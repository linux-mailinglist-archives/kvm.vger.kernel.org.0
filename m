Return-Path: <kvm+bounces-53969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BCFCB1B082
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 10:53:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95E877AA571
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 08:52:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B14B52594B7;
	Tue,  5 Aug 2025 08:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YZ5BFIPc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f195.google.com (mail-lj1-f195.google.com [209.85.208.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7E025394C;
	Tue,  5 Aug 2025 08:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754383998; cv=none; b=Wa5Dv2EgJtu98DCxACd1uEwscPRjJd/1vPP0jMW2qOEFf3Dap40TOU/QaL6D2pcXz5eiYawo7ZNyZmsUVv/4ShGn2KMDdg8PPIpea+wXZfu8v2vBZNJDudnBxilkCv/h2qoTaFCjVK+LWfcmFNlhiAj+P+/ZrdDFTc8vjG4NBsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754383998; c=relaxed/simple;
	bh=bmc3fqkz5l4aFYJYtB/WgxFSjibZd7amLkHxt3HSOPY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KD45cNW4rz5ihR4Urxrc2E2kxGkpVy73R5W7GxW1Rnno9QadHdN0gXYRT4Y1c+aj9VyQ9u+1kaPfjgKIAhVpWAEm5RiZBU50LcudsQmqIk1c3DUxEljQT8h+RVMqR0+2S8KeCyPEQWNLZy+MpI5z9/pxhgtNLQV+lkt2v7pRYr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YZ5BFIPc; arc=none smtp.client-ip=209.85.208.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f195.google.com with SMTP id 38308e7fff4ca-33229f67729so45065341fa.1;
        Tue, 05 Aug 2025 01:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754383995; x=1754988795; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ibHjp0RKgyKqNDDPGolCzlUBv8FDlz7MwKF0ZylR1+w=;
        b=YZ5BFIPcd3WD/WadFtOv28wKsaALh7Dbmvlx21qsBOm/mdmWlS++Lqy8R5lB3FyaJI
         P0PgRF/Tx1R+6REmJF89tKKPUVy3Q+PvubLnaNwClMPkiKPV6r1nNGOm7nshaFhRs0lZ
         k/NSTAO3f9stoPSLwWH9EH8D6nmfDHP8kAg012pJ2OG2Oq3VuM8wTKVKK3+Z+5WSSjch
         3nA0pudgxJAqtXJmWTQcd8h63RZZ+9Fght6bx0fAj9wepyWu2iVD27QaSSedyhQIAXJA
         qZfHfgDZKdc6xXTNukBDQGs7X8JeLZ4IW8jxtNsclmSJLkx+JKA1oWo4KNCXAqTYtDFs
         gmfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754383995; x=1754988795;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ibHjp0RKgyKqNDDPGolCzlUBv8FDlz7MwKF0ZylR1+w=;
        b=ksMKhuHL70+yoOVCHihnLqJ9+/ImpHNjaPn98mHNxKKKJPnFeuf4FEMvBOOtZ6v2iz
         SKor8+xK/JOn67wlBV+qxwnKPW60TBVUOBBlao1gXOKo+aXhHeHcoiKb8rvdUvwpe68H
         MpWekvYAonrKIamYy9WMFIxL1Ujk6PaAYqCeNm+oeswDRXt9S8joeOr3Eq79WCKb2Tk4
         DzAGduCw0ScQD4ZydNa6ZUdIob2Z2ZqkDD7gKFSJXuyRpHUIVCBU5KpQWomEnO4+k/ab
         7U7qEndC9DCFWDRwW+VL487sEs20TvElcBiMtJ6QHMbBhqxzu0u6NyPIHdJvYs7gQIJR
         MFUQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0vy6YLwxlsBnftv9EEaUIDrpimRXYcRTX7K3dgaPZOYryYa74dtOAeiZdHEqq9jRRSRc5G19FM26Md6m5@vger.kernel.org, AJvYcCW2GhBZYWRNioOOFHItVIFmkFt0HkxbpKBgwvJfia27smjIRYds2xIstHR182b5aDTPKtCwqYBA@vger.kernel.org, AJvYcCXtWjgLdDs9ddhys7LEWXGlS6TFDzH68iDrnuvkTG/A+uCb+ZhEJhG+ih2Qh/ZqHoVApjA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLeFvJCp/IMN0xoZoWFWStZZZ3Z3m57HKtHqMJW9+NtvMtksfN
	MToALQ/XPEBtn4lQ9UFMP6F3mqOr93f4Qb+hKu5xrslREswjWhkB3BdAvlsbKrEviIdyMJYrork
	+5nLiOtDfMnV2XaQnThAgYKiRAuj56DM=
X-Gm-Gg: ASbGnctc/wCODsv3S6mL6Vyfud/miYKoKC8UvxwWuBY17rsOtgR8Fa4l0VoLSJ/LDVN
	bzwdOl2Cx4Mt3YXnyh8jN5oRalOrdiOER2C7yQJoowfDeyGpennYvm21YO89vJ0Oytux0Y+WZBn
	4vECUd19aE0we8ZV8eAeMktn4P44/YECjiBZwNCiSX2I9fD7yDkK3UA/fNXU7uqhEJxswdSlXEL
	EeZPNo=
X-Google-Smtp-Source: AGHT+IFD5XNw8cP384FaLMCLrTz2I87FHqRB6f/qwltp9qO9etEP6nue9QDshjhDWfCXFPjNxtkFMqihQ3uLrVpxQEI=
X-Received: by 2002:a2e:a54f:0:b0:332:45b5:d665 with SMTP id
 38308e7fff4ca-33256709372mr32288541fa.11.1754383994891; Tue, 05 Aug 2025
 01:53:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250805051009.1766587-1-tcs_kernel@tencent.com> <4sbamls46k3dxlqgreifhhhd66iaosbeoxgbpyvwaipwlnwiba@dep4mseknust>
In-Reply-To: <4sbamls46k3dxlqgreifhhhd66iaosbeoxgbpyvwaipwlnwiba@dep4mseknust>
From: henry martin <bsdhenrymartin@gmail.com>
Date: Tue, 5 Aug 2025 16:53:03 +0800
X-Gm-Features: Ac12FXzozgbryRFZfZ8Jbwl1TrTa0Ad2T4Xt810HLdQs9hEAdhKtjpUCUff4i9Y
Message-ID: <CAEnQdOr+Gnk7MW3di-=EDD92BR1C1m0P5pK=Fz6ov5iUH+=u2w@mail.gmail.com>
Subject: Re: [PATCH v1] VSOCK: fix Information Leak in virtio_transport_shutdown()
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: huntazhang@tencent.com, jitxie@tencent.com, landonsun@tencent.com, 
	stefanha@redhat.com, mst@redhat.com, jasowang@redhat.com, 
	xuanzhuo@linux.alibaba.com, eperezma@redhat.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Henry Martin <bsdhenryma@tencent.com>, 
	TCS Robot <tcs_robot@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the quick review. You're right=E2=80=94this patch is a false
positive. Modern compilers zero out the remaining fields, so the fix
isn't needed.

I'll be withdrawing all the patches and will ensure we more carefully
evaluate our robot's findings before submitting in the future.

Thanks for your help!

Stefano Garzarella <sgarzare@redhat.com> =E4=BA=8E2025=E5=B9=B48=E6=9C=885=
=E6=97=A5=E5=91=A8=E4=BA=8C 15:01=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, Aug 05, 2025 at 01:10:09PM +0800, bsdhenrymartin@gmail.com wrote:
> >From: Henry Martin <bsdhenryma@tencent.com>
> >
> >The `struct virtio_vsock_pkt_info` is declared on the stack but only
> >partially initialized (only `op`, `flags`, and `vsk` are set)
> >
> >The uninitialized fields (including `pkt_len`, `remote_cid`,
> >`remote_port`, etc.) contain residual kernel stack data. This structure
> >is passed to `virtio_transport_send_pkt_info()`, which uses the
> >uninitialized fields.
> >
> >Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
> >Reported-by: TCS Robot <tcs_robot@tencent.com>
> >Signed-off-by: Henry Martin <bsdhenryma@tencent.com>
> >---
> > net/vmw_vsock/virtio_transport_common.c | 15 +++++++--------
> > 1 file changed, 7 insertions(+), 8 deletions(-)
> >
> >diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/vir=
tio_transport_common.c
> >index fe92e5fa95b4..cb391a98d025 100644
> >--- a/net/vmw_vsock/virtio_transport_common.c
> >+++ b/net/vmw_vsock/virtio_transport_common.c
> >@@ -1073,14 +1073,14 @@ EXPORT_SYMBOL_GPL(virtio_transport_connect);
> >
> > int virtio_transport_shutdown(struct vsock_sock *vsk, int mode)
> > {
> >-      struct virtio_vsock_pkt_info info =3D {
> >-              .op =3D VIRTIO_VSOCK_OP_SHUTDOWN,
> >-              .flags =3D (mode & RCV_SHUTDOWN ?
> >-                        VIRTIO_VSOCK_SHUTDOWN_RCV : 0) |
> >-                       (mode & SEND_SHUTDOWN ?
> >-                        VIRTIO_VSOCK_SHUTDOWN_SEND : 0),
> >-              .vsk =3D vsk,
> >-      };
>
> The compiler sets all other fields to 0, so I don't understand what this
> patch solves.
> Can you give an example of the problem you found?
>
> Furthermore, even if this fix were valid, why do it for just one
> function?
>
> Stefano
>
> >+      struct virtio_vsock_pkt_info info =3D {0};
> >+
> >+      info.op =3D VIRTIO_VSOCK_OP_SHUTDOWN;
> >+      info.flags =3D (mode & RCV_SHUTDOWN ?
> >+                      VIRTIO_VSOCK_SHUTDOWN_RCV : 0) |
> >+                      (mode & SEND_SHUTDOWN ?
> >+                      VIRTIO_VSOCK_SHUTDOWN_SEND : 0);
> >+      info.vsk =3D vsk;
> >
> >       return virtio_transport_send_pkt_info(vsk, &info);
> > }
> >--
> >2.41.3
> >
>

