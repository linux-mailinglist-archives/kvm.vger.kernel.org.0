Return-Path: <kvm+bounces-17466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 529468C6D77
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 23:04:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3A21284560
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 21:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99F0A15B11D;
	Wed, 15 May 2024 21:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Er4iSXq+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4576D158DD8
	for <kvm@vger.kernel.org>; Wed, 15 May 2024 21:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715807038; cv=none; b=hlFaBwB/189xWl8SHErhFElV8kgMlvnJgM+BFqPXFAiws6p8Yl7GruNgRYFKZl+LMLtZDHMjjSBGYFcWIgKJcG61ES2DIe1R/Ed2QJkBQgMsqmGrgeMQHfYUEGFMo2q45Wcmt8dbnO3BZ2oHc62hbRdECYM89MgHUZXla+fHDp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715807038; c=relaxed/simple;
	bh=v4fYS1RN+A3001h4gPdRNP37c1LHlJOy58nJtSXM+iI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rWfE8VeRHTYHof4B+zq+Em/JqEC18dVs7dDCmUNl5UscGlj/6aEC3/snjSSyO4NrTR6J0TnGyIY9qkb0UGDFzm05/2YNsxXeiZmWtq7augT6/+K4Bb2fluiTVkZrtN7uG3+Sq84qpMxNbQqlQTUOSGBJzNSLQ0IAEa3Vh7ftCWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Er4iSXq+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715807034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y1f1v8XJYpAEVpbxVbnSTDiAhuB4qr2c5YdAEr2f08Q=;
	b=Er4iSXq+LdCZRvSuG6FAs2JM4EtIfN2AQMOegWQ6UGR9+09hmjC+Zp/xux0mCM+tSqrzho
	xpJwRoQZZrQKtfYepNWBMiZRzYYitopeuK4OFaCQeME+V6G28dBFvimYEJ268CntyDcEe9
	nzFS+8wqujejX0bkVAVBbfdJtAy6xlY=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-bRBeQGxvN9KbEjVh5HlZZw-1; Wed, 15 May 2024 17:03:37 -0400
X-MC-Unique: bRBeQGxvN9KbEjVh5HlZZw-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-622d157d9fbso69342427b3.0
        for <kvm@vger.kernel.org>; Wed, 15 May 2024 14:03:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715807017; x=1716411817;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y1f1v8XJYpAEVpbxVbnSTDiAhuB4qr2c5YdAEr2f08Q=;
        b=PU+ezvmnwAT3p5vyM41AJpMYXgQL5SDPmO0sp+YQrxClbJmSk2GJq/wrx69fzATcCP
         MqRvP6Eejwy9a7hW/VD/NXYfhxPQQDRWrCW5keG79ro3Zb/StQjUlb0REHiXyhs5Rpor
         eI2g5JQqrTYtpQxN3Ja14lc6+gcbxLDagkGoZPMvTKqhWNrW7uYxD/ECWWf6G0arJHtb
         onpx6YM5QUOxQL53+lU4R8wkLGW8pADIJujH+3zBRYvBOwsy1I9ZglxAeOUgDO9eNGR3
         9RhPBd+s9wbA/O0btrnNeCSUrQOZWOViFBoe+YVpj7zkcTRSMdexLNaHc815lB69TM6D
         /nQg==
X-Gm-Message-State: AOJu0YzHuxzXH/0YY5iSLw4DlbuaF3ixPe+plgyqzI24UtcWS6TIF8EI
	KvDM5NtbuKFWI0RoxQ5yNZlhjuwRkj+OOYeX0ZD8DzoSyJJDVfPZYpUvJtfXVyHUw98/1Y+NKv9
	Eb0gjMdGwA5flybrVRg4hhvRT7DEXq8po8u94BimmnSDyv96iNQ==
X-Received: by 2002:a81:9149:0:b0:61b:418:139 with SMTP id 00721157ae682-622afff635bmr156633877b3.27.1715807016658;
        Wed, 15 May 2024 14:03:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHry4v9XZCuzTQKM54tgzIGwvbMt/qrmc7oNguw8imoK5prI9zSyKZLvps3MKzQWTP496n6PA==
X-Received: by 2002:a81:9149:0:b0:61b:418:139 with SMTP id 00721157ae682-622afff635bmr156633557b3.27.1715807016205;
        Wed, 15 May 2024 14:03:36 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43df56b1651sm86999151cf.76.2024.05.15.14.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 May 2024 14:03:35 -0700 (PDT)
