Return-Path: <kvm+bounces-17458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 077BB8C6C98
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 21:09:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A70A1C221B5
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 19:09:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3405C1598EC;
	Wed, 15 May 2024 19:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xlsXxYUu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28E4158DD5
	for <kvm@vger.kernel.org>; Wed, 15 May 2024 19:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715800157; cv=none; b=Illqcfpp+lRZSA46gSb9n4pazyYrwLu8kj8zfaGt7DLhjbi6R4/uKJAXQAAW3d6W3VNtwYS+3J4LzsuMrciYCR7Bgr96IK6Bp5glWqlywdMjnOA3WCfvWo+H+UcHa0Q1h1HyhfV4PeXU4QopDAw4/fSc0f+XgiJg99Ax0mx+dcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715800157; c=relaxed/simple;
	bh=klDXW8FMsuxV7llpZoytjH+464Dy+E6cBZlgkcahN+o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CdwGQo22mAMfCuWKERfaa/B5BBe1TVR/yJq5v/PRFzyX47jsAwbqvtUJkT/gYdqb2x0hYlJe0gEYlBHmsyw7BO78VueZTVV0tN+dedrT14ZAAR0/aNWOljXc3wXt6kiWeESeBEm/omFnRepI5S5KOyXA2Fcv6S/BoC/f3orM62g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xlsXxYUu; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc64f63d768so12507503276.2
        for <kvm@vger.kernel.org>; Wed, 15 May 2024 12:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715800155; x=1716404955; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ksk0qnZLyUebfmxSRyzeWFRLym1uGNJcYwJ0+2ZuAS0=;
        b=xlsXxYUu9NjwIfomn2CrYckHEQiFAhfbJ4k7RZdMlN5eC0cAbtQImoJCoVEAdPjXZI
         MWFgo5j6Esd51cfRqknrTrY1rjoUxyi5075pdBrJuI0sp5nOBXkDuKNChL3l+llE0eTn
         CdAzH70N62Wxk0Mt4iKF+zKrTysXvA/EwkWmsThUkZlbngGj9KTIWJne5Pg20DcPk/m6
         AqG4eE7x54BKoN3wYEOHAl+EBDMycKtQcEf1AUGuurVTELbgV2aNZQ4pdO5+y7qfnfRJ
         DPpLLGJPwe7AiHhwSg8iEu0z3V32t/gSZSfQuMR1aq1GGj7GLDpF8OkdT/gZVj0r08R+
         eCRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715800155; x=1716404955;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ksk0qnZLyUebfmxSRyzeWFRLym1uGNJcYwJ0+2ZuAS0=;
        b=HBz5Pyzzl8AhMsuE0ec4qk0YX9Y9RZ5D503MenBpncXbUn9BnmsYVa045wkw/1QO7B
         1GEbdBDNfGQTD8ZGljiT0S/03E++KAVqV1zQwLPU5SvAABI36OGonL+ibpsymWIuodyS
         eoz7haRSyXxHqExo0A4jDGC1tAOZ7YBLddwU2JVwdFZ0hpVjSLNQP0KD8vae6mbJyPpi
         DKUTOBMVJjYxjZLYwNLzp+XiiKEdSkJLARJ0JjttlmIqGwo1loo117w+QlFftQo3Dueo
         moybbazip0yBxd/1kQdUnduiCMF3iFQ7QGNtAcWzKxyNoKYTJ/wgRKb8alvLntiM+UHG
         TNCQ==
X-Gm-Message-State: AOJu0YyM9Oqz8v8y6fg1r2XgBXYVNP3xIcsmNLGY4hT33byD8PsulSwU
	gz5TZ55gz4E9upamxc/Yj0QrArp4lxrrsuHGQ5SgU7zq10tov0jBZMcW3ztfPjyIr5GUbRytic6
	uyA==
X-Google-Smtp-Source: AGHT+IF54W6CDSZuUYYDejoZ+3AA3LnyDAgAkTZFWAyy8/fgUtDkNCkb3RG/fbGh2SCW2ohqUVM8Mnp8s4o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2b88:b0:dc6:d233:ffdd with SMTP id
 3f1490d57ef6-dee4f0d9077mr4594376276.0.1715800154952; Wed, 15 May 2024
 12:09:14 -0700 (PDT)
