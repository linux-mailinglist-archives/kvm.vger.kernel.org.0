Return-Path: <kvm+bounces-48342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D6F6ACCF3E
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 23:47:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18E0F3A50AA
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 21:46:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2270A24A069;
	Tue,  3 Jun 2025 21:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bi3hxfIg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94C8233704
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 21:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748987217; cv=none; b=GVoZ718aT6zF2o61HjpJo4jw1AxpBWygKH+XSJCu3Lu4850O94uZ6cpgvKs10/DUqmeQ9cvGSWxrEEoS6NvQaCpOoZsfI31887N9t9VkU6//oP0bbFSVBNSH+y/5prSKQ5neM2cFCJylDa0R7uK2MBOYXDyKrbuAsj38eSqVuD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748987217; c=relaxed/simple;
	bh=7OkVmia+kAhC2psjz5g/UQyEwFQL6hlzlynJfKibJrY=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=SOhJiIJ64DuSnbWuL5PF4dZ8QPC9WC0kGaxYowad2PVe9FrUJ7ynRhKeFxkb9088YLtJ4OK18/rHEC3Yt7DDqUjOGoZ4uiG/aNNlP5/geYtiCdSffYcIw6f6g1VKxA7jVCh3zDu2uNuB/qn64XkyTQiZ9wr29eqCROl2wV+0hfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bi3hxfIg; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-735b135988eso2893964a34.1
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 14:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748987215; x=1749592015; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LccXvjPYPBUKmolpHX2IrRx+++KKrUgiEoyHX8qZbOw=;
        b=Bi3hxfIgHRRST+ts6mfaolap226t0NctWhE6kDXuMLdh9p7VCLfiUh54mQOMVBdPjM
         H0S8Oe4ctU4zeJ4WkQvBD1axE9ErDgf05eVYRpbsX1g9/9XX6x2Q6WQMukvKVHIplJkc
         k/+kDNvsy2kXUHA+FE/F9SU1K+JFUWObFpVQBUdWy5rNaoY8kRoZ8Ej4uqJZtMyAcDvp
         YFkfttFGdyptJMZ/P30qbgY7DDbfMDyyXPI/9iXhnakAxZyDOaYxVrZcwy8S0sKYgLxF
         94XoWkPTGfJhE+bim2J2zpq6Zw31Px4q4uhsqHyktsGyL6R/pauQbnSrmZ5p9Y/Wf8gy
         t/yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748987215; x=1749592015;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LccXvjPYPBUKmolpHX2IrRx+++KKrUgiEoyHX8qZbOw=;
        b=Z9+8gZilz+eJYQTVpi4GxeW8fw5Arl6HMB0wDmbCDohsHIkBe3wuKTxv+yFhnvQfhT
         nz23BJwC6p2TnP89wlCQd41fbwvtrMrhkPWqUjR0Sk/HpoHN3TIKBSrXEknuv4wQE6jL
         z9xTsErdJTQUDsvPdWTaOa5V5j3HPqFEKGMdNtn4ZJtkIpBn/ZwHfZh9Jww9hncNBEPi
         1f3arx1Ic01td0p7AST95EZ6DzdRbWUuMu7f+NB/CHVgC+yXZerkgrsirH0WQhVOQHJy
         BynOMwYVacYti8f67Pr1t+HIfjF4GE3PQBp5dhdmeg5hQkfEZWKyvLyewm9eDEccP+1E
         xeGA==
X-Gm-Message-State: AOJu0Yykc0BHb/nTL0kDEDF7pP1ZQTmN9kAcmCuDB/Kn/i0XhUrVtRA7
	p1CzZS99NFB/UejBqS2Y2y+sQmsx/t9IsnHD+rlGYpdZR/jqxxHEmGmF3kjdxqN3bVsYQSowvpM
	bff/bfR5JwpAtjRvd5f+UQqee5Q==
X-Google-Smtp-Source: AGHT+IGVKt5ILqjSdW8OtKLqE/y3WeywMj3vX4/DzsQoxvrjy7RrNHS3PkxJz64AV7HAzQffHQulShSVI5b7iylTEA==
X-Received: from oobdi8.prod.google.com ([2002:a05:6820:1e88:b0:60f:868:60e1])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6830:4882:b0:735:ebf8:b241 with SMTP id 46e09a7af769-73869d7c158mr529938a34.14.1748987214770;
 Tue, 03 Jun 2025 14:46:54 -0700 (PDT)
Date: Tue, 03 Jun 2025 21:46:54 +0000
In-Reply-To: <aD4oS1_tnMPlgDJ6@linux.dev> (message from Oliver Upton on Mon, 2
 Jun 2025 15:40:11 -0700)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsnt1ps033ch.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 16/17] KVM: arm64: Add ioctl to partition the PMU when supported
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, mark.rutland@arm.com, shuah@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> On Mon, Jun 02, 2025 at 07:27:01PM +0000, Colton Lewis wrote:
>> +	case KVM_ARM_PARTITION_PMU: {

> This should be a vCPU attribute similar to the other PMUv3 controls we
> already have. Ideally a single attribute where userspace tells us it
> wants paritioning and specifies the PMU ID to use. None of this can be
> changed after INIT'ing the PMU.

Okay

>> +		struct arm_pmu *pmu;
>> +		u8 host_counters;
>> +
>> +		if (unlikely(!kvm_vcpu_initialized(vcpu)))
>> +			return -ENOEXEC;
>> +
>> +		if (!kvm_pmu_partition_supported())
>> +			return -EPERM;
>> +
>> +		if (copy_from_user(&host_counters, argp, sizeof(host_counters)))
>> +			return -EFAULT;
>> +
>> +		pmu = vcpu->kvm->arch.arm_pmu;
>> +		return kvm_pmu_partition(pmu, host_counters);

> Yeah, we really can't be changing the counters available to the ARM PMU
> driver at this point. What happens to host events already scheduled on
> the CPU?

Okay. I remember talking about this before.

> Either the partition of host / KVM-owned counters needs to be computed
> up front (prior to scheduling events) or KVM needs a way to direct perf
> to reschedule events on the PMU based on the new operating constraints.

Yes. I will think about it.

