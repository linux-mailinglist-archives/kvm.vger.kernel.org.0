Return-Path: <kvm+bounces-15672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CC648AEA84
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 17:15:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 415361C22559
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 15:15:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAF7413C676;
	Tue, 23 Apr 2024 15:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xtWGkKMm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43C613C672
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 15:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713885324; cv=none; b=gEgouTCL/W2xkaKI0u9FHu8lXq+uqvszjVHdKQqEFFuC1XcrWBlwW5dnWCxYkyoaTZ/wygdEFln22DcbXxAvBxj+FKVHN/itRWGcQMI6Pg29CE8SQ4GzBMXTUAIBYatGM7jstpAvGZ+UE463rqs2tPSOu9TqNqvhj+6ksvDie0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713885324; c=relaxed/simple;
	bh=29mJ2eC3FOIKEQMjH1aipAJXYNklA0kCDubcrgWpjxI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rie1yLZR9eqgNCYCzYe/8QhKgA7+fET8IFCEs/7Iz66t7ZcRdMqe3MgisruGViY13T8c1musFFIkS7QCbUus/y8+5sHuJNAK61T1rVvdrBPC5re6kxOaUtLhgOuuANDe+YVWx4Jo7xsuplzboKaP+WqVzQWWvUeg3t2MbGrpBCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xtWGkKMm; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-6029e614eeeso1536972a12.1
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 08:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713885322; x=1714490122; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uvz589OQSL7BtgJIC3S0S1kNpDPbm+tVW7ZqS1/fwaA=;
        b=xtWGkKMmc8hX2yznug3v6v5NSwmc5r6yM/pV85JKA/xXTIKo/xSUcAIo6PvwXlvVg4
         CXMVozkAWsvIfTGSnL4kLHDurxzg5KdHJR/zmHzqO42pRFr9/I4h5O+BspVoj8MzU8m4
         1mDriOyEjTn2AyKQkL6TtsRdrWsGfRqgsarVHEYDNwmv3OVNoNYvE7xL7wm0sSPJnPqZ
         pNVJZtFBA5lz22gzCBl9miN6Iz4j4H41P81tTp9kN5EeeEfYpiM8kDHpLLJEZa2iSzXj
         NC2TA7uhCK3qRNYPQPLJXLuXQf7XIoY63jOEy38g2i+fpP+EVC7P8ot031ZRYVe4w+vg
         e9lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713885322; x=1714490122;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uvz589OQSL7BtgJIC3S0S1kNpDPbm+tVW7ZqS1/fwaA=;
        b=oCGlbSWnNAb3hYhgUFXBP4uvowPLSh4laeY2Xn8tP3OGcdCuiRdInQkANcI160Q6FG
         /lCsGaaxAr2jeL7KDlCsjeQ+05ZZMhMIQQO86enNcJJgTUOgfgZHQBUElUHrMU6bRJCW
         0Id/hg2n22D/bWGEYzzvp2zuVEE1qxVSoi/CvA4Ly0QqzTDEZpOJJE9xIhpS3G7SBZWt
         UsvVZsfy9/e7uqfe+1Op6fSblx5BTxTY5sdIBXhv/AuMtYeTM3YQduMYx4/xjz6zW7pr
         ayQwiLcCppVJ/9PxMEZtV8u/PMnEGTpkzVVWAw4KL42B4NThbjYTD0ZVqAcjogy1aZio
         iaDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrtEJq6RcpXEz1mDciiJB0uRiQEScAE/p5r6VFhLBXEbwf3Mzt29AINiEg4vkeanyRHsV0jyEV8LEF0gYkMpB9hyCX
X-Gm-Message-State: AOJu0YxTKlXHpjrvov18Svnt2khMsRd80i/xcTEuI15RfWVXV74vbkWv
	tOB/yNLj2cIQ/42IKz6bdQ2J1xk/RTgFfUEgADujywOi9OQ8OaAdGzXz/r3p4tvBeElMQVZcw2K
	0Fg==
X-Google-Smtp-Source: AGHT+IFQMXpWlXAmt1Hjf05oblgz2qzg5pSqCLj2Uj5XW5rbT8TMU9yswMQX+Cl6PHEPZuJ5DFJk2P12+SU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:2b58:0:b0:5e8:57aa:3609 with SMTP id
 r85-20020a632b58000000b005e857aa3609mr42754pgr.9.1713885321995; Tue, 23 Apr
 2024 08:15:21 -0700 (PDT)
Date: Tue, 23 Apr 2024 08:15:20 -0700
In-Reply-To: <d0563f077a7f86f90e72183cf3406337423f41fe.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <5ffd4052-4735-449a-9bee-f42563add778@intel.com>
 <ZiEulnEr4TiYQxsB@google.com> <22b19d11-056c-402b-ac19-a389000d6339@intel.com>
 <ZiKoqMk-wZKdiar9@google.com> <deb9ccacc4da04703086d7412b669806133be047.camel@intel.com>
 <ZiaWMpNm30DD1A-0@google.com> <3771fee103b2d279c415e950be10757726a7bd3b.camel@intel.com>
 <Zib76LqLfWg3QkwB@google.com> <6e83e89f145aee496c6421fc5a7248aae2d6f933.camel@intel.com>
 <d0563f077a7f86f90e72183cf3406337423f41fe.camel@intel.com>
