Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64065BB4D8
	for <lists+kvm@lfdr.de>; Sat, 17 Sep 2022 02:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiIQAB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 20:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiIQAB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 20:01:57 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12953B2DA6
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 17:01:56 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id p1-20020a17090a2d8100b0020040a3f75eso1017504pjd.4
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 17:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=OqAS65UuymxWcN26V6JOOaj7O9UfhSwxU0z1jgvRQ4U=;
        b=mj4srjh+ScylIrq7HNMxwNLBp6b951a4mMxjKJcMxvZ3F+QU4ReAK4LJVZC6f42mu9
         UvwHvd4fYWCDctTtlnWFPKdjWETsZTauUeV7L+Lay3G6Rbz6TapRBV8PYcOdS7wdQWAP
         otEjD2zSQNQoLj5J5Oumsr11tV4y8zAPKkl88Su4sGX1eBPvmXpCYUJtqQffzgnptEod
         fbdpdh+hLJuQg1Tg+jbLt1JpQb3l3SHATuDN2G/aCHxGc3i3vRdMm/s7kb0Av8Y9J0iU
         k5E8dcl4DtMzhlgDwxe2yoPS/I21ikZwNMVCP5Ry4aKiELRHcJDi/5UVkmLlMcTFOm/0
         yLAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=OqAS65UuymxWcN26V6JOOaj7O9UfhSwxU0z1jgvRQ4U=;
        b=bihkzBRNSQPO79/bH2sHRJCYqvOdHBDe04+RybN0b65QAEkqJm+7tRZb7qOwkl8fLd
         0+tAMDuUhV9Z5K84tHgsI/0E7MacoNopbv6mJTSrZ8qsB7HqP5slytQ7JAuEqpZCvx9W
         PhuFkUtEo2EkqdCoIkC1FsSq5+GfJLgl0URaWox43YkGLF/srVo/X5CWYJs8rHuLdtdo
         cl6PeWmMHq26MP0l8cJY+QXLW90x96qvqikSzgC0YFohuzdYJfjqAavs14Cj/fevNNW5
         TQQeAtXvIHB8JuwDshq7rGvifR/uKnSmUiCYKIK3Z+Bhooo8J85BQ4pCxoNFc8/N+rQI
         KJig==
X-Gm-Message-State: ACrzQf3cZOCj3UQIVLV+W6jVovYn+dW5z31GbnS8FjB4M4bWNHOkbBl3
        HviswbrOpnOxWJ2Wfg42BL+0tQ==
X-Google-Smtp-Source: AMsMyM7OF9N3C4EOx+SH4T8Jnpoi/RSe94jW7k7D41RsLFmamCPCcfRgQR7wweu/S8A6Je2MdHz/rQ==
X-Received: by 2002:a17:902:7e83:b0:177:e667:7841 with SMTP id z3-20020a1709027e8300b00177e6677841mr2215829pla.18.1663372915349;
        Fri, 16 Sep 2022 17:01:55 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h6-20020a170902680600b0016d8d277c02sm6351913plk.25.2022.09.16.17.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 17:01:54 -0700 (PDT)
Date:   Sat, 17 Sep 2022 00:01:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, jon.grimm@amd.com,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH] KVM: x86: Un-inhibit APICv/AVIC when switching to x2APIC
 mode
Message-ID: <YyUOb5X8yO4BbYSf@google.com>
References: <20220909195442.7660-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909195442.7660-1-suravee.suthikulpanit@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 09, 2022, Suravee Suthikulpanit wrote:
> Currently, kvm_lapic_xapic_id_updated() checks if the xAPIC ID in
> the APIC_ID register differs from the vcpu ID. If so it inhibits
> APICv/AVIC.
> 
> However, for vcpu 256 and above, the 8-bit xAPIC ID field in the APIC_ID
> register cannot support 32-bit x2APIC ID causing the kvm_xapic_id()
> to return invalid ID and fail the comparison with the vcpu ID.
> This causes APICv/AVIC inhibition for VM with more than 256 vcpus
> due to APIVC_INHIBIT_REASON_APIC_ID_MODIFIED.
> 
> In this case, when guest switch to x2APIC mode, KVM needs to clear
> APIVC_INHIBIT_REASON_APIC_ID_MODIFIED.
> 
> Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/lapic.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 9dda989a1cf0..750d385b770e 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -374,6 +374,7 @@ static inline void kvm_apic_set_x2apic_id(struct kvm_lapic *apic, u32 id)
>  	kvm_lapic_set_reg(apic, APIC_ID, id);
>  	kvm_lapic_set_reg(apic, APIC_LDR, ldr);
>  	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
> +	kvm_clear_apicv_inhibit(apic->vcpu->kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);

This isn't safe as it assumes the guest will switch _all_ vCPUs to x2APIC, e.g.
if one vCPU switches to x2APIC before the others then weird things will happen.
Part of me just wants to throw in the towel, but I think we have an easy out.

