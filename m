Return-Path: <kvm+bounces-37487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 556A9A2AC0B
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 16:03:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44C047A7B6A
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 15:02:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E2EF1EA7DD;
	Thu,  6 Feb 2025 15:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ea/GBNU9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583221E5B93
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 15:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738854181; cv=none; b=ttlkYFY4gmZDZftAE9h1pCZg4j3h+gRnUDw/RmxaV+P1J9Nrzid4c9o1hzYqBdrvFQotGS0g3XBUNnzGtaL3NWapTSMv8mpw1k6bldURsBttofsw0myw8CvQOBo33uV4MESELZDt+a9aQt6NYjZnUIuf23vZraJYb9O3QRJ2xrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738854181; c=relaxed/simple;
	bh=gFwVDbQw3oyXij2AeuvNWmyFCCHU+IJ4scLzh16Royg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pRQI6xDcmDP9dWkmjNdoqwthWvjyZISte1u8KXS29tgODLFfxmi/hZYIswYZwoGcPhhI5gYaD/mCVfRpdSsrjiY1WDGRQ82sP+UJFOb2XXJxwY46ST8L4Y5I33lC7VuJpPGBKiUjx52gkpzx0+nm4bfr/0K7NhUIHHOYR9d4V30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ea/GBNU9; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5dcef821092so1186489a12.0
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2025 07:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738854178; x=1739458978; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oLdJi4U7fEVnSaHGWLoixI2X9/Q9WTKa8jI/Sbrxh44=;
        b=Ea/GBNU9ujQKlHwCDFPUvBJWUF4UpH2n5uFNKu1U2RZ/dQo6HSUfqg+FphQ3jIOmHm
         l8a7ynGKzSE4KwJz2fiNWYH/rQlj5v7FTDymaWsT+nCH1t6/i27MTBW7YQGl8fmfvuPm
         wqnUg2pHifvkC6ZqfEDjJC8Vn6iT7qqsx0hgoX8KDBk7vcsrDFQdAOJtZAx7odnfUUOb
         QnqmRLicFEsCn20wqwDxlcbm1WlMAIC1P0uiYe9HGRRGi+h28zsohKZ+9I1lWcs92rvG
         xG/qPLUXCZcsVbvxvLFwTUlWuVglDdZk5knn+YWgK1xfQ8DgHAlrJ3B4C/Gm3ojetvKv
         2Iig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738854178; x=1739458978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oLdJi4U7fEVnSaHGWLoixI2X9/Q9WTKa8jI/Sbrxh44=;
        b=Vvsg3bxVLpGFtxPALNo10I/wc/m/6aJLKUG/olwc8z5SXfbIxvJtXva9VOXBalDFnt
         aubySCzw8DVnNGOGwRnbi6eBsyNisgawx7JqIXSWE0LEp32ukdXadPqS2sGxiP+SexXZ
         XMng1E4DVikdidGpwBIBG8kaqJ13XMcPTbucLcGBdFAFNCf7AbZJW+6EDagDvlTr8tiT
         b/d1lYRy3/Yn+PYGy8i0lc6hATXCGhHmTdExtEP9Zu/DnfASDZhiAtDSHZbHHBCPLDG/
         Lg8DYjmR0CV2aZLbQRRiTmeJn9URkS45qBHVzsgPqU0DQ9aRF8ToaB1nIrGt4KViQIpl
         ZcYw==
X-Forwarded-Encrypted: i=1; AJvYcCU43W57IuGKq0vVbL/inX1acMqnEJSRuCwDeAxlnyt5p12qU82PY8lne4ixgO77EprOo0s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2ZLRYeLs1TxwFHFFqyrhGUl2F7tmMxPCIygXIk+1UefOivJZm
	I7Pi4Bb6LuwgfXc6gcBvm2MyhD1rfmzZb+/GeVeKIocp2+CfhXHbrYmpT9HSmX6MPOeyZ1eKBFZ
	XUvJJVygo43s30TyHQZ3BYcheg2A=
X-Gm-Gg: ASbGnctxgIXsThylMNTNSHqmdQY8LnmMdP26smt5xKypUypVcvhlIn3wIruaQ06WoLm
	NMzqkebDF37xtVi51E1ybGr2VPLZdwlHmDZ6vgzZa3qoLJFVchKqGi6So2XUfSelKvqbb0Rg=
