Return-Path: <kvm+bounces-10508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8540386CC2C
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 15:55:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3EFF11F26392
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 14:55:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54406137774;
	Thu, 29 Feb 2024 14:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vmo6mUOv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE1F137747;
	Thu, 29 Feb 2024 14:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709218541; cv=none; b=KVLOXr/BIRyj1gfBdTp64FXcYY+6qVtpAIubIGTJxsQhWdy5qa7pWraDP/fCWRfk6MAKnuTqab3TEmfKuUCu6+QsvKVykFkbFD17VLgDXFKSs9PLCGbNxXfnNVs24OiNPfbfOOum0Xul+NBGmBhynGORv0Y61CkH21W6Gzd2qeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709218541; c=relaxed/simple;
	bh=f+/q7GkH+OaFYxQE4zP/4onFmtutKCNIPD40hxaVN6M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eUe5oEIBej/FPtDqJro4ELoF24A1fbYe8y+3HebWTGp+JQ2i1Nz6Zpb/DsDy1BehOwNJIb4KE8TIT8tbwDLhLJrk9rxyANkrsOmGlAmTEE4dBK9h9YrUgXTk4VnO4yP7eQ916TKr2A4DBzr80IpCkoitom/fGUGf6+l5aZMH/JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vmo6mUOv; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-299b92948a6so657314a91.3;
        Thu, 29 Feb 2024 06:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709218539; x=1709823339; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hP6lzrqapccsF2KLWHw3WzMibJs8TMjgt2szFY2HpXk=;
        b=Vmo6mUOvTOBHWe3SiE4PFklJJMfq+PHEpLSmNz60KQNhhxSxYdvQ1S/qejzK9nK6yz
         EvM3AmsX19suwrI3niBMm/d3npAjSbc0ei4UNCvLYoUa0rWSXDWK05hvkiMbmiDQ7hft
         Xlt71a61wFmUjr5ErHTjZFzVqzEOlR8kuDWY7kAa9KxxK7rIsNrrxUBY4v4Pjp4cN3eR
         5b7a70HxtkERCtU/FQNDf923P0WYX/M5WUSlppxHwCEn9PdmpQPC0SHCzcA+DoYlFyvR
         IIScn2nI2FiD7fcHfumrn5lMtYnQPaDb0GUqtPsMaMwCzkyhQijQBuvaLL2DbHmCzRXO
         sENg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709218539; x=1709823339;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hP6lzrqapccsF2KLWHw3WzMibJs8TMjgt2szFY2HpXk=;
        b=BB4bzkoBXPkA1qfguxy4EjIgCrnKlCcaNhpF9hYjO3BmE51hDn2zFFBxjeu8LI9QZS
         QYPtWTxvRQ7gizXPkF0NGe1iB55PF6PxKJXbWD4yZOXvgs7EPTmGV5pH9m3tVt7DFIqN
         epFUbqPaL4qOAfw4FBJRpvPX5lLzDKEc9PZAPDxSNTmalTOkWM2hqWC2drvX6LthbxUd
         pObDq1an1o+bNLFy9CF1ydi8wL8rFeXrGsSm3JSKgW45XYqwtRkKZzQueP9pFmR6imR5
         2wA0Nbv4WE9KZEK4LTn8bMsxUmoHyp2+lPKpUxSluwIoGO26t3vJZkB8brkz8U4B0nEp
         /y8A==
X-Forwarded-Encrypted: i=1; AJvYcCVAp7ql2XyN0T+rvbBmNmHksFFzN3PSviZhdBECICLNA7pQHu+Rm+x0LsyLeQUWj8Vk89WTwEQ7b7PAiwn8ICwKDiNB
X-Gm-Message-State: AOJu0YywKwiKhbHL7qtOI6iTw+2jpDuNlPNOyANPwZHgWqWym9N1+4DP
	P8eWxP41sxDn15IqGeMtwtSvWuQ2k4NxgWNUTsDlE+3qy/RL00KE0iMSnM0h7sfoCe8vuTNI2Kr
	D8KSDC5ZXQSTROslhW+sLcvVVQuQ=
X-Google-Smtp-Source: AGHT+IEhVLB8oSGlTlLkyrt6KF+P4ZoHNYQMmdL5tHoI8RvPCpSpZVPwG1yKonSyWpwnlhp8XnSUC0GfqgD4tmrthfA=
X-Received: by 2002:a17:90a:4384:b0:29a:feba:abbd with SMTP id
 r4-20020a17090a438400b0029afebaabbdmr2696847pjg.0.1709218539331; Thu, 29 Feb
 2024 06:55:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240226143630.33643-1-jiangshanlai@gmail.com> <CABgObfaSGOt4AKRF5WEJt2fGMj_hLXd7J2x2etce2ymvT4HkpA@mail.gmail.com>
