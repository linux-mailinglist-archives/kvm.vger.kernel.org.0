Return-Path: <kvm+bounces-64633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E1EB9C88CF1
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 09:59:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9628D4E9661
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 08:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8FDB31B119;
	Wed, 26 Nov 2025 08:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QxwwG9ZF";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="lEkmM3cX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557A72DCC03
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 08:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764147579; cv=none; b=kYzoqQVtLetfhXV73Mose3JtNHgnkBG5+2OdpkRfz9GaG2hIowN66Q8QuvSTwjFZjv5PlDcn15y7PebyvhV0qBG5G2YvvqSZ6hYtFMEypiaU6zMXQrKW5kFyrIn6bPM2ma3ZYo1ZrQwTVFTxfC7E1sWgJL8K5FBQvcnfO/XOlzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764147579; c=relaxed/simple;
	bh=aiqh2PAT/tWWNvpkdF1X6ErbenfRTCtAJHqiTHgh2SI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LpLKxFuNTNZjrFXo0lTO5FoTOnAevN2HMY0t0iFtE7G0D4PQUDjg7lTmdZkzg3juKBdoaYcpsz9b0QYfj+9H2MiKAiTjZcN990G9uUpM067BbTPCo+Ve/pBCgWIqMHWFT1sXjjaWQSr497TWc9hzQIqkDowkNkcz60wU3wmvOf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QxwwG9ZF; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=lEkmM3cX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764147577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gCL7wV9LGQe7mIrAFouPo/mWI9NXcq87rHeeVrQ0hwU=;
	b=QxwwG9ZF64qvaVKkpphk49obiaqDGYtKFvr/azWNQCM9GvErbsFCQnZUmRiO11Lzq3m2JA
	7qaFXiGgkK01S0Z8hBIUKDTYdA9ozCATEv0BmdklIzetS/LYwIqoC41OSNgQaSTKO3pLKD
	lUAJxIg+D1vAUp5cmXGXgu1gl2Q4wuE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-369-sgM2SuXnP8SKgnwGhAmUew-1; Wed, 26 Nov 2025 03:59:36 -0500
X-MC-Unique: sgM2SuXnP8SKgnwGhAmUew-1
X-Mimecast-MFC-AGG-ID: sgM2SuXnP8SKgnwGhAmUew_1764147575
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-42b3086a055so6162018f8f.3
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 00:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764147573; x=1764752373; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gCL7wV9LGQe7mIrAFouPo/mWI9NXcq87rHeeVrQ0hwU=;
        b=lEkmM3cXSeHI2PF59oyv/0qc4IsGG5bMj5VQY886pJR6TuwRqFb7yQHhOMMtPgotTf
         wq2+py261KDMFtPOMKHC1brI0FVqjw5fdcIZWost71fWPIh3t7iyXZw0r/cvrUG3Wlve
         ArzBFCH+55GBrpbSHZex0Y0OBcbxP/9MtvWpvGFlFXW0bsVhcuxUlC/U1e7irVoF8IMp
         ZoQsCzxtOFwUgVsqOlWMKcqlbaBIXJd6ha8gqOPexJ5RR4Q6o2I+LM8MT9lNAAahCIMY
         oUIvHSpTfPFInbHwo7h9yuka4YZfBQ+hNUKlXKbJ3NgtbKBIbxrV3pHBJlTB1oSooLco
         LG9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764147573; x=1764752373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gCL7wV9LGQe7mIrAFouPo/mWI9NXcq87rHeeVrQ0hwU=;
        b=nn+qyj4y8u5K+NCCzFxZVk8hbigq+OzofueroGATt7iPqEi+aCfecyQm4tIU1e1r5a
         CM2+ZsXTNcPxnZkH6Chc4ABe2yPndhym8A70qdh44OaTMOEaXrj+Z3pTYZKGPViZJPEr
         s12v3uoNg0iAS9m62p/O+jNtM/lOao2KUJFQN+NvaMSLEblwWmUt5I/92QgpNnKiz1Cu
         Ghb8J77vreuMahjwZjMKaG7Z/pZAM6RmfAJFgP+ZLNOpfyCwb1RD7e6ebP80+g4iXILe
         BsELc8QspB7zfo7B6T9Nmh4Z18cGs7kA1seQOAZodEqbQ5S+e6kE3LEjp+jpaKJ05yAH
         liQQ==
