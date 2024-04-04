Return-Path: <kvm+bounces-13569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D933898905
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 15:45:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A08E282445
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 13:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B712128395;
	Thu,  4 Apr 2024 13:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AaOMsiCM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DCE85644;
	Thu,  4 Apr 2024 13:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712238317; cv=none; b=bYYq4XFKYSvBW9E1hKjyuHr9h4QTi8YrPpVS66RB/TAB4sSqv+8APyLTMyVdCLvAHYiwg3ymhPty4c9TnFb5BXI5066uBCnTcDbIrXSj0+89LeviHk2khMSys3slBREuEmafLPQOHuXxfM16i9TTcKoDcTVq0EJJ3T8goZ5IF3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712238317; c=relaxed/simple;
	bh=eNFxWhJpWGn4MVKyzZRbjgkh8DaGFUxZWhNvYbMxGkI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dmBWMyIBqQkW6Ej3XHSuZAaKIrrBCAz9++Xktpk5syhfnUQoVerKPN1wPDr28ii7VeTeyP61DjO6H2n3tQFVxAOBueB1HX7TvcPF1TqgsonqxGamFNHCVYMgZomIoG+oOMkOBGxcbVWuWYlZodqri5VDPSd11c/yPlqXIsav8x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AaOMsiCM; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2a2da57ab3aso373962a91.3;
        Thu, 04 Apr 2024 06:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712238315; x=1712843115; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WxzZmInBFuAtLU4NoG0liW28RCj7raug1tFQ+0Qn6gc=;
        b=AaOMsiCMllr0ywB+3KRStqmw9umxWIGSm932/ZyMlENms6urkXC2Tsk4cIUdLlMY79
         xRf5m1dumbNOrM+wUPv8ozHeg4+L5RZjNHbqojKeXwlGSzxjmUbjyBksrf0iV7s++do/
         aXNWGFoPL7tv9+1dsbzHVfdodZH09nD68P7wU0maN/6vy7s/8VuGrf8EsCIR9u3630vR
         4grNazG4lQln6LhovvJj1r/2lCw5xsMOlzGSmdqESaMjbGAt7PmfAux9aW7Y1JIInJdZ
         4qRr/n03BtYjO1c9p/gQEH9RkQVxSUGb3VDKk07DF76eumd0dqWBy9rtfABQOFgAnT8X
         gEHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712238315; x=1712843115;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WxzZmInBFuAtLU4NoG0liW28RCj7raug1tFQ+0Qn6gc=;
        b=XV39LzC+W6ILO9Mi7DBIKk6UmeWrrmPdCE2p1xg/UnMCqFSxSZH1Knf3pwE7I+9V+O
         SyYbADN+iL5Uwhyfdh+n0sgIjc37rRp5nd+tWihsYqBDVDH/Fgo7BLMZQcM99Gz8ZBTH
         68vl8Ec1EUVj7/MT3cL13RoRGu5KSbIy25p7e2QA2XxTZ+RcMA6ClOIfbFNWlAN2io0o
         6ld/vWeZSz7V9uFD+9aS18a2JaxNKTOTNsM/YPQHmCg4/Crdb1jYt1TUiF8hCqy0VACF
         vaFWyER1Ml0TnIqQi0QzkoeackSsr10fJWJw7NSJdlyGEHREbeH74+saDMaTM6kfVyrf
         gMhQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8MUDCM3fUUt7EalKhPMPdfbctyisTySdRuUaF9INa5mag7yLOLYIdgkMQeG9n9jwmNk7t45m4aMjukXyM528aG7KNq2arccMEQRlIVZaGvvCvjTeqxrmS3UhdjUmGHDdR
X-Gm-Message-State: AOJu0YxEGBx+8X0TGzh44gCye3TMAvkBQVV25XTA5aKkC2k9BIkP0ULn
	D1Fv6yE+D12umR8C9pdGrJ1NhGHCbGYw48bukU4s7+6j0lJXarg8
X-Google-Smtp-Source: AGHT+IGwHkPA46yLsNudscd7HWEyOutrM8mgbI2iygtOCqjw2DmR57hI0OfHbI9BXGLrzxboQP/BNg==
X-Received: by 2002:a17:90a:17cb:b0:2a2:c430:fc30 with SMTP id q69-20020a17090a17cb00b002a2c430fc30mr2515476pja.21.1712238315089;
        Thu, 04 Apr 2024 06:45:15 -0700 (PDT)
Received: from [172.27.237.1] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id d4-20020a17090ac24400b002a2fe0998f0sm54885pjx.19.2024.04.04.06.45.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 06:45:14 -0700 (PDT)
Message-ID: <fe40498a-3bb2-43c6-b3e2-1e4e10205db1@gmail.com>
Date: Thu, 4 Apr 2024 21:45:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/15] Coalesced Interrupt Delivery with posted MSI
Content-Language: en-US
To: Jacob Pan <jacob.jun.pan@linux.intel.com>,
 LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
 Joerg Roedel <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>
Cc: Paul Luse <paul.e.luse@intel.com>, Dan Williams
 <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>,
 Raj Ashok <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, seanjc@google.com, Robin Murphy <robin.murphy@arm.com>
References: <20240126234237.547278-1-jacob.jun.pan@linux.intel.com>
From: Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <20240126234237.547278-1-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/27/2024 7:42 AM, Jacob Pan wrote:
> Hi Thomas and all,
> 
> This patch set is aimed to improve IRQ throughput on Intel Xeon by making use of
> posted interrupts.
> 
> There is a session at LPC2023 IOMMU/VFIO/PCI MC where I have presented this
> topic.
> 
> https://lpc.events/event/17/sessions/172/#20231115
> 
> Background
> ==========
> On modern x86 server SoCs, interrupt remapping (IR) is required and turned
> on by default to support X2APIC. Two interrupt remapping modes can be supported
> by IOMMU/VT-d:
> 
> - Remappable 	(host)
> - Posted	(guest only so far)
> 
> With remappable mode, the device MSI to CPU process is a HW flow without system
> software touch points, it roughly goes as follows:
> 
> 1.	Devices issue interrupt requests with writes to 0xFEEx_xxxx
> 2.	The system agent accepts and remaps/translates the IRQ
> 3.	Upon receiving the translation response, the system agent notifies the
> 	destination CPU with the translated MSI
> 4.	CPU's local APIC accepts interrupts into its IRR/ISR registers
> 5.	Interrupt delivered through IDT (MSI vector)
> 
> The above process can be inefficient under high IRQ rates. The notifications in
> step #3 are often unnecessary when the destination CPU is already overwhelmed
> with handling bursts of IRQs. On some architectures, such as Intel Xeon, step #3
> is also expensive and requires strong ordering w.r.t DMA. 

Can you tell more on this "step #3 requires strong ordering w.r.t. DMA"?

> As a result, slower
> IRQ rates can become a limiting factor for DMA I/O performance.
> 



