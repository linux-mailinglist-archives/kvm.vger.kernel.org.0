Return-Path: <kvm+bounces-21565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 971D292FF16
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:09:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C70941C219D2
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:09:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 893BC1791F4;
	Fri, 12 Jul 2024 17:02:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE376178397;
	Fri, 12 Jul 2024 17:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803754; cv=none; b=n2Y3msqR5CQhbCszjLoWEpUgWrD3DwAjNvebo0NMLfP3toPQkZdbREEu1ineYZhZIGQ815Y2DbB25jh7PfLKu4nT/rhwjyLX94lEamGAbbZR1Ds9U1YPiy5ZzHzpxS9HP4rdlmBfsjUGVYCwKLs/Es53Ko3Q6f8v1lNXyqrXAtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803754; c=relaxed/simple;
	bh=I4z80uf9z3521cknQ18uC8LRTHagv6p8IMSR1R8y37E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SX1iuhrEgjX51GZMBCs4xg+HjkoGWAs2QrwifLoXE51XCrLxwvtQww+LJQTj7XLgPAEeOJpNmTOKDrisZLvO9iaLR2Rniuff/haKARmc4LUPS976XHpTt0gh4vRmDWwYDmmKtr32JGoStMbga6a1oBBMnpEsxY/6vEDGwqOQ/qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707E8C32782;
	Fri, 12 Jul 2024 17:02:30 +0000 (UTC)
Date: Fri, 12 Jul 2024 13:02:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Joel Fernandes
 <joel@joelfernandes.org>, Vineeth Remanan Pillai <vineeth@bitbyteword.org>,
 Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>, Daniel
 Bristot de Oliveira <bristot@redhat.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Juri
 Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>, Paolo Bonzini
 <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Valentin
 Schneider <vschneid@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Wanpeng Li <wanpengli@tencent.com>, Suleiman Souhlal <suleiman@google.com>,
 Masami Hiramatsu <mhiramat@kernel.org>, himadrics@inria.fr,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 graf@amazon.com, drjunior.org@gmail.com
Subject: Re: [RFC PATCH v2 0/5] Paravirt Scheduling (Dynamic vcpu priority
 management)
Message-ID: <20240712130228.72de0a7d@rorschach.local.home>
In-Reply-To: <ZpFcWPMwEOQchvCB@google.com>
References: <20240403140116.3002809-1-vineeth@bitbyteword.org>
	<ZjJf27yn-vkdB32X@google.com>
	<CAO7JXPgbtFJO6fMdGv3jf=DfiCNzcfi4Hgfn3hfotWH=FuD3zQ@mail.gmail.com>
	<CAO7JXPhMfibNsX6Nx902PRo7_A2b4Rnc3UP=bpKYeOuQnHvtrw@mail.gmail.com>
	<66912820.050a0220.15d64.10f5@mx.google.com>
	<19ecf8c8-d5ac-4cfb-a650-cf072ced81ce@efficios.com>
	<ZpFCKrRKluacu58x@google.com>
	<01c3e7de-0c1a-45e0-aed6-c11e9fa763df@efficios.com>
	<20240712123019.7e18c67a@rorschach.local.home>
	<ZpFcWPMwEOQchvCB@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Jul 2024 09:39:52 -0700
Sean Christopherson <seanjc@google.com> wrote:

> > 
> > One other issue we need to worry about is that IIUC rseq memory is
> > allocated by the guest/user, not the host kernel. This means it can be
> > swapped out. The code that handles this needs to be able to handle user
> > page faults.  
> 
> This is a non-issue, it will Just Work, same as any other memory that is exposed
> to the guest and can be reclaimed/swapped/migrated..
> 
> If the host swaps out the rseq page, mmu_notifiers will call into KVM and KVM will
> unmap the page from the guest.  If/when the page is accessed by the guest, KVM
> will fault the page back into the host's primary MMU, and then map the new pfn
> into the guest.

My comment is that in the host kernel, the access to this memory needs
to be user page fault safe. You can't call it in atomic context.

-- Steve

