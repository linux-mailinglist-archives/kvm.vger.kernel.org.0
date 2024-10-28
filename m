Return-Path: <kvm+bounces-29825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 623459B2A7A
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 09:38:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 857B21C20D3E
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 08:38:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2473191F84;
	Mon, 28 Oct 2024 08:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HkUwYlXu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B88D19047C
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 08:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730104679; cv=none; b=OlYazoKW5pgCxuiwIpytIKwVVFpVo2i1LAW7N7C+07pu1KNR80mXRBKI3Vt7Gg8O+7RTxSoEsPtpk+QYJjjgeu7MEMHUtDAVpDcSRw5ZnUShdFArbyHpUSBzbYG3/d/kilB3ERrvZtzqjUMgnMqH0YHoxduRPq4o/G4kxvBUwy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730104679; c=relaxed/simple;
	bh=D3OUigFhjRD6EmpqxF2HWPvy5R+JEBM70Ex47W5gP40=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OVjdhguN8enyw6js+ZBZtfR/lgHdLDyAZJe705L3QUEXOs/U+vN1xUmP7A2HQfB2XDj8jvDdaAtkl/nEAc0E4+gsOW7RyNbhLndiLvtzQWo7bEx/uGm6ZGU7e9l8PJfpoZEJ1IuNzP4vpUc9GPrPbxU+Jq83O6f/D/e5lXK3F4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HkUwYlXu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730104676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RY1ABRLjLkvXF8gaN0ioWPJwQqdicQnkO7mCEKvqIhc=;
	b=HkUwYlXuq4ioGOLOIcbRuz3Xpqp0xUZQkwOe+T/ZLInAxjFTfWTlbhf2iM9L4YhGSABjvJ
	kAtXyXlksTta6FtjW5nyWrAZ6Av+OzOwdWs04I3fyqKQEanXNNRfTjbLhzgpwqZfhyE9zw
	wgVa+gC06O0JlGJ9GEcifVK2duFQ80g=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-361-XmfXZ9xVP5GibrTI1N5zwA-1; Mon, 28 Oct 2024 04:37:54 -0400
X-MC-Unique: XmfXZ9xVP5GibrTI1N5zwA-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-53a246ecb7bso3040745e87.2
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 01:37:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730104672; x=1730709472;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RY1ABRLjLkvXF8gaN0ioWPJwQqdicQnkO7mCEKvqIhc=;
        b=prd6e3cXm2ZEKZWOlXNqqDFdcswVsfg6WSvNBrqOOOiHtDBkJrhE+OOGSX9vHh/smM
         W7XIzQ97br8pdiqFYqjOPwdCMFMCdh0+Y5ZWLnugLP8OmLA201RPxpK5TN20qPCeyc/D
         B1rXeTelkJU0lcj16b4jkiAo+mM1kW+GuUfBB5XgeDcNo9aS0qfGZm7BWhOmWiA+yjvU
         4uIJoeswzf8h14QqImGEQLwoAIVZhzauCv3pV6n24Cx9lTElRtAegai/XrdyIxM5p2NR
         DPyw3A+WMfN3h3CyOT6mnQRBzkLigx9ZDE3eSuwh3Q92crQ72yizcqh/kpx8UzrJ5Bfv
         fcMQ==
X-Forwarded-Encrypted: i=1; AJvYcCV14jbZDtnSxLmDSa9Fq/YZOY6OW0KRD2Y0UfYvmEaoUFJk9BF4SwZXst2/E9E0f3M24Qo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQSClW8meb4wG9QVsoQDtxyJfg63Hj7eco6Btxvi6C+SX4uQNA
	xz036pbc+dg8nZL5oUmTfsE6wWmSAqo3F9AVGauGEbKD+hW2ZsQ8VgcIVwu/9mW8OJImF+Yo3IV
	+6HVWLSaphjk9Miwxqsq7bd4udBTaZ4i0ry32iuNyDOCI18u9atyufKATqhUN
