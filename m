Return-Path: <kvm+bounces-39202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ACE23A451C1
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 01:51:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A30CE17D888
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 00:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EBD1153BF0;
	Wed, 26 Feb 2025 00:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EnbrudHx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59394145B27
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 00:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740531059; cv=none; b=PwvyF2qJNhzDU+OA2gk4vJBtOfRHEp6WDy9IDhX9kxKC1pntr9yNW3yXV+W8rrfzRi56PyO0sXmRVdjiSaXE9ouqlEbRKeHvdKxm95lQ6eId1aHaAmHcEGoau7BjwvGQgLyuniM9u+oyJxvF6X/CyVqrFLpPuoUHEGKHCiGBoDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740531059; c=relaxed/simple;
	bh=z4otdrdsn2fsyB2Bvll9tjCAMDpiUsb7HJylJFqs8UQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z4qoDdBpTTkBmup69ycDAF1fe2zkQ4Tg/FA67TlbAc6K3UPxUn+msgDshqGKQcPEwSIJSyyjVcomGKa7ZonafDe7mJpFyFy0H+/QmGEWlNLW8kgO0v7B3Z9n8pmIK9TZ/d7oc9cHGlAtV7GxKRXgefcl292/lIMcvZ05szSV/lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EnbrudHx; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f2a9f056a8so13299680a91.2
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 16:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740531057; x=1741135857; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JXtm2iNAeoRBljTe88BgfoaNePq6nOE+XaOff3sfo/g=;
        b=EnbrudHx6FPi5eSeSmmrEYqNQUwTyQ6W1ZPT9kRed74bbvv0C3GkMxqoxqyb9qyHdR
         qiSkFtwemWb+8DYk7VWJ9AdSCy6ghNEo7K66iDtXSpwnw27iIbgb9t/PhXs+7BIlPsp2
         nE+Iv8xZ21/vvmHt6ZM3FgFz2f+jLvKsj/XN+I+kpCi0Bxf2KhyGNPV4q7qLjCw68FA5
         a4UmmyYxS58ZQvMsJs0d/W6jmngE344AMXriGRQ5Qv/JqCZMEeov0sNRGOkp0RrA/1XH
         5Aabc9jBNxFKrEfQdG/UtJoQbdjWQkVedUk7ICRAK3Wr+b27qRW/Ur7FrzHiteXMiJ0z
         FV5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740531057; x=1741135857;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JXtm2iNAeoRBljTe88BgfoaNePq6nOE+XaOff3sfo/g=;
        b=pCXCvw2zoKBiHigfpYT33vyAxDXqEd+XYdtQmJuaAiej16taPWodWdcsJ+jkeQfKi9
         D2Bop71bIej8gatgk+AH8MbIUZrSik8Bc5uFLiGjqjgE7i0oy5SePtfswRkx198Cxqba
         D/1KVYit4UMHPlTbIPrP3zU3FV+i4fkS2dRABqAWFUf7hbWyFPQwTqqkLCD3vGEbMVLm
         pc83n6199Ukegnq4CqShJK9kSLtqeRcOW6BX/kXF3UTJh+pj1kSntf0k57yzOPCqLUno
         cF9qgW+PxBiWXCf/kTTmBEJKteI1mozKfeQWgKtytkgbX91RLguKobeErukGtvLKf8No
         y19Q==
X-Forwarded-Encrypted: i=1; AJvYcCX+FzaonM9+7xtBHbMbZ2wtiXOgj9zZtE//zPaGJrChIWg3SxzIl20GeTvGMCJlqwEJDTQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8awqhBY3OSUDtCeJmnFJKWfik59dBsWyjwUxGzoyXVV5ndApH
	8AapurOAkZUHyvoi7YKt2V9p2LE/9YXhdPKA7Qcn0ENbrFf4UvYAN5mLki1wBQCqOTu6SQ9HxeN
	QWA==
