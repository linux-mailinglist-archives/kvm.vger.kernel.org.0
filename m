Return-Path: <kvm+bounces-22258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B980D93C7B5
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 19:37:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E6FF281283
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 17:37:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFA2A19DF78;
	Thu, 25 Jul 2024 17:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mv6L+T6t"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5456512B72
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 17:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721929066; cv=none; b=VhiSZhl09/0hSMFMM12FnvQ8bjC3Ued9V5T1i8Lz3PU+1WfuzUngpF2zsVeXBAtW1SHRW8NcfjRczSFkK0zwHCIjqOqJSvvjcaLAWT086SiGp5az673pLoDztgoUijpcydYPb/JqdhQmi+ldMIBEcWUkItf6zocf4msbPR0jwO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721929066; c=relaxed/simple;
	bh=vdALvz3a8w2em1aYeLslMZpPgz3ROZ6wXDMrm7mVZBY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=D7ENleUulIMn/9oZJnS0uNcmNBThg3FJ/yW45QkHbHfowK2OoQ+JP8TIjxaLDQBixF94NXivVDTjSO47/YVUjNdaAGXJesNyUt+xyv2Nr31Yg2XDoHemQQ8aJsGkJECd/tNERruhtJ4FJNuLJyVVKMjfOIKXieLmU0wZTHe2tRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mv6L+T6t; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721929063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6vtQ8ERzCxeHTyQEKEvDyf0dGBFdbqzEzRI9LXLcuWw=;
	b=Mv6L+T6tpxuNQshUzjEZZ3bOk9rw5GJtAFFBBKcQsUHtFXLJlJoDhoxd2tL+rIrbyMJUAT
	tEYJN3/v/i57tByWHMvG9qf5+J0hD1qxmK2cKE/m0/2hR/1eZeK2/KzscOoqVwlWYtiLV9
	HGfqZYf5QEGY3FMlFuffCooqFXKSKcY=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-31-dv2Vh0waP0-6r1bID8Lnsw-1; Thu, 25 Jul 2024 13:37:42 -0400
X-MC-Unique: dv2Vh0waP0-6r1bID8Lnsw-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6b7a5ab3971so16964846d6.2
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 10:37:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721929061; x=1722533861;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6vtQ8ERzCxeHTyQEKEvDyf0dGBFdbqzEzRI9LXLcuWw=;
        b=ogG92K5o0tGfMfcP47p53hh/YBV35rlN+vBWv/XbS/KKvZEKPkNw+Q0G0nXh9IrZQs
         eps/KKIC7tl69sLfMVxXJ0NgnuJ4ndglIq2rS1qt0bYJWKfRVY0l6PfyL/Vp8SVzJ5Pj
         5umuUg/tn5I/tqDyPK4GQJIbBNiOWQIWLTRZZFBIAByaGAqQBaIPvri2gDKNqJQsPnYe
         /AZL0EtQX0e7NUYKyUAp9pEsSjV0BvjlUe3wNYQPztYFrmw5EyHQveehUMS3hYHqUAE5
         gZoNH05BEq+xwEkFcCPivedEE4O73+S0/t9gUT9REbGHSLbn5/znMHxma7UnGdDcHcpR
         4sLQ==
X-Gm-Message-State: AOJu0YzL/YD70YtOHiIxjZgBCzbfqdu0EhzdBQy9awQJGVr4OgtkBIQ5
	PIZxXmWaFo8ycZrXdhoO3rY85nFw9soB7huMKU3/cv5uyGdukvaE443GTAiCVTPvN1mC21e9Pk0
	NbTyKi1/hT7zWw4qKDmPpK1VR2kXf0Pasl07GoxTSiNDe0jY53aiykktrAQ==
X-Received: by 2002:a05:6214:4017:b0:6b7:a485:9dd0 with SMTP id 6a1803df08f44-6bb407068c5mr24084756d6.21.1721929061316;
        Thu, 25 Jul 2024 10:37:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+GM1ErI+F5Scx2xanlXL2A4m0NqINsVmg6FWUPW3i7x0UTJByUNwJfsx51otU+vykh2jW7g==
X-Received: by 2002:a05:6214:4017:b0:6b7:a485:9dd0 with SMTP id 6a1803df08f44-6bb407068c5mr24084476d6.21.1721929060862;
        Thu, 25 Jul 2024 10:37:40 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bb3fae79d9sm9217046d6.125.2024.07.25.10.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jul 2024 10:37:40 -0700 (PDT)
Message-ID: <9b4d5563d8ad04f30ee24d4aaa495f787bdef71d.camel@redhat.com>
Subject: Re: [PATCH v2 2/2] KVM: VMX: disable preemption when touching
 segment fields
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar
 <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
 Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org, Dave Hansen
 <dave.hansen@linux.intel.com>,  Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 25 Jul 2024 13:37:39 -0400
