Return-Path: <kvm+bounces-35299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C900A0BC8E
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 16:49:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B41191885A78
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 15:49:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFA5C1FBBE5;
	Mon, 13 Jan 2025 15:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jwChamly"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8169714B08A
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 15:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736783330; cv=none; b=SDUTx8jEKbh6Bvi/6qCG2E6UxB/Of6hcFr3JxAqI4228axYIhtwF0XgxqtZqRVlwHNPofr+9zgAAPay5WZBm8svgemvVGxMEj8i021+RoCHZhOnfMcK5zAvgyi4FfFLQSQvVM7qOPxAWvpPCJk32WM583nL3R/hYWnkjqXemxo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736783330; c=relaxed/simple;
	bh=IYZOypcaQcSIoz0YrOnSpdYtmQ7rwZr8J3hfohT0pQw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Na3zDM9CJKbNe8c0NCGMKIM12qSyLga2ddeKYyI6oifUJgi6F3jVUcQgEuCMbCeuJiiVtpMynRwCIppV1dwQODQorDwRXGgDYpeY3RxhN6zzi7CTWelZV1NJyX89FWdFjCNo3se/Dufc3qggjf5MlPCcIiCcTC/DEKKrgpI0ZiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jwChamly; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee8ced572eso7947587a91.0
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 07:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736783328; x=1737388128; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i9nzX7aXTGYmmOj2PtSq7Ss6UOn7GgH7UoDrTFdf5uc=;
        b=jwChamlyVOPgPyTfDzx3xVyO8+jGh84S7YG4oTnonPr+qJD9hWDTBduWsnj6YAk8l1
         YHMBtzS6joxUS2F8qYthoAZJyBOpt5Ty2VowHEDNXIhmzbcv+srCDSFa1G1C352tgvl7
         tpV5VvHy55F6bVWchBUKHuVM1+S/nlmfg4pYsaPB1lvSn8zTk8MSazlQJ4hsEVQ5cKIF
         7FczpAL59EB98+d/nwZtH6GszvbvSwE+PyC0TrV5NF9D1kHVLFtcLr0BQpcaQCn56vYH
         a+7eKBgOAsjmEw7DMNiWuIWx2BlCI+tIUbIz7IIF4qBRK/JX+Yb7tq9NLQLX2D0wYaJ3
         H3mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736783328; x=1737388128;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i9nzX7aXTGYmmOj2PtSq7Ss6UOn7GgH7UoDrTFdf5uc=;
        b=rx+yrxYzPDW9APQnKAWfkewd4iYhMrtWvNqC1bK5QwMELj2kbS/A1/IdOdUrwuZbNv
         bTv3HbFeNNALfbRvJzNlPfg4DvgK1uSJwPEZFjws+rDKCM2WvqO4kzTU25ZP5cuYJ8BS
         r8+oMYi2PmNi8RQxizo4cKWCgV/UWyoPc15YGlNNEdKWSoeDBxWKI0woxH2XS0NX4WUQ
         J4u6SKcwsEz2AjMiqNEXIgRRm0Q5vaQ94c3EYTZFkT7wBiUp+Ri7vxTnGpcgQpqpP6iO
         y1soA50Frpf5n3bA6cqutsq40E36kggd2jPllY3Cp1eHwi8NgtIHob5+YxA+maSG4stE
         t5Qg==
X-Forwarded-Encrypted: i=1; AJvYcCUTN0hQbnMAsA35HPqb8OZicK69odbsYJ8T6Fg/KXiqxXIdrz4akFdyJqFXXDYzn6B6tKM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiQGSDuaLlWQMbuogJK5dL3WES4r13+O9FOZ5xsBZMuA289y5k
	WP55AWEbnhBvhazB1Y82WWR7OynEF4SNV7k1EGB75rFt4cGylwjHnPF8ywas4oR8JAvYTVNdDaC
	gSw==
X-Google-Smtp-Source: AGHT+IEnku9NNmAY4NKweblgpWHxNUkjYFq0KrtNH5xLtW+mmgVk7olQ8zzt2RYoUY6Srjz/ceKKLzr8p2w=
X-Received: from pjqa2.prod.google.com ([2002:a17:90a:a502:b0:2f6:e47c:1747])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:520f:b0:2ee:db8a:29f0
 with SMTP id 98e67ed59e1d1-2f548f1b7e6mr29175048a91.27.1736783327688; Mon, 13
 Jan 2025 07:48:47 -0800 (PST)
Date: Mon, 13 Jan 2025 07:48:46 -0800
In-Reply-To: <Z4TdaxQwMuA7NM5g@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111010409.1252942-1-seanjc@google.com> <20250111010409.1252942-3-seanjc@google.com>
 <Z4TdaxQwMuA7NM5g@yzhao56-desk.sh.intel.com>
Message-ID: <Z4U13s_TeP3jAedh@google.com>
Subject: Re: [PATCH 2/5] KVM: Bail from the dirty ring reset flow if a signal
 is pending
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 13, 2025, Yan Zhao wrote:
> On Fri, Jan 10, 2025 at 05:04:06PM -0800, Sean Christopherson wrote:
> > Abort a dirty ring reset if the current task has a pending signal, as the
> > hard limit of INT_MAX entries doesn't ensure KVM will respond to a signal
> > in a timely fashion.
> > 
> > Fixes: fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  virt/kvm/dirty_ring.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> > index 2faf894dec5a..a81ad17d5eef 100644
> > --- a/virt/kvm/dirty_ring.c
> > +++ b/virt/kvm/dirty_ring.c
> > @@ -117,6 +117,9 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
> >  	cur_slot = cur_offset = mask = 0;
> >  
> >  	while (likely((*nr_entries_reset) < INT_MAX)) {
> > +		if (signal_pending(current))
> > +			return -EINTR;
> Will it break the userspace when a signal is pending? e.g. QEMU might report an
> error like
> "kvm_dirty_ring_reap_locked: Assertion `ret == total' failed".

Ugh.  In theory, yes.  In practice, I hope not?  If it's a potential problem for
QEMU, the only idea have is to only react to fatal signals by default, and then
let userspace opt-in to reacting to non-fatal signals.

> 
> >  		entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
> >  
> >  		if (!kvm_dirty_gfn_harvested(entry))
> > -- 
> > 2.47.1.613.gc27f4b7a9f-goog
> > 

