Return-Path: <kvm+bounces-72271-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YGnBEtyKommK3wQAu9opvQ
	(envelope-from <kvm+bounces-72271-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 07:27:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D8501C090B
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 07:27:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F21DB303850B
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 06:27:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAC38343D8A;
	Sat, 28 Feb 2026 06:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PP3w85Yp";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sCwO3yJV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473A5278779
	for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 06:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772260049; cv=none; b=id+DB7SyvXAyMJ0x2NbGvN/8tIyMrGxCVjwDj3HdQSTJOo/9tbXNXivGIel4PRA4tO2Wa9gsclxC4qYdxiKyBljiMAFn3LcMAibpKUq9Wh4scQV18QsuuTA6m4QbGuDK4Nt/8455bSV9wbsI2j9/Kh4CwvXXeHfD8avNNFT3mHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772260049; c=relaxed/simple;
	bh=Algz3X/C0x3bfuWfFzdXKjp6mqsR19eIZA8vaIazmQI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aqt0O+gHC2sbN0c6ankxXe6Iuvge5i+5ThCIb6+KG5cjAJ0EOtcY/grQjNfOIrD7QER0ruljN1GgxyfhEQ+v7SmJnljMHIwM47r0AS0NCAhlrgvf4CGD71C5G2rLUQTm9ECQS8VVlS/33TOlSI6tf3ZakQbkYfgYaHTB3FJe2EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PP3w85Yp; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sCwO3yJV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772260047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CFOKSbv5jm8kZsAOb2q3dXX8LS174LwOwucnJ7t0sAU=;
	b=PP3w85YpNOlaDBRDkoXkKWsq1CiX7/aDkC4vRFfwSQnRj+S/d93K6JRxe7wUDRrL4Gqz9N
	bB1eVHpYv2XAveXt70X4gkYRLIX/JZ1nx58yuR2VTjUWI9kvDQECxI4XEgXQz0sSkZB5FU
	pOEJtgw/MdrxSWbilRk77SB/omT61Og=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-GRw2tZYtMCSkjf5ybm1xbA-1; Sat, 28 Feb 2026 01:27:25 -0500
X-MC-Unique: GRw2tZYtMCSkjf5ybm1xbA-1
X-Mimecast-MFC-AGG-ID: GRw2tZYtMCSkjf5ybm1xbA_1772260045
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4839fc4cef6so35390945e9.0
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 22:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772260044; x=1772864844; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=CFOKSbv5jm8kZsAOb2q3dXX8LS174LwOwucnJ7t0sAU=;
        b=sCwO3yJVyqNxdKn4IdYlgMwrulBnrZRjnVUCOhRPMyqod/7miV4x2rxMdl3lK/DJeg
         8wHtWfMvzvkGCUXUqN1BS4eki7ddJcYmv4/RNqgUPbO24WGVDQNS+3E0ppGj4EUH1gpo
         WpLFCVbMMnsDzHv1DFzcgcFJ3Hsvn9X6KZp1r2vUFhGQerhBv5WRunDPQPKo3chhpOr4
         jBxuz4PtZl077nOkGa67B+kXldOgP59P6fgvzA/O6fpk85K7N0gDYDPC/JGYNWWuJeEG
         3O7AElW4uiwOPfrkeyBbMo5+zXBHfMkQc2c8MYR0p6/CgKPTCW88FV2/KLkHKIf6pYp1
         bhSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772260044; x=1772864844;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CFOKSbv5jm8kZsAOb2q3dXX8LS174LwOwucnJ7t0sAU=;
        b=NIE0HQkJC0Y/8d6oYbjBWu3JDOckZKS2SE4AVeYlXW6GevyMSdydjola+3/Yeg1GUK
         P1enrQdG4uBaRs0OQcm0pI5piwGtdEUeAnv8EMUZI0ttjFL/Il2agJJb7wyFPwBEtZ6o
         5sVLbIDvairEJNRN3NZh13/GMg8n3rlRuzl9R1eXSNOmfhjvKV/gpdk0K22KZO078QD/
         p86Fb9r8VoZD5VRh9ENz943tYt27An32xyOEdIz52ekH0ImimAzthIruiHvzZl3HaPnC
         ILxfQ9vKDClIfInVm9SePiwSszJ7Vz7QaTWfoI+KD+TPU1seVcGQ6HFS8p0x+KHvjNGC
         1oZA==
X-Forwarded-Encrypted: i=1; AJvYcCVGqsGlFI81WV/0OtZOncmZ4HZOyBuJnSVECR7GpxWcKjSxk5qph2kB8EllLkG2F4gC1pU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8hm6zVjLTL5FkAiOjlhhlG2vLDAugXMsl5b8TUbm9P17L89Ik
	my4JQyg3Mmjm3pYsE0uM8286l1LegY2JwwJtW/+DSnDD9AyNIKa+wdQnbZroHXdDqYgSrcWUy2U
	VZ1TN4KUoxwFeQniBE+cNiXz2BwgwelbemfT7zekLJtSLc5QK6cCNzQ==
X-Gm-Gg: ATEYQzyLokyIc/hI+XWI8ZmRND6OXkNp1ksPQmbbh2kYOpyzJ7Lm72YRVInyE7AMOhA
	M1XlykaVNBbKZbsLdqQBB+440dwQoz15L2RaH9T0kSkSdp0JyJ4xkzIcWsxxI4Ve8Bi3azuIO0q
	i0a+IuYsU3b4T0Uay/nFyBhuc61MoND/EogIpJLyQDoUcHVxZy7VKXWIKl/TpKbUlBNEGnQW8cU
	I59LtqRsBafVH4L91rTBFkUsgoT5p9mTBbR11HCrlyoeUs4u1pFR2ZH38PlI5vsH3J01w0BzFz8
	tEfhzT+3ygsws+zrqCqN4lZ/m3zoc9bqy0goog1W/+11do6Lg9wAsXoTonfRUU4+i51IHnVifYD
	0bz1JSxtc/nwyBo17r2ruQmV9STtHkboKlDrXdLg0mVKU+HZ2xVVW8hokp23q
X-Received: by 2002:a05:600c:34c1:b0:47d:6c36:a125 with SMTP id 5b1f17b1804b1-483c993a0e3mr90847755e9.17.1772260044504;
        Fri, 27 Feb 2026 22:27:24 -0800 (PST)
X-Received: by 2002:a05:600c:34c1:b0:47d:6c36:a125 with SMTP id 5b1f17b1804b1-483c993a0e3mr90847365e9.17.1772260044053;
        Fri, 27 Feb 2026 22:27:24 -0800 (PST)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483c3b841absm171731945e9.13.2026.02.27.22.27.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Feb 2026 22:27:23 -0800 (PST)
Message-ID: <f74867bd-02b0-40d8-98be-c22a4129320a@redhat.com>
Date: Sat, 28 Feb 2026 07:27:21 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vfio 0/6] Add support for PRE_COPY initial bytes
 re-initialization
