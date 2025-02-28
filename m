Return-Path: <kvm+bounces-39762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14A01A4A1BA
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 19:35:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 355C33AC490
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 18:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F34CB27CCDE;
	Fri, 28 Feb 2025 18:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qwOJd1PK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D7F27CCD0
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 18:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740767523; cv=none; b=nLF/m5khMsDMZHilwS5ryQgW+JC5b2oGzl3V0BvkAGrP8qzSSOa9JB4SfjmX8dW0afplX4D+PSpQtIRdNwoyNnUBwwd3eMif1H+FyLqR6BH2xWsX4DiWbO4NHbVrmQpeI0w/VPzY4njoTqsLAX/Pfha7IPIygOyieRnh0J00qAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740767523; c=relaxed/simple;
	bh=guZt1Zi+iXkkSqZIGqCWWaUtqAwC15Ww+zgjipfFYog=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VcvOeuognSaxUB7pC8rdBlCQfg+BuBhIuiRH+d/vMEvjQkWKpg2VQolUubeTQVS9vb162pvynDYHX41P+zR7owVa3LfQCsaJiIeYPO364/RFSB3eDmH3jnMdtl9mg69HczmkF+juDFElrtBZiw29i1qp4q+GdMGkOgAP2kYnVPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qwOJd1PK; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-223725a1e76so12727975ad.0
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 10:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740767520; x=1741372320; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6pijisVLPCJj8vW2ZfATw2CQzs5cG5ymgPPQbMYMBHE=;
        b=qwOJd1PKAiPgSNYHFttS7XbhwtAdlyjX7vmuyw76UEVFOpvAyDzRY6dJbiqhxOz9+C
         lrLIt5DAKAbbFngQPOMW3jubsd/r9hqewu5kqfhkPqA8l9YM9DIBKQ1bzfmjK9l+KfSH
         JhQHQAm/deIlz775qoMqZ9JKAtb9JTsXDK/KiCtiny8JmxPsVjHQTHenyHwBvY8HFhYe
         FUXQsShQPfeWtm5vxK+pTy0wG+xfX7VrPbN2gV8DBoyS9kD+OM9rS7Hn5mTGUmXTMgpj
         PXvz9tdkI4iMe7UYPI1zRwzM7VroP6xeK2zYzLzY0ZXcd85Nu3FTqaerNrJskdwnbtPP
         NZ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740767520; x=1741372320;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6pijisVLPCJj8vW2ZfATw2CQzs5cG5ymgPPQbMYMBHE=;
        b=GXtIwCzgK6RVgH+ZFMpVO2EcpXsH1uYjZ8Jpb8PRTzvxgucXillQ8XiybIPvlCZ5vy
         Oc/DFckc5lEH8WWyn4jgX4SIF4cFW6GHERPCXyTPU1nT1Ew0Gh9LeWL3/iWWm1ES3bgY
         oQlHMxgLJQguh7kANoYBQiDRzrNCN+MviLtQZI2D8IkrWtHlsSQpGAawELAHQHUfQPAa
         Ek4GOIlP+XL8nxeQC/I2vnHZhHyyQYDPb/5nlNdexyVu1w8kTHagXGo2ey2NyfiqZ2UY
         cXXHVak26zd5ZWWjvYj1Jq1SjrxackTZjXC6jhF6qC/+r7gO8ZJN+nlod/hckL4y/AAX
         /RVQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5uXq+4fPRW0w/1LgzJWFE6ARhLKBUwN1lyRoW3G0AwKguyD4cjuBDwCLuc9GufzkHf60=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+SCV8dMvxAN94nKl0JME7t46Ksev37KYn+npR3/mZHBN54vp7
	nyYzlKL2x4jGgxktNctrQM+b1lxxWs1kSZSEHSPuLHpx2KcofAQHujj90fDscfZmbE6MjJMEsyZ
	FtA==
