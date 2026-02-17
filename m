Return-Path: <kvm+bounces-71174-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eB+VBW68lGm4HQIAu9opvQ
	(envelope-from <kvm+bounces-71174-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 20:07:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ECE114F74C
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 20:07:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BE699300692C
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 19:07:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5B7F37473A;
	Tue, 17 Feb 2026 19:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jf+itQQ/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024D02BDC2A
	for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 19:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771355234; cv=none; b=vGN4HcbvM3TrXS4IWDq9KYXRaENiOFUlxzL4igtTC4EWj01Z6ZnznhOLrtU0esmkasJh8b8aVJCftipq7J5b20fonKI4MVz/lS3rLqT71fczv2eOR3UBVqbQpAwgRGLsSTlRYmNw4ZATs3MnLYUmy99+8mkIuOjG620YRcDYQI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771355234; c=relaxed/simple;
	bh=reGbZPMRQCC0kj1jFlDO98IpMMNB/uUPMXZwwwAFyPI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ynnp7TBI26XJ6dkJ+ismS0xiG6SDRO0ZG0gA93vvSnqv6IYODzLqQ3p5W3Va/OmxBSjLbnYelyqkSz4KpAoMV7UKvCn6TW7JDqA03HxGqACyQSmZfY3ECMvEJOVehrXc9CqKno9s9iFgqlC1025urbW8hiDK6TAcuqOLU1O7jQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Jf+itQQ/; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a943e214daso217355165ad.3
        for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 11:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771355232; x=1771960032; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4mGOCCVLTr299NsqFOYVBdQ9l7JaHEtHLFfNu9E/0HQ=;
        b=Jf+itQQ/HQ27blig1/S2nOBoSDY+qFD/HrA7si2rpi90BLvoWXXMqH6Gj5e6Mqi45W
         2TnHUc/PY32uGO9WKYGtvsGF8qdnAY9M4bHMoVHHbQDkZa2xi9Qwhu+uLACYqKZZf9vY
         elKb/jHBFoYkEbR+Bx17RXGu/9xhPj3jc4A11/WqHEM2e61ED5vJj3O8cNOKWj74j2uQ
         HJ2luaULLi6/829SWsZzFHhci8/CYzw2NsRFkJFCJNyM96ILJB3jCNXjH0pjqVAuomlm
         +PEQaWr1a4fyqgSRZgWIWqA9lVchycQsB7NU7+PrWk21bRrkK9X27XqZzDSo27zr9i7A
         sUGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771355232; x=1771960032;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4mGOCCVLTr299NsqFOYVBdQ9l7JaHEtHLFfNu9E/0HQ=;
        b=vBo/NBXeRdHchXh17cHRprT8SzWMVJjIY5qps0hzFZuKR0YgFNjmWgCTNYXQV3bqw7
         V9ZO5T3C3QK3xZRntSRspsDA3GQYzoZjz2hQHZ2yNoUIhwl24U1yGyJbE2JhoKFh84QF
         X3iPeDPzIUkI6tHlRpEO7tiej6QKoLaGKrH8I3wcvsil6LXktevsARtcYgqjXwDXa1Qq
         beywD7k0c7nwNHcAqYlPqs+/Nepuc6aDUgY5Dp6vYIEI07fbNgMIzPXaOr4PyLPPOntj
         YoS7MNyH+qaiPSMbUEY920+k+pILqboJPi/Ore41zMrP7RitIYWAeHdJ8vtbq7d0/OWR
         z/DQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBOzXMGsNdPRKJNK903SeQlgn4o+IsQoF7Ba109oLUdtSVeyEkx6mGJslf7lI0NIf5ImI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxR/uLciMfme4gEFSkMjOf8sWxlFWxYp7g2Ur5sGHwzvgU9isAp
	mtn623H+PzkGhy7Sob7FHZ+1z7vL0Vs7azVxyOE+l+s5wyh6/f4DoNuWs6emLuhHHYfvioR/6mE
	WEv/JOQ==
X-Received: from plbkp8.prod.google.com ([2002:a17:903:2808:b0:2a9:5b22:145a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:f84:b0:2aa:e574:c9f7
 with SMTP id d9443c01a7336-2ab4d0aed90mr146214705ad.57.1771355230961; Tue, 17
 Feb 2026 11:07:10 -0800 (PST)
Date: Tue, 17 Feb 2026 11:07:09 -0800
In-Reply-To: <dcbd7a58-c961-4510-ae48-ef7fd4f4d75c@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250909100007.3136249-1-keirf@google.com> <20250909100007.3136249-5-keirf@google.com>
 <a84ddba8-12da-489a-9dd1-ccdf7451a1ba@amazon.com> <aY-x0OlJQEqInyNF@google.com>
 <dcbd7a58-c961-4510-ae48-ef7fd4f4d75c@amazon.com>
Message-ID: <aZS8XXOW7vhMkNWQ@google.com>
Subject: Re: [PATCH v4 4/4] KVM: Avoid synchronize_srcu() in kvm_io_bus_register_dev()
From: Sean Christopherson <seanjc@google.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: Keir Fraser <keirf@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Eric Auger <eric.auger@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71174-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3ECE114F74C
X-Rspamd-Action: no action

On Mon, Feb 16, 2026, Nikita Kalyazin wrote:
> On 13/02/2026 23:20, Sean Christopherson wrote:
> > On Fri, Feb 13, 2026, Nikita Kalyazin wrote:
> > > I am not aware of way to make it fast for both use cases and would be more
> > > than happy to hear about possible solutions.
> > 
> > What if we key off of vCPUS being created?  The motivation for Keir's change was
> > to avoid stalling during VM boot, i.e. *after* initial VM creation.
> 
> It doesn't work as is on x86 because the delay we're seeing occurs after the
> created_cpus gets incremented

I don't follow, the suggestion was to key off created_vcpus in
kvm_io_bus_register_dev(), not in kvm_swap_active_memslots().  I can totally
imagine the patch not working, but the ordering in kvm_vm_ioctl_create_vcpu()
should be largely irrelevant.

Probably a moot point though.

> so it doesn't allow to differentiate the two
> cases (below is kvm_vm_ioctl_create_vcpu):
> 
> 	kvm->created_vcpus++; // <===== incremented here
> 	mutex_unlock(&kvm->lock);
> 
> 	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
> 	if (!vcpu) {
> 		r = -ENOMEM;
> 		goto vcpu_decrement;
> 	}
> 
> 	BUILD_BUG_ON(sizeof(struct kvm_run) > PAGE_SIZE);
> 	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> 	if (!page) {
> 		r = -ENOMEM;
> 		goto vcpu_free;
> 	}
> 	vcpu->run = page_address(page);
> 
> 	kvm_vcpu_init(vcpu, kvm, id);
> 
> 	r = kvm_arch_vcpu_create(vcpu); // <===== the delay is here
> 
> 
> firecracker   583 [001]   151.297145: probe:synchronize_srcu_expedited:
> (ffffffff813e5cf0)
>     ffffffff813e5cf1 synchronize_srcu_expedited+0x1 ([kernel.kallsyms])
>     ffffffff81234986 kvm_swap_active_memslots+0x136 ([kernel.kallsyms])
>     ffffffff81236cdd kvm_set_memslot+0x1cd ([kernel.kallsyms])
>     ffffffff81237518 kvm_set_memory_region.part.0+0x478 ([kernel.kallsyms])
>     ffffffff81264dbc __x86_set_memory_region+0xec ([kernel.kallsyms])
>     ffffffff8127e2dc kvm_alloc_apic_access_page+0x5c ([kernel.kallsyms])
>     ffffffff812b9ed3 vmx_vcpu_create+0x193 ([kernel.kallsyms])
>     ffffffff8126788a kvm_arch_vcpu_create+0x1da ([kernel.kallsyms])
>     ffffffff8123c54c kvm_vm_ioctl+0x5fc ([kernel.kallsyms])
>     ffffffff8167b331 __x64_sys_ioctl+0x91 ([kernel.kallsyms])
>     ffffffff8251a89c do_syscall_64+0x4c ([kernel.kallsyms])
>     ffffffff8100012b entry_SYSCALL_64_after_hwframe+0x76 ([kernel.kallsyms])
>               6512de ioctl+0x32 (/mnt/host/firecracker)
>                d99a7 std::rt::lang_start+0x37 (/mnt/host/firecracker)
> 
> Also, given that it stumbles after the KVM_CREATE_VCPU on ARM (in
> KVM_SET_USER_MEMORY_REGION), it doesn't look like a universal solution.

Hmm.  Under the hood, __synchronize_srcu() itself uses __call_srcu, so I _think_
the only practical difference (aside from waiting, obviously) between call_srcu()
and synchronize_srcu_expedited() with respect to "transferring" grace period
latency is that using call_srcu() could start a normal, non-expedited grace period.

IIUC, SRCU has best-effort logic to shift in-flight non-expedited grace periods
to expedited mode, but if the normal grace period has already started the timer
for the delayed invocation of process_srcu(), then SRCU will still wait for one
jiffie, i.e. won't immediately queue the work.

I have no idea if this is sane and/or acceptable, but before looping in Paul and
others, can you try this to see if it helps?

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 344ad51c8f6c..30437dc8d818 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -89,6 +89,8 @@ void __srcu_read_unlock(struct srcu_struct *ssp, int idx) __releases(ssp);
 
 void call_srcu(struct srcu_struct *ssp, struct rcu_head *head,
                void (*func)(struct rcu_head *head));
+void call_srcu_expedited(struct srcu_struct *ssp, struct rcu_head *rhp,
+                        rcu_callback_t func);
 void cleanup_srcu_struct(struct srcu_struct *ssp);
 void synchronize_srcu(struct srcu_struct *ssp);
 
diff --git a/kernel/rcu/srcutree.c b/kernel/rcu/srcutree.c
index ea3f128de06f..03333b079092 100644
--- a/kernel/rcu/srcutree.c
+++ b/kernel/rcu/srcutree.c
@@ -1493,6 +1493,13 @@ void call_srcu(struct srcu_struct *ssp, struct rcu_head *rhp,
 }
 EXPORT_SYMBOL_GPL(call_srcu);
 
+void call_srcu_expedited(struct srcu_struct *ssp, struct rcu_head *rhp,
+                        rcu_callback_t func)
+{
+       __call_srcu(ssp, rhp, func, rcu_gp_is_normal());
+}
+EXPORT_SYMBOL_GPL(call_srcu_expedited);
+
 /*
  * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
  */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 737b74b15bb5..26215f98c98f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6036,7 +6036,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
        memcpy(new_bus->range + i + 1, bus->range + i,
                (bus->dev_count - i) * sizeof(struct kvm_io_range));
        rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
-       call_srcu(&kvm->srcu, &bus->rcu, __free_bus);
+       call_srcu_expedited(&kvm->srcu, &bus->rcu, __free_bus);
 
        return 0;
 }

