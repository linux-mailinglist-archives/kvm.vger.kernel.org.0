Return-Path: <kvm+bounces-36671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D1E4A1DB27
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 18:19:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAE23162317
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 17:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D7FF18A924;
	Mon, 27 Jan 2025 17:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L9m3faLe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76FD7DA6A
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 17:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737998355; cv=none; b=kSnRvyryo8sEDb8wL8K5/SLNK8TPiqQqzcx5iGHCc2Dg60D5OnQZVTd9tGrZVZkHxwTdV+NdCMxqJmtWbj9w2TjKxRscbBrTHHaiJ69Yz+TeVFDDtp/ZGmxbCINQFY/6dGeiUXP7tZC659TVXWTY+mn1tC7gDxI7988/QW5Zd6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737998355; c=relaxed/simple;
	bh=iBnURTqPXW2aHXWRytiUQwc3RleQ1CdQYvgVqtnNdGE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QnIDTaFaLwyilj3CrxaTOgGXu2aps5Mg0oilWiBnatUhlHhQj7olVD0H+P/9q4R+ktoqUZy/2eoU+Fytwhk0YzBgYBhcfvq2zDTwwoWCwGe/c92Zzn3Hv76Xb3byzxWw2mbUvuuADDZX4VGcoAZXSzU0hk7d7poh7OLwngVuFHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L9m3faLe; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-3eb9757e579so3675319b6e.3
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 09:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737998353; x=1738603153; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k6ZFPH8+E5WrW09Nv346BS0Z+fTVST94HMISpos/8LA=;
        b=L9m3faLeWOv5z6Mu+hVtTLNJfz7/PcdUvufkKbF6Mt8p2mC70hqBo0aPXO3pPH5eKo
         e8DAre/szR/bsj4ApYCQrNjkbOhAjwKiGh/fN6G4PYcuzdyxtHfDmcZSdLIQWCknPUKg
         syjuuHfBfa85BZMtIvz2PqlxalThU3FIoGFrlKsLBHE/45R1JuxV+elP5w5PbuEn5jYS
         WKKSvp6nXVoyIzHIclSDdopyVLfmK227HzdjZXe5mAF8vroW6BgIM8WgvoEfeQwE+wW/
         Ffdlf6uvn9SNS3RQKOWJsrzsl6dZeglI3HdJeglbDUXU17GMaCPLDQOlbHZFhliFDdQp
         5UvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737998353; x=1738603153;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k6ZFPH8+E5WrW09Nv346BS0Z+fTVST94HMISpos/8LA=;
        b=VAjCr/EL7c4oyZcVxVm3oB/XChvqcWA8TBB9U3x4SKbmDiTHysfg1srVX+5KgPn7Za
         zThRakbgmweNT1920TDozIorLFVG5+202+TJ2ckscBOMsWXD1i/0WyyJNLqHKlR6FMrp
         sxQgOJKj6JUHdvQeXDUnPFVbogijh+z/tbt8tAs4RfDeU47NzJ9dKm82Ss6G7/Ii0yY5
         62GwWbWt0rc8wZdok/Qb8uAeJl/3yD3kbp0/jygdje4gfLkcb7QJ8P4Ce3AoyoVuzt9D
         7bTXSzv04DbyamOFASzSEDHu9aNH794ubiRBGSa0JRCYkCoQNOlRMtL5pcZNoCLM+dQC
         D/Uw==
X-Forwarded-Encrypted: i=1; AJvYcCW3rRE+vVDq+r2Nf/snXcLf6KoHMTakC8vF2YhP/ol8K9v93pou1DW1Oxnp2Q49yN0Dyts=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvltLR6XMzWZpUAycB1CBFpWpnwABiJ+odcMuXif/BdLXBZTDr
	wtcFqJmOjU3NfMRBKTNlDZcms86Esut2YJ3CUdh5orLozXxlZAYARlcpZZZkZA0y0sEvK03IKIU
	rHw==
X-Google-Smtp-Source: AGHT+IGRUszYJFAK7joMtRXqZLbVy1IE+a02qW5WNJPmkf4KHnpufiJpDLdSbCWXxcMpFRmG2nQMUgnxee4=
X-Received: from pgbcf12.prod.google.com ([2002:a05:6a02:84c:b0:801:d724:5abd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1d1:b0:216:668d:690c
 with SMTP id d9443c01a7336-21c3558171emr693519375ad.28.1737998342288; Mon, 27
 Jan 2025 09:19:02 -0800 (PST)
Date: Mon, 27 Jan 2025 09:19:01 -0800
In-Reply-To: <Z5e8umkPeRri0Z_p@kbusch-mbp>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250124234623.3609069-1-seanjc@google.com> <Z5RkcB_wf5Y74BUM@kbusch-mbp>
 <Z5e4w7IlEEk2cpH-@google.com> <Z5e8umkPeRri0Z_p@kbusch-mbp>
Message-ID: <Z5fABRZuUz6o2cyF@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Ensure NX huge page recovery thread is
 alive before waking
From: Sean Christopherson <seanjc@google.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 27, 2025, Keith Busch wrote:
> On Mon, Jan 27, 2025 at 08:48:03AM -0800, Sean Christopherson wrote:
> > If vhost_task_create() fails, then the call_once() will "succeed" and mark the
> > structure as ONCE_COMPLETED.  The first KVM_RUN will fail with -ENOMEM, but any
> > subsequent calls will succeed, including in-flight KVM_RUNs on other threads.
> 
> The criteria for returning -ENOMEM for any KVM_RUN is if we have a NULL
> nx_huge_page_recovery_thread vhost_task. So I think that part, at least,
> is fine.
> 
> The call_once is just needed to ensure that only the very first KVM_RUN
> even tries to create it. If the vhost_task_create fails, then all the
> KVM_RUN threads will see the NULL nx_huge_page_recovery_thread and
> return -ENOMEM.

Ah, duh, because the check is performed by the caller, outside of the "once"
protection.

> What you're suggesting here will allow a subsequent thread to attempt
> creating the vhost task if the first one failed. Maybe you do want to
> try again, but the current upstream code doesn't retry this, so I
> thought it best to keep that behavior.

No strong opinion.  In practice, it's a moot point because the odds of a VM being
able to make forward progress if task creation hits an OOM are basically nil.

I'll defer to Paolo on what he thinks is best for the call_once() API.

