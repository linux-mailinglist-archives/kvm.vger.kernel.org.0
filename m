Return-Path: <kvm+bounces-21537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0612A92FED0
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 18:51:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 260521C21E4D
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 16:51:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E025176AB3;
	Fri, 12 Jul 2024 16:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="HNsotdYJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E05614EC5E
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 16:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803062; cv=none; b=WG0zPNultlcsK24UUqimxCBKM8/ib+vIJ4n5rFt2ueVQLrTDLIUjEB2qVe9l4HZO/82YN3a1COCKXgbtVOAdWXV4LfG2iNw+7+tDKlMeP7VIeVoTGzgSX6NJUTyiAUDlkJeZaWyk8nSH8FlNX2eZZ9Nm3apTEA6MM57GepFP7WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803062; c=relaxed/simple;
	bh=GIxv7kyr1fOYOTFD8h5UlkXFpaIz/l2mkymV2jG4dIE=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eTnAWkKUNQkVv1w6OA6qPMKlea26D1XhRDU5ItStwyEWfbLMCpvgYm/IF1zFXRCvOeGI3TvJ3mZbaDkYOqLSTatYMXrG9sYPquei99SpNL0A0x9kpsn/nHW66N1gs/juRrMpz3tGP3RZeIT2wiW4c6xM0S53CJdzv5MVUAc62Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org; spf=pass smtp.mailfrom=joelfernandes.org; dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b=HNsotdYJ; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joelfernandes.org
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-79f0c08aa45so155127785a.0
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 09:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1720803060; x=1721407860; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7TgW3Fxolq5hWIfDVfOFTW8e1mACsU8DTpdpP/Urrsw=;
        b=HNsotdYJlvsa9HEb6tYdil5Z7eEehGhUnob80gYft2Our5dMqzzZtJPNFl3zYxlGH4
         b3WAwaq6JR/2ErF8f0Ro9qOPeY+BGTSV9iFWVCY2l04o1E2kWtesgS1Tbq4yEhRJHyQ7
         G9SoCTuBNlGVZsdUXpRZl3vdU8s6/Ay/lOZeg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803060; x=1721407860;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7TgW3Fxolq5hWIfDVfOFTW8e1mACsU8DTpdpP/Urrsw=;
        b=dloag3D+bZfaJnmbDZimkcLTrPKJCjVFQZ7ph5223c2EBbRZ98/OiW7h5jStBPi0bi
         dpgCbsGxCnWCoAJv6adz5QkJ0YCcb3IGxkTzH53awE0XfDSBmxuv7vZP+JytG3ppStUw
         RjrBFgCgKD602b4rhrH2+xbDWZSs0vvNOvyRZ0aJm0VOqRKd0WjODSZDG88fjaq5da1O
         NbavzTyNcVz7Gw3zq16aga4ZEjlqFD3OOMhXLxE4JgOwf/KLvPRqTEbkyD5ZkkbKC5ib
         3QJRfDWXVf+nkseZn4HuDZxxBeYK72ahGKFv7QNLxraXJ71inVOx7uZFyDDSRXmHWLi9
         WkQA==
X-Forwarded-Encrypted: i=1; AJvYcCWsizs4Udm6kmXQw4I358hasfKDWgEaBipfYLzqkR5YC4FKb/nZPuONnlwZL4/s+8wb3F0nGP9nMJwmMIKgRZPHNZr8
X-Gm-Message-State: AOJu0YxMDSobROIeu4oR4h5M7ZbIAxeim8EIHco3O+NkXg8OpbT4u9IT
	gt8SzLj35rsGzSYFM5YFukT75wbSTZjJ5HqJ4c4LkOCGxNoHjs03YZWrv3nAD3A=
X-Google-Smtp-Source: AGHT+IGDZbjK2vfzdGQ04zfdQtcFDzbhW00kvjY2XCWo4lK+eLrLbVcitvWMacaFEGabuMdumAuMzw==
X-Received: by 2002:a05:620a:28c8:b0:79e:fca5:c312 with SMTP id af79cd13be357-79f19a78d1emr1572957785a.38.1720803059944;
        Fri, 12 Jul 2024 09:50:59 -0700 (PDT)
Received: from localhost ([73.134.137.40])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79f190b2f93sm417696685a.125.2024.07.12.09.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jul 2024 09:50:59 -0700 (PDT)
Message-ID: <66915ef3.050a0220.72f83.316b@mx.google.com>
X-Google-Original-Message-ID: <20240712165057.GA57824@JoelBox.>
Date: Fri, 12 Jul 2024 12:50:57 -0400
From: Joel Fernandes <joel@joelfernandes.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Vineeth Remanan Pillai <vineeth@bitbyteword.org>,
	Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>, himadrics@inria.fr,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	graf@amazon.com, drjunior.org@gmail.com
Subject: Re: [RFC PATCH v2 0/5] Paravirt Scheduling (Dynamic vcpu priority
 management)
References: <20240403140116.3002809-1-vineeth@bitbyteword.org>
 <ZjJf27yn-vkdB32X@google.com>
 <CAO7JXPgbtFJO6fMdGv3jf=DfiCNzcfi4Hgfn3hfotWH=FuD3zQ@mail.gmail.com>
 <CAO7JXPhMfibNsX6Nx902PRo7_A2b4Rnc3UP=bpKYeOuQnHvtrw@mail.gmail.com>
 <66912820.050a0220.15d64.10f5@mx.google.com>
 <19ecf8c8-d5ac-4cfb-a650-cf072ced81ce@efficios.com>
 <20240712122408.3f434cc5@rorschach.local.home>
 <ZpFdYFNfWcnq5yJM@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZpFdYFNfWcnq5yJM@google.com>

On Fri, Jul 12, 2024 at 09:44:16AM -0700, Sean Christopherson wrote:
> On Fri, Jul 12, 2024, Steven Rostedt wrote:
> > On Fri, 12 Jul 2024 10:09:03 -0400
> > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > 
> > > > 
> > > > Steven Rostedt told me, what we instead need is a tracepoint callback in a
> > > > driver, that does the boosting.  
> > > 
> > > I utterly dislike changing the system behavior through tracepoints. They were
> > > designed to observe the system, not modify its behavior. If people start abusing
> > > them, then subsystem maintainers will stop adding them. Please don't do that.
> > > Add a notifier or think about integrating what you are planning to add into the
> > > driver instead.
> > 
> > I tend to agree that a notifier would be much better than using
> > tracepoints, but then I also think eBPF has already let that cat out of
> > the bag. :-p
> > 
> > All we need is a notifier that gets called at every VMEXIT.
> 
> Why?  The only argument I've seen for needing to hook VM-Exit is so that the
> host can speculatively boost the priority of the vCPU when deliverying an IRQ,
> but (a) I'm unconvinced that is necessary, i.e. that the vCPU needs to be boosted
> _before_ the guest IRQ handler is invoked and (b) it has almost no benefit on
> modern hardware that supports posted interrupts and IPI virtualization, i.e. for
> which there will be no VM-Exit.

I am a bit confused by your statement Sean, because if a higher prio HOST
thread wakes up on the vCPU thread's phyiscal CPU, then a VM-Exit should
happen. That has nothing to do with IRQ delivery.  What am I missing?

thanks,

 - Joel

