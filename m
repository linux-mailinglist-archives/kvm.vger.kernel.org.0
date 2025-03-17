Return-Path: <kvm+bounces-41221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D3DBA64D0C
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 12:40:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AA9F168CBC
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 11:40:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B54172376EC;
	Mon, 17 Mar 2025 11:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xNwkT5GX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA9A19E966
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 11:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742211637; cv=none; b=hQY/+yxfJ5Of5suMvSSjkq+AtPad3dxWWrfqrZ5BwbYxmc9j2512WwuZvmtmugkXJi6l+6CqspzBL4H32OU+sVxhKqHsn0xpYY5/kSmI25nJdRr/aYVm2B4Jey5+s11IXgxLmjDRaiRTKTfqiwusklB5o7VUWVdAIbBaxpgBHLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742211637; c=relaxed/simple;
	bh=UVyXwPT+0dzoPtLhFGXpu4aEN0ofZJQd3YIKHnKn0WI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LoTPugDG12De1rnOgcSPKJD8CkPIc7u6FXd5nEG6STVMs1pnqrzXIfFtQxJyxabsGk6TXX6AlmTUIUPMRPm3Hn6Xxb8o6pzwLL3SChUIb0QuP1Ainn4mgDKUbKPqJWjmgNLfu7B+c8Au/eE4Syutbus9sxmkpLThUwqZ0hgOJnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xNwkT5GX; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4393ee912e1so79815e9.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 04:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742211634; x=1742816434; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FalVw+9HFv8usCB4GiV4/uDmB1SN5pnYqD8s9pvUy4s=;
        b=xNwkT5GXSoTTe0I+hCytMBGZvCKvAbH8DowRVTUT60wp7ehS6mrAvj1zPHVQfxB/p7
         PfcKqtNaPYM6yThnh3Zy9BDP7uZId0iZwGdnyJXm/pHYvMt06s+8lpKSLwCNrRE6X1tN
         EioQeteOhAW2i42HPVHz09q1OwdDHD6aaTelL0fbN62zLbBqvLLUa/bCoOxNC5A5vXbl
         Fzo8wbJerrdjPqKfUSSpRie4B+/ZV13yD5bPSsRvZCRDxiaAQ91Rks4UH+Iw8VfAsyVN
         aySs3dqQfg4zxgTdQQF5Zg7DMjbRXOjmxDVJhBk3corOrvNMmCrqmFOqpSA6pHAykchV
         HLEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742211634; x=1742816434;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FalVw+9HFv8usCB4GiV4/uDmB1SN5pnYqD8s9pvUy4s=;
        b=u55uGNLphimeqRCM3dAX9m17bkA8OYNw3G/4VUfHH7KQwFYODBOCwV6E6jVJmvcVbq
         gvk5V1fIdJZ0z2aBLQKuFWIRB0ttvWbxobcHNdPVrv+dr+tpcbTl/rxNXOH3xYc36wYy
         xI4gx75TSZSzxoxqoaJmLEIa7OLbkeujIZzP8noHpX7GBdQzmNyiiwVP2XPvdLISRXlP
         n7H19d8EtBqK7EAjH2FSl6sT3qbrFFSrL6QQR42QCU4HXhChn6zIhmlqvKTMC6Ud8DOC
         18gOPHGJIdk1dWL5fHngo+YZ7blZRFRlmNnli+Wo+cDpIDLa5f6Rb+VGlZGT2PbgjTlb
         89BA==
X-Forwarded-Encrypted: i=1; AJvYcCXbu+9PeqvzrBv2cW/4Gq6GKKDA/ZSoZbPhuJecpzetW8W0UbjqdKNuG7hvCbXry6/bhLg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyY6RtWQWZo35p0VMJigYpvk8WuC7366dE6H08tIkzTl9q6zADV
	wKhIoZiKg8CHa7mhY7WdTaKRYnpBg/Bfir1vhOYs5buk5eCUFUCbNpBpqQQWww==
