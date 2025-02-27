Return-Path: <kvm+bounces-39557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 21BD7A47A3E
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 11:25:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE09F18886ED
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 10:25:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13CBC22F3BC;
	Thu, 27 Feb 2025 10:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O+KWkRT+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B7822A1D4
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 10:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740651738; cv=none; b=rQdBuczt5HsTy5GRo7CZNV1RJvhoDhoJ1e7w7h7t/xKU3PWsOibDFOiJ9vK+6VAHQ7ibazqVqMNNIlMb1GD+RiEWH+FoHqG3bnBsrGS3EcO/p+r5ovYR/6zHy+wExLJk2Avolb0o/WQis6+V4VboH2x5qsHqqCuUtCRn7o/YVms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740651738; c=relaxed/simple;
	bh=T9BHAcLO2Fi8F/is/hh9AfEDFJvEd2NLh8ELZM2jcp4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E1mxh4TujMXUnQ1dRfPnmyR0TS414jErOr0AwCDGDU2r9C9mWvjjiQbSCtdXCVduMT8ZqW9MIDSBrzwbjHJwiAiAr1xcBzSGWdjlz/KSpqRKd7M6f+sETbfitEhcfMAHoCAUpOR24OF4NU02bwnW7bJKCV2ZnKEKkiS1uHzI+E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O+KWkRT+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740651735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UlN7ERFRgkJUG+zgZJ963Qv4eKnSMi6hs0/GkrW6sYs=;
	b=O+KWkRT+ar2JWhikvSCxrnFX9R+IsdSdLpOL4WNrt6gVvIb2IetlnvJmB7s9KYHAvaIQLv
	5I0/st+bsAE3dUsqNAyPvkfgaZxke4wQqEkQVU3OMi+PMo7ACaS0UpWPsFC76wyRKbz6zH
	r/dQVUdyZv9shUgzjpyjVe9SYnJAbgc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118-B0vF_5qUNvuj1mPt8RkL3w-1; Thu, 27 Feb 2025 05:22:12 -0500
X-MC-Unique: B0vF_5qUNvuj1mPt8RkL3w-1
X-Mimecast-MFC-AGG-ID: B0vF_5qUNvuj1mPt8RkL3w_1740651731
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5e041305a29so675601a12.2
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:22:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740651731; x=1741256531;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UlN7ERFRgkJUG+zgZJ963Qv4eKnSMi6hs0/GkrW6sYs=;
        b=B3/icV4Vc6HuZzjiSY10TIA1tvmakPf0jD9ssYgc7PcqUDOmTP8oY5DOgV6VY4Z0o2
         IKs4frnJj0H8D+eHR+fuN79WAHGF+PBQND1TRziYzkZbDK3xOvh1Tu0pwNHPqt3AwzL6
         UHBvdpBlOC+AHRbV30hrKQRK4BR45FzAbxBGXlMX/2PeuKwyratpWGOIxb1DgcViLr6X
         Ossr6WM2i/S+OFS65hQUrb+EPcAWatwS1wbHyJiZeSSEPzFDCwpSgvCKuAbs6SwBSY0b
         yTo2D3OpJFaQK51kdtt5y46ZGVBq8mfYvYMjX0gvcYvomervRCtdr5ekpWPOgVi8PuLR
         dcpw==
X-Forwarded-Encrypted: i=1; AJvYcCUFULKI69kaWMNGb9k+5w94Mex/ClGQ1v2CyDs+1Y9noGwY1g0TfvSsqq5rmxTmEX54ADI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6zzO896U8/VVqrugw55TEK+ajNDTvWC2gKZD12oL33cILrzSH
	pJc0UBWXl8pKJazmP0hRoD7Ln8d4Hgm3jLE63+fBHqIaN9ZoZv9z1UsSV4PSAkCrt2+UsTGjcXw
	ZVGKJ0BCySR0HckBchwbwyZ4K3tpyA+XJV4828rHw9IRJlqhNmKZK9i3kGYSrZoBHYLwMtVjVvC
	dRw+KKQgYgQPfOOizf39+uxIFr
X-Gm-Gg: ASbGncvY1HIrFQAturr8cyd+CHAhy8q5UcGk3V5i5zVrsfNwddvcH8mEEydiad5PXiF
	A/RC/ObNE78NcS4UctKcb2l6f/SATQA7Q0SY/r98Fq0H9NSyJGGBjOaHnUaQAQwN7OpW7UBFspQ
	==
