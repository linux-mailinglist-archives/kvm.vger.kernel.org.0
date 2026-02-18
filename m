Return-Path: <kvm+bounces-71243-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IJ2PIcS2lWk/UQIAu9opvQ
	(envelope-from <kvm+bounces-71243-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 13:55:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EE56315673F
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 13:55:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6CB34301C8AF
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:55:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FAA131DD86;
	Wed, 18 Feb 2026 12:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="DlnNYyaA"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.28.197.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46D831B837;
	Wed, 18 Feb 2026 12:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.28.197.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771419321; cv=none; b=r8MBobR4GtqDhoQatG0srT34/Oq5i2i6zHEL73WPTdaNI3WA9RuRpw/UzZQFKP3ZctjM+nMtm6rCJ8Lq/ao/R/dI8uV2CbSmT4dUDYoZ5D9pviRvYGJo3aNAE5b3Yg83MN3JqNJlqYnGEOvcqjtijfcTphAgdh78xYM7ZPH5xQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771419321; c=relaxed/simple;
	bh=GHT2FjhXYmwxGx6YxNNdKj3VnULNGoG7l9q5M3qt+Ek=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=qemD1/LBj9j8ldL0kdMJGWccXEky4AInJClAfXymEZNG+zDFiSQvh9Gfe0ayylvpdL2/tiM4S84eI12e3tOFL+oosNBun68E6dSAPCxNRLVzkvXHf5BmeKiUcSVI/QBIvwOgql7O5ayxPfHjfNFP6PdYXtRae9muQdAjLv29F1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=DlnNYyaA; arc=none smtp.client-ip=52.28.197.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1771419318; x=1802955318;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=GRCj0qUESzvzI1Pl96YD601iynqnDh6I4Otqkg2Gb54=;
  b=DlnNYyaAWZ4uXtZfBDMRTmLkr2pN0NNZev7h41V37Po7ju0QXCSxocZs
   E3muDtPIMEH3H0QVNwvxGmHlarPxGU0phsM6LHZjzIb35dc4XfH3XuGD4
   E1hrNYRegEADyuHkRXZPt//SVUbomXzFGHT7sfnJix1BmigSAkODPotVB
   q6HijqVLQB0H9loegNqIabwSMIat1WdReUsOiNze6TbwdaDsGHNsNnxxH
   9IYR5Y1Zhp4l6YMAblnIt2pUT544RDu5i1+gtgzwWRxu3FDhQGUTomTEw
   G501XuWrSIsh9muEEzoO+4EnAEBYSpfXTZAQKqbFdpy+VLqWmkYawXQfN
   A==;
X-CSE-ConnectionGUID: eiKe7rzQSLSa46wTMGxIFg==
X-CSE-MsgGUID: yD4xaVC8TOuCEGooPZypIg==
X-IronPort-AV: E=Sophos;i="6.21,298,1763424000"; 
   d="scan'208";a="9505218"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 12:55:14 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:25156]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.5.167:2525] with esmtp (Farcaster)
 id b474f839-fba7-4942-9ee1-0bb1a3e43cbb; Wed, 18 Feb 2026 12:55:14 +0000 (UTC)
X-Farcaster-Flow-ID: b474f839-fba7-4942-9ee1-0bb1a3e43cbb
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 18 Feb 2026 12:55:13 +0000
Received: from [192.168.2.195] (10.106.83.9) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35; Wed, 18 Feb 2026
 12:55:13 +0000
Message-ID: <162cedc3-cd6c-494c-b39e-daadfbd6d8db@amazon.com>
Date: Wed, 18 Feb 2026 12:55:11 +0000
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
To: Sean Christopherson <seanjc@google.com>
CC: Keir Fraser <keirf@google.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Eric Auger
	<eric.auger@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier
	<maz@kernel.org>, Will Deacon <will@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, Li RongQing <lirongqing@baidu.com>
