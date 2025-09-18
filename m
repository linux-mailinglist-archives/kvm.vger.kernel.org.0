Return-Path: <kvm+bounces-58038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D2F3B86578
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 19:58:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C06113B8B0F
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 17:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8FAE2882CF;
	Thu, 18 Sep 2025 17:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v5HgG66H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945182848BE
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 17:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758218292; cv=none; b=C1o3m5NyBvU/qsH39j2Frl7XS8GoNHorvhAp1S1l8DjrgdZvACgU2O8VYItcNgfe+SQ0JJQbKr54Dgv9qdqUv+ZMfT0jqOYX8wQinBDgDB0jh1AWSEjg3+pLHKKwfgAt7SF6QtC5ImHiB512AzWL5VX/hsPWF2s5chaocl940gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758218292; c=relaxed/simple;
	bh=VmpW7OnEYoEyc5lIRNLt2u7dmN2rs111BQgn9ACktVE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P0zY99W6fF/8Uy0uw/Tw8rhhf9NxNpOkDb/bKIPHFuxztedRncK+RVA564e4lpV7aGuJ8KuMBaQ9S0ceqZ0W0cdzBwCV3oiXFk204Lryke3D9hhXZs2dg6HCltdEC1rllmEMhVjgpFy3VjTaQ8P5NyAzDFJ94fGzNcvMIaeLu9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v5HgG66H; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b5515a1f5b8so206034a12.1
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 10:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758218290; x=1758823090; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b/M1FEowV3diJ/eMdBsk6hJ8wec8W1gdfm/YaaJ0QnQ=;
        b=v5HgG66HfnGaf/B8J4h2XvEzvVZgHsfmOLrcuB5AwL4ASlJdQbQ/0FicCXdWt05wjY
         vwcrKQg3Cz41acGB1XBD+Kh17hKRewCQejtVl8zo2R3fZ6KGw/rlqrLQEJ+DQgk4jW1s
         AgIH9SLAvcYOVGbwQJz66yXvvzGYcssKjhCiWA+meDczePw/RtGbAF532XzMf3xghlwv
         R4nuTO8QeKH0/Hcu21GkbqM7YXsBvgFPdPO823L1Bwq9TRNbmXaFZ/tDNkhExL7SZaSv
         I2sisbhU0CtL8IudQ0+dXFGuIizCqv6SDUelVopX6cikFQxAK9PeDmXXojie6MmNiwet
         ULyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758218290; x=1758823090;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b/M1FEowV3diJ/eMdBsk6hJ8wec8W1gdfm/YaaJ0QnQ=;
        b=mZG6+FSSNYYiDv4PX++RKylIyeHpLOTqwYPlQvZFs6MbzJ0vMm/Bm19JXexdK+/E0i
         mA06bsLDCr1wFVGEhM3nDXRR0Xd/Yy9BJMDk2W6GBXiYil76+N0iZ7WJlLefsHYtbDA7
         gmYaZd+wlv0SpYttCI/oMOzc+0DrPsCXxun/g3OFwHrinyqs2adNpIAaYMIoEAsK1FU0
         lwDcvPHf0YUNzZdDMkguGWkuSO3ZDuWj2TIhUeAxRxAYpaYAcY05wXCaMUUDDYtEjicn
         cihgbt/vRtlMvuLh8tz9zgZuKlFvXfAWZN1BAJL8uv7yP+z6aJMOS5gOh1F0mjmTZdI/
         8hYw==
X-Forwarded-Encrypted: i=1; AJvYcCVS0dsmaxH3mj19oomUGDShNLEXaI4wi0ZlYD5ZDZDTDxc7t/MPEOYk3KDNO6kfxx6CAFY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtSubShU089OoZhHfhYaEy3Qx8MA+zM3Tr9rfREDmekIRoginZ
	0tXXUyjIVXMAoVLLXlygzYzcHwAaP4uvW4h4j8bal9tBNJWtPXQssZppnv5v8Q0sOG+3Q0KBgF+
	23jrFCg==
X-Google-Smtp-Source: AGHT+IHFOysq+TUFP9EvRmUcELUaug1GgnM47ZAa/SK6gIEhQbX64NyajJHdrY4fLWC0UBAHJ5CzHUj9VNc=
X-Received: from pjbkl14.prod.google.com ([2002:a17:90b:498e:b0:31f:2a78:943])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ec83:b0:32e:8c14:5d09
 with SMTP id 98e67ed59e1d1-33097fef587mr345549a91.7.1758218290023; Thu, 18
 Sep 2025 10:58:10 -0700 (PDT)
Date: Thu, 18 Sep 2025 10:58:08 -0700
In-Reply-To: <20250918133938-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827194107.4142164-1-seanjc@google.com> <20250827201059.EmmdDFB_@linutronix.de>
 <20250918110828-mutt-send-email-mst@kernel.org> <20250918154826.oUc0cW0Y@linutronix.de>
 <aMwtd40q44q5uqwr@google.com> <20250918120658-mutt-send-email-mst@kernel.org>
 <aMw4wx5ENt-odhYS@google.com> <20250918133938-mutt-send-email-mst@kernel.org>
Message-ID: <aMxIMADtzYrJg6Pb@google.com>
Subject: Re: [PATCH v2 0/3] vhost_task: Fix a bug where KVM wakes an exited task
From: Sean Christopherson <seanjc@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 18, 2025, Michael S. Tsirkin wrote:
> On Thu, Sep 18, 2025 at 09:52:19AM -0700, Sean Christopherson wrote:
> > On Thu, Sep 18, 2025, Michael S. Tsirkin wrote:
> > > On Thu, Sep 18, 2025 at 09:04:07AM -0700, Sean Christopherson wrote:
> > > > On Thu, Sep 18, 2025, Sebastian Andrzej Siewior wrote:
> > > > > On 2025-09-18 11:09:05 [-0400], Michael S. Tsirkin wrote:
> > > > > > So how about switching to this approach then?
> > > > > > Instead of piling up fixes like we seem to do now ...
> > > > 
> > > > I don't have a strong preference for 6.17, beyond landing a fix of some kind.
> > > > I think there are three options for 6.17, in order of "least like to break
> > > > something":
> > > > 
> > > >  1. Sebastian's get_task_struct() fix
> > > 
> > > 
> > > I am just a bit apprehensive that we don't create a situation
> > > where we leak the task struct somehow, given the limited
> > > testing time. Can you help me get convinced that risk is 0?
> > 
> > I doubt it, I share same similar concerns about lack of testing.  So I guess
> > thinking about this again, #2 is probably safer since it'd only impact KVM?
> 
> I can't say I understand completely how we get that state though?
> Why did the warning trigger if it's not a UAF?

It's purely a flaw in the sanity check itself due to the ordering in vhost_task_fn().

As is, vhost_task_fn() marks the task KILLED before invoking ->handle_sigkill(),
i.e. before vhost_worker_killed() is guaranteed to complete, and thus before
worker->killed is set.  As a result, vhost can keep waking workers that have
KILLED set, but haven't actually exited.  That's perfectly fine as UAF won't
occur until do_exit() is called, and that won't happen until ->handle_sigkill()
completes.

> > > >  2. This series, without the KILLED sanity check in __vhost_task_wake()
> > > >  3. This series, with my fixup (with which syzbot was happy)
> 

