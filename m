Return-Path: <kvm+bounces-50124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 48323AE200F
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 18:26:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0E724A7105
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 16:26:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3786E2E612B;
	Fri, 20 Jun 2025 16:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yBuoA83M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D622DFA57
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 16:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750436781; cv=none; b=BvQeQJN2QGVJVHEjba3SWQHWVYWGPaGk5thYabc1tJB+LO/JIHPKvYLgi+rRkDQslZiTVz361aXwM/KrFZOih/TVusw+brwQApb42esE3hLzQi2Buj1eNLx6Zy5AjKJ72re9mVTivVhIImJfM55xn8YEAnajODbb3cHN3cGQPVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750436781; c=relaxed/simple;
	bh=GmbeS99lMZb32yLusCYzKg0Hsx2vlzLyFSD34r6Dsx8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cTT8cXlN8YZsL6YYOMyMulbLy4fbtY/f0PXlRuHoFwy8cUwfic5+QtbhM8wz6D8MxUowagZasZ4r8aP+iCCx0F/NHBMcT94Z0TuQ2BIb8Y91e/+zkNxHYEXuZNyobuFZaBYTLP5+16ST0VH3T3If2rJ2M70paP+i9E/2DBik0q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yBuoA83M; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3122368d82bso2780990a91.0
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 09:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750436778; x=1751041578; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ohXTG1F8q+sZIWE5T3UCXkFHYvD6TwygvwiXK1MWjtQ=;
        b=yBuoA83MeQzMBdGtlT29OOOJSRBBU+vQlJ1LOjJwsQE7bZPVhFLoWRg75cnmO1o9F0
         h/q1Ub10SqA2F9g/tLsNadZCurFfuBmNVh182H/pNowR0vpfx7XcYIijniIa0SdBTdFM
         BRVJhoY6wksm+5lRh43YxbFBE2Ftk6gsOrsZWsk/p9QZnMLPpFdOgUmXYd5d+oLvGTux
         FFSJJBYiczLuoBCZhKYuOAEOyFG2ZHr3nYcI4x8FbPCr/9kscMIyxGLtT1XYCFFgbGvR
         cwDyrNBTdDpd792he+lq8fjc0cgO9Eoq92sZm/6yNc2RNi6Fg1mfKR5N05y1BPJrhOqN
         9erA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750436778; x=1751041578;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ohXTG1F8q+sZIWE5T3UCXkFHYvD6TwygvwiXK1MWjtQ=;
        b=Bb1b+rsvCPH1cPLVcEzk9x7uCD9KgAv4LcoYtxtV20YnSaChFH9AkecSKTuH9K4BDR
         55DCDQf0kNMyW+LmQRl4S7KpTUbug5a9gI9R2dUC8/+YmZImJwraON8USWSrOdvUtdP2
         k6p08XeQIWpw5NFULg4hDkxNqCdOE2ZV8k8Tu59Q+RjYqKWa49/triHhoww8ikRpb7Yw
         CU5nUkZj+7hM3fosX1IYNmsV7lcrm1sn19lHrN7ehjOq326rEl+m9YnWg56fWYFDM2Kz
         KmlkFaULq9wiFpf2KUnqcW6imtp9a2V7/ymp6YDCh+9k4+205pSBkomDnRnzj4jpWbhe
         xXEg==
X-Forwarded-Encrypted: i=1; AJvYcCXs0qw/FSGS7ZlGOhYR8Pqa/Oec2QaM83D861cd/cr76rAJcD8+QmQwDmWukqm8amtEqdI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh/4BH4UGkkHE8lMBaNo+iKaDJozsVbt3t7wuznt/HGLMn0gho
	7IgBR/jvHnIHZ39dZo4966tvmGulvSuWbsxPHcrvl+M6NejSA2AWdoF74nsQe2N/Mi7+g6GXfep
	+VKPpgA==
X-Google-Smtp-Source: AGHT+IHSI33VZnJrVN5GSWOeOURBcD463SXHD2uLeqoTFyAZmRsAQZBnIblvyZ5jUZEP7pAHfN+WFTdx7sg=
X-Received: from pjbpb15.prod.google.com ([2002:a17:90b:3c0f:b0:2ef:d283:5089])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:574d:b0:312:e51c:af67
 with SMTP id 98e67ed59e1d1-3159d6267eamr5679524a91.1.1750436778221; Fri, 20
 Jun 2025 09:26:18 -0700 (PDT)
