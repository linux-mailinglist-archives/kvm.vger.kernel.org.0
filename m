Return-Path: <kvm+bounces-27610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2D9F988150
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 11:28:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 693AA281D42
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 09:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B01901BAECB;
	Fri, 27 Sep 2024 09:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R6XRD+Tt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C8F249F5
	for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 09:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727429327; cv=none; b=kpvV8Lj6LXLKFoYqGcJxTUtJTT42wSAT9KUFxmXx22dpNfdsVbrEF5C7qaFE0x3lDZsuNzd8ZRBSHWBv4gZzgKKTG4pWDkWa7KCqsG0cN2jmBlLoEQSIVGARI3OeQT8Ps83KuhIW1x8JjD1d2B+nASeEIFoaer8mgnCPBnbo4WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727429327; c=relaxed/simple;
	bh=+pxSowBNVtkt3eTXjUHPSm5hLFAYtuFRhcjjuTiSGUM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OO3w/APIx7JkprYJWbFt5q3vlu5Dan/q++tlq3MnVfU6kD3tACo4LkDi+/3jISIB4PQGHNgRdjTKaiiCEmL38RegvLcDi7QqxO+3SDl3pLzH4c+TzUPImkz1aYdMT54+yH+CjT1h4xHNvwZM86MxwEeysDrPrHNk/HVvAWJsLOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R6XRD+Tt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727429325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WuOi4SgQEYMvRt/k1X3DYzFCNGycqdFMixmxowyHomI=;
	b=R6XRD+TtjKLsg6mvWB3VcP++XKHFHT1aHpgE13lrhovil7Yj37HZr1cnIJ9zjtkUbweyor
	kE0N4VQOX2pfEgGdKG1O4//7WLx9PuFwnDCWNQFHQTUexZBIAbu6gpeDyI7vyly4aB87fW
	3oMQGA2LMQ+pCReXUE6/XixVq5rvJ7k=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-5-1F654JXjOGaX-MdHc-qPfA-1; Fri, 27 Sep 2024 05:28:43 -0400
X-MC-Unique: 1F654JXjOGaX-MdHc-qPfA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-37cd18bd0d6so629552f8f.0
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 02:28:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727429322; x=1728034122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WuOi4SgQEYMvRt/k1X3DYzFCNGycqdFMixmxowyHomI=;
        b=bfz41bUVbBQjLFbdtvWrCt0LuwkOSUWQ26OGvth4FWu0+jLpORcSXx1cdjJ8oqH01u
         f+oJXjMP43KbH9i5kMD45TRTd56mTMteY7UAmrrUYy2uKD4/22H4qag4c84ozY3k4onm
         uFvIzqu7Tid0Mh9w7PdDTKOE/oy70frDYrA2worSabt8mliM7yqz6EMqVHePDnxsjD0Z
         COpH1VRJ3z2AdNHuRrFvdbZpJ3ohG8j/4lh5FVk1bEBcOSyd53pF/ifRgwJjBqqlV0fJ
         gU2tLjTD/FyZbkN6YLF/N0BWsOi478GoDPGDtJ7BeyUlcO2ye7IqPVFnFC74lDdyxVRb
         kqgw==
X-Forwarded-Encrypted: i=1; AJvYcCWdLN+PRHZmvIhbbHsavXlg54ysBvQ4EvbUknQ5kczeq8mFIoW4nSYDzO8Fkwtz6qTS558=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkZ2CYpz4K1SQw9ITdwPwUxf8ZhrRKXi10zUosQDB/o3BMJUxM
	yFE60Q02/pnLSyFheZkBIkJnL3VW4tSqkC1pqOmzBMjyp05GUq5/OdKIQ5+nFFjxdTeoxFEKbY9
	j1/oTdsoJ+lM/coMWwdR2jTI9JX7Z63QS0S24ZuIy6w08QKfA7A==
X-Received: by 2002:a5d:410a:0:b0:37c:cfeb:e612 with SMTP id ffacd0b85a97d-37cd5a6923bmr1593103f8f.1.1727429322121;
        Fri, 27 Sep 2024 02:28:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFSUe4mNUiJgfsQB3wAqqogWPXNdEdApsLKyz0EkbF9ObTGRtjmYAETR9gyeUxBQRZ9XK7xsw==
X-Received: by 2002:a5d:410a:0:b0:37c:cfeb:e612 with SMTP id ffacd0b85a97d-37cd5a6923bmr1593088f8f.1.1727429321685;
        Fri, 27 Sep 2024 02:28:41 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cd5748918sm1908311f8f.107.2024.09.27.02.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2024 02:28:41 -0700 (PDT)
Date: Fri, 27 Sep 2024 11:28:39 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Eric Mackay <eric.mackay@oracle.com>
Cc: boris.ostrovsky@oracle.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Subject: Re: [PATCH] KVM/x86: Do not clear SIPI while in SMM
Message-ID: <20240927112839.1b59ca46@imammedo.users.ipa.redhat.com>
In-Reply-To: <20240927012239.34406-1-eric.mackay@oracle.com>
References: <4274f9be-1c3d-4246-abe9-69c4d8ca8964@oracle.com>
	<20240927012239.34406-1-eric.mackay@oracle.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Sep 2024 18:22:39 -0700
