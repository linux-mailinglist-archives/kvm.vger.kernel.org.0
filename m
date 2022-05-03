Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543505187E0
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 17:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237819AbiECPKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 11:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237811AbiECPKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 11:10:38 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0903A5CA;
        Tue,  3 May 2022 08:07:05 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id r9so15558241pjo.5;
        Tue, 03 May 2022 08:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kpUXLHmfMO9TwZfWJqVY4XQuTZrvTupEDHXTCZCy2JY=;
        b=HoXU6gI8QHQ1RysZ3jac2pj95Mt97LCnMGHEQS+r7qZvbLnWXXLqkTDTftKEdLGIOj
         0bQR/jUQ2C+CoD8E/X3gaKEpuO6k8PLtjedukszecQhN8D/FNRLdoTZXtJ8IjkTTugQI
         xoLB9LoRIJYwGLbP+tC0MvlefiAuzHb15+2S/Wn3yO4jkPVtRBowQ0nvr9/V11a56uwb
         9om60dgJ5Z9czP1+msCObQwv4gXpmFMBOcm6zRsyESefa7N0p0sLay5lHbhYzulxMoKa
         ib0kxtpLYZyQ6afIheefLMZNPGUEJaUwsEmwZ2VejQ6pALcCL0l2cHpt1veeX5E8Rlbd
         8Zzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kpUXLHmfMO9TwZfWJqVY4XQuTZrvTupEDHXTCZCy2JY=;
        b=vm2Wj3ifIIZvYwXR2KbZf1XRnfQmc1gXmcdbXgOVNYNHyUqdW6PotzBVqtSwJPC4n7
         TWJAKho576frwCu000iQDShdIirWMR4AMdXLMFmahfAxFjzrgnUFSdIRQFVL5aWftbBH
         uAPtX/SBiN7vwWhjR/3wFFqhC9V91N/0UECAhgoGCtsxrvdCjnYY1e3rMyQItlPGdB5Q
         hrk2ixJlPuGDK9OUGAwuDg9IqHNe6pSAhBiB4XfKotkX2b1gNDijtLIDuJgRy96sRkVd
         0sGAriUdwSPaq+jjk7Jx8a0YWwcKMIjCm78lzwChU51wpuRzyOP6wrYx/H8XdGg3fVtS
         q80g==
X-Gm-Message-State: AOAM530HqwuQ/HC9sMBGcJ7m5nmqcRozrGq11eANWB0bDqvPcuPlgwZj
        NWd0ITe2hZ3aDsImdi3D99OTbKHKJ1s=
X-Google-Smtp-Source: ABdhPJyXKA/B5fXITt2ZWIUZno4Y48G54EV1OaTHaH1l4nvmt5c/mF7sCUaPHb2J8DdbevRDT0TOrQ==
X-Received: by 2002:a17:90b:3d0:b0:1d9:52e1:de86 with SMTP id go16-20020a17090b03d000b001d952e1de86mr5064916pjb.73.1651590424705;
        Tue, 03 May 2022 08:07:04 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id v8-20020a170902e8c800b0015e8d4eb2dfsm6421548plg.297.2022.05.03.08.07.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 May 2022 08:07:04 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH V2 1/7] KVM: X86/MMU: Add using_special_root_page()
Date:   Tue,  3 May 2022 23:07:29 +0800
Message-Id: <20220503150735.32723-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220503150735.32723-1-jiangshanlai@gmail.com>
References: <20220503150735.32723-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

In some case, special roots are used in mmu.  It is often using
to_shadow_page(mmu->root.hpa) to check if special roots are used.

Add using_special_root_page() to directly check if special roots are
used or needed to be used even mmu->root.hpa is not set.

Prepare for making to_shadow_page(mmu->root.hpa) return non-NULL via
using special shadow pages.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 909372762363..7f20796af351 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1711,6 +1711,14 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
+static bool using_special_root_page(struct kvm_mmu *mmu)
+{
+	if (mmu->root_role.direct)
+		return mmu->root_role.level == PT32E_ROOT_LEVEL;
+	else
+		return mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL;
+}
+
 static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
 {
 	struct kvm_mmu_page *sp;
@@ -4241,10 +4249,10 @@ static bool fast_pgd_switch(struct kvm *kvm, struct kvm_mmu *mmu,
 {
 	/*
 	 * For now, limit the caching to 64-bit hosts+VMs in order to avoid
-	 * having to deal with PDPTEs. We may add support for 32-bit hosts/VMs
-	 * later if necessary.
+	 * having to deal with PDPTEs.  Special roots can not be put into
+	 * mmu->prev_roots[].
 	 */
-	if (VALID_PAGE(mmu->root.hpa) && !to_shadow_page(mmu->root.hpa))
+	if (VALID_PAGE(mmu->root.hpa) && using_special_root_page(mmu))
 		kvm_mmu_free_roots(kvm, mmu, KVM_MMU_ROOT_CURRENT);
 
 	if (VALID_PAGE(mmu->root.hpa))
-- 
2.19.1.6.gb485710b

