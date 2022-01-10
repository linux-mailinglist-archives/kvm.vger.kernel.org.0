Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFEC48A13D
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 21:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343725AbiAJU4V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 15:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343704AbiAJU4R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 15:56:17 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBC2C06173F
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 12:56:16 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id 59-20020a17090a09c100b001b34a13745eso728742pjo.5
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 12:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DSBL73diG3nJJJKmUuDFKV7a62ax2dpKOBHt0+DgKYE=;
        b=AWioNWY29OtZcO9pgL+kJ+0OmQe6ZNGKCrr/AjpmTFYknhk0HOJ4HQSzpJFtRI5GXD
         GRdMaZEsoSOHxF7Q9Gi4dEW05UHcEPcuDN/va3cMiFZVGgOdnqjcpvzrDfYXxDJrbtL+
         8WytxWG+JMFUcibQWTyCxOyJHJ6J1P4vyoyQAI2mJ5bihjmzSZY5GXy1FrkruHm4WHPr
         A+qzEA8UrIfqqJcpQFl/yKnFOO6aQFIo1P5TfYKADi40I8287RXaA6iwFnBt9DtDk4am
         JDJRyqVEbCxjOCKYJRpZRZfOV+TUiqCILJkHNWMxbVB2NrzOPsmcFKv5jsvcfcMBRG4n
         b8hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DSBL73diG3nJJJKmUuDFKV7a62ax2dpKOBHt0+DgKYE=;
        b=6rC5kuR1gOUpPMQNwghlycKHdo8sR7wzgSIna9tbDXVabRTB6eR2/+VwL4/PIKBbjw
         ccxFHoUSM3lCQe/vFieyWzwBNL9iwDV5ymSnJTKoGIjPldS4bv6yzEHg/p7DgOZ9AVTI
         9tgyBirHx6LV5hgQMYkPlQTOX3XazJk0JhWKC5GX1U3B3fnaku3GYOuQcZMr2ac7bqcT
         PizdqjKXnjGQdlAcm1qJtlnIrZxvgPGk4LnVYDBsrjzpew2crhf90h/u5PL4kIMNCPch
         5b/kRSJTwI2+l9J+RvUrUoZ5BUQpAWbCREzmtq/tZ/DUwvUP/1TM4VmHIq5PSNKlJe5k
         XoOA==
X-Gm-Message-State: AOAM531wPe+3nZoBL4YciIScfpkR0YcIWTICT5GiwbSM88TfOF/N7UUR
        tayRTGXUZXBToKnAfT/L1rvuJg==
X-Google-Smtp-Source: ABdhPJzT/QEahrJPqR0Htk2lrdLL2kxZYmDM33pdZKOfmYxDZ45r9JljZNMcdO7sBn2klbr5TX6tuA==
X-Received: by 2002:a17:90a:688d:: with SMTP id a13mr1038849pjd.164.1641848176266;
        Mon, 10 Jan 2022 12:56:16 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k8sm8097188pfc.177.2022.01.10.12.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 12:56:15 -0800 (PST)
Date:   Mon, 10 Jan 2022 20:56:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kechen Lu <kechenl@nvidia.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, wanpengli@tencent.com,
        vkuznets@redhat.com, mst@redhat.com, somduttar@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/3] KVM: x86: add vCPU ioctl for HLT exits
 disable capability
Message-ID: <Ydyda6K8FrFveZX7@google.com>
References: <20211221090449.15337-1-kechenl@nvidia.com>
 <20211221090449.15337-4-kechenl@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tQ3jC/mhVwyhSXsr"
Content-Disposition: inline
In-Reply-To: <20211221090449.15337-4-kechenl@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--tQ3jC/mhVwyhSXsr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 21, 2021, Kechen Lu wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d5d0d99b584e..d7b4a3e360bb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5072,6 +5072,18 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>  			kvm_update_pv_runtime(vcpu);
>  
>  		return 0;
> +
> +	case KVM_CAP_X86_DISABLE_EXITS:
> +		if (cap->args[0] && (cap->args[0] &
> +				~KVM_X86_DISABLE_VALID_EXITS))

Bad alignment, but there's no need for the !0 in the first place, i.e.

		if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)

but that's also incomplete as this path only supports toggling HLT, yet allows
all flavors of KVM_X86_DISABLE_VALID_EXITS.  Unless there's a good reason to not
allow maniuplating the other exits, the proper fix is to just support everything.

> +			return -EINVAL;
> +
> +		vcpu->arch.hlt_in_guest = (cap->args[0] &
> +			KVM_X86_DISABLE_EXITS_HLT) ? true : false;

Hmm, this behavior diverges from the per-VM ioctl, which doesn't allow re-enabling
a disabled exit.  We can't change the per-VM behavior without breaking backwards
compatibility, e.g. if userspace does:

	if (allow_mwait)
		kvm_vm_disable_exit(KVM_X86_DISABLE_EXITS_MWAIT)
	if (allow_hlt)
		kvm_vm_disable_exit(KVM_X86_DISABLE_EXITS_HLT)

