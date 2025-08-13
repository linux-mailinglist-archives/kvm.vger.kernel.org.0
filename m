Return-Path: <kvm+bounces-54615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FFFEB25633
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 00:02:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28985563206
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 22:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90B2C3009DA;
	Wed, 13 Aug 2025 22:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2rQFB0Av"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2682D3727
	for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 22:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755122514; cv=none; b=mazYRz898iiOo9681oYCIleU1i8xCtRFWfQfBaxFcvWMhc/SxV/nvbGNusHurLslCe/NVUSaZJyVxtxXoQPMvGpJ+ZVX4cw8jk3idPz5TWdxV0L+zl2K6W+GYyA1cuKavgP5bEe0pp0noSCQZiVDVlp9jeg9LOhX5n4u5nxrXL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755122514; c=relaxed/simple;
	bh=RH+90nQ0r0rQd7AUFhTs/1Hi439AwUXYx50x6ncYXEk=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ZwmpWduxDJztmFUmeOPBXTmGGBzdRA6q86mGUtr35ztuRdV1K6fFiP9+fU+li8Y7t06uDw6e2YymqtZHQo72XRH3wgEsWNTmBKjBCoUPG7Wb+fCI3b+LeA0YLfx6Us7E+9/YTVydfwpDctzwu556p27K+8UfaZ+w614kApcsJk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2rQFB0Av; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-88432ccc211so38861639f.0
        for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 15:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755122512; x=1755727312; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Lffc0WMub0rTiOOasAgzp27lbUXwGqsfsYixfeu01z4=;
        b=2rQFB0Av6IF5cKZLwYnHy9c5DAgTC/EGmKX9NrhCQ19OVnkVxZwtam3XIc8OfgqHQf
         axpYHg+9S6MgCmqeCZbP84McFEjflPBBk2IQLIBBl4uFU/YKtBj+fNky2pYu30u30IqP
         aHpYtcssUihfEMNKwF0oinMArgvHv6TnFfkVw7Y3Ts4mIbNEfWJjcLS9LdN2J/NM7EpV
         2QvmXFTdwMy7drVEq7aX5dVbLWwCSxDVDJh/79B14F4hul6/BfjpD7TWkm3RuRvJ7UiV
         UkpW0Rv3N/hWh6S8k24QtgZ86G9sExnRQvafVbeyLfEHhzQ3SNySGscO08E8I2kqLa6L
         knrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755122512; x=1755727312;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lffc0WMub0rTiOOasAgzp27lbUXwGqsfsYixfeu01z4=;
        b=FTHAOZNN7yEvU4+sdF1uIjJ3/LuWgrdEMn6nwIJePSqHSmptjLeLZ6IdkYReeZkfzM
         2nXbxWEChmAQrKJZa9r6HtlZHb5Lu4vMsSzllAl6u2LkAHpV4SrVs65SibSmQj9ShwtF
         0K46G/ORwKWCqpWc0O135+Qs69wF/CE6bjQxk+fTJq71jt8NO3kw1oU7gN5XkI1MYTRB
         gChHfz3aZoEmfisyWZt4+OqZ7k6vInyqyAe6UIJ0M9YBfrudytZOXPzZPn/8YkR4Yt1/
         oHtBTO0D/OSTLVSCgYqFB4+6tKT372ByKBcS+LRgzdq+W9bCg/6buxyqNQN7FXOrmrzs
         NKsg==
X-Gm-Message-State: AOJu0YzkS8hrOmJ3B0iI6veKTC6xCcDfDWNNkuMTzN1c4bykBZ2hdmOW
	QA6IV137NsWgixQ7ytucDuYmXtX7B2Wutn7oQIhuwXqRWhpU40LkBXupXeUdLftqjdJOTmapP6v
	AZ404HJFVsEfTcd3OfzB81ZCMMg==
X-Google-Smtp-Source: AGHT+IG5r8vYJD9ejnNmOkd2D/b3gPNw0HLwazt4Xo6qZB5BPCocG+3nQgDyMNKMBq/qXmrpxMezac4YdgIdTVzxSA==
X-Received: from iosu8.prod.google.com ([2002:a05:6602:29a8:b0:87c:58a2:24c5])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6602:26cd:b0:86a:84f:7a45 with SMTP id ca18e2360f4ac-8843382aa8cmr146631439f.8.1755122511931;
 Wed, 13 Aug 2025 15:01:51 -0700 (PDT)
Date: Wed, 13 Aug 2025 22:01:50 +0000
In-Reply-To: <20250714225917.1396543-11-coltonlewis@google.com> (message from
 Colton Lewis on Mon, 14 Jul 2025 22:59:04 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsntwm76ricx.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v4 10/23] KVM: arm64: Writethrough trapped PMEVTYPER register
From: Colton Lewis <coltonlewis@google.com>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Colton Lewis <coltonlewis@google.com> writes:

> With FGT in place, the remaining trapped registers need to be written
> through to the underlying physical registers as well as the virtual
> ones. Failing to do this means delaying when guest writes take effect.

> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>   arch/arm64/kvm/sys_regs.c | 28 +++++++++++++++++++++++++++-
>   1 file changed, 27 insertions(+), 1 deletion(-)

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index b3f97980b11f..704e5d45ce52 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1036,6 +1036,30 @@ static bool access_pmu_evcntr(struct kvm_vcpu  
> *vcpu,
>   	return true;
>   }

> +static bool writethrough_pmevtyper(struct kvm_vcpu *vcpu, struct  
> sys_reg_params *p,
> +				   u64 reg, u64 idx)
> +{
> +	u64 eventsel;
> +
> +	if (idx == ARMV8_PMU_CYCLE_IDX)
> +		eventsel = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
> +	else
> +		eventsel = p->regval & kvm_pmu_evtyper_mask(vcpu->kvm);
> +
> +	if (vcpu->kvm->arch.pmu_filter &&
> +	    !test_bit(eventsel, vcpu->kvm->arch.pmu_filter))
> +		return false;

I made a mistake here. The thing tested in the pmu_filter should be &
kvm_pmu_event_mask(), not & kvm_pmu_evtyper_mask()

Then, the value written to the register should be &
kvm_pmu_evtyper_mask()

There might be a similar mistake in Patch 17 where I enforce the filter
at vcpu load time.

> +
> +	__vcpu_assign_sys_reg(vcpu, reg, eventsel);
> +
> +	if (idx == ARMV8_PMU_CYCLE_IDX)
> +		write_pmccfiltr(eventsel);
> +	else
> +		write_pmevtypern(idx, eventsel);
> +
> +	return true;
> +}
> +
>   static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct  
> sys_reg_params *p,
>   			       const struct sys_reg_desc *r)
>   {
> @@ -1062,7 +1086,9 @@ static bool access_pmu_evtyper(struct kvm_vcpu  
> *vcpu, struct sys_reg_params *p,
>   	if (!pmu_counter_idx_valid(vcpu, idx))
>   		return false;

> -	if (p->is_write) {
> +	if (kvm_vcpu_pmu_is_partitioned(vcpu) && p->is_write) {
> +		writethrough_pmevtyper(vcpu, p, reg, idx);
> +	} else if (p->is_write) {
>   		kvm_pmu_set_counter_event_type(vcpu, p->regval, idx);
>   		kvm_vcpu_pmu_restore_guest(vcpu);
>   	} else {
> --
> 2.50.0.727.gbf7dc18ff4-goog

