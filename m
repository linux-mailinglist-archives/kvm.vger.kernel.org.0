Return-Path: <kvm+bounces-10838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EC9EF871136
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 00:40:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66A0B1F22BE6
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 23:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23F7A7D3E5;
	Mon,  4 Mar 2024 23:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TgYOfh+c"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4387CF2B
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 23:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595575; cv=none; b=KDckZgzZAtzvcUbHvn/cpO9X5az8ICevYdHqRPVIAYmXePcS2zhMKVqE/eZ/eF2D3uOAX6YQgGjmdtfpE8K2Z3v7omAJiNXH2tNrwORNYZjYD0MB58qN+EOEHDS7Jh5Z26cJCObafsSxtlTTDjSdG/p1+46WGsXALGE9hTKAS9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595575; c=relaxed/simple;
	bh=HuxVTbWhoEdPorH9pH9iSCc7GnAeuOBAW39IlNag+ZU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KvjdygiU0VA4dDjS3m0pQad+xgEF8Y+J6hmEOVlkGHconWvrZNCyegGP5F3qurrc+mivo9IKX97l2DNvzjbdE13LWbPE8c25FhPwyxcu7H07MQ5tFbyX4TgaKTa53MO0YdVhT5QPUIvE23PTXYpi/HHsM8XMG/G+sWMfgC78zKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TgYOfh+c; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709595572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2wAQK/IWD+07r8iQ2sWomvQr6iC0KVSkeyxgsYKZFoQ=;
	b=TgYOfh+ceGvQrGYJW0pCEfCB4rt9EP5SdX17+XZx/GdbuMw8g7uastdRBDzAkfQ1GI61Dy
	tK7GFGeVfXzC1eOonRalOxM91mKhELHGV+rcpMRLPEfsPtDBI20HUwkETgYlx/neJ5HW1o
	sU9KQNFm5k93z/IiEKhv54NCBgzOBpk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-z9qN9SBQPziifEn5-hlSyQ-1; Mon, 04 Mar 2024 18:39:31 -0500
X-MC-Unique: z9qN9SBQPziifEn5-hlSyQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-412a64bf17eso821945e9.0
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 15:39:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709595570; x=1710200370;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2wAQK/IWD+07r8iQ2sWomvQr6iC0KVSkeyxgsYKZFoQ=;
        b=cpmV2jmQ9xbNKym7S1yUNRRLDj0z8NQfBJ53DloGAp5+QFhERLf7/UBFtOwfSGzCky
         DP3gDjD9VbIXQ09tEhYbktJ4d9XSWqayUhwEtmUaY5e/0O4O81fki0Y/MaAWkH+dy/5w
         NaNpQqOUMKz+zV6/JVa/urUnsPOhAbUOPdoi7Iy/6aHPw0Ykd5pJvcb6kRfDJ2K/uE1L
         L1F5ypyRZA1M4YZ1bvpd5UKFzVEplj36RduEC1yvHAnFFB+XVMyGg2EADjz0XxRF0BLu
         QiZLBKlP1EuV+Oj8QJFAM29KvrXGBDK0e8fGmHPFJxhGRz1qDf1NiGUVczYW+QWlKYvA
         3dAA==
X-Forwarded-Encrypted: i=1; AJvYcCXDKRDqnX9nDayuiyMo3pDurNJ3V+m5sQV2OuOqoHs6UimbLTRVBUjI89gRLrOznodNXe47IV1ZDI/brkJ9s7T3Xo7N
X-Gm-Message-State: AOJu0YwCDyOSm1+S5Rh+pKpAKK45+Ct6L2ZxIijdPTVTZo8zi7u597ob
	/tImBGtI/PQowlHl3w1iwVGpEZ0dIytqCiRt17kATKPsDwsPjQSqG/H6FMvwKDgF3wt+BPcS18X
	aIfYlzQ1OjpckQX0AxJjQi8q82tiB0JiVoksL1RsC99bM/ZuNzg==
X-Received: by 2002:a05:6000:4c7:b0:33e:8fd:1173 with SMTP id h7-20020a05600004c700b0033e08fd1173mr8612162wri.60.1709595569936;
        Mon, 04 Mar 2024 15:39:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG7OproRb1U90V197v1ESVvV7A39c/dXtAJLhYhq1T0Tv4SkgUlHDgucUxKm6u4unAT6lbhWg==
X-Received: by 2002:a05:6000:4c7:b0:33e:8fd:1173 with SMTP id h7-20020a05600004c700b0033e08fd1173mr8612155wri.60.1709595569609;
        Mon, 04 Mar 2024 15:39:29 -0800 (PST)
Received: from [192.168.10.118] ([151.49.77.21])
        by smtp.googlemail.com with ESMTPSA id i8-20020adfb648000000b0033e0ed396bdsm13244118wre.106.2024.03.04.15.39.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 15:39:29 -0800 (PST)
Message-ID: <51e57a7c-c8a1-4a18-a08b-d2c8fd5b35b3@redhat.com>
Date: Tue, 5 Mar 2024 00:39:27 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Why does the vmovdqu works for passthrough device but crashes for
 emulated device with "illegal operand" error (in x86_64 QEMU, -accel = kvm) ?
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>, Xu Liu <liuxu@meta.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-discuss@nongnu.org" <qemu-discuss@nongnu.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <39E9DB13-5FA3-4D1A-A573-7D58BA83B35C@fb.com>
 <20240304145932.4e685a38.alex.williamson@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240304145932.4e685a38.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/24 22:59, Alex Williamson wrote:
> Since you're not seeing a KVM_EXIT_MMIO I'd guess this is more of a KVM
> issue than QEMU (Cc kvm list).  Possibly KVM doesn't emulate vmovdqu
> relative to an MMIO access, but honestly I'm not positive that AVX
> instructions are meant to work on MMIO space.  I'll let x86 KVM experts
> more familiar with specific opcode semantics weigh in on that.

Indeed, KVM's instruction emulator supports some SSE MOV instructions 
but not the corresponding AVX instructions.

Vector instructions however do work on MMIO space, and they are used 
occasionally especially in combination with write-combining memory.  SSE 
support was added to KVM because some operating systems used SSE 
instructions to read and write to VRAM.  However, so far we've never 
received any reports of OSes using AVX instructions on devices that QEMU 
can emulate (as opposed to, for example, GPU VRAM that is passed through).

Thanks,

Paolo

> Is your "program" just doing a memcpy() with an mmap() of the PCI BAR
> acquired through pci-sysfs or a userspace vfio-pci driver within the
> guest?
> 
> In QEMU 4a2e242bbb30 ("memory: Don't use memcpy for ram_device
> regions") we resolved an issue[1] where QEMU itself was doing a memcpy()
> to assigned device MMIO space resulting in breaking functionality of
> the device.  IIRC memcpy() was using an SSE instruction that didn't
> fault, but didn't work correctly relative to MMIO space either.
> 
> So I also wouldn't rule out that the program isn't inherently
> misbehaving by using memcpy() and thereby ignoring the nature of the
> device MMIO access semantics.  Thanks,
> 
> Alex
> 
> [1]https://bugs.launchpad.net/qemu/+bug/1384892
> 
> 
> 


