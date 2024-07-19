Return-Path: <kvm+bounces-21958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01F99937B99
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 19:31:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1F59281884
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 17:31:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B06CE146A99;
	Fri, 19 Jul 2024 17:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TsXPnnJq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880A1DDB2
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 17:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721410254; cv=none; b=dbUJtljG/8tEknT5OPXP4Tcbj1QjBl0b83yK7pH3jDNClpkOxmOUd0XdN/oXvk2ntoFgcP0VTHIReBGX+EjzbhSSepd3xeFxpOTVFkWKYDnBMJ4e9VkrGrvu9Pdc4d4I2iIn20jeUAs8wjflajFQ/5pRIf2ORJSgLfiksVyJnqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721410254; c=relaxed/simple;
	bh=GMspW2YoqcOva052wx35RklyGV4RoHqvWFzeKJ1omDE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cO4GwAYzggNTjTIkbZSeP6x4kARMuoxWpdqDzwASIqZM60bL83qcXlh6nsacI3ryH9RZiSMfwXFQ4aFUo9i5BKJEg3YfRvqZZlw6/Q4P36UxN8hJ+iLoUZqM+sxVap7/YeLS7oP12WF0c8Vz8GkdrW5jC9JGgLCHTatCWiJqPIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TsXPnnJq; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0353b731b8so5084648276.2
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 10:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721410252; x=1722015052; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gP6+VmSPHcYMxQS0JnsLJu5q9rtZVq5bNy3SOvLjfEg=;
        b=TsXPnnJqssPQQtvLTq+m6Rg0ZKhHaX5iojv7v0L3gQUFGumjZL5QBTAtDhzDoBnm06
         RvJo+bJI06KWzj115NsGOVxAFGEXT3Y1X5owMus1xusaQLEdJ55MOmDHi7MFH+0heBsW
         x7lUnVi/ulfLA7haXlGCFPAFWzhZAR/svZgH6timYOddZPkhVC9KkORF2lZcSqcYCb6j
         7dNZGzurgSFAFV7QpFxsLaVosW/9XkUWVVGmMFN1wvt61OcNsfIRzwZTkn3Msr5L1V7j
         owMYEUK20D+YuN3SiK95UesjbozJ8hszDn+nLKTg0m6PWS+pMOxL8ZwkFj0aM+Xr5Ns7
         t3pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721410252; x=1722015052;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gP6+VmSPHcYMxQS0JnsLJu5q9rtZVq5bNy3SOvLjfEg=;
        b=NNpf1T1IH6VwBHKNHHac4j0O9trzRpbtPhnqvBTLl2/72lsFPDn3TdBzfO7xIU8tsq
         +AMAmINLMWNr7f/P6izyEFTO2gCACSo2kN5iXsSfd+cB5PfipX0RHp0airw5N1BDZSla
         xhbhrIoc2NLpteJwBACKZfG0RF8VDP27xpkbWAwCHeyzLrd0/EUtB7dbQvE5P+vIbpDT
         kYuuxPqkeh7WTYtaKijYfV5GjTqb/ZyFU2tqWPlugI/pndFXN3jMxEfELGKGNqWwanuH
         3+uCS3SMC/qd4IKa19TA/Gdq9ml4+dJ/ozqh40arhy2OeswHht33KpBTfjPch5VrujaR
         i4qA==
X-Gm-Message-State: AOJu0Yz7ZFF7SNza8emQfFCfeY+rvDPi+CUHlSjIM7YK9CPcTVmd8Zn+
	mQrdkosK1Ze5nCgyIO7ZFioqfSeKXjHSox9arLS5uCU8PaXOd4Fd1P8UnbwR3/7GBPYTkFyij7g
	yBA==
X-Google-Smtp-Source: AGHT+IF8y/u83nNvL3CbDE2OIMPQWlC17/lwUgB7FErVL+rh23Nj07seTNkwISxUuE1vxNR+9m/V/KKNbRc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1891:b0:e03:2217:3c8f with SMTP id
 3f1490d57ef6-e086fe4020amr908276.2.1721410252464; Fri, 19 Jul 2024 10:30:52
 -0700 (PDT)
Date: Fri, 19 Jul 2024 10:30:51 -0700
In-Reply-To: <7b47f4b7-eda8-40e2-883c-6d6c539a4649@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <7b47f4b7-eda8-40e2-883c-6d6c539a4649@gmail.com>
Message-ID: <ZpqiyxAuobYjkjC-@google.com>
Subject: Re: [BUG] 6.10 stable: =?utf-8?Q?arch=2Fx8?= =?utf-8?Q?6=2Fkvm=2Fxen=2Ec=3A1486=3A44=3A_error=3A_use_of_uninitialized_?=
 =?utf-8?B?dmFsdWUg4oCYcG9ydOKAmQ==?= [CWE-457]
From: Sean Christopherson <seanjc@google.com>
To: Mirsad Todorovac <mtodorovac69@gmail.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, 
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 19, 2024, Mirsad Todorovac wrote:
> Hi, all,
>=20
> While building stable tree version of 6.10, the following error occurred:
>=20
> In line 1421 defines:
>=20
> 1421        evtchn_port_t port, *ports;
>=20
> The ports becomes &port in line 1470, but neither port nor *ports is assi=
gned a value
> until line 1486 where port is used:
>=20
> 1485         if (sched_poll.nr_ports =3D=3D 1)
> 1486 =E2=86=92               vcpu->arch.xen.poll_evtchn =3D port;
>=20
> The visual inspection proves that the compiler is again right (GCC 12.3.0=
).

Nope, the compiler is wrong.  If sched_poll.nr_ports > 0, then kvm_read_gue=
st_virt()
will fill ports[sched_poll.nr_ports].  If kvm_read_guest_virt() fails to do=
 so,
it will return an error and the above code will never be reached.

	if (kvm_read_guest_virt(vcpu, (gva_t)sched_poll.ports, ports,
				sched_poll.nr_ports * sizeof(*ports), &e)) {
		*r =3D -EFAULT;
		return true;
	}

