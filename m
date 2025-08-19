Return-Path: <kvm+bounces-54986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C7E1FB2C5F6
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 15:45:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D7A9B1B62DEA
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 13:42:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AE2833EAE1;
	Tue, 19 Aug 2025 13:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XTId6T+a"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DDE1D514E
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 13:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755610899; cv=none; b=N2mb+4g6hQsfrGEzZ2LcwglseoLH4wv00qFfSV4U5eZctWCt77zzK+4UEZWEVLzJt6CjeP0mzTPc2aFedLPSBSTzxEHI8KTan8mfrJ7OiZ2/8IJGG3jLvyfsGvcVc9JlczJogQhasUYeDfLMRKv578eKKoeupK/7EyYQRFOZPfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755610899; c=relaxed/simple;
	bh=45kfBlIx/c2YzCpopNGEzgYrDpvm5CQrUb7RS9hYw5M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FzeaM/L6eAxiTtgYFD7uu3cQxsDq2gX2nQqcEPx6QyjzReGGA4oPdlMmp/hN0Fxgoqfj6ysS7UAk4mMF3MYh7XsM7kaNIkoq/83Ezdm8NBnMR9bDhk6h9wZCP1Ulk4fzcchf8opieligdmYd/zY+idBXVSWUSYU94dbqXB4NHcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XTId6T+a; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755610897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EujI76cBsDT4aJDRz+24Ho6Ic52R+N90rhwAuXHewjk=;
	b=XTId6T+acdN3hpv9jXPBq63m2l+BTsnhsPfigvwXtAGxIH0LpGEm+1m/eb6hSBm3I7UtKz
	kS78Xmx+ARo6ETuIop2IuLhKnNN2J4VrFYI3+usxbVEBDFElRzF818bWGJUIg/yd9k5YEJ
	YOErgPCLU2nzQ+s58VrJhL0ErdS4koM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-VDnqAddHM4OtJMShgtMOJw-1; Tue, 19 Aug 2025 09:41:35 -0400
X-MC-Unique: VDnqAddHM4OtJMShgtMOJw-1
X-Mimecast-MFC-AGG-ID: VDnqAddHM4OtJMShgtMOJw_1755610894
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-afcb5f59d9fso437162366b.0
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 06:41:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755610894; x=1756215694;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EujI76cBsDT4aJDRz+24Ho6Ic52R+N90rhwAuXHewjk=;
        b=ZySotESSwWucvP0NlLGzkyM3R6XdRquEB6bnVTFJ8jIJLBv8XzacHi3oQC9cfgq4/V
         PhHD5k4tRU+RFDDdH4HOrWe7lNSndzsW96CWdAdC/ZsvAyJ4XGRGgxxIZdribhjk9QQT
         N2YroqQfMrCy9+joi2JRCKnlEKU2iGFKcLdxJQhcRUjC+zHjOifp6AoyBk28aPDxhOjZ
         nlqnm+CX+JgllpIQDYNgw8ac3V1CFdy1PvaeQLfSZ3482kdpdVzdzxqYxxjaV/WcLTaU
         /i1hqXkAkZagdPO7ygv0sWcdNKH4WBNg+c+fNVNfJ3vP4xfAU/eCjbY1B4VdrkHX02U1
         mn3w==
X-Forwarded-Encrypted: i=1; AJvYcCWyXPtXW/Awt2ZdmGetV4RlDz6/VPqpl9+iievBGNPzWajIXozxw3+2n3cSoN4UHzjWEoc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbBf4QKldQzuViJ39f4s5OrFRxWDA7XAqx1DoAmWNCxFMfLxbM
	7++l3NmDykmX2zce2GLL9GGzepM0qdWOP8UtdPmi9RHIEZZhg3dHGWc06ItGvXfcWc+8gMWn2qr
	t7RifI6VjoPTB1a6URDD/M7jDhOnSEvC0HF96Ww4wCO4dGcN1zN3XKqFqk4mRaSfw5VWBnvn0do
	FQR/XyLdSz833hZYfZzNPFQgZi6yv8
X-Gm-Gg: ASbGnculqyovDsJvS3DTKjtD2kHnfpaZ+tqtdPYl7tbzzXQED5hv1x82JVGgIX2nd7T
	bxzHUmHjTbTtxP2dPqySg5lUC/4uFyRYGxBCAm2/R4mMOVWKj1q4sHlWYwbiWwcPu7WKa+4I9Ba
	v8OBQKeclDSG3vyFThsIfnYA==