X-Google-Smtp-Source: AGHT+IEGXofKw7PxDUXKaR4FAQmTtG03BfGhA63qxjzop1MVKo/p8/lL+ozSw4uxIKofwjdQ6x2HR5WCrE4=
X-Received: from pjb16.prod.google.com ([2002:a17:90b:2f10:b0:2fa:1803:2f9f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f42:b0:2ea:2a8d:dd2a
 with SMTP id 98e67ed59e1d1-2fe7e36c869mr2169059a91.27.1740531057669; Tue, 25
 Feb 2025 16:50:57 -0800 (PST)
Date: Tue, 25 Feb 2025 16:50:56 -0800
In-Reply-To: <07788b85473e24627131ffe1a8d1d01856dd9cb5.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250204004038.1680123-1-jthoughton@google.com>
 <025b409c5ca44055a5f90d2c67e76af86617e222.camel@redhat.com>
 <Z7UwI-9zqnhpmg30@google.com> <07788b85473e24627131ffe1a8d1d01856dd9cb5.camel@redhat.com>
Message-ID: <Z75lcJOEFfBMATAf@google.com>
Subject: Re: [PATCH v9 00/11] KVM: x86/mmu: Age sptes locklessly
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: James Houghton <jthoughton@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 25, 2025, Maxim Levitsky wrote:
> On Tue, 2025-02-18 at 17:13 -0800, Sean Christopherson wrote:
> > My understanding is that the behavior is deliberate.  Per Yu[1], page_idle/bitmap
> > effectively isn't supported by MGLRU.
> > 
> > [1] https://lore.kernel.org/all/CAOUHufZeADNp_y=Ng+acmMMgnTR=ZGFZ7z-m6O47O=CmJauWjw@mail.gmail.com
> 
> Hi,
> 
> Reading this mail makes me think that the page idle interface isn't really
> used anymore.

I'm sure it's still used in production somewhere.  And even if it's being phased
out in favor of MGLRU, it's still super useful for testing purposes, because it
gives userspace much more direct control over aging.

> Maybe we should redo the access_tracking_perf_test to only use the MGLRU
> specific interfaces/mode, and remove its classical page_idle mode altogher?

I don't want to take a hard dependency on MGLRU (unless page_idle gets fully
deprecated/removed by the kernel), and I also don't think page_idle is the main
problem with the test.
   
> The point I am trying to get across is that currently
> access_tracking_perf_test main purpose is to test that page_idle works with
> secondary paging and the fact is that it doesn't work well due to more that
> one reason:

The primary purpose of the test is to measure performance.  Asserting that 90%+
pages were dirtied is a sanity check, not an outright goal.

> The mere fact that we don't flush TLB already necessitated hacks like the 90%
> check, which for example doesn't work nested so another hack was needed, to
> skip the check completely when hypervisor is detected, etc, etc.

100% agreed here.

> And now as of 6.13, we don't propagate accessed bit when KVM zaps the SPTE at
> all, which can happen at least in theory due to other reasons than NUMA balancing.
> 
> Tomorrow there will be something else that will cause KVM to zap the SPTEs,
> and the test will fail again, and again...
> 
> What do you think?

What if we make the assertion user controllable?  I.e. let the user opt-out (or
off-by-default and opt-in) via command line?  We did something similar for the
rseq test, because the test would run far fewer iterations than expected if the
vCPU task was migrated to CPU(s) in deep sleep states.

	TEST_ASSERT(skip_sanity_check || i > (NR_TASK_MIGRATIONS / 2),
		    "Only performed %d KVM_RUNs, task stalled too much?\n\n"
		    "  Try disabling deep sleep states to reduce CPU wakeup latency,\n"
		    "  e.g. via cpuidle.off=1 or setting /dev/cpu_dma_latency to '0',\n"
		    "  or run with -u to disable this sanity check.", i);

This is quite similar, because as you say, it's impractical for the test to account
for every possible environmental quirk.

> > Aha!  I wonder if in the failing case, the vCPU gets migrated to a pCPU on a
> > different node, and that causes NUMA balancing to go crazy and zap pretty much
> > all of guest memory.  If that's what's happening, then a better solution for the
> > NUMA balancing issue would be to affine the vCPU to a single NUMA node (or hard
> > pin it to a single pCPU?).
> 
> Nope. I pinned main thread to  CPU 0 and VM thread to  CPU 1 and the problem
> persists.  On 6.13, the only way to make the test consistently work is to
> disable NUMA balancing.

Well that's odd.  While I'm quite curious as to what's happening, my stance is
that enabling NUMA balancing with KVM is a terrible idea, so my vote is to sweep
it under the rug and let the user disable the sanity check.

