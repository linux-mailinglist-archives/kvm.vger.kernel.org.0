Return-Path: <kvm+bounces-14691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B4DFF8A5B66
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 21:49:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1CAC2B23A95
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 19:49:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16C04159910;
	Mon, 15 Apr 2024 19:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bLS/tGNy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60861598E7
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 19:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713210028; cv=none; b=lmrJaNf7Fja1QjR6i68kWg/WvlArwsKGqr608/Uad0aJkQvszqvmH2zG+KYrtDQL1/6dma/UZKPA0urCGYc28Tkmg7+0xIimhGP2KadFXzoBkrkO4g9ykwvneM7wnfZzEtEud6sao+LkaV2X+yL0zMbBfL/tokxKO2u0OPgbN1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713210028; c=relaxed/simple;
	bh=HnQrke53HbieJQg1K+HmxDC5DcgHzycPVXayX92Uel0=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=tWrMiVpENnRDtIGtdE6r9UCA6v5aYKqcjj7DNVVm5Tl9Zb1Xu5WksEbjz4lTDrMxKdq9pApeVnq5dxznnsOxyqIFWCxJKyH5oB9SCSVyw4v7uOrSrz6lyTL7VdSgPnoSSP5QCeK1FDXIELSjijrqjkXwtYjuQfkJEugrUN/6I+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bLS/tGNy; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-7cc7a6a04d9so453032639f.3
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 12:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713210026; x=1713814826; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=taYfEAMhWxZKhDVEpiZhlMgSXjBrsWj8geaLNIGWoBE=;
        b=bLS/tGNySaiyrIyV7Ze0eNjuUOx5/KpUk4xcIxQgTNZkaZ6mQwsXLlD8eCVdZTd/K5
         1zURDk2OGz+Bpv/xYUV00LhUDp8DWvF6Wo3P/dt5E6ktAQaLScHF6iRXZ/4VHPtQOurh
         Yu83Cbk5q8HMgjJeVMrr+/vD0f+P8YrM5O7PRdDNs1zLYV+7F5kZrQNUAZ5MT/XsYapG
         uOqbEXH6lXqSPuB4OieEaWoXcCl/b/MtRlyWLd+GJb5HBXjvCKMLA62tnw6oj9fKbV6i
         WR1aYTHmLTo9jG9guV/aMPGZwYauhD72iG96dwIc/7s9V7lQXgquL2EUo7JlcQ3ex1zV
         rMfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713210026; x=1713814826;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=taYfEAMhWxZKhDVEpiZhlMgSXjBrsWj8geaLNIGWoBE=;
        b=H9Zut24ndzBq2FWVrzK4GrTtJDNCBm4bO51I/hgwTNsM4mbo14jKWq1jLNkaWmOr+I
         k8mjce+U8L+Ec0PyrWbrauEGMYds8DnK7xQbAY74xtWnwd3ZLcT1RCi8hrg1Sm3vMGlK
         LP6tQa4gHJy1+DdgOdH2HWldEofweXZEqCIsFcONiVGuZSsg3sXu8txVNL/0QZs/dS+K
         e8LGXX7+f5KD2RGVpAohTT84GD9IBmINU/JooirD4Rvg+2b6aJmj1kYuhb3dNhAZc+rT
         P0Pcl2rcKajRnai1v7pyU1EqUmeYnLxsmsjrsHHWthQCz6oejv9pqhzgRoAMkMfrMKgH
         XEWA==
X-Gm-Message-State: AOJu0YwmaOYR3jgXnie/X+i2UTM6yJUyiZT1rj6WHSzob8x17JRqw6r0
	xFET/xk5eDzJBuNDzRjxA/bXFKGQfRCHEq6NijCN8YuOOgEO2kUXlSaKmQQxZnkxZir18d9lFdl
	MBaMtxHIy1yWeqmRQ84bIPw==
X-Google-Smtp-Source: AGHT+IGUqapQXFj2hPWnTQ4fKWHkr8XUX4Eacrb1Di5Og6Xvq8008PLajdkB1V4vRSdttFUHw7IRCbM2YDH38IdHzw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:34ab:b0:482:fc24:b74c with
 SMTP id t43-20020a05663834ab00b00482fc24b74cmr472110jal.0.1713210026131; Mon,
 15 Apr 2024 12:40:26 -0700 (PDT)
