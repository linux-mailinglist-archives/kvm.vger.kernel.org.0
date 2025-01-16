Return-Path: <kvm+bounces-35702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B7830A144CE
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 23:53:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E17B6164566
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 22:53:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 799BC22FDE1;
	Thu, 16 Jan 2025 22:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cMBMM9Zq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB1518A6A8
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 22:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737067996; cv=none; b=MQBH6RgHFXTxEPxO8dAjfOWaCW2kSTY4csC0NObp4MojHXoiDmVvR91idfDWkRB1dIuBBH5chxkRBSPU0UOXtyUfUs8xDsc2sxunHF17EUJHp4HM0Tu+lEtTDpuPOc3oXyH17A0l028WDM18RtJt8Y5WP2awWN407+ao2vf0f3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737067996; c=relaxed/simple;
	bh=M7hrbCFlo1i55ug6XscaT87cRTzYxoSC93gPldebbkw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H8HmUpF3zwMpP2ykj17NUddm/fUc1ZmamlGdHzr4XlnQRfz8ZZCgiS91Di8WNWl3JODs+jutU9la6DECc0oYqnMEOqLhk/EpW90wsAUPShhH6qo63Q2C6SSAjKe1BvG5Q5Opse2Hx42iB0V+C/Pvd7CJOVSYscgRSAbhsR96Hjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cMBMM9Zq; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2163c2f32fdso40408235ad.2
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 14:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737067994; x=1737672794; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YpsNgnSKVlvn4uHhcKm936EMtxOiPoBOMPpxpZBHoq8=;
        b=cMBMM9Zqd9Dt+B4gFdozhmc65ajV5WV33307e/xfbmhoa0Tw9K4kcAl6QI2cvyfOH7
         3FTG0eKiixXqEYkLQRFL2381j/Ui91r2M8ZLUzT/Phm3oTSAUfwUUPMmgAVbHFCIyABs
         TyMFHPA4xU72j3UPV3wsn45SX/Uqp+/zsIgrdPEg3QfiCiZ8+6h6B60jPabQ0MF89srO
         njzFjBLDhrLVZ4MiYYiAwrlEf14s4q1bFlCiHos7BCveNz/FCKFIpY6hvPrBhP237QUI
         FEphIKbRoinn4OhK8HGqoEz2qxo81oDO+CGXhvXo6AngTn002dyJvNhP9jouCpVQUReb
         w95A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737067994; x=1737672794;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YpsNgnSKVlvn4uHhcKm936EMtxOiPoBOMPpxpZBHoq8=;
        b=EMUDDPLpD1hCd7z88gaD/J8xkMkwrToj8DjnqQimSB+LxPo+1pc52r2fHzBzbbseJm
         Lm3NN9vd/pmsh4ltUYDfPG+iDjVGUZxqLiD1E7dDqfkbYxypXYw4bAyUeSKPZnr37BF9
         f0+fwyTTxclrDqPhxW0q2TahMFUW9t42fP+PQavQb6vIvRWujyyFPqms2TDwZjcL20Ht
         f0HJyYhTga3SY+uDhKte5HNuVI60UKJV7pWgF4LwmKJaiQJd3y4M7yqbLhbL/4Q9SfA4
         e6Cr2WsG7kdatr7c9FzgkoflrUs4js/NPvNxEqXYnCrp+vIwhrLjZyjItisW+bOj4+R7
         fMug==
X-Forwarded-Encrypted: i=1; AJvYcCUx4o2C4pG49haGMKITEYzeBoIBj/6u1HJpjmO10+JFMO7AYazRzjzHn5bJlTDBvqrQD0U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyw2imQkg54Pf2gltR6y0eHm2P7DOHcb/hNEKX+6BtFwnj7QgYc
	y+X9wAV7CPnLD7sPij86pR2eo6/XvXDgNCey/5ylaeU4IKXH2grUIqv3c4VWxFjsfmlAcZA+t8d
	FPQ==
X-Google-Smtp-Source: AGHT+IFE06cZ1NoWP7OdXrOVjn1iSfUQVuTaoIxS0U6rhpG7UHzQY7xIVXmyFZZ8hLEzC/JwVgNzDqN73LU=
X-Received: from pgbgb2.prod.google.com ([2002:a05:6a02:4b42:b0:86d:55d8:7944])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:8429:b0:1e1:e2d9:7f0a
 with SMTP id adf61e73a8af0-1eb2156f917mr659097637.34.1737067994607; Thu, 16
 Jan 2025 14:53:14 -0800 (PST)
Date: Thu, 16 Jan 2025 14:53:13 -0800
In-Reply-To: <a957a662-b4b9-4104-9aea-d3bfb0bb7449@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240910200350.264245-1-mlevitsk@redhat.com> <20240910200350.264245-4-mlevitsk@redhat.com>
 <9ff2be87-117a-4f96-af3b-dacb55467449@redhat.com> <4c1c999c29809c683cc79bc8c77cbe5d7eca37b7.camel@redhat.com>
 <a957a662-b4b9-4104-9aea-d3bfb0bb7449@redhat.com>
Message-ID: <Z4mN2Skhp1lQwrYw@google.com>
Subject: Re: [PATCH v5 3/3] KVM: x86: add new nested vmexit tracepoints
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, x86@kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 19, 2024, Paolo Bonzini wrote:
> On 12/19/24 18:49, Maxim Levitsky wrote:
> > > Here I probably would have preferred an unconditional tracepoint giving
> > > RAX/RBX/RCX/RDX after a nested vmexit.  This is not exactly what Sean
> > > wanted but perhaps it strikes a middle ground?  I know you wrote this
> > > for a debugging tool, do you really need to have everything in a single
> > > tracepoint, or can you correlate the existing exit tracepoint with this
> > > hypothetical trace_kvm_nested_exit_regs, to pick RDMSR vs. WRMSR?
> > 
> > Hi!
> > 
> > If the new trace_kvm_nested_exit_regs tracepoint has a VM exit number
> > argument, then I can enable this new tracepoint twice with a different
> > filter (vm_exit_num number == msr and vm_exit_num == vmcall), and each
> > instance will count the events that I need.
> > 
> > So this can work.
> Ok, thanks.  On one hand it may make sense to have trace_kvm_exit_regs and
> trace_kvm_nested_exit_regs (you can even extend the TRACE_EVENT_KVM_EXIT
> macro to generate both the exit and the exit_regs tracepoint).  On the other
> hand it seems to me that this new tracepoint is kinda reinventing the wheel;
> your patch adding nested equivalents of trace_kvm_hypercall and
> trace_kvm_msr seems more obvious to me.
> 
> I see Sean's point in not wanting one-off tracepoints, on the other hand
> there is value in having similar tracepoints for the L1->L0 and L2->L0
> cases.

I don't understand why we want two (or three, or five) tracepoints for the same
thing.  I want to go the opposite direction and (a) delete kvm_nested_vmexit
and then (b) rename kvm_nested_vmexit_inject => kvm_nested_vmexit so that it
pairs with kvm_nested_vmenter.

Similary, having kvm_nested_intr_vmexit is asinine when kvm_nested_vmexit_inject
captures *more* information about the IRQ itself.

I don't see the point of trace_kvm_nested_exit_regs.  Except for L1 vs. L2, it's
redundant.   kvm_nested_vmexit_inject and kvm_nested_vmenter are useful because
they capture novel information.

> I'll let him choose between the two possibilities (a new *_exit_regs
> pair, or just apply this patch) but I think there should be one of these
> two.

Anything but a pair.  Why can't we capture L1 vs. L2 in the tracepoints and call
it a day?

