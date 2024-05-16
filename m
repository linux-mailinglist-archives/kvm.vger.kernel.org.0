Return-Path: <kvm+bounces-17526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DD7E8C7377
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 11:06:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 956601F239EC
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 09:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74C5514372E;
	Thu, 16 May 2024 09:06:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FE06142E8A;
	Thu, 16 May 2024 09:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715850406; cv=none; b=Aq4+mzTGqUlwQt6yqiZ/D4EWLE34FtZHsFiDOr9I2eypp6ePmyWu8MguUMrc4ncM6kPSYbfxgwTj70iu2nS96Bjkr3VBaPGX7QNnxlXUt2gD89I4fXiD/Dw/mGfvwXdtFJhvPyEjcZsSGXL0cMsHs6eGabN+Yb32P2znMZmpoT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715850406; c=relaxed/simple;
	bh=+Jlyv5HcMaUNPlQ6mVoxa3FJu4ksG1w7kjJzgf+HZ3E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jwKItAB4Kyv0wiIRkZDiLMM6X1jaP+UrFU54zaTwz5jl7C6LQ79rqUyfkAEzGTy+j5waV02izre2DAyr+0Mbe78Jn5cMFOctm0CTpJoasB16tsZ5zfLcWv5ThmPoRgPKhw1/wAwt0S2/eWVQt5F00BY3OiKbW1LNcMKc4K/OYvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 504C2DA7;
	Thu, 16 May 2024 02:07:08 -0700 (PDT)
Received: from [10.57.35.131] (unknown [10.57.35.131])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 77A383F7A6;
	Thu, 16 May 2024 02:06:41 -0700 (PDT)
Message-ID: <d9d35115-0fb5-4e8e-a99c-ff85ba4a7967@arm.com>
Date: Thu, 16 May 2024 10:06:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/14] arm64: Enable memory encrypt for Realms
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-10-steven.price@arm.com> <ZkOmrMIMFCgEKuVw@arm.com>
 <5b2db977-7f0f-4c3a-b278-f195c7ddbd80@arm.com> <ZkW6UgrwJT6G9UN-@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <ZkW6UgrwJT6G9UN-@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Catalin

On 16/05/2024 08:48, Catalin Marinas wrote:
> On Wed, May 15, 2024 at 11:47:02AM +0100, Suzuki K Poulose wrote:
>> On 14/05/2024 19:00, Catalin Marinas wrote:
>>> On Fri, Apr 12, 2024 at 09:42:08AM +0100, Steven Price wrote:
>>> Can someone summarise what the point of this protection bit is? The IPA
>>> memory is marked as protected/unprotected already via the RSI call and
>>> presumably the RMM disables/permits sharing with a non-secure hypervisor
>>> accordingly irrespective of which alias the realm guest has the linear
>>> mapping mapped to. What does it do with the top bit of the IPA? Is it
>>> that the RMM will prevent (via Stage 2) access if the IPA does not match
>>> the requested protection? IOW, it unmaps one or the other at Stage 2?
>>
>> The Realm's IPA space is split in half. The lower half is "protected"
>> and all pages backing the "protected" IPA is in the Realm world and
>> thus cannot be shared with the hypervisor. The upper half IPA is
>> "unprotected" (backed by Non-secure PAS pages) and can be accessed
>> by the Host/hyp.
> 
> What about emulated device I/O where there's no backing RAM at an IPA.
> Does it need to have the top bit set?

The behaviour depends on the IPA (i.e, protected vs unprotected).

1. Unprotected : All stage2 faults in the Unprotected half are serviced
by the Host, including the areas that may be "Memory" backed. RMM 
doesn't provide any guarantees on accesses to the unprotected half. 
i.e., host could even inject a Synchronous External abort, if an MMIO
region is not understood by it.

2. Protected : The behaviour depends on the "IPA State" (only applicable 
for the protected IPAs). The possible states are RIPAS_RAM,  RIPAS_EMPTY 
and RIPAS_DESTROYED(not visible for the Realm).

The default IPA state is RIPAS_EMPTY for all IPA and the state is 
controlled by Realm with the help of RMM (serviced by Host), except
during the Realm initialisation. i.e., the Host is allowed to "mark"
some IPAs as RIPAS_RAM (for e.g., initial images loaded into the Realm)
during Realm initiliasation (via RMI_RTT_INIT_RIPAS), which gets
measured by the RMM (and affects the Realm Initial Measurement). After
the Realm is activated, the Host can only perform the changes requested
by the Realm (RMM monitors this). Hence, the Realm at boot up, marks all
of its "Described RAM" areas as RIPAS_RAM (via RSI_IPA_STATE_SET), so
that it can go ahead and acccess the RAM as normal.


a) RIPAS_EMPTY: Any access to an IPA in RIPAS_EMPTY generates a 
Synchronous External Abort back to the Realm. (In the future, this may
be serviced by another entity in the Realm).

b) RIPAS_RAM: A stage2 fault at a mapped entry triggers a Realm Exit to 
the Host (except Instruction Aborts) and the host is allowed to map a
page (that is "scrubbed" by RMM) at stage2 and continue the execution.

[ ---->8  You may skip this ---
  c) RIPAS_DESTROYED: An IPA is turned to RIPAS_DESTROYED, if the host
     "unmaps" a protected IPA in RIPAS_RAM (via RMI_DATA_DESTROY). This
     implies that the Realm contents were destroyed with no way of
     restoring back. Any access to such IPA from the Realm also causes
     a Realm EXIT, however, the Host is not allowed to map anything back
     there and thus the vCPU cannot proceed with the execution.
----<8----
]

> 
>> The RSI call (RSI_IPA_STATE_SET) doesn't make an IPA unprotected. It
>> simply "invalidates" a (protected) IPA to "EMPTY" implying the Realm doesn't
>> intend to use the "ipa" as RAM anymore and any access to it from
>> the Realm would trigger an SEA into the Realm. The RSI call triggers an exit
>> to the host with the information and is a hint to the hypervisor to reclaim
>> the page backing the IPA.
>>
>> Now, given we need dynamic "sharing" of pages (instead of a dedicated
>> set of shared pages), "aliasing" of an IPA gives us shared pages.
>> i.e., If OS wants to share a page "x" (protected IPA) with the host,
>> we mark that as EMPTY via RSI call and then access the "x" with top-bit
>> set (aliasing the IPA x). This fault allows the hyp to map the page backing
>> IPA "x" as "unprotected" at ALIAS(x) address.
> 
> Does the RMM sanity-checks that the NS hyp mappings are protected or
> unprotected depending on the IPA range?

RMM moderates the mappings in the protected half (as mentioned above).
Any mapping in the unprotected half is not monitored. The host is
allowed unmap, remap with anything in the unprotected half.

> 
> I assume that's also the case if the NS hyp is the first one to access a
> page before the realm (e.g. inbound virtio transfer; no page allocated
> yet because of a realm access).
> 

Correct. The host need not map anything upfront in the Unprotected half
as it is allowed to map a page "with contents" at any time. A stage2 
fault can be serviced by the host to load a page with contents.

Suzuki

