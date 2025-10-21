Return-Path: <kvm+bounces-60687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 30D03BF79A9
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 18:14:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8192C4EA149
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 16:14:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A1D2345CC2;
	Tue, 21 Oct 2025 16:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eRqFA7nx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC44E3451C4
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 16:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761063251; cv=none; b=BhfUBKcyHHkLfKNtTYBKo61Y24Ulh9ta9SlUkf4IrQD3ujucMbdFT9oSjLXCE1fxytPVX5WG9p5kxYWIEqq4sLb9YiedwtgD/rgRI+k1H2uj3LKr7FUYag3Bdmy62VWwpsN8pRT02yOOVNQMs9FSnl3ipHylFqM7T7ds2FjoSTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761063251; c=relaxed/simple;
	bh=jwALCPRFruFeYmRfrp9Ri+SEZYzWo8ADyILKji9+IIo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kv6ZFQbz1TMjoYSp9ILSRfQnRTGzRU8VDMdkng1W5KLosR1yLTu9ziCqdnmFjROBoJVH7bT8iWeryp1ir1rwi7KtnMh/4kuM1JYifcTF+EXE9eUzgGa/q4W1L6d3ujP5uzjNBj0uXqB9Fxak0jphA+zMo5ynqfu5phphVJE2rQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eRqFA7nx; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-47101c27c9cso75945e9.0
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 09:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761063247; x=1761668047; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fzW2rY1I2AKLs/LU+wRizdzQ22+SHdlJ/3qusxmFBDE=;
        b=eRqFA7nxiXlxzFYyinrIjOWTfDELwsBV1AoSpBTUDGBy0te9x+pKr07ARmFVjeYxfI
         izlXOK933UZb5MVMGBpJ0ruVHZmx6+cwFAbwGtyVoKu8iUl/TyyCKt00HY2i2apYwgpe
         qRcuVS3SJxTNpJeqSl/JEK2CQOG/eyh7HuxBG0WCQkw5v7X687un532/lAwiCWq+OkjR
         N5dMASSffNPpOlAjMR3tBv0amjaWbC3btwEGFFodZ0qz0QF9VljRtEGmpE8jai/0HuAB
         ANtRKE+yxZmA/jBiE+BfdjV+AXAxcqKgObe/CcATfkxBbS4IJN9Mq1iwKc9673U3fFaX
         1aKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761063247; x=1761668047;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fzW2rY1I2AKLs/LU+wRizdzQ22+SHdlJ/3qusxmFBDE=;
        b=GCqyAbsZztz59HHBeJVxHEKj4d6DOpkR6CkFQ6xA6ye5WOGeY+wE0oexqstbUNL94b
         iuq1VRKNrBXjP+ECfZY9uF47lNs2YwsCh1LMRvXvh47I6u5I0eLDJkdaXF3OynUJq3y4
         yLN7bWO6qHncxzUIaQ6gxaNpwI8+HmK+vLUKStzRBqGgCr8hg61izaBrVC73Fa7L1f9k
         5iA7nyUJkJqWI1QfxuA6WGTKV+hNzffImX4Dj0GbbrJ6ic8UO4aUOTLiRxZDGda4a8dP
         zJc6B/VeBzVPAoBtXS84YycJEFHV+2x1HU1+c0L82N/fkGbBjleC+HxE3wGtwpwSMhbV
         hjCQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4yWLLy6jFLPenqcSeknsaOdnIXkOBG/PO4/E1BEIxoHFWxbB6yWWl4gqpSd+JupcN55U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUv0JGu3US3++h2fvqfmfUSbbq0mmcGmda6OfRFDMY8IGzXXNZ
	2hBI5OY4B35nZozC0imxgkhyfkMYzsPPo+lByAmTLgHYhf9s+vCpPHig3ZILkpypjBn6li99Glj
	nXLfVib3oDIhZnNZ1/AZKWexocsazERBULmXO8Hm9
X-Gm-Gg: ASbGncu3KyFYU53CmIYzf0zAUmCkwAZ4djgffUVUSEMgjRmwn1sf/eJInf8cG8TZzfr
	9dZPoStdg8O7BQ86i6G5PnYbOPRebE30YD/7s3KAEpXAIFW+Q8muD9go02RfoLKJl4aelnFlrj0
	5nebA+uunfn5N9/ZmGCnoN1/kueLjIizP60xqtU3oclGtKbIz5RUHQvmCLqTXg/CatvSm8iJI+e
	9a6kM7ixtUKYlJkxIsZRO+klOZ9z9r9psNkWarWsBwlWpHomBxSCsSyvOdXrFtEFIGJf8s1F7RC
	ShKQgRHZTYcKMYj7
X-Google-Smtp-Source: AGHT+IE14qTEBghQgzjgcliX4306euS6iolIBF3AxWlF2cEnTAIMms5VkABvdFJelKcvqwketyvRe6yUthJZ0L6j/JI=
X-Received: by 2002:a05:600c:8719:b0:46f:aa9f:e345 with SMTP id
 5b1f17b1804b1-47497744bccmr724965e9.7.1761063246555; Tue, 21 Oct 2025
 09:14:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251013185903.1372553-1-jiaqiyan@google.com> <20251013185903.1372553-4-jiaqiyan@google.com>
 <3efcf624-58f1-4390-b6e2-a0aa5e62a9a3@infradead.org>
