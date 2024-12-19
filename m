Return-Path: <kvm+bounces-34093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 01A269F7285
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 03:14:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77902188BF1B
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 02:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6425A78F2D;
	Thu, 19 Dec 2024 02:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s3JQEvM2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069AA4DA04
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 02:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734574436; cv=none; b=bEio03ydjwbdiSxG9BlryHGh8CCNdaSiQVr0Ub87YxEJLa3D9WMAldn3Ef1XJcvpsiTBcdkOdDTWLBhoNlGBO4UcssmgyB8vlGaURnnOhkHU4MWSdmWx9dXI+MFBKjOhqsro0GMmnpCJhMXuLI+oU9oqMcu3yvEb8Oahd1ldLRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734574436; c=relaxed/simple;
	bh=L7Fx5ggKmryfJVk2cggnyAeH+sHNuH9BZXayIbVtv7c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S6XwrhFZ0Lf0MESukpdR5cThPmHyqJztPdlqUlghTa1hBuew5zIxS9ujUhtAD2jnolVUpHVFKebUWdhneBSE5yUYc0JnnuhauoYbnN5J4Y4DJfvJrYNJEmKRcx6117rk38ZvmLPosrGZa76DCOQIRV6dUa5OvdCVFQSHDZtMw4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s3JQEvM2; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f2a9743093so278874a91.3
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734574434; x=1735179234; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bDeAWYWC0HCAW56PbNHRhtgmzycjgvEnQXZSyGnnPYU=;
        b=s3JQEvM2S7o+PY5yrz1jlRdJdK5qJ8idLsRg1zsxWYYEKQ2H0lHTWKZE5er6JzY3Qw
         rx4DA+gZJ97w+c1KJWTta98UeBZEWdX2vEpugM8aFlCReWAiOMySlXKIon0pxYbb2b5G
         jQeeiMQsEnNOvRwAefCEQWOwEEMLD5PyNSwJAAh4yo0kE8p5QWfmEpozd6pN+C/gv5ck
         UkSE2zXfuoN6o1KU3ypfWAGt5Vcl+fHGJMplv/EsetqRH2AhNS6H+GWksOva4ic/Dw+G
         51bqrx1Yb44aeuHmFYS5YjVP0/A7XeOrFDxeqWQKj1E/uByzs4oSADsAaq21eZySvpQv
         yxZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734574434; x=1735179234;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bDeAWYWC0HCAW56PbNHRhtgmzycjgvEnQXZSyGnnPYU=;
        b=tIacLQ0gegc03y8cdVbpPYY7ebzD2Gup99yp/xrSrGAlOO7D1EMLtdlx9LhEWLayqv
         ABcb5t1OJDQrTczHHqGy/OkuWjaP1ApaGauM+KFumFp3SsEnTkBps8paComN/XR9dLug
         rcSbsfINSL6TpS140eGm8FsIVISE71s2/LRPtqFfZig+fQl9Tnml2vu0d/CeXEnOQ2n0
         FpdJnDacM3UmHxEIqDvB/T6dWtURXhYDGbyW8qS/RUA/f/W/rqwalSy/3kGyzurT/gs7
         EdHDhwvmQSSMh3mg1y6G3BAoTVl7pvn4AVwoxPlGwWv+MSWUf61kKNe1dIDCwQiWo9v/
         jtLg==
X-Forwarded-Encrypted: i=1; AJvYcCW4LApf050Su5eEw3mYR0Ai12isa6GOElu+4Xm1Y93DJvnOhIt3PLtQG4AY0thcQczaRok=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuVxL+oEdJxg745E+ZN7ph+rIjvPH/GGqiRQavx5J+Q/UMQLgl
	pSIVTVP+VxIJ+CSQTwEtm4Ng6GnDsQzW0K+lfHequ6jNRRLJlhTrYyIj4IFm8sst8pgyEPhGyBs
	1zA==
X-Google-Smtp-Source: AGHT+IGBCW3P8t1GXn8qPQXba7fdDIU+RBGGNlovYKQ/83YmsIwe1P+krSAzUfHxOYDQOX1yoarPPZ+uIu8=
X-Received: from pjiz22.prod.google.com ([2002:a17:90a:6096:b0:2f4:4222:ebba])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2c8c:b0:2ee:e518:c1d8
 with SMTP id 98e67ed59e1d1-2f443d3cc89mr2075399a91.30.1734574434264; Wed, 18
 Dec 2024 18:13:54 -0800 (PST)