In-Reply-To: <f183d215c903d4d1e85bf89e9d8b57dd6ce5c175.camel@redhat.com>
References: <20240716022014.240960-1-mlevitsk@redhat.com>
	 <20240716022014.240960-3-mlevitsk@redhat.com> <Zpb127FsRoLdlaBb@google.com>
	 <f183d215c903d4d1e85bf89e9d8b57dd6ce5c175.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2024-07-25 at 08:59 -0400, Maxim Levitsky wrote:
> On Tue, 2024-07-16 at 15:36 -0700, Sean Christopherson wrote:
> > On Mon, Jul 15, 2024, Maxim Levitsky wrote:
> > > VMX code uses segment cache to avoid reading guest segment fields.
> > > 
> > > The cache is reset each time a segment's field (e.g base/access rights/etc)
> > > is written, and then a new value of this field is written.
> > > 
> > > However if the vCPU is preempted between these two events, and this
> > > segment field is read (e.g kvm reads SS's access rights to check
> > > if the vCPU is in kernel mode), then old field value will get
> > > cached and never updated.
> > 
> > It'be super helpful to include the gory details about how kvm_arch_vcpu_put()
> > reads stale data.  Without that information, it's very hard to figure out how
> > getting preempted is problematic.
> 
> I will do this in next version of this patch.
> 
> >   vmx_vcpu_reset resets the segment cache bitmask and then initializes
> >   the segments in the vmcs, however if the vcpus is preempted in the
> >   middle of this code, the kvm_arch_vcpu_put is called which
> >   reads SS's AR bytes to determine if the vCPU is in the kernel mode,
> >   which caches the old value.
> > 
> > > Usually a lock is required to avoid such race but since vCPU segments
> > > are only accessed by its vCPU thread, we can avoid a lock and
> > > only disable preemption, in places where the segment cache
> > > is invalidated and segment fields are updated.
> > 
> > This doesn't fully fix the problem.  It's not just kvm_sched_out() => kvm_arch_vcpu_put()
> > that's problematic, it's any path that executes KVM code in interrupt context.
> > And it's not just limited to segment registers, any register that is conditionally
> > cached via arch.regs_avail is susceptible to races.
> > 
> > Specifically, kvm_guest_state() and kvm_guest_get_ip() will read SS.AR_bytes and
> > RIP in NMI and/or IRQ context when handling a PMI.
> > A few possible ideas.
> > 
> >  1. Force reads from IRQ/NMI context to skip the cache and go to the VMCS.
> 
> This IMHO is the best solution. For segment cache its easy to do, the code
> will be contained in vmx_read_guest_seg_* functions.
> 
> For other VMX registers, this can be lot of work due to the way the code is scattered
> around. Still probably double.
> 
> 
> >  2. Same thing as #1, but focus it specifically on kvm_arch_vcpu_in_kernel()
> >     and kvm_arch_vcpu_get_ip(), and WARN if kvm_register_is_available() or
> >     vmx_segment_cache_test_set() is invoked from IRQ or NMI context.
> 
> I agree on this, this is actually one of the suggestions I had originally.
> ( I didn't notice the kvm_arch_vcpu_get_ip though )
> 
> I think I will implement this suggestion.
> 
> >  3. Force caching of SS.AR_bytes, CS.AR_bytes, and RIP prior to kvm_after_interrupt(),
> >     rename preempted_in_kernel to something like "exited_in_kernel" and snapshot
> >     it before kvm_after_interrupt(), and add the same hardening as #2.
> > 
> >     This is doable because kvm_guest_state() should never read guest state for
> >     PMIs that occur between VM-Exit and kvm_after_interrupt(), nor should KVM
> >     write guest state in that window.  And the intent of the "preempted in kernel"
> >     check is to query vCPU state at the time of exit.
> > 
> >  5. Do a combination of #3 and patch 02 (#3 fixes PMIs, patch 02 fixes preemption).
> > My vote is probably for #2 or #4.
> #4 causes a NULL pointer deference here :) 
> 
> >   I definitely think we need WARNs in the caching
> > code, and in general kvm_arch_vcpu_put() shouldn't be reading cacheable state, i.e.
> > I am fairly confident we can restrict it to checking CPL.
> > 
> > I don't hate this patch by any means, but I don't love disabling preemption in a
> > bunch of flows just so that the preempted_in_kernel logic works.
> > 
> 
> Thanks for the suggestions!

Hi,

I decided to keep it simple. I'll send a patch which moves call to the vmx_segment_cache_clear
to be after we done with the segment initialization in vmx_vcpu_reset, and later I
write a refactoring/hardening to make sure that we don't read the cache
from the interrupt context.

Best regards,
	Maxim Levitsky



> 
> Best regards,	
> 	Maxim Levitsky
> 
> 
> 



