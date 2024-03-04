Return-Path: <kvm+bounces-10830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40D22870BA1
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 21:33:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BFB53B22019
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 20:33:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4B8B8F6F;
	Mon,  4 Mar 2024 20:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h40mIeUk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6679A8BF9
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 20:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709584375; cv=none; b=nW6Qbat6WWJHLhjnkPhhnrd4YKI22a/P+fJB1nphQMAT9p3JOdvtYa+TT9yIIBSMD/I39YsPTwZFlNddxNCxyjP8gFXOaSWBmCc1DYd9yG95QEv9goEUa8ao75CudfmAIun63sIJROyrAcnGeyylKkqBWsBV7GJ0oYcJbYpJ3W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709584375; c=relaxed/simple;
	bh=aN7iBP0Fr7hMMlKq3I0xxEeo5y2nD9yxqABrzVhf8DU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KjlBYW49NDw+vzCVxMqLMGO60USE/QlCgQnzmRTHN8HvI+e0Rsj6L2N4HzG5SKqHc+/awbBTbrCaa68dNwyV2veWmYsWc8O+YDjnUhGgE6898RJbVtfk/WsZpkzhf9+yUTM+tCF8mEZsFQg+mmm5MtzhkjT8oHUlHxHfECQW5fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h40mIeUk; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcd94cc48a1so7656548276.3
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 12:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709584373; x=1710189173; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IGjbhidK9mIBRigo6mJIfMD0RxuUrgdaznMkQx4mOsU=;
        b=h40mIeUk2nE9giQpXMqUNwvUJqpF1fkK4IT7EJGWhc5287zOFncD8iVyqFacKAyZ+1
         +geFRGvz5329BX3B5mQcXKkwNR15W7/N1atza+SFbXuRhfNDkyd7PPr1llrW+oP24byf
         3pZoKDRnBvWA0nlx8PZRB/Jo9D0qzioehzFFkRQo975tjqOC+R4TLdwQ1VZ7B/KXrCW4
         7Qddhq3pjSqviN5djo6dOM1CZ5bioQVcFUWZOvkhNltwb+0hSSMGl93f33U/m6Fur3JX
         TpL7XKl/dvls7L/Ze+iaYOaP64uRmbSDXby/jxycyeHYkLJ65n08UMZe4SosXa+Odq0v
         Yfaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709584373; x=1710189173;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IGjbhidK9mIBRigo6mJIfMD0RxuUrgdaznMkQx4mOsU=;
        b=h/LqA4IptvjI7q5ahAt3QxIIAwf+yNyucFJfEnNYoJ9s/zYkaP+T0ngN9qQ6zxXszf
         l0JkhyhCU5AYf+fHvsBc5RXorYHhZwie09yiTfS0jfLLDFScSh+6oEb2jvp+65w1AMps
         kb7WAVpQ5y6LhG0M+koQvbs03eDwT+nI5KygZBoI3JoHynkwPufyKdQPCn8kbq+CPmJ+
         r3MlrIyjelHqdfAc9RVJoXueI+Le3b1fznI+AGYhQgl8mHjexdd2I9cPwjwqegzxduQ8
         XC0Okvf2M6YoJYbUVsX+AcTSqwtFKI9pxXdBHwIZVyv1fCh6GUUKRr0Ydebm63oWNMH2
         73KA==
X-Forwarded-Encrypted: i=1; AJvYcCWaAmdpzTXw5wRwTQrkQQEm18izbXfdAxU8S1I6Iqn74ldLkgqs5/Vu8IjevUzW4wqeVg+E1U+GwL49j2hrUkBpDJes
X-Gm-Message-State: AOJu0YwZgJnHs/paTrYH/AVQI14Z7t6qhAK9UHVR2ASY9zIvnrM5BUKS
	g/0rcw7DzAG0BVv6xX4wfbWhgY4B0ISVQtwbNC+L3c4TE8/mp9D31ai2V5h3UFtXJA13D/G//+t
	3wg==
X-Google-Smtp-Source: AGHT+IEmRdAyXCmSUg6f9/OpeGnPuqGycjin7usqBi6tnzcnwZA/qldiy/+AtwEb+/ocbiyWAY5WKQraOik=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1004:b0:dc7:48ce:d17f with SMTP id
 w4-20020a056902100400b00dc748ced17fmr2609142ybt.10.1709584373516; Mon, 04 Mar
 2024 12:32:53 -0800 (PST)
Date: Mon, 4 Mar 2024 12:32:51 -0800
In-Reply-To: <ZeYqt86yVmCu5lKP@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <20240215235405.368539-9-amoorthy@google.com>
 <ZeYoSSYtDxKma-gg@linux.dev> <ZeYqt86yVmCu5lKP@linux.dev>
Message-ID: <ZeYv86atkVpVMa2S@google.com>
Subject: Re: [PATCH v7 08/14] KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO and
 annotate fault in the stage-2 fault handler
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Anish Moorthy <amoorthy@google.com>, maz@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com, jthoughton@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 04, 2024, Oliver Upton wrote:
> On Mon, Mar 04, 2024 at 08:00:15PM +0000, Oliver Upton wrote:
> > On Thu, Feb 15, 2024 at 11:53:59PM +0000, Anish Moorthy wrote:
> > 
> > [...]
> > 
> > > +	if (is_error_noslot_pfn(pfn)) {
> > > +		kvm_prepare_memory_fault_exit(vcpu, gfn * PAGE_SIZE, PAGE_SIZE,
> > > +					      write_fault, exec_fault, false);
> > 
> > Hmm... Reinterpreting the fault context into something that wants to be
> > arch-neutral might make this a bit difficult for userspace to
> > understand.
> > 
> > The CPU can take an instruction abort on an S1PTW due to missing write
> > permissions, i.e. hardware cannot write to the stage-1 descriptor for an
> > AF or DBM update. In this case HPFAR points to the IPA of the stage-1
> > descriptor that took the fault, not the target page.
> > 
> > It would seem this gets expressed to userspace as an intent to write and
> > execute on the stage-1 page tables, no?
> 
> Duh, kvm_vcpu_trap_is_exec_fault() (not to be confused with
> kvm_vcpu_trap_is_iabt()) filters for S1PTW, so this *should*
> shake out as a write fault on the stage-1 descriptor.
> 
> With that said, an architecture-neutral UAPI may not be able to capture
> the nuance of a fault. This UAPI will become much more load-bearing in
> the future, and the loss of granularity could become an issue.

What is the possible fallout from loss of granularity/nuance?  E.g. if the worst
case scenario is that KVM may exit to userspace multiple times in order to resolve
the problem, IMO that's an acceptable cost for having "dumb", common uAPI.

The intent/contract of the exit to userspace isn't for userspace to be able to
completely understand what fault occurred, but rather for KVM to communicate what
action userspace needs to take in order for KVM to make forward progress.

> Marc had some ideas about forwarding the register state to userspace
> directly, which should be the right level of information for _any_ fault
> taken to userspace.

I don't know enough about ARM to weigh in on that side of things, but for x86
this definitely doesn't hold true.  E.g. on the x86 side, KVM intentionally sets
reserved bits in SPTEs for "caching" emulated MMIO accesses, and the resulting
fault captures the "reserved bits set" information in register state.  But that's
purely an (optional) imlementation detail of KVM that should never be exposed to
userspace.

Ditto for things like access tracking on hardware without A/D bits, and shadow
paging, which again can generate fault state that is inscrutable/misleading
without context that only KVM knows (and shouldn't expose to userspace).