To: Alex Williamson <alex@shazbot.org>, Peter Xu <peterx@redhat.com>
Cc: Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
 jgg@nvidia.com, kvm@vger.kernel.org, kevin.tian@intel.com,
 joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com,
 avihaih@nvidia.com, liulongfang@huawei.com, giovanni.cabiddu@intel.com,
 kwankhede@nvidia.com
References: <20260224082019.25772-1-yishaih@nvidia.com>
 <20260227132327.3e627601@shazbot.org>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20260227132327.3e627601@shazbot.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_FROM(0.00)[bounces-72271-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clg@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nvidia.com:email]
X-Rspamd-Queue-Id: 7D8501C090B
X-Rspamd-Action: no action

Hello,

On 2/27/26 21:23, Alex Williamson wrote:
> 
> +Cédric, +Peter, please see what you think of this approach relative to
> QEMU.  The broken uAPI for flags on the PRECOPY_INFO ioctl is
> unfortunate, but we need an opt-in for the driver to enable REINIT
> reporting anyway.  Thanks,
> 
> Alex


I took a quick look. The series would be a little cleaner if
vfio_check_precopy_ioctl() came first and some parts are little ugly
(precopy_info_flags_fix). Will take a closer look when back from PTO.


Is there a QEMU implementation ?

Thanks,

