Return-Path: <kvm+bounces-68082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E885BD2107B
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 20:28:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0C87F309C3A5
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 19:27:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F230346ACF;
	Wed, 14 Jan 2026 19:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W2DTDXgn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFC1346A1F
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 19:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768418825; cv=pass; b=dvjpWVzJ5oGpffcovBjktar/pANphLFx2Q91l3/T7QD2p8MSQkPEJdIanq4dTq3e/5tk6nl1UUomcgwOmQpvRRVc5X6BrIi32pbifA0lgOWSMJkjWHa9Ii+qgIVh8V83/OuSDCCTyRTqjEGSIwKP7YbcFLDk/logYV6G2/SKudU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768418825; c=relaxed/simple;
	bh=064OhwXl3Cmv/nOr6qe6fnW0m2ckrHf98JV5OjOx3q4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bj7YEpwt+4ZG1tvwK9DHiEfuRgAzegwNQRUJYdNktF7NqUys3/sopyzEsD3DurS4YOPwsNO/8hnEznZd3K5rZ9ow40gDvh4Ailhbz4Q2boC56joevaGyvyF2hHLduGwLSEL96aMSjviza4jNrGUWg86IPCg6OhygjBJbXuNmQuU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W2DTDXgn; arc=pass smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b872b588774so28949366b.1
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 11:27:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768418822; cv=none;
        d=google.com; s=arc-20240605;
        b=SkQygl9z+ukbP56xSGbKLhE3OSYQxSpFn32aycysbyZ4hFSRclz6PiwIwNwtTvmJ4p
         KYc6rQjKEWqYRvO56247NvzsUHRwH8wFpn8G4swPjXQiYWIPF33HgMECQOz2TeLTjt3O
         Wlk6AV+MFCv5Ov/oYAqQjI1F113LEsTd7KUV5XIiLoynDWtCsSf1AEnEDFp70dyaDf1p
         NsfYl7RvXyz5A9VIIZFIE7oTYhLL8y+izJnSb9F8BPA1BEF9IAJTLXigxyTiT4zb13BJ
         PqVRGNkMWNtPOZ6XF5aMGFPk8VkuGwLUiUdHBKl8uBceEHi6Mi10cSbHQM1C/BX3ZPcS
         1Wfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=itGWxuNUXKr4Klr3rfnGOaIQ9XzrtNIw8H2hVEZJkps=;
        fh=VHWW9JHyvkBs4VOKKG5DiEde1owY/xTKl1JgKL7WDp8=;
        b=V+eV4C+SWTtqsFJhJzJLcORV9ACNvq4zSt8gE86zNrqarRLAprI31oPepS1G6kf9Vv
         CcFosbbRmHI1dQhZLcWVyKnY/xWmQbGEi6yQBR5o9tRVz47IxD32/ZSZczqrLxxXT5mS
         ePNw+DmDQYdwXVW3kVpoqMx/+IXRPdr5ePm5MuQwZFwA8lR7Xr679IuA8Bv+BVtN9532
         RPZgxz+Ztl46uYcCXA5Xl9TducT7qudFR7mxNz9xThnrp+bBh25eNPaVIzv8zJ7064dY
         3fwNMrsncAUQRn1aPmC303Z80bo6LHbD2jc5EzjseY0lJvoowfP++shnqGGXeYY4dZ79
         IU2w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768418822; x=1769023622; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=itGWxuNUXKr4Klr3rfnGOaIQ9XzrtNIw8H2hVEZJkps=;
        b=W2DTDXgnPc+PQ5DFk3mGEKP34niHdbRfaef62Lx/sCf8yiT1t14drbMP93np1dVzpy
         Yinnrst50g4E9dOpyE0db2RRQOLk+7T8Dkor8gJj4AYzQq46RYiKUX/PTofRTc/1klwE
         Q32KUu/qU2lgjAp/559iS1MqQvRCUhdxIeFkOAt9TKSPTxDvqjrArCAXwaElNNVxRR5s
         xL2sz5xVLAISTQKJG5OBTPg7GbOfpPYi4Fc2+lv9AcZiRFbeRqFn5xHsNj0t6z3Ply64
         Qc26gbRdgg8oXrHplVCKiVrTEV0Qvbw/QVB33yRRCUsddtCSU0pMbu3snbcKDCdDLnxn
         PFjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768418822; x=1769023622;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=itGWxuNUXKr4Klr3rfnGOaIQ9XzrtNIw8H2hVEZJkps=;
        b=tIQjKRQ9vSIKEgmKUzcALLRrG0UWjGDJAe9AozeJJlNNJXZNawkulZfnQDX/fMrnho
         yhRelHseFCvm4XVzBP2RcooGFainOJu+HN6eIt9+jtHmbUQzMsfhLjTYGezImLa1KDuA
         9dwTaP4hnbAMhgR8A6OseLR1BCFa3+cRkFCRSQtX44O8NE2hreNn7BgokICjwmvpXMMf
         fZUzKGZes7GdYyrRAuWudHtzI5ZknwUIcc/LNM1/IbR2agYdtgor+WSz2RyKQpVnBrHX
         kXRxE/f3/2TIrGpBZQBcUPNUjOGHQVp0u/y+ylvOcwFfFnK36EDEUBnMb8a57N3KB2el
         zy1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXS3Xo1/saj16eqtY1MlIA/xgaXm4+YG2iBQfevqDNh3L1L2rdTQoe6B+Pv8lP7XqObauo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGZFphUIvLftTEKkWwZwi32ZZMFLtNzUCA8oeqBT/tnZcJwWvJ
	Cvj9RKYZ9AL5+RXDiDz3sq9z3THsLlvkBJDahvhkQgj6zT2l+wnYMjjUqed5g59HYMRshTuPmTA
	v2L47FSLzR6zXTs6emDUlECZ6t8VkRps=