X-Google-Smtp-Source: AGHT+IFm3GZYMklSVL3KfRyfhQSdqu4mPlu/ASReyOBylKB4YfAePVKqrCnIUT2NLo00mffp/qOCDzTSCafbDCYvREA=
X-Received: by 2002:a05:6402:35cd:b0:5d3:ce7f:abee with SMTP id
 4fb4d7f45d1cf-5dcdb775245mr7038055a12.25.1738854175491; Thu, 06 Feb 2025
 07:02:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QVYE1Zcws=9hoO6+B+xB-hVWv38Dtu_LM8SysAmS4qRMw@mail.gmail.com>
 <Z6SCGN+rW2tJYATh@fedora>
In-Reply-To: <Z6SCGN+rW2tJYATh@fedora>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Thu, 6 Feb 2025 10:02:43 -0500
X-Gm-Features: AWEUYZnABPAiNQnHAuAcUp5oMT6n8P_YdJatgdJcAJweLCH27C-YEAxaw0sIwpg
Message-ID: <CAJSP0QXHG8Vj1EomaRRTfQWykR=9mWQ3SDWn0pCG-b_8rJuKcg@mail.gmail.com>
Subject: Re: Call for GSoC internship project ideas
To: Matias Ezequiel Vara Larsen <mvaralar@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
	Richard Henderson <richard.henderson@linaro.org>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Huth <thuth@redhat.com>, "Daniel P. Berrange" <berrange@redhat.com>, 
	Pierrick Bouvier <pierrick.bouvier@linaro.org>, Alex Bennee <alex.bennee@linaro.org>, 
	Akihiko Odaki <akihiko.odaki@gmail.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Bibo Mao <maobibo@loongson.cn>, Jamin Lin <jamin_lin@aspeedtech.com>, 
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>, 
	Fabiano Rosas <farosas@suse.de>, Palmer Dabbelt <palmer@dabbelt.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Hanna Reitz <hreitz@redhat.com>, felisous@amazon.com, 
	Stefano Garzarella <sgarzare@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 6, 2025 at 4:34=E2=80=AFAM Matias Ezequiel Vara Larsen
<mvaralar@redhat.com> wrote:
> =3D=3D=3D Adding Kani proofs for Virtqueues in Rust-vmm =3D=3D=3D
>
> '''Summary:''' Verify conformance of the virtqueue implementation in
> rust-vmm to the VirtIO specification.
>
> In the rust-vmm project, devices rely on the virtqueue implementation
> provided by the `vm-virtio` crate. This implementation is based on the
> VirtIO specification, which defines the behavior and requirements for
> virtqueues. To ensure that the implementation meets these
> specifications, we have been relying on unit tests that check the output
> of the code given specific inputs.
>
> However, writing unit tests can be incomplete, as it's challenging to
> cover all possible scenarios and edge cases. During this internship, we
> propose a more comprehensive approach: using Kani proofs to verify that
> the virtqueue implementation conforms to the VirtIO specification.
>
> Kani allows us to write exhaustive checks for all possible values, going
> beyond what unit tests can achieve. By writing Kani proofs, we can
> confirm that our implementation meets the requirements of the VirtIO
> specification. If a proof passes, it provides strong evidence that the
> virtqueue implementation is correct and conformant.
>
> During the internship, we propose the following tasks:
> - Get familiar with Kani proofs written for Firecraker
> - Finish current PR that adds a proof for the notification suppression
>   mechanism (see [2])
> - Port add_used() proof (see [5])
> - Port verify_prepare_kick() proof (see [6])

add_used(), verify_prepare_kick(), and notification suppression are
explicitly named. Firecracker's queue.rs has proofs for a number of
other proofs as well. Would it be possible to work on them if there is
time remaining, or is there a reason why only the proofs you mentioned
can be ported?

I'm asking because a 12-week internship is likely to leave enough time
to tackle more than 3 proofs.

Stefan

>
> '''Links:'''
>   * [1] Kani source code - https://github.com/model-checking/kani/
>   * [2] Notification suppression mechanism PR -
>     https://github.com/rust-vmm/vm-virtio/pull/324
>   * [3] LPC Talk about how we may check conformance in the VirtIO
>     specification - https://www.youtube.com/watch?v=3Dw7BAR228344
>   * [4] FOSDEM'25 talk current effort to use Kani -
>     https://fosdem.org/2025/schedule/event/fosdem-2025-5930-hunting-virti=
o-specification-violations/
>   * [5] https://github.com/firecracker-microvm/firecracker/blob/4bbbec06e=
e0d529add07807f75d923cc3d3cd210/src/vmm/src/devices/virtio/queue.rs#L1006
>   * [6] https://github.com/firecracker-microvm/firecracker/blob/4bbbec06e=
e0d529add07807f75d923cc3d3cd210/src/vmm/src/devices/virtio/queue.rs#L966
>
> '''Details:'''
>   * Skill level: intermediate
>   * Language: Rust
>

