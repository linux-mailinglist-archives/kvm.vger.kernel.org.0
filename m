Return-Path: <kvm+bounces-9388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A33A85F939
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 14:12:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7369C1F23E88
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 13:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7A28134721;
	Thu, 22 Feb 2024 13:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WzTycjLF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79527133401
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 13:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708607528; cv=none; b=W0n5vzGUWloJOYWV8GhKmpD1g5XCtscyaxqNwWL7DyhzfeqTSrSKaToWiik1BS7CCAIfFEqY1vRSsAWmENkosumA2yD+QHLgGJ3Ta6eOsdkCFb4KuL/raywMQFnhsws4X6jySQoQqaIwgOyDR9JmFmismF8xVSEDSgh8ynxtSDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708607528; c=relaxed/simple;
	bh=d7GxfWu0hOLiqtwL12cDWRUaRJ6roFwQ+Ebn69wNex0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IqyZz54bPAV9tc6rZnOu5lix9wXPknN3Vfsm8bccnAEXpwhdVfea+CCNFz5NdS8myXrrPGJdgJDdJH1K5NJDeaA3EK6S2UhwKkpuoWPOb7wx2/wO0YKE1Pn14TCnj60KHQij9eA7P6YWoy35TG5zgE2ZuUP2wkL7Vmqv/2y2QO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WzTycjLF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708607525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qJa349TyQ3HXyk6B6kMqS2JJAYZDV7asae/y3BzFFf0=;
	b=WzTycjLFREmayrDAmD4B2bebNrYZlVcTL5eSZzYH6OvFlbeLpObXQCUm1fnAgkt1VwXJJE
	ADNchqtjIy4OR06DhwrM2/u+LWQZFpU75lp+Uqx29LuKcRswqA9yYCbmzW2v6x+bdhW/QW
	XHyYbxdWNp5qzYSHzgGBAoz4MG50X9w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-ZPe-FjhZPEuoMPxwYGq8RA-1; Thu, 22 Feb 2024 08:12:04 -0500
X-MC-Unique: ZPe-FjhZPEuoMPxwYGq8RA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-410422e8cd1so33274835e9.3
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 05:12:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708607523; x=1709212323;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qJa349TyQ3HXyk6B6kMqS2JJAYZDV7asae/y3BzFFf0=;
        b=XAu24XcIkuLcrNyaiOlkZyoguoX3xTDFCVtjFEgt85jSQh15voWzRc1IuThFkU5K7X
         09MOBn0OeZv04nS75DxbT5OLRXpRX52kDj14Gar3ayvOquCgf5tSfIAhUsWubFTonGyH
         gfmjynETq37HMfyRe8Ll22rIVlQmzEJ/tu0cnatB89itzF3FON1l8j1+VnmZPOrfhwJv
         xAOuYJR44Y6PqrikA+nHa/AJmF6kADNy6pprzr7lmLw0bJ/DCBUWp33Kqp0/dUBIILyo
         kxYlGeiQ+O7ktll2HK+vLsopkbXkDlsmt8J8zv38RM+p8+WT4qKwP+doIjuIhuXPNyj7
         Sj6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXHr6o6PPI5iUDiFQ8lgx/T0n9K5FoYh/GJqXQ87MEIVSQwBglgryFvSDVVQwqwdpv7FtjLa2OHU0mZ1CqCnmVebz9S
X-Gm-Message-State: AOJu0YyIevNDmUt8z5nZnFvlKpUlwOwEd6lchARzm3ceusqm69YPKZDb
	8XwSJUh4fGu7jq+t/Q9iW643JYr1wZbxlxfp9j0l1KO5/711ywJwyoIbPL99CMg75e36X+oU20p
	/3LhEIgcZVGB3SBp4guoad4QAHMX51xUWFBPGXNdABlR1lxOQBQ==
X-Received: by 2002:a05:600c:3c89:b0:411:a751:322b with SMTP id bg9-20020a05600c3c8900b00411a751322bmr17553392wmb.18.1708607522796;
        Thu, 22 Feb 2024 05:12:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGjYaEP1TbxlBP3wGyKyDc2nwyTYyDMsDzAKGuirtPW3JtZlQTY8ri9/3btPvbZqj35xEAr6Q==