X-Google-Smtp-Source: AGHT+IF4N9NsIkmr/dcMIkDaZ4a+7XdgaaufJF3rLHlXHdN4NAQScNU/ckB1oUbOH4qNPSFvkWjtZERYyYU=
X-Received: from pjboh15.prod.google.com ([2002:a17:90b:3a4f:b0:2ea:5be5:da6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:8cb:b0:220:e63c:5b13
 with SMTP id d9443c01a7336-2236925e4famr73615075ad.46.1740767520231; Fri, 28
 Feb 2025 10:32:00 -0800 (PST)
Date: Fri, 28 Feb 2025 10:31:58 -0800
In-Reply-To: <27a491ee16015824b416e72921b02a02c27433f7.1740512583.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1740512583.git.ashish.kalra@amd.com> <27a491ee16015824b416e72921b02a02c27433f7.1740512583.git.ashish.kalra@amd.com>
Message-ID: <Z8IBHuSc3apsxePN@google.com>
Subject: Re: [PATCH v5 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au, 
	michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com, ardb@kernel.org, 
	kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, aik@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: multipart/mixed; charset="UTF-8"; boundary="ZxKkPI+e2NE34Qwk"


--ZxKkPI+e2NE34Qwk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 25, 2025, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Move platform initialization of SEV/SNP from CCP driver probe time to
> KVM module load time so that KVM can do SEV/SNP platform initialization
> explicitly if it actually wants to use SEV/SNP functionality.
> 
> Add support for KVM to explicitly call into the CCP driver at load time
> to initialize SEV/SNP. If required, this behavior can be altered with KVM
> module parameters to not do SEV/SNP platform initialization at module load
> time. Additionally, a corresponding SEV/SNP platform shutdown is invoked
> during KVM module unload time.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 74525651770a..0bc6c0486071 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2933,6 +2933,7 @@ void __init sev_set_cpu_caps(void)
>  void __init sev_hardware_setup(void)
>  {
>  	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
> +	struct sev_platform_init_args init_args = {0};
>  	bool sev_snp_supported = false;
>  	bool sev_es_supported = false;
>  	bool sev_supported = false;
> @@ -3059,6 +3060,17 @@ void __init sev_hardware_setup(void)
>  	sev_supported_vmsa_features = 0;
>  	if (sev_es_debug_swap_enabled)
>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
> +
> +	if (!sev_enabled)
> +		return;
> +
> +	/*
> +	 * Always perform SEV initialization at setup time to avoid
> +	 * complications when performing SEV initialization later
> +	 * (such as suspending active guests, etc.).

This is misleading and wildly incomplete.  *SEV* doesn't have complications, *SNP*
has complications.  And looking through sev_platform_init(), all of this code
is buggy.

The sev_platform_init() return code is completely disconnected from SNP setup.
It can return errors even if SNP setup succeeds, and can return success even if
SNP setup fails.

I also think it makes sense to require SNP to be initialized during KVM setup.
I don't see anything in __sev_snp_init_locked() that suggests SNP initialization
can magically succeed at runtime if it failed at boot.  To keep things sane and
simple, I think KVM should reject module load if SNP is requested, setup fails,
and kvm-amd.ko is a module.  If kvm-amd.ko is built-in and SNP fails, just disable
SNP support.  I.e. when possible, let userspace decide what to do, but don't bring
down all of KVM just because SNP setup failed.

The attached patches are compile-tested (mostly), can you please test them and
slot them in?

> +	 */
> +	init_args.probe = true;
> +	sev_platform_init(&init_args);
>  }
>  
>  void sev_hardware_unsetup(void)
> @@ -3074,6 +3086,9 @@ void sev_hardware_unsetup(void)
>  
>  	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
>  	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
> +
> +	/* Do SEV and SNP Shutdown */

Meh, just omit this comment.  

> +	sev_platform_shutdown();
>  }
>  
>  int sev_cpu_init(struct svm_cpu_data *sd)
> -- 
> 2.34.1
> 

--ZxKkPI+e2NE34Qwk
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-crypto-ccp-Enumerate-SNP-support-in-output-of-sev_pl.patch"

From 7274d7156ff9df5018e4f8ac8fbfae7d7ca8d6d6 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Feb 2025 10:01:37 -0800
Subject: [PATCH 1/4] crypto: ccp: Enumerate SNP support in output of
 sev_platform_init()

Add an output param to sev_platform_init() to communicate whether or not
SNP was (or already was) successfully initialized.  The return code from
sev_platform_init() is completely disconnected from SNP initialization,
e.g. will return errors if SNP setup succeeded, and will return success if
SNP setup failed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/crypto/ccp/sev-dev.c | 1 +
 include/linux/psp-sev.h      | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index cde6ebab589d..5164c5f3bd3f 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1357,6 +1357,7 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 		 */
 		dev_err(sev->dev, "SEV-SNP: failed to INIT, continue SEV INIT\n");
 	}
+	args->snp_initialized = sev->snp_initialized;
 
 	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */
 	if (args->probe && !psp_init_on_probe)
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 0b3a36bdaa90..726535e302be 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -797,10 +797,12 @@ struct sev_data_snp_shutdown_ex {
  * @probe: True if this is being called as part of CCP module probe, which
  *  will defer SEV_INIT/SEV_INIT_EX firmware initialization until needed
  *  unless psp_init_on_probe module param is set
+ * @snp_initialized: Output param that is true if SNP was initialized.
  */
 struct sev_platform_init_args {
 	int error;
 	bool probe;
+	bool snp_initialized;
 };
 
 /**

base-commit: ac2ba191f3b6b41c9403b142223dfcc3dfe8903b
-- 
2.48.1.711.g2feabab25a-goog


--ZxKkPI+e2NE34Qwk
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-KVM-SVM-Reject-SNP-VM-creation-if-SNP-platform-initi.patch"

From 6cd53151470bb088e6a5f1fded0e4d9b66fe7bbe Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Feb 2025 10:09:48 -0800
Subject: [PATCH 2/4] KVM: SVM: Reject SNP VM creation if SNP platform
 initialization failed

Explicitly check that SNP platform initialization succeeded prior to
creating SNP VMs.  The return from sev_platform_init() only tracks "legacy"
SEV and SEV-ES support, i.e. can return '0' even if SNP setup fails.

Fixes: 1dfe571c12cf ("KVM: SEV: Add initial SEV-SNP support")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3fc87cdc95c8..dd001a293899 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -449,6 +449,10 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 
 	/* This needs to happen after SEV/SNP firmware initialization. */
 	if (vm_type == KVM_X86_SNP_VM) {
+		if (!init_args.snp_initialized) {
+			ret = -EIO;
+			goto e_free;
+		}
 		ret = snp_guest_req_init(kvm);
 		if (ret)
 			goto e_free;
-- 
2.48.1.711.g2feabab25a-goog


--ZxKkPI+e2NE34Qwk
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0003-KVM-SVM-Ignore-sev_platform_init-return-code-when-cr.patch"

From 8dd4327a3e30ce73753e818377c6b47a16e48467 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Feb 2025 10:09:48 -0800
Subject: [PATCH 3/4] KVM: SVM: Ignore sev_platform_init() return code when
 creating SNP VM

Ignore errors from sev_platform_init() when creating SNP VMs, as SNP
initialization can succeed even if SEV/SEV-ES initialization fails.

Fixes: 1dfe571c12cf ("KVM: SEV: Add initial SEV-SNP support")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index dd001a293899..354f6c32c435 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -443,8 +443,15 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 		goto e_no_asid;
 
 	init_args.probe = false;
+	/*
+	 * Initialize SEV/SEV-ES if neccessary, i.e. if the CCP driver was
+	 * configured to defer setup.
+	 * Ignore failure for SNP VMs, as SNP initialization can succeed even
+	 * if SEV/SEV-ES initialization fails (and vice versa).  SNP support is
+	 * communicated via an out param, and is checked below.
+	 */
 	ret = sev_platform_init(&init_args);
-	if (ret)
+	if (ret && vm_type != KVM_X86_SNP_VM)
 		goto e_free;
 
 	/* This needs to happen after SEV/SNP firmware initialization. */
-- 
2.48.1.711.g2feabab25a-goog


--ZxKkPI+e2NE34Qwk
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0004-KVM-SVM-Add-support-to-initialize-SEV-SNP-functional.patch"

From d67d8504d1e288f646e67d264f418b2acc300236 Mon Sep 17 00:00:00 2001
From: Ashish Kalra <ashish.kalra@amd.com>
Date: Tue, 25 Feb 2025 21:01:33 +0000
Subject: [PATCH 4/4] KVM: SVM: Add support to initialize SEV/SNP functionality
 in KVM

Move platform initialization of SEV/SNP from CCP driver probe time to
KVM module load time so that KVM can do SEV/SNP platform initialization
explicitly if it actually wants to use SEV/SNP functionality.

Add support for KVM to explicitly call into the CCP driver at load time
to initialize SEV/SNP. If required, this behavior can be altered with KVM
module parameters to not do SEV/SNP platform initialization at module load
time. Additionally, a corresponding SEV/SNP platform shutdown is invoked
during KVM module unload time.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 52 +++++++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.c |  4 +++-
 arch/x86/kvm/svm/svm.h |  4 ++--
 3 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 354f6c32c435..2b8c1d125164 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -402,7 +402,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 			    unsigned long vm_type)
 {
 	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
-	struct sev_platform_init_args init_args = {0};
+	struct sev_platform_init_args init_args = { .probe = false };
 	bool es_active = vm_type != KVM_X86_SEV_VM;
 	u64 valid_vmsa_features = es_active ? sev_supported_vmsa_features : 0;
 	int ret;
@@ -442,10 +442,9 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (ret)
 		goto e_no_asid;
 
-	init_args.probe = false;
 	/*
-	 * Initialize SEV/SEV-ES if neccessary, i.e. if the CCP driver was
-	 * configured to defer setup.
+	 * Initialize SEV/SEV-ES if neccessary, i.e. if setup failued during
+	 * module load, or if the CCP driver was configured to defer setup.
 	 * Ignore failure for SNP VMs, as SNP initialization can succeed even
 	 * if SEV/SEV-ES initialization fails (and vice versa).  SNP support is
 	 * communicated via an out param, and is checked below.
@@ -456,7 +455,11 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 
 	/* This needs to happen after SEV/SNP firmware initialization. */
 	if (vm_type == KVM_X86_SNP_VM) {
-		if (!init_args.snp_initialized) {
+		/*
+		 * SNP is initialized during KVM setup, and KVM shouldn't
+		 * advertise support for SNP if initialization failed.
+		 */
+		if (WARN_ON_ONCE(!init_args.snp_initialized)) {
 			ret = -EIO;
 			goto e_free;
 		}
@@ -2941,9 +2944,10 @@ void __init sev_set_cpu_caps(void)
 	}
 }
 
-void __init sev_hardware_setup(void)
+int __init sev_hardware_setup(void)
 {
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
+	struct sev_platform_init_args init_args = { .probe = true };
 	bool sev_snp_supported = false;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
@@ -3044,6 +3048,38 @@ void __init sev_hardware_setup(void)
 	sev_snp_supported = sev_snp_enabled && cc_platform_has(CC_ATTR_HOST_SEV_SNP);
 
 out:
+	/*
+	 * Initialize SEV+ in firmware and throughout the plaform.  If SNP is
+	 * supported by hardare, requested by the user, and fails to initialize,
+	 * reject setup if kvm-amd.ko is built as a module, i.e. if userspace
+	 * can retry and thus decide whether or not SNP is a hard requirement.
+	 * If KVM is fully built-in, continue on so that KVM can still run
+	 * non-SNP VMs.
+	 *
+	 * Leave SEV and SEV-ES as-is; they are compatible with runtime setup,
+	 * and KVM will retry initialization if/when the first SEV/SEV-ES VM is
+	 * created.
+	 *
+	 * Note, if psp_init_on_probe is disabled, this will initialize SNP+,
+	 * but not SEV or SEV-ES.  Deferring SEV/SEV-ES initialization allows
+	 * userspace to hotload firmware (SNP enabling is compatible, "legacy"
+	 * SEV/SEV-ES enabling is not).  As above, KVM will do SEV/SEV-ES at VM
+	 * creation if necessary.
+	 */
+	if (sev_supported) {
+		/*
+		 * Ignore the return value, which only communicates SEV/SEV-ES
+		 * status.  SNP status is provided as an output param.
+		 */
+		sev_platform_init(&init_args);
+		if (!init_args.snp_initialized && sev_snp_supported) {
+			if (IS_MODULE(CONFIG_KVM_AMD))
+				return -EIO;
+
+			sev_snp_supported = false;
+		}
+	}
+
 	if (boot_cpu_has(X86_FEATURE_SEV))
 		pr_info("SEV %s (ASIDs %u - %u)\n",
 			sev_supported ? min_sev_asid <= max_sev_asid ? "enabled" :
@@ -3070,6 +3106,8 @@ void __init sev_hardware_setup(void)
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
+	return 0;
 }
 
 void sev_hardware_unsetup(void)
@@ -3085,6 +3123,8 @@ void sev_hardware_unsetup(void)
 
 	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
 	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
+
+	sev_platform_shutdown();
 }
 
 int sev_cpu_init(struct svm_cpu_data *sd)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58e377d32627..db48fb8d6257 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5358,7 +5358,9 @@ static __init int svm_hardware_setup(void)
 	 * Note, SEV setup consumes npt_enabled and enable_mmio_caching (which
 	 * may be modified by svm_adjust_mmio_mask()), as well as nrips.
 	 */
-	sev_hardware_setup();
+	r = sev_hardware_setup();
+	if (r)
+		return r;
 
 	svm_hv_hardware_setup();
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index faa5c0dab0ea..fe7bfab96397 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -773,7 +773,7 @@ static inline struct page *snp_safe_alloc_page(void)
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 void sev_vm_destroy(struct kvm *kvm);
 void __init sev_set_cpu_caps(void);
-void __init sev_hardware_setup(void);
+int __init sev_hardware_setup(void);
 void sev_hardware_unsetup(void);
 int sev_cpu_init(struct svm_cpu_data *sd);
 int sev_dev_get_attr(u32 group, u64 attr, u64 *val);
@@ -797,7 +797,7 @@ static inline struct page *snp_safe_alloc_page(void)
 static inline void sev_free_vcpu(struct kvm_vcpu *vcpu) {}
 static inline void sev_vm_destroy(struct kvm *kvm) {}
 static inline void __init sev_set_cpu_caps(void) {}
-static inline void __init sev_hardware_setup(void) {}
+static inline int __init sev_hardware_setup(void) { return 0; }
 static inline void sev_hardware_unsetup(void) {}
 static inline int sev_cpu_init(struct svm_cpu_data *sd) { return 0; }
 static inline int sev_dev_get_attr(u32 group, u64 attr, u64 *val) { return -ENXIO; }
-- 
2.48.1.711.g2feabab25a-goog


--ZxKkPI+e2NE34Qwk--

