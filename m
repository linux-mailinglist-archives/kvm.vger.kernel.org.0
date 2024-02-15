Return-Path: <kvm+bounces-8743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0543C855ECE
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 11:11:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ACCC81F25544
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 10:11:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF84E6994D;
	Thu, 15 Feb 2024 10:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="D8rhLhfm"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B42679FE;
	Thu, 15 Feb 2024 10:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707991880; cv=none; b=Y5tZURc/NxGG7sKmg8zMUHFQznINMJlVuWKG2uXAsRzbU7vRC+a4atgyB+e6bO+2D8h8AWGDJaze/4wvZk7BkzTfW7hY6rq6MHQICR2iOmHDk3IG4Bl7MQahA2ZR2ulKE1+ITEElxHHM8+NikdUn42Qly2F9HNK7whlMZPu6ntM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707991880; c=relaxed/simple;
	bh=xW+SMn0yzEP/atgRxvcp9tLl5suSkW1RNJRYWpnVzMw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=evIdEcEJWOsMfS5pcffuz/4WxaBspfrhk+T3T7bg/RubsFJ+qA8fRZs1oxgpFZSby1iUNNYVgJRpDwYGB4KkoPw/QM8NTBKpd9Ll1Jx0/2taa49NUZNKBRrVMuWwP7pPMuG3HVfdkrGa/NksjYgaft85mKcKa9S/FTT6lzBD7DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=D8rhLhfm; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1707991875; bh=xW+SMn0yzEP/atgRxvcp9tLl5suSkW1RNJRYWpnVzMw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=D8rhLhfmUsPVebdqxjmKjA3kZ3+hs01T1ZODKFHrBEuL4KR0WjE5tXdkjPjXvRuGC
	 f2gVDGHZAr8bLZnWPJ8TFOcxDgRaNTPVeZZ+rtAJ04TTcR6/DMpX+OXJFmodbBg79o
	 /1mtIiq5IregwWfi0EnZt1u/F/zuZWlae+14ueb0=
Received: from [28.0.0.1] (unknown [49.93.119.4])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 0960E60114;
	Thu, 15 Feb 2024 18:11:14 +0800 (CST)
Message-ID: <0f4d83e2-bff9-49d9-8066-9f194ce96306@xen0n.name>
Date: Thu, 15 Feb 2024 18:11:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/6] LoongArch: Add pv ipi support on LoongArch VM
Content-Language: en-US
To: Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
References: <20240201031950.3225626-1-maobibo@loongson.cn>
From: WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <20240201031950.3225626-1-maobibo@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 2/1/24 11:19, Bibo Mao wrote:
> [snip]
>
> Here is the microbenchmarck data with perf bench futex wake case on 3C5000
> single-way machine, there are 16 cpus on 3C5000 single-way machine, VM
> has 16 vcpus also. The benchmark data is ms time unit to wakeup 16 threads,
> the performance is higher if data is smaller.
> 
> perf bench futex wake, Wokeup 16 of 16 threads in ms
> --physical machine--   --VM original--   --VM with pv ipi patch--
>    0.0176 ms               0.1140 ms            0.0481 ms
> 
> ---
> Change in V4:
>    1. Modfiy pv ipi hook function name call_func_ipi() and
> call_func_single_ipi() with send_ipi_mask()/send_ipi_single(), since pv
> ipi is used for both remote function call and reschedule notification.
>    2. Refresh changelog.
> 
> Change in V3:
>    1. Add 128 vcpu ipi multicast support like x86
>    2. Change cpucfg base address from 0x10000000 to 0x40000000, in order
> to avoid confliction with future hw usage
>    3. Adjust patch order in this patchset, move patch
> Refine-ipi-ops-on-LoongArch-platform to the first one.

Sorry for the late reply (and Happy Chinese New Year), and thanks for 
providing microbenchmark numbers! But it seems the more comprehensive 
CoreMark results were omitted (that's also absent in v3)? While the 
changes between v4 and v2 shouldn't be performance-sensitive IMO (I 
haven't checked carefully though), it could be better to showcase the 
improvements / non-harmfulness of the changes and make us confident in 
accepting the changes.

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/


