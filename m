Return-Path: <kvm+bounces-14789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 795F98A6F86
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 17:17:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 197A11F22182
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 15:17:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAE26130AE6;
	Tue, 16 Apr 2024 15:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ku+pcSFE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D511304B9
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 15:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713280663; cv=none; b=tyyws7Tfe2yADgBVd4OxX8WxGgiJiDwwIA34LUlCPuh6oyiVkxIVsYlLWX3GAAUbrNc7qJCCjDXQ15ptIaVJS2OmVrJEmyAUWAdLoR5AHIVdk2rB+f7rnZD6H7AFPVGSRXcZ72xoGwp08w23hl0UM7/kIyMZoEk+aOBo1DnuhHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713280663; c=relaxed/simple;
	bh=go1vbmHvk0Pb3VqNEc0jmnUBOnnVGwgjoeuYYNxHqa8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VvQWT4EpQalG9btLmFD1/uJtcZ2WEBrFLOOZt1+1ExyH/cGRePEVwdexqFEc4bzv0rQU5RQK/EkDzQIfI7D8iuESBqMStLzKxhgKAfV650TmwAoc1MIec6fbOZ24PPq2JIknEEhSb/VX/xLdwxqKkK6OoERjQLTZKg9R51HwOGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ku+pcSFE; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6183c4a6d18so67023917b3.3
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 08:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713280661; x=1713885461; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V3zj9QBfDL8j06rkJRFV/Dgsq0KfXCXS2xUHTpdOQOY=;
        b=Ku+pcSFEqy343Mq4j2sk4SHNWQBaCoCzMmf7u9YqS8VvrEe9wZZalcR35aNIuBBXlV
         K2jg58ZDly0+tM86HAoCJSL/KdomW4KLhLnpeTTm0v7tjAQPV8fn9m20wKTFC+F+XtQb
         l4Oa8AZSbybSjaL6p/MZxx6kSMhwtsLK0gxFjYT8xfmC4x+LAXUKkCyEmPM6KjaRvtXo
         SDtbH4HekpTtd1ybNPz6DqtuXogU8xmUOxBW14IktSglLGsXJ594cZgGTR28G47hCg+U
         SqpYTNvz8A2KzMMa0T3ZXwUsyy6Sy8trOrNAFyoXeQFgbgaGHf1/4YsDs1ELHndtHyVF
         P6vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713280661; x=1713885461;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V3zj9QBfDL8j06rkJRFV/Dgsq0KfXCXS2xUHTpdOQOY=;
        b=j43coup4A8QY1ey4TnjOg8orFxGk/d0ps+O5Na8/In/rNIPE4000ruBK08G2oi3V/C
         BY+kQCTe2MZGsIb98xHPMKstnWbWAN0TI+P5fDIDggQy7O+uZMsA7hX+mAbn4uoD1kmb
         L3x/kveciX7ONUotnZJ9VuYXIf2itRkQ0XR8UkMapCdrqWZ/h/VgtJSsz6d4kSAS86Aj
         /dYpTVDHF4rxjJo3rNox/5Qih/85/46Y6/y1D03xUXcI/Xs693EVhTgerFlilJGrHR6h
         k3PW6+1iFrURkI7ETZMpxNU8fwLHWWXX6nnaKyxS0IL9v1TB/KZMhJ5i/QKgomm3Y2/i
         PRMA==
X-Forwarded-Encrypted: i=1; AJvYcCUbz7xp3v1zAKIOjQ5fofUwaEtqi9HzeNf55MPpZH0qqrUkDFYgLpNcovQ2kNEGQ3i6X3UBqcVI/Fm8gsZRkGZXKlFp
X-Gm-Message-State: AOJu0YwDwgFtJIgtz/HnEp/8W5b+lMubcJS4SSz1LlJOHH4uRlJIsE2R
	IoWTtL5TfU6JC+g9JwFZSTJv0/0SCKwlHf6W5jXrRKiyLtlVQliN771E7ujnDDZnwJkN+S8wOML
	9bQ==
X-Google-Smtp-Source: AGHT+IHhRRb/O7U6wXqexpWPYdtot54ZdSme3vhOv+FN5wOtJOPUl+Sk8EtCPMwpGvcltsmeb9wmmXjCJvU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:ea09:0:b0:61a:cec3:e348 with SMTP id
 t9-20020a0dea09000000b0061acec3e348mr1389646ywe.8.1713280661544; Tue, 16 Apr
 2024 08:17:41 -0700 (PDT)
Date: Tue, 16 Apr 2024 08:17:40 -0700
In-Reply-To: <ecb314c53c76bc6d2233a8b4d783a15297198ef8.camel@cyberus-technology.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240416123558.212040-1-julian.stecklina@cyberus-technology.de>
 <Zh6MmgOqvFPuWzD9@google.com> <ecb314c53c76bc6d2233a8b4d783a15297198ef8.camel@cyberus-technology.de>
Message-ID: <Zh6WlOB8CS-By3DQ@google.com>
Subject: Re: [PATCH 1/2] KVM: nVMX: fix CR4_READ_SHADOW when L0 updates CR4
 during a signal
From: Sean Christopherson <seanjc@google.com>
To: Thomas Prescher <thomas.prescher@cyberus-technology.de>
Cc: Julian Stecklina <julian.stecklina@cyberus-technology.de>, 
	"x86@kernel.org" <x86@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 16, 2024, Thomas Prescher wrote:
> Hi Sean,
>=20
> On Tue, 2024-04-16 at 07:35 -0700, Sean Christopherson wrote:
> > On Tue, Apr 16, 2024, Julian Stecklina wrote:
> > > From: Thomas Prescher <thomas.prescher@cyberus-technology.de>
> > >=20
> > > This issue occurs when the kernel is interrupted by a signal while
> > > running a L2 guest. If the signal is meant to be delivered to the L0 =
VMM,
> > > and L0 updates CR4 for L1, i.e. when the VMM sets KVM_SYNC_X86_SREGS =
in
> > > kvm_run->kvm_dirty_regs, the kernel programs an incorrect read shadow
> > > value for L2's CR4.
> > >=20
> > > The result is that the guest can read a value for CR4 where bits from=
 L1
> > > have leaked into L2.
> >=20
> > No, this is a userspace bug.=C2=A0 If L2 is active when userspace stuff=
s
> > register state, then from KVM's perspective the incoming value is L2's
> > value.=C2=A0 E.g.  if userspace *wants* to update L2 CR4 for whatever r=
eason,
> > this patch would result in L2 getting a stale value, i.e. the value of =
CR4
> > at the time of VM-Enter.
> >=20
> > And even if userspace wants to change L1, this patch is wrong, as KVM i=
s
> > writing vmcs02.GUEST_CR4, i.e. is clobbering the L2 CR4 that was progra=
mmed
> > by L1, *and* is dropping the CR4 value that userspace wanted to stuff f=
or
> > L1.
> >=20
> > To fix this, your userspace needs to either wait until L2 isn't active,=
 or
> > force the vCPU out of L2 (which isn't easy, but it's doable if absolute=
ly
> > necessary).
>=20
> What you say makes sense. Is there any way for
> userspace to detect whether L2 is currently active after
> returning from KVM_RUN? I couldn't find anything in the official
> documentation https://docs.kernel.org/virt/kvm/api.html
>=20
> Can you point me into the right direction?

Hmm, the only way to query that information is via KVM_GET_NESTED_STATE, wh=
ich is
a bit unfortunate as that is a fairly "heavy" ioctl().

