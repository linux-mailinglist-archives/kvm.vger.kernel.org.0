Return-Path: <kvm+bounces-29465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10F6E9AC040
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 09:31:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 61E43B235A7
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 07:31:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B2EA153BF8;
	Wed, 23 Oct 2024 07:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ITZaz2qr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194F2148FE8
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 07:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729668659; cv=none; b=mPqAf3kpMo9hD3ZezaZINKF8QmmKYpjgNc1WWRZAV42qhgZGnahnwp5MMClTs5xLzHVRdOFNGWkYUyWNfr0GeA7ZD/eSo+Ga/i1pvCUrTGYXy7f0bWlPN23+eyDySL9F6XcoTgjxVYLKTBt+Nvu23JN9QLcPk+vMyFVxAbQobeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729668659; c=relaxed/simple;
	bh=S18A9/uegNQLch0nFe6lcikOk1MT+xNgksoyQj207/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MKtzBb4WuTMF70YAu/ibyROQOEx+Kp3zUQ8YGnlPHIPQZVsl+bYuAPcuzAJwwvse/e3hitOcNFedj2HDVRr6KzX4HbGZ8+8myzcQdrPUE7T+ZD7PTyuJJ3ZuFWZ1qm8mejeJUq1Qc12cB+ir4DmzzG/Poc5K+Tp8qNsK0vmxBtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ITZaz2qr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729668656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nLAbOW5noKWYdqiOCxdBnOzCCEaEY6Bx0acXsqpyM84=;
	b=ITZaz2qrZ71Jy2iShgEesjVr/boxexA2jFzktfjU4yMtEA/LO6agxlA44eRfr+1yX1xBmV
	LWYvxTAHy1ipXdOwO7BsV3JmTA3KJjHrmXduMhajg09q4dZ3/HrRjPE6wO25lDcX0+XMPB
	pRebKtOjrSJp4tYfKSn53F646Sr90DM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-335-bx9Tyoi3MCmlysoH1VNRSw-1; Wed, 23 Oct 2024 03:30:53 -0400
X-MC-Unique: bx9Tyoi3MCmlysoH1VNRSw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-37d5a3afa84so3411185f8f.3
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 00:30:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729668652; x=1730273452;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nLAbOW5noKWYdqiOCxdBnOzCCEaEY6Bx0acXsqpyM84=;
        b=UqQ7Drs/+s//AAnzskgblxE8LIy98xPrU6hTs8cQS9h/71+a11KybcTzGvSlJoJJ57
         4rsUwJw0t1kfV5opANSxZDiEa6rum/9ku60ruC/XYRxa7hkuo2OysACMd3mCBW39lZNj
         HhVAOtTYO7wyQ1EYDgQYoS7JOTF8y/rV/jtPUd3E6CwGKeHx9pXlBX4FkBKEeHlAC3gb
         Nt6FI5TKyZpCL6poK5fsgUFkpb4hx669KrElhxuzyblC0V0MxwHTs+sP6BIs5nqLdAx6
         tEt98BeftP2WIrS1tR0yFFpIqIlChMjTxnbTRO3qoy74xx7kd5KKrqkIwtE2tASJ0p7Z
         qpAw==
X-Forwarded-Encrypted: i=1; AJvYcCUltHql8WB72JBHjTmiM38Ma6uz7yHvOFpinecMbg7tve7CyZht7qBtFS41xRZWEa82DXs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSjAovzM332pifscm0KmFjv/+DavHBqGQ8UN6Kwg55l2fz9eWf
	4e5oi88eErMgDCz79U1M6bnboLm6homSRK49Gc2Gs2ebj5kFjtKLXfMfoQx8tJ37oLaHndorwdp
	XkzkpB68tyiVCxkr41y3Z2QWb24wi6lLya3YqUkPHjbtYoDtwcw==
X-Received: by 2002:adf:fc89:0:b0:37e:f1ed:67e8 with SMTP id ffacd0b85a97d-37efcf1febemr910537f8f.35.1729668652070;
        Wed, 23 Oct 2024 00:30:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IElQufGspeuo8s52Js73KdBiTAVmxS+0bm1ueIZyZW3Xk3w29r46GilaYuIg/XFCvKU6PmSYA==
X-Received: by 2002:adf:fc89:0:b0:37e:f1ed:67e8 with SMTP id ffacd0b85a97d-37efcf1febemr910514f8f.35.1729668651465;
        Wed, 23 Oct 2024 00:30:51 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70c:cd00:c139:924e:3595:3b5? (p200300cbc70ccd00c139924e359503b5.dip0.t-ipconnect.de. [2003:cb:c70c:cd00:c139:924e:3595:3b5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43186c15684sm8218015e9.39.2024.10.23.00.30.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Oct 2024 00:30:50 -0700 (PDT)
Message-ID: <0cda6b34-d62c-49c7-b30c-33f171985817@redhat.com>
Date: Wed, 23 Oct 2024 09:30:48 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/4] system/physmem: Largepage punch hole before reset
 of memory pages
To: =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>,
 peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: joao.m.martins@oracle.com
References: <ZwalK7Dq_cf-EA_0@x1n>
 <20241022213503.1189954-1-william.roche@oracle.com>
 <20241022213503.1189954-4-william.roche@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20241022213503.1189954-4-william.roche@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 22.10.24 23:35, “William Roche wrote:
> From: William Roche <william.roche@oracle.com>
> 
> When the VM reboots, a memory reset is performed calling
> qemu_ram_remap() on all hwpoisoned pages.
> While we take into account the recorded page sizes to repair the
> memory locations, a large page also needs to punch a hole in the
> backend file to regenerate a usable memory, cleaning the HW
> poisoned section. This is mandatory for hugetlbfs case for example.
> 
> Signed-off-by: William Roche <william.roche@oracle.com>
> ---
>   system/physmem.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/system/physmem.c b/system/physmem.c
> index 3757428336..3f6024a92d 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -2211,6 +2211,14 @@ void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
>                   prot = PROT_READ;
>                   prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
>                   if (block->fd >= 0) {
> +                    if (length > TARGET_PAGE_SIZE && fallocate(block->fd,
> +                        FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
> +                        offset + block->fd_offset, length) != 0) {
> +                        error_report("Could not recreate the file hole for "
> +                                     "addr: " RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
> +                                     length, addr);
> +                        exit(1);
> +                    }
>                       area = mmap(vaddr, length, prot, flags, block->fd,
>                                   offset + block->fd_offset);
>                   } else {

Ah! Just what I commented to patch #3; we should be using 
ram_discard_range(). It might be better to avoid the mmap() completely 
if ram_discard_range() worked.

And as raised, there is the problem with memory preallocation (where we 
should fail if it doesn't work) and ram discards being disabled because 
something relies on long-term page pinning ...

-- 
Cheers,

David / dhildenb


