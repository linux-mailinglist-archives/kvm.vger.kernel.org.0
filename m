Return-Path: <kvm+bounces-71058-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sPsiInRGj2kiPAEAu9opvQ
	(envelope-from <kvm+bounces-71058-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:42:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 325B5137A1B
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:42:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C5E423029E5C
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 15:42:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D16C36213E;
	Fri, 13 Feb 2026 15:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="FAWZLYG+"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.197.217.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EBD194A60;
	Fri, 13 Feb 2026 15:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.197.217.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770997348; cv=none; b=AegiE+9fSZuH8O4L24SisLRcbLy24d52zsldE4c+Mt8IlhpHx0Wyhd+dSbdk7xZKukeaZpmOqt0xJt/cIwLYoGJ/IjagPob//7d4zXzzV4CijJY3bXvVnLWOqzdzLL2CdOO8gqV7Vyp4uPGgyQJVUlzgreCRVJk+V+SCwshKJtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770997348; c=relaxed/simple;
	bh=Qso2QQhen+sj//adele5UXO2wHVTsq7lLh6MPPrqVAo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=dcSLkbrNUtr2COUyom6xn7w6cRdhYs46YW2V6zu4I+32AsZNzjTF2uGDwwzoZeKyeOYV6lc826+zyaNMaz516iUtrRiET14Vr33s3N1CtBinaVUGlR+WJcYplUYhYjvXS2rW/dQY0j4IFUMOWdwZzK6Iy3ik6c/k0C5XMg/s6J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=FAWZLYG+; arc=none smtp.client-ip=18.197.217.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770997347; x=1802533347;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=wc3wuiR4d5qR9HNFKkQBL/RhcLLo/Jro4GjXQoKeDOE=;
  b=FAWZLYG+vUFk9X2PQqjclSNb3egTi30AxpE5W7tHIp512zRwmgozR5Jd
   ghZdbDmMaxyVshy1V05JpXfsmXhY4zic/jAmHkSVKwmCAB7O1iZv0HPVw
   6qNbI60/EgaL0WFr29Q8dwwjxMfV2/liJOml5Vge2vye8+S1Bi9xczboG
   EOUPn7Husyqb4qyXReEWRKIgCF1UTtZ9euXwymRbb2kMc0F0uIr+ZatsW
   hmX1XKAjnpYqm+uitf9Tozn8vYqQsVK75myu1CqvLfKC37lRP8Cs1l7X/
   XkaolkJiETabXwx+EzuMcO2LY+PDyH3TpZeh9M/+YC6JXfDrFqe12AIzI
   A==;
X-CSE-ConnectionGUID: xBWKtWbURmCvJTHWq/NQzw==
X-CSE-MsgGUID: v1IpJRI/Q9ms7OkLKHCw5g==
X-IronPort-AV: E=Sophos;i="6.21,288,1763424000"; 
   d="scan'208";a="9442917"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2026 15:42:22 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:18090]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.34.99:2525] with esmtp (Farcaster)
 id 66f259df-d113-42b5-9bad-4cdd94991272; Fri, 13 Feb 2026 15:42:22 +0000 (UTC)
X-Farcaster-Flow-ID: 66f259df-d113-42b5-9bad-4cdd94991272
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Fri, 13 Feb 2026 15:42:21 +0000
Received: from [192.168.1.242] (10.106.82.26) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35; Fri, 13 Feb 2026
 15:42:21 +0000
Message-ID: <a84ddba8-12da-489a-9dd1-ccdf7451a1ba@amazon.com>
Date: Fri, 13 Feb 2026 15:42:16 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v4 4/4] KVM: Avoid synchronize_srcu() in
 kvm_io_bus_register_dev()
To: Keir Fraser <keirf@google.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Eric Auger
	<eric.auger@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier
	<maz@kernel.org>, Will Deacon <will@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, Li RongQing <lirongqing@baidu.com>
References: <20250909100007.3136249-1-keirf@google.com>
 <20250909100007.3136249-5-keirf@google.com>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJnrNfABQkFps9DAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOpfgD/exazh4C2Z8fNEz54YLJ6tuFEgQrVQPX6nQ/PfQi2+dwBAMGTpZcj9Z9NvSe1
 CmmKYnYjhzGxzjBs8itSUvWIcMsFzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmes18AFCQWmz0MCGwwACgkQr5LKIKmaZPNTlQEA+q+rGFn7273rOAg+rxPty0M8lJbT
 i2kGo8RmPPLu650A/1kWgz1AnenQUYzTAFnZrKSsXAw5WoHaDLBz9kiO5pAK
