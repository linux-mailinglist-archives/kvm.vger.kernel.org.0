Return-Path: <kvm+bounces-45658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C4D5FAACD31
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 20:25:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD9821B68B84
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:25:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0118C28642E;
	Tue,  6 May 2025 18:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k0R83fqY"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225C22857F0
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 18:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746555893; cv=none; b=QAQqhUiN0bVY0B3S18sPoElOCTZ6z4Ejr1qLDF0qRKVrmUGEpf70bqnt13/eHShi+Atg+MY8CMSr0oy1+4EbCjHk9HDUQie4gV9158Mrk470I3nE8c2kIUsURL82/95YOpsD1ePTbnlpL0bnuBzlbcJbRM0yuze2DzNYMnZvtTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746555893; c=relaxed/simple;
	bh=uCfaIfnnCWSBy+q1M1s63XCLCanHkjTurho6DqyCykc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=odMCwtWNA0UL0AP8nmGG8wu1CPD6CQJhdzTHMuuoXITd+bFwrDt5Lv1OgotwMZ0/3hi/+OivB0wvkdhDBRJTqlTZ+WZbTfOXqjj/aKZqKkXg/8DCm9pPRVRPVhTRMCWO96OdNUoBEIx2MXZYxMmDa9dmJjAPkYkpblO98x9ivsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k0R83fqY; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <bc0f1273-d596-47dd-bcc6-be9894157828@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746555888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yg0ojWgQyQzU5i4Zxk36RG+sOM1+p0j0oZkxihGIqjM=;
	b=k0R83fqYWpu7LJn4XbkVaJzLInKcqjnv1ZRLheQSZAv864qp2zIP1leM7Q9wUmA/lM8AHO
	DXPpLHFHSkf7TaG3pm7MA9uOLqSQCnIDRmLFBRFB6aVPp2ow0PEjJgrTFCJnYc+CVnogx5
	J+s+IM6OyoMt8Axfr7Mcsh+LkLx2WbA=
Date: Tue, 6 May 2025 11:24:41 -0700
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
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <D9OYWFEXSA55.OUUXFPIGGBZV@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 5/6/25 2:24 AM, Radim Krčmář wrote:
> 2025-05-05T14:39:25-07:00, Atish Patra <atishp@rivosinc.com>:
>> This series adds support for enabling hstateen bits lazily at runtime
>> instead of statically at bootime. The boot time enabling happens for
>> all the guests if the required extensions are present in the host and/or
>> guest. That may not be necessary if the guest never exercise that
>> feature. We can enable the hstateen bits that controls the access lazily
>> upon first access. This providers KVM more granular control of which
>> feature is enabled in the guest at runtime.
>>
>> Currently, the following hstateen bits are supported to control the access
>> from VS mode.
>>
>> 1. BIT(58): IMSIC     : STOPEI and IMSIC guest interrupt file
>> 2. BIT(59): AIA       : SIPH/SIEH/STOPI
>> 3. BIT(60): AIA_ISEL  : Indirect csr access via siselect/sireg
>> 4. BIT(62): HSENVCFG  : SENVCFG access
>> 5. BIT(63): SSTATEEN0 : SSTATEEN0 access
>>
>> KVM already support trap/enabling of BIT(58) and BIT(60) in order
>> to support sw version of the guest interrupt file.
> I don't think KVM toggles the hstateen bits at runtime, because that
> would mean there is a bug even in current KVM.

This was a typo. I meant to say trap/emulate BIT(58) and BIT(60).
This patch series is trying to enable the toggling of the hstateen bits 
upon first access.

Sorry for the confusion.

>>                                                     This series extends
>> those to enable to correpsonding hstateen bits in PATCH1. The remaining
>> patches adds lazy enabling support of the other bits.
> The ISA has a peculiar design for hstateen/sstateen interaction:
>
>    For every bit in an hstateen CSR that is zero (whether read-only zero
>    or set to zero), the same bit appears as read-only zero in sstateen
>    when accessed in VS-mode.

Correct.

> This means we must clear bit 63 in hstateen and trap on sstateen
> accesses if any of the sstateen bits are not supposed to be read-only 0
> to the guest while the hypervisor wants to have them as 0.

Currently, there are two bits in sstateen. FCSR and ZVT which are not 
used anywhere in opensbi/Linux/KVM stack.

In case, we need to enable one of the bits in the future, does hypevisor 
need to trap every sstateen access ?
As per my understanding, it should be handled in the hardware and any 
write access to to those bits should be masked
with hstateen bit value so that it matches. That's what we do in Qemu as 
well.


> Thanks.

