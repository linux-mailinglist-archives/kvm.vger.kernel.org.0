Return-Path: <kvm+bounces-45817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53CD7AAF003
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 02:35:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 498E54E45DF
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 00:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2EB3139CE3;
	Thu,  8 May 2025 00:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OSqRsCV4"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C44F80034
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 00:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746664497; cv=none; b=px2tq1vo5alPCMhpprP2V+IFjhe7SddRqdbGHjVfo6Yv09+JqM3ElvgnuXkgu2pWKJlOAFxcxMLYbNza1ImEy0mJXJ7phlhIqXAfXRcOMnkaGS6T5kPdgpAH9Gfji71Cz+4nb9rEa55MgWPxwkTK2ZdOXI63PGP4hQer+vngZAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746664497; c=relaxed/simple;
	bh=E++WLKC1b5AMh3N+lcjBZDykyM88OV7ldVp6UoKnQ88=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lpqYB1nH/K0schiZzzyWmIoJ/dDFd1f5jaNBZ9IDWqPjZ65UCP5oZ2TKzAZlGwAA+XVtagEKrxws1fxQjGPpfiWlGxHEpU8zoRzsMVNCwmZsUYZGkDd8zbuOQjuZWe3zwmowq+W+oUBZ6H7JPt6DDRHg1sZeDalP/hoV/VefaHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OSqRsCV4; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <ec73105c-f359-4156-8285-b471e3521378@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746664483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pU21r1AALBbTx/oUKK/Y9bNXG599CWsACufdbKUbqOw=;
	b=OSqRsCV4qL2fo52Kc0kdhJbHN7ycGcOhAPFKIhgbmwX7rTfdAlpHaDcJpo9fvsJ9NnZJfS
	SBwKQi4dnGQT0j8jhx3iAgcyFnZj/GZMh2BW8YWIhZ+RJw6SxTKtD6NUdL5tP4J7UZw+qt
	D1Ugcu2fXazyL3Vi18jQ7QXRm5LI7u0=
Date: Wed, 7 May 2025 17:34:38 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 0/5] Enable hstateen bits lazily for the KVM RISC-V Guests
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-riscv <linux-riscv-bounces@lists.infradead.org>
References: <20250505-kvm_lazy_enable_stateen-v1-0-3bfc4008373c@rivosinc.com>
 <D9OYWFEXSA55.OUUXFPIGGBZV@ventanamicro.com>
 <bc0f1273-d596-47dd-bcc6-be9894157828@linux.dev>
 <D9Q05T702L8Y.3UTLG7VXIFXOK@ventanamicro.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <D9Q05T702L8Y.3UTLG7VXIFXOK@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 5/7/25 7:36 AM, Radim Krčmář wrote:
> 2025-05-06T11:24:41-07:00, Atish Patra <atish.patra@linux.dev>:
>> On 5/6/25 2:24 AM, Radim Krčmář wrote:
>>> 2025-05-05T14:39:25-07:00, Atish Patra <atishp@rivosinc.com>:
>>>> This series adds support for enabling hstateen bits lazily at runtime
>>>> instead of statically at bootime. The boot time enabling happens for
>>>> all the guests if the required extensions are present in the host and/or
>>>> guest. That may not be necessary if the guest never exercise that
>>>> feature. We can enable the hstateen bits that controls the access lazily
>>>> upon first access. This providers KVM more granular control of which
>>>> feature is enabled in the guest at runtime.
>>>>
>>>> Currently, the following hstateen bits are supported to control the access
>>>> from VS mode.
>>>>
>>>> 1. BIT(58): IMSIC     : STOPEI and IMSIC guest interrupt file
>>>> 2. BIT(59): AIA       : SIPH/SIEH/STOPI
>>>> 3. BIT(60): AIA_ISEL  : Indirect csr access via siselect/sireg
>>>> 4. BIT(62): HSENVCFG  : SENVCFG access
>>>> 5. BIT(63): SSTATEEN0 : SSTATEEN0 access
>>>>
>>>> KVM already support trap/enabling of BIT(58) and BIT(60) in order
>>>> to support sw version of the guest interrupt file.
>>> I don't think KVM toggles the hstateen bits at runtime, because that
>>> would mean there is a bug even in current KVM.
>> This was a typo. I meant to say trap/emulate BIT(58) and BIT(60).
>> This patch series is trying to enable the toggling of the hstateen bits
>> upon first access.
>>
>> Sorry for the confusion.
> No worries, it's my fault for misreading.
> I got confused, because the code looked like generic lazy enablement,
> while it's really only for the upper 32 bits and this series is not lazy
> toggling any VS-mode visible bits.
>
>>>>                                                      This series extends
>>>> those to enable to correpsonding hstateen bits in PATCH1. The remaining
>>>> patches adds lazy enabling support of the other bits.
>>> The ISA has a peculiar design for hstateen/sstateen interaction:
>>>
>>>     For every bit in an hstateen CSR that is zero (whether read-only zero
>>>     or set to zero), the same bit appears as read-only zero in sstateen
>>>     when accessed in VS-mode.
>> Correct.
>>
>>> This means we must clear bit 63 in hstateen and trap on sstateen
>>> accesses if any of the sstateen bits are not supposed to be read-only 0
>>> to the guest while the hypervisor wants to have them as 0.
>> Currently, there are two bits in sstateen. FCSR and ZVT which are not
>> used anywhere in opensbi/Linux/KVM stack.
> True, I guess we can just make sure the current code can't by mistake
> lazily enable any of the bottom 32 hstateen bits and handle the case
> properly later.

I can update the cover letter and leave a comment about that.

Do you want a additional check in sstateen 
trap(kvm_riscv_vcpu_hstateen_enable_stateen)
to make sure that the new value doesn't have any bits set that is not 
permitted by the hypervisor ?

>> In case, we need to enable one of the bits in the future, does hypevisor
>> need to trap every sstateen access ?
> We need to trap sstateen accesses if the guest is supposed to be able to
> control a bit in sstateen, but the hypervisor wants to lazily enable
> that feature and sets 0 in hstateen until the first trap.
Yes. That's what PATCH 4 in this series does.
> If hstateen is 1 for all features that the guest could control through
> sstateen, we can and should just set the SE bit (63) to 1 as well.
>
>> As per my understanding, it should be handled in the hardware and any
>> write access to to those bits should be masked
>> with hstateen bit value so that it matches. That's what we do in Qemu as
>> well.
> Right, hardware will do the job most of the time.  It's really only for
> the lazy masking, beause if we don't trap the stateen accesses, they
> would differ from what the guest should see.

