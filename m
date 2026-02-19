Return-Path: <kvm+bounces-71339-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YC8+KNvAlmmzlwIAu9opvQ
	(envelope-from <kvm+bounces-71339-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 08:50:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 16A3D15CCCC
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 08:50:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EF6153010263
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 07:50:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EA8B2F3C3D;
	Thu, 19 Feb 2026 07:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0dwucIvO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D73285071
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 07:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771487448; cv=none; b=Zn74i9GVCIVzjaGJoC0Hd3eRpp5FM4+gUGiOl+H9ijUS79d1D8dR7PibE/hD/KVGOzEqAon6fQvvqeqeUU+IvOkVP+B9xzJOYbbsZgGpoykU6H/wXjCVTzVem5AdE/fEFWfv0XF4lsrTnz6aHghnYDtodPQ+WPFi4xFp7rWMzmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771487448; c=relaxed/simple;
	bh=L0t0PqxQTwEtuGpCbk9nxX0dm96E4NIfmoDpEHqV7gs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tqrU29v6eQU4cKuumoyXxY6lUMJjI59ND3K1jMsMc2rIPJT1HLhAflfUcQVrpwMHj0ZrUlneay8sfKba3Iw1T5DQ/3qgU8F4sc1vJnSWeGBKJ8vAjCmWwg6J724P/RJoXdzCcvVgBTJk05vB0m36sfWaqI434mn8EuIPEbyjc2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0dwucIvO; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48370174e18so3778785e9.2
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 23:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771487445; x=1772092245; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v67gFqLTRAEXaksruasTXbf+/wqfcmhb5T0lX43fE4k=;
        b=0dwucIvO2QORVpDLk9UYZ3EwpSxz6Om0hvEK2G0CuVrGWsMkruJlSreUpRpXK7gb+e
         WhW1XQ6dEHg7x5nX4FYf2KQ2pTV8EI+3U5pwaR1Ti3G6GaeYgIaGlkW3JzTFgXySiYqL
         DTUPeP+XAGamWO+HHrwz5GKQ6BHtU9pbP1vbeyNdDftcSuz0f3+6GRLarAOomWYDauCw
         noXccr3qubhuqdhiJ6UJi9nfMwGrwA5Miz8Z0aJ4TUUr/6LtC4qQVExiiJthyQ6bAAA7
         jP83Zz8UPemTWdGJZTBXyvae3vpfNNrsyBbLOYRq4rkNv7iqUH/nQs6oqkFqMY+9hD3A
         M28A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771487445; x=1772092245;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v67gFqLTRAEXaksruasTXbf+/wqfcmhb5T0lX43fE4k=;
        b=KhfkCRvX3FfIj9A8uSRlJyoySlEOUj4jt+qbIkShFAthl58mj58LliyRkhMxMXtx7V
         jJgtp4JQ+nn8Fuqcb4Ylqqq3e0JVEkzC5J3Hge7ykdwVy8pVr0NaVVILefgHfdpKkqFA
         hys3rQ60Q/F16pxqgrKfEb0bTGJP+tpZKMP+zfPzk7CbR1HHQqmDIjM6xbCuXOD0Qh7a
         oYK9JObnV7s26FbzZdjHP/2RDrSTCGl+CGhvkcAX0LoKbbVV4mvM2jDNoUrjP9ri3/ut
         xby/tx+H+sB919vB3awdI+QuLG8TdvAIIzmx/VTgUlkUifN/W+4U4S4qWOAsfJYjG4c+
         rWEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZfFJLaiaBz7+SaJdlEAbkMTGjV9/jPbVSc704ekzfbc73BdwBvIX69D1Nby/zjInQ2pY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxrxWELoedKfVroU3RESt+MLWBgsn0wWdGUKxwXuVjOp1IBgc6
	vnPojvKJMEKJutJMIpUWKmSDD1JAhSfNMgqbKL+fTmHNtCfc0JL56OeddlmjjyOL3g==
X-Gm-Gg: AZuq6aL+Be5k/Puvu066h+YufEH5fwjtM/LSUKPfcpzllBTfxOTzTBVRWTuExtFDY9j
	qLKISvXIt54zBmhK0xG77cRT4ASLBtXNqT+avQYUfxuhTQaAGR8BXNLkmd+z2hYWrBJchSMq32r
	7EuuF/vO8b9eZgjbIHvbMoRlDwjZW+lR+Xpu35AdWdVjTIlHcofEcDRl4Rb1V2T3SrgPh3oZZco
	kIZ8OcOvjDov410fhKPt+cIb3QT6yvIrD/rB0GVz5LGWxiiPepMeviITAo7KmCIlHJLZlMmH5wz
	uwhhCVKtz5MCp4w7xfhIkuq6BcZb7eV+8g7kcKchS/5OndIQ9jl5R8BLxiNgfT7jUSSgY3OYNFF
	N3HMFYA85KKEjk9Hq3TL4sKrctKPyoUgw3uPYdUduF9dGxcu9WnA/aNoqR79dnwY+aFqcAIFBKt
	LLH1sK8ErNBw076Xh9Dq065uUWKi9T9IzNAbNYHu3XG0DgeFUSbCdzhAuvRBBJ
X-Received: by 2002:a05:600c:8709:b0:480:1c53:2085 with SMTP id 5b1f17b1804b1-48379bd731emr278862615e9.19.1771487444605;
        Wed, 18 Feb 2026 23:50:44 -0800 (PST)
Received: from google.com (164.102.240.35.bc.googleusercontent.com. [35.240.102.164])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4839f94fee1sm15399125e9.4.2026.02.18.23.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 23:50:44 -0800 (PST)
Date: Thu, 19 Feb 2026 07:50:40 +0000
From: Keir Fraser <keirf@google.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: Sean Christopherson <seanjc@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH v4 4/4] KVM: Avoid synchronize_srcu() in
 kvm_io_bus_register_dev()
