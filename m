Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784797B2A3E
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 04:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjI2CG6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 22:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjI2CG5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 22:06:57 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D2C199
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 19:06:54 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d817775453dso19883267276.2
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 19:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695953214; x=1696558014; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UW0Dtv/KujpaOnqWiMzyb6swMLyUdZ8OkZzAylCLanI=;
        b=EDaNVC+3rapcwQf8jLTtAk2Vs8tzyonAk4RHk0SN+afUgJchue4IvkPeSaRmBem7Hg
         Y7+y3YQVqAR3agoUoK92qj5k5tdOxCxV0bEFlDEtsQXtO08mekuuvvH0ikx6uHF+wHzZ
         U+bue+WHN/tzPjbnk8a9TDYDBxojUztnZLBoCaqf1vg3eJdW+NNqrWlBsRCjmwbS+yDf
         cBKWHuZvJgvvo+lXBaN7QHj/acYNG3FR4dLwVVoRF3R0Eus03psp15dH5+uHAnUz0xWx
         0wr4fKSj0RA/epJLunBedBb/8lEMeOsgwnZxgD3jWhAy+n5udDy479au7OhxzhfS5eV0
         soPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695953214; x=1696558014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UW0Dtv/KujpaOnqWiMzyb6swMLyUdZ8OkZzAylCLanI=;
        b=MepBja7Azmi3unHwDq9s0WsRqOZovrWvjqHZG/TybA/12Prrjcn5c17lZda556ruuT
         hwIbHyEuLeViQVTSR5BymjnbYZAV4R/qt9PxWa9vLI65mh172cfSTq+Od330l4S4OoWD
         QOvPzDxEWmt/Olrtha17jggmJvUbOIe/bQ6Sy8sPmQmaL2hL3K0bXU+73xv+6Whwmo2R
         hRuYj4NO9X/nLDJOFE5Qg3lXQgCQYVyL4PxV66Dv8Sf+XR/9afycxvVfnqHuVLQEQqsh
         5Ny4ED0VUYpcwFdU6LgQClsLNqK6a6Njuz+MXbRHB45q+EnJQ3upKTddCi5uVnXPswKb
         oL7g==
X-Gm-Message-State: AOJu0YxfPPCtPpuTTq5vSuxk/zdFCdBqJjEhocQmBMoLh/yL9yWDzYIp
        5H/J2u9LLQNZe1ELK4Hh3sBwIlu2/gc=
X-Google-Smtp-Source: AGHT+IFl9RIZrKlba27gL6pMdIc+x3vCcNzUyo88NqB7rbfbfTZAaTTweokWP1YforFZCvRwoJLoRbEaMgE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ce42:0:b0:d84:e73f:6f8c with SMTP id
 x63-20020a25ce42000000b00d84e73f6f8cmr38495ybe.6.1695953213803; Thu, 28 Sep
 2023 19:06:53 -0700 (PDT)
