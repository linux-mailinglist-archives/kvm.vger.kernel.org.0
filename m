Return-Path: <kvm+bounces-36586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EEB6A1BF90
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 01:10:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 043B83AC72F
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 00:10:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD5D83214;
	Sat, 25 Jan 2025 00:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M0WhqAWf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF639360
	for <kvm@vger.kernel.org>; Sat, 25 Jan 2025 00:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737763849; cv=none; b=pEejgJR6BYmJI4FULZ1LeAGEHqaSIvNapSBod2rvsD0FnGbeOAE1kw3dpa3q82G42NTBCY/tDpy1RxKpQis+MPZnCl1ehhUm99+zu7kAXG9mVRKEKoZuTpiANRhF/eZGNWOhWpf17DHSByJolX5rW3Ut41ezAnjlc09wcG9iE38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737763849; c=relaxed/simple;
	bh=vUGqW9hRUo6yTSS0XX3LufamipqZvYQXssBdlkbaMDw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EPf4UZLa0f+9ty99RyMa8mnJzicfuZ1GnwcAXBuwz1LSAAi713CMocdlItwadi0CTQY0M8yhut7KwoX6vVIQapC1QNnH+rQyZ7pGj5eXfEganDUj5y0ppJ7mTWsGrmc1Kq437Mk3rWtuHr6DDMwOHMnMesL61o52Dzh6X2pbEDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M0WhqAWf; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2165433e229so52238905ad.1
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 16:10:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737763847; x=1738368647; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lLBwqek7dAIeuACyAn1wHDWn/eOmVHui0aCFeRl2CPg=;
        b=M0WhqAWfXlLUBHH4P3DivvEuiySJSOAMnXRZOKmpHmJ5KOyakKVWAwhdCry/tANyyy
         CGVaBgHoELP9h/Tf02n/+yV/FNlyGSo2C6GsTxphXFYWwnyEhqC5CScdhq1TjavM7ent
         XdBiB6a116lA1ePpZyiWwcck/zH1y1vWU9Yk/XJazlNMxAnNXD0BUoWpVRyZGQqXo2qU
         AWg6cv8GjbyqwnlP65jtGjJFFD/e8oNjjUI2p1hPnz4WoAKyeTN463GyseWYF8TAA0Mz
         ZaD6UR1pJG6AjNrRttTwc/RvC5PH38+gqcRjKjklkDyi6DoXz0DuJy5RI1GAc5cTYtuy
         N8Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737763847; x=1738368647;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lLBwqek7dAIeuACyAn1wHDWn/eOmVHui0aCFeRl2CPg=;
        b=wmhGI4D8rFbasIZPFuqKNHLszb56mZh0BYuC2IMWsR6BIMlEKaTEL9tacr/Q5ZxhGE
         8zDY69Jll16xH/t/64Btksy2kQdzDmrhqnhsBi0P/CVRZnPJyjedGLTcbvTvbpwAXYIV
         M69bK+NnbdgSlEr7zdTqeT2kgUXaPse38wYKJOIzpvvRPZVIPZYD4Y/FEsMPPt52aR0Q
         zPbofv0ACvkodDYwc11d+THubryh2AhZQIb7TLanZ3u+6xDEHfHaol4uBxfUCfMO2g+z
         PuD5OwlvyuTpNqVMCJ9tXIKqBw9TiW5vTHG+ncO/atLpmlgNL/zjrOipKaT3L9FacElX
         IZnw==
X-Forwarded-Encrypted: i=1; AJvYcCU50TwYPmpYRxdJKdTnXWKifmgPVdF3Nap9JKP7Yaf4czJRhLDKbYphM7D4ep971CjwX84=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6E3zSjhUmA1FEBcGPp/PSV0CncqIuwT9ARQqM8ZyKUCBJzVj0
	iyE0C+uleaiqDdEutGw1eCRVOo0+i+o2a3PqiOQwSM3stM3jdh8xuvvdbjFmvra7940SmZW1ZQq
	SgQ==
X-Google-Smtp-Source: AGHT+IFpy3P4veqv3F3dWouqbdgVpGzdZe9YYIEXXZ4ArJcsgxQiSvHAO44CHe0DkODVGsEgPjRaJAtco+8=
X-Received: from plbme16.prod.google.com ([2002:a17:902:fc50:b0:216:21cb:2dfe])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f688:b0:215:aee1:7e3e
 with SMTP id d9443c01a7336-21c352d664fmr461166135ad.5.1737763846919; Fri, 24
 Jan 2025 16:10:46 -0800 (PST)
Date: Fri, 24 Jan 2025 16:10:45 -0800
In-Reply-To: <Z5P97NyK9Rb_cU1z@kbusch-mbp>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250123153543.2769928-1-kbusch@meta.com> <Z5Py_JYc8nYHNgZS@google.com>
 <Z5P97NyK9Rb_cU1z@kbusch-mbp>
Message-ID: <Z5QsBXJ7rkJFDtmK@google.com>
Subject: Re: [PATCH] kvm: defer huge page recovery vhost task to later
From: Sean Christopherson <seanjc@google.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Vlad Poenaru <thevlad@meta.com>, tj@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Alyssa Ross <hi@alyssa.is>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 24, 2025, Keith Busch wrote:
> On Fri, Jan 24, 2025 at 12:07:24PM -0800, Sean Christopherson wrote:
> > This is broken.  If the module param is toggled before the first KVM_RUN, KVM
> > will hit a NULL pointer deref due to trying to start a non-existent vhost task:
> > 
> >   BUG: kernel NULL pointer dereference, address: 0000000000000040
> >   #PF: supervisor read access in kernel mode
> >   #PF: error_code(0x0000) - not-present page
> >   PGD 0 P4D 0 
> >   Oops: Oops: 0000 [#1] SMP
> >   CPU: 16 UID: 0 PID: 1190 Comm: bash Not tainted 6.13.0-rc3-9bb02e874121-x86/xen_msr_fixes-vm #2382
> >   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
> >   RIP: 0010:vhost_task_wake+0x5/0x10
> >   Call Trace:
> >    <TASK>
> >    set_nx_huge_pages+0xcc/0x1e0 [kvm]
> 
> Thanks for pointing out this gap. It looks like we'd have to hold the
> kvm_lock in kvm_mmu_post_init_vm(), and add NULL checks in
> set_nx_huge_pages() and set_nx_huge_pages_recovery_param() to prevent
> the NULL deref. Is that okay?

I don't _think_ we need to take kvm_lock.  And I don't want to take kvm_lock,
because we're also trying to eliminate a (very theoretical) deadlock[1] due to
taking kvm_lock in the params helpers.

There is a race that can happen with my proposed fix[2], but I'm not sure we care
enough to address it.  If kvm_nx_huge_page_recovery_worker() runs before the params
are set, and the param setter processes the VM before nx_huge_page_recovery_thread
is set, then the worker could sleep for too long, relative to what userspace expects.

I suppose if we care then we could fix that by taking kvm->arch.nx_once.mutex
when waking the task?

[1] https://lore.kernel.org/all/20250124191109.205955-2-pbonzini@redhat.com
[2] https://lore.kernel.org/all/20250124234623.3609069-1-seanjc@google.com

