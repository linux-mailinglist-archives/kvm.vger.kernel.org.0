Return-Path: <kvm+bounces-12706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEB8588C858
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 17:00:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7579F301F18
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 16:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8D7B13C9A7;
	Tue, 26 Mar 2024 15:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZEjR9Arw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6337C2574B
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 15:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711468778; cv=none; b=qvN2ZDTVunnvVTv2DAKT55Z8COaTBlueybpWsQZtD9Z+obxqEMDxdpnGqFXqX9AhwPrM1ZbB8+cwayVHe7Rl5EzLzxR9Yoi8dBbbPImB2w2TnC+JPejsnK799B+G7qBpS3MMavz7jNZCY9E8vmgY7Dh9FZh3GewtChDEhyNisl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711468778; c=relaxed/simple;
	bh=Ynl1v8gS98gAwGFyFLKby7KV+b8y8whJ/pPgiYiDqbY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BPaXi6X3DajQ3KT7qtCAqLcu3r4RWMlb6/g03Fxp5qPpCBxnDd0wIQV1P7wYx6fcRkDbB40lGC1BMnnPQSDm4/bIDlTN8VdJs87JAmRQX/6g1RjcuqgfRLFvUoOu4E41SbkLe3kXCRjjNZ0Nx7TazugUEaBCLPFzaAysJ3sCSps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZEjR9Arw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711468775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jQ8clIjXc4soz7eWewvwlvASClEQyBetLO4fGly13aQ=;
	b=ZEjR9Arw10ZyhaO84/a60ZB29IAa+Nex1uYjVuNGO4RZ7cHzzZwW6ISRpOMSawzR0jjxib
	u23CGEctPVC0HvSPPwiTLzTg2BG7QKUixJDqYYTui5eJThCv50klhJa+TydGrPEcvZo4Qv
	dQaqe6QoZWV8ND4iH7mH//RIpikoK9I=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-574-XOgYxqm1P-erukA9CG4g-Q-1; Tue, 26 Mar 2024 11:59:33 -0400
X-MC-Unique: XOgYxqm1P-erukA9CG4g-Q-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-22a1bb369f8so2657967fac.2
        for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 08:59:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711468773; x=1712073573;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jQ8clIjXc4soz7eWewvwlvASClEQyBetLO4fGly13aQ=;
        b=aOWOPtVYpU7dEEDav3Qv5s9NvkOFcp4Sz7w3dNOgIYPaL5Vn/cvNYo8PbY6WfQmXyd
         cGKhwuy+P6B1hLdNAzfyR7cOAJ2bFyE8rS7jJtNpRiCc/zbVvIN9N5lcBwq2xt8vXnsp
         V050tnScvrYD5zxVN8ZG+wO626+wA+SbfasBrOmZA/QPOV2gLLXpojKyR47CeD1FmQYY
         flSqHWXKOylcGAJjutdz0j7ztjDbPk3escZMzO0NgWFGhK7rcEY5/FmU69yiLyl6os+f
         BGGnERME8hpjgi2pyOqL8Kq/qUWu+SSPYiu7jS/H4RkXlExsfdoS7B8Kk3E8TB3kiKZG
         yhUQ==
X-Gm-Message-State: AOJu0Yw20wn1rhsXdhm9KpHw5KohL6rFq7ltBuzfdK63CsFJi0nH/FkC
	/ex1/1nJSSDvIp+X1+SojjZGMkl+91k8dKVLSJ68rHCGZXMMEB+6u3QwEJlc3XTmYdnzNnNMvDE
	COdT2VKdAOCmOvjgi/bHof0qsugsBlJlmkQs1Nc720ahVMxSYmw==
X-Received: by 2002:a05:6871:2b0e:b0:222:5ff6:43f1 with SMTP id dr14-20020a0568712b0e00b002225ff643f1mr1841639oac.16.1711468772800;
        Tue, 26 Mar 2024 08:59:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgzBoNk7aHkGsNEwNVhcEMsbOfldxjSZnKhmacfHPBzgsBueev9oXHbaC3XghCk7h6QPy9yA==
