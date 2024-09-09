Return-Path: <kvm+bounces-26122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B819971BDE
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 15:57:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA0542815A0
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 13:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C0931BA896;
	Mon,  9 Sep 2024 13:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eWuPA7Eb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FEB17837E
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 13:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725890018; cv=none; b=mAQZidV67jNiu2SZTv1mm4Cs4BlP0CNSI23F+OovA4XGu+zZ/wEekfE2B/A7itfTrV+9nOO2cuYsk8l2BQrtQXCxOSXJMo8GhF+1+LDejm/wuT3RvzXm2IIZe+zwhcE1nyzBlWTAWKmURPjtX8IXKkK21VCJOmt8zSd+TZkKGdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725890018; c=relaxed/simple;
	bh=6lpFZDhVrG3/GaSlPVPc98y5Bs5EC0xSL82X/4smWvI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vn9Yo3xBe0qb6kbm0L2lqwr/ZnPWCADEIjwyRLYWcCfaYgtWruHIqwzvjnQNtdMULluQVvLNkll0RfmKdmx6gsJ6MgNziq0Z+nTnAq9jveXgmc0U4wFDmYrg4Ihnqsed3h8R9tt5lGxpzajMBDUQ+7Vk70DCqwA+PM8YmEH4ckg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eWuPA7Eb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725890015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IsQRnE8iGkIDPevlzlo6+DQHj8Ph1msQbFaOs1yRsTg=;
	b=eWuPA7Ebv7mq6nGkgLxaIcPaxB3T8KXJ5cEzacWU25iw1PwQm9CNb3zgZT8BZyV56CdSIf
	fn+ztbKvvp4qaFFg1pvnVhNIq86c4qwaujnVop8xeSChP/5J7w7WGgd+npZvUkavaHDzXT
	epgjbFhlWD47UU1LWcyB14M5jmp0NNQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-RViHlMXTPgSjQC357vf4ig-1; Mon, 09 Sep 2024 09:53:34 -0400
X-MC-Unique: RViHlMXTPgSjQC357vf4ig-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-374c3402d93so2431423f8f.0
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 06:53:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725890013; x=1726494813;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IsQRnE8iGkIDPevlzlo6+DQHj8Ph1msQbFaOs1yRsTg=;
        b=BbHRXgkzhDyBu7+Fyp71UNfjOkxa6RIHZfSwSuXgLFWsih+GFen0ve8DKLw3XMQtyf
         UMrKiFwpLEhFp6gKql/QUe03pgBPPDXiSwlVfhtCcNWVkscHyIkUJ7pAMCREBnIykoXf
         aX4JxZNSqnCtMQ7D6vt2uHz2vePpWDljTBsM6xhlWIw9WW8BQVxiCc7I57ndScImhQcj
         kxbT/NyESLi61PhQ131KlvUhmtMXdT+yesEtte6nfqz2RNsy5HWKLE68wzvQ4qDPayiW
         mKBU6ujLHVkPvWlvc6UTx6oPg8KmyG0mbLsaueeoZffAo6uMocvE9EOHOGd6XUfSkScR
         N2eQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdOwiIF5RHSIfs0frgOJX6aUi8zObbVw0iX+kzNvs9tQpfs57WStmUS8FmQJeW9M1iP08=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGISN1vN0hbDuwoOKO6/VUAUiuRp7lbjp6Toy1ANO91Q63eW49
	SA6QEOrCTmNfzkDYCCcr1WgUbXZ4V1VQr73ZUY72py0eQiwoQSxe9MCABCTmo4XzIcU3O9OHt7x
	K7FSTXlzOJDF+1j7F+/sn1gqm0EXANKr/TLIw1Zdn+4ZFy3ChIw==
X-Received: by 2002:adf:f582:0:b0:374:bb1b:d8a1 with SMTP id ffacd0b85a97d-378895c8952mr7037639f8f.13.1725890013450;
        Mon, 09 Sep 2024 06:53:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFk/RZdu5hJmqPBD1gLK2Du0vc3Ucd0dFI9zif6lUjbFOdQm054xYpFZmm6lHghk0+9DSd3kQ==
X-Received: by 2002:adf:f582:0:b0:374:bb1b:d8a1 with SMTP id ffacd0b85a97d-378895c8952mr7037624f8f.13.1725890012968;
        Mon, 09 Sep 2024 06:53:32 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3789564a1absm6201030f8f.1.2024.09.09.06.53.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2024 06:53:32 -0700 (PDT)
Message-ID: <7d986ebc-f3a3-4a06-96a9-8c339fdfb23c@redhat.com>
Date: Mon, 9 Sep 2024 15:53:31 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/21] KVM: x86/mmu: Do not enable page track for TD guest
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
 yan.y.zhao@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org,
 Yuan Yao <yuan.yao@linux.intel.com>, Binbin Wu <binbin.wu@linux.intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-4-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240904030751.117579-4-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/24 05:07, Rick Edgecombe wrote:
> From: Yan Zhao <yan.y.zhao@intel.com>
> 
> TDX does not support write protection and hence page track.
> Though !tdp_enabled and kvm_shadow_root_allocated(kvm) are always false
> for TD guest, should also return false when external write tracking is
> enabled.
> 
> Cc: Yuan Yao <yuan.yao@linux.intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
> v19:
> - drop TDX: from the short log
> - Added reviewed-by: BinBin
> ---
>   arch/x86/kvm/mmu/page_track.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index 561c331fd6ec..26436113103a 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -35,6 +35,9 @@ static bool kvm_external_write_tracking_enabled(struct kvm *kvm)
>   
>   bool kvm_page_track_write_tracking_enabled(struct kvm *kvm)
>   {
> +	if (kvm->arch.vm_type == KVM_X86_TDX_VM)
> +		return false;
> +
>   	return kvm_external_write_tracking_enabled(kvm) ||
>   	       kvm_shadow_root_allocated(kvm) || !tdp_enabled;
>   }

You should instead return an error from 
kvm_enable_external_write_tracking().

This will cause kvm_page_track_register_notifier() and therefore 
intel_vgpu_open_device() to fail.

Paolo


