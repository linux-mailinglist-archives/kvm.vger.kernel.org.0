Return-Path: <kvm+bounces-59102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6414ABABF3D
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:06:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5C31189CAFB
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:06:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BB232C0F87;
	Tue, 30 Sep 2025 08:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TjNVXF2V"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2140F2BE041
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 08:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759219577; cv=none; b=J3IGDxlTLnLZG2qRCVTlssxU8HHUk28mtnX7ZCSKPPpiRIdyK4mR+b3Ef5m+9Sw0NO9MNud2vc0VM88fajQOF+fC5SkXcBJgtQhYlibQ1VYgNR76d06HKo+/kE+ht/DRUWLpdkCNbsqJ3RgI5sPd+ewHseAUZKXPBAbKYcnVu0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759219577; c=relaxed/simple;
	bh=TOftkbiC2OgQ0q4rUDYjRIfDGaspWTCIRXwoNcsGKhU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HHj6pCX/0QwPHiawzuPO9tvi0q5V56EM/n4U4HKBZbxgtVo/uWSXf1ggadN10999MVOVe0UElmEdvwj/NO1kz82GCx1pho0Fs0OA0/TokoNIgbSlLO4U9jrTYbAnfQ8v+NmqrTnOHQG7oYYMpdLPU/1/iffGvrIq+351l/tdlBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TjNVXF2V; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759219573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=51XCkH+aNFTh/vSx2SwIZ43NeMu3vUeTpNln3mKSYks=;
	b=TjNVXF2VSjxrDFIh/KGGrKUBSx0UlwLJ+QjXOphsHOLFCiphuYb7aSEnRC5F1Cilg4quX6
	ksV4D2jevsOuFOKD66+trCgG3amhfv+5GxnDmVfJgw2T+mOn13BzU2l7XUc3g5cSO76g71
	QPpESgy5Yng6BAg7KKO6OKYmWPIcC0g=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-571-Ig_xtcC4OrqWeIGDvS-iYA-1; Tue, 30 Sep 2025 04:06:10 -0400
X-MC-Unique: Ig_xtcC4OrqWeIGDvS-iYA-1
X-Mimecast-MFC-AGG-ID: Ig_xtcC4OrqWeIGDvS-iYA_1759219569
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ecdc9dbc5fso4096854f8f.1
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 01:06:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759219569; x=1759824369;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=51XCkH+aNFTh/vSx2SwIZ43NeMu3vUeTpNln3mKSYks=;
        b=IBR17tkMG0QaoNMcdRZVPFCnR2CcTRhrsPV68JNn+t5GxLhpkpY8DFmAkr71IWRa33
         sdrgGuxTg5nakTPoU9C+33Nt1drXas8uBAb6dzdXRkyE0yCrv1CIRfC3LPgKCZNALFWj
         iO3xioxnVJN8WPy0+vPOklQ0FvzJRB7Ov4yldRe3iOPwxIcJ3k6xg4tQyfgSHLjiNLou
         s8haUM51zUplqvvFlBbpefZFqaM3hbsVx4R+RZvM49Uw5RWRtPbp/Gv7DMeBAqsYVSiz
         GPIEkJkwpAG+oSH0xLllXKdTgRjJQ05c6g609+5cHfuQzalcqD9XTxXKiul5m/ImYH7h
         lH+A==
X-Forwarded-Encrypted: i=1; AJvYcCWwReoZMEYcOovcrAxDSnI9IymKr92UblAHOtrQvpF+IAGZx2S5jpPY+prWW9wGFQSC+wM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHL6QIYKwmtWqhXRiDVdkNg7IE/1dxgwLm7iFikat/At9yD8XV
	ZbBAOWiCcgcM3tSp/yiIWbntklY7jK2f+Gv/Fvuqs3XNTw04USyF63F+eTGAWa/p9ishjxC9gyM
	eyEEN7rRY7dM2heF23t9JhWVr1LsmjfFwUX0owtKgGvy0PUEKzkMKsg==
X-Gm-Gg: ASbGncu7ZNFOk6q74bwyzgLNxIgerGxILXJaeqZJM+VHIEaGtpqSBR9fdaWFbWIeoxW
	BkZBqLziDxBr75QvbDM5mblXtswY1pLvFUXXbpEyPCLydB9mQcUEFayUN+H5ui0INy7XFTAA9bn
	jtCbzCdNM0+L+O0OO0cohX68MxTZl3B1o0tK2DRqjVa8zOrOKmFvEa0JbR67V7tEiELRQa1DCie
	4/0CEGT+N/hEPfn6E7hYRcCR+9jzNjRUT2eCKwSTAMOcp1QUCKGxhCn1MJn3oG7tZWeXSeV9P7f
	uH1zwqpAkx5D7QvVXZht+mf9z4DyqyifmBLrPKqYT8lqKmm0W93oTJDvxWyvbNqKymmeolqfZwt
	U0bcRZju6
X-Received: by 2002:a05:6000:25ca:b0:3eb:4e88:55e with SMTP id ffacd0b85a97d-40e47ee0960mr14803559f8f.41.1759219569061;
        Tue, 30 Sep 2025 01:06:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEycmBsRkqTCL8+ewu7sbeh1VbG/+/fMKLVnhENjV7ujlxRbToj1yrIQBvbcqxqhpUjJtPopA==