X-Gm-Gg: ASbGncubRJQeHQzKdNZoP+UEMk+GGg8UhM1z6gTN/pD8Q1xjkyxSV40SJxEeHv9JTxE
	6SyPMaUDvaBf9nPsW6aBtAUUkPpzEXu78YNovcJ0GzpTV3gjwJ0GtsKh6umOUOIiBMu39XlN92r
	Sem1U3n8gl3bOfddxpHLM9JJxJhnXZ3SvJofIeVYcxJcIe27UzrEt6dnAEhIqJ3AKvYigJQdk3t
	OFMFGlYuWUjfK2uLdiJWwacQcZfcUvIQvbasH+p/X79htubNrg38iw3VExgRO0rgi2L0s96kR13
	iyT55D3w+zlWY6wkI9NyqspZQevWITggudvQnfGjADh6knihvwRt4UOh5cLQuSwYOk42kLtIOBJ
	BqP33epU=
X-Google-Smtp-Source: AGHT+IHyBBjvD+KqyxoajH2zdtd9crPZu/jYPWUHhato2zeKlOirxmAMl0xdrx/qS0RPytQt4WJKiQ==
X-Received: by 2002:a05:600c:5cb:b0:439:961d:fc7d with SMTP id 5b1f17b1804b1-43d251f35edmr2861275e9.6.1742211634205;
        Mon, 17 Mar 2025 04:40:34 -0700 (PDT)
Received: from google.com (158.100.79.34.bc.googleusercontent.com. [34.79.100.158])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c888167bsm14681764f8f.45.2025.03.17.04.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 04:40:33 -0700 (PDT)
Date: Mon, 17 Mar 2025 11:40:29 +0000
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Junaid Shahid <junaids@google.com>, akpm@linux-foundation.org,
	dave.hansen@linux.intel.com, yosryahmed@google.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, peterz@infradead.org, seanjc@google.com,
	tglx@linutronix.de, x86@kernel.org
Subject: Re: [PATCH RFC v2 03/29] mm: asi: Introduce ASI core API
Message-ID: <Z9gKLdNm9p6qGACS@google.com>
References: <20250227120607.GPZ8BVL2762we1j3uE@fat_crate.local>
 <20250228084355.2061899-1-jackmanb@google.com>
 <20250314131419.GJZ9Qrq8scAtDyBUcg@fat_crate.local>
 <5aa114f7-3efb-4dab-8579-cb9af4abd3c0@google.com>
 <20250315123621.GCZ9V0RWGFapbQNL1w@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250315123621.GCZ9V0RWGFapbQNL1w@fat_crate.local>

On Sat, Mar 15, 2025 at 01:36:21PM +0100, Borislav Petkov wrote:
> On Fri, Mar 14, 2025 at 06:34:32PM -0700, Junaid Shahid wrote:
> > The reason this isn't a problem with the current asi_enter() is because
> > there the equivalent of asi_start_critical() happens _before_ the address
> > space switch. That ensures that even if an NMI arrives in the middle of
> > asi_enter(), the NMI epilog will switch to the restricted address space and
> > there is no window where an NMI (or any other interrupt/exception for that
> > matter) would result in going into vmenter with an unrestricted address
> > space.
> 
> Aha.
> 
> > So
> > 	asi_enter();
> > 	asi_start_critical();
> > 	vmenter();
> > 	asi_end_critical();
> > 
> > is broken as there is a problematic window between asi_enter() and
> > asi_start_critical() as Brendan pointed out.
> > 
> > However,
> > 	asi_start_critical();
> > 	asi_enter();
> > 	vmenter();
> > 	asi_end_critical();
> > 
> > would work perfectly fine.
> > 
> > Perhaps that might be the way to refactor the API?
> 
> Ok, let's see if I understand the API better now. And I'm using function names
> which say what they do:
> 
> I guess the flow and needed ingredients should be:
> 
> 	1. asi_lock() or asi_start() or whatnot which does that atomic switch
> 	   of asi target. That tells other code like the NMI glue where in the
> 	   asi context the CPU is so that glue code can know what to do on
> 	   return
> 
> 	2. asi_switch_address_space() - the expensive pagetables build and CR3
> 	   switch

