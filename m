Return-Path: <kvm+bounces-54525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 764C4B22B5E
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 17:07:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A4D47B1155
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 15:05:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA39B2F5332;
	Tue, 12 Aug 2025 15:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bWH9o2MO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5DC3F9C5
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 15:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755011226; cv=none; b=giNdozjthOa/Z3QRWmkThA4dA5aCE0hakJceRhyBr6YsyjCksPKB5xMuf/gvN1W3yu/GSbI/MOgH6oGPvuEh1fjKGajwbOp7LB/Ja/4yq9hSwHQDhLdHplIJHJPiZrZYVFE+YWSVdPNDAUyT3THusjQhgpULs1dc4/B+WTDdBU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755011226; c=relaxed/simple;
	bh=dU2XaoyPROWY5JgE6YqFK++DH1vf16ilgO1c98wW1xY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mllx9K2UWaqU+s1QDVprxg1jkop2TP7Zh3Aqy9Jui5AcgMt+XnLJDkTHlZOJkh7O9m+gS3V9Q5qLi0+gEvZoUqqhaDzhzEfw91owvZddisP+kIs7mzwAkfjwM2OIoPqXkdl9fD5dVN/O6hpilpYADDr/OzYOqUE4wBW7CTJ9VAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bWH9o2MO; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-23fed1492f6so81314775ad.2
        for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 08:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755011224; x=1755616024; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RWVOfX09b6wMzY0hn2+O1rM/PZq+779HvmHU5dA90gM=;
        b=bWH9o2MOBbJYX+Rvg2WTanpZsEEo9QevSFkLijMJwqxkLexn9kMrvy2aEi7fIYHcv9
         DTkunC6G8eWSEz5b8RDmNGxG/JSH4n6EAR37tNkIvHp3FAT2L2OOOle7vIZTvuZqYMfF
         zYBDsf0kFNV7XcmSmsfaZHTeG9oC5h2oV/WYqx4perLjdRcxSizN0XcteNLyBkoZT6wn
         cW1xtyEEKfH02uoFIAGgOodyXvv1yW2YJ7MstcP6/XRg86mZ/smPm9I4Hlj/txR621XO
         GYUDsYoJVNFw7AgeThrCQqX1K3SezEVH5/cMO+GYC7W5pTauv2hSi7yz/4Gj6sFHcW1y
         aSHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755011224; x=1755616024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RWVOfX09b6wMzY0hn2+O1rM/PZq+779HvmHU5dA90gM=;
        b=EqJlzGor2mW5g+dt5VPz2tiXQcrRwZ/+/pdFbTsgF9Viy8wzX/7PWlSrZVNZajAwkr
         MmGHhElkVkVu4DjrrTERG5+2AKlelcnx0S65QfacVeh4TIGVZtRM6Ya/1WifKXfJ/F2n
         9ZITy3hIUxY8I4yRflASSYp9yzOWGsLDHmkPGKmGzYheVdp1/kmDNGXKMQ5RT9xF5Dbl
         efy/6DLjQ4ktdQxZzKsZbv78aly963o5pRE14yTFDXMq0Bu0yANfxnXAxQkJDknzVaod
         8zJOXghI1o8wM9Xsj5yWHS7ux7r+YTc5VbuAu0cPRG21QIww53dB3+LKwpJcZTXg9atw
         0pFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwSNKq6EsFF9V8/TA5DPv5OW7JffSdkHemNYZXd+lDBNTScu/z2/UgBSU0hX9UNxZMvdc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzuUKsUE7ZusK7E5GnX9CTox/HrvDmIw1gPNXQDpHQS0MwpUf4
	lPO+w/XS1EXMjnWG09DQxxY7lwy28VKGZiUlk2wCrj1Ru/bWUVByjrlRGlDBew3g31e0VFXbog/
	pQAadqQ==