X-Gm-Gg: AY/fxX54BxrwGSqzv3mDgDythgftJ50zZgDcq1qus9inRgA07/4Cx5AifBfGReaOZPb
	ox1lOJPpVfL9lAaF9xOSbobc7fe6Y4ynxV+483ca4QXdOfx27bDSUyb9ko2pThlF9w4o7AdQOwZ
	cLMPBVpjmLIafmMD7PvkrJl/QuV1oDxxwyG8pYrN4PR1k8LG0Z3lmHEk0D5hkHajKpSkuEyeMGV
	gVQCnG4YY5D3KOkYE7phgoj+gm4h7h+M07TV/5+jMyTj8LMAzANOtnh8l6IF9/nFKwC/7zSlW2B
	AtZz
X-Received: by 2002:a17:907:1b07:b0:b83:32b7:21b0 with SMTP id
 a640c23a62f3a-b8761080312mr330570966b.17.1768418821609; Wed, 14 Jan 2026
 11:27:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
In-Reply-To: <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Wed, 14 Jan 2026 14:26:48 -0500
X-Gm-Features: AZwV_QhGt3axNkykzL3oY3gQVBo1JCpygC8YOady8GhZ2b4JvQuIJfnDtIjGlyM
Message-ID: <CAJSP0QVQNExn01ipcu4KTQJrmnXGVmvFyKzXe5m9P3_jQwJ6cA@mail.gmail.com>
Subject: Re: Call for GSoC internship project ideas
To: =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
	Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Matias Ezequiel Vara Larsen <mvaralar@redhat.com>, Kevin Wolf <kwolf@redhat.com>, 
	German Maglione <gmaglione@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Thomas Huth <thuth@redhat.com>, danpb@redhat.com, 
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Alex Bennee <alex.bennee@linaro.org>, 
	Pierrick Bouvier <pierrick.bouvier@linaro.org>, John Levon <john.levon@nutanix.com>, 
	Thanos Makatos <thanos.makatos@nutanix.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 14, 2026 at 1:01=E2=80=AFPM Marc-Andr=C3=A9 Lureau
<marcandre.lureau@redhat.com> wrote:
> On Tue, Jan 6, 2026 at 1:47=E2=80=AFAM Stefan Hajnoczi <stefanha@gmail.co=
m> wrote:
> Rather than replying to this mail, I sketched some ideas of things I have=
 in mind on the wiki directly:
>
> https://wiki.qemu.org/Internships/ProjectIdeas/RDPUSB

Excellent! This one looks ready to go because it's self-contained.

> https://wiki.qemu.org/Internships/ProjectIdeas/VFIOUSER
> https://wiki.qemu.org/Internships/ProjectIdeas/ModernHMP
> https://wiki.qemu.org/Internships/ProjectIdeas/mkosiTestAssets

These three involve additional maintainers and require consensus
before they can be listed. This way we can be confident that the
intern's work will not be held up later by design discussions from
people who are not yet on board with the idea.

> I will try to reach the various people involved in those related projects=
 to see if they are reasonable proposals.
>
> We have a lot of ideas on the wiki (https://wiki.qemu.org/Internships/Pro=
jectIdeas/), that have various status.. I wonder if they wouldn't be better=
 under qemu.git docs/ with some form, so we could send patches to discuss t=
hem instead. Arf, a QEMU Enhancement Proposal, I have too much ideas :)

For the internships, discussing them via email in this thread has
worked well in the past. For a more general QEMU Enhancement Proposal
process, that is a bigger topic for the community since there is
currently no formal process for the development of new features.

I have some thoughts about the vfio-user project idea:

