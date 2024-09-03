Return-Path: <kvm+bounces-25715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 413A89695DF
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 09:43:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED0112823DD
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 07:43:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8459D1DAC46;
	Tue,  3 Sep 2024 07:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M/OUtvAn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19DB1865F0
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 07:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725349398; cv=none; b=fTy7YxVOtZ+NP9O0Shh1RiJPnV1BI823spM5NifneIEp7FUBo0ccomS8svfG7HQYgyfp6pSlydADTI0ENzgUcRPPLKtkC8QLyqdKuonqIOKd+5bdsFKSLr0iQMB1n5CBtUA1ooFlxKVBX3zeDfYQSkJ2xdGsDVlVV36+yo5H+Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725349398; c=relaxed/simple;
	bh=3VSt6q4cs8KHilwNRYKzdiczROHYLKuEKWV6imZTmfA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JV+Z9EKPDTqQ7o3MPuULVTgaJrJaIK/RF3FDZIUCk+rHC6ydkL+RI+txxJd/5dYg8sA54n30n9Mvyr/nPJsEA4vpC6wuwFHFGzYT07q2JxJcW293Aq1KLl6wD0X4HqZXf9Ct11ffZVCTJJr1N/MfDFqKZ0Gy2eLADVlcUlx6R20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M/OUtvAn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725349395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1AwvxU2FuOYSnLn87kkYf7HRlnU0avXnduIOEZLfLtA=;
	b=M/OUtvAnW9UXPlWESJt+yAnOL46dOZeHwI75L910Soae/79N/sC3+IJLGKnZLIUH4xDT3S
	b9EAQYZxzu/X4+Zhs+QJmAXWh22TRtFf9G5Xahk3JqKWK509jIwdlvhT+5X2w8zB48IOnc
	vTCqHi7Qxi/WsEgn0wR7EhSjHhPUdn0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-504-HXG-J9ptMhmlq6FncBX8BA-1; Tue, 03 Sep 2024 03:43:14 -0400
X-MC-Unique: HXG-J9ptMhmlq6FncBX8BA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a8698664af8so717968866b.0
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 00:43:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725349392; x=1725954192;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1AwvxU2FuOYSnLn87kkYf7HRlnU0avXnduIOEZLfLtA=;
        b=ldkLJ6WiAY8r8Pooi8ylnSqgAlWOSGb3uNtBQBTOUUZGGIMQt9RqheaJKE/K8Lcxke
         7/LCZqAoSMpAVKnfzVV+JcmxYjlnNhkjsrR1uwHbJ4LxLre2+WXObCwD76xWuWRGIirU
         RbYbNfH3UgbNxfluilsbEKfCXaV2umom1q1GXSptUS5ueOL7Ka/0Ek/E95m6fFsbgroz
         R/Gg/XNDE5ysydOB2K54F3d8FfJuJqbq7MToWB+IXbv4JPQQ24P5cBh1friUTvYfNXJI
         dj7JUeY9hpYfhDjnceIzWpgzz0IY34qh6Q5HDwCyDZ1RZq4zYk+vxP4UvvBs1p7Abqor
         7BBA==
X-Gm-Message-State: AOJu0YxiJzYFIY1LPsfBr93i0lsRnZ8IsRc9PITDfLfQ57HvVjUIN6K2
	DG85wth+9G7oOrDWNQleGGAUhLJNsk7oF7kMdDw4RrMI61/sqdBLY8YmHq9OaJnnelzuezoBTfd
	D3ZU9IkUk96EUvrlMSU0GImnAAqjhDOS3LyiPS28DCfv7MJjd8CKq6xX8xuai
X-Received: by 2002:a17:907:9726:b0:a7a:ac5f:bbef with SMTP id a640c23a62f3a-a8982833612mr1566268066b.31.1725349392613;
        Tue, 03 Sep 2024 00:43:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFxAPJPwSoWCLXS336TviAXav/oIrctZZtj/CPGQfhgefyOseoxvyBCRE6rzeKph/2mklaCkA==
X-Received: by 2002:a17:907:9726:b0:a7a:ac5f:bbef with SMTP id a640c23a62f3a-a8982833612mr1566265366b.31.1725349392109;
        Tue, 03 Sep 2024 00:43:12 -0700 (PDT)
Received: from [192.168.10.47] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a8988feaf05sm651137366b.33.2024.09.03.00.43.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2024 00:43:11 -0700 (PDT)
Message-ID: <32332f54-0c20-434c-be43-e4e00bcebe29@redhat.com>
Date: Tue, 3 Sep 2024 09:43:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kvm/i386: fix a check that ensures we are running on host
 intel CPU
To: Ani Sinha <anisinha@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20240903071942.32058-1-anisinha@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240903071942.32058-1-anisinha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/3/24 09:19, Ani Sinha wrote:
> is_host_cpu_intel() returns TRUE if the host cpu in Intel based. RAPL needs
> Intel host cpus. If the host CPU is not Intel baseed, we should report error.
> Fix the check accordingly.
> 
> Signed-off-by: Ani Sinha <anisinha@redhat.com>

It's the function that is returning the incorrect value too; so your 
patch is breaking the feature: this line in is_host_cpu_intel()

return strcmp(vendor, CPUID_VENDOR_INTEL);

needs to be changed to use g_str_equal.

Paolo

> ---
>   target/i386/kvm/kvm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 11c7619bfd..503e8d956e 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2898,7 +2898,7 @@ static int kvm_msr_energy_thread_init(KVMState *s, MachineState *ms)
>        * 1. Host cpu must be Intel cpu
>        * 2. RAPL must be enabled on the Host
>        */
> -    if (is_host_cpu_intel()) {
> +    if (!is_host_cpu_intel()) {
>           error_report("The RAPL feature can only be enabled on hosts\
>                         with Intel CPU models");
>           ret = 1;


