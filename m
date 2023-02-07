Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DE668DD77
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 16:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbjBGP5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 10:57:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232475AbjBGP5S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 10:57:18 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504193D93D;
        Tue,  7 Feb 2023 07:57:01 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id d2so11775572pjd.5;
        Tue, 07 Feb 2023 07:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FpPbA9xF6oScMvGYfln/2x0CbG9qI6ccW9bRoyYMKlo=;
        b=FgRxsfcfNNSPl9UUDPrvsGQ/rioCqZMHpfN+fci/cOEObU+HScNFDqKB8NGpnEPw9K
         j4YGCNwnoxavJhV0Uy5sD7OHyx/1IfAgeeP4d0tNnWqXwlVAjNpLmNKwXdIHdDyad0wt
         gpBfSsn3yb+Er/jm614kGsoR1nIdmfvvmdnWhuRUIY9HXPAQZICHEWw1wFxpRFCk9oZl
         ckAHbVj45e0ENExbEijc+8LBpcm64h9lhosAu5GnYUNAIuPeyCB1RaGeZXXsEuPwofY0
         I+GdGeeTORcyDwfmPoOotUPjFSu1FwSr/0qrvUK6O7IkMDWkc5ruGxK24VosgTtSvoBj
         VNMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FpPbA9xF6oScMvGYfln/2x0CbG9qI6ccW9bRoyYMKlo=;
        b=nu9UUbIdxOXBLjmO624Bmh2tdjGpBHaiY3Nerb1/J7Vp8Noe8zakkY9MxdNTuXWlNc
         MkrHPXB0m0rcl6/nxUMppKpfAopmNkjve99I9Ipcvo+qUrEXFboL89j5Umm/XVG8f3mI
         qtAarp/rmE0d65+vWrB7vwVMOkeEMmrdpX4YJBWRiKYf4gJg2JZF6/It/lkxMnPpNLp0
         7oIpWQXBoqIImYoX7eOle//WqoAqksNPF7gFrOMkpZCFTgpLxf5wftUXEcilox7+TX/H
         zPCAxotz243cQSd+VdYPHyxGd6VPIby8Gw6DVj2/Ua6WW650AqjfMXikU61ao3nS+gR8
         9nlw==
X-Gm-Message-State: AO0yUKXckMlHGi1mbzmbtUMx7xzKNT8ETq1FOYvoWFinOkY/IDIArNXU
        BpL5SvJBDwFxVpU4sVFH7WVssXxSFkg=
X-Google-Smtp-Source: AK7set8SJWkiq4MaeBhB9HwD4mo0PT8egLGypFDUBbzvRFNxpmY6WEOO14XCeVQUYS93xk8BZSUOUw==
X-Received: by 2002:a17:902:ea09:b0:198:fd67:ba46 with SMTP id s9-20020a170902ea0900b00198fd67ba46mr3920789plg.1.1675785408129;
        Tue, 07 Feb 2023 07:56:48 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id jl13-20020a170903134d00b00198fde9178csm5942539plb.197.2023.02.07.07.56.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Feb 2023 07:56:47 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH V2 7/8] kvm: x86/mmu: Reduce the update to the spte in FNAME(sync_page)
Date:   Tue,  7 Feb 2023 23:57:33 +0800
Message-Id: <20230207155735.2845-8-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230207155735.2845-1-jiangshanlai@gmail.com>
References: <20230207155735.2845-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Sometimes when the guest updates its pagetable, it adds only new gptes
to it without changing any existed one, so there is no point to update
the sptes for these existed gptes.

Also when the sptes for these unchanged gptes are updated, the AD
bits are also removed since make_spte() is called with prefetch=true
which might result unneeded TLB flushing.

Do nothing if the gpte's permissions are unchanged.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 0031fe22af3d..fca5ce349d9d 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -967,6 +967,11 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int
 		drop_spte(vcpu->kvm, &sp->spt[i]);
 		return 1;
 	}
+	/*
+	 * Do nothing if the permissions are unchanged.
+	 */
+	if (kvm_mmu_page_get_access(sp, i) == pte_access)
+		return 0;
 
 	/* Update the shadowed access bits in case they changed. */
 	kvm_mmu_page_set_access(sp, i, pte_access);
-- 
2.19.1.6.gb485710b

