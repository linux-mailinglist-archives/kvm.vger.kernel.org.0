Return-Path: <kvm+bounces-37076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A8E96A24C7B
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 03:11:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E001164562
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 02:11:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3B471DA23;
	Sun,  2 Feb 2025 02:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ay7Z8cun"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A1F2594
	for <kvm@vger.kernel.org>; Sun,  2 Feb 2025 02:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738462299; cv=none; b=Onghe3bM16YO+YHiKONF0AHvTYsaQi6hR7bMyCnVOewyal+Ka/jDJGqj5aeAuHdzSli5v+f3xu786EMlVvWGh1FxY1JjRXmMgOW+MFp/f1mikSSyjIe5mw49vXK/WkE7FnJRon8R92SCV88EPr3K9ZuZyK9x6Ykl94F4lr9iyo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738462299; c=relaxed/simple;
	bh=f/Xz711tH686KIYj8B5uhbPaXR1gbd0LuSh4loqolqI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hPR6O2LKV38/F4qI98T8JvEAG2pkorGT8UOPEXtsjHauDF+yl59xruf76BWJJaPi24vXjnXlFeNFaFHIeiSbBZ3g3AXMJNgWSPgoz/ipAA0SIEN1Wu3GACKSjVM3CqXRkplLM3daIe38YVOox6M/VSVfO9t+YHl54xJezSd5tmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ay7Z8cun; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738462297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jz0tT2FTFLvNvj61SDsLmOkHBQ46Tt26HSOtiuLa6z4=;
	b=Ay7Z8cuniJy2H7KL4tHWi/1++8tOtG9gplccW3L/xEI+N12N6BeqxNbasXKXMbXusqMwDX
	a0LXg0Xlp9YowmrjkpHlDyzlqm6xTETSFMh6qC7ofw3aFN6IgMcawbPSkbAXBWLYDCgCeD
	VLFaKPORJ49YlhFWngl8uCSbuFXv/28=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-TG3lsV3yNcWjZbQu2tSBVA-1; Sat, 01 Feb 2025 21:11:36 -0500
X-MC-Unique: TG3lsV3yNcWjZbQu2tSBVA-1
X-Mimecast-MFC-AGG-ID: TG3lsV3yNcWjZbQu2tSBVA
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2166e907b5eso57125125ad.3
        for <kvm@vger.kernel.org>; Sat, 01 Feb 2025 18:11:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738462295; x=1739067095;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jz0tT2FTFLvNvj61SDsLmOkHBQ46Tt26HSOtiuLa6z4=;
        b=rm6B93swne71C6ZLGN70FFyuJltVj1VP3xBlbEF9ntwOVPmILz9TuOxHi2/0cFox5O
         knvUkSOj6zy3YIzmaf9JXN/jAya5w7yjnj+jCtJiRhBQeSpker5Hkt3papQT1k//RSBh
         rnrGuyAC5M5Aa9Hr4utzAjW5GEIj4j6uXoEI2a8+fgo3SVAJLIOqQezL5cFK8nsD2vlp
         uAmTIHnK/F1YdCwYZv5qu8IrNIQ+ZYRORp0C9gUn7uYL+WACBTwMwba8sHkAhedZ7NUb
         se6oHEIFcby7f2LTIHrPAbegBKGRVplYQ4hgJRgqYrWx11gr54IMNF97zWbX205W3FtW
         YT3g==
X-Forwarded-Encrypted: i=1; AJvYcCULmx5x79wmgi1ZTTeoVvuV62bAASD3FIZGQR6RA/xxksPRjaIcsIK2Uu3R8OfHWSL3LMs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyc/Ma5obxwBA2pzNk6ZtZz3LW65qXt/U1Y3eluLw3cjGL54qbM
	fQvKjWtzyJKVNHOuAkO0eFVihpBYt5ShUdzqaLU5+QOYkvdAIpjK+leVt5YzrIEXV82oJ2wJrJD
	UnbS+hRqO/NktRv+fIppYslByrbMMEoL7iFweTxYB5IjG65tU7A==
X-Gm-Gg: ASbGncvoyOtvO5p2dbtn94iijHZUPNKueH6rQgXmSGpUwd+eXKe3CD5ZIdY3CheLi1g
	jT30eknszjk6wiWXPzBTqfhOV4U/YACxXiQ0kJ0+avEFuodhctgLoaD0PyuYaydYo9cWnLM50/x
	0XO0NtfIVp88yPMLVYiDZMyeEcqTWlVEuulrumgXNnhblR81+D+ctEDKZ1IrZc4n+aGRd3wJlEm
	pCu5f7EXka2EOiMR1VAX8+4pbRQ06wHulc8qvmS2slrWZNQpK/l5rSkMa2sVTAa6Jx3PqZNaQhb
	ErtOfw==
X-Received: by 2002:a17:902:ec90:b0:21c:15b3:e3a8 with SMTP id d9443c01a7336-21dd7db9401mr253960085ad.37.1738462295038;
        Sat, 01 Feb 2025 18:11:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEznBpra764QOyQOK6CFRr1iAthLIwu66BAhbI5avSF//jD31IMMeDXBhhitA9mMZwWv411Bw==
X-Received: by 2002:a17:902:ec90:b0:21c:15b3:e3a8 with SMTP id d9443c01a7336-21dd7db9401mr253959935ad.37.1738462294746;
        Sat, 01 Feb 2025 18:11:34 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21ee2bae0a5sm24864345ad.19.2025.02.01.18.11.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2025 18:11:34 -0800 (PST)
Message-ID: <8606c5b1-075e-43c8-a58e-bfd5b90f3dcb@redhat.com>
Date: Sun, 2 Feb 2025 12:11:26 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 24/43] KVM: arm64: WARN on injected undef exceptions
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-25-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-25-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
> The RMM doesn't allow injection of a undefined exception into a realm
> guest. Add a WARN to catch if this ever happens.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/inject_fault.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index 611867b81ac2..705463058ce0 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -226,6 +226,8 @@ void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
>    */
>   void kvm_inject_undefined(struct kvm_vcpu *vcpu)
>   {
> +	if (vcpu_is_rec(vcpu))
> +		WARN(1, "Cannot inject undefined exception into REC. Continuing with unknown behaviour");

May be more compact with:

	WARN(vcpu_is_rec(vcpu), "Unexpected undefined exception injection to REC");

>   	if (vcpu_el1_is_32bit(vcpu))
>   		inject_undef32(vcpu);
>   	else

Thanks,
Gavin


