Return-Path: <kvm+bounces-14071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C78C789E9BF
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 07:29:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C78A1F2621B
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 05:29:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D38D20DDB;
	Wed, 10 Apr 2024 05:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LMPphPgG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8D112E73
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 05:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712726963; cv=none; b=AIfazMS3wWoXnqcPt9odueSvgyWeJwAHDOd5350TyI1LDpV6n7PcfSCbM3tGnvVsnkGCPOWdX51muZZFy2CAtp84hXOPgHgGuLbfY7vE/yDsWHzU0cYis5d86+xHHJ2dvdEVZQ9BeM+Yuxh1ZhG6TWFuxuH3yEY/09fI68BETXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712726963; c=relaxed/simple;
	bh=Garsb0yrb09cyxnrIqAQEaABu4EXVm1wLQ8zJlWQFy0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=k4dk8adrY6SrEj2IFnYjEyUBU9y6aRJGm/03dpfWzU0hMHzB6SRKYnY6dNQJ+d9Blb7/57wbik0pMtXjRRFcULr3epwtlmTXj4J3JQGL3PgejhY1TZEirD804jGIuZB2PB8Rxuzvq9fMwWamV7fRGxUKvLRewNQ2/guAUDv8Hto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LMPphPgG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712726961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ALjg/ntug4MBk1XtNMajyyKljj175m906YvGN0uC3zY=;
	b=LMPphPgGBfnULwj62/FP37FOrr5fBXbAv/+q3NeLQYeFSiuzs6gLfsTTbpgfK6cR1+EVK0
	xAKC5g22yiE3L6c5KqlkS8QHvBuppIG2zR/moTpiRNsEGKqBZFRrYk2COI3gczPsst75Th
	85XmRNcUu2o2OCESsG+tNdY7o0fSZ9I=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-dNlsclhZOZWHl8JD-5rm3Q-1; Wed, 10 Apr 2024 01:29:18 -0400
X-MC-Unique: dNlsclhZOZWHl8JD-5rm3Q-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a5199cc13b2so432325166b.0
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 22:29:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712726957; x=1713331757;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ALjg/ntug4MBk1XtNMajyyKljj175m906YvGN0uC3zY=;
        b=hvZ7fXBWhGNhbbKifD22MNRWx3Lmm0jNxJPEzQBsUvg3ExSh+WOBljnJgZ/uEPX7Iu
         nElD7wjUQCI2Jpvo7Xczjlk0Bp591HKWG1smR2FQGGGGxIc5U3w491k3WDWbzL5b8XWh
         +L7bcFXGp4kRpOkrTsWIzcTeUqjnNBN4be8XIT5GPxvJ3sRwb4fhh0PdbgAQMfym6mVP
         7XyufmGiKukfdOQPLv5V6zydutZTgHlbMODsil4CWd2KqAGY0+lylhc88SSSXTvU0JN2
         12GDhwFvjG2psG+DY1Yr3EMAKz3YzcTOO6j3Kdj/qYl1Kf4cV+4UF870/o4SBY3/Edpv
         pipQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSSOUCut9RTLbVc4+FqRtwzw1s/Ia+nY6Tpqv/f2mHOF94QYo1vqiixYrej96WZ1SJKJPhzYZxrgfbUfaNxARErCaP
X-Gm-Message-State: AOJu0YxyV2JtbyMplaYILIf3f8clcUHcP1PERTNp4RHGbdo2oXYQAR9x
	PaDbY9qiK7lWlUP6EQxiiHQa7APXC0tfOAqUkSbQhL799LsIRxx05+Zairk04SE7HYdS/E7uurz
	8nmyCrnCNkWazJAa+SVFgV6hKOsasWT7mBySp4RLpLrZVVgyAE6exf5MTLSHXB/uf78kU6Vk5Jr
	dEj6NOcuUztvP2ktY2JZlyC+nn
X-Received: by 2002:a17:906:4899:b0:a51:b49e:473e with SMTP id v25-20020a170906489900b00a51b49e473emr1381816ejq.19.1712726957037;
        Tue, 09 Apr 2024 22:29:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9ro1TSS6P51R8HAGDNJrNtBNNdENLxX7oHAMyEfVHKQkSe40Ls/G0b/qqZdnwgw3ZDazI/7T4ggthUqEqHRk=
X-Received: by 2002:a17:906:4899:b0:a51:b49e:473e with SMTP id
 v25-20020a170906489900b00a51b49e473emr1381809ejq.19.1712726956864; Tue, 09
 Apr 2024 22:29:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240410043450.416752-1-lulu@redhat.com>
In-Reply-To: <20240410043450.416752-1-lulu@redhat.com>
From: Cindy Lu <lulu@redhat.com>
Date: Wed, 10 Apr 2024 13:28:39 +0800
Message-ID: <CACLfguW-o8ox5zmXdmr4Phm-8zSX3sWif8CtNDynW6kRH2fBoA@mail.gmail.com>
Subject: Re: [PATCH v2 0/1] virtio-pci: Fix the crash that the vector was used
 after released
To: lulu@redhat.com, mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry, send to the wrong mail list, please ignore it

On Wed, Apr 10, 2024 at 12:35=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrote:
>
> During the booting process of the Vyatta image, the behavior of the
> called function in qemu is as follows:
>
> 1. vhost_net_stop() was triggered by guest image . This will call the fun=
ction
> virtio_pci_set_guest_notifiers() with assgin=3D false, and
> virtio_pci_set_guest_notifiers(=EF=BC=89 will release the irqfd for vecto=
r 0
>
> 2. virtio_reset() was called -->set configure vector to VIRTIO_NO_VECTOR
>
> 3.vhost_net_start() was called (at this time, the configure vector is
> still VIRTIO_NO_VECTOR) and call virtio_pci_set_guest_notifiers() with
> assgin=3D true, so the irqfd for vector 0 is still not "init" during this=
 process
>
> 4. The system continues to boot,set the vector back to 0, and msix_fire_v=
ector_notifier() was triggered
>  unmask the vector 0 and then met the crash
> [msix_fire_vector_notifier] 112 called vector 0 is_masked 1
> [msix_fire_vector_notifier] 112 called vector 0 is_masked 0
>
> To fix this, we need to call the function "kvm_virtio_pci_vector_use_one(=
)"
> when the vector changes back from VIRTIO_NO_VECTOR.
>
> The reason that we don't need to call kvm_virtio_pci_vector_release_one w=
hile the vector changes to
> VIRTIO_NO_VECTOR is this function will called in vhost_net_stop(),
> So this step will not lost during this process.
>
> Change from V1
> 1.add the check for if using irqfd
> 2.remove the check for bool recovery, irqfd's user is enough to check sta=
tus
>
> Cindy Lu (1):
>   virtio-pci: Fix the crash that the vector was used after released.
>
>  hw/virtio/virtio-pci.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
>
> --
> 2.43.0
>


