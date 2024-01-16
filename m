Return-Path: <kvm+bounces-6351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AAFB82F317
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 18:21:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1534128561C
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 17:21:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02ACB1CD05;
	Tue, 16 Jan 2024 17:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="grBawxMW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194AE1CA92
	for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 17:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705425647; cv=none; b=Nad8qg+zgVI4K4owhkf+0+G7a0MylCKR5M7rrd3cQ7zmYdKuKWA40rtJIC3JU7dxoOzr2y11ie6hNep2LmXxregh1RE4SQiFJkTGvtM6RQsm2kQe+HC2t1VUUrqO+63nODfEwg/CoBM+yeH+wxRsX1v5yA4TfZBVsM7JoEsTjao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705425647; c=relaxed/simple;
	bh=tnRy3jWG4+OwIbi8OFvCp/HqFPWFwcstEM2fzjh9K0E=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Date:
	 In-Reply-To:Mime-Version:References:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=a8rFEpyGswsYDmb40+sOC7U+KQKcmbubgYDMjApqVtoUM8IJGb51b2yb+lZvENHCmJcbtRsvCbsUf4LYa6rDIpiUc0a3U+2KPZhectIod/2DCTA2xeIaeWaXfLRU6uRnXs7urd5okoMn0h6bpjxONKdlfZcSgXhMsbOpp2dGxLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=grBawxMW; arc=none smtp.client-ip=209.85.128.201
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5e9de9795dfso189573317b3.0
        for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 09:20:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705425641; x=1706030441; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=clNdxL3spBiROjgCSpV36akIqm7jAf49yzjKH1UtjfE=;
        b=grBawxMWJiqgfnZmk0IxICqeOhfuMbvdhweSYKny+6e2nUK2KbssCihhckAkhMqZEd
         t+ikpkvzKqnNpp1ECzKCtujPhxawZYDoWZVlqRQSDWlh5OgV2d9qtX3GWTv7IKMGe+dh
         uIsVw//Qx0RD50BtbiaATKfyeocjJZBy/RMEPXaNEgO4PuddfM568X/TpNDEkUlrYMEO
         KzBP9Auszx7fiqpQfUuHpPMejdo7q/i+OrQxUW9x1dzVtO33K5x1S4JKrGb8eV3EINGF
         IBFq/nJFB8jl/rEQob+zOmJ82oPvQgMTc3Akg+hyHBWMO6+PW8TtGKGNN2ue9M8SytvO
         SpMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705425641; x=1706030441;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=clNdxL3spBiROjgCSpV36akIqm7jAf49yzjKH1UtjfE=;
        b=FliieHtUlyA5AYE4NqHvxZqcbEDmmmz44KQF5tYa3dw8jhcEwrKESFr+YZ1iXpMRa4
         LMwcnl7JN3Tld4ubV3gT8E/XKkr3VajmiRCcBY6l2Aq7qKque3PK89/4JRTOaDfpYXln
         ZZowTWDkmhHXpzkqzzmrxg/hsveXqXz3olg8m4XYJN5kNwYVqbCSE6GqtSsRWJZYIAYL
         +6HzUAkJ61Uf2ADr/Wu6NdE3cSrRNtTbawsi+chwCURrZXZZhLx1DG6d6k9bZk/vkDiY
         Qkz3RCI3QNf47ZAnYMsS/Sl4DsPYVGBYAIskDtsqTG/D8abdNblsY0kJO5j59p7wMP3S
         SVvA==
X-Gm-Message-State: AOJu0YxPZ+GwBCVAOSPYBDRRH3a5W/pN05eWz4n48eavkGwwEhhMQ86l
	vAAzpCdxNMoAv61+GSJSl6uRdAx3yrJ5QX3EtA==