X-Received: by 2002:a05:6000:25ca:b0:3eb:4e88:55e with SMTP id ffacd0b85a97d-40e47ee0960mr14803497f8f.41.1759219568427;
        Tue, 30 Sep 2025 01:06:08 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:576b:abc6:6396:ed4a? ([2a01:e0a:280:24f0:576b:abc6:6396:ed4a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc8aa0078sm21322019f8f.59.2025.09.30.01.06.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 01:06:07 -0700 (PDT)
Message-ID: <ac4a28a4-1236-4102-8742-9f46c6b98437@redhat.com>
Date: Tue, 30 Sep 2025 10:06:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/35] memory: QOM-ify AddressSpace
To: Peter Xu <peterx@redhat.com>, Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
 Peter Maydell <peter.maydell@linaro.org>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@kaod.org>, Steven Lee <steven_lee@aspeedtech.com>,
 Troy Lee <leetroy@gmail.com>, Jamin Lin <jamin_lin@aspeedtech.com>,
 Andrew Jeffery <andrew@codeconstruct.com.au>, Joel Stanley <joel@jms.id.au>,
 Eric Auger <eric.auger@redhat.com>, Helge Deller <deller@gmx.de>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 =?UTF-8?Q?Herv=C3=A9_Poussineau?= <hpoussin@reactos.org>,
 Aleksandar Rikalo <arikalo@gmail.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Alistair Francis <alistair@alistair23.me>,
 Ninad Palsule <ninad@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S. Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Jason Wang <jasowang@redhat.com>, Yi Liu <yi.l.liu@intel.com>,
 =?UTF-8?Q?Cl=C3=A9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
 Nicholas Piggin <npiggin@gmail.com>, Aditya Gupta <adityag@linux.ibm.com>,
 Gautam Menghani <gautam@linux.ibm.com>, Song Gao <gaosong@loongson.cn>,
 Bibo Mao <maobibo@loongson.cn>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>, Fan Ni <fan.ni@samsung.com>,
 David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
 Beniamino Galvani <b.galvani@gmail.com>,
 Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
 Subbaraya Sundeep <sundeep.lkml@gmail.com>, Jan Kiszka <jan.kiszka@web.de>,
 Laurent Vivier <laurent@vivier.eu>, Andrey Smirnov
 <andrew.smirnov@gmail.com>, Aurelien Jarno <aurelien@aurel32.net>,
 BALATON Zoltan <balaton@eik.bme.hu>, Bernhard Beschow <shentey@gmail.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Elena Ufimtseva <elena.ufimtseva@oracle.com>,
 Jagannathan Raman <jag.raman@oracle.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Weiwei Li <liwei1518@gmail.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
 Thomas Huth <thuth@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Fam Zheng <fam@euphon.net>,
 Bin Meng <bmeng.cn@gmail.com>,
 Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
 Artyom Tarasenko <atar4qemu@gmail.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, Max Filippov <jcmvbkbc@gmail.com>,
 qemu-arm@nongnu.org, qemu-ppc@nongnu.org, qemu-riscv@nongnu.org,
 qemu-s390x@nongnu.org, qemu-block@nongnu.org, kvm@vger.kernel.org,
 Alex Williamson <alex.williamson@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>,
 Alistair Francis <alistair.francis@wdc.com>
References: <20250917-qom-v1-0-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
 <a06a989d-b685-4e62-be06-d96fb91ed6ea@redhat.com>
 <61e4c2bb-d8fa-446a-b4ec-027d4eae35b5@rsg.ci.i.u-tokyo.ac.jp>
 <aNrzASvJCP_axv22@x1.local>
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Content-Language: en-US, fr
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <aNrzASvJCP_axv22@x1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/29/25 22:58, Peter Xu wrote:
> On Thu, Sep 18, 2025 at 09:47:07PM +0900, Akihiko Odaki wrote:
>> On 2025/09/18 21:39, Cédric Le Goater wrote:
>>> Hello Akihiko,
>>>
>>> On 9/17/25 14:56, Akihiko Odaki wrote:
>>>> Based-on: <20250917-subregion-v1-0-bef37d9b4f73@rsg.ci.i.u-tokyo.ac.jp>
>>>> ("[PATCH 00/14] Fix memory region use-after-finalization")
>>>>
>>>> Make AddressSpaces QOM objects to ensure that they are destroyed when
>>>> their owners are finalized and also to get a unique path for debugging
>>>> output.
>>>>
>>>> Suggested by BALATON Zoltan:
>>>> https://lore.kernel.org/qemu-devel/cd21698f-db77-eb75-6966-
>>>> d559fdcab835@eik.bme.hu/
>>>>
>>>> Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
>>>
>>> I wonder if this is going to fix an issue I was seeing a while ago
>>> in the FSI models. I couldn't find a clean way to avoid corrupting
>>> memory because of how the address_space was created and later on
>>> destroyed. See below,
>>
>> Partially, but this is insufficient.
>>
>> The first problem is that AddressSpace suffers from circular references the
>> following series solves:
>> https://lore.kernel.org/qemu-devel/20250906-mr-v2-0-2820f5a3d282@rsg.ci.i.u-tokyo.ac.jp/
>> "[PATCH v2 0/3] memory: Stop piggybacking on memory region owners"
>>
>> Another problem is that RCU is not properly waited. This is left to future
>> work.
> 
> Just to mention, Peter Maydell just posted a series for fixing AS
> destructions here:
> 
> https://lore.kernel.org/qemu-devel/20250929144228.1994037-1-peter.maydell@linaro.org/
> 
> IIUC it should also work for FSI, if FSI can convert to use dynamically
> allocated AddressSpaces (with/without QOMify; as Akihiko pointed out
> correctly, these should be orthogonal), then provide a proper unrealize()
> of the bus device to invoke address_space_destroy_free().


Thanks,

I see the series is reviewed. Once merged, I will rework the OP bus
and check if the issue we initially saw on the OPB address space is
fixed.

C.


