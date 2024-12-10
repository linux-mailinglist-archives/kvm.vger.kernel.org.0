Return-Path: <kvm+bounces-33458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 023459EBEB7
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 23:58:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65396188A37D
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 22:57:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F920211288;
	Tue, 10 Dec 2024 22:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1KX09ao2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96731F1902
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 22:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733871465; cv=none; b=sppgMQwXorTSwpSw+45dQct8F8yrqk8SSoDANJZizITWyjmvKFwU+lejQHsgJppMDDNYMIXbja7iDLsivlgxeaPNq1SQ/gOLzZwpVFl1JHpOD3CCMiyMbF27cFiMo/FYVieLKOw+HnT7ucEJ7u7GJyU/+8yJob+f4Q4mNKd/GpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733871465; c=relaxed/simple;
	bh=t27uPK9myV2Fjkiq8KR5e2btnKMMaG7ZSU2ygrIP3dY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EG/fUNrLBD2xxzNIcAVl0PLXD9TOYCmvNybcNJIyhju6Qj3jsdz+BrPrka/VFHK8AB4Nypq1nMJcFdmIJDVDRnPPOcZ0K6ug79HeDDr8akfyB+aWYk/twg32vOuJhFlC15ejoRMjEHLVoWy3NORSuCmViXhx4956lkSpz+mKZzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1KX09ao2; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-725f4b412ecso2109357b3a.0
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 14:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733871462; x=1734476262; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qzYjzBYRpXZXvsrb769WEDw25xGLeNpQvXzkO9JPotw=;
        b=1KX09ao2rHRWnlKeUJ8GbBTwEvbeY/hxa+RIRrHMrc2yTS1T/Ac/MJq5IRsROnm/dy
         7LpGObtbl/nbuD0wyYqYKuF6HS/cP9UI3li7jHgLcSBLMEKuDmie7POsxcSMvrI/1DVi
         mcieeXIFUonNAZxNmX6LogOdEF7jelJO+91UQhH7LhsdWP9VlJcUw+r7P3/omgUbbHca
         A4Ow9zV70PMJGGdqlvisoH+KQwQKvEPs/CTcGT0JwuZv2YbyLDKxTcEIc31lUSJpT9HK
         L9TsU9ZIIRoF8R5ZJipz7ivBg0QlPJd+lCkokoAOvdjb52/K6OkDh+cjv3NYJbxWbreT
         OJ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733871462; x=1734476262;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qzYjzBYRpXZXvsrb769WEDw25xGLeNpQvXzkO9JPotw=;
        b=tPt2YQ+OMKA837tDqNzzq6KCJkZVM42ILKMKEIhemG5ADMYRXwPo+Lg8Z3xL3uxLNE
         xWIQsIygsWrhHgnLD0hkJgQp9OeyI9x28rWeVJXSN7qgIFC4Y/PI5jhtm2Bkqs2+gjDE
         wzWdZpjl1/eX2LZXqgF14SOzBOZvrlSDAh5sFd5wOXOaU1Cv+DsdXrCLUOstC6pfCX9+
         yTlfA1QRpUTwQITW1W1hsIf0YEnlYmx81xfiOWwb7UouCDijkstWpANsiNWDfV9wafPC
         iyYu/+iolBShZKOKDaUMG9cgcJ6kP2boAda8mqlwV81DfgWKNlLua5n1cOhrTWmYf868
         1p6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXQ6dGnnNDTKfKTp1obop6kn1fuMrw3ZlrCtTDNZQ2o+kme7i7QSO5KphtnD+LHE/jtl+4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6bEgcU1NqcMqOIwYayesVOJRkh7F74DwMrpdQZFyjxkH1ctxe
	n+Eg1KU9pDAflvpP4noG0iKU3Zxlb3wCJhRO2FW/qj18lL1TnMcr4Upg8U0RELbZkHuf5o9jTIm
	y7w==
X-Google-Smtp-Source: AGHT+IF6t00td5jEaIaek3MFm00Ua9Hbiy9YUHI7swlBm1m2PjANavqzv5JW0g0U8zlnt2Sc4OQTusDSogw=
X-Received: from pfbcw12.prod.google.com ([2002:a05:6a00:450c:b0:725:e93d:92a4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:cf83:b0:1d4:fc66:30e8
 with SMTP id adf61e73a8af0-1e1c125c02emr1565486637.10.1733871462184; Tue, 10
 Dec 2024 14:57:42 -0800 (PST)
Date: Tue, 10 Dec 2024 14:57:40 -0800
In-Reply-To: <0a468f32-c586-4cfc-a606-89ab5c3e77c2@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <d3e78d92-29f0-4f56-a1fe-f8131cbc2555@amd.com> <d3de477d-c9bc-40b9-b7db-d155e492981a@amd.com>
 <Zz9mIBdNpJUFpkXv@google.com> <cb62940c-b2f7-0f3e-1710-61b92cc375e5@amd.com>
 <Zz9w67Ajxb-KQFZZ@google.com> <7ea2b3e8-56b7-418f-8551-b905bf10fecb@amd.com>
 <Z1N7ELGfR6eTuO6D@google.com> <5b77d19d-3f34-46d7-b307-738643504cd5@amd.com>
 <Z1eZmXmC9oZ5RyPc@google.com> <0a468f32-c586-4cfc-a606-89ab5c3e77c2@amd.com>
Message-ID: <Z1jHZDevvjWFQo5A@google.com>
Subject: Re: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, Peter Gonda <pgonda@google.com>, pbonzini@redhat.com, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au, 
	x86@kernel.org, john.allen@amd.com, davem@davemloft.net, michael.roth@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 10, 2024, Ashish Kalra wrote:
> On 12/9/2024 7:30 PM, Sean Christopherson wrote:
> > Why can't we simply separate SNP initialization from SEV+ initialization?
> 
> Yes we can do that, by default KVM module load time will only do SNP initialization,
> and then we will do SEV initialization if a SEV VM is being launched.
> 
> This will remove the probe parameter from init_args above, but will need to add another
> parameter like VM type to specify if SNP or SEV initialization is to be performed with
> the sev_platform_init() call.

Any reason not to simply use separate APIs?  E.g. sev_snp_platform_init() and
sev_platform_init()?

And if the cc_platform_has(CC_ATTR_HOST_SEV_SNP) check is moved inside of
sev_snp_platform_init() (probably needs to be there anyways), then the KVM code
is quite simple and will undergo minimal churn.

E.g.

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5e4581ed0ef1..7e75bc55d017 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -404,7 +404,6 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
                            unsigned long vm_type)
 {
        struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-       struct sev_platform_init_args init_args = {0};
        bool es_active = vm_type != KVM_X86_SEV_VM;
        u64 valid_vmsa_features = es_active ? sev_supported_vmsa_features : 0;
        int ret;
@@ -444,8 +443,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
        if (ret)
                goto e_no_asid;
 
-       init_args.probe = false;
-       ret = sev_platform_init(&init_args);
+       ret = sev_platform_init();
        if (ret)
                goto e_free;
 
@@ -3053,7 +3051,7 @@ void __init sev_hardware_setup(void)
        sev_es_asid_count = min_sev_asid - 1;
        WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
        sev_es_supported = true;
-       sev_snp_supported = sev_snp_enabled && cc_platform_has(CC_ATTR_HOST_SEV_SNP);
+       sev_snp_supported = sev_snp_enabled && !sev_snp_platform_init();
 
 out:
        if (boot_cpu_has(X86_FEATURE_SEV))