X-Google-Smtp-Source: AGHT+IEa8FYhTZbg1Grsnfnbe1lAtRLd0Lu5zVL6RIJlU788VzmSGiCHMQ/3GdhuUMVq+NOCaEYXe+qYFyU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:564:b0:dc2:26f8:91f with SMTP id
 a4-20020a056902056400b00dc226f8091fmr479444ybt.8.1705425641075; Tue, 16 Jan
 2024 09:20:41 -0800 (PST)
Date: Tue, 16 Jan 2024 09:20:39 -0800
In-Reply-To: <ef81ff36-64bb-4cfe-ae9b-e3acf47bff24@proxmox.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <832697b9-3652-422d-a019-8c0574a188ac@proxmox.com>
 <ZaAQhc13IbWk5j5D@google.com> <ef81ff36-64bb-4cfe-ae9b-e3acf47bff24@proxmox.com>
Message-ID: <Zaa654hwFKba_7pf@google.com>
Subject: Re: Temporary KVM guest hangs connected to KSM and NUMA balancer
From: Sean Christopherson <seanjc@google.com>
To: Friedrich Weber <f.weber@proxmox.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 16, 2024, Friedrich Weber wrote:
> Hi Sean,
> 
> On 11/01/2024 17:00, Sean Christopherson wrote:
> > This is a known issue.  It's mostly a KVM bug[...] (fix posted[...]), but I suspect
> > that a bug in the dynamic preemption model logic[...] is also contributing to the
> > behavior by causing KVM to yield on preempt models where it really shouldn't.
> 
> I tried the following variants now, each applied on top of 6.7 (0dd3ee31):
> 
> * [1], the initial patch series mentioned in the bugreport ("[PATCH 0/2]
> KVM: Pre-check mmu_notifier retry on x86")
> * [2], its v2 that you linked above ("[PATCH v2] KVM: x86/mmu: Retry
> fault before acquiring mmu_lock if mapping is changing")
> * [3], the scheduler patch you linked above ("[PATCH] sched/core: Drop
> spinlocks on contention iff kernel is preemptible")
> * both [2] & [3]
> 
> My kernel is PREEMPT_DYNAMIC and, according to
> /sys/kernel/debug/sched/preempt, defaults to preempt=voluntary. For case
> [3], I additionally tried manually switching to preempt=full.
> 
> Provided I did not mess up, I get the following results for the
> reproducer I posted:
> 
> * [1] (the initial patch series): no hangs
> * [2] (its v2): hangs
> * [3] (the scheduler patch) with preempt=voluntary: no hangs
> * [3] (the scheduler patch) with preempt=full: hangs
> * [2] & [3]: no hangs
> 
> So it seems like:
> 
> * [1] (the initial patch series) fixes the hangs, which is consistent
> with the feedback in the bugreport [4].
> * But weirdly, its v2 [2] does not fix the hangs.
> * As long as I stay with preempt=voluntary, [3] (the scheduler patch)
> alone is already enough to fix the hangs in my case -- this I did not
> expect :)
> 
> Does this make sense to you? Happy to double-check or run more tests if
> anything seems off.
 
Ha!  It too me a few minutes to realize what went sideways with v2.  KVM has an
in-flight change that switches from host virtual addresses (HVA) to guest physical
frame numbers (GFN) for the retry check, commit 8569992d64b8 ("KVM: Use gfn instead
of hva for mmu_notifier_retry").

That commit is in the KVM pull request for 6.8, and so v2 is based on top of a
branch that contains said commit.  But for better or worse (probably worse), the
switch from HVA=GFN didn't change the _names_ of mmu_invalidate_range_{start,end},
only the type.  So v2 applies and compiles cleanly on 6.7, but it's subtly broken
because checking for a GFN match against an HVA range is all but guaranteed to get
false negatives.

If you can try v2 on top of `git://git.kernel.org/pub/scm/virt/kvm/kvm.git next`,
that would be helpful to confirm that I didn't screw up something else.

Thanks very much for reporting back!  I'm pretty sure we would have missed the
semantic conflict when backporting the fix to 6.7 and earlier, i.e. you likely
saved us from another round of bug reports for various stable trees.