X-Received: by 2002:a05:600c:3c89:b0:411:a751:322b with SMTP id bg9-20020a05600c3c8900b00411a751322bmr17553371wmb.18.1708607522440;
        Thu, 22 Feb 2024 05:12:02 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id ba20-20020a0560001c1400b0033d640c8942sm10250452wrb.10.2024.02.22.05.12.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Feb 2024 05:12:00 -0800 (PST)
Message-ID: <b9d9a871-ba64-4c13-a186-0c60adc8d245@redhat.com>
Date: Thu, 22 Feb 2024 14:11:59 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: linux-next: build failure after merge of the kvm-arm tree
Content-Language: en-US
To: Stephen Rothwell <sfr@canb.auug.org.au>, Joey Gouly <joey.gouly@arm.com>,
 Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>
Cc: Christoffer Dall <cdall@cs.columbia.edu>, KVM <kvm@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20240222220349.1889c728@canb.auug.org.au>
 <20240222111129.GA946362@e124191.cambridge.arm.com>
 <20240222224041.782761fd@canb.auug.org.au>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240222224041.782761fd@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/22/24 12:40, Stephen Rothwell wrote:
>> This fails because https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/commit/?id=fdd867fe9b32
>> added new fields to that register (ID_AA64DFR1_EL1)
>>
>> and commit b80b701d5a6 ("KVM: arm64: Snapshot all non-zero RES0/RES1 sysreg fields for later checking")
>> took a snapshot of the fields, so the RES0 (reserved 0) bits don't match anymore.
>>
>> Not sure how to resolve it in the git branches though.
> 
> Thanks.  I will apply this patch to the merge of the kvm-arm tree from
> tomorrow (and at the end of today's tree).

Marc, Oliver, can you get a topic branch from Catalin and friends for 
this sysreg patch, and apply the fixup directly to the kvm-arm branch in 
the merge commit?

Not _necessary_, as I can always ask Linus to do the fixup, but 
generally he prefers to have this sorted out by the maintainers if it is 
detected by linux-next.

Paolo


> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 22 Feb 2024 22:31:22 +1100
> Subject: [PATCH] fix up for "arm64/sysreg: Add register fields for ID_AA64DFR1_EL1"
> 
> interacting with "KVM: arm64: Snapshot all non-zero RES0/RES1 sysreg fields for later checking"
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>   arch/arm64/kvm/check-res-bits.h | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/check-res-bits.h b/arch/arm64/kvm/check-res-bits.h
> index 967b5d171d53..39f537875d17 100644
> --- a/arch/arm64/kvm/check-res-bits.h
> +++ b/arch/arm64/kvm/check-res-bits.h
> @@ -55,7 +55,6 @@ static inline void check_res_bits(void)
>   	BUILD_BUG_ON(ID_AA64SMFR0_EL1_RES0	!= (GENMASK_ULL(62, 61) | GENMASK_ULL(51, 49) | GENMASK_ULL(31, 31) | GENMASK_ULL(27, 0)));
>   	BUILD_BUG_ON(ID_AA64FPFR0_EL1_RES0	!= (GENMASK_ULL(63, 32) | GENMASK_ULL(27, 2)));
>   	BUILD_BUG_ON(ID_AA64DFR0_EL1_RES0	!= (GENMASK_ULL(27, 24) | GENMASK_ULL(19, 16)));
> -	BUILD_BUG_ON(ID_AA64DFR1_EL1_RES0	!= (GENMASK_ULL(63, 0)));
>   	BUILD_BUG_ON(ID_AA64AFR0_EL1_RES0	!= (GENMASK_ULL(63, 32)));
>   	BUILD_BUG_ON(ID_AA64AFR1_EL1_RES0	!= (GENMASK_ULL(63, 0)));
>   	BUILD_BUG_ON(ID_AA64ISAR0_EL1_RES0	!= (GENMASK_ULL(3, 0)));


