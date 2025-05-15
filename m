Return-Path: <kvm+bounces-46678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8977AB83DD
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 12:30:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E98653B1D69
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 10:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17324297B92;
	Thu, 15 May 2025 10:30:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17F731B0F31;
	Thu, 15 May 2025 10:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747305038; cv=none; b=pmfR84bmiDm8j+Db9LlSVWXr8fyeNnZrqLt1nmx+GimnUAMWXD10P51qT1nWnYveCCABJrlRTFlfbT2pc96y8tD0PbCtLHFq9+FcaUzirly3mQNhlLT6ytTvGVSq/W0bM2VskhlRuw36xxIcvgSV/1BthUWUgkdfx6trws7AjTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747305038; c=relaxed/simple;
	bh=9mEVG38JuV53OVjULk4hmXDOEQm15HR8LrrAxgAC4/U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fZhtxDnYvecRqCyv7DyGMi1HGSCSEslTW7MgDDuEJrNdVJ6Wk4TRDorufInWthnAY1q6q5tQzeZ3cw38UKJatN3ovHbFEN2kRuo1kmkfIVWh8+6IA9YdCiQgN9b9/3qageqCSvNiu+KtIJ9+NIlBGzHdGH5WmTikb7ehDTawVW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C5DA314BF;
	Thu, 15 May 2025 03:30:24 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0DAF53F673;
	Thu, 15 May 2025 03:30:34 -0700 (PDT)
Message-ID: <5d204cf7-c6a0-455c-8706-753e1fce3777@arm.com>
Date: Thu, 15 May 2025 11:30:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] KVM: arm64: Allow vGICv4 configuration per VM
To: Raghavendra Rao Ananta <rananta@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Mingwei Zhang <mizhang@google.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250514192159.1751538-1-rananta@google.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <20250514192159.1751538-1-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 5/14/25 20:21, Raghavendra Rao Ananta wrote:
> Hello,
> 
> When kvm-arm.vgic_v4_enable=1, KVM adds support for direct interrupt
> injection by default to all the VMs in the system, aka GICv4. A
> shortcoming of the GIC architecture is that there's an absolute limit on
> the number of vPEs that can be tracked by the ITS. It is possible that
> an operator is running a mix of VMs on a system, only wanting to provide
> a specific class of VMs with hardware interrupt injection support.
> 
> To support this, introduce a GIC attribute, KVM_DEV_ARM_VGIC_CONFIG_GICV4,
> for the userspace to enable or disable vGICv4 for a given VM.
> 
> The attribute allows the configuration only when vGICv4 is enabled in KVM,
> else it acts a read-only attribute returning
> KVM_DEV_ARM_VGIC_CONFIG_GICV4_UNAVAILABLE as the value.
What's the reason for the cmdline enable continuing to be absolute in 
the disable case? I wonder if this is unnecessarily restrictive.

Couldn't KVM_DEV_ARM_VGIC_CONFIG_GICV4_UNAVAILABLE be reserved for 
hardware that doesn't support vgic_v4 and if kvm-arm.vgic_v4_enable=0, 
or omitted, on supporting hardware then default to 
KVM_DEV_ARM_VGIC_CONFIG_GICV4_DISABLE but allow it to be overridden? I 
don't think this changes the behaviour when your new attribute is not used.
> 
> On the other hand, if KVM has the vGICv4 enabled via the cmdline, the
> VM absorbs this configuration by default to maintain the backward
> compatibility. Userspace can get the attribute's value to check if the VM
> has vGICv4 support if it sees KVM_DEV_ARM_VGIC_CONFIG_GICV4_ENABLE as the
> value. As required, it can disable vGICv4 by setting
> KVM_DEV_ARM_VGIC_CONFIG_GICV4_DISABLE as the value.
> 
...
> 
> 

Thanks,

Ben


