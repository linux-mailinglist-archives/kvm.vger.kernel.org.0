Return-Path: <kvm+bounces-10836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19D6D870FA8
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 22:59:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B3CC1F23214
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 21:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF8D379DCA;
	Mon,  4 Mar 2024 21:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E6fEa4h2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9382A1F60A
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 21:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589580; cv=none; b=Va+u/mI119bPJMWsclExjKieutE1UfRxfGsMHcj3AosncVSHiruzILSb/F7w6Mdu5DPdfJsGoLZpCXA8Y27f5CZsx0fLHfwhlKSGUc25LXis+fExRYtwiktsQSHySIYWhdNMNmo6AL9My5EDP9yH4zKLe8tApj6HZ9IYUfGQA6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589580; c=relaxed/simple;
	bh=rsfcvOcEZKrhm0r9Dg1uMkc+eokAKC6cmKnkHnWiqIw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BLHWzEIn4uxdXMHNPRJiQ38TFEvNQvX2i9ZDg6B+3XtcvMfJT5LAOcGfdFpdlv22KCnwSnfMxGyin7MfUWQfDSHQjP+u1dlF9tiizNhNZOzZnTrwd1j1yJ4fnUnjqeuC8A14IrJQiErqAEQfSTAYx7UQiY45i4l1bF2J9EY7oPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E6fEa4h2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709589577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YYr9RxLE7ICQP5M8LuYJaBjIKBfoxquqKHOKlfU1Ml0=;
	b=E6fEa4h2WT4yPX0gomQSdVxKaHgOfHHhUJusx2HI9mmLb1I3nBg3fhOgFeZwST2HsOPCtj
	nZ8jBhNZRFAMFisGRbbTS1kUo5nvjzhMDxuiju60eoj37y5oMlPGZAhSdDVxpPuX4aiiQI
	BdHkcoE2oIQ7HFQ/gIl5Oujrhw7TXoM=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-_R6ojKdXOSCG9aqb1lijsQ-1; Mon, 04 Mar 2024 16:59:35 -0500
X-MC-Unique: _R6ojKdXOSCG9aqb1lijsQ-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7c83c53216bso600739f.1
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 13:59:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709589575; x=1710194375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YYr9RxLE7ICQP5M8LuYJaBjIKBfoxquqKHOKlfU1Ml0=;
        b=Kc64JCl85wAYmQiriRIl/zHe6Y19ioY/a7m+RVjVEnF3gYmMqKn0fU51nT/JAozn03
         c6zUjX4nto/Ls+2+vlZfUgLv2UerYYqVWvX/iva9zert5S01lY+Cm4LmBWAEruT0H5BY
         pJSPsWdAhCMBirNnplGpDNNDeFssGgKgPhC4HpdoltfXQ03LsPtd8CCc2lC0aE8uD+bB
         q9CEdGDGbktX+I4SOEx9Yll81hZah9kzCOTCdUGSUGQpL6KeKctnirLmONF6JGhDH7Js
         Be/kDV9nNBrA4oaePc6mDxI+r95Y4lQxVyaGsqbdt4l4K0ybUJkq7+U8gUOoLOjqDisW
         wS2Q==
X-Forwarded-Encrypted: i=1; AJvYcCU4/gfwFimR9Ds/fQhMLP4YZQbm9WiFSq8RNJAD8TF6QhomG0EHijyqhrMwQ+lpd09hDdxUgKkzsGMtswz5KiCP0O/e
X-Gm-Message-State: AOJu0YxNlJFYbul70il9a5MIulMH4SJck4ESPrUighEAsDm1DetMhBWS
	McBQUOsWRVrs+ZuGEesunPseHYHffB9DYKY1mqUfC9X16qW8/x74fg7zETgfeV85cDI12JOQPai
	OR+P1z6/TJPOBbbIHNfz1fP5IVmPTvLjZ8+dYrWvVHI9ObXBSHA==
X-Received: by 2002:a05:6602:38e:b0:7c8:560f:19a8 with SMTP id f14-20020a056602038e00b007c8560f19a8mr3821633iov.0.1709589574809;
        Mon, 04 Mar 2024 13:59:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH5OzQhRN4IV8xTWTw1t3YUnE/L009vfT2eF63he7m5wXkyjJuk0adjSmxV8P3au4sJM3yMiQ==