Date:   Thu, 28 Sep 2023 19:06:52 -0700
In-Reply-To: <20230928173354.217464-5-mlevitsk@redhat.com>
Mime-Version: 1.0
References: <20230928173354.217464-1-mlevitsk@redhat.com> <20230928173354.217464-5-mlevitsk@redhat.com>
Message-ID: <ZRYxPNeq1rnp-M0f@google.com>
Subject: Re: [PATCH v2 4/4] x86: KVM: SVM: workaround for AVIC's errata #1235
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, iommu@lists.linux.dev,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Will Deacon <will@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>
Content-Type: multipart/mixed; charset="UTF-8"; boundary="3xcBp5v4/HRyz7Jb"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--3xcBp5v4/HRyz7Jb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 28, 2023, Maxim Levitsky wrote:
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 4b74ea91f4e6bb6..28bb0e6b321660d 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -62,6 +62,9 @@ static_assert(__AVIC_GATAG(AVIC_VM_ID_MASK, AVIC_VCPU_ID_MASK) == -1u);
>  static bool force_avic;
>  module_param_unsafe(force_avic, bool, 0444);
>  
> +static int avic_zen2_errata_workaround = -1;
> +module_param(avic_zen2_errata_workaround, int, 0444);
> +
>  /* Note:
>   * This hash table is used to map VM_ID to a struct kvm_svm,
>   * when handling AMD IOMMU GALOG notification to schedule in
> @@ -276,7 +279,7 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
>  
>  static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>  {
> -	u64 *entry, new_entry;
> +	u64 *entry;
>  	int id = vcpu->vcpu_id;
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> @@ -308,10 +311,10 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>  	if (!entry)
>  		return -EINVAL;
>  
> -	new_entry = __sme_set((page_to_phys(svm->avic_backing_page) &
> -			      AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK) |
> -			      AVIC_PHYSICAL_ID_ENTRY_VALID_MASK);
> -	WRITE_ONCE(*entry, new_entry);
> +	svm->avic_physical_id_entry = __sme_set((page_to_phys(svm->avic_backing_page) &
> +						 AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK) |
> +						 AVIC_PHYSICAL_ID_ENTRY_VALID_MASK);
> +	WRITE_ONCE(*entry, svm->avic_physical_id_entry);

Aha!  Rather than deal with the dummy entry at runtime, simply point the pointer
at the dummy entry during setup.

And instead of adding a dedicated erratum param, let's piggyback VMX's enable_ipiv.
It's not a true disable, but IMO it's close enough.  That will make the param
much more self-documenting, and won't feel so awkward if someone wants to disable
IPI virtualization for other reasons.

Then we can do this in three steps:

  1. Move enable_ipiv to common code
  2. Let userspace disable enable_ipiv for SVM+AVIC
  3. Disable enable_ipiv for affected CPUs

The biggest downside to using enable_ipiv is that a the "auto" behavior for the
erratum will be a bit ugly, but that's a solvable problem.

If you've no objection to the above approach, I'll post the attached patches along
with a massaged version of this patch.

The attached patches apply on top of an AVIC clean[*], which (shameless plug)
could use a review ;-)

[*] https://lore.kernel.org/all/20230815213533.548732-1-seanjc@google.com

--3xcBp5v4/HRyz7Jb
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-VMX-Move-enable_ipiv-knob-to-common-x86.patch"

From 4990d0e56b1e9bb8bf97502d525779b2a43d26d4 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 28 Sep 2023 17:22:52 -0700
Subject: [PATCH 1/2] KVM: VMX: Move enable_ipiv knob to common x86

Move enable_ipiv to common x86 so that it can be reused by SVM to control
IPI virtualization when AVIC is enabled.  SVM doesn't actually provide a
way to truly disable IPI virtualization, but KVM can get close enough by
skipping the necessary table programming.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/vmx/capabilities.h | 1 -
 arch/x86/kvm/vmx/vmx.c          | 2 --
 arch/x86/kvm/x86.c              | 3 +++
 4 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e9e69009789e..7239155213c7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1806,6 +1806,7 @@ extern u32 __read_mostly kvm_nr_uret_msrs;
 extern u64 __read_mostly host_efer;
 extern bool __read_mostly allow_smaller_maxphyaddr;
 extern bool __read_mostly enable_apicv;
+extern bool __read_mostly enable_ipiv;
 extern struct kvm_x86_ops kvm_x86_ops;
 
 #define KVM_X86_OP(func) \
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 41a4533f9989..8cbfef64ea75 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -15,7 +15,6 @@ extern bool __read_mostly enable_ept;
 extern bool __read_mostly enable_unrestricted_guest;
 extern bool __read_mostly enable_ept_ad_bits;
 extern bool __read_mostly enable_pml;
-extern bool __read_mostly enable_ipiv;
 extern int __read_mostly pt_mode;
 
 #define PT_MODE_SYSTEM		0
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 72e3943f3693..f51dac6b21ae 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -104,8 +104,6 @@ static bool __read_mostly fasteoi = 1;
 module_param(fasteoi, bool, S_IRUGO);
 
 module_param(enable_apicv, bool, S_IRUGO);
-
-bool __read_mostly enable_ipiv = true;
 module_param(enable_ipiv, bool, 0444);
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6573c89c35a9..ccf5aa4fbe73 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -235,6 +235,9 @@ EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
 bool __read_mostly enable_apicv = true;
 EXPORT_SYMBOL_GPL(enable_apicv);
 
+bool __read_mostly enable_ipiv = true;
+EXPORT_SYMBOL_GPL(enable_ipiv);
+
 u64 __read_mostly host_xss;
 EXPORT_SYMBOL_GPL(host_xss);
 

base-commit: ca3beed3b49348748201a2a35888b49858ce5d73
-- 
2.42.0.582.g8ccd20d70d-goog


--3xcBp5v4/HRyz7Jb
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-KVM-SVM-Add-enable_ipiv-param-skip-physical-ID-progr.patch"

From fb86a56d11eac07626ffd9defeff39b88dbf6406 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 28 Sep 2023 17:25:48 -0700
Subject: [PATCH 2/2] KVM: SVM: Add enable_ipiv param, skip physical ID
 programming if disabled

Let userspace "disable" IPI virtualization via an enable_ipiv module param
by programming a dummy entry instead of the vCPU's actual backing entry in
the physical ID table.  SVM doesn't provide a way to actually disable IPI
virtualization in hardware, but by leaving all entries blank, every IPI in
the guest (except for self-IPIs) will generate a VM-Exit.

Providing a way to effectively disable IPI virtualization will allow KVM
to safely enable AVIC on hardware that is suseptible to erratum #1235,
which causes hardware to sometimes fail to detect that the IsRunning bit
has been cleared by software.

All credit goes to Maxim for the idea!

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 15 ++++++++++++++-
 arch/x86/kvm/svm/svm.c  |  3 +++
 arch/x86/kvm/svm/svm.h  |  1 +
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index fa87b6853f1d..fc804bb84394 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -310,7 +310,20 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 		    AVIC_PHYSICAL_ID_ENTRY_VALID_MASK;
 	WRITE_ONCE(table[id], new_entry);
 
-	svm->avic_physical_id_entry = &table[id];
+	/*
+	 * IPI virtualization is bundled with AVIC, but effectively can be
+	 * disabled simply by never marking vCPUs as running in the physical ID
+	 * table.  Use a dummy entry to avoid conditionals in the runtime code,
+	 * and to keep the IOMMU coordination logic as simple as possible.  The
+	 * entry in the table also needs to be valid (see above), otherwise KVM
+	 * will ignore IPIs due to thinking the target doesn't exist.
+	 */
+	if (enable_ipiv) {
+		svm->avic_physical_id_entry = &table[id];
+	} else {
+		svm->ipiv_disabled_backing_entry = table[id];
+		svm->avic_physical_id_entry = &svm->ipiv_disabled_backing_entry;
+	}
 
 	return 0;
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index acdd0b89e471..bc40ffb5c47c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -227,6 +227,8 @@ module_param(tsc_scaling, int, 0444);
 static bool avic;
 module_param(avic, bool, 0444);
 
+module_param(enable_ipiv, bool, 0444);
+
 bool __read_mostly dump_invalid_vmcb;
 module_param(dump_invalid_vmcb, bool, 0644);
 
@@ -5252,6 +5254,7 @@ static __init int svm_hardware_setup(void)
 	enable_apicv = avic = avic && avic_hardware_setup();
 
 	if (!enable_apicv) {
+		enable_ipiv = false;
 		svm_x86_ops.vcpu_blocking = NULL;
 		svm_x86_ops.vcpu_unblocking = NULL;
 		svm_x86_ops.vcpu_get_apicv_inhibit_reasons = NULL;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 147516617f88..7a1fc9325d74 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -264,6 +264,7 @@ struct vcpu_svm {
 
 	u32 ldr_reg;
 	u32 dfr_reg;
+	u64 ipiv_disabled_backing_entry;
 	u64 *avic_physical_id_entry;
 
 	/*
-- 
2.42.0.582.g8ccd20d70d-goog


--3xcBp5v4/HRyz7Jb--