X-Received: by 2002:a05:6871:2b0e:b0:222:5ff6:43f1 with SMTP id dr14-20020a0568712b0e00b002225ff643f1mr1841604oac.16.1711468772497;
        Tue, 26 Mar 2024 08:59:32 -0700 (PDT)
Received: from [192.168.8.125] ([173.34.154.202])
        by smtp.gmail.com with ESMTPSA id fv24-20020a05622a4a1800b00430dbd6edf9sm3788120qtb.68.2024.03.26.08.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 08:59:32 -0700 (PDT)
Message-ID: <22be7d6156e38dfba1a055cc3e9cc3d10de75dbb.camel@redhat.com>
Subject: Re: [PATCH 0/5] AVIC bugfixes and workarounds
From: mlevitsk@redhat.com
To: Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, Suravee
 Suthikulpanit <suravee.suthikulpanit@amd.com>, Thomas Gleixner
 <tglx@linutronix.de>, Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
 Robin Murphy <robin.murphy@arm.com>,  iommu@lists.linux.dev, Ingo Molnar
 <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>, Sean Christopherson
 <seanjc@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Date: Tue, 26 Mar 2024 11:59:30 -0400
In-Reply-To: <CALMp9eSSCUSOpP64Ho16sU6iV1urbjfTafJ0nThAWGHE6oOkLw@mail.gmail.com>
References: <20230928150428.199929-1-mlevitsk@redhat.com>
	 <CALMp9eSSCUSOpP64Ho16sU6iV1urbjfTafJ0nThAWGHE6oOkLw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-3.fc36) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-03-25 at 20:15 -0700, Jim Mattson wrote:
> > On Thu, Sep 28, 2023 at 8:05=E2=80=AFAM Maxim Levitsky <mlevitsk@redhat=
.com> wrote:
> > > >=20
> > > > Hi!
> > > >=20
> > > > This patch series includes several fixes to AVIC I found while work=
ing
> > > > on a new version of nested AVIC code.
> > > >=20
> > > > Also while developing it I realized that a very simple workaround f=
or
> > > > AVIC's errata #1235 exists and included it in this patch series as =
well.
> > > >=20
> > > > Best regards,
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Maxim Levitsky
> >=20
> > Can someone explain why we're still unwilling to enable AVIC by
> > default? Have the performance issues that plagued the Rome
> > implementation been fixed? What is AMD's guidance?
> >=20
Hi

This is what I know:

Zen1:
	I never tested it, so I don't know how well AVIC works there and if it has=
 any erratas.

Zen2:
	Has CPU errata in regard to IPI virtualization that makes it unusable in p=
roduction,
 	but if AVIC's IPI virtualization (borrowing the Intel term here) is disab=
led,
	then it works just fine and 1:1 equivalent to APICv without IPI.

	I posted patches for this several times, latest version is here, it still =
applies I think:
	https://lkml.iu.edu/hypermail/linux/kernel/2310.0/00790.html

Zen3:
	For some reason AVIC got disabled by AMD in CPUID. It is still there thoug=
h and force_avic=3D1 kvm_amd option
	can make KVM use it and AFAIK it works just fine.

	It is possible that it got disabled due to Zen2 errata that is fixed on Ze=
n3,
	but maybe AMD wasn't sure back then that it will be fixed or it might be d=
ue to performance issues with broadcast
	IPIs which I think ended up being a software issue and was fixed a long ti=
me ago.

Zen4+
	I haven't tested it much, but AFAIK it should work out of the box. It also=
 got x2avic mode which allows
	to use AVIC with VMs that have more that 254 vCPUs.

IMHO if we merge the workaround I have for IPI virtualization and make IPI =
virtualization off for Zen2
(and maybe Zen1 as well), then I don't see why we can't make AVIC be the de=
fault on.

Best regards,
	Maxim Levitsky