Message-ID: <7cb1aec718178ee9effe1017dad2ef7ab8b2a714.camel@redhat.com>
Subject: Re: RFC: NTP adjustments interfere with KVM emulation of TSC
 deadline timers
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Paolo Bonzini
 <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Marc
 Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vitaly
 Kuznetsov <vkuznets@redhat.com>
Date: Wed, 15 May 2024 17:03:34 -0400
In-Reply-To: <CALMp9eQcRF_oS2rc_xF1H3=pfHB7ggts44obZgvh-K03UYJLSQ@mail.gmail.com>
References: <20c9c21619aa44363c2c7503db1581cb816a1c0f.camel@redhat.com>
	 <CALMp9eSy2r+iUzqHV+V2mbPaPWfn=Y=a1aM+9C65PGtE0=nGqA@mail.gmail.com>
	 <481be19e33915804c855a55181c310dd8071b546.camel@redhat.com>
	 <CALMp9eQcRF_oS2rc_xF1H3=pfHB7ggts44obZgvh-K03UYJLSQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 2024-01-02 at 15:49 -0800, Jim Mattson wrote:
> On Tue, Jan 2, 2024 at 2:21 PM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > On Thu, 2023-12-21 at 11:09 -0800, Jim Mattson wrote:
> > > On Thu, Dec 21, 2023 at 8:52 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > > > Hi!
> > > > 
> > > > Recently I was tasked with triage of the failures of 'vmx_preemption_timer'
> > > > that happen in our kernel CI pipeline.
> > > > 
> > > > 
> > > > The test usually fails because L2 observes TSC after the
> > > > preemption timer deadline, before the VM exit happens.
> > > > 
> > > > This happens because KVM emulates nested preemption timer with HR timers,
> > > > so it converts the preemption timer value to nanoseconds, taking in account
> > > > tsc scaling and host tsc frequency, and sets HR timer.
> > > > 
> > > > HR timer however as I found out the hard way is bound to CLOCK_MONOTONIC,
> > > > and thus its rate can be adjusted by NTP, which means that it can run slower or
> > > > faster than KVM expects, which can result in the interrupt arriving earlier,
> > > > or late, which is what is happening.
> > > > 
> > > > This is how you can reproduce it on an Intel machine:
> > > > 
> > > > 
> > > > 1. stop the NTP daemon:
> > > >       sudo systemctl stop chronyd.service
> > > > 2. introduce a small error in the system time:
> > > >       sudo date -s "$(date)"
> > > > 
> > > > 3. start NTP daemon:
> > > >       sudo chronyd -d -n  (for debug) or start the systemd service again
> > > > 
> > > > 4. run the vmx_preemption_timer test a few times until it fails:
> > > > 
> > > > 
> > > > I did some research and it looks like I am not the first to encounter this:
> > > > 
> > > > From the ARM side there was an attempt to support CLOCK_MONOTONIC_RAW with
> > > > timer subsystem which was even merged but then reverted due to issues:
> > > > 
> > > > https://lore.kernel.org/all/1452879670-16133-3-git-send-email-marc.zyngier@arm.com/T/#u
> > > > 
> > > > It looks like this issue was later worked around in the ARM code:
> > > > 
> > > > 
> > > > commit 1c5631c73fc2261a5df64a72c155cb53dcdc0c45
> > > > Author: Marc Zyngier <maz@kernel.org>
> > > > Date:   Wed Apr 6 09:37:22 2016 +0100
> > > > 
> > > >     KVM: arm/arm64: Handle forward time correction gracefully
> > > > 
> > > >     On a host that runs NTP, corrections can have a direct impact on
> > > >     the background timer that we program on the behalf of a vcpu.
> > > > 
> > > >     In particular, NTP performing a forward correction will result in
> > > >     a timer expiring sooner than expected from a guest point of view.
> > > >     Not a big deal, we kick the vcpu anyway.
> > > > 
> > > >     But on wake-up, the vcpu thread is going to perform a check to
> > > >     find out whether or not it should block. And at that point, the
> > > >     timer check is going to say "timer has not expired yet, go back
> > > >     to sleep". This results in the timer event being lost forever.
> > > > 
> > > >     There are multiple ways to handle this. One would be record that
> > > >     the timer has expired and let kvm_cpu_has_pending_timer return
> > > >     true in that case, but that would be fairly invasive. Another is
> > > >     to check for the "short sleep" condition in the hrtimer callback,
> > > >     and restart the timer for the remaining time when the condition
> > > >     is detected.
> > > > 
> > > >     This patch implements the latter, with a bit of refactoring in
> > > >     order to avoid too much code duplication.
> > > > 
> > > >     Cc: <stable@vger.kernel.org>
> > > >     Reported-by: Alexander Graf <agraf@suse.de>
> > > >     Reviewed-by: Alexander Graf <agraf@suse.de>
> > > >     Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > > >     Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > > > 
> > > > 
> > > > So to solve this issue there are two options:
> > > > 
> > > > 
> > > > 1. Have another go at implementing support for CLOCK_MONOTONIC_RAW timers.
> > > >    I don't know if that is feasible and I would be very happy to hear a feedback from you.
> > > > 
> > > > 2. Also work this around in KVM. KVM does listen to changes in the timekeeping system
> > > >   (kernel calls its update_pvclock_gtod), and it even notes rates of both regular and raw clocks.
> > > > 
> > > >   When starting a HR timer I can adjust its period for the difference in rates, which will in most
> > > >   cases produce more correct result that what we have now, but will still fail if the rate
> > > >   is changed at the same time the timer is started or before it expires.
> > > > 
> > > >   Or I can also restart the timer, although that might cause more harm than
> > > >   good to the accuracy.
> > > > 
> > > > 
> > > > What do you think?
> > > 
> > > Is this what the "adaptive tuning" in the local APIC TSC_DEADLINE
> > > timer is all about (lapic_timer_advance_ns = -1)?
> > 
> > Hi,
> > 
> > I don't think that 'lapic_timer_advance' is designed for that but it does
> > mask this problem somewhat.
> > 
> > The goal of 'lapic_timer_advance' is to decrease time between deadline passing and start
> > of guest timer irq routine by making the deadline happen a bit earlier (by timer_advance_ns), and then busy-waiting
> > (hopefully only a bit) until the deadline passes, and then immediately do the VM entry.
> > 
> > This way instead of overhead of VM exit and VM entry that both happen after the deadline,
> > only the VM entry happens after the deadline.
> > 
> > 
> > In relation to NTP interference: If the deadline happens earlier than expected, then
> > KVM will busy wait and decrease the 'timer_advance_ns', and next time the deadline
> > will happen a bit later thus adopting for the NTP adjustment somewhat.
> > 
> > Note though that 'timer_advance_ns' variable is unsigned and adjust_lapic_timer_advance can underflow
> > it, which can be fixed.
> > 
> > Now if the deadline happens later than expected, then the guest will see this happen,
> > but at least adjust_lapic_timer_advance should increase the 'timer_advance_ns' so next
> > time the deadline will happen earlier which will also eventually hide the problem.
> > 
> > So overall I do think that implementing the 'lapic_timer_advance' for nested VMX preemption timer
> > is a good idea, especially since this feature is not really nested in some sense - the timer is
> > just delivered as a VM exit but it is always delivered to L1, so VMX preemption timer can
> > be seen as just an extra L1's deadline timer.
> > 
> > I do think that nested VMX preemption timer should use its own value of timer_advance_ns, thus
> > we need to extract the common code and make both timers use it. Does this make sense?
> 
> Alternatively, why not just use the hardware VMX-preemption timer to
> deliver the virtual VMX-preemption timer?
> 
> Today, I believe that we only use the hardware VMX-preemption timer to
> deliver the virtual local APIC timer. However, it shouldn't be that
> hard to pick the first deadline of {VMX-preemption timer, local APIC
> timer} at each emulated VM-entry to L2.

I assume that this is possible but it might add some complexity.

AFAIK the design choice here was that L1 uses the hardware VMX preemption timer always,
while L2 uses the software preemption timer which is relatively simple.

I do agree that this might work and if it does work it might be even worthwhile
change on its own.

If you agree that this is a good idea, I can prepare a patch series for that.

Note though that the same problem (although somewhat masked by lapic_timer_advance)
does exit on AMD as well because while AMD lacks both VMX preemption timer and even the TSC deadline timer,
KVM exposes TSC deadline to the guest, and HR timers are always used for its emulation,
and are prone to NTP interference as I discovered.

Best regards,
	Maxim Levitsky

> 
> > Best regards,
> >         Maxim Levitsky
> > 
> > 
> > >  If so, can we
> > > leverage that for the VMX-preemption timer as well?
> > > > Best regards,
> > > >         Maxim Levitsky
> > > > 
> > > > 
> > > > 
> > 
> > 
> > 





