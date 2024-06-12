Return-Path: <kvm+bounces-19464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C49F905595
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 16:47:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B003A1F23A46
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 14:47:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF6F41802C5;
	Wed, 12 Jun 2024 14:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aQ8P34F7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A0A10E3;
	Wed, 12 Jun 2024 14:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718203564; cv=none; b=lE4mhgp+C0uZXUoUV/7A1FuZcMawPkhtu+aW8bmIuh+F5MuJK733JjOEWrcbka8slmuUHOeH2jWkgbyhwckVX3U0cuYkU4gYrkYOVWnWR/rlvL7qJ1LYk6ksdiJv4pdcXiN4sTZhn59MfGn+ukCYNDO7dvsySN4NRLuAG+aJIGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718203564; c=relaxed/simple;
	bh=5AxXYH7nKTnTDISzs7OOMXqxrPovr+dh//GfJdFTR8k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gXVl3gytizSqzJWJLIs+RbQ7QaXLYCZp/oC7s2Rx5lDMMJQMHPikpaizdA9aJGYelfGoDU7WabRVoYpj526922txWzFEb3OSpMMDhkLh648iREb2/zVVI6uxYJuSzKQN3cFj9BUf3F6F6nKoZBcfGIOBLlkCZlstr/614G+YCv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aQ8P34F7; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a6f04afcce1so304723366b.2;
        Wed, 12 Jun 2024 07:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718203560; x=1718808360; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5AxXYH7nKTnTDISzs7OOMXqxrPovr+dh//GfJdFTR8k=;
        b=aQ8P34F7P6QvkYdFxgalqjIaH1D2++2VaFcDdpejbvCkFyPuFHQ208EgHNKjGW/HBR
         iOI0GnF/6JRHvJ67wrmY/kCa8TquO/m2WNkqqMx9Pwe1RprYpuLiSl4BIjt6Gyr5Fnm8
         oe75nEL76aIl7zZplwKJ/plVctywNZywXUdjCeNi3Cbg5e3K0bKL3XIAGIxozIwmDvyx
         qc6oJWc7/PxDkcJEPhQdx1aXL3n+oSrE97m88KJ0TEIy37EnUM4RjT/7xaOXmrM50lJ6
         YnTYtESvnJEc8fFtmxk7RQFH3I5oKkszaigacVCzERWjzQGmGUB2wEab3jXQyvQYg1Kf
         Mq0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718203560; x=1718808360;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5AxXYH7nKTnTDISzs7OOMXqxrPovr+dh//GfJdFTR8k=;
        b=GiBmMLEh3bf3jXwVgb/FcNHo09Z7fi77FzGg3SPMPLFJMhkRJulQK3yZ57W2uTjV6e
         chxS2BH9LaoHjz71WuyBmWMFt7RerC0ONBF5vtkeBhAoED8VXoUgnoql4XeYfHTTjOXj
         ctf8ndseyLknZGEv440eFnW3nNZsHSg8jDibgBmO9wAIpx9USXcmE6AwIM5UOQx5coJo
         hHtzxxKTbYDNIC24rpYXzbCdfkVndYJMCwfpEZyQqSTPBfEH71+ts5xRiS0IF2gmax1O
         QR6zNWY1hlNtd1+XG5g12JC8gqrswWD5Wuz724fwdpycfrTCsJtQZvqJ1vypVnr3h9v0
         QncA==
X-Forwarded-Encrypted: i=1; AJvYcCX6QD2T0M6q5KyZDAYfDYmkEbSmcgG/cVvCL7QR47MKtjZFm/A3mG4Gsj33D4XyPcwI89sKWTccXVZvRCtIxPAYm4SXWL0M0KfxKnsRQX/9jqcvXcOeRQ+o0sGEg3hisiEPdnb8t1K8Vghz6IvHDvzAjb+DBgrzn7HZdQ==
X-Gm-Message-State: AOJu0YytyCywemBRDdJhjNdSIiXdexPs2EDM/+htXHjXwu8zpwRLGIx/
	r9Vo+vef2Rxmju7fMeUMdTMDYwTohlAl3KIV5nlxDHj9nB2MoPQDZkgoUdIMheoxaUsV9CQY+D2
	JPNFXS8jeyuPqnwFJ7Ma/rCsDOM0=
X-Google-Smtp-Source: AGHT+IEl0JvRLUON6rkpWTuYeTJkOBLp2cxRobpfn23a+6NqNKZeRh/2J4mmduBxTKrwNFkPAbePHd1yLLmdOoT5X3A=
X-Received: by 2002:a17:906:d8ab:b0:a6f:2d9a:c956 with SMTP id
 a640c23a62f3a-a6f47d4eefamr167552966b.3.1718203559979; Wed, 12 Jun 2024
 07:45:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240610125713.86750-1-fgriffo@amazon.co.uk> <k4r7ngm7cyctnyjcwbbscvprhj3oid6wv3cqobkwt4p4j4ibfy@pvmb35lmvdlz>
In-Reply-To: <k4r7ngm7cyctnyjcwbbscvprhj3oid6wv3cqobkwt4p4j4ibfy@pvmb35lmvdlz>
From: Frederic Griffoul <griffoul@gmail.com>
Date: Wed, 12 Jun 2024 15:45:48 +0100
Message-ID: <CAF2vKzP0C1nEYTWRdWeAFKVUcuu3BkPD0FVA7yAS1rc-c=gs5A@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] vfio/pci: add msi interrupt affinity support
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Fred Griffoul <fgriffo@amazon.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Alex Williamson <alex.williamson@redhat.com>, 
	Waiman Long <longman@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mark Brown <broonie@kernel.org>, 
	Ard Biesheuvel <ardb@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Jeremy Linton <jeremy.linton@arm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Yi Liu <yi.l.liu@intel.com>, Kevin Tian <kevin.tian@intel.com>, 
	Eric Auger <eric.auger@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Ye Bin <yebin10@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

MIchal

To be honest my initial idea was to store an affinity mask per vfio group, =
which
can be done in the privileged process setting the vfio group/device owner, =
and
later apply the mask to each interrupt of each device in the group.

It would still require to fix the affinity of all the interrupts if
the vfio group affinity is
changed (or deliberately ignore this case). And it did not match
exactly my use case
where I need the process handling the interrupts to sometimes be able
to change them
but always within the cpuset. So I would still need the current patch,
in addition to
a new ioctl() to set the affinity mask of a vfio group.

Br,

Fred

On Mon, Jun 10, 2024 at 5:31=E2=80=AFPM Michal Koutn=C3=BD <mkoutny@suse.co=
m> wrote:
>
> Hello Fred.
>
> On Mon, Jun 10, 2024 at 12:57:06PM GMT, Fred Griffoul <fgriffo@amazon.co.=
uk> wrote:
> > The usual way to configure a device interrupt from userland is to write
> > the /proc/irq/<irq>/smp_affinity or smp_affinity_list files. When using
> > vfio to implement a device driver or a virtual machine monitor, this ma=
y
> > not be ideal: the process managing the vfio device interrupts may not b=
e
> > granted root privilege, for security reasons. Thus it cannot directly
> > control the interrupt affinity and has to rely on an external command.
>
> External commands something privileged? (I'm curious of an example how
> this is setup.)
>
> > The affinity argument must be a subset of the process cpuset, otherwise
> > an error -EPERM is returned.
>
> I'm not sure you want to look at task's cpuset mask for this purposes.
>
> Consider setups without cpuset or a change of (cpuset) mask anytime
> during lifetime of the task...
>
> Michal

