Return-Path: <kvm+bounces-11125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 365F687354F
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 12:06:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A2AD1C230CF
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 11:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EA0B745CD;
	Wed,  6 Mar 2024 11:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IXFNjAth"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7DF2907;
	Wed,  6 Mar 2024 11:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709723160; cv=none; b=DzkclYgO67zciOG8FVlq3v+evQfk2WtkDWLJDtbgnQURpAph5kV8daqOGMFzZDFsRruLYZq3MFvx1dm/0MSUNU5YycLSTEtAnfP4MT53EqRFVqktqXGX+gd2if1R0vQagyMFutxdgMmhi+NYv0FTBY+iQKoImV11JruKoRf5Rs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709723160; c=relaxed/simple;
	bh=OS+oXHg7aIgyD5o++PSkxmSkn2TsWCyQ/F4rAy+jmpY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oEyZdl11Tk+tiQ5wtedlwyLgPpJauWaF3ICs5whqznprusSEg9XCwRVdaK4kT1fx5yq8bs6/ss7W/PVE20bKxAlou2bH3ZOsocvMy9SjxRjgKjApjD5BM84FxmUmWwZtAoctdndpifHxBjPDGOIQasUHju6iPFD3/typjuMO9Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IXFNjAth; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6e6419cd4ddso1294224b3a.2;
        Wed, 06 Mar 2024 03:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709723158; x=1710327958; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eENTc/nxZKDpcMdBkEdykK0etKdeqpDZmOKe+tsPiU0=;
        b=IXFNjAth8SuEdrGnbavCZCrioFohy1PJYMKhJmiz0hM8g2+11xjTErsVsHZFWSFVDM
         F0tiavxOS7LSOujQpcnsldj9wuHf3e4AdwhWZdK6D76KLB865H5pyS6gIagCufvR4INt
         zoTOhXzJQpqCmXf7M3VnQKVqeDeMFVW3hNAG6omjQHstJEB+iM+qDBTrzn5nTLZTod8D
         pDuEM07/OZkIL3HY+ceEkI7uFybOKk6KrGCB0cxu1zp3r2V+V+lYnD+cotdr/6RpjhBB
         e2O1iD5j7EGjwKuMJ+PjZyFJpcECKqhLyk3wZXdTIFlqSHH3Qjk1oHrAIhgL6/icoPMl
         /5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709723158; x=1710327958;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eENTc/nxZKDpcMdBkEdykK0etKdeqpDZmOKe+tsPiU0=;
        b=QJTXLOru/lD7Le1ua+MUCENHutziFhjpn20FjF6jq85EHs9n7hw5tZljitwx/xPhZF
         kzBBpFpFNqURiJoDKaDrvgiJeWSFb2yK1kf9ZAMAaN6CbaoLkjN3Q9QuVikbNaq109rG
         E2lDUy/VR82qC2FxsofSC49gku4+3CShADm4HqnMvBUnwxToHyYeaN3CUJkhSPwXBTqV
         W3ZRnCUgPPllGRTJzWmrhyxhgwvZekLmxOYVtM8TYOt5X3bR4GSA0+hISVg0Y/VOfV8i
         S29n3HPM48rJ+c3fyGTKGfc3jI3YHR2+gMT0abJ14BM4z2RhRQx8Bq8iy9hFef8Usp1g
         UaGg==
X-Forwarded-Encrypted: i=1; AJvYcCXkvTVxI63dw5FW3hlzVSN8ts3W+bRd3nvI5V011UzNURM4XNwbRsq9zKwr+0HlR5UfO12rNCQ9kQOKGWLszAH1VnTJDN+HK6MoISW4gHzFhYyi6BbmaPtG/BzoQpx60Phr
X-Gm-Message-State: AOJu0YwVhL7xvfvVUrDnesH4ha7+oYk500x5y2QZdJDe4HYnJbSJctpk
	9E8AL+Ny8nHLtNeV0pKm5yiBw7Ui9h6JhnBRbs5LlKvtmpBnE92OKFCsC+MzSyneeA==
X-Google-Smtp-Source: AGHT+IECYfeEfp2OiYGuDm/MEkbQ8cA4xsrb8XYKOoFlSJy2hf7HkSygK6o8CLzD+enHyL2n5m3+kQ==
X-Received: by 2002:a05:6a00:99c:b0:6e6:16b5:2eaa with SMTP id u28-20020a056a00099c00b006e616b52eaamr9567404pfg.7.1709723158290;
        Wed, 06 Mar 2024 03:05:58 -0800 (PST)
Received: from [192.168.255.10] ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id a3-20020aa78643000000b006e0debc1b75sm10725468pfo.90.2024.03.06.03.05.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 03:05:58 -0800 (PST)
Message-ID: <302ef225-7a45-4153-acd1-a0066b652da2@gmail.com>
Date: Wed, 6 Mar 2024 19:05:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/73] KVM: x86/PVM: Introduce a new hypervisor
Content-Language: en-US
To: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
 Sean Christopherson <seanjc@google.com>, Borislav Petkov <bp@alien8.de>,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
From: Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jiangshan,

On 26/2/2024 10:35 pm, Lai Jiangshan wrote:
> Performance drawback
> ====================
> The most significant drawback of PVM is shadowpaging. Shadowpaging
> results in very bad performance when guest applications frequently
> modify pagetable, including excessive processes forking.

Some numbers are needed here to show how bad this RFC virt-pvm version
without SPT optimization is in terms of performance. Compared to L2-VM
based on nested EPT-on-EPT, the following benchmarks show a significant
performance loss in PVM-based L2-VM (per pvm-get-started-with-kata.md):

- byte/UnixBench-shell1: -67%
- pts/sysbench-1.1.0 [Test: RAM / Memory]: -55%
- Mmap Latency [lmbench]: -92%
- Context switching [lmbench]: -83%
- syscall_get_pid_latency: -77%

Not sure if these performance conclusions are reproducible on your VM,
but it reveals the concern of potential users that there is not a strong
enough incentive to offload the burden of maintaining kvm-pvm.ko to the
upstream community until there is a public available SPT optimization
based on your or any state-of-art MMU-PV-ops impl. brought to the ring.

There are other kernel technologies used by PVM that have user scenarios
outside of PVM (e.g. unikernel/kernel-level sandbox), and it seems to me
that there's opportunities for all of them to be absorbed by upstream
individually and sequentially, but getting the KVM community to take
kvm-pvm.ko seriously may be more dependent on how much room there can
be for performance optimization based on your "Parallel Page fault for SPT
and Paravirtualized MMU Optimization" implementation, and the optimizing
space developers can squeeze out of legacy EPT-on-EPT solution.

> 
> However, many long-running cloud services, such as Java, modify
> pagetables less frequently and can perform very well with shadowpaging.
> In some cases, they can even outperform EPT since they can avoid EPT TLB
> entries. Furthermore, PVM can utilize host PCIDs for guest processes,
> providing a finer-grained approach compared to VPID/ASID.
> 
> To mitigate the performance problem, we designed several optimizations
> for the shadow MMU (not included in the patchset) and also planning to
> build a shadow EPT in L0 for L2 PVM guests.
> 
> See the paper for more optimizations and the performance details.
> 
> Future plans
> ============
> Some optimizations are not covered in this series now.
> 
> - Parallel Page fault for SPT and Paravirtualized MMU Optimization.