X-Received: by 2002:a05:6402:238f:b0:5e4:9348:72c3 with SMTP id 4fb4d7f45d1cf-5e493487986mr7779707a12.10.1740651730973;
        Thu, 27 Feb 2025 02:22:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF3pM8WlV3oQBfytyyeOaQOimRV0KwS4EKHWJ5i0zUzAv1yCmDn5hX3VcUGzB4vcvxPmQuMR1bS9CT94wGST18=
X-Received: by 2002:a05:6402:238f:b0:5e4:9348:72c3 with SMTP id
 4fb4d7f45d1cf-5e493487986mr7779686a12.10.1740651730586; Thu, 27 Feb 2025
 02:22:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250226213844.3826821-1-kbusch@meta.com>
In-Reply-To: <20250226213844.3826821-1-kbusch@meta.com>
From: Lei Yang <leiyang@redhat.com>
Date: Thu, 27 Feb 2025 18:21:34 +0800
X-Gm-Features: AQ5f1JpeYWXlUn8jsieYhOpf1esALXljPtGnrofbGi8hLpfdoH4ms9lz0ZIIMxk
Message-ID: <CAPpAL=yffyhUrdEJHtAw4BDpV-=Z5mZq0r1ZFcoj1v1OBLnp_g@mail.gmail.com>
Subject: Re: [PATCHv2 0/2] kvm/x86: vhost task creation failure handling
To: Keith Busch <kbusch@meta.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org, 
	x86@kernel.org, virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Keith

There are some error messages from qemu output when I tested this
series of patches with the virtio-net regression test. It can
reproduced by boot up a guest with vhost device after applied your
patches.
Error messages:
Qemu output:
qemu-kvm: -netdev {"id": "idoejzv8", "type": "tap", "vhost": true,
"vhostfd": "16", "fd": "10"}: vhost_set_owner failed: Cannot allocate
memory
qemu-kvm: -netdev {"id": "idoejzv8", "type": "tap", "vhost": true,
"vhostfd": "16", "fd": "10"}: vhost-net requested but could not be
initialized

My tests based on this commit:
# git log -1
commit dd83757f6e686a2188997cb58b5975f744bb7786 (HEAD -> master,
origin/master, origin/HEAD)
Merge: 102c16a1f9a9 eb54d2695b57
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Feb 26 16:55:30 2025 -0800

    Merge tag 'bcachefs-2025-02-26' of git://evilpiepirate.org/bcachefs

Thanks
Lei



On Thu, Feb 27, 2025 at 5:40=E2=80=AFAM Keith Busch <kbusch@meta.com> wrote=
:
>
> From: Keith Busch <kbusch@kernel.org>
>
> The suggestion from Sean appears to be successful, so sending out a new
> version for consideration.
>
> Background:
>
> The crosvm VMM might send signals to its threads that have entered
> KVM_RUN. The signal specifically is SIGRTRMIN from here:
>
>   https://github.com/google/crosvm/blob/main/src/crosvm/sys/linux/vcpu.rs=
#L651
>
> If this happens to occur when the huge page recovery is trying to create
> its vhost task, that will fail with ERESTARTNOINTR. Once this happens,
> all KVM_RUN calls will fail with ENOMEM despite memory not being the
> problem.
>
> This series propogates the error up so we can distinguish that from the
> current defaulting to ENOMEM and replaces the call_once since we need to
> be able to call it repeatedly due to this condition.
>
> Changes from the v1 (prefixed as an "RFC", really) patch:
>
>   Instead of using a VM-wide mutex, update the call_once pattern to
>   complete only if what it calls is successful (from Sean).
>
> Keith Busch (1):
>   vhost: return task creation error instead of NULL
>
> Sean Christopherson (1):
>   kvm: retry nx_huge_page_recovery_thread creation
>
>  arch/x86/kvm/mmu/mmu.c    | 12 +++++-------
>  drivers/vhost/vhost.c     |  2 +-
>  include/linux/call_once.h | 16 +++++++++++-----
>  kernel/vhost_task.c       |  4 ++--
>  4 files changed, 19 insertions(+), 15 deletions(-)
>
> --
> 2.43.5
>
>


