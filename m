Return-Path: <kvm+bounces-61965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A57E7C30A04
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 11:59:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6A2C1898708
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 10:59:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCAC52DCF7C;
	Tue,  4 Nov 2025 10:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2I40uPMh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA552D7DDC
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 10:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762253915; cv=none; b=VpVceDdROeYoDlPkL0HV+AmsS4HvWGm0zoluHW3sh6zp7OqJReH5afVzuk6WQ5BUXhmiM2JjqCYFPb761N3+SbW/bc8l5z2weaYC4BH4v8x2NHhf4Xi/Lrsiu0PGhD5d9IkPtnBfQD4GANPd+QUaaXjxIQbIiqHRb7QAXKO6VFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762253915; c=relaxed/simple;
	bh=HebYm8EAvsOzjr9XU4T4GHJnyvzUoA5HYP0IjjAFdrs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pLbk3TuMDiU6Ds1v7qhnFcCWItlel5HqhgmAI3Z8PxteK4Ke8IAUsz+4sUMDR62Y7URYzg1eZPNs6UCZLv66lmwLX3nwU29jxTM/48JoRMnmG6/gbhEkeWBa5pOZGrsA3cPIYRmP2n9qvWOOqWKjlWTXIzqqHGTA0c2we+jcr2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2I40uPMh; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4711899ab0aso46916515e9.2
        for <kvm@vger.kernel.org>; Tue, 04 Nov 2025 02:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762253912; x=1762858712; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pXdSXfonp+4CltEbCxtU0GySzoIYQXalOg00fKevaG4=;
        b=2I40uPMhKCAn/izP1xpz/NFgJgjex7miYlbjeY8bsb/JRzLNBZCUGW4hi4bzebWChB
         c/PaA7ovqeyiGu2dnuSqKwiG4FwfITsw4544KNl1KUE1BkZ6nZ/rEKPdWni+a/4ZDdLJ
         nn3vcZaVWShpbpUCEj4twev6aO67n9OSChKn4qpPxPcG60qA+luvQy55le1wul7WZLCw
         MNsRi9GSMAbv7y4SQwyJHnfjOfCYXhWCTZDhbns9j3dIiv5ET/GWZl9HogGr1WqDJAuB
         mC+8l3z3XeFJ1Nd9fLq2XDLpD9eRR3x/GJQf1EkN+WDxGFOjuyk/a94dK858QK9KqN67
         /1EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762253912; x=1762858712;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pXdSXfonp+4CltEbCxtU0GySzoIYQXalOg00fKevaG4=;
        b=X/zpz7GO5w3RWY0nPY0aqdVzr4ORTR8jnM/3WtsmMxoBMKHjyafEbJn9G+ZTqWQzDw
         6DAicS2gSFmk5zXUP8fWz7wCoJ10RDwfVgWwsqkSZdJ9+eBdOKFeETHe8OYZUo6u6Oie
         vkts4UIDmoq+vsdYBDkSV+qSmMCmHuD/hyCTYxOTDDNHWFzEV16wbr6HzhID/7EPHgsb
         iWcD7PRZ2WTGsiral6x+smU4JI3s9MyhIRM9YOz5ietscnv/hAq9W9Z2qE/CExJdqWSM
         wXkMi9EKGuTuDCFCuYtA7OxgsvDwMgfGPCIcx02T7zB5OZV+RWdustNiKyPFXh1FxNZV
         EmUg==
X-Forwarded-Encrypted: i=1; AJvYcCUwlKBpHISyvW1fc/KRaT2e9bOw30/9c+e8qA6JvnnHqVzegOpg0JoC9wrSX1MEfORkkQI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJYlYSwWVAV8cqy4z2jk/bzKHyiBQ5oayCH+98AxkOTfejBC6i
	To/F3blyR381tZOIPGM4E7RmKu14w21QOAvOUfmdKMtAs6nulZtWF2MmXgs9AGOLFHLMS6JNou4
	2aZFXx2Sc2HpLDA==
X-Google-Smtp-Source: AGHT+IEYDP8U8LOXUhrV8oDGXEGv0k+9QmdOSaBd1lOaxKTOjACdUZ0JcpAc103+appImu7sgQgXz136HUJEaA==
X-Received: from wmfv3.prod.google.com ([2002:a05:600c:15c3:b0:477:561f:772c])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4ece:b0:46f:b42e:e367 with SMTP id 5b1f17b1804b1-477308cc556mr150001265e9.41.1762253912727;
 Tue, 04 Nov 2025 02:58:32 -0800 (PST)
Date: Tue, 04 Nov 2025 10:58:32 +0000
In-Reply-To: <aQTzlivZDrT_tZRL@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031003040.3491385-1-seanjc@google.com> <DDWGVW5SJQ4S.3KBFOQPJQWLLK@google.com>
 <aQTzlivZDrT_tZRL@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDZUVIZWOH60.30WAV3ER8RPTT@google.com>
Subject: Re: [PATCH v4 0/8] x86/bugs: KVM: L1TF and MMIO Stale Data cleanups
From: Brendan Jackman <jackmanb@google.com>
To: Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

On Fri Oct 31, 2025 at 5:36 PM UTC, Sean Christopherson wrote:
> On Fri, Oct 31, 2025, Brendan Jackman wrote:
>> On Fri Oct 31, 2025 at 12:30 AM UTC, Sean Christopherson wrote:
>> > This is a combination of Brendan's work to unify the L1TF L1D flushing
>> > mitigation, and Pawan's work to bring some sanity to the mitigations that
>> > clear CPU buffers, with a bunch of glue code and some polishing from me.
>> >
>> > The "v4" is relative to the L1TF series.  I smushed the two series together
>> > as Pawan's idea to clear CPU buffers for MMIO in vmenter.S obviated the need
>> > for a separate cleanup/fix to have vmx_l1d_flush() return true/false, and
>> > handling the series separately would have been a lot of work+churn for no
>> > real benefit.
>> >
>> > TL;DR:
>> >
>> >  - Unify L1TF flushing under per-CPU variable
>> >  - Bury L1TF L1D flushing under CONFIG_CPU_MITIGATIONS=y
>> >  - Move MMIO Stale Data into asm, and do VERW at most once per VM-Enter
>> >
>> > To allow VMX to use ALTERNATIVE_2 to select slightly different flows for doing
>> > VERW, tweak the low lever macros in nospec-branch.h to define the instruction
>> > sequence, and then wrap it with __stringify() as needed.
>> >
>> > The non-VMX code is lightly tested (but there's far less chance for breakage
>> > there).  For the VMX code, I verified it does what I want (which may or may
>> > not be correct :-D) by hacking the code to force/clear various mitigations, and
>> > using ud2 to confirm the right path got selected.
>> 
>> FWIW [0] offers a way to check end-to-end that an L1TF exploit is broken
>> by the mitigation. It's a bit of a long-winded way to achieve that and I
>> guess L1TF is anyway the easy case here, but I couldn't resist promoting
>> it.

Oops, for posterity, the missing [0] was:

[0]: https://lore.kernel.org/all/20251013-l1tf-test-v1-0-583fb664836d@google.com/

> Yeah, it's on my radar, but it'll be a while before I have the bandwidth to dig
> through something that involved (though I _am_ excited to have a way to actually
> test mitigations).

Also, I just realised I never mentioned anywhere: this is just the first
part, we also have an extension to the L1TF exploit to make it attack
via SMT. And we also have tests that exploit SRSO. Those will come later
though, I think there's no point in burning everyone out trying to get
everything in at once.

