Return-Path: <kvm+bounces-35457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CECE1A1141C
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 23:32:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79F7E3A034D
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 22:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FB492135D0;
	Tue, 14 Jan 2025 22:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aU8L0npt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1918423245F
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 22:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736893908; cv=none; b=aArZcg6wBlxC+Q2eRFxIf9YH470Uc7a2ubnXBrAyt6eJAP/skQGFUIKQHYiVLRnpl1LeingpZVGOdhhiDdxLKebYNYJWEE8C26WsuA+rE53aj7PmvS1PlagOZPViZjkUEAv68tooFVZ+5kQNNOc71bOY0uSU+/0NEXoYLF/6g5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736893908; c=relaxed/simple;
	bh=cqx6DbIYkBoGBaiuAkwVPBay5SgCYs4xVZ1fLHBHb8k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EjRmuebabr5meb1GTgU66/DBoI9SenfytQ/5PFrTpRxnbWKJNgUeHNVKtAKa/ENbLT9T2e/6UKWN1Z9ktxP2zv+9N3Fs/4PIxL8oAEWAGY0IWVY5w6gwxHtNyOHisIpYBBOAOqCwFo/FLBcMTKwHmtMG8MIm+tAgzMz5w0uhWmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aU8L0npt; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-216430a88b0so116785705ad.0
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 14:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736893905; x=1737498705; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q0ATR9Ks2Lk/Fr3H3v8Xg7bVUeMFdDfhM2C3ev16hPg=;
        b=aU8L0nptD4s/sEsUI+GnbogTrHkv+WBh7uD+/CA5tOdX8V+/mlvJ7EjNNZ+EitvYpN
         oh3pe+QjWNQo8ONyLMwIQfcotCkxZQ4EueR5UxbAyl4hJZFCPAbOrDnNuZEcxun7p0Mg
         70+0Ud9pQCy/Z8mfLbVhJ7BiGx5tcRTmS1xQew3xIzzsR6dynf7tBeMp8qeae3Ci+oGV
         /iL4bcZG2Iwr4eMSnezeXm/8Grc+DZGPQyEp9njjQL/lgwwpIvUQPy71UE58qi7ODoKB
         jHmOvPa68idKvXbAIzClr/eZcM/EkBbPcmhrHvtP9/wqcpkjyWkv7eH/PSRoHf0mpZJW
         Ge6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736893905; x=1737498705;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q0ATR9Ks2Lk/Fr3H3v8Xg7bVUeMFdDfhM2C3ev16hPg=;
        b=dD/TXLP6LvNv552fQyDjy6i85vfAe3L79S66xDmPeZ0Pe6Qh4T8h4tlN7Nm0SjQJh/
         uSqm+6GNVeE2yxReu6kCXim/8M8LpftK8etduPKGnXZd1NjH9Izk3GI8mcRX7V3B+HF6
         n2hIT2sVr/P3X7MTfVuxtMxhSlDDsg5djZdYWDtG3/vVvD+cy9e9jK8Bj1Lngpmpjp67
         i7+MfFe47gbBZ91Uka8KuOFuMIQcxPwiTwVzvDQh7N8BG2wNu3ggYm/SJGUtDZQuAQ0V
         iSOf1/Cd3LfN05/alxpNXfE8SMFZRciq1W8/YVatxJKiR76mzgGv8YE50JfoKEMt0zMh
         bp+A==
X-Forwarded-Encrypted: i=1; AJvYcCXVM2ROcAEX17AFu5UAUsmZ5xFBL81kjzrTEpppSYC0baPzuwWp8dMX+xWmN2uUzn+CJRs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpvRSz7WZNv6QhajlWgNWF2vdYFJPDq4TyYmdgzjU3LHNOp818
	5RvhO5Wtlean0S/5+wdVvKKMn3hZ7Onq3u3d82VusU+iQlL5KJFCd4t1joEs+0tJ73Kssa/nzl7
	lzA==
X-Google-Smtp-Source: AGHT+IH6y88q+TWhSZZp7tzO2YG9BcgQQjbOs0koRAZVE554McNiR1VCYsWrRPn0etG8CljUBjhc4EVbcoQ=
X-Received: from pgba17.prod.google.com ([2002:a63:4d11:0:b0:802:81:dd47])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7491:b0:1e0:d87a:f67
 with SMTP id adf61e73a8af0-1e88cfa6a76mr42712779637.13.1736893905447; Tue, 14
 Jan 2025 14:31:45 -0800 (PST)