Date: Mon, 15 Apr 2024 19:40:24 +0000
In-Reply-To: <86sezss5cm.wl-maz@kernel.org> (message from Marc Zyngier on Thu,
 11 Apr 2024 08:53:13 +0100)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsnth6g2qus7.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v3] KVM: arm64: Add early_param to control WFx trapping
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Thanks for the review Marc.

Marc Zyngier <maz@kernel.org> writes:

> On Wed, 10 Apr 2024 18:54:37 +0100,
> Colton Lewis <coltonlewis@google.com> wrote:
>> +
>> +enum kvm_interrupt_passthrough {
>> +	KVM_INTERRUPT_PASSTHROUGH_DEFAULT,
>> +	KVM_INTERRUPT_PASSTHROUGH_ALWAYS,
>> +	KVM_INTERRUPT_PASSTHROUGH_NEVER,

> What does this mean? This is not dealing with interrupts, this is
> supposed to deal with the behaviour of specific instructions
> (WFI/WFE). The notion of "passthrough" is really odd as well. Finally,
> both ALWAYS and NEVER are wrong -- the architecture makes no such
> guarantee.

Looking at this, I did let the language get away from me by mixing up
interrupts and the instructions dealing with them.

"Passthrough" is not a technical term but has pervaded some of my
internal conversations about this and I've just been using it to mean
the opposite of trapping. That can be easily swapped.

I understand always and never are not what the architecture guarantees,
but was trying to capture what KVM code is attempting to do. I could
just drop it entirely.

So the enum values could be named something like:

KVM_WFX_TRAP
KVM_WFX_NOTRAP
KVM_WFX_NOTRAP_SINGLE_TASK (default option)

>> -	if (single_task_running())
>> +	if ((kvm_interrupt_passthrough == KVM_INTERRUPT_PASSTHROUGH_ALWAYS
>> +	     && kvm_vgic_global_state.has_gicv4) ||
>> +	    (kvm_interrupt_passthrough == KVM_INTERRUPT_PASSTHROUGH_DEFAULT
>> +	     && single_task_running()))

> Why is this affecting both WFI and WFE? They are very different and
> lumping them together makes little sense.

It's true they are different, but I couldn't think of any cases where
you would want trapping for one to be different than for the other. The
current behavior also assumes trapping should be the same for both.

Are you suggesting separate controls for the two?

>> @@ -2654,6 +2658,30 @@ static int __init early_kvm_mode_cfg(char *arg)
>>   }
>>   early_param("kvm-arm.mode", early_kvm_mode_cfg);

>> +static int __init early_kvm_interrupt_passthrough_cfg(char *arg)
>> +{
>> +	if (!arg)
>> +		return -EINVAL;
>> +
>> +	if (strcmp(arg, "always") == 0) {
>> +		kvm_interrupt_passthrough = KVM_INTERRUPT_PASSTHROUGH_ALWAYS;
>> +		return 0;
>> +	}
>> +
>> +	if (strcmp(arg, "never") == 0) {
>> +		kvm_interrupt_passthrough = KVM_INTERRUPT_PASSTHROUGH_NEVER;
>> +		return 0;
>> +	}
>> +
>> +	if (strcmp(arg, "default") == 0) {
>> +		kvm_interrupt_passthrough = KVM_INTERRUPT_PASSTHROUGH_DEFAULT;
>> +		return 0;
>> +	}
>> +
>> +	return -EINVAL;
>> +}
>> +early_param("kvm-arm.interrupt-passthrough",  
>> early_kvm_interrupt_passthrough_cfg);
>> +

> Again, this is not dealing with interrupts. This is dealing with the
> *potential* trapping of instructions in certain circumstances.

Understood. Should be something like "kvm-arm.wfx-instruction-trapping".

>>   enum kvm_mode kvm_get_mode(void)
>>   {
>>   	return kvm_mode;

> Finally, this needs to be documented.

Right, in Documentation/admin-guide/kernel-parameters.txt