Message-ID: <aZbA0IZE1i0w1BTH@google.com>
References: <20250909100007.3136249-1-keirf@google.com>
 <20250909100007.3136249-5-keirf@google.com>
 <a84ddba8-12da-489a-9dd1-ccdf7451a1ba@amazon.com>
 <aY-x0OlJQEqInyNF@google.com>
 <dcbd7a58-c961-4510-ae48-ef7fd4f4d75c@amazon.com>
 <aZS8XXOW7vhMkNWQ@google.com>
 <162cedc3-cd6c-494c-b39e-daadfbd6d8db@amazon.com>
 <aZXifSagpbj4CjBn@google.com>
 <7e46af52-b6f3-43cf-a970-8c179a964729@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e46af52-b6f3-43cf-a970-8c179a964729@amazon.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71339-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[keirf@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 16A3D15CCCC
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 04:15:33PM +0000, Nikita Kalyazin wrote:
> 
> 
> On 18/02/2026 16:02, Keir Fraser wrote:
> > On Wed, Feb 18, 2026 at 12:55:11PM +0000, Nikita Kalyazin wrote:
> > > 
> > > 
> > > On 17/02/2026 19:07, Sean Christopherson wrote:
> > > > On Mon, Feb 16, 2026, Nikita Kalyazin wrote:
> > > > > On 13/02/2026 23:20, Sean Christopherson wrote:
> > > > > > On Fri, Feb 13, 2026, Nikita Kalyazin wrote:
> > > > > > > I am not aware of way to make it fast for both use cases and would be more
> > > > > > > than happy to hear about possible solutions.
> > > > > > 
> > > > > > What if we key off of vCPUS being created?  The motivation for Keir's change was
> > > > > > to avoid stalling during VM boot, i.e. *after* initial VM creation.
> > > > > 
> > > > > It doesn't work as is on x86 because the delay we're seeing occurs after the
> > > > > created_cpus gets incremented
> > > > 
> > > > I don't follow, the suggestion was to key off created_vcpus in
> > > > kvm_io_bus_register_dev(), not in kvm_swap_active_memslots().  I can totally
> > > > imagine the patch not working, but the ordering in kvm_vm_ioctl_create_vcpu()
> > > > should be largely irrelevant.
> > > 
> > > Yes, you're right, it's irrelevant.  I had made the change in
> > > kvm_io_bus_register_dev() like proposed, but have no idea how I couldn't see
> > > the effect.  I retested it now and it's obvious that it works on x86.  Sorry
> > > for the confusion.
> > > 
> > > > 
> > > > Probably a moot point though.
> > > 
> > > Yes, this will not solve the problem on ARM.
> > 
> > Sorry for being late to this thread. I'm a bit confused now. Did
> > Sean's original patch (reintroducing the old logic, based on whether
> > any vcpus have been created) work for both/either/neither arch? I
> > would have expected it to work for both ARM and X86, despite the
> > offending synchronize_srcu() not being in the vcpu-creation ioctl on
> > ARM, and I think that is finally what your testing seems to show? If
> > so then that seems the pragmatic if somewhat ugly way forward.
> 
> The original patch from Sean works for x86.  I didn't test it on ARM as it's
> harder for me to do, but I don't expect it to work because it only affects
> the pre-vcpu-creation phase.

