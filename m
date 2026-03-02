Return-Path: <kvm+bounces-72402-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GFL2Iem8pWn8FQAAu9opvQ
	(envelope-from <kvm+bounces-72402-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 17:38:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F1C41DD031
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 17:38:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C865F30A319B
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 16:31:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF50B421F11;
	Mon,  2 Mar 2026 16:31:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5A3D421EF3;
	Mon,  2 Mar 2026 16:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772469073; cv=none; b=eu7Vz2Lt2whTZi69V+WN1WJPzAIFS1xNUPsEGgDIkyZTB+smLA7+Q1irlfax26d+w1ZGw9ZpoSClDsrJ3IGneXB1vz+lcXpbJKEH6STRLeQzhoz8t4pgZbCdJLz0dKQV0Nx3wSszlydLHWdOz6EJzLb4klYHqWiUq1wXMBia9AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772469073; c=relaxed/simple;
	bh=zErPL7VBbMbbTJrwfpfbSDU6peIxWnzNCPeBJRC+JTQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OOjrxxWZuVyuI9UdUltDULdgWGQ4SvFXvuojcS6To13RhaJkZV46YasbZYCidFDm+6f+N0vrS7VVfE5p4SnE6iunQJuwnNW5mfN2aEkSAOaLdUuARFFc8kVadsnb/uLYSGDnowiYxZD/AcC6CFEcn2gKouXkVcwThhSQGxdy7Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2BB8114BF;
	Mon,  2 Mar 2026 08:31:01 -0800 (PST)
Received: from [10.57.55.216] (unknown [10.57.55.216])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5FEBE3F694;
	Mon,  2 Mar 2026 08:31:03 -0800 (PST)
Message-ID: <92fe1041-e8fe-4015-8e3b-872cbcce66a2@arm.com>
Date: Mon, 2 Mar 2026 16:31:00 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 11/46] arm64: RMI: Activate realm on first VCPU run
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
 <20251217101125.91098-12-steven.price@arm.com> <86seai8fbd.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <86seai8fbd.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2F1C41DD031
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[steven.price@arm.com,kvm@vger.kernel.org];
	NEURAL_HAM(-0.00)[-0.910];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72402-lists,kvm=lfdr.de];
	R_DKIM_NA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[]
X-Rspamd-Action: no action

On 02/03/2026 14:40, Marc Zyngier wrote:
> On Wed, 17 Dec 2025 10:10:48 +0000,
> Steven Price <steven.price@arm.com> wrote:
>>
>> When a VCPU migrates to another physical CPU check
> 
> To another physical CPU?
> 
> That's not what kvm_arch_vcpu_run_pid_change() tracks. It really is
> limited to a new PID being associated to the vpcu thread. Which is
> indeed the case when the vpcu runs for the first time, but that's
> about it.
> 
> If you need to track the physical CPU, we have some tracking for it in
> vcpu_load(), but that'd need some rework.

Sorry that was just a complete brainfart when I wrote that commit
message. We don't care about physical CPUs - this is just catching the
first VCPU run. Thanks for catching that.

>> if this is the first
>> time the guest has run, and if so activate the realm.
>>
>> Before the realm can be activated it must first be created, this is a
>> stub in this patch and will be filled in by a later patch.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> New patch for v12
>> ---
>>  arch/arm64/include/asm/kvm_rmi.h |  1 +
>>  arch/arm64/kvm/arm.c             |  6 +++++
>>  arch/arm64/kvm/rmi.c             | 42 ++++++++++++++++++++++++++++++++
>>  3 files changed, 49 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
>> index cb7350f8a01a..e4534af06d96 100644
>> --- a/arch/arm64/include/asm/kvm_rmi.h
>> +++ b/arch/arm64/include/asm/kvm_rmi.h
>> @@ -69,6 +69,7 @@ void kvm_init_rmi(void);
>>  u32 kvm_realm_ipa_limit(void);
>>  
>>  int kvm_init_realm_vm(struct kvm *kvm);
>> +int kvm_activate_realm(struct kvm *kvm);
>>  void kvm_destroy_realm(struct kvm *kvm);
>>  void kvm_realm_destroy_rtts(struct kvm *kvm);
>>  
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 941d1bec8e77..542df37b9e82 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -951,6 +951,12 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>>  			return ret;
>>  	}
>>  
>> +	if (kvm_is_realm(vcpu->kvm)) {
>> +		ret = kvm_activate_realm(kvm);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +
>>  	mutex_lock(&kvm->arch.config_lock);
>>  	set_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags);
>>  	mutex_unlock(&kvm->arch.config_lock);
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index e57e8b7eafa9..98929382c365 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -223,6 +223,48 @@ void kvm_realm_destroy_rtts(struct kvm *kvm)
>>  	WARN_ON(realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits)));
>>  }
>>  
>> +static int realm_ensure_created(struct kvm *kvm)
>> +{
>> +	/* Provided in later patch */
>> +	return -ENXIO;
>> +}
>> +
>> +int kvm_activate_realm(struct kvm *kvm)
>> +{
>> +	struct realm *realm = &kvm->arch.realm;
>> +	int ret;
>> +
>> +	if (!kvm_is_realm(kvm))
>> +		return -ENXIO;
> 
> nit: you already checked for this in caller.

Ack

>> +
>> +	if (kvm_realm_state(kvm) == REALM_STATE_ACTIVE)
>> +		return 0;
> 
> You probably also want to return early once the realm has been marked
> as dead -- it shouldn't be able to be a zombie and die twice.

Indeed, >= would be a better check.

Thanks,
Steve

>> +
>> +	guard(mutex)(&kvm->arch.config_lock);
>> +	/* Check again with the lock held */
>> +	if (kvm_realm_state(kvm) == REALM_STATE_ACTIVE)
>> +		return 0;
>> +
>> +	ret = realm_ensure_created(kvm);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Mark state as dead in case we fail */
>> +	WRITE_ONCE(realm->state, REALM_STATE_DEAD);
>> +
>> +	if (!irqchip_in_kernel(kvm)) {
>> +		/* Userspace irqchip not yet supported with realms */
>> +		return -EOPNOTSUPP;
>> +	}
>> +
>> +	ret = rmi_realm_activate(virt_to_phys(realm->rd));
>> +	if (ret)
>> +		return -ENXIO;
>> +
>> +	WRITE_ONCE(realm->state, REALM_STATE_ACTIVE);
>> +	return 0;
>> +}
>> +
>>  void kvm_destroy_realm(struct kvm *kvm)
>>  {
>>  	struct realm *realm = &kvm->arch.realm;
> 
> Thanks,
> 
> 	M.
> 