X-Google-Smtp-Source: AGHT+IEMeP6fwbkLF/vmFUlq1jDJL82y7WP2o/xsl1PBQMg9QSTH7Goz25Fu7Bjzsr/+X7bLIrkCdyFIm6k=
X-Received: from pjqx9.prod.google.com ([2002:a17:90a:b009:b0:31e:d618:a29c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2290:b0:240:9006:1523
 with SMTP id d9443c01a7336-2430bfec994mr783485ad.10.1755011223969; Tue, 12
 Aug 2025 08:07:03 -0700 (PDT)
Date: Tue, 12 Aug 2025 08:07:01 -0700
In-Reply-To: <20250811013558.332940-1-ewanhai-oc@zhaoxin.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250811013558.332940-1-ewanhai-oc@zhaoxin.com>
Message-ID: <aJtYlfuBSWhXS3dW@google.com>
Subject: Re: [PATCH] KVM: x86: expose CPUID 0xC000_0000 for Zhaoxin "Shanghai" vendor
From: Sean Christopherson <seanjc@google.com>
To: Ewan Hai <ewanhai-oc@zhaoxin.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, ewanhai@zhaoxin.com, 
	cobechen@zhaoxin.com, leoliu@zhaoxin.com, lyleli@zhaoxin.com
Content-Type: text/plain; charset="us-ascii"

On Sun, Aug 10, 2025, Ewan Hai wrote:
> rename the local constant CENTAUR_CPUID_SIGNATURE to ZHAOXIN_CPUID_SIGNATURE. 

Why?  I'm not inclined to rename any of the Centaur references, as I don't see
any point in effectively rewriting history.  If we elect to rename things, then
it needs to be done in a separate patch, there needs to be proper justification,
and _all_ references should be converted, e.g. converting just this one macro
creates discrepancies even with cpuid.c, as there are multiple comments that
specifically talk about Centaur CPUID leaves.

> The constant is used only inside cpuid.c, so the rename is NFC outside this
> file.
> 
> Signed-off-by: Ewan Hai <ewanhai-oc@zhaoxin.com>
> ---
>  arch/x86/kvm/cpuid.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index e2836a255b16..beb83eaa1868 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1811,7 +1811,7 @@ static int do_cpuid_func(struct kvm_cpuid_array *array, u32 func,
>  	return __do_cpuid_func(array, func);
>  }
>  
> -#define CENTAUR_CPUID_SIGNATURE 0xC0000000
> +#define ZHAOXIN_CPUID_SIGNATURE 0xC0000000
>  
>  static int get_cpuid_func(struct kvm_cpuid_array *array, u32 func,
>  			  unsigned int type)
> @@ -1819,8 +1819,9 @@ static int get_cpuid_func(struct kvm_cpuid_array *array, u32 func,
>  	u32 limit;
>  	int r;
>  
> -	if (func == CENTAUR_CPUID_SIGNATURE &&
> -	    boot_cpu_data.x86_vendor != X86_VENDOR_CENTAUR)
> +	if (func == ZHAOXIN_CPUID_SIGNATURE &&
> +		boot_cpu_data.x86_vendor != X86_VENDOR_CENTAUR &&
> +		boot_cpu_data.x86_vendor != X86_VENDOR_ZHAOXIN)

Align indentation.

	if (func == CENTAUR_CPUID_SIGNATURE &&
	    boot_cpu_data.x86_vendor != X86_VENDOR_CENTAUR &&
	    boot_cpu_data.x86_vendor != X86_VENDOR_ZHAOXIN)
		return 0;

>  		return 0;
>  
>  	r = do_cpuid_func(array, func, type);
> @@ -1869,7 +1870,7 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>  			    unsigned int type)
>  {
>  	static const u32 funcs[] = {
> -		0, 0x80000000, CENTAUR_CPUID_SIGNATURE, KVM_CPUID_SIGNATURE,
> +		0, 0x80000000, ZHAOXIN_CPUID_SIGNATURE, KVM_CPUID_SIGNATURE,
>  	};
>  
>  	struct kvm_cpuid_array array = {
> -- 
> 2.34.1
> 