Date: Fri, 20 Jun 2025 09:26:16 -0700
In-Reply-To: <CAGtprH-an308biSmM=c=W2FS2XeOWM9CxB3vWu9D=LD__baWUQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611095158.19398-1-adrian.hunter@intel.com>
 <20250611095158.19398-2-adrian.hunter@intel.com> <CAGtprH_cpbPLvW2rSc2o7BsYWYZKNR6QAEsA4X-X77=2A7s=yg@mail.gmail.com>
 <e86aa631-bedd-44b4-b95a-9e941d14b059@intel.com> <CAGtprH_PwNkZUUx5+SoZcCmXAqcgfFkzprfNRH8HY3wcOm+1eg@mail.gmail.com>
 <0df27aaf-51be-4003-b8a7-8e623075709e@intel.com> <aFNa7L74tjztduT-@google.com>
 <4b6918e4-adba-48b2-931c-4d428a2775fc@intel.com> <aFVvDh7tTTXhX13f@google.com>
 <CAGtprH-an308biSmM=c=W2FS2XeOWM9CxB3vWu9D=LD__baWUQ@mail.gmail.com>
Message-ID: <aFWLqOd7Kln67h1N@google.com>
Subject: Re: [PATCH V4 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
From: Sean Christopherson <seanjc@google.com>
To: Vishal Annapurve <vannapurve@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kirill.shutemov@linux.intel.com, 
	kai.huang@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, 
	isaku.yamahata@intel.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 20, 2025, Vishal Annapurve wrote:
> On Fri, Jun 20, 2025 at 7:24=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > > > The problem is that setting kvm->vm_dead will prevent (3) from succ=
eeding.  If
> > > > kvm->vm_dead is set, KVM will reject all vCPU, VM, and device (not =
/dev/kvm the
> > > > device, but rather devices bound to the VM) ioctls.
> > >
> > > (3) is "Close the older guest memfd handles -> results in older VM in=
stance cleanup."
> > >
> > > close() is not an IOCTL, so I do not understand.
> >
> > Sorry, I misread that as "Close the older guest memfd handles by deleti=
ng the
> > memslots".
> >
> > > > I intended that behavior, e.g. to guard against userspace blowing u=
p KVM because
> > > > the hkid was released, I just didn't consider the memslots angle.
> > >
> > > The patch was tested with QEMU which AFAICT does not touch  memslots =
when
> > > shutting down.  Is there a reason to?
> >
> > In this case, the VMM process is not shutting down.  To emulate a reboo=
t, the
> > VMM destroys the VM, but reuses the guest_memfd files for the "new" VM.=
  Because
> > guest_memfd takes a reference to "struct kvm", through memslot bindings=
, memslots
>=20
> guest_memfd takes a reference on the "struct kvm" only on
> creation/linking, currently memslot binding doesn't add additional
> references.

Oh yeah, duh.

> Adrian's suggestion makes sense

+1.  It should also be faster overall (hopefully notably faster?).

> and it should be functional but I am running into some issues which likel=
y
> need to be resolved on the userspace side. I will keep this thread update=
d.
>=20
> Currently testing this reboot flow:
> 1) Issue KVM_TDX_TERMINATE_VM on the old VM.
> 2) Close the VM fd.
> 3) Create a new VM fd.
> 4) Link the old guest_memfd handles to the new VM fd.
> 5) Close the old guest_memfd handles.
> 6) Register memslots on the new VM using the linked guest_memfd handles.
>=20
> That being said, I still see the value in what Sean suggested.
> " Remove vm_dead and instead reject ioctls based on vm_bugged, and simply=
 rely
>     on KVM_REQ_VM_DEAD to prevent running the guest."
>=20
> This will help with:
> 1) Keeping the cleanup sequence as close as possible to the normal VM
> cleanup sequence.
> 2) Actual VM destruction happens at step 5 from the above mentioned
> flow, if there is any cleanup that happens asynchronously, userspace
> can enforce synchronous cleanup by executing graceful VM shutdown
> stages before step 2 above.
>=20
> And IIUC the goal here is to achieve exactly what Sean suggested above
> i.e. prevent running the guest after KVM_TDX_TERMINATE_VM is issued.

Ya, I still like the idea.  But given that it's not needed for KVM_TDX_TERM=
INATE_VM,
it can and should be posted/landed separately.