Message-ID: <ZifQiCBPVeld-p8Y@google.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Tina Zhang <tina.zhang@intel.com>, Hang Yuan <hang.yuan@intel.com>, 
	Bo2 Chen <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Erdem Aktas <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 23, 2024, Kai Huang wrote:
> On Tue, 2024-04-23 at 13:34 +1200, Kai Huang wrote:
> > >=20
> > > > > And the intent isn't to catch every possible problem.  As with ma=
ny sanity checks,
> > > > > the intent is to detect the most likely failure mode to make tria=
ging and debugging
> > > > > issues a bit easier.
> > > >=20
> > > > The SEAMCALL will literally return a unique error code to indicate =
CPU
> > > > isn't in post-VMXON, or tdx_cpu_enable() hasn't been done.  I think=
 the
> > > > error code is already clear to pinpoint the problem (due to these p=
re-
> > > > SEAMCALL-condition not being met).
> > >=20
> > > No, SEAMCALL #UDs if the CPU isn't post-VMXON.  I.e. the CPU doesn't =
make it to
> > > the TDX Module to provide a unique error code, all KVM will see is a =
#UD.
> >=20
> > #UD is handled by the SEAMCALL assembly code.  Please see TDX_MODULE_CA=
LL
> > assembly macro:

Right, but that doesn't say why the #UD occurred.  The macro dresses it up =
in
TDX_SW_ERROR so that KVM only needs a single parser, but at the end of the =
day
KVM is still only going to see that SEAMCALL hit a #UD.

> > > There is no reason to rely on the caller to take cpu_hotplug_lock, an=
d definitely
> > > no reason to rely on the caller to invoke tdx_cpu_enable() separately=
 from invoking
> > > tdx_enable().  I suspect they got that way because of KVM's unnecessa=
rily complex
> > > code, e.g. if KVM is already doing on_each_cpu() to do VMXON, then it=
's easy enough
> > > to also do TDH_SYS_LP_INIT, so why do two IPIs?
> >=20
> > The main reason is we relaxed the TDH.SYS.LP.INIT to be called _after_ =
TDX
> > module initialization. =C2=A0
> >=20
> > Previously, the TDH.SYS.LP.INIT must be done on *ALL* CPUs that the
> > platform has (i.e., cpu_present_mask) right after TDH.SYS.INIT and befo=
re
> > any other SEAMCALLs.  This didn't quite work with (kernel software) CPU
> > hotplug, and it had problem dealing with things like SMT disable
> > mitigation:
> >=20
> > https://lore.kernel.org/lkml/529a22d05e21b9218dc3f29c17ac5a176334cac1.c=
amel@intel.com/T/#mf42fa2d68d6b98edcc2aae11dba3c2487caf3b8f
> >=20
> > So the x86 maintainers requested to change this.  The original proposal
> > was to eliminate the entire TDH.SYS.INIT and TDH.SYS.LP.INIT:
> >=20
> > https://lore.kernel.org/lkml/529a22d05e21b9218dc3f29c17ac5a176334cac1.c=
amel@intel.com/T/#m78c0c48078f231e92ea1b87a69bac38564d46469
> >=20
> > But somehow it wasn't feasible, and the result was we relaxed to allow
> > TDH.SYS.LP.INIT to be called after module initialization.
> >=20
> > So we need a separate tdx_cpu_enable() for that.

No, you don't, at least not given the TDX patches I'm looking at.  Allowing
TDH.SYS.LP.INIT after module initialization makes sense because otherwise t=
he
kernel would need to online all possible CPUs before initializing TDX.  But=
 that
doesn't mean that the kernel needs to, or should, punt TDH.SYS.LP.INIT to K=
VM.

AFAICT, KVM is NOT doing TDH.SYS.LP.INIT when a CPU is onlined, only when K=
VM
is loaded, which means that tdx_enable() can process all online CPUs just a=
s
easily as KVM.

Presumably that approach relies on something blocking onlining CPUs when TD=
X is
active.  And if that's not the case, the proposed patches are buggy.

> Btw, the ideal (or probably the final) plan is to handle tdx_cpu_enable()
> in TDX's own CPU hotplug callback in the core-kernel and hide it from all
> other in-kernel TDX users. =C2=A0
>=20
> Specifically:
>=20
> 1) that callback, e.g., tdx_online_cpu() will be placed _before_ any in-
> kernel TDX users like KVM's callback.
> 2) In tdx_online_cpu(), we do VMXON + tdx_cpu_enable() + VMXOFF, and
> return error in case of any error to prevent that cpu from going online.
>=20
> That makes sure that, if TDX is supported by the platform, we basically
> guarantees all online CPUs are ready to issue SEAMCALL (of course, the in=
-
> kernel TDX user still needs to do VMXON for it, but that's TDX user's
> responsibility).
>=20
> But that obviously needs to move VMXON to the core-kernel.

It doesn't strictly have to be core kernel per se, just in code that sits b=
elow
KVM, e.g. in a seperate module called VAC[*] ;-)

[*] https://lore.kernel.org/all/ZW6FRBnOwYV-UCkY@google.com

> Currently, export tdx_cpu_enable() as a separate API and require KVM to
> call it explicitly is a temporary solution.
>=20
> That being said, we could do tdx_cpu_enable() inside tdx_enable(), but I
> don't see it's a better idea.

It simplifies the API surface for enabling TDX and eliminates an export.

