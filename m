Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82825616D02
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 19:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbiKBSrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 14:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbiKBSrH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 14:47:07 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C954F2FC36
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 11:47:06 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id t9-20020a5b03c9000000b006cff5077dc9so1884624ybp.3
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 11:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3fJGVLvuux7ZjXhWn/U9v5+1PBfr8qV0mPVrMinacoE=;
        b=tUUyu5SD3bD2emAIVs5TbHN4UbJlKx4cIjvc9WE6Dx7OleokmsFQE0dlBCTRBec/HB
         I1nHljLKNFf7UbeVg2g4tNLCxaU275XQKlUTZF7vveoUHMNZ24Zjj4wNuFIJf6TYbmOn
         qIn7ESBQK0x+sbXBpPRJ5+sAc1e7rEdY6x+XG1OnN4TNgHATusz01eicl6zNoE7lXExL
         kkAf1hbporckbz3+HcWThq/iFfWZ9GmMwPsjSuVMSlHogmY9WKB/HcCqJDa+IyyMbIMr
         Vf2TysbM7ssiiJ5h/NqzlHB6l/rH09+wBV0WobW/dgwRj3lnLBb4tRVraVh4Mz3uzqef
         fJUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3fJGVLvuux7ZjXhWn/U9v5+1PBfr8qV0mPVrMinacoE=;
        b=1bio9FHdYef4CfywTWrYpnQTSsR1oA2TTxJY4UP9m5w1rm+3HzYNXnoCH+U8o7WP3v
         /rZTLyvy1Ls+ttp9Zj/Rc8EsZyghLaIrbgVqwpFj1Q6DJPdg/Jb/YL/0520j5Pfb2KCL
         z2vOXJAMpDRZFRShQ7IppIk0tHn+427CJQt/OELRQSWLbofK8erMva25LdtERqThCDBg
         goJF+73ahOEjstyeQ3fCQvvuTRggpVMaDowcjynFZafi3FvyWy+9HAp7hXng6rMPJtWP
         ucjrrDyhWoLUo6RuQdhwkbPqPdtMzZwCLSLzjuA89ELMWburcTa5+XGvkRdCjzr3+LX7
         uq+g==
X-Gm-Message-State: ACrzQf3tBjTEGzcZzGFScJYyv9JNxQu6OjRo4CTO1n3htMJKwksyUnuM
        UdL2nDaVdfrBPyxAufvXSZDxTKg+mOk54g==
X-Google-Smtp-Source: AMsMyM4ALx73ySVgxvPN4T4NGOYv0Xh/sR4+BRuBQBMXmwmEMYFgZfYYrR3S692+nQLNSyBBaBTNU9huY+O5UQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:d0d1:0:b0:6cb:3ae4:7de2 with SMTP id
 h200-20020a25d0d1000000b006cb3ae47de2mr25494210ybg.505.1667414826096; Wed, 02
 Nov 2022 11:47:06 -0700 (PDT)
Date:   Wed,  2 Nov 2022 11:46:49 -0700
In-Reply-To: <20221102184654.282799-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221102184654.282799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221102184654.282799-6-dmatlack@google.com>
Subject: [PATCH v4 05/10] KVM: x86/mmu: Use BIT{,_ULL}() for PFERR masks
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vipin Sharma <vipinsh@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,USER_IN_DEF_DKIM_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the preferred BIT() and BIT_ULL() to construct the PFERR masks
rather than open-coding the bit shifting.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 415113dea951..716f165cfa10 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -256,16 +256,16 @@ enum x86_intercept_stage;
 #define PFERR_GUEST_PAGE_BIT 33
 #define PFERR_IMPLICIT_ACCESS_BIT 48
 
-#define PFERR_PRESENT_MASK (1U << PFERR_PRESENT_BIT)
-#define PFERR_WRITE_MASK (1U << PFERR_WRITE_BIT)
-#define PFERR_USER_MASK (1U << PFERR_USER_BIT)
-#define PFERR_RSVD_MASK (1U << PFERR_RSVD_BIT)
-#define PFERR_FETCH_MASK (1U << PFERR_FETCH_BIT)
-#define PFERR_PK_MASK (1U << PFERR_PK_BIT)
-#define PFERR_SGX_MASK (1U << PFERR_SGX_BIT)
-#define PFERR_GUEST_FINAL_MASK (1ULL << PFERR_GUEST_FINAL_BIT)
-#define PFERR_GUEST_PAGE_MASK (1ULL << PFERR_GUEST_PAGE_BIT)
-#define PFERR_IMPLICIT_ACCESS (1ULL << PFERR_IMPLICIT_ACCESS_BIT)
+#define PFERR_PRESENT_MASK	BIT(PFERR_PRESENT_BIT)
+#define PFERR_WRITE_MASK	BIT(PFERR_WRITE_BIT)
+#define PFERR_USER_MASK		BIT(PFERR_USER_BIT)
+#define PFERR_RSVD_MASK		BIT(PFERR_RSVD_BIT)
+#define PFERR_FETCH_MASK	BIT(PFERR_FETCH_BIT)
+#define PFERR_PK_MASK		BIT(PFERR_PK_BIT)
+#define PFERR_SGX_MASK		BIT(PFERR_SGX_BIT)
+#define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
+#define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
+#define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)
 
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
 				 PFERR_WRITE_MASK |		\
-- 
2.38.1.273.g43a17bfeac-goog

