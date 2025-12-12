Return-Path: <kvm+bounces-65900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C76CECB9F52
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 23:37:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6077530A0FAA
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 22:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03A342D94AA;
	Fri, 12 Dec 2025 22:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rTirMttk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268AD2877E9
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 22:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765579005; cv=none; b=WiDHCj898ZafUNQrvIPwpK3frCtKnRu4sa3D48QTFtGPoxv6WuSnLpxjBmH0oe6xwSeTHjYPhm8xCkTAH1hZLIdao7dWlUx7T9+0vu7+X10ttvWFEpeV9/dIaTp2EK/ODzlcjaEBjRWqqfnUWSMIp0gCAYopvmZ39cbOnco/tp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765579005; c=relaxed/simple;
	bh=9mFmYvzmJytgvfdsMLBBujUvcXmuhikrBpixw/LzYIw=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=JFZkRARZ4cyFPwAimpqfbEPCHBezolQ99D6mYXTPWxHXixjXgmSdtyeWyJeXFz0IbgNAxbGFB1r2bDFxpSjOjHlzTi2HbOAo8MBbDa4QDQ9zF7B7z03wInm3G5BxLraDLh1xh0dtbdTKgCqI7JcEAv9d/mps9rk5yfh6Jb41GpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rTirMttk; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-65b342ac488so1410669eaf.0
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 14:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765579002; x=1766183802; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3V7ABHshgDafwAwYHEV+MXsyHyX7z1eKDaoAGOxARUw=;
        b=rTirMttkQrnbaFs8ND7eaXf3Y2Qzag51ROsEATytlhkUOYEg/Jp8mKIz9cTYONj0hB
         i4m7qIfpigLAIinGJTdN4t+ZnwXgUxq1zzjn/O//u69WOXNlJHXBAIpTZ/fnb/gNsSo8
         9HT8A25JI+BaBZY2lgByhz7ypeTm9aT8uc7mMMblKOUSOv9HspK+KRLNal81or2lsrqR
         Aia4/dwe8hA0uWoVuCgOR3pQ533UI8yXaexHHQ+m0sPZN14XefyjDfs1Qpvd9vXgis+m
         ovz8xTFGLD+2DuNPINpgLKo8X2gK+IiKTIb6Q/WnVtbvp9QdVs75fxL8cnUE8OcNSP5D
         9I4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765579002; x=1766183802;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3V7ABHshgDafwAwYHEV+MXsyHyX7z1eKDaoAGOxARUw=;
        b=AYe94YluWf97afTTp5cJYtGiC0+k4w0TXNrBddPg1QcyMh/zN8Q2SVJbTHaBHm61Ff
         KpvkJ4LSbzYPm8SxNstAE5MZHAW4fzq8t4Q/J8o1QpiVr5vl4OT9M2gFHL+hfYBiE26n
         ZuANs/yT3zBJ01HFfe29bvXBYpaCxQxLmluiPZdczUqD97qrBALoPSt99gABFcadhhcw
         WBdXj5k2DEX9l90MwyRabBY1jr4kRmChmhRkpRUM4iKfvuKyqbjIt3KwqkbclYVebX5l
         ce5C3HWmG78VT25kuCO80n0U116UKqytAQmRNZG6gejfwCpOUwKrsrz5MiGRBhg08/9+
         VZTQ==
X-Gm-Message-State: AOJu0YxRpTX/LWzmxx0auCJpK+rVqoHXRY6W5JzysV1sM2fygYTKGivT
	0GmskLwYnZk9ppslx3YFRkiLHX6PG8UlCQLDtZe27HXyaFOntSyU13V0qVsFdwdLNPYI9+brUdF
	6RW/1lSuDnoqeT80PyxTltIY6uA==
X-Google-Smtp-Source: AGHT+IHkZVgWFjBleB6izi/mYS6b4xrdOCdIwFPbm2svitIfX3LWxEQK52duuNdAGmZBwWfL5PIEmP5Eu+rxvNmu9A==
X-Received: from ilbbl8.prod.google.com ([2002:a05:6e02:32c8:b0:434:972f:bf90])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:2223:b0:659:858f:f1d3 with SMTP id 006d021491bc7-65b44ff60f4mr1625746eaf.0.1765579002046;
 Fri, 12 Dec 2025 14:36:42 -0800 (PST)
Date: Fri, 12 Dec 2025 22:36:41 +0000
In-Reply-To: <aTimpRFfr9wI9Hw5@kernel.org> (message from Oliver Upton on Tue,
 9 Dec 2025 14:45:57 -0800)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsntbjk32upy.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v5 20/24] perf: arm_pmuv3: Handle IRQs for Partitioned PMU
 guest counters
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oupton@kernel.org>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oupton@kernel.org> writes:

> On Tue, Dec 09, 2025 at 08:51:17PM +0000, Colton Lewis wrote:
>> Because ARM hardware is not yet capable of direct interrupt injection

> PPI injection, it can do LPIs just fine.

Clarification noted. I will update the message.

>> @@ -961,6 +964,12 @@ static irqreturn_t armv8pmu_handle_irq(struct  
>> arm_pmu *cpu_pmu)
>>   		 */
>>   		perf_event_overflow(event, &data, regs);
>>   	}
>> +
>> +	govf = pmovsr & kvm_pmu_guest_counter_mask(cpu_pmu);
>> +
>> +	if (kvm_pmu_is_partitioned(cpu_pmu) && govf)
>> +		kvm_pmu_handle_guest_irq(govf);
>> +

> The state ownership of this whole interaction is very odd. I would much
> rather that KVM have full ownership of the range of counters while the
> guest is loaded. By that I mean the PMUv3 driver only clears overflows
> on PMCs that it owns and KVM will do the same on the back of the IRQ.

If I'm understanding correctly this is a code location concern, because
the host driver has to handle the interrupt in this function or a callee
of this function.

I will do it that way. It would be duplicating a small amount of logic
in kvm_pmu_handle_guest_irq() but I see your reasoning.

> Similarly, KVM should be leaving the "guest" range of counters in a
> non-overflow condition at vcpu_put().

Noted from your comments on kvm_pmu_put()


> Thanks,
> Oliver

