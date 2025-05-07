Return-Path: <kvm+bounces-45713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E554AAE330
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 16:38:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA84F3BB395
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 14:32:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC39528935D;
	Wed,  7 May 2025 14:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fxyKsmx0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4FC25745C
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 14:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746628367; cv=none; b=VvSFTb8gV+SAKtu7TAwoKBU2RpKRfXxnpRqGcPxD5EfBLNQR/CmoDJ02jzoVo/Pf+RWSJXkInemXDBN3lgNAAR6KZRntGH3XLlhVAXj/pkm6AYAn/a34DBofC7jlMBEZhUqsPPsyJcYCw5iOoopkliOBYrp/8QbmIWYZdXYlnTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746628367; c=relaxed/simple;
	bh=jioF/+b3Tvjy/E0Y2VmWY5RdJgnHHIX9RsgPmF5bwTM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tvUEI/S2yYqHMO6g+VxPNMzWarXwmEjZVEXQaUnBv2N/M0Fed3MZMObb3MPvXEA7kdcS5Gky+2vUNTCBdCqrk/KIyeqnfqCvfcvieuqpMUojmnCSoJaSoRXXSte+twkwx/9QmdoNhJyvtqEuRnDZL5MzZalCcjbqyx2pNsvTHbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fxyKsmx0; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-739525d4d7bso4567270b3a.2
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 07:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746628365; x=1747233165; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1cy0MsCwZXeebtI/qV5RxpPFKyFGvdPyAhseWZVMeuc=;
        b=fxyKsmx0FkFShOrsGxJkDi2tswzuPP5IxT6ERWbDj91WiYLUQKixLYclZgPvQsjjSj
         LidJlzYjJJMWDmJT222R4cS50zxqSoRLK6ooGScCtx9KHNWx2yo21RuJM8eO23C/VcFG
         a5PiUZDuNtfiPhH0pZmO5up/n1X8ThKbFG1fMzesAaBITlE/N2ssRFRApv9A/qc4Q2av
         hpFzph9qeX02eEVlE7yHVqpSLgW5ksRF0rDuKXq9vfMcBBuHh1p3gzHsz5FUnj7coL6x
         HdFNaKedMp+URPigoprRPfArJzL2hCQVO+wptCXIOAKDInipo6U4aQgPKcgkJONpWfTc
         ggNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746628365; x=1747233165;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1cy0MsCwZXeebtI/qV5RxpPFKyFGvdPyAhseWZVMeuc=;
        b=sUuEk4EQUxdvJFsPuzdLecRmgiDSQn7T1+q2ZgGlOjOcY00u3riSrYs4ZOCjfzFcUG
         FBfW3WGs/VRIgE/v1C6EN5rYL/8FzrV6+f9KVR8/jT0BI6we7Nd8AXn3vkHlrrX3vGhA
         Lr3rEtxpuB/mxWfXh63EKp6KqbB4iONgcSztYBINB5AR0xv2IWc6J1gxUygEAwDJYXj1
         Vi0+p0kBGl7J95YMA3QezTTmJErpANpYrRgYueXR1sfhRB3fL8JwO8Gr5mqtyjC0p8SJ
         HTHU6fxoN7zYgw2nsFY9KndEU4ebj/L4XX8Wx7ylSd+hL2jayTAJQCr9BTOITKpYUXmt
         aQVA==
X-Forwarded-Encrypted: i=1; AJvYcCUH9roneKktCf+nVngAvw4Z/8Tjo6EngDp7afBmtGPM4VhO/9hgDVPHg93TSnEpTQ532t4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNTxt3imRPiI7ipL09802HxtylZKiFczpViXSqMLZzpbtlkZzG
	kqdazjpcgt3gjn2rnoXTEiEUNc3i9s2gAZkL+6d+3EN0BSdCjsxwwj67YtfOOVTHLYTRcwVPohc
	gbw==