In-Reply-To: <20250909100007.3136249-5-keirf@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D009EUA002.ant.amazon.com (10.252.50.88) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-9.16 / 15.00];
	WHITELIST_DMARC(-7.00)[amazon.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[amazon.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[amazon.com:s=amazoncorp2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amazon.com:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71058-lists,kvm=lfdr.de];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	HAS_REPLYTO(0.00)[kalyazin@amazon.com];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kalyazin@amazon.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 325B5137A1B
X-Rspamd-Action: no action



On 09/09/2025 11:00, Keir Fraser wrote:
> Device MMIO registration may happen quite frequently during VM boot,
> and the SRCU synchronization each time has a measurable effect
> on VM startup time. In our experiments it can account for around 25%
> of a VM's startup time.
> 
> Replace the synchronization with a deferred free of the old kvm_io_bus
> structure.


Hi,

We noticed that this change introduced a regression of ~20 ms to the 
first KVM_CREATE_VCPU call of a VM, which is significant for our use case.

Before the patch:
45726 14:45:32.914330 ioctl(25, KVM_CREATE_VCPU, 0) = 28 <0.000137>
45726 14:45:32.914533 ioctl(25, KVM_CREATE_VCPU, 1) = 30 <0.000046>

After the patch:
30295 14:47:08.057412 ioctl(25, KVM_CREATE_VCPU, 0) = 28 <0.025182>
30295 14:47:08.082663 ioctl(25, KVM_CREATE_VCPU, 1) = 30 <0.000031>

The reason, as I understand, it happens is call_srcu() called from 
kvm_io_bus_register_dev() are adding callbacks to be called after a 
normal GP, which is 10 ms with HZ=100.  The subsequent 
synchronize_srcu_expedited() called from kvm_swap_active_memslots() 
(from KVM_CREATE_VCPU) has to wait for the normal GP to complete before 
making progress.  I don't fully understand why the delay is consistently 
greater than 1 GP, but that's what we see across our testing scenarios.

I verified that the problem is relaxed if the GP is reduced by 
configuring HZ=1000.  In that case, the regression is in the order of 1 ms.

It looks like in our case we don't benefit much from the intended 
optimisation as the number of device MMIO registrations is limited and 
and they don't cost us much (each takes at most 16 us, but most commonly 
~6 us):

      firecracker 68452 [054]  3053.183991: 
kprobes:kvm_io_bus_register_dev: (ffffffffc0348390)
      firecracker 68452 [054]  3053.184007: 
kprobes:kvm_io_bus_register_dev__return: (ffffffffc0348390 <- 
ffffffffc03aa190)
      firecracker 68452 [054]  3053.184007: 
kprobes:kvm_io_bus_register_dev: (ffffffffc0348390)
      firecracker 68452 [054]  3053.184014: 
kprobes:kvm_io_bus_register_dev__return: (ffffffffc0348390 <- 
ffffffffc03aa1b9)
      firecracker 68452 [054]  3053.184015: 
kprobes:kvm_io_bus_register_dev: (ffffffffc0348390)
      firecracker 68452 [054]  3053.184021: 
kprobes:kvm_io_bus_register_dev__return: (ffffffffc0348390 <- 
ffffffffc03aa1db)
      firecracker 68452 [054]  3053.184028: 
kprobes:kvm_io_bus_register_dev: (ffffffffc0348390)
      firecracker 68452 [054]  3053.184034: 
kprobes:kvm_io_bus_register_dev__return: (ffffffffc0348390 <- 
ffffffffc03ac957)
      firecracker 68452 [054]  3053.184093: 
kprobes:kvm_io_bus_register_dev: (ffffffffc0348390)
      firecracker 68452 [054]  3053.184099: 
kprobes:kvm_io_bus_register_dev__return: (ffffffffc0348390 <- 
ffffffffc03ab51a)
      firecracker 68452 [054]  3053.184100: 
kprobes:kvm_io_bus_register_dev: (ffffffffc0348390)
      firecracker 68452 [054]  3053.184106: 
kprobes:kvm_io_bus_register_dev__return: (ffffffffc0348390 <- 
ffffffffc03ab549)
      firecracker 68452 [054]  3053.193145: 
kprobes:kvm_io_bus_register_dev: (ffffffffc0348390)
      firecracker 68452 [054]  3053.193164: 
kprobes:kvm_io_bus_register_dev__return: (ffffffffc0348390 <- 
ffffffffc0348c9f)
      firecracker 68452 [054]  3053.193165: 
kprobes:kvm_io_bus_register_dev: (ffffffffc0348390)
      firecracker 68452 [054]  3053.193171: 
kprobes:kvm_io_bus_register_dev__return: (ffffffffc0348390 <- 
ffffffffc0348c9f)

Our env:
  - 6.18
  - Arch: the analysis above is from x86, but ARM regressed very similarly
  - CONFIG_HZ=100
  - VMM: Firecracker (https://github.com/firecracker-microvm/firecracker)


I am not aware of way to make it fast for both use cases and would be 
more than happy to hear about possible solutions.


Thanks,
Nikita

> 
> Tested-by: Li RongQing <lirongqing@baidu.com>
> Signed-off-by: Keir Fraser <keirf@google.com>
> ---
>   include/linux/kvm_host.h |  1 +
>   virt/kvm/kvm_main.c      | 11 +++++++++--
>   2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e7d6111cf254..103be35caf0d 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -206,6 +206,7 @@ struct kvm_io_range {
>   struct kvm_io_bus {
>   	int dev_count;
>   	int ioeventfd_count;
> +	struct rcu_head rcu;
>   	struct kvm_io_range range[];
>   };
>   
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 870ad8ea93a7..bcef324ccbf2 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1320,6 +1320,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
>   		kvm_free_memslots(kvm, &kvm->__memslots[i][1]);
>   	}
>   	cleanup_srcu_struct(&kvm->irq_srcu);
> +	srcu_barrier(&kvm->srcu);
>   	cleanup_srcu_struct(&kvm->srcu);
>   #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
>   	xa_destroy(&kvm->mem_attr_array);
> @@ -5952,6 +5953,13 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
>   }
>   EXPORT_SYMBOL_GPL(kvm_io_bus_read);
>   
> +static void __free_bus(struct rcu_head *rcu)
> +{
> +	struct kvm_io_bus *bus = container_of(rcu, struct kvm_io_bus, rcu);
> +
> +	kfree(bus);
> +}
> +
>   int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
>   			    int len, struct kvm_io_device *dev)
>   {
> @@ -5990,8 +5998,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
>   	memcpy(new_bus->range + i + 1, bus->range + i,
>   		(bus->dev_count - i) * sizeof(struct kvm_io_range));
>   	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
> -	synchronize_srcu_expedited(&kvm->srcu);
> -	kfree(bus);
> +	call_srcu(&kvm->srcu, &bus->rcu, __free_bus);
>   
>   	return 0;
>   }


