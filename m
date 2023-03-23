Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3CB6C71AA
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 21:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjCWU3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 16:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCWU3p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 16:29:45 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6796A69
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 13:29:43 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id h4-20020a170902f54400b001a1f5f00f3fso11442plf.2
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 13:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679603383;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WXbH0goXw1leVFAOf4IsXwUbFsJdcIMZKM/a5zydiXE=;
        b=c3rA1hzhl5gUJMD0YC1dCFVP143h00NeHDCVcRDWgpU3PI9ILeKAWgbcbmEzSpSZKa
         wdY+fTBhXDQ4PyXtRANHRPOTstCNDDd3Xgo5Hkhh427vYbiDHT9JAZWxeJDynBTWSj5u
         3blBD6CNOAt2OyvlQcE0HCvvOKBI1bNXkyk3x32q0cqZfp0XGCR4YxZ4rQD6BFjRcfQv
         lAyWdqcfwAFZO+ZP/uQzYotWVgt2o6Om06QZ58LdwQT8qlmj7LlqCqcpw8LHKl4ouGbx
         4/5+vlS/ckcJOkYTWHe0e9mwblRmPjJ8WkT8NeqKXVWfq0UTkvm4MYyD/eLGJvNgcrFF
         KfhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679603383;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WXbH0goXw1leVFAOf4IsXwUbFsJdcIMZKM/a5zydiXE=;
        b=x6AurdKANf+hViNQDLhFrC+1/Y3fEsfGfYk4kHQm8Mv4RtiJ95Yf07mGB0EOAQXjXw
         WDn9IGGJWgTPDbNcfFumlNivEmlLTR5LhJ300aKsE+8xi52Aek5GWdbt3T7hVh0Rpclu
         e1mbTeqotX8Qa+ZbRA/kofUs+FOCe+/V+KwGDvz5S/SsnlZwL7W69OvQvQZVVquGwTVI
         311y1220Qjm/JBBl5l7vgXZPn26pvC5OPsvLY6GwqGMI79+wiIFjvvFVZrPGs62yHtvI
         6Y9sS3UeZYtgfPUU7ZIkYLPsvFI3QnHjXlqv6t+66M3mJXw0K9EqeDtP55KT1GBJMkrz
         QeRg==
X-Gm-Message-State: AAQBX9dBYyF1moYdLBu7PSFfCqhETN27+ykZt2V99KVXxVr7uk1PWIQE
        fb3iTXUvxV0VZrDsnmXzD86QG7Jiub0=
X-Google-Smtp-Source: AKy350ZyMXLZlAM5LvynC5hMx66YLxkqtMHJx0U99N0O+4Nhw2IWPgESNggEtZuBc3+pIPrjxdhyCmT6kZw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:555:b0:1a0:440e:ecf9 with SMTP id
 jo21-20020a170903055500b001a0440eecf9mr63607plb.5.1679603383215; Thu, 23 Mar
 2023 13:29:43 -0700 (PDT)
