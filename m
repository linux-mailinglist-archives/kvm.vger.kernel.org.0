Return-Path: <kvm+bounces-71252-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2HMFNpDilWliVwIAu9opvQ
	(envelope-from <kvm+bounces-71252-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 17:02:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 38474157924
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 17:02:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 394C63011BC4
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 16:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB9C5344033;
	Wed, 18 Feb 2026 16:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ilGh/R4q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAC53328E0
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 16:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771430535; cv=none; b=eiYjIRQqga5kjwNxzEwYKT3tQNIQXY9NOkf3Ji9BwCT/aux7dGES77R6p5Eeaucj1vHwM5EMVeQAzXIWmCVxiyik9VUgP3jxFhyx4cpLv7sOs8lQeF6OG4o06KRn7jJnSBIlJ/dDIZZ1hH9o1kE1/TAdk+5AP9fPdwV3TM4iAlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771430535; c=relaxed/simple;
	bh=Sya9btRRHCzFM+Kc07ob/2EMmNBJBIrHqnz7VyaAlYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LzUPLXKI/fcmWw+Q5ihcGKefX4WU0Xll6Epb8mKa0iYyj5I5FGX1q4PiRrvYwr9i06Tw+F8Kq0Ya0QJuKjWJKl+cUVBa/g4D8Rak1wubzN3GcZjvwRuKPRkZFIQ5jC59aAamtL9IUUl+1XDbbSqpx+c+BV61jBZA60rb85Qhcqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ilGh/R4q; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-4359228b7c6so4209876f8f.2
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 08:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771430532; x=1772035332; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6WI6XVVgb/sjOKhoe/ZrjdLzkj8wj+eqRqsuqmM7G5c=;
        b=ilGh/R4q1e54/vmRdKPSG2jCNkw3RZ2sUD5ufG8vDhmvgbNU+/4Ktc9NRa4qlScuLG
         nR4bMsk9XyBvmtVyWkk2KmaHCF78P833RZDM/rAPTkqkDMBAJXAJrJBQxOJNf6Y/IN4z
         K89eP1SyJTvzxTEcRAhoA8DCajfK9Sf6t+dhAxVx0AqDrjHfy5Ea3/vEFKZ+ATwll2Xe
         BfRR/g9HG8qGT32koYy9rDwrzMvc3mBbGjHEGtEWRur3H6C8fZYuPO7QveIdJJF4Pesg
         pROrcEohlljNq0hifK5lFy8KlI8UqCPDxo2CufomIGTO6ozabW1vj1V6v4Q+7eSS2mpk
         iO/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771430532; x=1772035332;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6WI6XVVgb/sjOKhoe/ZrjdLzkj8wj+eqRqsuqmM7G5c=;
        b=MZYo2eubnOdMmlgDrsj7QZ9hLFBRMc+JymTRX/E1X2b7JB55628vuBWyIwcE69fujn
         UrfMLbUtqZJfQYtFBVI8pdVy1G0OL+J6pClx7h2d081+xZmNKZE/9aFdId4JqNnFK1jb
         jz+clNfSwZJ3NvWrTsiOHcHXHpcwvZsH5XosjtXC7Kq37OePj6W0UA88cJoG0olUcVhg
         +vQRCTbjzvO0X13HtqIIMfmDlkfO0vLh+mBi0SJScXBHsZwq9gCwlhasHybUQz8wzVaR
         BKtjWPwVE6NuZULvRdESE9f/0b3RIJdRFMLaH4PJR6jLYwE5CvlYJJpzTr/yGT6wKHtb
         CZkg==
X-Forwarded-Encrypted: i=1; AJvYcCXcFxtrTQccEm5Zt/Oed8Psm0cPiae/IacnCofeK4emu1pBrzm0v2F6UvBYYIEsskdPQZI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZVxDNi+Vl9aYVnpbhnr08pVneotcLDR703TVjuqaD1dwrDlSq
	3nNe20Gn94kgfczMclJWG3vefg8tZ8sgtK1dCWZnC/Pmnt9t6I7D5jR4yndA04wlYA==
X-Gm-Gg: AZuq6aLrc67YMD//q/U69HEh1syFe4pdjJpJ6ScVgjSZAWvsb+MLlODygL45NWXloED
	Em4aVFsFOhuA1G6Hjt4hcj0lmxfjCW7kQ/zLisDHidYUauz/1RJJ0/Dexb7/1vMINNLj+guj+Dv
	A0yEZ5PEUm8GqCc8l8+PshhyjCHQWU7yp58qz4ttbRIE6E91wxHhwRv6Ueq2+bsHS7OMvqI83CG
	qpDC7covRe8OQ9zpBhAGRK9+awCTmUl+IPV0cNVu5o78TrYA+3tPhHmjdKNVt1RbfAHqjiyBhTY
	AIJUDvgwHjFnjZFOTQsv67vyxlHBfKjaAQT/AGwxv5V59r/qhW29Vpsl08/xJGDO9+8d1XSqro1
	y4lTbj/ktbrwiTRGAZoX6ELdBwhmcKD/0cWuB/or8t5pAljIeUwtWrr3yUM1lkUg/Wi+AmX77vx
	u6esi9WvmpBozFQB/hW20LA1x0W9Pqx8QXkKPtyyZZrLuWe/N7HPArqP5EeIfsk9UdBwLidwI=
X-Received: by 2002:a05:6000:2510:b0:42b:3246:1681 with SMTP id ffacd0b85a97d-4379db64295mr25862256f8f.18.1771430529420;
        Wed, 18 Feb 2026 08:02:09 -0800 (PST)
Received: from google.com (164.102.240.35.bc.googleusercontent.com. [35.240.102.164])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796ac800esm45562165f8f.27.2026.02.18.08.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 08:02:08 -0800 (PST)
Date: Wed, 18 Feb 2026 16:02:05 +0000
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
Message-ID: <aZXifSagpbj4CjBn@google.com>
References: <20250909100007.3136249-1-keirf@google.com>
 <20250909100007.3136249-5-keirf@google.com>
 <a84ddba8-12da-489a-9dd1-ccdf7451a1ba@amazon.com>
 <aY-x0OlJQEqInyNF@google.com>
 <dcbd7a58-c961-4510-ae48-ef7fd4f4d75c@amazon.com>
 <aZS8XXOW7vhMkNWQ@google.com>
 <162cedc3-cd6c-494c-b39e-daadfbd6d8db@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162cedc3-cd6c-494c-b39e-daadfbd6d8db@amazon.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71252-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[keirf@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 38474157924
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 12:55:11PM +0000, Nikita Kalyazin wrote:
> 
> 
> On 17/02/2026 19:07, Sean Christopherson wrote:
> > On Mon, Feb 16, 2026, Nikita Kalyazin wrote:
> > > On 13/02/2026 23:20, Sean Christopherson wrote:
> > > > On Fri, Feb 13, 2026, Nikita Kalyazin wrote:
> > > > > I am not aware of way to make it fast for both use cases and would be more
> > > > > than happy to hear about possible solutions.
> > > > 
> > > > What if we key off of vCPUS being created?  The motivation for Keir's change was
> > > > to avoid stalling during VM boot, i.e. *after* initial VM creation.
> > > 
> > > It doesn't work as is on x86 because the delay we're seeing occurs after the
> > > created_cpus gets incremented
> > 
> > I don't follow, the suggestion was to key off created_vcpus in
> > kvm_io_bus_register_dev(), not in kvm_swap_active_memslots().  I can totally
> > imagine the patch not working, but the ordering in kvm_vm_ioctl_create_vcpu()
> > should be largely irrelevant.
> 
> Yes, you're right, it's irrelevant.  I had made the change in
> kvm_io_bus_register_dev() like proposed, but have no idea how I couldn't see
> the effect.  I retested it now and it's obvious that it works on x86.  Sorry
> for the confusion.
> 
> > 
> > Probably a moot point though.
> 
> Yes, this will not solve the problem on ARM.

Sorry for being late to this thread. I'm a bit confused now. Did
Sean's original patch (reintroducing the old logic, based on whether
any vcpus have been created) work for both/either/neither arch? I
would have expected it to work for both ARM and X86, despite the
offending synchronize_srcu() not being in the vcpu-creation ioctl on
ARM, and I think that is finally what your testing seems to show? If
so then that seems the pragmatic if somewhat ugly way forward.

 Cheers,
  Keir


> > 
> > > so it doesn't allow to differentiate the two
> > > cases (below is kvm_vm_ioctl_create_vcpu):
> > > 
> > >        kvm->created_vcpus++; // <===== incremented here
> > >        mutex_unlock(&kvm->lock);
> > > 
> > >        vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
> > >        if (!vcpu) {
> > >                r = -ENOMEM;
> > >                goto vcpu_decrement;
> > >        }
> > > 
> > >        BUILD_BUG_ON(sizeof(struct kvm_run) > PAGE_SIZE);
> > >        page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> > >        if (!page) {
> > >                r = -ENOMEM;
> > >                goto vcpu_free;
> > >        }
> > >        vcpu->run = page_address(page);
> > > 
> > >        kvm_vcpu_init(vcpu, kvm, id);
> > > 
> > >        r = kvm_arch_vcpu_create(vcpu); // <===== the delay is here
> > > 
> > > 
> > > firecracker   583 [001]   151.297145: probe:synchronize_srcu_expedited:
> > > (ffffffff813e5cf0)
> > >      ffffffff813e5cf1 synchronize_srcu_expedited+0x1 ([kernel.kallsyms])
> > >      ffffffff81234986 kvm_swap_active_memslots+0x136 ([kernel.kallsyms])
> > >      ffffffff81236cdd kvm_set_memslot+0x1cd ([kernel.kallsyms])
> > >      ffffffff81237518 kvm_set_memory_region.part.0+0x478 ([kernel.kallsyms])
> > >      ffffffff81264dbc __x86_set_memory_region+0xec ([kernel.kallsyms])
> > >      ffffffff8127e2dc kvm_alloc_apic_access_page+0x5c ([kernel.kallsyms])
> > >      ffffffff812b9ed3 vmx_vcpu_create+0x193 ([kernel.kallsyms])
> > >      ffffffff8126788a kvm_arch_vcpu_create+0x1da ([kernel.kallsyms])
> > >      ffffffff8123c54c kvm_vm_ioctl+0x5fc ([kernel.kallsyms])
> > >      ffffffff8167b331 __x64_sys_ioctl+0x91 ([kernel.kallsyms])
> > >      ffffffff8251a89c do_syscall_64+0x4c ([kernel.kallsyms])
> > >      ffffffff8100012b entry_SYSCALL_64_after_hwframe+0x76 ([kernel.kallsyms])
> > >                6512de ioctl+0x32 (/mnt/host/firecracker)
> > >                 d99a7 std::rt::lang_start+0x37 (/mnt/host/firecracker)
> > > 
> > > Also, given that it stumbles after the KVM_CREATE_VCPU on ARM (in
> > > KVM_SET_USER_MEMORY_REGION), it doesn't look like a universal solution.
> > 
> > Hmm.  Under the hood, __synchronize_srcu() itself uses __call_srcu, so I _think_
> > the only practical difference (aside from waiting, obviously) between call_srcu()
> > and synchronize_srcu_expedited() with respect to "transferring" grace period
> > latency is that using call_srcu() could start a normal, non-expedited grace period.
> > 
> > IIUC, SRCU has best-effort logic to shift in-flight non-expedited grace periods
> > to expedited mode, but if the normal grace period has already started the timer
> > for the delayed invocation of process_srcu(), then SRCU will still wait for one
> > jiffie, i.e. won't immediately queue the work.
> > 
> > I have no idea if this is sane and/or acceptable, but before looping in Paul and
> > others, can you try this to see if it helps?
> 
> That's exactly what I tried myself before and it didn't help, probably for
> the reason you mentioned above (a normal GP being already started).
> 
> > 
> > diff --git a/include/linux/srcu.h b/include/linux/srcu.h
> > index 344ad51c8f6c..30437dc8d818 100644
> > --- a/include/linux/srcu.h
> > +++ b/include/linux/srcu.h
> > @@ -89,6 +89,8 @@ void __srcu_read_unlock(struct srcu_struct *ssp, int idx) __releases(ssp);
> > 
> >   void call_srcu(struct srcu_struct *ssp, struct rcu_head *head,
> >                  void (*func)(struct rcu_head *head));
> > +void call_srcu_expedited(struct srcu_struct *ssp, struct rcu_head *rhp,
> > +                        rcu_callback_t func);
> >   void cleanup_srcu_struct(struct srcu_struct *ssp);
> >   void synchronize_srcu(struct srcu_struct *ssp);
> > 
> > diff --git a/kernel/rcu/srcutree.c b/kernel/rcu/srcutree.c
> > index ea3f128de06f..03333b079092 100644
> > --- a/kernel/rcu/srcutree.c
> > +++ b/kernel/rcu/srcutree.c
> > @@ -1493,6 +1493,13 @@ void call_srcu(struct srcu_struct *ssp, struct rcu_head *rhp,
> >   }
> >   EXPORT_SYMBOL_GPL(call_srcu);
> > 
> > +void call_srcu_expedited(struct srcu_struct *ssp, struct rcu_head *rhp,
> > +                        rcu_callback_t func)
> > +{
> > +       __call_srcu(ssp, rhp, func, rcu_gp_is_normal());
> > +}
> > +EXPORT_SYMBOL_GPL(call_srcu_expedited);
> > +
> >   /*
> >    * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
> >    */
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 737b74b15bb5..26215f98c98f 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -6036,7 +6036,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
> >          memcpy(new_bus->range + i + 1, bus->range + i,
> >                  (bus->dev_count - i) * sizeof(struct kvm_io_range));
> >          rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
> > -       call_srcu(&kvm->srcu, &bus->rcu, __free_bus);
> > +       call_srcu_expedited(&kvm->srcu, &bus->rcu, __free_bus);
> > 
> >          return 0;
> >   }
> 