(Not relevant to the present discussion but just taking a chance to
 add some colour: there are no pagetables to build here, they are ready
 to go - e.g. see my separate RFC from last week[0] on how the physmap
 could be managed.

 Also, it's perhaps worth noting that the CR3 write itself isn't
 expected to be the really expensive thing, in the general case we
 expect that to be dwarfed by the cost of the actual security
 mitigations - IBPB etc)

[0] https://lore.kernel.org/all/20250313-asi-page-alloc-v1-0-04972e046cea@google.com/

> 	3. asi_enter_critical_region() - this could be NOP but basically marks
> 	   the beginning of the CPU executing "unsafe" code
> 
> 		<... executes unsafe code... >
> 
> 	4. asi_exit_critical_region() - sets ASI target to NULL, i.e., what
> 	   asi_relax) does now. This also atomic and tells other code, we're
> 	   done with executing unsafe code but we're still running in the
> 	   restricted address space.
> 
> 	   This here can go back to 3 as often as needed.
> 
> 	5. asi_switch_address_space() - this goes back to the unrestricted
> 	   adddress space
> 
> 	6. asi_unlock()
> 
> Close?

I don't understand having both asi_[un]lock() _and_
asi_{start,enter}_critical_region(). The only reason we need the
critical section concept is for the purposes of the NMI glue code you
mentioned in part 1, and that setup must happen before the switch into
the restricted address space.

Also, I don't think we want part 5 inside the asi_lock()->asi_unlock()
region. That seems like the region betwen part 5 and 6, we are in the
unrestricted address space, but the NMI entry code is still set up to
return to the restricted address space on exception return. I think
that would actually be harmless, but it doesn't achieve anything.

The more I talk about it, the more convinced I am that the proper API
should only have two elements, one that says "I'm about to run
untrusted code" and one that says "I've finished running untrusted
code". But...

> 1. you can do empty calls to keep the interface balanced and easy to use
>
> 2. once you can remove asi_exit(), you should be able to replace all in-tree
>    users in one atomic change so that they're all switched to the new,
>    simplified interface

Then what about if we did this:

/* 
 * Begin a region where ASI restricted address spaces _may_ be used.
 *
 * Preemption must be off throughout this region.
 */
static inline void asi_start(void)
{
	/* 
	 * Cannot currently context switch in the restricted adddress
	 * space.
	 */
	lockdep_assert_preemption_disabled();

	/* 
	 * (Actually, this doesn't do anything besides assert, it's
	 * just to help the API make sense).
	 */
}

/*
 * End a region begun by asi_start(). After this, the CPU cannot be in
 * the restricted address space until the next asi_start(). 
 */
static inline void asi_end(void)
{
	/* Leave the restricted address space if we're in it. */
	...
}

/*
 * About to run untrusted code, begin a region that _must_ run in the
 * restricted address space.
 */
void asi_start_critical(void);

/* End a region begun by asi_start_critical(). */
void asi_end_critical(void);

ioctl(KVM_RUN) {
    enter_from_user_mode()
    asi_start()
    while !need_userspace_handling()
        asi_start_critical();
        vmenter();
        asi_end_critical();
    }
    asi_end()
    exit_to_user_mode()
}

Then the API is balanced, and we have a clear migration path towards
the two-element API, i.e. we need to just remove asi_start() and
asi_end(). It also better captures the point about the temporary
simplification: basically the reason why the API is currently
overcomplicated is: if totally arbitrary parts of the kernel can find
themselves in the restricted address space, we have more work to do.
(It's totally possible, but we don't wanna block initial submission on
that work). The simplification is about demarcating what code is and
isn't affected by ASI, so having this "region" kinda helps with that.
Although, because NMIs can also be affected it's a bit of a fuzzy
demarcation...