Date: Wed, 18 Dec 2024 18:13:53 -0800
In-Reply-To: <fb179759bdc224431f6b031eaa9747c1897d296b.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241214010721.2356923-1-seanjc@google.com> <20241214010721.2356923-15-seanjc@google.com>
 <fb179759bdc224431f6b031eaa9747c1897d296b.camel@redhat.com>
Message-ID: <Z2OBYYQq6cwptSws@google.com>
Subject: Re: [PATCH 14/20] KVM: selftests: Collect *all* dirty entries in each
 dirty_log_test iteration
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 17, 2024, Maxim Levitsky wrote:
> On Fri, 2024-12-13 at 17:07 -0800, Sean Christopherson wrote:
> > Collect all dirty entries during each iteration of dirty_log_test by
> > doing a final collection after the vCPU has been stopped.  To deal with
> > KVM's destructive approach to getting the dirty bitmaps, use a second
> > bitmap for the post-stop collection.
> > 
> > Collecting all entries that were dirtied during an iteration simplifies
> > the verification logic *and* improves test coverage.
> > 
> >   - If a page is written during iteration X, but not seen as dirty until
> >     X+1, the test can get a false pass if the page is also written during
> >     X+1.
> > 
> >   - If a dirty page used a stale value from a previous iteration, the test
> >     would grant a false pass.
> > 
> >   - If a missed dirty log occurs in the last iteration, the test would fail
> >     to detect the issue.
> > 
> > E.g. modifying mark_page_dirty_in_slot() to dirty an unwritten gfn:
> > 
> > 	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
> > 		unsigned long rel_gfn = gfn - memslot->base_gfn;
> > 		u32 slot = (memslot->as_id << 16) | memslot->id;
> > 
> > 		if (!vcpu->extra_dirty &&
> > 		    gfn_to_memslot(kvm, gfn + 1) == memslot) {
> > 			vcpu->extra_dirty = true;
> > 			mark_page_dirty_in_slot(kvm, memslot, gfn + 1);
> > 		}
> > 		if (kvm->dirty_ring_size && vcpu)
> > 			kvm_dirty_ring_push(vcpu, slot, rel_gfn);
> > 		else if (memslot->dirty_bitmap)
> > 			set_bit_le(rel_gfn, memslot->dirty_bitmap);
> > 	}
> > 
> > isn't detected with the current approach, even with an interval of 1ms
> > (when running nested in a VM; bare metal would be even *less* likely to
> > detect the bug due to the vCPU being able to dirty more memory).  Whereas
> > collecting all dirty entries consistently detects failures with an
> > interval of 700ms or more (the longer interval means a higher probability
> > of an actual write to the prematurely-dirtied page).
> 
> While this patch might improve coverage for this particular case,
> I think that this patch will make the test to be much more deterministic,

The verification will be more deterministic, but the actual testcase itself is
just as random as it was before.

> and thus have less chance of catching various races in the kernel that can happen.
> 
> In fact in my option I prefer moving this test in other direction by
> verifying dirty ring while the *vCPU runs* as well, in other words, not
> stopping the vCPU at all unless its dirty ring is full.

I don't see how letting verification be coincident with the vCPU running is at
all interesting for a dirty logging.  Host userspace reading guest memory while
it's being written by the guest doesn't stress KVM's dirty logging in any meaningful
way.  E.g. it exercises hardware far more than anything else.  If we want to stress
that boundary, then we should spin up another vCPU or host thread to randomly read
while the test is in-progress, and also to write to bytes 4095:8 (assuming a 4KiB
page size), e.g. to ensure that dueling writes to a cacheline that trigger false
sharing are handled correct.

But letting the vCPU-under-test keep changing the memory while it's being validated
would add significant complexity, without any benefit insofar as I can see.  As
evidenced by the bug the current approach can't detect, heavily stressing the
system is meaningless if it's impossible to separate the signal from the noise.

