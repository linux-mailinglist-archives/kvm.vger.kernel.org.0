Return-Path: <kvm+bounces-46707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5F3DAB8CD2
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 18:48:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F9D04C2719
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 16:48:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5253253F08;
	Thu, 15 May 2025 16:48:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 659B325395C;
	Thu, 15 May 2025 16:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747327715; cv=none; b=QkKrzU9+bN7C70Tls18k0X/76cYRO7AUTOSrQsfUChQgTlW6VnPZ3+C4K4KXabSC3pLcEOV+dyX7iUIsNSqzu5aDsjZ434yKWgPj4svPUYwSCPazC+8nCnXKGVZENP9pem52CIO2PZ1pT2dKFXLKFk/4SJi5RJL3+mnodq3ozEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747327715; c=relaxed/simple;
	bh=0ADnEgUksaRuN7xX8QNORj+pUqdmF0PSLqFRMgWLl/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gIUeyvaoDM59W0yuc+JKsQC/FAUAmvUGW68sgPNc34/NrTWXkVz27rfBlbcSGVd6y4sfQjbI4oLiHAd+tQkP+1mJR647g/kmRTJxH+tno7ByF00HmkSJOzEAJ8/Qwb5Ia2iTlOjo6wtG43+g0aLO3UVlvpwk4IM7q1RoPMAMaQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D3B5A14BF;
	Thu, 15 May 2025 09:48:20 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7B05A3F5A1;
	Thu, 15 May 2025 09:48:31 -0700 (PDT)
Message-ID: <89c75451-8a30-42c1-ba2a-a63b818a1a04@arm.com>
Date: Thu, 15 May 2025 17:48:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] KVM: arm64: Allow vGICv4 configuration per VM
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Mingwei Zhang <mizhang@google.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250514192159.1751538-1-rananta@google.com>
 <5d204cf7-c6a0-455c-8706-753e1fce3777@arm.com>
 <CAJHc60w1rYc9guoideuKpKaukuCyvxu3S7Fidoy3Lh94+_xDiw@mail.gmail.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <CAJHc60w1rYc9guoideuKpKaukuCyvxu3S7Fidoy3Lh94+_xDiw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

On 5/15/25 16:55, Raghavendra Rao Ananta wrote:
> On Thu, May 15, 2025 at 3:30 AM Ben Horgan <ben.horgan@arm.com> wrote:
>>
>> Hi,
>>
>> On 5/14/25 20:21, Raghavendra Rao Ananta wrote:
>>> Hello,
>>>
>>> When kvm-arm.vgic_v4_enable=1, KVM adds support for direct interrupt
>>> injection by default to all the VMs in the system, aka GICv4. A
>>> shortcoming of the GIC architecture is that there's an absolute limit on
>>> the number of vPEs that can be tracked by the ITS. It is possible that
>>> an operator is running a mix of VMs on a system, only wanting to provide
>>> a specific class of VMs with hardware interrupt injection support.
>>>
>>> To support this, introduce a GIC attribute, KVM_DEV_ARM_VGIC_CONFIG_GICV4,
>>> for the userspace to enable or disable vGICv4 for a given VM.
>>>
>>> The attribute allows the configuration only when vGICv4 is enabled in KVM,
>>> else it acts a read-only attribute returning
>>> KVM_DEV_ARM_VGIC_CONFIG_GICV4_UNAVAILABLE as the value.
>> What's the reason for the cmdline enable continuing to be absolute in
>> the disable case? I wonder if this is unnecessarily restrictive.
>>
>> Couldn't KVM_DEV_ARM_VGIC_CONFIG_GICV4_UNAVAILABLE be reserved for
>> hardware that doesn't support vgic_v4 and if kvm-arm.vgic_v4_enable=0,
>> or omitted, on supporting hardware then default to
>> KVM_DEV_ARM_VGIC_CONFIG_GICV4_DISABLE but allow it to be overridden? I
>> don't think this changes the behaviour when your new attribute is not used.
> 
> KVM_DEV_ARM_VGIC_CONFIG_GICV4_UNAVAILABLE is reserved for the exact
> situation that you mentioned (no GICv4 h/w support  or if cmdline is
> disabled/omitted).
> Regarding defaulting to KVM_DEV_ARM_VGIC_CONFIG_GICV4_DISABLE,
> wouldn't it change the existing expectations, i.e., vGICv4 is enabled
> if available and set by cmdline?
I was suggesting keeping the defaults the same when your new gic 
attribute is untouched but in the same way that it overrides enable to 
disable you could also allow it to override disable to enable.

Based on Marc's comments this does not seem desirable. As things are 
now, and with your changes, setting kvm-arm.vgic_v4_enable=1 at boot 
implies a promise that vgic_v4 works on the system. As there is broken 
hardware we can't take this promise for granted.
> 
> Thank you.
> Raghavendra

Thanks,

Ben


