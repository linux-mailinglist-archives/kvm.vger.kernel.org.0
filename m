Return-Path: <kvm+bounces-21569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D53F992FF4E
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:14:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96A01286AF2
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36BDC176AD0;
	Fri, 12 Jul 2024 17:14:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC9517C6B;
	Fri, 12 Jul 2024 17:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804461; cv=none; b=gL48TlqY18tbd9Z9Cy99Ks1egSE+MHiiOm3Zoweogyoan2TSGSsy/QnvIDKcO7Vfy3pWX4x/Vo0XVKygbVJny8kvwjw+aOx3ZjtZ+gU8+rR5+jHEqOUQLQF6ajMzVKcYZlY1PFQxQjeamQBuRg8IxZAHso4ACrhtQqnjwq2gPeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804461; c=relaxed/simple;
	bh=fBPOV7zfczv29qyKM3eLeKNoHsGD5ay/fTO1h4n5yuk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s3Upr92oVVOBYWOh5IzFUoJ3ysz+Zr1TfE6fAsU1vneuhOtLEl1k89P9ZLFgzWIZseoal/ZCH9omCHKioi1QvkPMIBOLpbLwqGhTadKVp1eC76PtRi+7w3vuTGYLeHGZTYfl+rqQkPSi45zKX0JfuGvBzuUqVP4h5o1pwxiq7DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECCDC32782;
	Fri, 12 Jul 2024 17:14:18 +0000 (UTC)
Date: Fri, 12 Jul 2024 13:14:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Vineeth Remanan Pillai
 <vineeth@bitbyteword.org>, Ben Segall <bsegall@google.com>, Borislav Petkov
 <bp@alien8.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, Dave
 Hansen <dave.hansen@linux.intel.com>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar
 <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Mel Gorman
 <mgorman@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner
 <tglx@linutronix.de>, Valentin Schneider <vschneid@redhat.com>, Vincent
 Guittot <vincent.guittot@linaro.org>, Vitaly Kuznetsov
 <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, Suleiman Souhlal
 <suleiman@google.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 himadrics@inria.fr, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 x86@kernel.org, graf@amazon.com, drjunior.org@gmail.com
Subject: Re: [RFC PATCH v2 0/5] Paravirt Scheduling (Dynamic vcpu priority
 management)
Message-ID: <20240712131416.78648a6e@rorschach.local.home>
In-Reply-To: <ZpFjG-seBN33uTP2@google.com>
References: <20240403140116.3002809-1-vineeth@bitbyteword.org>
	<ZjJf27yn-vkdB32X@google.com>
	<CAO7JXPgbtFJO6fMdGv3jf=DfiCNzcfi4Hgfn3hfotWH=FuD3zQ@mail.gmail.com>
	<CAO7JXPhMfibNsX6Nx902PRo7_A2b4Rnc3UP=bpKYeOuQnHvtrw@mail.gmail.com>
	<66912820.050a0220.15d64.10f5@mx.google.com>
	<19ecf8c8-d5ac-4cfb-a650-cf072ced81ce@efficios.com>
	<20240712122408.3f434cc5@rorschach.local.home>
	<ZpFdYFNfWcnq5yJM@google.com>
	<66915ef3.050a0220.72f83.316b@mx.google.com>
	<ZpFjG-seBN33uTP2@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Jul 2024 10:08:43 -0700
Sean Christopherson <seanjc@google.com> wrote:

> > I am a bit confused by your statement Sean, because if a higher prio HOST
> > thread wakes up on the vCPU thread's phyiscal CPU, then a VM-Exit should
> > happen. That has nothing to do with IRQ delivery.  What am I missing?  
> 
> Why does that require hooking VM-Exit?

To do the lazy boosting. That's the time that the host can see the
priority of the currently running task.

-- Steve

