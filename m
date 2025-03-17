Return-Path: <kvm+bounces-41226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19E94A64FEE
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 13:56:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15A293B2400
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 12:56:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CBE5237702;
	Mon, 17 Mar 2025 12:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HPjmi92z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DF9238145
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 12:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742216204; cv=none; b=WFBe99OqTdhCJB6oT9Vuj8K4LI5F+Aqk34caeyiqkGbwZ0OOfVzFLMKXlAThZe9X8nUEWC3UlUc9E3I0cGIipTd2ayGOBjApvPXaK+gE0qA6QWo8iL5121MLx9yVgA4CAilUPZ2mf+RtYdA7IdxtIGJ5AkpjLr9+Vrk6Sc5gWic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742216204; c=relaxed/simple;
	bh=jmSvZVqvqGW4awVg3fQykeFS9yJ46QwAr/ar28MbrZ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lx7ebmFaQSNU+h70B8h49GT9GM2ILaGkhsswq5LK2bCEOBcbsuRQZpMDykiSD5r1J9U+FZz1ZkoQ2DOJC+B9r79Cw0TFvnIxeYeONkamSPw6QzQdGD5jAXZsC07qbC+g+nS8hYIJCqL2hpkPnjgdGrDKjy+OpGsRVf7/S+eegaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HPjmi92z; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-391295490c8so445936f8f.3
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 05:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1742216200; x=1742821000; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=UbsRiFVxxEKr04+0sZxmRyyZzBNScOsNtdIZTdkDI0g=;
        b=HPjmi92zbD3EYyAX2Ahu0tU4mLaioC9slCOp+adezWJvCFYkvPjEsX7JWrVwineFza
         IRIBafAzdmkuxq5WfP9o0d2AuopxyXzfg8OX7wIUklKxTEb2VTGATqsk7hfTAfFWsUXL
         3FdxVS9HTlYwkcB0SVIUDvFki1iFk1RwFeAJuS7gQ5OU60aS8pbCySF4dTyAqWJMAaOI
         5r5rsKEFGrJpArMgY41YiNKEW7cSxsZIhIAjisY+BhAdyPHSYUOYxFwQtxI7xA1r6G0r
         zLW3jGFSJNRM6AbWjmaGT2I0I41ZDJhG/CiDXpDdMAhzyAB3e93t5RCrU0q2k4g+8NPc
         f4YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742216200; x=1742821000;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UbsRiFVxxEKr04+0sZxmRyyZzBNScOsNtdIZTdkDI0g=;
        b=bCE2mcxpaVUJPZbyWXNdGdwxqUcnzeZz48Y2gkFST2sxdabYykeZ8xFpRayKHiHkSS
         BegKUsmY8tLytVgFBWlA/VPVgndmspHuV+LuuRlqflluHNres9QKhBgUTMwV5NVGi5L7
         RhxOFj0S8anDrdQnILRgKEQjCZFTOjvNvSWD7nr4JvPsoldjWVGO7tzILfhwY944weeu
         eSp3sxlJxarpoZk8PsJpyLN53I8at64jSR9BkHUZMvZTZDzA1B2zQBUckHO7awtXo+54
         IXdN2O0trvdMLVsbEpHQJnnWt0R3zRRK3TOKgHhZpZ178cNGjW/u9pQ6w5oGDVz27YS8
         gV6A==
X-Forwarded-Encrypted: i=1; AJvYcCX9EZYImQbQYkfM3/8gg1tmWvXvdxL/u2PeKf3QNDWI1rrJK9trdO9bBj9SZdBO2++Kwes=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeA3SMHq2A5YpIlUtD0Qr+26WERXeMm7StDN/eXl9i7cxt355/
	p9xzu6TkmeB1AJRZss8Og4pxkY3QuHTVP/TqCxxZvc3jaNJhoNIb4OS4ljRu+KU=
X-Gm-Gg: ASbGnct0UvSzLG9yzv68liAYZi3N9KQ5vloSOafe3DsSKQWcpTJtv/FulFvLjjwXqq2
	OJwgDefnqMRw6RNLMwytLX0r747ZhGtsNO5IIuf/NQaDncLCUF6qrzPJSxv356AQGIoxDd+kIDF
	PfvZg1Xn3hqfUczLfyojFebu0w9n/MzKXDVX63n/XsQBHaaUFgo80L6fAIjvEGktaA8/+dltdKj
	RcFBfBu7xazLW0qSIAe6AT+p1JohIy7RE775rtRFODJxmyi5S0GLQcI26Ex+B7ZmboAiuL+5kr5
	HnB1N9pRHD4gQM6JBlPIqYUVtUdXKl+LhRsifx07HW1dD7hEcB/q4t8nNA==
X-Google-Smtp-Source: AGHT+IEhJ3LmO+4u3/G7N4x9UiTZCPKO+aKmqtzgBg0oVKBS/T5lLgd0TZhrKYCVxyopEHEecvC5Cw==
X-Received: by 2002:a5d:59a9:0:b0:382:4e71:1a12 with SMTP id ffacd0b85a97d-3971d239c31mr4786172f8f.1.1742216200078;
        Mon, 17 Mar 2025 05:56:40 -0700 (PDT)
