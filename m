Return-Path: <kvm+bounces-56017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7B48B391A2
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 04:20:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A08B8366F63
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 02:20:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C992625228F;
	Thu, 28 Aug 2025 02:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fUo4cdnD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D82C199931
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 02:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756347588; cv=none; b=U7gp9GO0BKu+rWoERMcPHMvDbt5aIZI+KsiZKdjPpOGNWz7fh8g4LASH52d20W/PsjtHQf1ZQ2nCikTghC2sUMeUCJiu8V7nVhvqkDjhYXP/BdnAbIzNG80qhzWQ38jv2C+oUGv7bsRp2LIN/nWtJcYK2n0pgbgpfrr7x6O+gNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756347588; c=relaxed/simple;
	bh=hvnRnQeBlWogViGHqrd2JOdKSR/3mg9vBmKlLw/Pvz4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JTyogTCnct/vi3ldZShrhGGUP5VlcYrRaD7WRbEc3Zvy31ZQG4SYp+RJdKdfRbXT8RU1zJ77VSK43SCh34LgaOFgQ8QLwHE+CaSByjhgzwb3fvrRMiYaw8fXZvWpepWhuAOnkla/It9EbYLhIBbTj5LnTD/KXvQsz/ltUr2Z52U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fUo4cdnD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756347585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yuWJUdUgE10jBMdt4FfzRaIc9EOrRfX0+GmPYVYhe+4=;
	b=fUo4cdnDD4bQHIgvyADfwS5jTzr4vlzgzgTu2mnDIZaKIl3xzaQokh02DvV+3zP+0oNPNN
	HBH7ykCrPnO/LWLaa90m/+IWAOg1fkoeS45p1XrAqdF0EWVw/x7rRHhdNTos/5+Sh328Zm
	HyKDUtX4yebonoYZnWUApUUNilaBdzE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-466-3Lf32tkONAm91m0Q_EJPgQ-1; Wed, 27 Aug 2025 22:19:44 -0400
X-MC-Unique: 3Lf32tkONAm91m0Q_EJPgQ-1
X-Mimecast-MFC-AGG-ID: 3Lf32tkONAm91m0Q_EJPgQ_1756347583
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-afe89c157e9so57903766b.3
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 19:19:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756347582; x=1756952382;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yuWJUdUgE10jBMdt4FfzRaIc9EOrRfX0+GmPYVYhe+4=;
        b=UzAX3CEIp3DVNO+EE1nEzB/eQYTNy1ebPyIrqGLwj9jhkBEbpNbyROjGOZ4zpiiP9Q
         SZVP+B0XwfqoVIetD7RemfZsnUbA1PXTmOEPYetUKaYFihzaQhEqdt/jjHOyDtN7O6dB
         MYg1vYbwD/V4ozbZVffmL6xMtkdUKzc4Ru+Cknwn/GLgRkUGReYLmOc31vqkTgV6hE78
         MgM2/tU9ppkAsKK2Pmw9fF9jZ3NUBQmAdWwsgXx4R9Cs59Q0DrmcAlmcoYlcYDU0/9XM
         PIGk377nsooOd5k8fN2EGJZtuXvAcnnv9MyDdVqq4pCTakaF7Fn6Ujk5bl/lBqSsUwfz
         26XQ==
X-Forwarded-Encrypted: i=1; AJvYcCWo+EojMV2lEJEecqnMkaJAWvXv78x+jcxF1nYWYH0TmN0uzgHt+1OTMQoAb6BNuJ3e+WI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yym2/+7A1DgvIG2tupRkppO+NcBNDL62mzOEWlPvlrW98TBc3l8
	C56KPpeASflfv5KYezyZ3yEgDfGL2mbgPQySGm61IfPcPK9yoofWuAG7cNiwQ2artDAblx3G2ay
	OonxzwTSVwYshToMxs09uQ/IR/LK2cwxzaaVrUUD8cQescgVYEKMW61QNopZL5bww6kevCkQfyV
	RwGlK2AuY4K2tvzQ/jp8mHxQAVDrwLdVDBMKDf+R2t3Q==
X-Gm-Gg: ASbGnctPoJMhtW4CS3Jk3d9br2CSUm+/inKubXF83OOnJOewK3AS7248tRCbccSXDHG
	dRudaJdw4yK4IZX6yEeMLOKpDyVb580x8SX0BkUhf1Lej9XiRjCWStOyxeVQuCXEzYi502ojgKg
	M+c5UwvjlUh39iZ2kMKKoxKg==
X-Received: by 2002:a17:907:3e0c:b0:afe:c803:a0cf with SMTP id a640c23a62f3a-afec803db44mr338070766b.50.1756347582059;
        Wed, 27 Aug 2025 19:19:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEywnZxZXd+LrwXaJupMXn8D4KG8fZV7ZXo9Nhl8+J+/NoGVlVy9jGmEHSZX26lkU7wovhDS1MB/Wlat2HYVJY=
X-Received: by 2002:a17:907:3e0c:b0:afe:c803:a0cf with SMTP id
 a640c23a62f3a-afec803db44mr338068966b.50.1756347581664; Wed, 27 Aug 2025
 19:19:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250826004012.3835150-1-seanjc@google.com>
In-Reply-To: <20250826004012.3835150-1-seanjc@google.com>
From: Lei Yang <leiyang@redhat.com>
Date: Thu, 28 Aug 2025 10:19:03 +0800
X-Gm-Features: Ac12FXx3ye1m5pDHDoHQMdklVzQePg1kNlD8XHk5EhKfbtJVcOqPjtReEt75Bpc
Message-ID: <CAPpAL=wp61suVw-VdqpT-Kxxztaokg_-DkjsVEHDTg7rxzsnbw@mail.gmail.com>
Subject: Re: [PATCH 0/3] vhost_task: KVM: Fix a race where KVM wakes an exited task
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested this series of patches with vhost-net regression tests,
everything works fine.

Tested-by: Lei Yang <leiyang@redhat.com>

On Tue, Aug 26, 2025 at 8:40=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Fix a bug where KVM attempts to wake a vhost task that has already exited=
 in
> response to a fatal signal, and tack on a few cleanups to harden against
> introducing similar bugs in the future.
>
> Somehow, this only started causing problems when commit 56180dd20c19 ("fu=
tex:
> Use RCU-based per-CPU reference counting instead of rcuref_t") landed.  I=
 have
> no idea why the futex changes exposed the bug, and I don't care all that =
much,
> as this is firmly a KVM bug.
>
> Sean Christopherson (3):
>   vhost_task: KVM: Don't wake KVM x86's recovery thread if vhost task
>     was killed
>   vhost_task: Allow caller to omit handle_sigkill() callback
>   KVM: x86/mmu: Don't register a sigkill callback for NX hugepage
>     recovery tasks
>
>  arch/x86/kvm/mmu/mmu.c           |  9 ++----
>  include/linux/sched/vhost_task.h |  1 +
>  kernel/vhost_task.c              | 52 +++++++++++++++++++++++++++++---
>  3 files changed, 51 insertions(+), 11 deletions(-)
>
>
> base-commit: 1b237f190eb3d36f52dffe07a40b5eb210280e00
> --
> 2.51.0.261.g7ce5a0a67e-goog
>
>