X-Google-Smtp-Source: AGHT+IEFrv6tdIicybAuNsOV6e762Ja8XkyFYRXi1ZowjtvTFyDF+rQtHVmfENoKXdwPbMc8F7B97APEJ+M=
X-Received: from pfix12.prod.google.com ([2002:aa7:9a8c:0:b0:740:341:8a0b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:42:b0:1ee:dd60:194f
 with SMTP id adf61e73a8af0-2148cd2d1f8mr5062892637.26.1746628364740; Wed, 07
 May 2025 07:32:44 -0700 (PDT)
Date: Wed, 7 May 2025 07:32:43 -0700
In-Reply-To: <4bfe7a8f5020448e903e6335173afc75@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250423092509.3162-1-lirongqing@baidu.com> <aAkAY40UbqzQNr8m@google.com>
 <4bfe7a8f5020448e903e6335173afc75@baidu.com>
Message-ID: <aBtgTnQU0JlNq2Y3@google.com>
Subject: Re: =?utf-8?B?562U5aSNOiBbPz8/Pw==?= =?utf-8?Q?=5D?= Re: [PATCH] KVM:
 Use call_rcu() in kvm_io_bus_register_dev
From: Sean Christopherson <seanjc@google.com>
To: Li Rongqing <lirongqing@baidu.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Li Zhaoxin <lizhaoxin04@baidu.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 24, 2025, Li,Rongqing wrote:
> > On Wed, Apr 23, 2025, lirongqing wrote:
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c index
> > > 2e591cc..af730a5 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -5865,6 +5865,13 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu,
> > enum kvm_bus bus_idx, gpa_t addr,
> > >  	return r < 0 ? r : 0;
> > >  }
> > >
> > > +static void free_kvm_io_bus(struct rcu_head *rcu) {
> > > +	struct kvm_io_bus *bus = container_of(rcu, struct kvm_io_bus, rcu);
> > > +
> > > +	kfree(bus);
> > > +}
> > > +
> > >  int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx,
> > gpa_t addr,
> > >  			    int len, struct kvm_io_device *dev)  { @@ -5903,8 +5910,8
> > @@
> > > int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t
> > addr,
> > >  	memcpy(new_bus->range + i + 1, bus->range + i,
> > >  		(bus->dev_count - i) * sizeof(struct kvm_io_range));
> > >  	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
> > > -	synchronize_srcu_expedited(&kvm->srcu);
> > > -	kfree(bus);
> > > +
> > > +	call_srcu(&kvm->srcu, &bus->rcu, free_kvm_io_bus);
> > 
> > I don't think this is safe from a functional correctness perspective, as
> > KVM must guarantee all readers see the new device before KVM returns
> > control to userspace.  E.g. I'm pretty sure KVM_REGISTER_COALESCED_MMIO is
> > used while vCPUs are active.
> > 
> > However, I'm pretty sure the only readers that actually rely on SRCU are vCPUs,
> > so I _think_ the synchronize_srcu_expedited() is necessary if and only if vCPUs
> > have been created.
> > 
> > That could race with concurrent vCPU creation in a few flows that don't
> > take kvm->lock, but that should be ok from an ABI perspective.  False
> > kvm->positives (vCPU creation fails) are benign, and false negatives (vCPU
> > created after the check) are inherently racy, i.e. userspace can't
> > guarantee the vCPU sees any particular ordering.
> > 
> > So this?
> > 
> > 	if (READ_ONCE(kvm->created_vcpus)) {
> > 		synchronize_srcu_expedited(&kvm->srcu);
> > 		kfree(bus);
> > 	} else {
> > 		call_srcu(&kvm->srcu, &bus->rcu, free_kvm_io_bus);
> > 	}
> 
> 
> If call_srcu is able to used only before creating vCPU, the upper will have
> little effect, since most device are created after creating vCPU

Is that something that can be "fixed" in userspace?  I.e. why are devices being
created after vCPUs?

> We want to optimize the ioeventfd creation, since a VM will create lots of
> ioeventfd, 

Ah, so this isn't about device creation from userspace, rather it's about reacting
to the guest's configuration of a device, e.g. to register doorbells when the guest
instantiates queues for a device?

> can ioeventfd uses call_srcu?

No, because that has the same problem of KVM not ensuring vCPUs will observe the
the change before returning to userspace.

Unfortunately, I don't see an easy solution.  At a glance, every architecture
except arm64 could switch to protect kvm->buses with a rwlock, but arm64 uses
the MMIO bus for the vGIC's ITS, and I don't think it's feasible to make the ITS
stuff play nice with a rwlock.  E.g. vgic_its.its_lock and vgic_its.cmd_lock are
mutexes, and there are multiple ITS paths that access guest memory, i.e. might
sleep due to faulting.

Even if we did something x86-centric, e.g. futher special case KVM_FAST_MMIO_BUS
with a rwlock, I worry that using a rwlock would degrade steady state performance,
e.g. due to cross-CPU atomic accesses.

Does using a dedicated SRCU structure resolve the issue?  E.g. add and use
kvm->buses_srcu instead of kvm->srcu?  x86's usage of the MMIO/PIO buses is
limited to kvm_io_bus_{read,write}(), so it should be easy enough to do a super
quick and dirty PoC.

