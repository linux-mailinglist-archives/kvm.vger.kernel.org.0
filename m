Return-Path: <kvm+bounces-19000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87D848FE2CA
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 11:30:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A54DBB2B0EA
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 09:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8538915688F;
	Thu,  6 Jun 2024 09:03:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77F4013E035;
	Thu,  6 Jun 2024 09:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717664613; cv=none; b=XxfYK52rsm2eVdOJaVus6lFiEjq4K089/5Q218G3gOpc4z5CHj4yoglUUk6kIABkUnbBmmbfMs7S6lQMWZqEbJY/wyEIRDeK3uUL1J3+oBy6da0fmavtI87IhrtKydGXtBirgXsaKfPb+xeBp6wM5wfzmAuEhQFOcvo+Kq68hbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717664613; c=relaxed/simple;
	bh=zGINutsNe6MmQp12y68+cEwLXsIuxll5jEDC/d7keK4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PtZVjU3ibjWp3EHuQfNEtgoJbjRY3CSkFbbKtTOnd3CwTwkw56OWP3lzG4daXzRRDUDYdOD61mlHYdE0XhKh1dDuBgT6uKzs2blDWvsDosqIeoGkPwHZx2ZmFZS+GWL7YkkmmT3fDlswW5SS49HXVrk4IihWApJokFJ46k51LEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 637B6339;
	Thu,  6 Jun 2024 02:03:55 -0700 (PDT)
Received: from [10.1.33.29] (e122027.cambridge.arm.com [10.1.33.29])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9994E3F762;
	Thu,  6 Jun 2024 02:03:27 -0700 (PDT)
Message-ID: <c7db4f52-3d14-4d45-8352-d6d9f9e3b286@arm.com>
Date: Thu, 6 Jun 2024 10:03:25 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/14] arm64: Support for running as a guest in Arm CCA
To: Itaru Kitayama <itaru.kitayama@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <ZmAj26Q2aHj-U9hw@vm3>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <ZmAj26Q2aHj-U9hw@vm3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05/06/2024 09:37, Itaru Kitayama wrote:
> Hi Steven,
> On Wed, Jun 05, 2024 at 10:29:52AM +0100, Steven Price wrote:
>> This series adds support for running Linux in a protected VM under the
>> Arm Confidential Compute Architecture (CCA). This has been updated
>> following the feedback from the v2 posting[1]. Thanks for the feedback!
>> Individual patches have a change log for v3.
>>
>> The biggest change from v2 is fixing set_memory_{en,de}crypted() to
>> perform a break-before-make sequence. Note that only the virtual address
>> supplied is flipped between shared and protected, so if e.g. a vmalloc()
>> address is passed the linear map will still point to the (now invalid)
>> previous IPA. Attempts to access the wrong address may trigger a
>> Synchronous External Abort. However any code which attempts to access
>> the 'encrypted' alias after set_memory_decrypted() is already likely to
>> be broken on platforms that implement memory encryption, so I don't
>> expect problems.
>>
>> The ABI to the RMM from a realm (the RSI) is based on the final RMM v1.0
>> (EAC 5) specification[2]. Future RMM specifications will be backwards
>> compatible so a guest using the v1.0 specification (i.e. this series)
>> will be able to run on future versions of the RMM without modification.
>>
>> Arm plans to set up a CI system to perform at a minimum boot testing of
>> Linux as a guest within a realm.
>>
>> This series is based on v6.10-rc1. It is also available as a git
>> repository:
>>
>> https://gitlab.arm.com/linux-arm/linux-cca cca-guest/v3
>>
>> This series (the guest side) should be in a good state so please review
>> with the intention that this could be merged soon. The host side (KVM
>> changes) is likely to require some more iteration and I'll post that as
>> a separate series shortly - note that there is no tie between the series
>> (i.e. you can mix and match v2 and v3 postings of the host and guest).
>>
>> Introduction (unchanged from v2 posting)
>> ============
>> A more general introduction to Arm CCA is available on the Arm
>> website[3], and links to the other components involved are available in
>> the overall cover letter.
>>
>> Arm Confidential Compute Architecture adds two new 'worlds' to the
>> architecture: Root and Realm. A new software component known as the RMM
>> (Realm Management Monitor) runs in Realm EL2 and is trusted by both the
>> Normal World and VMs running within Realms. This enables mutual
>> distrust between the Realm VMs and the Normal World.
>>
>> Virtual machines running within a Realm can decide on a (4k)
>> page-by-page granularity whether to share a page with the (Normal World)
>> host or to keep it private (protected). This protection is provided by
>> the hardware and attempts to access a page which isn't shared by the
>> Normal World will trigger a Granule Protection Fault.
>>
>> Realm VMs can communicate with the RMM via another SMC interface known
>> as RSI (Realm Services Interface). This series adds wrappers for the
>> full set of RSI commands and uses them to manage the Realm IPA State
>> (RIPAS) and to discover the configuration of the realm.
>>
>> The VM running within the Realm needs to ensure that memory that is
>> going to use is marked as 'RIPAS_RAM' (i.e. protected memory accessible
>> only to the guest). This could be provided by the VMM (and subject to
>> measurement to ensure it is setup correctly) or the VM can set it
>> itself.  This series includes a patch which will iterate over all
>> described RAM and set the RIPAS. This is a relatively cheap operation,
>> and doesn't require memory donation from the host. Instead, memory can
>> be dynamically provided by the host on fault. An alternative would be to
>> update booting.rst and state this as a requirement, but this would
>> reduce the flexibility of the VMM to manage the available memory to the
>> guest (as the initial RIPAS state is part of the guest's measurement).
>>
>> Within the Realm the most-significant active bit of the IPA is used to
>> select whether the access is to protected memory or to memory shared
>> with the host. This series treats this bit as if it is attribute bit in
>> the page tables and will modify it when sharing/unsharing memory with
>> the host.
>>
>> This top bit usage also necessitates that the IPA width is made more
>> dynamic in the guest. The VMM will choose a width (and therefore which
>> bit controls the shared flag) and the guest must be able to identify
>> this bit to mask it out when necessary. PHYS_MASK_SHIFT/PHYS_MASK are
>> therefore made dynamic.
>>
>> To allow virtio to communicate with the host the shared buffers must be
>> placed in memory which has this top IPA bit set. This is achieved by
>> implementing the set_memory_{encrypted,decrypted} APIs for arm64 and
>> forcing the use of bounce buffers. For now all device access is
>> considered to required the memory to be shared, at this stage there is
>> no support for real devices to be assigned to a realm guest - obviously
>> if device assignment is added this will have to change.
>>
>> Finally the GIC is (largely) emulated by the (untrusted) host. The RMM
>> provides some management (including register save/restore) but the
>> ITS buffers must be placed into shared memory for the host to emulate.
>> There is likely to be future work to harden the GIC driver against a
>> malicious host (along with any other drivers used within a Realm guest).
>>
>> [1] https://lore.kernel.org/r/20240412084213.1733764-1-steven.price%40arm.com
>> [2] https://developer.arm.com/documentation/den0137/1-0eac5/
>> [3] https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture
>>
> 
> The v3 guest built with clang booted fine on FVP backed by v2 host kernel.
> 
> Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>

Thanks for testing!

Steve