Ok, looking closer at one of your previous replies, the first fix
doesn't work for you on ARM because there your vcpu creations occur
earlier than on X86? Fair enough.

> We discussed the second patch at the KVM sync earlier today, then I retested
> it and it appears to solve the issue for both, but I'm going to have more
> complete results tomorrow.
> 
> Are you by chance able to have a look whether KVM_SET_USER_MEMORY_REGION
> execution elongates on ARM in your environment (with the 4/4 patch)? I'd be
> curious to know why not if it doesn't.

On our VMM (crosvm) the kvm_io_bus_register_dev happen much later,
during actual VM boot (device probe phase), so the results would not
be comparable. In our scenario we generally save milliseconds on every
single kvm_io_bus_register_dev invocation.

> > 
> >   Cheers,
> >    Keir
> > 
> > 
> > > > 
> > > > > so it doesn't allow to differentiate the two
> > > > > cases (below is kvm_vm_ioctl_create_vcpu):
> > > > > 
> > > > >         kvm->created_vcpus++; // <===== incremented here
> > > > >         mutex_unlock(&kvm->lock);
> > > > > 
> > > > >         vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
> > > > >         if (!vcpu) {
> > > > >                 r = -ENOMEM;
> > > > >                 goto vcpu_decrement;
> > > > >         }
> > > > > 
> > > > >         BUILD_BUG_ON(sizeof(struct kvm_run) > PAGE_SIZE);
> > > > >         page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> > > > >         if (!page) {
> > > > >                 r = -ENOMEM;
> > > > >                 goto vcpu_free;
> > > > >         }
> > > > >         vcpu->run = page_address(page);
> > > > > 
> > > > >         kvm_vcpu_init(vcpu, kvm, id);
> > > > > 
> > > > >         r = kvm_arch_vcpu_create(vcpu); // <===== the delay is here
> > > > > 
> > > > > 
> > > > > firecracker   583 [001]   151.297145: probe:synchronize_srcu_expedited:
> > > > > (ffffffff813e5cf0)
> > > > >       ffffffff813e5cf1 synchronize_srcu_expedited+0x1 ([kernel.kallsyms])
> > > > >       ffffffff81234986 kvm_swap_active_memslots+0x136 ([kernel.kallsyms])
> > > > >       ffffffff81236cdd kvm_set_memslot+0x1cd ([kernel.kallsyms])
> > > > >       ffffffff81237518 kvm_set_memory_region.part.0+0x478 ([kernel.kallsyms])
> > > > >       ffffffff81264dbc __x86_set_memory_region+0xec ([kernel.kallsyms])
> > > > >       ffffffff8127e2dc kvm_alloc_apic_access_page+0x5c ([kernel.kallsyms])
> > > > >       ffffffff812b9ed3 vmx_vcpu_create+0x193 ([kernel.kallsyms])
> > > > >       ffffffff8126788a kvm_arch_vcpu_create+0x1da ([kernel.kallsyms])
> > > > >       ffffffff8123c54c kvm_vm_ioctl+0x5fc ([kernel.kallsyms])
> > > > >       ffffffff8167b331 __x64_sys_ioctl+0x91 ([kernel.kallsyms])
> > > > >       ffffffff8251a89c do_syscall_64+0x4c ([kernel.kallsyms])
> > > > >       ffffffff8100012b entry_SYSCALL_64_after_hwframe+0x76 ([kernel.kallsyms])
> > > > >                 6512de ioctl+0x32 (/mnt/host/firecracker)
> > > > >                  d99a7 std::rt::lang_start+0x37 (/mnt/host/firecracker)
> > > > > 
> > > > > Also, given that it stumbles after the KVM_CREATE_VCPU on ARM (in
> > > > > KVM_SET_USER_MEMORY_REGION), it doesn't look like a universal solution.
> > > > 
> > > > Hmm.  Under the hood, __synchronize_srcu() itself uses __call_srcu, so I _think_
> > > > the only practical difference (aside from waiting, obviously) between call_srcu()
> > > > and synchronize_srcu_expedited() with respect to "transferring" grace period
> > > > latency is that using call_srcu() could start a normal, non-expedited grace period.
> > > > 
> > > > IIUC, SRCU has best-effort logic to shift in-flight non-expedited grace periods
> > > > to expedited mode, but if the normal grace period has already started the timer
> > > > for the delayed invocation of process_srcu(), then SRCU will still wait for one
> > > > jiffie, i.e. won't immediately queue the work.
> > > > 
> > > > I have no idea if this is sane and/or acceptable, but before looping in Paul and
> > > > others, can you try this to see if it helps?
> > > 
> > > That's exactly what I tried myself before and it didn't help, probably for
> > > the reason you mentioned above (a normal GP being already started).
> > > 
> > > > 
> > > > diff --git a/include/linux/srcu.h b/include/linux/srcu.h
> > > > index 344ad51c8f6c..30437dc8d818 100644
> > > > --- a/include/linux/srcu.h
> > > > +++ b/include/linux/srcu.h
> > > > @@ -89,6 +89,8 @@ void __srcu_read_unlock(struct srcu_struct *ssp, int idx) __releases(ssp);
> > > > 
> > > >    void call_srcu(struct srcu_struct *ssp, struct rcu_head *head,
> > > >                   void (*func)(struct rcu_head *head));
> > > > +void call_srcu_expedited(struct srcu_struct *ssp, struct rcu_head *rhp,
> > > > +                        rcu_callback_t func);
> > > >    void cleanup_srcu_struct(struct srcu_struct *ssp);
> > > >    void synchronize_srcu(struct srcu_struct *ssp);
> > > > 
> > > > diff --git a/kernel/rcu/srcutree.c b/kernel/rcu/srcutree.c
> > > > index ea3f128de06f..03333b079092 100644
> > > > --- a/kernel/rcu/srcutree.c
> > > > +++ b/kernel/rcu/srcutree.c
> > > > @@ -1493,6 +1493,13 @@ void call_srcu(struct srcu_struct *ssp, struct rcu_head *rhp,
> > > >    }
> > > >    EXPORT_SYMBOL_GPL(call_srcu);
> > > > 
> > > > +void call_srcu_expedited(struct srcu_struct *ssp, struct rcu_head *rhp,
> > > > +                        rcu_callback_t func)
> > > > +{
> > > > +       __call_srcu(ssp, rhp, func, rcu_gp_is_normal());
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(call_srcu_expedited);
> > > > +
> > > >    /*
> > > >     * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
> > > >     */
> > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > index 737b74b15bb5..26215f98c98f 100644
> > > > --- a/virt/kvm/kvm_main.c
> > > > +++ b/virt/kvm/kvm_main.c
> > > > @@ -6036,7 +6036,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
> > > >           memcpy(new_bus->range + i + 1, bus->range + i,
> > > >                   (bus->dev_count - i) * sizeof(struct kvm_io_range));
> > > >           rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
> > > > -       call_srcu(&kvm->srcu, &bus->rcu, __free_bus);
> > > > +       call_srcu_expedited(&kvm->srcu, &bus->rcu, __free_bus);
> > > > 
> > > >           return 0;
> > > >    }
> > > 
> 

