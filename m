Return-Path: <kvm+bounces-17347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C8BC8C4775
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 21:24:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 18F84B20A15
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 19:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74D6452F6A;
	Mon, 13 May 2024 19:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="STOFMvFd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE851BDD0
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 19:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715628259; cv=none; b=hBUBEa9NMUSroeJ6pJrn6hbphZWNty6bw3P5TehKl0Pr3sD/66TAvIOkYip2XeVWT/nKwc5W5Tn3WFDiwUVwb39kvMP2jB10ZTAj0NDMwEWWkBNSWARSgJvlbf0OUF/j3wUAedHlTcapQHXlwlD8EIZ71op7VrOypHiGs1oMlTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715628259; c=relaxed/simple;
	bh=5N15qcryEo41N2/C4GG6RzQY4PJ2O8cJAktjHr+5acU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A/gsGXYepw+Hthyaayqu6pCqx4tAiZCMAyCEpK/nk1RgyUYNP1k3PMcL7kky5SiQEi8Qa9gyPEtKVSHpKOAHve728aY3lNDqedGkvUrHm2jN82V35f7IOw5ZAc7zVgeTFdog8UzQeYbWq6BRHh19luP8IYKavmdnLDCl8GfitEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=STOFMvFd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715628257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=es+FVsqPWUNIRpUuG3Q0WLOBQbEEWGORQ4d1y6RL/uI=;
	b=STOFMvFdOFzXikKgg2GMjZglNkfluCmvlQeTimpm/MFczGuZoTQVSjTpCeJk21PoPJwIBV
	esFBFfb4TSg8JMaGdT6DhlQqPccUNfNaPOzUH6zgFa2p1sR9lpvCV9HNOCYFpjQqmZPRZe
	l9l14yUwcg8ZxnRMWseSBlRDFCZ8oWc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-691-IhuntFJkPiuuUjT2CZHgqA-1; Mon,
 13 May 2024 15:14:21 -0400
X-MC-Unique: IhuntFJkPiuuUjT2CZHgqA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92A5E380009A;
	Mon, 13 May 2024 19:14:20 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.8])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C255200B4D8;
	Mon, 13 May 2024 19:14:20 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 7C663400E4E82; Mon, 13 May 2024 16:14:03 -0300 (-03)
Date: Mon, 13 May 2024 16:14:03 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Leonardo Bras <leobras@redhat.com>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] kvm: Note an RCU quiescent state on guest exit
Message-ID: <ZkJme7kRGGNdxwnb@tpad>
References: <20240511020557.1198200-1-leobras@redhat.com>
 <ZkE4N1X0wglygt75@tpad>
 <ZkGFmISfnrKNrUgj@LeoBras>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZkGFmISfnrKNrUgj@LeoBras>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

On Mon, May 13, 2024 at 12:14:32AM -0300, Leonardo Bras wrote:
> On Sun, May 12, 2024 at 06:44:23PM -0300, Marcelo Tosatti wrote:
> > On Fri, May 10, 2024 at 11:05:56PM -0300, Leonardo Bras wrote:
> > > As of today, KVM notes a quiescent state only in guest entry, which is good
> > > as it avoids the guest being interrupted for current RCU operations.
> > > 
> > > While the guest vcpu runs, it can be interrupted by a timer IRQ that will
> > > check for any RCU operations waiting for this CPU. In case there are any of
> > > such, it invokes rcu_core() in order to sched-out the current thread and
> > > note a quiescent state.
> > > 
> > > This occasional schedule work will introduce tens of microsseconds of
> > > latency, which is really bad for vcpus running latency-sensitive
> > > applications, such as real-time workloads.
> > > 
> > > So, note a quiescent state in guest exit, so the interrupted guests is able
> > > to deal with any pending RCU operations before being required to invoke
> > > rcu_core(), and thus avoid the overhead of related scheduler work.
> > 
> > This does not properly fix the current problem, as RCU work might be
> > scheduled after the VM exit, followed by a timer interrupt.
> > 
> > Correct?
> 
> Correct, for this case, check the note below:
> 
> > 
> > > 
> > > Signed-off-by: Leonardo Bras <leobras@redhat.com>
> > > ---
> > > 
> > > ps: A patch fixing this same issue was discussed in this thread:
> > > https://lore.kernel.org/all/20240328171949.743211-1-leobras@redhat.com/
> > > 
> > > Also, this can be paired with a new RCU option (rcutree.nocb_patience_delay)
> > > to avoid having invoke_rcu() being called on grace-periods starting between
> > > guest exit and the timer IRQ. This RCU option is being discussed in a
> > > sub-thread of this message:
> > > https://lore.kernel.org/all/5fd66909-1250-4a91-aa71-93cb36ed4ad5@paulmck-laptop/
> 
> ^ This one above.
> The idea is to use this rcutree.nocb_patience_delay=N :
> a new option we added on RCU that allow us to avoid invoking rcu_core() if 
> the grace_period < N miliseconds. This only works on nohz_full cpus.
> 
> So with both the current patch and the one in above link, we have the same 
> effect as we previously had with last_guest_exit, with a cherry on top: we 
> can avoid rcu_core() getting called in situations where a grace period just 
> started after going into kernel code, and a timer interrupt happened before 
> it can report quiescent state again. 
> 
> For our nohz_full vcpu thread scenario, we have:
> 
> - guest_exit note a quiescent state
> - let's say we start a grace period in the next cycle
> - If timer interrupts, it requires the grace period to be older than N 
>   miliseconds
>   - If we configure a proper value for patience, it will never reach the 
>     end of patience before going guest_entry, and thus noting a quiescent 
>     state
> 
> What do you think?

I don't fully understand all of the RCU details, but since RCU quiescent
state marking happens in IRQ disabled section, there is no chance for a
timer interrupt to conflict with the marking of quiescent state.

So seem to make sense to me.