X-Gm-Message-State: AOJu0YzoKw7WSkwW6F7qBE+MW4Xj/dD5lJiujKqhqpYZ5yUBpwzCgHbb
	nZzWahAwytKKCaveU5eWqC5nQ8sY1tg4l1gxbNT5PTmCiek2xWyOXcb7j/JvnxDzqGFBCv91KWu
	BlIVjO2KmtssP3MrKUtLJ14NVYXm13Ndhm0Vi1tuymKo5RfcfgAWV4gYljXk5kI5edXh0x59MRJ
	Hm1mc38Dg0U2JKFdUqk0SgyT5YjBKD6hCwwgaV
X-Gm-Gg: ASbGncvtolA3/ofnjsn73nHPKy6PVvSE2RnOsz1M9rmRSv/KJaAjEKvYI02xb3ZLrXw
	pcDGn2ACqUF66aEwtASR1Agdk5XJDIvKF0v0lBRRhzxH0OB+okCoYKnFPFjEAQOdLibv0l+bFM5
	YWaGxyCQuAl5y6EIn/y+RkLJL8V0TeUsIRnXJ4cMd1z53dF16RawQymAg3D4aPQuSSNMXs6q9/Y
	sjtzXu7esdCmZOFDVB5LD+jIFaWf7mC9kPx9mESmvdHVGHzmEfQf0iy6pE59iTqQxxODTA=
X-Received: by 2002:a05:6000:2210:b0:429:d170:b3ac with SMTP id ffacd0b85a97d-42e0f21e7a9mr6114503f8f.13.1764147573402;
        Wed, 26 Nov 2025 00:59:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHLsDUmvVeT4AcKR9eh0qXIu/7mkfWzhZ/TD7aKx0WjQK6m7WMT6Atgs7YJjN7HQyh+gfo2ixjcxvVh82hkook=
X-Received: by 2002:a05:6000:2210:b0:429:d170:b3ac with SMTP id
 ffacd0b85a97d-42e0f21e7a9mr6114473f8f.13.1764147572989; Wed, 26 Nov 2025
 00:59:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251126014455.788131-1-seanjc@google.com> <20251126014455.788131-2-seanjc@google.com>
In-Reply-To: <20251126014455.788131-2-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 26 Nov 2025 09:59:21 +0100
X-Gm-Features: AWmQ_bnSmbCuOP7fhHAsd1knE2NADevOwTRymCg7-aOMP5fK7DHbQI-bNI6wfGs
Message-ID: <CABgObfbiEsPcQ=6goOwr2PcqoTBjivUYT-RfqBdTobWVrNPGFg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: Generic changes for 6.19
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2025 at 2:45=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> A tweak to account for an upcoming API change, and a doc fix.
>
> The following changes since commit 3a8660878839faadb4f1a6dd72c3179c1df567=
87:
>
>   Linux 6.18-rc1 (2025-10-12 13:42:36 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-generic-6.19
>
> for you to fetch changes up to 04fd067b770d19fee39759d994c4bfa2fb332d9f:
>
>   KVM: Fix VM exit code for full dirty ring in API documentation (2025-10=
-14 15:19:05 -0700)

This could have been even 6.18 material, so I pulled it first just in
case. Though it's pretty late now so probably not.

Thanks,

Paolo

> ----------------------------------------------------------------
> KVM generic changes for 6.19:
>
>  - Use the recently-added WQ_PERCPU when creating the per-CPU workqueue f=
or
>    irqfd cleanup.
>
>  - Fix a goof in the dirty ring documentation.
>
> ----------------------------------------------------------------
> Leonardo Bras (1):
>       KVM: Fix VM exit code for full dirty ring in API documentation
>
> Marco Crivellari (1):
>       KVM: Explicitly allocate/setup irqfd cleanup as per-CPU workqueue
>
>  Documentation/virt/kvm/api.rst | 2 +-
>  virt/kvm/eventfd.c             | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>


