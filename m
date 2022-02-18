Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62DAC4BB055
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 04:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiBRDoP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 22:44:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiBRDoN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 22:44:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA42023D3CB
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 19:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645155836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TAqwbcuC1K/GCPIxOA4YjwPr067i6z5v+vekWEsSG9o=;
        b=PYUy6sOlQn7E4hKFIh1Cz1tJnIQA869aUmNKnK07rHa6YhIP35F6+OS9W4a7oQWI4RQ/Vl
        Hdm0kzFlRBB07soh1wd/RPBLYKipw9C0PVlkDdlkzALZSaIqxPeWmuRqkACE1Dsh/5wq3G
        Ew5MmV4VaDE5wjuId6As3bwmzhTvXrI=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-207-kj8-TTJPNFKaIOpqk2KpdQ-1; Thu, 17 Feb 2022 22:43:54 -0500
X-MC-Unique: kj8-TTJPNFKaIOpqk2KpdQ-1
Received: by mail-ot1-f71.google.com with SMTP id w16-20020a056830111000b005a3e1a958ccso913161otq.11
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 19:43:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TAqwbcuC1K/GCPIxOA4YjwPr067i6z5v+vekWEsSG9o=;
        b=lt5Xew4KESl4E32v4G96ffA9ZDjKZBnRKxs9hiT79hDAXpP9/sUIaNMV2BWyMufD5o
         SvTF290OSY6c3HlPMTJAd9FcV7HXSQO8NB8E3VpKw0yBG0YkcKulbH2hWCqjcFvKR+Jt
         LwuXfYgKrV7jhIx/cXeQwhuAnifyz+N36z5Ti/InSFJgZUi0D0I2VfBepB1JgC9DTUQH
         dSVerdsV3N85pgjWmpQOvif50H9h+yt6TW9ILQFn9nugJRZbyBEFKo6Uz2AcBqvzhQCH
         +9cmF/8H5uzKqb3XgOTIu1NYwenjNDQY5PhIrXkbfQjoDIG1PXzUKZd5STTbLhIjrxPg
         aAeg==
X-Gm-Message-State: AOAM530aAEUQ2aIudIl3snAFU5MWBCV+lfaIwXxLJkgEefs9m1I12np8
        8a0kZGQZpVE72+5o3BT63Sj4fprVeABKTvr3KoXNeCM7czNsxX/Mm2Ayyu4IP9vrcs7fN6CedQJ
        hdElo+bzf0LqR
X-Received: by 2002:a05:6808:3099:b0:2d4:72ca:f45e with SMTP id bl25-20020a056808309900b002d472caf45emr2555607oib.15.1645155834001;
        Thu, 17 Feb 2022 19:43:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw8bZlDWt8IZI29DXtSzbFzvGBwpDW+1FuCuZLOAXwmZbxeB7aCqMJnaTH2gLaKvTvpWZNNwA==
X-Received: by 2002:a05:6808:3099:b0:2d4:72ca:f45e with SMTP id bl25-20020a056808309900b002d472caf45emr2555594oib.15.1645155833808;
        Thu, 17 Feb 2022 19:43:53 -0800 (PST)
Received: from localhost.localdomain ([2804:431:c7f1:c12c:38a3:24a6:f679:3afd])
        by smtp.gmail.com with ESMTPSA id n18sm914422otr.48.2022.02.17.19.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 19:43:53 -0800 (PST)
From:   Leonardo Bras <leobras@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     Leonardo Bras <leobras@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] x86/kvm/fpu: Remove kvm_vcpu_arch.guest_supported_xcr0
Date:   Fri, 18 Feb 2022 00:43:45 -0300
Message-Id: <20220218034345.115855-1-leobras@redhat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_vcpu_arch currently contains the guest supported features in both
guest_supported_xcr0 and guest_fpu.fpstate->user_xfeatures field.

Currently both fields are set to the same value in
kvm_vcpu_after_set_cpuid() and are not changed anywhere else after that.

Since it's not good to keep duplicated data, remove guest_supported_xcr0.

To keep the code more readable, introduce kvm_guest_supported_xcr()
and kvm_guest_supported_xfd() to replace the previous usages of
guest_supported_xcr0.

Signed-off-by: Leonardo Bras <leobras@redhat.com>
Message-Id: <20220217053028.96432-3-leobras@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
This patch includes a fix from a bug found by "kernel test robot",
regarding compilation of non-x86_64 builds.

 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/cpuid.c            |  5 +++--
 arch/x86/kvm/x86.c              | 20 +++++++++++++++-----
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6dcccb304775..ec9830d2aabf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -703,7 +703,6 @@ struct kvm_vcpu_arch {
 	struct fpu_guest guest_fpu;
 
 	u64 xcr0;
-	u64 guest_supported_xcr0;
 
 	struct kvm_pio_request pio;
 	void *pio_data;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 71125291c578..b8f8d268d058 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -282,6 +282,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	struct kvm_cpuid_entry2 *best;
+	u64 guest_supported_xcr0;
 
 	best = kvm_find_cpuid_entry(vcpu, 1, 0);
 	if (best && apic) {
@@ -293,10 +294,10 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		kvm_apic_set_version(vcpu);
 	}
 
-	vcpu->arch.guest_supported_xcr0 =
+	guest_supported_xcr0 =
 		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
 
-	vcpu->arch.guest_fpu.fpstate->user_xfeatures = vcpu->arch.guest_supported_xcr0;
+	vcpu->arch.guest_fpu.fpstate->user_xfeatures = guest_supported_xcr0;
 
 	kvm_update_pv_runtime(vcpu);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 641044db415d..ca0fae020961 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -984,6 +984,18 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_load_host_xsave_state);
 
+static inline u64 kvm_guest_supported_xcr0(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.guest_fpu.fpstate->user_xfeatures;
+}
+
+#ifdef CONFIG_X86_64
+static inline u64 kvm_guest_supported_xfd(struct kvm_vcpu *vcpu)
+{
+	return kvm_guest_supported_xcr0(vcpu) & XFEATURE_MASK_USER_DYNAMIC;
+}
+#endif
+
 static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 {
 	u64 xcr0 = xcr;
@@ -1003,7 +1015,7 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 	 * saving.  However, xcr0 bit 0 is always set, even if the
 	 * emulated CPU does not support XSAVE (see kvm_vcpu_reset()).
 	 */
-	valid_bits = vcpu->arch.guest_supported_xcr0 | XFEATURE_MASK_FP;
+	valid_bits = kvm_guest_supported_xcr0(vcpu) | XFEATURE_MASK_FP;
 	if (xcr0 & ~valid_bits)
 		return 1;
 
@@ -3706,8 +3718,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !guest_cpuid_has(vcpu, X86_FEATURE_XFD))
 			return 1;
 
-		if (data & ~(XFEATURE_MASK_USER_DYNAMIC &
-			     vcpu->arch.guest_supported_xcr0))
+		if (data & ~kvm_guest_supported_xfd(vcpu))
 			return 1;
 
 		fpu_update_guest_xfd(&vcpu->arch.guest_fpu, data);
@@ -3717,8 +3728,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !guest_cpuid_has(vcpu, X86_FEATURE_XFD))
 			return 1;
 
-		if (data & ~(XFEATURE_MASK_USER_DYNAMIC &
-			     vcpu->arch.guest_supported_xcr0))
+		if (data & ~kvm_guest_supported_xfd(vcpu))
 			return 1;
 
 		vcpu->arch.guest_fpu.xfd_err = data;
-- 
2.35.1