Date: Tue, 14 Jan 2025 14:31:44 -0800
In-Reply-To: <f02fee7d-27e8-4ddc-b349-6d0f8c7919fa@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1735931639.git.ashish.kalra@amd.com> <14f97f58d6150c6784909261db7f9a05d8d32566.1735931639.git.ashish.kalra@amd.com>
 <6241f868-98ee-592b-9475-7e6cec09d977@amd.com> <8ae7718c-2321-4f3a-b5b7-7fb029d150cf@amd.com>
 <8adf7f48-dab0-cbed-d920-e3b74d8411cf@amd.com> <ee9d2956-fa55-4c83-b17d-055df7e1150c@amd.com>
 <d6d08c6b-9602-4f3d-92c2-8db6d50a1b92@amd.com> <Z4G9--FpoeOlbEDz@google.com>
 <5e3c0fe3-b220-404f-8ae0-f0790a7098b6@amd.com> <f02fee7d-27e8-4ddc-b349-6d0f8c7919fa@amd.com>
Message-ID: <Z4bl0D4CbtHgwGGW@google.com>
Subject: Re: [PATCH v3 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, john.allen@amd.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, michael.roth@amd.com, dionnaglaze@google.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 14, 2025, Ashish Kalra wrote:
> On 1/13/2025 9:03 AM, Kalra, Ashish wrote:
> > SNP host support is enabled in snp_rmptable_init() in
> > arch/x86/virt/svm/sev.c, which is invoked as a device_initcall().  Here
> > device_initcall() is used as snp_rmptable_init() expects AMD IOMMU SNP
> > support to be enabled prior to it and the AMD IOMMU driver is initialized
> > after PCI bus enumeration. 

Ugh.  So. Many. Dependencies.

That's a kernel bug, full stop.  RMP initialization very obviously is not device
initialization.

Why isn't snp_rmptable_init() called from mem_encrypt_init()?  AFAICT,
arch_cpu_finalize_init() is called after IOMMU initialziation.  And if that
doesn't work, hack it into arch_post_acpi_subsys_init().  Using device_initcall()
to initialization the RMP is insane, IMO.

> > Additionally, the PSP driver probably needs to be initialized at
> > device_initcall level if it is built-in, but that is much later than KVM
> > module initialization, therefore, that is blocker for moving SEV/SNP
> > initialization to KVM module load time instead of PSP module probe time.
> > Do note that i have verified and tested that PSP module initialization
> > works when invoked as a device_initcall(). 
> 
> As a follow-up to the above issues, i have an important question: 
> 
> Do we really need kvm_amd module to be built-in for SEV/SNP support ?

Yes.

> Is there any usage case/scenario where the kvm_amd module needs to be
> built-in for SEV/SNP support ?

Don't care.  I am 100% against setting a precedent of tying features to KVM
being a module or not, especially since this is a solvable problem.

Ideally, the initcall infrastructure would let modules express dependencies, but
I can appreciate that solving this generically would require a high amount of
complexity.

Having KVM explicitly call into the PSP driver as needed isn't difficult, just
gross.  But for me, it's still far better giving up and requiring everything to
be modules.

E.g.

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 943bd074a5d3..a2ee12e998f0 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2972,6 +2972,16 @@ void __init sev_hardware_setup(void)
            WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_FLUSHBYASID)))
                goto out;
 
+       /*
+        * The kernel's initcall infrastructure lacks the ability to express
+        * dependencies between initcalls, where as the modules infrastructure
+        * automatically handles dependencies via symbol loading.  Ensure the
+        * PSP SEV driver is initialized before proceeding if KVM is built-in,
+        * as the dependency isn't handled by the initcall infrastructure.
+        */
+       if (IS_BUILTIN(CONFIG_KVM_AMD) && sev_module_init())
+               goto out;
+
        /* Retrieve SEV CPUID information */
        cpuid(0x8000001f, &eax, &ebx, &ecx, &edx);
 
diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
index 7eb3e4668286..a0cdc03984cb 100644
--- a/drivers/crypto/ccp/sp-dev.c
+++ b/drivers/crypto/ccp/sp-dev.c
@@ -253,8 +253,12 @@ struct sp_device *sp_get_psp_master_device(void)
 static int __init sp_mod_init(void)
 {
 #ifdef CONFIG_X86
+       static bool initialized;
        int ret;
 
+       if (initialized)
+               return 0;
+
        ret = sp_pci_init();
        if (ret)
                return ret;
@@ -263,6 +267,7 @@ static int __init sp_mod_init(void)
        psp_pci_init();
 #endif
 
+       initialized = true;
        return 0;
 #endif
 
@@ -279,6 +284,13 @@ static int __init sp_mod_init(void)
        return -ENODEV;
 }
 
+#if IS_BUILTIN(CONFIG_KVM_AMD) && IS_ENABLED(CONFIG_KVM_AMD_SEV)
+int __init sev_module_init(void)
+{
+       return sp_mod_init();
+}
+#endif
+
 static void __exit sp_mod_exit(void)
 {
 #ifdef CONFIG_X86
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 903ddfea8585..0138d22b46ac 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -814,6 +814,8 @@ struct sev_data_snp_commit {
 
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
+int __init sev_module_init(void);
+
 /**
  * sev_platform_init - perform SEV INIT command
  *