then changing KVM behavior would result in MWAIT behavior intercepted when previously
it would have been allowed.  We have a userspace VMM that operates like this...

Does your use case require toggling intercepts?  Or is the configuration static?
If it's static, then the easiest thing would be to follow the per-VM behavior so
that there are no suprises.  If toggling is required, then I think the best thing
would be to add a prep patch to add an override flag to the per-VM ioctl, and then
share code between the per-VM and per-vCPU paths for modifying the flags (attached
as patch 0003).

Somewhat related, there's another bug of sorts that I think we can safely fix.
KVM doesn't reject disabling of MWAIT exits when MWAIT isn't allowed in the guest,
and instead ignores the bad input.  Not a big deal, but fixing that means KVM
doesn't need to check kvm_can_mwait_in_guest() when processing the args to update
flags.  If that breaks someone's userspace, the alternative would be to tweak the
attached patch 0003 to introduce the OVERRIDE, e.g.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f611a49ceba4..3bac756bab79 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5053,6 +5053,8 @@ static int kvm_vcpu_ioctl_device_attr(struct kvm_vcpu *vcpu,

 #define kvm_ioctl_disable_exits(a, mask)                                    \
 ({                                                                          \
+       if (!kvm_can_mwait_in_guest())                                       \
+               (mask) &= KVM_X86_DISABLE_EXITS_MWAIT;                       \
        if ((mask) & KVM_X86_DISABLE_EXITS_OVERRIDE) {                       \
                (a).mwait_in_guest = (mask) & KVM_X86_DISABLE_EXITS_MWAIT;   \
                (a).hlt_in_guest = (mask) & KVM_X86_DISABLE_EXITS_HLT;       \


If toggling is not required, then I still think it makes sense to add a macro to
handle propagating the capability args to the arch flags.

--tQ3jC/mhVwyhSXsr
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-x86-Reject-disabling-of-MWAIT-interception-when-.patch"

From 10798eb3fc1fe7f7240acd0f2667a6519ae445c5 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 10 Jan 2022 12:29:28 -0800
Subject: [PATCH] KVM: x86: Reject disabling of MWAIT interception when not
 allowed

Reject KVM_CAP_X86_DISABLE_EXITS if userspace attempts to disable MWAIT
exits and KVM previously reported (via KVM_CHECK_EXTENSION) that MWAIT is
not allowed in guest, e.g. because it's not supported or the CPU doesn't
have an aways-running APIC timer.

Fixes: 4d5422cea3b6 ("KVM: X86: Provide a capability to disable MWAIT intercepts")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c194a8cbd25f..9de22dceb49b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4087,6 +4087,17 @@ static inline bool kvm_can_mwait_in_guest(void)
 		boot_cpu_has(X86_FEATURE_ARAT);
 }
 
+static u64 kvm_get_allowed_disable_exits(void)
+{
+	u64 r = KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_PAUSE |
+		KVM_X86_DISABLE_EXITS_CSTATE;
+
+	if(kvm_can_mwait_in_guest())
+		r |= KVM_X86_DISABLE_EXITS_MWAIT;
+
+	return r;
+}
+
 static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_vcpu *vcpu,
 					    struct kvm_cpuid2 __user *cpuid_arg)
 {
@@ -4202,10 +4213,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_CLOCK_VALID_FLAGS;
 		break;
 	case KVM_CAP_X86_DISABLE_EXITS:
-		r |=  KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_PAUSE |
-		      KVM_X86_DISABLE_EXITS_CSTATE;
-		if(kvm_can_mwait_in_guest())
-			r |= KVM_X86_DISABLE_EXITS_MWAIT;
+		r |= kvm_get_allowed_disable_exits();
 		break;
 	case KVM_CAP_X86_SMM:
 		/* SMBASE is usually relocated above 1M on modern chipsets,
@@ -5779,11 +5787,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		break;
 	case KVM_CAP_X86_DISABLE_EXITS:
 		r = -EINVAL;
-		if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
+		if (cap->args[0] & ~kvm_get_allowed_disable_exits())
 			break;
 
-		if ((cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT) &&
-			kvm_can_mwait_in_guest())
+		if (cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT)
 			kvm->arch.mwait_in_guest = true;
 		if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
 			kvm->arch.hlt_in_guest = true;
-- 
2.34.1.575.g55b058a8bb-goog


--tQ3jC/mhVwyhSXsr
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0003-KVM-x86-Let-userspace-re-enable-previously-disabled-.patch"

From a8e75742293c1c400dd5aa1d111825046cf26ab2 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 10 Jan 2022 12:40:31 -0800
Subject: [PATCH] KVM: x86: Let userspace re-enable previously disabled exits

Add an OVERRIDE flag to KVM_CAP_X86_DISABLE_EXITS allow userspace to
re-enable exits and/or override previous settings.  There's no real use
case for the the per-VM ioctl, but a future per-vCPU variant wants to let
userspace toggle interception while the vCPU is running; add the OVERRIDE
functionality now to provide consistent between between the per-VM and
per-vCPU variants.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst |  5 +++++
 arch/x86/kvm/x86.c             | 37 +++++++++++++++++++++++-----------
 include/uapi/linux/kvm.h       |  4 +++-
 3 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9460941d38d7..c42e653891a2 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6617,6 +6617,7 @@ Valid bits in args[0] are::
   #define KVM_X86_DISABLE_EXITS_HLT              (1 << 1)
   #define KVM_X86_DISABLE_EXITS_PAUSE            (1 << 2)
   #define KVM_X86_DISABLE_EXITS_CSTATE           (1 << 3)
+  #define KVM_X86_DISABLE_EXITS_OVERRIDE         (1ull << 63)
 
 Enabling this capability on a VM provides userspace with a way to no
 longer intercept some instructions for improved latency in some
@@ -6625,6 +6626,10 @@ physical CPUs.  More bits can be added in the future; userspace can
 just pass the KVM_CHECK_EXTENSION result to KVM_ENABLE_CAP to disable
 all such vmexits.
 
+By default, this capability only disables exits.  To re-enable an exit, or to
+override previous settings, userspace can set KVM_X86_DISABLE_EXITS_OVERRIDE,
+in which case KVM will enable/disable according to the mask (a '1' == disable).
+
 Do not enable KVM_FEATURE_PV_UNHALT if you disable HLT exits.
 
 7.14 KVM_CAP_S390_HPAGE_1M
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7741a5980334..f611a49ceba4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4089,11 +4089,10 @@ static inline bool kvm_can_mwait_in_guest(void)
 
 static u64 kvm_get_allowed_disable_exits(void)
 {
-	u64 r = KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_PAUSE |
-		KVM_X86_DISABLE_EXITS_CSTATE;
+	u64 r = KVM_X86_DISABLE_VALID_EXITS;
 
-	if(kvm_can_mwait_in_guest())
-		r |= KVM_X86_DISABLE_EXITS_MWAIT;
+	if (!kvm_can_mwait_in_guest())
+		r &= ~KVM_X86_DISABLE_EXITS_MWAIT;
 
 	return r;
 }
@@ -5051,6 +5050,26 @@ static int kvm_vcpu_ioctl_device_attr(struct kvm_vcpu *vcpu,
 	return r;
 }
 
+
+#define kvm_ioctl_disable_exits(a, mask)				     \
+({									     \
+	if ((mask) & KVM_X86_DISABLE_EXITS_OVERRIDE) {			     \
+		(a).mwait_in_guest = (mask) & KVM_X86_DISABLE_EXITS_MWAIT;   \
+		(a).hlt_in_guest = (mask) & KVM_X86_DISABLE_EXITS_HLT;	     \
+		(a).pause_in_guest = (mask) & KVM_X86_DISABLE_EXITS_PAUSE;   \
+		(a).cstate_in_guest = (mask) & KVM_X86_DISABLE_EXITS_CSTATE; \
+	} else {							     \
+		if ((mask) & KVM_X86_DISABLE_EXITS_MWAIT)		     \
+			(a).mwait_in_guest = true;			     \
+		if ((mask) & KVM_X86_DISABLE_EXITS_HLT)			     \
+			(a).hlt_in_guest = true;			     \
+		if ((mask) & KVM_X86_DISABLE_EXITS_PAUSE)		     \
+			(a).pause_in_guest = true;			     \
+		if ((mask) & KVM_X86_DISABLE_EXITS_CSTATE)		     \
+			(a).cstate_in_guest = true;			     \
+	}								     \
+})
+
 static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 				     struct kvm_enable_cap *cap)
 {
@@ -5794,14 +5813,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (kvm->created_vcpus)
 			goto disable_exits_unlock;
 
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT)
-			kvm->arch.mwait_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
-			kvm->arch.hlt_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
-			kvm->arch.pause_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
-			kvm->arch.cstate_in_guest = true;
+		kvm_ioctl_disable_exits(kvm->arch, cap->args[0]);
+
 		r = 0;
 disable_exits_unlock:
 		mutex_unlock(&kvm->lock);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index fbfd70d965c6..5e0ffc87a578 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -798,10 +798,12 @@ struct kvm_ioeventfd {
 #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
 #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
 #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
+#define KVM_X86_DISABLE_EXITS_OVERRIDE	     (1ull << 63)
 #define KVM_X86_DISABLE_VALID_EXITS          (KVM_X86_DISABLE_EXITS_MWAIT | \
                                               KVM_X86_DISABLE_EXITS_HLT | \
                                               KVM_X86_DISABLE_EXITS_PAUSE | \
-                                              KVM_X86_DISABLE_EXITS_CSTATE)
+                                              KVM_X86_DISABLE_EXITS_CSTATE | \
+					      KVM_X86_DISABLE_EXITS_OVERRIDE)
 
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
-- 
2.34.1.575.g55b058a8bb-goog


--tQ3jC/mhVwyhSXsr--