Date: Wed, 15 May 2024 12:09:13 -0700
In-Reply-To: <b89385e5c7f4c3e5bc97045ec909455c33652fb1.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-3-rick.p.edgecombe@intel.com> <b89385e5c7f4c3e5bc97045ec909455c33652fb1.camel@intel.com>
Message-ID: <ZkUIMKxhhYbrvS8I@google.com>
Subject: Re: [PATCH 02/16] KVM: x86/mmu: Introduce a slot flag to zap only
 slot leafs on slot deletion
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, "sagis@google.com" <sagis@google.com>, 
	"dmatlack@google.com" <dmatlack@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 15, 2024, Kai Huang wrote:
> On Tue, 2024-05-14 at 17:59 -0700, Rick Edgecombe wrote:
> > So, Sean re-considered about introducing a per-VM flag or per-memslot flag
> > again for VMs like TDX. [4]

Not really.  I tried to be as clear as I could that my preference was that _if_
we exposing _something_ to userspace, then that something should probably be a
memslot flag.

 : There's no concrete motiviation, it's more that _if_ we're going to expose a knob
 : to userspace, then I'd prefer to make it as precise as possible to minimize the
 : changes of KVM ending up back in ABI hell again.

As I stressed in that thread, I hadn't thought about this deeply enough to have
an opinion one way or the other.

 : You're _really_ reading too much into my suggestion.  As above, my suggestion
 : was very spur of the momemnt.  I haven't put much thought into the tradeoffs and
 : side effects.

> > This patch is an implementation of per-memslot flag.
> > Compared to per-VM flag approach,
> > Pros:
> > (1) By allowing userspace to control the zapping behavior in fine-grained
> >     granularity, optimizations for specific use cases can be developed
> >     without future kernel changes.
> > (2) Allows developing new zapping behaviors without risking regressions by
> >     changing KVM behavior, as seen previously.
> > 
> > Cons:
> > (1) Users need to ensure all necessary memslots are with flag
> >     KVM_MEM_ZAP_LEAFS_ONLY set.e.g. QEMU needs to ensure all GUEST_MEMFD
> >     memslot is with ZAP_LEAFS_ONLY flag for TDX VM.
> > (2) Opens up the possibility that userspace could configure memslots for
> >     normal VM in such a way that the bug [1] is seen.
> 
> I don't quite follow the logic why userspace should be involved.
> 
> TDX cannot use "page table fast zap", and need to use a different way to
> zap, a.k.a, zap-leaf-only while holding MMU write lock, but this doesn't
> necessarily mean such thing should be exposed to userspace?
> 
> It's weird that userspace needs to control how does KVM zap page table for
> memslot delete/move.

Yeah, this isn't quite what I had in mind.  Granted, what I had in mind may not
be much any better, but I definitely don't want to let userspace dictate exactly
how KVM manages SPTEs.

My thinking for a memslot flag was more of a "deleting this memslot doesn't have
side effects", i.e. a way for userspace to give KVM the green light to deviate
from KVM's historical behavior of rebuilding the entire page tables.  Under the
hood, KVM would be allowed to do whatever it wants, e.g. for the initial
implementation, KVM would zap only leafs.  But critically, KVM wouldn't be
_required_ to zap only leafs.

> So to me looks it's overkill to expose this "zap-leaf-only" to userspace.
> We can just set this flag for a TDX guest when memslot is created in KVM.

100% agreed from a functionality perspective.  My thoughts/concerns are more about
KVM's ABI.

Hmm, actually, we already have new uAPI/ABI in the form of VM types.  What if
we squeeze a documentation update into 6.10 (which adds the SEV VM flavors) to
state that KVM's historical behavior of blasting all SPTEs is only _guaranteed_
for KVM_X86_DEFAULT_VM?

Anyone know if QEMU deletes shared-only, i.e. non-guest_memfd, memslots during
SEV-* boot?  If so, and assuming any such memslots are smallish, we could even
start enforcing the new ABI by doing a precise zap for small (arbitrary limit TBD)
shared-only memslots for !KVM_X86_DEFAULT_VM VMs.