X-Received: by 2002:a05:6602:38e:b0:7c8:560f:19a8 with SMTP id f14-20020a056602038e00b007c8560f19a8mr3821623iov.0.1709589574525;
        Mon, 04 Mar 2024 13:59:34 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id a36-20020a029427000000b00474393b4ed5sm2632863jai.10.2024.03.04.13.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 13:59:34 -0800 (PST)
Date: Mon, 4 Mar 2024 14:59:32 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Xu Liu <liuxu@meta.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-discuss@nongnu.org" <qemu-discuss@nongnu.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>
Subject: Re: Why does the vmovdqu works for passthrough device but crashes
 for emulated device  with "illegal operand" error (in x86_64 QEMU, -accel =
 kvm) ?
Message-ID: <20240304145932.4e685a38.alex.williamson@redhat.com>
In-Reply-To: <39E9DB13-5FA3-4D1A-A573-7D58BA83B35C@fb.com>
References: <39E9DB13-5FA3-4D1A-A573-7D58BA83B35C@fb.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 3 Mar 2024 22:20:33 +0000
Xu Liu <liuxu@meta.com> wrote:

> Hello,
>=20
> Recently I am running my programs in QEMU (x86_64) with =E2=80=9C-accel=
=3Dkvm=E2=80=9D.
>  The QEMU version is 6.0.0.
>=20
> I run my programs in two ways:
>=20
> 1.   I pass through my device through vfio-pci  to QEMU,  this way
> works well.
>=20
> 2.  I write an emulated PCI device for QEMU, and run my programs on
> the emulated PCI device. This crashes when  the code try to do memory
> copy to PCI device when the data length is longer than 16 bytes.
> While the  passthrough device works well for the same situation.
>=20
>=20
> After  dump the assembly code.  I noticed when the data is <=3D 16
> bytes,  the mov assembly code is chosen, and it works well.
>=20
> When the data is > 16 bytes,  the vmovdqu  assembly code is chosen,
> and it crashes with =E2=80=9Cillegal operand=E2=80=9D.
>=20
> Given the code and data are exactly same for both passthrough device
> and emulated device.  I am curious about why this happens.
>=20
> After turn on  kernel trace for kvm by   echo kvm:*
> /sys/kernel/debug/tracing/set_event And rerun the QEMU and my code
> for both passthrough device and emulated device, I noticed that:
>=20
> 1) for passthrough device,  I didn=E2=80=99t see  any trace events relate=
d to
> my  gva and gpa.  This makes me think that the memory copy to PCI
> device went through different code path . It is handled by the guest
> OS without exit to VMX.
>=20
> 2) for emulated device, if I use   compiler flag
> target-feature=3D-avx,-avx2 to force compiler use  mov assembly code,
> I can see the memory copy goes through the KVM_EXIT_MMIO, and
> everything works well. if I don=E2=80=99t force the compiler use mov ,  t=
he
> compiler just chooses the vmovdqu ,  which just crash the programs,
> and no KVM_EXIT_MMIO related to my memory copy appears in the trace
> events. Looks like the guest OS handles the crash.
>=20
>=20
> Any clue about why the vmovdqu works for passthrough device but not
> work for emulated device.

For an assigned device, the device MMIO space will be directly mapped
into the VM address space (assuming the PCI BAR is at least PAGE_SIZE),
so there's no emulation of the access.  You can disable this with the
x-no-mmap=3Don option for the vfio-pci device, where then I'd guess this
behaves the same as your emulated device (assuming we really don't
reach QEMU for the access).

Since you're not seeing a KVM_EXIT_MMIO I'd guess this is more of a KVM
issue than QEMU (Cc kvm list).  Possibly KVM doesn't emulate vmovdqu
relative to an MMIO access, but honestly I'm not positive that AVX
instructions are meant to work on MMIO space.  I'll let x86 KVM experts
more familiar with specific opcode semantics weigh in on that.

Is your "program" just doing a memcpy() with an mmap() of the PCI BAR
acquired through pci-sysfs or a userspace vfio-pci driver within the
guest?

In QEMU 4a2e242bbb30 ("memory: Don't use memcpy for ram_device
regions") we resolved an issue[1] where QEMU itself was doing a memcpy()
to assigned device MMIO space resulting in breaking functionality of
the device.  IIRC memcpy() was using an SSE instruction that didn't
fault, but didn't work correctly relative to MMIO space either.

So I also wouldn't rule out that the program isn't inherently
misbehaving by using memcpy() and thereby ignoring the nature of the
device MMIO access semantics.  Thanks,

Alex

[1]https://bugs.launchpad.net/qemu/+bug/1384892


