Return-Path: <kvm+bounces-65902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 79984CB9FE2
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 23:55:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 23CFE3017A54
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 22:55:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93C3D30170B;
	Fri, 12 Dec 2025 22:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EREG08Bp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055AD3FFD
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 22:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765580109; cv=none; b=LE9IbCXskgN32N2ogx0wQSoPfJ9b2TVIMytRaF4OlqT3aqmtdPMWUQxq81gLhZYjkVV0BEzgOM2gkCTugapXRn33ZdyFzic23Ne4w801jOKG7A8TeYdZNHCS85oKC94R1os2CQIf+VVruCunw0ErLBH1iDzjDQhTg2SUXJpa1g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765580109; c=relaxed/simple;
	bh=bIF6Bo2epqbYmITgIckR0PAV4EA02NE1jjQfw25p3QM=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=qtdxH8rTgaGQ9q3WY58E0ykaHAU8E8fxp6NUiOcxhMyvLwKIReZS9dlN0CgDIgCupKckseTN4TJ0f3kxjXOSo2YyCZbZhI3c2DHpKdbv3WRrR61Vv1u7pYpI1vQe/KCVy7s66YKXaR3jD1hMJ1K63l4JJqvmDkvCtam1EHpoJ80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EREG08Bp; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-65b325457e5so1453426eaf.1
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 14:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765580107; x=1766184907; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Gf9nzt/AIijA0v6SQzCygaqS4FyyvskIif7ML2SRzkU=;
        b=EREG08BpDYUwlqkunNMgj89aVsu2u/3cqMutBwf/mxNlJc7m75YWxicoBReFcn4VX3
         ELIqjdcHXYbmwBlJn92PhBx/2RTE6HgnR5to2q0vaLLA+BuOjRxMHSRGCQCG8Q5kEgZf
         Ehii7IxEXPQ1TGn+Uu1HD6xZhDGSC5+keBq1DM23vhFrkwvZd+1kCs5O+n9gd3XLOXC8
         2v5gv5tRYEEGPXdPcqgQZcovwIvEgMa/syG8KpC1+VBJg4MOC3Cdb8YjtEA9pgsaTDiO
         RnbZ9KrraydttPIu9M2llTDE4C/vG3yQDR5PMcly/K3PbBLYqptCLbvY95QOtDZYERJ1
         jUAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765580107; x=1766184907;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gf9nzt/AIijA0v6SQzCygaqS4FyyvskIif7ML2SRzkU=;
        b=gXVnBKo1Wh5MhMyUaTU6zSGCtYC6VM96fTAd6vzuFBD73GVp2xzRAx9Uvpzwn7d6eH
         gxBcB4G3YQglKQndZSvoS/nWnk95a12EMNvFjf9gmXtHfsgMVlGjjEKLzKUq2mnQ6lba
         xXeD6tSexpcbzFkzLb1ebJHB0GiPOwHzh0CVcbX6vG4j5J0MjQDq2pVehHQQbsDfkWFy
         vwr9tUsUtfQCGwBs/Z8GKipOQ3BgY/Bez4WvdYjnYe7Hd7fcKHp3usv+8kxFeVdXCv2V
         vSWg/OijJ2FTFh+Ul2yEpWxt5U2mj765Clic9TIqDwsVSfIubsHXzWsRpKX4acQJ5Dj9
         RwEA==
X-Gm-Message-State: AOJu0YyPPkvDRjk4N0byAkRfq4Ecu5pu4aTT1eVB2RwwUG6BZgDLVy1P
	1vgKZeuV7jOetUfZQiTG5LLlmMG0e2TSpkJqiYKoWvK1wGFiowZ4h842bDeHupWb4EXGrTM68XZ
	Ju0NhqZkGTW5y+9u7MNvp66TR9Q==
X-Google-Smtp-Source: AGHT+IGW0I1EN/TmF7XRt1Ne1xEDcpx6Or2Kw9UCPmMzkWNCsmyBQjelpeiy18twJajc3tFWP5QaNlfD3CTKO6VqfQ==
X-Received: from ilbbd1.prod.google.com ([2002:a05:6e02:3001:b0:438:1345:e9c3])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:162a:b0:65b:25e8:13f1 with SMTP id 006d021491bc7-65b4529af0dmr1939098eaf.73.1765580107018;
 Fri, 12 Dec 2025 14:55:07 -0800 (PST)
Date: Fri, 12 Dec 2025 22:55:06 +0000
In-Reply-To: <aTioEWHu0ZbFCjR6@kernel.org> (message from Oliver Upton on Tue,
 9 Dec 2025 14:52:01 -0800)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsnt8qf72tv9.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v5 21/24] KVM: arm64: Inject recorded guest interrupts
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

> In no situation should KVM be injecting a "recorded" IRQ. The overflow
> condition of the PMU is well defined in the architecture and we should
> implement *exactly* that.

When I say "record" I just meant "updating the virtual overflow register
to reflect an overflow".

Do you think I'm not implementing the condition correctly in
kvm_pmu_part_overflow_status()?

> On Tue, Dec 09, 2025 at 08:51:18PM +0000, Colton Lewis wrote:
>> +/**
>> + * kvm_pmu_part_overflow_status() - Determine if any guest counters  
>> have overflowed
>> + * @vcpu: Ponter to struct kvm_vcpu
>> + *
>> + * Determine if any guest counters have overflowed and therefore an
>> + * IRQ needs to be injected into the guest.
>> + *
>> + * Return: True if there was an overflow, false otherwise
>> + */
>> +bool kvm_pmu_part_overflow_status(struct kvm_vcpu *vcpu)
>> +{
>> +	struct arm_pmu *pmu = vcpu->kvm->arch.arm_pmu;
>> +	u64 mask = kvm_pmu_guest_counter_mask(pmu);
>> +	u64 pmovs = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
>> +	u64 pmint = read_pmintenset();
>> +	u64 pmcr = read_pmcr();

> How do we know that the vPMU has been loaded on the CPU at this point?

Because this is only called by kvm_pmu_update_state which is only called
by kvm_pmu_update_state <- kvm_pmu_{flush,sync}_hwstate <-
kvm_arch_vcpu_ioctl_run after a vcpu_load.

>> +
>> +	return (pmcr & ARMV8_PMU_PMCR_E) && (mask & pmovs & pmint);
>> +}

> I'd rather reuse kvm_pmu_overflow_status(), relying on the accessors to
> abstract away the implementation / location of the guest PMU context.

Agreed on making some generic accessors.

> Thanks,
> Oliver

