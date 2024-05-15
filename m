Return-Path: <kvm+bounces-17417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B74528C5FC8
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 06:46:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFE151C220F0
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 04:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BE3639ADD;
	Wed, 15 May 2024 04:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="faMxyunc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29AF20314
	for <kvm@vger.kernel.org>; Wed, 15 May 2024 04:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715748359; cv=none; b=F7kPr8Kh7/y5CBvuuxKd54irCDZKec7SB3/mCOf7/HoJTKMK0OIsStPIYvkEX/eNfnhah/KYj/hQ/ndgSJBaEBCMQmhlt4YYl4HRJMzqYoMaWQPVXtDyB8htxoKPYRnrTDu1BEURrXv0oNlYO9zkGr+E6RNFYavTuiJsdTIWXEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715748359; c=relaxed/simple;
	bh=HEa6eZqnnTLKC7vECaVu6A1XoVWrmgsd1gOhdflAqDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=JWJ6P3qaSUVxcS1e0CV137ZPH80NBuaVcmIWHrAroccadbY8VAYK2sYQS+doSNE/X0/MDhM9ONOFS+3tmH/RAFnBbxFY4BTCHf2mMW16pgKu9EBy79MD5wI4/StEFrGk6nxGpEbfJc6Q7nRL5r/VddTSLJeIaaMjK2AoEa9sikA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=faMxyunc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715748356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HPDdnVnDLt4JFsPDNjCVl1qjYtj9SLA+tQ0OtYJYL+0=;
	b=faMxyuncKA6fCxjc+jBx0KQPGuS4DMdt79yQj9fUVIWHqmXR+828VtVMcf0L14ZhIJcc0q
	99hDaYvFYsWyUXxSMfmht6ulxFc17FPliuGXP9+SRcahCF8WRT7iCoK54HMgMVeE/d1suj
	yTTy+RfGKz/btqFrkwHhjlaJdKCkYxA=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-JMopVA3aNiybdU7jIbJc_g-1; Wed, 15 May 2024 00:45:54 -0400
X-MC-Unique: JMopVA3aNiybdU7jIbJc_g-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-6331e4c809fso5960496a12.2
        for <kvm@vger.kernel.org>; Tue, 14 May 2024 21:45:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715748354; x=1716353154;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HPDdnVnDLt4JFsPDNjCVl1qjYtj9SLA+tQ0OtYJYL+0=;
        b=giyP4Vsapu1mUIpBgs7iSZcssQ0FmJK6j25uapZ8eGKkWaA8tmW/LGA2Gb/3RdTznb
         B8VyLt3INqFUvz2ER2Hk8nJajKTkNGBWaVJkK82HpWi22A8vZ7DY0SILb/AaAtc30kyX
         5W60Bk/IuzAGXg/t211HMx/JCW1RyiEoH82VgWyifHTbH3Go6RCykr4jl2VhoF7cjfWQ
         L5vf5JcQwA6epPftHSacVQaPq7LJ+Wtmi6oc43UhNCBwKztZdPRfx6Zq0BV4yU5EUvqc
         iRvj9Gu/Ke2Fy6pWojXddHe4qvExUitf68PR5TgttZZf0JQ/6kT4G1Uptx5692G0OUWV
         FO1A==
X-Forwarded-Encrypted: i=1; AJvYcCWkiOKXL+gr1yxZRPhvyFrh95CWJfMLraqq/HTN88uamxMjBoDmO11C5q/e+uv8RVGOdywU8UYHB8bqqAG5/6cUgdv/
X-Gm-Message-State: AOJu0YyWDe1+bLgIo2MYV7Q1zFEX7iaFSc9cTbHU4gf2I2CpM4Mzz1Nb
	aVEVoaZYMU/xkxN4dVKe9XP6c2bivMrfGUfFePBa7THsVfN1I80rebtnV45eAbGoo+TXBdq1mR1
	DRX+osJdbYbdBcxf0hsEJ9i/+GYEPZ7nDxZyjqmZ7NeQLKuPKDA==
X-Received: by 2002:a05:6a20:de91:b0:1af:cc9d:23af with SMTP id adf61e73a8af0-1afde1c5e0emr12058865637.57.1715748353626;
        Tue, 14 May 2024 21:45:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEgUhxoUoTbNkv5Cc30YdIoTivGz44dLy1qnK/N4egIwhfMFnKm1S+Iyt9S7QpvA0RUAEwidg==
X-Received: by 2002:a05:6a20:de91:b0:1af:cc9d:23af with SMTP id adf61e73a8af0-1afde1c5e0emr12058849637.57.1715748353122;
        Tue, 14 May 2024 21:45:53 -0700 (PDT)