X-Received: by 2002:a17:906:164f:b0:afd:eb4f:d5cc with SMTP id a640c23a62f3a-afdeb4fe8d9mr16481666b.31.1755610894088;
        Tue, 19 Aug 2025 06:41:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH1GVsEmsaG7XrNaXe8wonzWZoX3xXdB8eON+UVwMeu7PAq8S6nacljTSpJPy0fGiNqSMsvj1L05aVdNrtBjig=
X-Received: by 2002:a17:906:164f:b0:afd:eb4f:d5cc with SMTP id
 a640c23a62f3a-afdeb4fe8d9mr16478566b.31.1755610893561; Tue, 19 Aug 2025
 06:41:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACGkMEvm-wFV8TqX039CZU1JKnztft5Hp7kt6hqoqHCNyn3=jg@mail.gmail.com>
 <20250819063958.833770-1-namhyung@kernel.org> <20250819072216-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250819072216-mutt-send-email-mst@kernel.org>
From: Lei Yang <leiyang@redhat.com>
Date: Tue, 19 Aug 2025 21:40:57 +0800
X-Gm-Features: Ac12FXwPH4sSIUdUFp_9NFkFDCQTsp7XMFuiZKn4U01cioGDSa8UFneCp5B5QWs
Message-ID: <CAPpAL=xm9sgU=8b4TTYSMBYkdmgxmdx4PXFPGwYe3qkqcCh=3w@mail.gmail.com>
Subject: Re: [PATCH] vhost: Fix ioctl # for VHOST_[GS]ET_FORK_FROM_OWNER
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested this patch with virtio-net regression tests, everything works fine.

Tested-by: Lei Yang <leiyang@redhat.com>


On Tue, Aug 19, 2025 at 7:25=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Mon, Aug 18, 2025 at 11:39:57PM -0700, Namhyung Kim wrote:
> > The VHOST_[GS]ET_FEATURES_ARRAY ioctl already took 0x83 and it would
> > result in a build error when the vhost uapi header is used for perf too=
l
> > build like below.
> >
> >   In file included from trace/beauty/ioctl.c:93:
> >   tools/perf/trace/beauty/generated/ioctl/vhost_virtio_ioctl_array.c: I=
n function =E2=80=98ioctl__scnprintf_vhost_virtio_cmd=E2=80=99:
> >   tools/perf/trace/beauty/generated/ioctl/vhost_virtio_ioctl_array.c:36=
:18: error: initialized field overwritten [-Werror=3Doverride-init]
> >      36 |         [0x83] =3D "SET_FORK_FROM_OWNER",
> >         |                  ^~~~~~~~~~~~~~~~~~~~~
> >   tools/perf/trace/beauty/generated/ioctl/vhost_virtio_ioctl_array.c:36=
:18: note: (near initialization for =E2=80=98vhost_virtio_ioctl_cmds[131]=
=E2=80=99)
> >
> > Fixes: 7d9896e9f6d02d8a ("vhost: Reintroduce kthread API and add mode s=
election")
> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>
> Applied, thanks a lot!
>
> > ---
> >  include/uapi/linux/vhost.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> > index 283348b64af9ac59..c57674a6aa0dbbea 100644
> > --- a/include/uapi/linux/vhost.h
> > +++ b/include/uapi/linux/vhost.h
> > @@ -260,7 +260,7 @@
> >   * When fork_owner is set to VHOST_FORK_OWNER_KTHREAD:
> >   *   - Vhost will create vhost workers as kernel threads.
> >   */
> > -#define VHOST_SET_FORK_FROM_OWNER _IOW(VHOST_VIRTIO, 0x83, __u8)
> > +#define VHOST_SET_FORK_FROM_OWNER _IOW(VHOST_VIRTIO, 0x84, __u8)
> >
> >  /**
> >   * VHOST_GET_FORK_OWNER - Get the current fork_owner flag for the vhos=
t device.
> > @@ -268,6 +268,6 @@
> >   *
> >   * @return: An 8-bit value indicating the current thread mode.
> >   */
> > -#define VHOST_GET_FORK_FROM_OWNER _IOR(VHOST_VIRTIO, 0x84, __u8)
> > +#define VHOST_GET_FORK_FROM_OWNER _IOR(VHOST_VIRTIO, 0x85, __u8)
> >
> >  #endif
> > --
> > 2.51.0.rc1.167.g924127e9c0-goog
>
>