Received: from [192.168.178.35] ([37.120.43.178])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-397f2837e61sm9529434f8f.97.2025.03.17.05.56.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 05:56:39 -0700 (PDT)
Message-ID: <fd404afa-7a42-4fa9-8652-519649482d75@suse.com>
Date: Mon, 17 Mar 2025 13:52:58 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/4] Enable Secure TSC for SEV-SNP
To: Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: thomas.lendacky@amd.com, santosh.shukla@amd.com, bp@alien8.de,
 isaku.yamahata@intel.com
References: <20250317052308.498244-1-nikunj@amd.com>
Content-Language: en-US
From: Vaishali Thakkar <vaishali.thakkar@suse.com>
Autocrypt: addr=vaishali.thakkar@suse.com; keydata=
 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
In-Reply-To: <20250317052308.498244-1-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/17/25 6:23 AM, Nikunj A Dadhania wrote:
> The hypervisor controls TSC value calculations for the guest. A malicious
> hypervisor can prevent the guest from progressing. The Secure TSC feature for
> SEV-SNP allows guests to securely use the RDTSC and RDTSCP instructions. This
> ensures the guest has a consistent view of time and prevents a malicious
> hypervisor from manipulating time, such as making it appear to move backward or
> advance too quickly. For more details, refer to the "Secure Nested Paging
> (SEV-SNP)" section, subsection "Secure TSC" in APM Volume 2.
> 
> This patch set is also available at:
> 
>    https://github.com/AMDESE/linux-kvm/tree/sectsc-host-latest
> 
> and is based on kvm/queue
> 
> Testing Secure TSC
> -----------------
> 
> Secure TSC guest patches are available as part of v6.14-rc1.
> 
> QEMU changes:
> https://github.com/nikunjad/qemu/tree/snp-securetsc-latest
> 
> QEMU command line SEV-SNP with Secure TSC:
> 
>    qemu-system-x86_64 -cpu EPYC-Milan-v2 -smp 4 \
>      -object memory-backend-memfd,id=ram1,size=1G,share=true,prealloc=false,reserve=false \
>      -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on,stsc-freq=2000000000 \
>      -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
>      ...
> 

Hi Nikunj,

I've been trying to test this patchset with the above QEMU command line
and with the OVMF built from upstream master. But I'm encountering
following errors:

" !!!!!!!!  Image Section Alignment(0x40) does not match Required Alignment
(0x1000)  !!!!!!!!
ProtectUefiImage failed to create image properties record "

I briefly looked at this[1] branch as well but it appears to be no longer
actively maintained as I ran into some build errors which are fixed in
upstream.

The build command I'm using to build the OVMF is as follows:
build -a X64 -b DEBUG -t GCC5 -D DEBUG_VERBOSE -p OvmfPkg/OvmfPkgX64.dsc

So, I was wondering if you've some extra patches on top of upstream OVMF
to test SecureTSC or are there any modifications required in my build
command?

Thank you!


[1] https://github.com/AMDESE/ovmf/tree/snp-latest

> Changelog:
> ----------
> v5:
> * Rebased on top of kvm/queue that includes protected TSC patches
>    https://lore.kernel.org/kvm/20250314183422.2990277-1-pbonzini@redhat.com/
> * Dropped patch 4/5 as it is not required after protected TSC patches
> * Set guest_tsc_protected when Secure TSC is enabled (Paolo)
> * Collect Reviewed-by from Tom
> * Base the desired_tsc_freq on KVM's ABI (Sean)
> 
> v4: https://lore.kernel.org/kvm/20250310063938.13790-1-nikunj@amd.com/
> * Rebased on top of latest kvm-x86/next
> * Collect Reviewed-by from Tom
> * Use "KVM: SVM" instead of "crypto: ccp" (Tom)
> * Clear the intercept in sev_es_init_vmcb() (Tom)
> * Differentiate between guest and host MSR_IA32_TSC writes (Tom)
> 
> Ketan Chaturvedi (1):
>    KVM: SVM: Enable Secure TSC for SNP guests
> 
> Nikunj A Dadhania (3):
>    x86/cpufeatures: Add SNP Secure TSC
>    KVM: SVM: Add missing member in SNP_LAUNCH_START command structure
>    KVM: SVM: Add GUEST_TSC_FREQ MSR for Secure TSC enabled guests
> 
>   arch/x86/include/asm/cpufeatures.h |  1 +
>   arch/x86/include/asm/svm.h         |  1 +
>   arch/x86/include/uapi/asm/kvm.h    |  3 ++-
>   arch/x86/kvm/svm/sev.c             | 17 +++++++++++++++++
>   arch/x86/kvm/svm/svm.c             |  1 +
>   arch/x86/kvm/svm/svm.h             | 11 ++++++++++-
>   include/linux/psp-sev.h            |  2 ++
>   7 files changed, 34 insertions(+), 2 deletions(-)
> 
> 
> base-commit: 9f443c33263385cbb8565ab58db3f7983e769bed