In-Reply-To: <3efcf624-58f1-4390-b6e2-a0aa5e62a9a3@infradead.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 21 Oct 2025 09:13:55 -0700
X-Gm-Features: AS18NWBrgiqcwjUkY7yriOgg09EsrU9gzSKpZPzp6diSIUTDX5ipeIw05uqw6vQ
Message-ID: <CACw3F53cqiwtGyeJw+baS23sK3byenC8R5ddzW6Q1e_Bzk8tJA@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] Documentation: kvm: new UAPI for handling SEA
To: Randy Dunlap <rdunlap@infradead.org>
Cc: maz@kernel.org, oliver.upton@linux.dev, duenwen@google.com, 
	rananta@google.com, jthoughton@google.com, vsethi@nvidia.com, jgg@nvidia.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	shuah@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2025 at 6:51=E2=80=AFPM Randy Dunlap <rdunlap@infradead.org=
> wrote:
>
>
>
> On 10/13/25 11:59 AM, Jiaqi Yan wrote:
> > Document the new userspace-visible features and APIs for handling
> > synchronous external abort (SEA)
> > - KVM_CAP_ARM_SEA_TO_USER: How userspace enables the new feature.
> > - KVM_EXIT_ARM_SEA: exit userspace gets when it needs to handle SEA
> >   and what userspace gets while taking the SEA.
> >
> > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst | 61 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 61 insertions(+)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/ap=
i.rst
> > index 6ae24c5ca5598..43bc2a1d78e01 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -7272,6 +7272,55 @@ exit, even without calls to ``KVM_ENABLE_CAP`` o=
r similar.  In this case,
> >  it will enter with output fields already valid; in the common case, th=
e
> >  ``unknown.ret`` field of the union will be ``TDVMCALL_STATUS_SUBFUNC_U=
NSUPPORTED``.
> >  Userspace need not do anything if it does not wish to support a TDVMCA=
LL.
> > +
> > +::
> > +             /* KVM_EXIT_ARM_SEA */
> > +             struct {
> > +  #define KVM_EXIT_ARM_SEA_FLAG_GPA_VALID   (1ULL << 0)
> > +                     __u64 flags;
> > +                     __u64 esr;
> > +                     __u64 gva;
> > +                     __u64 gpa;
> > +             } arm_sea;
> > +
> > +Used on arm64 systems. When the VM capability KVM_CAP_ARM_SEA_TO_USER =
is
> > +enabled, a VM exit is generated if guest causes a synchronous external=
 abort
> > +(SEA) and the host APEI fails to handle the SEA.
> > +
> > +Historically KVM handles SEA by first delegating the SEA to host APEI =
as there
> > +is high chance that the SEA is caused by consuming uncorrected memory =
error.
> > +However, not all platforms support SEA handling in APEI, and KVM's fal=
lback
> > +is to inject an asynchronous SError into the guest, which usually pani=
cs
> > +guest kernel unpleasantly. As an alternative, userspace can participat=
e into
>
>                                                                          =
  in
>
> > +the SEA handling by enabling KVM_CAP_ARM_SEA_TO_USER at VM creation, a=
fter
> > +querying the capability. Once enabled, when KVM has to handle the gues=
t
>
>                                                                      gues=
t-
> > +caused SEA, it returns to userspace with KVM_EXIT_ARM_SEA, with detail=
s
> > +about the SEA available in 'arm_sea'.
> > +
> > +The 'esr' field holds the value of the exception syndrome register (ES=
R) while
> > +KVM taking the SEA, which tells userspace the character of the current=
 SEA,
>    KVM takes
>
> > +such as its Exception Class, Synchronous Error Type, Fault Specific Co=
de and
> > +so on. For more details on ESR, check the Arm Architecture Registers
> > +documentation.
> > +
> > +The following values are defined for the 'flags' field
>
> Above needs an ending like '.' or ':'.
> (or maybe "::" depending how it is processed by Sphinx)
>
> > +
> > +  - KVM_EXIT_ARM_SEA_FLAG_GPA_VALID -- the faulting guest physical add=
ress
> > +    is valid and userspace can get its value in the 'gpa' field.
> > +
> > +Note userspace can tell whether the faulting guest virtual address is =
valid
> > +from the FnV bit in 'esr' field. If FnV bit in 'esr' field is not set,=
 the
> > +'gva' field hols the valid faulting guest virtual address.
>
>                holds (or contains)> +
> > +Userspace needs to take actions to handle guest SEA synchronously, nam=
ely in
> > +the same thread that runs KVM_RUN and receives KVM_EXIT_ARM_SEA. One o=
f the
> > +encouraged approaches is to utilize the KVM_SET_VCPU_EVENTS to inject =
the SEA
> > +to the faulting VCPU. This way, the guest has the opportunity to keep =
running
> > +and limit the blast radius of the SEA to the particular guest applicat=
ion that
> > +caused the SEA. Userspace may also emulate the SEA to VM by itself usi=
ng the
> > +KVM_SET_ONE_REG API. In this case, it can use the valid values from 'g=
va' and
> > +'gpa' fields to manipulate VCPU's registers (e.g. FAR_EL1, HPFAR_EL1).
> > +
> >  ::
> >
> >               /* Fix the size of the union. */
> > @@ -8689,6 +8738,18 @@ This capability indicate to the userspace whethe=
r a PFNMAP memory region
> >  can be safely mapped as cacheable. This relies on the presence of
> >  force write back (FWB) feature support on the hardware.
> >
> > +7.45 KVM_CAP_ARM_SEA_TO_USER
> > +----------------------------
> > +
> > +:Architecture: arm64
> > +:Target: VM
> > +:Parameters: none
> > +:Returns: 0 on success, -EINVAL if unsupported.
> > +
> > +This capability, if KVM_CHECK_EXTENSION indicates that it is available=
, means
> > +that KVM has an implementation that allows userspace to participate in=
 handling
> > +synchronous external abort caused by VM, by an exit of KVM_EXIT_ARM_SE=
A.
> > +
> >  8. Other capabilities.
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
>
> --
> ~Randy
>

Thanks for your quick review, Randy. I have queued fixes and am
waiting for reviews on other commits in this PATCH.