> =3D=3D=3D First-Class vfio-user Device Support =3D=3D=3D
>
> '''Summary:''' Promote QEMU's experimental vfio-user device support to pr=
oduction-ready status by adding comprehensive testing, documentation, migra=
tion support, and seamless CLI integration.
>
> Since 2022, QEMU has included `x-vfio-user-server` for running emulated P=
CI devices in standalone processes using the vfio-user protocol. This enabl=
es security isolation, modular device development, and flexible deployment =
architectures.
>
> However, adoption has been limited due to:
> * '''Experimental status''' - All components use `x-` prefix indicating u=
nstable API

This is a question of whether the command-line interface is stable.
John Levon, Thanos Makatos, and C=C3=A9dric Le Goater are the maintainers
for vfio-user. I wonder what their thoughts on removing the "x-" are?

> * '''Complex CLI''' - Requires coordinating multiple components (`-machin=
e x-remote` + `-device` + `-object x-vfio-user-server`)
> * '''No live migration''' - Migration explicitly blocked

The vfio-user protocol has adopted the kernel VFIO interface's device
state migration features. In theory the protocol supports migration,
but I don't see QEMU code that implements the protocol features. If my
understanding is correct, then there is a (sub-)project here to
implement live migration protocol features in --device vfio-user-pci
(the proxy) as well as in --object x-vfio-user-server (QEMU's server)?

> * '''Limited testing''' - Only one functional smoke test exists
> * '''Documentation''' - No usage guide or troubleshooting docs
>
> This project aims to make vfio-user a first-class QEMU feature.
>
> '''Goal:''' Enable out-of-process device emulation with a single CLI opti=
on.
>
> '''Current (complex):'''
> <pre>
> # Server process (full QEMU instance):
> qemu-system-x86_64 -machine x-remote,vfio-user=3Don \
>   -device pci-serial,id=3Dserial0 \
>   -object x-vfio-user-server,id=3Dvfu0,type=3Dunix,path=3D/tmp/serial.soc=
k,device=3Dserial0
>
> # Client process (main VM):
> qemu-system-x86_64 ... -device vfio-user-pci,socket=3D/tmp/serial.sock
> </pre>
>
> '''Proposed:'''
> <pre>
> # Single option spawns all capable devices out-of-process automatically
> qemu-system-x86_64 -vfio-user \
>   -device pci-serial \
>   -device virtio-net-pci \
>   -device pvpanic-pci \

At first I thought this was about launching third-party vfio-user
device servers from the QEMU command-line, but later I realized it's
only about running QEMU's PCI device emulation in separate processes.

>   ...
> # QEMU automatically:
> # - Identifies vfio-user capable devices
> # - Spawns device server processes
> # - Connects via vfio-user protocol
> # - Manages lifecycle (startup, shutdown, crash recovery)
> </pre>
>
> '''Implementation:'''
> * Add global `-vfio-user` CLI option
> * Identify devices capable of out-of-process emulation (all PCI devices i=
nitially)
> * Automatically spawn server process for each capable device
> * Create internal socket connections (e.g., `/tmp/qemu-vfio-user-<pid>-<d=
evice>.sock`)
> * Replace device with `vfio-user-pci` client transparently
> * Handle process lifecycle: spawn, health monitoring, graceful shutdown, =
crash recovery
> * Optional: `-vfio-user=3D<device-list>` to select specific devices

Monitor commands don't work as expected in this mode since the main
VM's QMP server is unaware of the vfio-user device server's QMP
servers. How should QMP work for automatically spawned devices? I
think approaches that try to aggregate query-* command results or make
it appear that the devices are part of QEMU become complex quickly.

Users choosing vfio-user for process isolation (security) need to
launch vfio-user device servers before launching QEMU in order to
achieve principle of least privilege (e.g. pass file descriptors only
to the server and not to the main VM process).

> '''Goal:''' Add test suite covering more vfio-user devices and functional=
ities
>
> Currently, a single smoke test (`tests/functional/x86_64/test_vfio_user_c=
lient.py`)
>
> '''Test devices:'''
> * `pvpanic-pci` - Minimal device, no interrupts
> * `pci-serial` - Simple with INTx interrupt
> * `virtio-*` - More complex devices with DMA

Nice.

> '''Goal:''' Documentation for users and developers
>
> ** Quick start examples
> ** CLI reference
> ** Common use cases (security isolation, modular development)
> ** Troubleshooting guide
> ** When to use vfio-user
> ** Comparison with other solutions (vhost-user, usbredir, cacard, swtpm..=
.)
> ** Performance considerations

Yes!

> =3D=3D Stretch goals =3D=3D
>
> * Migration support
> * Hot-plug support
> * Support for non-PCI devices
>
> '''Links:'''
> * https://www.qemu.org/docs/master/interop/vfio-user.html - vfio-user pro=
tocol specification
> * https://github.com/nutanix/libvfio-user - libvfio-user library
>
> '''Details:'''
> * Skill level: advanced
> * Language: C
> * Mentor: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com> (elmarco o=
n IRC)
> * VFIO-USER maintainers?
> * Suggested by: Marc-Andr=C3=A9 Lureau

Stefan