C.



> 
> On Tue, 24 Feb 2026 10:20:13 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
> 
>> This series introduces support for re-initializing the initial_bytes
>> value during the VFIO PRE_COPY migration phase.
>>
>> Background
>> ==========
>> As currently defined, initial_bytes is monotonically decreasing and
>> precedes dirty_bytes when reading from the saving file descriptor.
>> The transition from initial_bytes to dirty_bytes is unidirectional and
>> irreversible.
>>
>> The initial_bytes are considered critical data that is highly
>> recommended to be transferred to the target as part of PRE_COPY.
>> Without this data, the PRE_COPY phase would be ineffective.
>>
>> Problem Statement
>> =================
>> In some cases, a new chunk of critical data may appear during the
>> PRE_COPY phase. The current API does not provide a mechanism for the
>> driver to report an updated initial_bytes value when this occurs.
>>
>> Solution
>> ========
>> For that, we extend the VFIO_MIG_GET_PRECOPY_INFO ioctl with an output
>> flag named VFIO_PRECOPY_INFO_REINIT to allow drivers reporting a new
>> initial_bytes value during the PRE_COPY phase.
>>
>> However, Currently, existing VFIO_MIG_GET_PRECOPY_INFO implementations
>> don't assign info.flags before copy_to_user(), this effectively echoes
>> userspace-provided flags back as output, preventing the field from being
>> used to report new reliable data from the drivers.
>>
>> Reliable use of the new VFIO_PRECOPY_INFO_REINIT flag requires userspace
>> to explicitly opt in. For that we introduce a new feature named
>> VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2.
>>
>> User should opt-in to the above feature with a SET operation, no data is
>> required and any supplied data is ignored.
>>
>> When the caller opts in:
>> - We set info.flags to zero, otherwise we keep v1 behaviour as is for
>>    compatibility reasons.
>> - The new output flag VFIO_PRECOPY_INFO_REINIT can be used reliably.
>> - The VFIO_PRECOPY_INFO_REINIT output flag indicates that new initial
>>    data is present on the stream. The initial_bytes value should be
>>    re-evaluated relative to the readiness state for transition to
>>    STOP_COPY.
>>
>> The mlx5 VFIO driver is extended to support this case when the
>> underlying firmware also supports the REINIT migration state.
>>
>> As part of this series, a core helper function is introduced to provide
>> shared functionality for implementing the VFIO_MIG_GET_PRECOPY_INFO
>> ioctl, and all drivers have been updated to use it.
>>
>> Note:
>> We may need to send the net/mlx5 patch to VFIO as a pull request to
>> avoid conflicts prior to acceptance.
>>
>> Yishai
>>
>> Yishai Hadas (6):
>>    vfio: Define uAPI for re-init initial bytes during the PRE_COPY phase
>>    vfio: Add support for VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2
>>    vfio: Adapt drivers to use the core helper vfio_check_precopy_ioctl
>>    net/mlx5: Add IFC bits for migration state
>>    vfio/mlx5: consider inflight SAVE during PRE_COPY
>>    vfio/mlx5: Add REINIT support to VFIO_MIG_GET_PRECOPY_INFO
>>
>>   .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  17 +--
>>   drivers/vfio/pci/mlx5/cmd.c                   |  25 +++-
>>   drivers/vfio/pci/mlx5/cmd.h                   |   6 +-
>>   drivers/vfio/pci/mlx5/main.c                  | 118 +++++++++++-------
>>   drivers/vfio/pci/qat/main.c                   |  17 +--
>>   drivers/vfio/pci/vfio_pci_core.c              |   1 +
>>   drivers/vfio/pci/virtio/migrate.c             |  17 +--
>>   drivers/vfio/vfio_main.c                      |  20 +++
>>   include/linux/mlx5/mlx5_ifc.h                 |  16 ++-
>>   include/linux/vfio.h                          |  40 ++++++
>>   include/uapi/linux/vfio.h                     |  22 ++++
>>   samples/vfio-mdev/mtty.c                      |  16 +--
>>   12 files changed, 217 insertions(+), 98 deletions(-)
>>
> 