Date:   Thu, 23 Mar 2023 13:29:41 -0700
In-Reply-To: <20230224223607.1580880-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230224223607.1580880-1-aaronlewis@google.com> <20230224223607.1580880-3-aaronlewis@google.com>
Message-ID: <ZBy2tcQzERBpsoxz@google.com>
Subject: Re: [PATCH v3 2/8] KVM: x86: Clear all supported MPX xfeatures if
 they are not all set
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        mizhang@google.com
Content-Type: multipart/mixed; charset="UTF-8"; boundary="YXzPC54dT+L+1xR4"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--YXzPC54dT+L+1xR4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 24, 2023, Aaron Lewis wrote:
> Be a good citizen and don't allow any of the supported MPX xfeatures[1]
> to be set if they can't all be set.  That way userspace or a guest
> doesn't fail if it attempts to set them in XCR0.
> 
> [1] CPUID.(EAX=0DH,ECX=0):EAX.BNDREGS[bit-3]
>     CPUID.(EAX=0DH,ECX=0):EAX.BNDCSR[bit-4]
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index e1165c196970..b2e7407cd114 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -60,9 +60,22 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
>  	return ret;
>  }
>  
> +static u64 sanitize_xcr0(u64 xcr0)
> +{
> +	u64 mask;
> +
> +	mask = XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR;
> +	if ((xcr0 & mask) != mask)
> +		xcr0 &= ~mask;
> +
> +	return xcr0;
> +}
> +
>  u64 kvm_permitted_xcr0(void)
>  {
> -	return kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
> +	u64 permitted_xcr0 = kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
> +
> +	return sanitize_xcr0(permitted_xcr0);

Sanitizing XCR0 in this "permitted" helper conflates two separate things (sanity
vs. permissions) and overall leads to a really, really confusing mess.  E.g.
kvm_vcpu_ioctl_x86_set_xsave(), cpuid_get_supported_xcr0(), kvm_x86_dev_get_attr(),
and kvm_mpx_supported() all use the non-sanitized value, which appears nonsensical,
but is actually correct because the whole "permitted" thing is funky.

On a related topic, isn't cpuid_get_supported_xcr0() buggy?  Ah, no, the wonderfully
named kvm_check_cpuid() ensures fpu_enable_guest_xfd_features() is invoked before
the result can actually be consumed.

Ugh, and past me created a royal mess with SGX subleaf 0x12.1.  KVM shouldn't
be manipulating guest CPUID just to ensure userspace doesn't bypass the guest's
permitted XCR0 by launching an enclave.  I.e. the SGX code that consumes
cpuid_get_supported_xcr0() in __kvm_update_cpuid_runtime() should not exists.
I'm 99.9% certain we can simply nuke that code without breaking userspace, e.g.
QEMU correctly sets the data.

LOL, or at least it used to.  QEMU commit 301e90675c ("target/i386: Enable support
for XSAVES based features") completely broke SGX by using allowed XSS instead of
XCR0.

Anyways, back to this mess.  I was going to say "As I suggested in v2[0], sanitize
kvm_caps.supported_xcr0 itself", but after a _lot_ of starting, I realized (or
finally remembered) that that doesn't work because supported_xcr0 is already sane,
the issue is specifically with xstate_get_guest_group_perm() clearing XTILE_DATA
and leaving behind the XTILE_CFG landmine.

And for all intents and purposes, supported_xcr0 _must_ be sane since it comes
from host_xcr0, which is pulled straight from hardware.  So barring a _completely_
busted CPU or hypervisor _and_ a busted kernel, supported_xcr0 itself can never
be insane.  So not only is my proposal to sanitize supported_xcr0 not viable, the
entire idea of generically sanitizing XCR0 is bunk.  The _only_ issue is XTILE_CFG,
and it's very specifically because of the dynamic feature crud.

So rather than add a bunch of logic to sanitize XCR0, which is at best superfluous
and at worst misleading (again, only XTILE_CFG can ever be insane), I think we
should just special case XTILE_CFG and add a big fat comment explaining why KVM
further manipulates the "supported" XCR0.

Ah, and that's more or less what Aaron had in v1, but then Jim asked about MPX[1]
and things went off the rails (I'm just relieved that I wasn't the one to send
you awry and then complain about the result).

Aaron and/or Mingwei, can you give the attached patches a spin?  Patch 1 is a
slightly reworked version of Aaron's patch 1, and patch 2 implements what I just
described (guts of patch 2 also pasted below).  If things look good, I'll post a v4
of this series.

[0] https://lore.kernel.org/all/Y7R36wsXn3JqwfEv@google.com
[1] https://lore.kernel.org/all/CALMp9eQD8EpS50A0iAxsoaW-_yFmWERWw6rbAh9VSEJjDrMkNQ@mail.gmail.com


---
 arch/x86/kvm/x86.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index b6c6988d99b5..ae235bc2b9bc 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -3,6 +3,7 @@
 #define ARCH_X86_KVM_X86_H
 
 #include <linux/kvm_host.h>
+#include <asm/fpu/xstate.h>
 #include <asm/mce.h>
 #include <asm/pvclock.h>
 #include "kvm_cache_regs.h"
@@ -325,7 +326,22 @@ extern bool enable_pmu;
  */
 static inline u64 kvm_get_filtered_xcr0(void)
 {
-	return kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
+	u64 supported_xcr0 = kvm_caps.supported_xcr0;
+
+	BUILD_BUG_ON(XFEATURE_MASK_USER_DYNAMIC != XFEATURE_MASK_XTILE_DATA);
+
+	if (supported_xcr0 & XFEATURE_MASK_USER_DYNAMIC) {
+		supported_xcr0 &= xstate_get_guest_group_perm();
+
+		/*
+		 * Treat XTILE_CFG as unsupported if the current process isn't
+		 * allowed to use XTILE_DATA, as attempting to set XTILE_CFG in
+		 * XCR0 without setting XTILE_DATA is architecturally illegal.
+		 */
+		if (!(supported_xcr0 & XFEATURE_MASK_XTILE_DATA))
+			supported_xcr0 &= XFEATURE_MASK_XTILE_CFG;
+	}
+	return supported_xcr0;
 }
 
 static inline bool kvm_mpx_supported(void)
-- 


--YXzPC54dT+L+1xR4
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-x86-Add-a-helper-to-handle-filtering-of-unpermit.patch"

From 0c0a6bdcd8edd04874344dd71c135bb211605c25 Mon Sep 17 00:00:00 2001
From: Aaron Lewis <aaronlewis@google.com>
Date: Fri, 24 Feb 2023 22:36:00 +0000
Subject: [PATCH 1/2] KVM: x86: Add a helper to handle filtering of unpermitted
 XCR0 features

Add a helper, kvm_get_filtered_xcr0(), to dedup code that needs to account
for XCR0 features that require explicit opt-in on a per-process basis.  In
addition to documenting when KVM should/shouldn't consult
xstate_get_guest_group_perm(), the helper will also allow sanitizing the
filtered XCR0 to avoid enumerating architecturally illegal XCR0 values,
e.g. XTILE_CFG without XTILE_DATA.

No functional changes intended.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
Link: https://lore.kernel.org/r/20230224223607.1580880-2-aaronlewis@google.com
[sean: rename helper, move to x86.h, massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c |  2 +-
 arch/x86/kvm/x86.c   |  4 +---
 arch/x86/kvm/x86.h   | 13 +++++++++++++
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 1ad3bde72526..98a46e46ee9e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1002,7 +1002,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->eax = entry->ebx = entry->ecx = 0;
 		break;
 	case 0xd: {
-		u64 permitted_xcr0 = kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
+		u64 permitted_xcr0 = kvm_get_filtered_xcr0();
 		u64 permitted_xss = kvm_caps.supported_xss;
 
 		entry->eax &= permitted_xcr0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3fab192862d4..0e5a0078bb4d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4547,9 +4547,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 			r = 0;
 		break;
 	case KVM_CAP_XSAVE2: {
-		u64 guest_perm = xstate_get_guest_group_perm();
-
-		r = xstate_required_size(kvm_caps.supported_xcr0 & guest_perm, false);
+		r = xstate_required_size(kvm_get_filtered_xcr0(), false);
 		if (r < sizeof(struct kvm_xsave))
 			r = sizeof(struct kvm_xsave);
 		break;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 203fb6640b5b..b6c6988d99b5 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -315,6 +315,19 @@ extern struct kvm_caps kvm_caps;
 
 extern bool enable_pmu;
 
+/*
+ * Get a filtered version of KVM's supported XCR0 that strips out dynamic
+ * features for which the current process doesn't (yet) have permission to use.
+ * This is intended to be used only when enumerating support to userspace,
+ * e.g. in KVM_GET_SUPPORTED_CPUID and KVM_CAP_XSAVE2, it does NOT need to be
+ * used to check/restrict guest behavior as KVM rejects KVM_SET_CPUID{2} if
+ * userspace attempts to enable unpermitted features.
+ */
+static inline u64 kvm_get_filtered_xcr0(void)
+{
+	return kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
+}
+
 static inline bool kvm_mpx_supported(void)
 {
 	return (kvm_caps.supported_xcr0 & (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR))

base-commit: 68f7c82ab1b8c7057b0c241907ff7906c7407e6d
-- 
2.40.0.348.gf938b09366-goog


--YXzPC54dT+L+1xR4
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-KVM-x86-Filter-out-XTILE_CFG-if-XTILE_DATA-isn-t-per.patch"

From 39775081bd99ef8dc8b38852f5dad82ca216de5e Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 23 Mar 2023 12:52:29 -0700
Subject: [PATCH 2/2] KVM: x86: Filter out XTILE_CFG if XTILE_DATA isn't
 permitted

Filter out XTILE_CFG from the supported XCR0 reported to userspace if the
current process doesn't have access to XTILE_DATA.  Attempting to set
XTILE_CFG in XCR0 will #GP if XTILE_DATA is also not set, and so keeping
XTILE_CFG as supported results in xplosions if userspace feeds
KVM_GET_SUPPORTED_CPUID back into KVM and the guest doesn't sanity check
CPUID.

Fixes: 445ecdf79be0 ("kvm: x86: Exclude unpermitted xfeatures at KVM_GET_SUPPORTED_CPUID")
Reported-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index b6c6988d99b5..ae235bc2b9bc 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -3,6 +3,7 @@
 #define ARCH_X86_KVM_X86_H
 
 #include <linux/kvm_host.h>
+#include <asm/fpu/xstate.h>
 #include <asm/mce.h>
 #include <asm/pvclock.h>
 #include "kvm_cache_regs.h"
@@ -325,7 +326,22 @@ extern bool enable_pmu;
  */
 static inline u64 kvm_get_filtered_xcr0(void)
 {
-	return kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
+	u64 supported_xcr0 = kvm_caps.supported_xcr0;
+
+	BUILD_BUG_ON(XFEATURE_MASK_USER_DYNAMIC != XFEATURE_MASK_XTILE_DATA);
+
+	if (supported_xcr0 & XFEATURE_MASK_USER_DYNAMIC) {
+		supported_xcr0 &= xstate_get_guest_group_perm();
+
+		/*
+		 * Treat XTILE_CFG as unsupported if the current process isn't
+		 * allowed to use XTILE_DATA, as attempting to set XTILE_CFG in
+		 * XCR0 without setting XTILE_DATA is architecturally illegal.
+		 */
+		if (!(supported_xcr0 & XFEATURE_MASK_XTILE_DATA))
+			supported_xcr0 &= XFEATURE_MASK_XTILE_CFG;
+	}
+	return supported_xcr0;
 }
 
 static inline bool kvm_mpx_supported(void)
-- 
2.40.0.348.gf938b09366-goog


--YXzPC54dT+L+1xR4--