Eric Mackay <eric.mackay@oracle.com> wrote:

> > On 9/24/24 5:40 AM, Igor Mammedov wrote: =20
> >> On Fri, 19 Apr 2024 12:17:01 -0400
> >> boris.ostrovsky@oracle.com wrote:
> >>  =20
> >>> On 4/17/24 9:58 AM, boris.ostrovsky@oracle.com wrote: =20
> >>>>
> >>>> I noticed that I was using a few months old qemu bits and now I am
> >>>> having trouble reproducing this on latest bits. Let me see if I can =
get
> >>>> this to fail with latest first and then try to trace why the process=
or
> >>>> is in this unexpected state. =20
> >>>
> >>> Looks like 012b170173bc "system/qdev-monitor: move drain_call_rcu call
> >>> under if (!dev) in qmp_device_add()" is what makes the test to stop f=
ailing.
> >>>
> >>> I need to understand whether lack of failures is a side effect of tim=
ing
> >>> changes that simply make hotplug fail less likely or if this is an
> >>> actual (but seemingly unintentional) fix. =20
> >>=20
> >> Agreed, we should find out culprit of the problem. =20
> >
> >
> > I haven't been able to spend much time on this unfortunately, Eric is=20
> > now starting to look at this again.
> >
> > One of my theories was that ich9_apm_ctrl_changed() is sending SMIs to=
=20
> > vcpus serially while on HW my understanding is that this is done as a=20
> > broadcast so I thought this could cause a race. I had a quick test with=
=20
> > pausing and resuming all vcpus around the loop but that didn't help.
> >
> > =20
> >>=20
> >> PS:
> >> also if you are using AMD host, there was a regression in OVMF
> >> where where vCPU that OSPM was already online-ing, was yanked
> >> from under OSMP feet by OVMF (which depending on timing could
> >> manifest as lost SIPI).
> >>=20
> >> edk2 commit that should fix it is:
> >>      https://github.com/tianocore/edk2/commit/1c19ccd5103b
> >>=20
> >> Switching to Intel host should rule that out at least.
> >> (or use fixed edk2-ovmf-20240524-5.el10.noarch package from centos,
> >> if you are forced to use AMD host) =20
>=20
> I haven't been able to reproduce the issue on an Intel host thus far,
> but it may not be an apples-to-apples comparison because my AMD hosts
> have a much higher core count.
>=20
> >
> > I just tried with latest bits that include this commit and still was=20
> > able to reproduce the problem.
> >
> >
> >-boris =20
>=20
> The initial hotplug of each CPU appears to complete from the
> perspective of OVMF and OSPM. SMBASE relocation succeeds, and the new
> CPU reports back from the pen. It seems to be the later INIT-SIPI-SIPI
> sequence sent from the guest that doesn't complete.
>=20
> My working theory has been that some CPU/AP is lagging behind the others
> when the BSP is waiting for all the APs to go into SMM, and the BSP just
> gives up and moves on. Presumably the INIT-SIPI-SIPI is sent while that
> CPU does finally go into SMM, and other CPUs are in normal mode.
>=20
> I've been able to observe the SMI handler for the problematic CPU will
> sometimes start running when no BSP is elected. This means we have a
> window of time where the CPU will ignore SIPI, and least 1 CPU is in
> normal mode (the BSP) which is capable of sending INIT-SIPI-SIPI from
> the guest.

I've re-read whole thread and noticed Boris were saying:
  > On Tue, Apr 16, 2024 at 10:57=E2=80=AFPM <boris.ostrovsky@oracle.com> w=
rote:
  > > On 4/16/24 4:53 PM, Paolo Bonzini wrote: =20
  ...
  > > >
  > > > What is the reproducer for this? =20
  > >
  > > Hotplugging/unplugging cpus in a loop, especially if you oversubscribe
  > > the guest, will get you there in 10-15 minutes.
  ...

So there was unplug involved as well, which was broken since forever.

Recent patch
 https://patchew.org/QEMU/20230427211013.2994127-1-alxndr@bu.edu/2023042721=
1013.2994127-2-alxndr@bu.edu/
has exposed issue (unexpected uplug/unplug flow) with root cause in OVMF.
Firmware was letting non involved APs run wild in normal mode.
As result AP that was calling _EJ0 and holding ACPI lock was
continuing _EJ0 and releasing ACPI lock, while BSP and a being removed
CPU were still in SMM world. And any other plug/unplug op
were able to grab ACPI lock and trigger another SMI, which breaks
hotplug flow expectations (aka exclusive access to hotplug registers
during plug/unplug op)
Perhaps that's what you are observing.

Please check if following helps:
  https://github.com/kraxel/edk2/commit/738c09f6b5ab87be48d754e62deb72b7674=
15158

So yes, SIPI can be lost (which should be expected as others noted)
but that normally shouldn't be an issue as wakeup_secondary_cpu_via_init()
do resend SIPI.
However if wakeup_secondary_cpu is set to another handler that doesn't
resend SIPI, It might be an issue.