The other funky thing to consider is KVM's x2APIC hotplug hack, where KVM
deliberately (and architecturally incorrectly) does not honor the aliasing behavior
that results when an x2APIC ID gets truncated to an xAPIC ID.  When the hack is
effectively enabled, KVM can actually ignore truncation because the resulting KVM
behavior of IPIs only getting sent to the "first" vCPU is the same as APICv/AVIC
behavior.  On the plus side, the existence of that godawful hack means it's extremely
unlikely the aliasing will break anything that anyones cares about.

To restore APICv support for stable kernels on systems with >255 CPUs, which people
do care about, it probably makes sense to split the fix into two patches.  An
incomplete patch to ignore the truncation case that is easy to backport, and then
a fix for the fix to inhibit APICv/AVIC when there is unwanted aliasing (piggybacking
off my patch "KVM: x86: Honor architectural behavior for aliased 8-bit APIC IDs").
We can even get clever and fixup the Fixes: tag when doing the final application
so that there's a paper trail if someone wants to backport the full fix.

Compile tested only at this point and lacks changelogs, but my thought is to do:

From: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 Sep 2022 16:48:03 -0700
Subject: [PATCH] KVM: x86: Don't inhibit APICv/AVIC if xAPIC ID mismatch is
 due to 32-bit ID

Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index adac6ca9b7dc..a02defa3f7b5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2075,7 +2075,12 @@ static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
 	if (KVM_BUG_ON(apic_x2apic_mode(apic), kvm))
 		return;
 
-	if (kvm_xapic_id(apic) == apic->vcpu->vcpu_id)
+	/*
+	 * Deliberately truncate the vCPU ID when detecting a modified APIC ID
+	 * to avoid false positives if the vCPU ID, i.e. x2APIC ID, is a 32-bit
+	 * value.
+	 */
+	if (kvm_xapic_id(apic) == (u8)apic->vcpu->vcpu_id)
 		return;
 
 	kvm_set_apicv_inhibit(apic->vcpu->kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);

base-commit: 59afc619c353e67d087dc741bd828019985ffac6
-- 

followed up by this later in the series:

From: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 Sep 2022 16:54:14 -0700
Subject: [PATCH] KVM: x86: Inhibit APICv/AVIC if the optimized physical map is
 disabled

Fixes: TDB
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/lapic.c            | 13 ++++++++++++-
 arch/x86/kvm/svm/avic.c         |  1 +
 arch/x86/kvm/vmx/vmx.c          |  1 +
 4 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 13dadc96d9ac..6953d1a61357 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1097,6 +1097,12 @@ enum kvm_apicv_inhibit {
 	 */
 	APICV_INHIBIT_REASON_BLOCKIRQ,
 
+	/*
+	 * APICv is disabled because not all vCPUs have a 1:1 mapping between
+	 * APIC ID and vCPU, _and_ KVM is not applying its x2APIC hotplug hack.
+	 */
+	APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED,
+
 	/*
 	 * For simplicity, the APIC acceleration is inhibited
 	 * first time either APIC ID or APIC base are changed by the guest
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 00c89ff740e5..e9ba17aa0710 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -381,6 +381,16 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 		cluster[ldr] = apic;
 	}
 out:
+	/*
+	 * The optimized map is effectively KVM's internal version of APICv,
+	 * and all unwanted aliasing that results in disabling the optimized
+	 * map also applies to APICv.
+	 */
+	if (!new)
+		kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED);
+	else
+		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED);
+
 	old = rcu_dereference_protected(kvm->arch.apic_map,
 			lockdep_is_held(&kvm->arch.apic_map_lock));
 	rcu_assign_pointer(kvm->arch.apic_map, new);
@@ -2150,7 +2160,8 @@ static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
 	/*
 	 * Deliberately truncate the vCPU ID when detecting a modified APIC ID
 	 * to avoid false positives if the vCPU ID, i.e. x2APIC ID, is a 32-bit
-	 * value.
+	 * value.  If the wrap/truncation results in unwatned aliasing, APICv
+	 * will be inhibited as part of updating KVM's optimized APIC maps.
 	 */
 	if (kvm_xapic_id(apic) == (u8)apic->vcpu->vcpu_id)
 		return;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 3400046ad0b4..a1eb4e9ed3eb 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -992,6 +992,7 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
 			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
 			  BIT(APICV_INHIBIT_REASON_SEV)      |
+			  BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |
 			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
 			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |
 			  BIT(APICV_INHIBIT_REASON_X2APIC);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c9b49a09e6b5..414485d03ee7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7996,6 +7996,7 @@ static bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 			  BIT(APICV_INHIBIT_REASON_ABSENT) |
 			  BIT(APICV_INHIBIT_REASON_HYPERV) |
 			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
+			  BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |
 			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
 			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
 

base-commit: c8ecd2ebbc283d377188ee6c94cf3f811a4ff501
-- 
