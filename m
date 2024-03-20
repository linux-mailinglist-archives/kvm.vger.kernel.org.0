Return-Path: <kvm+bounces-12313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBF6B881595
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 17:26:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F3837B2341B
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 16:26:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37DEA56443;
	Wed, 20 Mar 2024 16:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fkP3NkHP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB16D5579F
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 16:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710951968; cv=none; b=FqWE98lBeODtld4nyfeU+i3uCTfnzp6aQmpiZ4teNbQ7I2JW9vvOiLCOOt9LiPVdOHB67m85sgs8+BVqcpX8V+pvBZXE0orme7vxBMEh6wxz32Lor41YUsdzKXOA06gtHAdRUNrDfUEPHCBmwmjut/mZn4w6qVsSvOUdFP3aFbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710951968; c=relaxed/simple;
	bh=zT+Y3Qivz045pR+6YsoZ/22z9NQIth+Iho5aemONUcQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cuALe56hMaZYzX/R4sLxcVUFph+I9IHtjQrckL98eT8Wxfc9F8LJr2hienOdCIQxlYpaS9npf9hZciYzh67irTqt7QG/+beV+YxInaYFH4BSfiGvlRxZJL0cpC1HLKk3gJ2GqLsr1Xq0POvaCOUei1cOLCtrMTbPgoNmMl4w7Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fkP3NkHP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710951965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Q9mtthpbOAXg4sQmVeVli7IjhrEU+ZtiX0vSYDAWRFU=;
	b=fkP3NkHPGKuLxstbNZPoVO+dCyvCeOC8HaldrPmUNxBuOSi9UOwAOrYFTDNYNUkzXLfyXT
	qFT/jpN9hcR+HQ2C6TU3geDUZUUzPCFzzQvwZzHFtBz8paRt+L3WxnduqiVTEPIu4wG5sF
	EkqFH4jL2BIZMPwJ7rWF8WRahKrKG6s=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-Z7WvU2UXPiqjRQ9zEwfV2Q-1; Wed, 20 Mar 2024 12:26:04 -0400
X-MC-Unique: Z7WvU2UXPiqjRQ9zEwfV2Q-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a466c77307eso103755066b.0
        for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 09:26:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710951963; x=1711556763;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q9mtthpbOAXg4sQmVeVli7IjhrEU+ZtiX0vSYDAWRFU=;
        b=VOiyMGj9ODcNg2JmDQYosfx6tKycxLZeQ8NVhIMsJ3eFMePvdb+JUz3X0/7caIm7id
         Ykd1Xks025pKUqQYFR1rPvQBdCEK01MFkS9v4dpmsXeeR/hJ+RFM3bacMGUi/RJ93dDN
         +iPVXUQLPeZ6TGTznu5RMBOxdCxlhHV33V3ffrqwyjQwX9ydBs8qMDvyPKaXCapCvzqK
         +gSt3lmx8As17bamK+/UucNevITgDwJsNpNE1Qla8WLCDqaB/0ChdCbDHyfuIMF6GNFd
         sKtppXOt+MhO0erYgdXLvSC2nhyDFmF1NN87nboQdAhIuRjV0dHxMCIVwWcjEVvqVCD0
         Djrg==
X-Gm-Message-State: AOJu0YzLCOT21BkmMgCV4VZNIdx1vaOnIrxusnzp6B7W4k9Eal9CLUVk
	a0cPp3+udkqrhbWCzbYh16gxHcoAR1fXNihzctnm1DYTnLi61XHj8GH6IxU0jgKDvmX9/5Omtk5
	47u3x5cMrtlFAbb9MJATbc6u0feet/vXbTDB/IOQm0FqL3td2Ew==
X-Received: by 2002:a17:906:5387:b0:a46:9f12:ca2a with SMTP id g7-20020a170906538700b00a469f12ca2amr131914ejo.22.1710951963011;
        Wed, 20 Mar 2024 09:26:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECLA18nqUOxI+h+v1n/cHVmjwkTvIzsjJjO+lGm4cMUYzEvTsYkEVQt6PI24bSP3DzE+CZ8Q==
X-Received: by 2002:a17:906:5387:b0:a46:9f12:ca2a with SMTP id g7-20020a170906538700b00a469f12ca2amr131895ejo.22.1710951962682;
        Wed, 20 Mar 2024 09:26:02 -0700 (PDT)
Received: from [192.168.10.118] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id bx21-20020a170906a1d500b00a4655976025sm7391435ejb.82.2024.03.20.09.26.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Mar 2024 09:26:01 -0700 (PDT)
Message-ID: <d6acfbef-96a1-42bc-8866-c12a4de8c57c@redhat.com>
Date: Wed, 20 Mar 2024 17:26:00 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/49] kvm: Make kvm_convert_memory() obey
 ram_block_discard_is_enabled()
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-20-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240320083945.991426-20-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/24 09:39, Michael Roth wrote:
> Some subsystems like VFIO might disable ram block discard for
> uncoordinated cases. Since kvm_convert_memory()/guest_memfd don't
> implement a RamDiscardManager handler to convey discard operations to
> various listeners like VFIO. > Because of this, sequences like the
> following can result due to stale IOMMU mappings:

Alternatively, should guest-memfd memory regions call 
ram_block_discard_require(true)?  This will prevent VFIO from operating, 
but it will avoid consuming twice the memory.

If desirable, guest-memfd support can be changed to implement an 
extension of RamDiscardManager that notifies about private/shared memory 
changes, and then guest-memfd would be able to support coordinated 
discard.  But I wonder if that's doable at all - how common are 
shared<->private flips, and is it feasible to change the IOMMU page 
tables every time?

If the real solution is SEV-TIO (which means essentially guest_memfd 
support for VFIO), calling ram_block_discard_require(true) may be the 
simplest stopgap solution.

Paolo

>    - convert page shared->private
>    - discard shared page
>    - convert page private->shared
>    - new page is allocated
>    - issue DMA operations against that shared page
> 
> Address this by taking ram_block_discard_is_enabled() into account when
> deciding whether or not to discard pages.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   accel/kvm/kvm-all.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 53ce4f091e..6ae03c880f 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2962,10 +2962,14 @@ static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
>                   */
>                   return 0;
>               } else {
> -                ret = ram_block_discard_range(rb, offset, size);
> +                ret = ram_block_discard_is_disabled()
> +                      ? ram_block_discard_range(rb, offset, size)
> +                      : 0;
>               }
>           } else {
> -            ret = ram_block_discard_guest_memfd_range(rb, offset, size);
> +            ret = ram_block_discard_is_disabled()
> +                  ? ram_block_discard_guest_memfd_range(rb, offset, size)
> +                  : 0;
>           }
>       } else {
>           error_report("Convert non guest_memfd backed memory region "


