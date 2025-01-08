Return-Path: <kvm+bounces-34844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41CEEA0671C
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 22:22:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 808013A644F
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 21:22:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D0AC20408C;
	Wed,  8 Jan 2025 21:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U6YeeKD5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7FA1F8F14
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 21:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736371333; cv=none; b=eO5S3bLjQxsvMAlE2G5daq77D+U5vJdtDdrV2qUFe5gxG4v5k85ctrUAhNskp+D3aGQSIR3qT+hHIv9Yjit1kUmxGlzGWZAAiMDK6LDahA7+UClKtp1bvBU11mwzmp0+tGee/XwtKAtiJv/DT4tNv59fsn9mxG3/R2cELc+dzXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736371333; c=relaxed/simple;
	bh=N+9IgCv78VTf61KnMQslufMzGdpII/4nB3EfdjM+BDs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y+FIshLsXzSPn8+IkpnDTlPw4RII/6KfRj82NU3oC0ZORHII9/2Q08DHZvWUrQuhG8Ar9E9sfrmCedAfqBwergtTvMQTKEaqVat321DWHMehD4b/SaBXNkcQ2iFhitcJ4SnEDThaSgr7fpX3fHkotT92yQ29dCAEimc8yXJwL0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U6YeeKD5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736371330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Bfj03Z1hailZKFXRLUXKAdtZqhCy+9zpwuchbFoqM/Y=;
	b=U6YeeKD5ZoLWj+oJGVnhuBOOgvjEswVsrrh1Bw2zy8WYwHO+ikS+q/Lenre8bnN+Rvnlns
	yYO88QV9sjBxTJo71sTpiP9b96if19xUakIQwgP77iKB+r7++H0q0DnhO53eexdHbEcQ9E
	Q+SNCSIG9TN2mr/BeeBMljgmQxwTuow=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-7-Mz1bLxNbyrnvSdTHnb_A-1; Wed, 08 Jan 2025 16:22:09 -0500
X-MC-Unique: 7-Mz1bLxNbyrnvSdTHnb_A-1
X-Mimecast-MFC-AGG-ID: 7-Mz1bLxNbyrnvSdTHnb_A
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4362b9c1641so1097195e9.3
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 13:22:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736371328; x=1736976128;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Bfj03Z1hailZKFXRLUXKAdtZqhCy+9zpwuchbFoqM/Y=;
        b=RsY7660CksGBuiAq7W6/rVMuwtBHyPc9k/b9NbZjsnAVQGOiK+Crwifr8N1NRO6Fa5
         lp9nWP74AuIkVtJLTXGM6EyHqRwu+SSkhw3CTsCHCTL/qII/X93zOl/suufJlLQW+w6P
         Mf2CX+sH9BwXKj3ClcS08Ol/Uazwo36a1nJIeckmJYTgIh1zSQJGKFOp/a1YviCZ7hCL
         hizvtf0hw0RVim/CabLbd+zI5h176sghfJc9YwvzAGALsS3WWOW+FvLbrg07Dc8LM2/x
         +QnH4fm3RBwGxF9jWVHLW0i5kybMMQ3YKPCWSaNk/cu9jvYhraEfqpke5kRaX2W7NI7X
         OV9g==
X-Forwarded-Encrypted: i=1; AJvYcCU/ZbXrwx7xAWmMN8pFWcPm+/KJB4XotJDHO1oTR936Z+a9YZvo+BtEGpFAr0VbB8l7//o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMejee7tJnHTMXRiafrOJs0/j4ppox9qx+Xkmdzk6GCGX8KBS1
	q9+Djri7BzocjkS7KibkEnoJ8BZkZQeMJ3LCFx3LxPBpU9AeHoMGTeN0eWiCL8xVHZVqTNjMmbX
	u80ms3PuUuADyiBh/E5doGBHq4uLfojWp5/RMjzNTs3FgkFkeuSRDOZs1F/AO
X-Gm-Gg: ASbGncuerJFNfVSYaJnQq4hLh4c6+eeYhlzPpZrGbyg1TCA8YqhPOh72Tt9TFSKNB44
	2GQnAKgQ1E2I+v3UOS1TmqWcVXNah6QdIxYk7be5dbJ/N+zaEBdb+swr+iWtCatiMQTK8KW4rre
	LM3YEIUaSDO6RjmmQu2QPbhIA8yPSKQbJXqnzSGZfnTc5VBQfRh9QRHrstTZaH12JqCDGDKTQeE
	5hCcP2fOrHfk8Qp7gFH5QXg6xoNnrfC9nQMbs3w/v1OeecP9chlchEtuFh0+26RYARzGWrec64e
	vZmL1/b1rXIQFuW9nJNXANH2UtHZoSQ9EhIY/30qDHHvOo5AxK/xusJBSIg2umcLVWh8UocjTTD
	ILQ3UXg==
X-Received: by 2002:a05:600c:4f95:b0:434:a1d3:a326 with SMTP id 5b1f17b1804b1-436e2678213mr35028605e9.6.1736371328492;
        Wed, 08 Jan 2025 13:22:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IExWh9zYA05FKQUbHVuvm6/DNDgU3VRZGy31QFodIFIbAXgOWwcsJ5+GVAxWwXAoOZSsckkQw==
X-Received: by 2002:a05:600c:4f95:b0:434:a1d3:a326 with SMTP id 5b1f17b1804b1-436e2678213mr35028465e9.6.1736371328150;
        Wed, 08 Jan 2025 13:22:08 -0800 (PST)
Received: from ?IPV6:2003:cb:c70d:3a00:d73c:6a8:ca9f:1df7? (p200300cbc70d3a00d73c06a8ca9f1df7.dip0.t-ipconnect.de. [2003:cb:c70d:3a00:d73c:6a8:ca9f:1df7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e99a6e04sm141615e9.10.2025.01.08.13.22.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2025 13:22:06 -0800 (PST)
Message-ID: <6d771c8c-1ebe-48aa-b74e-6195738a041a@redhat.com>
Date: Wed, 8 Jan 2025 22:22:04 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/7] Poisoned memory recovery on reboot
To: =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>,
 kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241214134555.440097-1-william.roche@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20241214134555.440097-1-william.roche@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14.12.24 14:45, “William Roche wrote:
> From: William Roche <willia.roche@oracle.com>
> 
> Hello David,

Hi!

Let me start reviewing today a bit (it's already late, and I'll continue 
tomorrow.

> 
> Here is an new version of our code and an updated description of the
> patch set:
> 
 >   ---> This set of patches fixes several problems with hardware 
memory errors
> impacting hugetlbfs memory backed VMs and the generic memory recovery
> on VM reset.
> When using hugetlbfs large pages, any large page location being impacted
> by an HW memory error results in poisoning the entire page, suddenly
> making a large chunk of the VM memory unusable.

I assume the problem that will remain is that a running VM will still 
lose that chunk (yet, we only indicate a single 4k page to the guest via 
an injected MCE :( ).

So the biggest point of this patch set is really the recovery on reboot.

And as I am writing this, I realize that the series subject correctly 
reflects that :)

-- 
Cheers,

David / dhildenb