In-Reply-To: <CABgObfaSGOt4AKRF5WEJt2fGMj_hLXd7J2x2etce2ymvT4HkpA@mail.gmail.com>
From: Lai Jiangshan <jiangshanlai@gmail.com>
Date: Thu, 29 Feb 2024 22:55:28 +0800
Message-ID: <CAJhGHyDSHzPPhwaipSbcZXDJ+P3d6-K=ngjk1Ru3DbwzPGuz4Q@mail.gmail.com>
Subject: Re: [RFC PATCH 00/73] KVM: x86/PVM: Introduce a new hypervisor
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <jiangshan.ljs@antgroup.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Ingo Molnar <mingo@redhat.com>, kvm@vger.kernel.org, x86@kernel.org, 
	Kees Cook <keescook@chromium.org>, Juergen Gross <jgross@suse.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello, Paolo

On Mon, Feb 26, 2024 at 10:49=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com=
> wrote:
>
> On Mon, Feb 26, 2024 at 3:34=E2=80=AFPM Lai Jiangshan <jiangshanlai@gmail=
.com> wrote:
> > - Full control: In XENPV/Lguest, the host Linux (dom0) entry code is
> >   subordinate to the hypervisor/switcher, and the host Linux kernel
> >   loses control over the entry code. This can cause inconvenience if
> >   there is a need to update something when there is a bug in the
> >   switcher or hardware.  Integral entry gives the control back to the
> >   host kernel.
> >
> > - Zero overhead incurred: The integrated entry code doesn't cause any
> >   overhead in host Linux entry path, thanks to the discreet design with
> >   PVM code in the switcher, where the PVM path is bypassed on host even=
ts.
> >   While in XENPV/Lguest, host events must be handled by the
> >   hypervisor/switcher before being processed.
>
> Lguest... Now that's a name I haven't heard in a long time. :)  To be
> honest, it's a bit weird to see yet another PV hypervisor. I think
> what really killed Xen PV was the impossibility to protect from
> various speculation side channel attacks, and I would like to
> understand how PVM fares here.

How does the host kernel protect itself from guest's speculation side
channel attacks?

PVM is primarily designed for secure containers like Kata containers,
where safety and security are of utmost importance.

Guests run in the hardware ring3 and they are treated as the same as the
normal user applications in the views of the host kernel's protections
and mitigations. The code employs all of the current protections and
mitigations for kernel/user interactions to host/guest and with extra
protections from pagetable isolation and with protections/mitigations
usually used for host/VTX_or_AMDV_guest (with some similar VM enter/exit
code as in vmx/ svm/). All of these are sorta easily achieved by the
"integral entry" design and "the distinct separation of the address
spaces" design can also help for protections.

How does the guest kernel protect itself from guest users' speculation
side channel attacks?

The code also tries its best to provide all of the current protections
and mitigations between the native kernel/user for virtualized kernel/user.
It is obvious that the PVM virtualized kernel operates in hardware ring3
and you can't expect all methods can be effective. Since the linux kernel
can provide protections for threads switching between different user
processes, PVM can potentially offer similar protections between guest
kernel/user through the PVM hypervisor's support.

I'm not familiar with XENPV's handling and its solutions (including its
impossibility) for the speculation side channel attacks, thus I cannot
provide additional insights or assurances in this context.

PVM is not designed as a general-purpose virtualization. The primary
objective is for secure container and Linux kernel testing. PVM intends
to allow for the universal deployment of Kata Containers inside cloud
VMs leased from any provider over the world.

For Kata containers, the protection between host/guest is much more
important and every container is only for a single tenement in which
the guest kernel is not a TCB of the external container services.
It means the protection requirements between guest kernel/user are
more flexible and customized.


>
> You obviously did a great job in implementing this within the KVM
> framework; the changes in arch/x86/ are impressively small.

Thanks for your appreciation.

> On the
> other hand this means it's also not really my call to decide whether
> this is suitable for merging upstream. The bulk of the changes are
> really in arch/x86/kernel/ and arch/x86/entry/, and those are well
> outside my maintenance area.
>

Thanks
Lai