X-Received: by 2002:a05:6512:3b91:b0:52e:e3c3:643f with SMTP id 2adb3069b0e04-53b348c6ffcmr2321005e87.2.1730104671842;
        Mon, 28 Oct 2024 01:37:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFOq4MiF8TCFj1BNE++QMkF/v8IAqU+DpzD0MN/ig4TzeNEfXQ5RUp0fq3mv4Sk4XWRjqb0pg==
X-Received: by 2002:a05:6512:3b91:b0:52e:e3c3:643f with SMTP id 2adb3069b0e04-53b348c6ffcmr2320983e87.2.1730104671329;
        Mon, 28 Oct 2024 01:37:51 -0700 (PDT)
Received: from [192.168.10.3] ([151.49.226.83])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38058b1cc0asm8944578f8f.10.2024.10.28.01.37.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2024 01:37:50 -0700 (PDT)
Message-ID: <b4b7abae-669a-4a86-81d3-d1f677a82929@redhat.com>
Date: Mon, 28 Oct 2024 09:37:49 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/7] target/i386: Add support for perfmon-v2, RAS bits
 and EPYC-Turin CPU model
To: Babu Moger <babu.moger@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <cover.1729807947.git.babu.moger@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <cover.1729807947.git.babu.moger@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/25/24 00:18, Babu Moger wrote:
> 
> This series adds the support for following features in qemu.
> 1. RAS feature bits (SUCCOR, McaOverflowRecov)
> 2. perfmon-v2
> 3. Update EPYC-Genoa to support perfmon-v2 and RAS bits
> 4. Support for bits related to SRSO (sbpb, ibpb-brtype, srso-user-kernel-no)
> 5. Added support for feature bits CPUID_Fn80000021_EAX/CPUID_Fn80000021_EBX
>     to address CPUID enforcement requirement in Turin platforms.
> 6. Add support for EPYC-Turin.

Queued, thanks.  I looked at 
https://gitlab.com/qemu-project/qemu/-/issues/2571 and I think it's 
caused by the ignore_msrs=1 parameter on the KVM kernel module.

However, can you look into adding new CPUID_SVM_* bits?

Thanks,

Paolo

> Link: https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/programmer-references/57238.zip
> Link: https://www.amd.com/content/dam/amd/en/documents/corporate/cr/speculative-return-stack-overflow-whitepaper.pdf
> ---
> v3: Added SBPB, IBPB_BRTYPE, SRSO_USER_KERNEL_NO, ERAPS and RAPSIZE bits
>      to EPYC-Turin.
> 
> v2: Fixed couple of typos.
>      Added Reviewed-by tag from Zhao.
>      Rebased on top of 6d00c6f98256 ("Merge tag 'for-upstream' of https://repo.or.cz/qemu/kevin into staging")
> 
> v2: https://lore.kernel.org/kvm/cover.1723068946.git.babu.moger@amd.com/
>    
> v1: https://lore.kernel.org/qemu-devel/cover.1718218999.git.babu.moger@amd.com/
> 
> Babu Moger (6):
>    target/i386: Fix minor typo in NO_NESTED_DATA_BP feature bit
>    target/i386: Add RAS feature bits on EPYC CPU models
>    target/i386: Enable perfmon-v2 and RAS feature bits on EPYC-Genoa
>    target/i386: Expose bits related to SRSO vulnerability
>    target/i386: Expose new feature bits in CPUID 8000_0021_EAX/EBX
>    target/i386: Add support for EPYC-Turin model
> 
> Sandipan Das (1):
>    target/i386: Add PerfMonV2 feature bit
> 
>   target/i386/cpu.c | 222 +++++++++++++++++++++++++++++++++++++++++++++-
>   target/i386/cpu.h |  27 +++++-
>   2 files changed, 242 insertions(+), 7 deletions(-)
> 