Received: from localhost.localdomain ([2804:1b3:a800:a9e8:e01f:c640:3398:ffe5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b628ca5117sm12547700a91.40.2024.05.14.21.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 21:45:52 -0700 (PDT)
From: Leonardo Bras <leobras@redhat.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Leonardo Bras <leobras@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] kvm: Note an RCU quiescent state on guest exit
Date: Wed, 15 May 2024 01:45:33 -0300
Message-ID: <ZkQ97QcEw34aYOB1@LeoBras>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <68c39823-6b1d-4368-bd1e-a521ade8889b@paulmck-laptop>
References: <20240511020557.1198200-1-leobras@redhat.com> <ZkJsvTH3Nye-TGVa@google.com> <CAJ6HWG7pgMu7sAUPykFPtsDfq5Kfh1WecRcgN5wpKQj_EyrbJA@mail.gmail.com> <68c39823-6b1d-4368-bd1e-a521ade8889b@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, May 14, 2024 at 03:54:16PM -0700, Paul E. McKenney wrote:
> On Mon, May 13, 2024 at 06:47:13PM -0300, Leonardo Bras Soares Passos wrote:
> > On Mon, May 13, 2024 at 4:40 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Fri, May 10, 2024, Leonardo Bras wrote:
> > > > As of today, KVM notes a quiescent state only in guest entry, which is good
> > > > as it avoids the guest being interrupted for current RCU operations.
> > > >
> > > > While the guest vcpu runs, it can be interrupted by a timer IRQ that will
> > > > check for any RCU operations waiting for this CPU. In case there are any of
> > > > such, it invokes rcu_core() in order to sched-out the current thread and
> > > > note a quiescent state.
> > > >
> > > > This occasional schedule work will introduce tens of microsseconds of
> > > > latency, which is really bad for vcpus running latency-sensitive
> > > > applications, such as real-time workloads.
> > > >
> > > > So, note a quiescent state in guest exit, so the interrupted guests is able
> > > > to deal with any pending RCU operations before being required to invoke
> > > > rcu_core(), and thus avoid the overhead of related scheduler work.
> > >
> > > Are there any downsides to this?  E.g. extra latency or anything?  KVM will note
> > > a context switch on the next VM-Enter, so even if there is extra latency or
> > > something, KVM will eventually take the hit in the common case no matter what.
> > > But I know some setups are sensitive to handling select VM-Exits as soon as possible.
> > >
> > > I ask mainly because it seems like a no brainer to me to have both VM-Entry and
> > > VM-Exit note the context switch, which begs the question of why KVM isn't already
> > > doing that.  I assume it was just oversight when commit 126a6a542446 ("kvm,rcu,nohz:
> > > use RCU extended quiescent state when running KVM guest") handled the VM-Entry
> > > case?
> > 
> > I don't know, by the lore I see it happening in guest entry since the
> > first time it was introduced at
> > https://lore.kernel.org/all/1423167832-17609-5-git-send-email-riel@redhat.com/
> > 
> > Noting a quiescent state is cheap, but it may cost a few accesses to
> > possibly non-local cachelines. (Not an expert in this, Paul please let
> > me know if I got it wrong).
> 
> Yes, it is cheap, especially if interrupts are already disabled.
> (As in the scheduler asks RCU to do the same amount of work on its
> context-switch fastpath.)

Thanks!

> 
> > I don't have a historic context on why it was just implemented on
> > guest_entry, but it would make sense when we don't worry about latency
> > to take the entry-only approach:
> > - It saves the overhead of calling rcu_virt_note_context_switch()
> > twice per guest entry in the loop
> > - KVM will probably run guest entry soon after guest exit (in loop),
> > so there is no need to run it twice
> > - Eventually running rcu_core() may be cheaper than noting quiescent
> > state every guest entry/exit cycle
> > 
> > Upsides of the new strategy:
> > - Noting a quiescent state in guest exit avoids calling rcu_core() if
> > there was a grace period request while guest was running, and timer
> > interrupt hits the cpu.
> > - If the loop re-enter quickly there is a high chance that guest
> > entry's rcu_virt_note_context_switch() will be fast (local cacheline)
> > as there is low probability of a grace period request happening
> > between exit & re-entry.
> > - It allows us to use the rcu patience strategy to avoid rcu_core()
> > running if any grace period request happens between guest exit and
> > guest re-entry, which is very important for low latency workloads
> > running on guests as it reduces maximum latency in long runs.
> > 
> > What do you think?
> 
> Try both on the workload of interest with appropriate tracing and
> see what happens?  The hardware's opinion overrides mine.  ;-)

That's a great approach!

But in this case I think noting a quiescent state in guest exit is 
necessary to avoid a scenario in which a VM takes longer than RCU 
patience, and it ends up running rcuc in a nohz_full cpu, even if guest 
exit was quite brief. 

IIUC Sean's question is more on the tone of "Why KVM does not note a 
quiescent state in guest exit already, if it does in guest entry", and I 
just came with a few arguments to try finding a possible rationale, since 
I could find no discussion on that topic in the lore for the original 
commit.

Since noting a quiescent state in guest exit is cheap enough, avoids rcuc 
schedules when grace period starts during guest execution, and enables a 
much more rational usage of RCU patience, it's a safe to assume it's a 
better way of dealing with RCU compared to current implementation.

Sean, what do you think?

Thanks!
Leo

> 
> 							Thanx, Paul
> 


