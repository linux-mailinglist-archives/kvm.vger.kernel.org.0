Return-Path: <kvm+bounces-66183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 44358CC8920
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 16:49:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D6019310AA28
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 15:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 322F1378305;
	Wed, 17 Dec 2025 15:28:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1825376BDD;
	Wed, 17 Dec 2025 15:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765985306; cv=none; b=JNfjW08zpfot82CklYwPDK54ZxJx75E1Gg+VzyhhjRBJ0PNkTut+5eMwOeauD5xFPtzA6rx+KdDqgAh1zh+wijLYdQmLWvSNv+Ts5BWfD2rNH4mpYMywo0it4P5HmC0W3epluReCL0fUaPOgB5s3xcN0XSd6rkthacJTbphpS+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765985306; c=relaxed/simple;
	bh=s1zN82HGerq5N6yweSpLpMZpgygbzXLoWTjwg+HDuMI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SkZXkUTTKoXNYZ2fInjoZSsZ25DDR9uo9k9qfv0oeLEhEu28aJLSm0/RzaY04Rg2MkkT4969FjyY1+usPH7gzw+3KwBDoDCpLLox4LJb/VbxbgOXgykt7H+xAYpNbBsyYbYve3FTZugUDvknZQiyraUxemEQyprutb/CH2/2fBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 100A1FEC;
	Wed, 17 Dec 2025 07:28:17 -0800 (PST)
Received: from [10.57.45.201] (unknown [10.57.45.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 475983F73F;
	Wed, 17 Dec 2025 07:28:19 -0800 (PST)
Message-ID: <505e2e14-7f02-4a6d-b0fa-d322cf0c8b29@arm.com>
Date: Wed, 17 Dec 2025 15:28:16 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 00/46] arm64: Support for Arm CCA in KVM
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20251217101125.91098-1-steven.price@arm.com>
 <86y0n1ma2q.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <86y0n1ma2q.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 17/12/2025 14:55, Marc Zyngier wrote:
> On Wed, 17 Dec 2025 10:10:37 +0000,
> Steven Price <steven.price@arm.com> wrote:
>>
>> This series adds support for running protected VMs using KVM under the
>> Arm Confidential Compute Architecture (CCA). I've changed the uAPI
>> following feedback from Marc.
>>
>> The main change is that rather than providing a multiplex CAP and
>> expecting the VMM to drive the different stages of realm construction,
>> there's now just a minimal interface and KVM performs the necessary
>> operations when needed.
> 
> What are the relevant patches? I'd rather not look at the non-2.0
> patches at all, given that they are pretty meaningless for KVM.

Sorry, I really should have included that in the cover letter.

Patch 6 defines the uAPI - so I'd welcome feedback on whether that is
now the right shape.

Patch 11 shows how the "first VCPU run" is handled with a hook in
kvm_arch_vcpu_run_pid_change() (similar to pKVM).

Patch 20 is implementation of the new populate ioctl.

Patch 21 handles the INIT_RIPAS by assuming that any memslot with gmem
is private and should be RIPAS_RAM.

Patch 27 handles the PSCI requests which is the other ioctl. No real
change from the previous posting, but it would be good to know if there
are any issues with the uAPI here.

I think other than those there's either very little change from the
previous series, or it's likely to change with RMM v2.0.

Thanks,
Steve


