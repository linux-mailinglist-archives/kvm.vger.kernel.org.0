Return-Path: <kvm+bounces-37927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96E61A318AC
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 23:36:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 150AE1889BAF
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 22:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A3F3268FE4;
	Tue, 11 Feb 2025 22:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QmPSfKUP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDD6267715
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 22:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739313353; cv=none; b=FAU6aFKq8oilJYQI/haBNHPV+sS0lJWRsHASlibbdb+k3alm2zRMe5t6vAqPjFzVbAqVBTZ3ibh0j9317ILI+tNBDon4e/QZPo0dBXwQ+LkJVHktXCtisr0/fwjtFhPpAhxf80U8BYmzE3Euq5L/6lWGrJl9kZUMJEqNI+aIS4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739313353; c=relaxed/simple;
	bh=Xkdp9y4dsVSdxrh44v4Max9ccE+5GLe6LAhQMb/0OyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MAl2vLHq7pTjRv/CGVsY/6aJ65fghJj8y//HjxK16V99WKi8sjMPOkJCEVdfMQ8VToaRlnEgY5yVu/+xDPHt79EHfQfWv53jDYjGrGpENyd68bC3HuGcWN1imXZETwCZXG0bUBfiEt2B2G1sS/SfjTl6vJgoVAP53K/PZDnUI1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QmPSfKUP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739313350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AQmLFir4UkEGYUUsaqSF/TAOnlHne0O7Pyi3Uz6Gm6s=;
	b=QmPSfKUPEzpS5S8KwQAh/2R4PaNjZ/uW5qWXA+gJSOVJhRI05zOcp8uEfixVXXGinhEDes
	g/TrqvbR+ho+iUTZ1wAoYuyGp0JEgJjfXbhnoOc9QVfS7KRo19AHIAUpOOLrgmyKJgHrfs
	xSplmJgsxXOBHVTBvCQNsaHq84g0MGc=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-61-64K664KnMBSjiydg_jO9gg-1; Tue, 11 Feb 2025 17:35:48 -0500
X-MC-Unique: 64K664KnMBSjiydg_jO9gg-1
X-Mimecast-MFC-AGG-ID: 64K664KnMBSjiydg_jO9gg_1739313348
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3f3aa4b60bbso5308951b6e.3
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 14:35:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739313348; x=1739918148;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AQmLFir4UkEGYUUsaqSF/TAOnlHne0O7Pyi3Uz6Gm6s=;
        b=MjJzxFj/2NpcJ4Gf1Y1S1NOlrMnjshxIjHzNrqfiEWyYJ72W2y5hdqf5VKdKddlaVk
         X5NSGEKMJDg0ksCrRKITIDdWYeUVqh+oBorwCCkCBDE5oQDPNFYn7/voPni0wCaLMfc3
         dRrFKZdFPGyGNEsT+kkhd52DMD+3lsBAZN0qH6u39MRB8B7y0K7fNGWNEsIoz13duunv
         WP0zD6vU5mJ6QcFd2IzhfhyUK0BCeiQxlSqNbqqfunC5h3N+JsVVjnczSY59Ppufo6t+
         B1r+tgQ+FbBmxVKAKC8LBJJs/TbODHYIvvWh/SnG4i/IveTFjn9r53cAJ/XbqMcxFBaS
         7/4Q==
X-Forwarded-Encrypted: i=1; AJvYcCVykZV7Xe9vHkIAoQQhGSfgAr2Hybz8fX46m88eyDn73o7gCUzpskBVPqHSi/os4rXixgY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxF0A42Wx4ooJzny438TLO0fvZTQlGklSZkBfgyFPe5WZktAXyK
	8KonMmQh8Siho8oMDF+JgjTCI9Nl3NXeFMfJD2gO0hGKUtwU/ASrqj4dwLdPYhJ57gg90da5gyu
	khxaRY0hqDgJADnVyspTDvc5wksnMvcaP0KYjlIh8wBZNrN0fCg==
X-Gm-Gg: ASbGncsyMSfSp2n+vzhv+WwR2p6BmqtarkVltC4S7j6VNOxOZ3HYA6NKc6JISthdkpi
	ZeJaTV4BM78+veoJ7fcu+3EPLi4npu1alUy3Jj47An6s0JYD+9MardMjuiF5E9ZFBLTz11CfLSf
	8H8cGzWubnW8mMveT1JBv177JsTPGjXzQxEaXDOSnPfHdDvj5QoE7zS2vL+1vWHdK70/Mg3AD5X
	MOdbQZBsV11CJOSfvsGSdhspgNiWQizDH0rN7hALCBh55CZR9pWTjFvLhc=
X-Received: by 2002:a05:6808:80cc:b0:3f3:b0ae:7998 with SMTP id 5614622812f47-3f3cd601076mr1099268b6e.17.1739313347791;
        Tue, 11 Feb 2025 14:35:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGtm+HslfUZKczOhDisXpbAz9Wg8zd23YUSu/nhTnz2WuQo5SFimH65ggUbt/iDHmN7BQOJCA==
X-Received: by 2002:a05:6808:80cc:b0:3f3:b0ae:7998 with SMTP id 5614622812f47-3f3cd601076mr1099254b6e.17.1739313347528;
        Tue, 11 Feb 2025 14:35:47 -0800 (PST)
Received: from x1.local ([2604:7a40:2041:2b00::1000])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3f389efebe9sm3576089b6e.27.2025.02.11.14.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 14:35:46 -0800 (PST)
Date: Tue, 11 Feb 2025 17:35:42 -0500
From: Peter Xu <peterx@redhat.com>
To: =?utf-8?Q?=E2=80=9CWilliam?= Roche <william.roche@oracle.com>
Cc: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
	qemu-arm@nongnu.org, pbonzini@redhat.com,
	richard.henderson@linaro.org, philmd@linaro.org,
	peter.maydell@linaro.org, joao.m.martins@oracle.com
Subject: Re: [PATCH v8 0/3] Poisoned memory recovery on reboot
Message-ID: <Z6vQvr4dCCsBR2sX@x1.local>
References: <20250211212707.302391-1-william.roche@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250211212707.302391-1-william.roche@oracle.com>

On Tue, Feb 11, 2025 at 09:27:04PM +0000, “William Roche wrote:
> From: William Roche <william.roche@oracle.com>
> 
> Here is a very simplified version of my fix only dealing with the
> recovery of huge pages on VM reset.
>  ---
> This set of patches fixes an existing bug with hardware memory errors
> impacting hugetlbfs memory backed VMs and its recovery on VM reset.
> When using hugetlbfs large pages, any large page location being impacted
> by an HW memory error results in poisoning the entire page, suddenly
> making a large chunk of the VM memory unusable.
> 
> The main problem that currently exists in Qemu is the lack of backend
> file repair before resetting the VM memory, resulting in the impacted
> memory to be silently unusable even after a VM reboot.
> 
> In order to fix this issue, we take into account the page size of the
> impacted memory block when dealing with the associated poisoned page
> location.
> 
> Using the page size information we also try to regenerate the memory
> calling ram_block_discard_range() on VM reset when running
> qemu_ram_remap(). So that a poisoned memory backed by a hugetlbfs
> file is regenerated with a hole punched in this file. A new page is
> loaded when the location is first touched.  In case of a discard
> failure we fall back to remapping the memory location.
> 
> But we currently don't reset the memory settings and the 'prealloc'
> attribute is ignored after the remap from the file backend.

queued patch 1-2, thanks.

-- 
Peter Xu


