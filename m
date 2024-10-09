Return-Path: <kvm+bounces-28235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D77C9969C8
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 14:18:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33C6B1F24F7A
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 12:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 027CA19307F;
	Wed,  9 Oct 2024 12:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T9bfUcOr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01051922DE
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 12:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728476285; cv=none; b=SM9ynCMlj9dXZm+b4ViQmABirJ0cFDqrq0gA1v3Z7f48frIaREEyG4M3TEwSfeQUJMw+2gHPnv+XLdMyXHtBHmNS7TgUDfzOs6gwgRpDalvrrpIqG7ZwEwMpU7yzq1oiFBecUhgFsu913lkqgErF+nsEbJKnIpsFQ128wA+dqUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728476285; c=relaxed/simple;
	bh=xO8PVvEiGlQrBvLFulZKQ8G4KC8mUhuysrsSdmLti9o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=clAXYcSQWBcOwcv3BXhEp0V1n3phUTrxEFMorGwqzWoncsnMP5Nlgna4bkw9Fxf05fSeoBA56Ptf71xhw2YhGvGKW5ML7DTZMZUdDLZ5ozkCMxSlhUtusu96ow2g0mA9ALoOlrVzOGCOW5QglkxyyHS6lO4oJPgnfQYogh64hWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T9bfUcOr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728476282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i/JCA0HtI9ooTOOvo/GvEfwZsTSm16VZN5tQXZObxsA=;
	b=T9bfUcOrM5kF2f7qM9Xfd4pxfPe7NvwnL3PqaGSzEFLdrZQF2nbWzro3qSUW+YxbTR/Mk9
	nPEH5aok4LazrrrTjLeHitgVjVc+ZPt+JFaBbDGjkU4aHC20qI45NJ19j6MxQ6zGDm4lck
	Baba2ak4S52UYmQOwsd31u39NrQY2o0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-GztTGUfAOG2N_TUkrbsM2g-1; Wed, 09 Oct 2024 08:17:59 -0400
X-MC-Unique: GztTGUfAOG2N_TUkrbsM2g-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-37ce063895cso2885272f8f.0
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 05:17:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728476279; x=1729081079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i/JCA0HtI9ooTOOvo/GvEfwZsTSm16VZN5tQXZObxsA=;
        b=T3Rv3IBaKsLtNzGeU5zx7KUqcX/+IJ1jrU3cwe/i1C/Dn6eiMg467LktQruUvf6UbM
         2KQmI09g1dXV0qCwfkK0Dc/ORSKcHbAzrRPX3hOg4Lb2+5DNvgEwxqcqhLWaogF1cKsd
         C24q9CEEycj2OOXP/C8CoSqvJfAyXKKpj7VioqeGXqbs9vn6XSRcwTWWLi8GALXPpHzj
         x1N19d/LjX9wL156WsK/S6sMS5JltHlvjfbkTk4pZpmfAkI6WW4/2metkUbMpLU6G+X/
         MjI0/1+2rYviNeuf0O8vSrGcGoq0DgGAlXvKtEcgTbJi2npisZIbELvNiOk/4R24iFVX
         0uYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVS259BI2t51eHcbCcqfbNObbFchH8EDss6Zyr/udivugMNLrTHLQXLdy86xkgP5vY3do0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxxu854V1u4MSuI1BGcP9eqdTwRgbezFPd/1W7a4aWvLDKEx5WN
	BHnKMWys+0UR1g/9iogC2yEYgaflm2apz4LhE1uqA9WMYd0Qcu3IhR/Bmjgji9bEGkMGOzOjPeC
	VCCrXrGVUUKsy6OEOHqC7jeqaUbA2dM+xk8W4LN/uutxfsFpnhJ1tUfRxGAml23UA+O1YxPe9W0
	7y5UY8prYJkr8qfJhmKbQKGIvM
X-Received: by 2002:adf:f04a:0:b0:37c:cc01:f7e with SMTP id ffacd0b85a97d-37d3aabccefmr1225538f8f.58.1728476278579;
        Wed, 09 Oct 2024 05:17:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFMtuZgRTBRKHy4TJ6+iqV6ZczH3/cPSGjClk8IPhbXhcnPHARjws9/sXc6usMMhIy/CyG7Pf4yqSXmWSz83kg=
X-Received: by 2002:adf:f04a:0:b0:37c:cc01:f7e with SMTP id
 ffacd0b85a97d-37d3aabccefmr1225526f8f.58.1728476278182; Wed, 09 Oct 2024
 05:17:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <SA1PR10MB7815C826ABBCA3AC3B3F3B12E97D2@SA1PR10MB7815.namprd10.prod.outlook.com>
 <ZwQjUSOle6sWARsr@google.com>
In-Reply-To: <ZwQjUSOle6sWARsr@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 9 Oct 2024 14:17:47 +0200
Message-ID: <CABgObfYWZQc_gnzUAmFQ=McbN4VQxbrd+4vss=pGRdrOAcOcfg@mail.gmail.com>
Subject: Re: KVM default behavior change on module loading in kernel 6.12
To: Sean Christopherson <seanjc@google.com>
Cc: Vadim Galitsin <vadim.galitsyn@oracle.com>, Klaus Espenlaub <klaus.espenlaub@oracle.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 7, 2024 at 8:07=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
> On Mon, Oct 07, 2024, Vadim Galitsin wrote:
> > Would you consider to change the default behavior by having
> > "kvm.enable_virt_at_load=3D0", so people who really need it, could expl=
icitly
> > enable it in kernel command line?
>
> I'm not dead set against it, but my preference would be to force out-of-t=
ree
> hypervisor modules to adjust.  Leaving enable_virt_at_load off by default=
 risks
> performance regressions due to the CPU hotplug framework serially operati=
ng on
> CPUs[1].  And, no offence to VirtualBox or VMware, I care much more about=
 not
> regressing KVM users than I care about inconveniencing out-of-tree hyperv=
isors.
>
> Long term, the right answer to this problem is to move virtualization ena=
bling
> to a separate module (*very* roughly sketeched out here[2]), which would =
allow
> out-of-tree hypervisor modules to co-exist with KVM.  They would obviousl=
y need
> to give up control of CR4.VMXE/VMXON/EFER.SVME, but I don't think that's =
an
> unreasonable ask.

I agree, VMXE/VMXON/SVME are mostly a one-shot thing.

I thought about adding a Kconfig for kvm.enable_virt_at_load, but it
is not really a good solution.  Distros would either leave it to the
default of y and inconvenience VirtualBox/VMware users, or set it to n
and have bad performance on machines with a large number of CPUs. The
problem is that "all distros set it to y" is an unstable equilibrium,
because it may take only one bug report to convince distros to flip
the value.

> Short term, one idea would be to have VirtualBox's module (and others) pr=
epare
> for that future by pinning kvm-{amd,intel}.ko, and then playing nice if V=
MX/SVM
> is already enabled.

Yes, this is a good plan for allowing to work with both old and new KVM.

Alternatively if VirtualBox or VMware have an installer or rpm they
can write a file to /etc/modprobe.d to change the default, which
doesn't require code changes but is not a good idea.

Paolo