References: <20250909100007.3136249-1-keirf@google.com>
 <20250909100007.3136249-5-keirf@google.com>
 <a84ddba8-12da-489a-9dd1-ccdf7451a1ba@amazon.com>
 <aY-x0OlJQEqInyNF@google.com>
 <dcbd7a58-c961-4510-ae48-ef7fd4f4d75c@amazon.com>
 <aZS8XXOW7vhMkNWQ@google.com>
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
In-Reply-To: <aZS8XXOW7vhMkNWQ@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D012EUA003.ant.amazon.com (10.252.50.98) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-9.16 / 15.00];
	WHITELIST_DMARC(-7.00)[amazon.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[amazon.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[amazon.com:s=amazoncorp2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amazon.com:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71243-lists,kvm=lfdr.de];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	HAS_REPLYTO(0.00)[kalyazin@amazon.com];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kalyazin@amazon.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: EE56315673F
X-Rspamd-Action: no action



On 17/02/2026 19:07, Sean Christopherson wrote:
> On Mon, Feb 16, 2026, Nikita Kalyazin wrote:
>> On 13/02/2026 23:20, Sean Christopherson wrote:
>>> On Fri, Feb 13, 2026, Nikita Kalyazin wrote:
>>>> I am not aware of way to make it fast for both use cases and would be more
>>>> than happy to hear about possible solutions.
>>>
>>> What if we key off of vCPUS being created?  The motivation for Keir's change was
>>> to avoid stalling during VM boot, i.e. *after* initial VM creation.
>>
>> It doesn't work as is on x86 because the delay we're seeing occurs after the
>> created_cpus gets incremented
> 
> I don't follow, the suggestion was to key off created_vcpus in
> kvm_io_bus_register_dev(), not in kvm_swap_active_memslots().  I can totally
> imagine the patch not working, but the ordering in kvm_vm_ioctl_create_vcpu()
> should be largely irrelevant.

Yes, you're right, it's irrelevant.  I had made the change in 
kvm_io_bus_register_dev() like proposed, but have no idea how I couldn't 
see the effect.  I retested it now and it's obvious that it works on 
x86.  Sorry for the confusion.

> 
> Probably a moot point though.

Yes, this will not solve the problem on ARM.

> 
>> so it doesn't allow to differentiate the two
>> cases (below is kvm_vm_ioctl_create_vcpu):
>>
>>        kvm->created_vcpus++; // <===== incremented here
>>        mutex_unlock(&kvm->lock);
>>
>>        vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
>>        if (!vcpu) {
>>                r = -ENOMEM;
>>                goto vcpu_decrement;
>>        }
>>
>>        BUILD_BUG_ON(sizeof(struct kvm_run) > PAGE_SIZE);
>>        page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>>        if (!page) {
>>                r = -ENOMEM;
>>                goto vcpu_free;
>>        }
>>        vcpu->run = page_address(page);
>>
>>        kvm_vcpu_init(vcpu, kvm, id);
>>
>>        r = kvm_arch_vcpu_create(vcpu); // <===== the delay is here
>>
>>
>> firecracker   583 [001]   151.297145: probe:synchronize_srcu_expedited:
>> (ffffffff813e5cf0)
>>      ffffffff813e5cf1 synchronize_srcu_expedited+0x1 ([kernel.kallsyms])
>>      ffffffff81234986 kvm_swap_active_memslots+0x136 ([kernel.kallsyms])
>>      ffffffff81236cdd kvm_set_memslot+0x1cd ([kernel.kallsyms])
>>      ffffffff81237518 kvm_set_memory_region.part.0+0x478 ([kernel.kallsyms])
>>      ffffffff81264dbc __x86_set_memory_region+0xec ([kernel.kallsyms])
>>      ffffffff8127e2dc kvm_alloc_apic_access_page+0x5c ([kernel.kallsyms])
>>      ffffffff812b9ed3 vmx_vcpu_create+0x193 ([kernel.kallsyms])
>>      ffffffff8126788a kvm_arch_vcpu_create+0x1da ([kernel.kallsyms])
>>      ffffffff8123c54c kvm_vm_ioctl+0x5fc ([kernel.kallsyms])
>>      ffffffff8167b331 __x64_sys_ioctl+0x91 ([kernel.kallsyms])
>>      ffffffff8251a89c do_syscall_64+0x4c ([kernel.kallsyms])
>>      ffffffff8100012b entry_SYSCALL_64_after_hwframe+0x76 ([kernel.kallsyms])
>>                6512de ioctl+0x32 (/mnt/host/firecracker)
>>                 d99a7 std::rt::lang_start+0x37 (/mnt/host/firecracker)
>>
>> Also, given that it stumbles after the KVM_CREATE_VCPU on ARM (in
>> KVM_SET_USER_MEMORY_REGION), it doesn't look like a universal solution.
> 
> Hmm.  Under the hood, __synchronize_srcu() itself uses __call_srcu, so I _think_
> the only practical difference (aside from waiting, obviously) between call_srcu()
> and synchronize_srcu_expedited() with respect to "transferring" grace period
> latency is that using call_srcu() could start a normal, non-expedited grace period.
> 
> IIUC, SRCU has best-effort logic to shift in-flight non-expedited grace periods
> to expedited mode, but if the normal grace period has already started the timer
> for the delayed invocation of process_srcu(), then SRCU will still wait for one
> jiffie, i.e. won't immediately queue the work.
> 
> I have no idea if this is sane and/or acceptable, but before looping in Paul and
> others, can you try this to see if it helps?

That's exactly what I tried myself before and it didn't help, probably 
for the reason you mentioned above (a normal GP being already started).

> 
> diff --git a/include/linux/srcu.h b/include/linux/srcu.h
> index 344ad51c8f6c..30437dc8d818 100644
> --- a/include/linux/srcu.h
> +++ b/include/linux/srcu.h
> @@ -89,6 +89,8 @@ void __srcu_read_unlock(struct srcu_struct *ssp, int idx) __releases(ssp);
> 
>   void call_srcu(struct srcu_struct *ssp, struct rcu_head *head,
>                  void (*func)(struct rcu_head *head));
> +void call_srcu_expedited(struct srcu_struct *ssp, struct rcu_head *rhp,
> +                        rcu_callback_t func);
>   void cleanup_srcu_struct(struct srcu_struct *ssp);
>   void synchronize_srcu(struct srcu_struct *ssp);
> 
> diff --git a/kernel/rcu/srcutree.c b/kernel/rcu/srcutree.c
> index ea3f128de06f..03333b079092 100644
> --- a/kernel/rcu/srcutree.c
> +++ b/kernel/rcu/srcutree.c
> @@ -1493,6 +1493,13 @@ void call_srcu(struct srcu_struct *ssp, struct rcu_head *rhp,
>   }
>   EXPORT_SYMBOL_GPL(call_srcu);
> 
> +void call_srcu_expedited(struct srcu_struct *ssp, struct rcu_head *rhp,
> +                        rcu_callback_t func)
> +{
> +       __call_srcu(ssp, rhp, func, rcu_gp_is_normal());
> +}
> +EXPORT_SYMBOL_GPL(call_srcu_expedited);
> +
>   /*
>    * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
>    */
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 737b74b15bb5..26215f98c98f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -6036,7 +6036,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
>          memcpy(new_bus->range + i + 1, bus->range + i,
>                  (bus->dev_count - i) * sizeof(struct kvm_io_range));
>          rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
> -       call_srcu(&kvm->srcu, &bus->rcu, __free_bus);
> +       call_srcu_expedited(&kvm->srcu, &bus->rcu, __free_bus);
> 
>          return 0;
>   }


