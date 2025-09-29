Return-Path: <kvm+bounces-58957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30AF7BA8118
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 08:07:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBFEB3A968E
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 06:07:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A48723D287;
	Mon, 29 Sep 2025 06:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iPRmIJZ/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35538238C36
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 06:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759126064; cv=none; b=cUkm0/aGBzh/eenwZTu77Apve9DgaAUl5HQvJkX4bNY0vWtRJs09xecxsjfZU/kzdGMs0lB97u2ViAm9Nz1S3m4Lmm8sWpJJNGvg+aEeKxtAJfsOPgO2H7Pjv/yaMo6XWL4Fldg3TsY03sk9eEErZ8TWvOR+MYuFfZqaSH0XjvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759126064; c=relaxed/simple;
	bh=IbEySVpKbLCFuZ9rrIjdK5cqttbR+AKe+UCoV2F1p5Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NxfHon2CDDx/sendYe4AYBDia7vkVB1KvveWmYMZfCXM6ogmcUip72PHXNLnx451HzJzU0tT++XvJKm5fsgdNcRCwWw0bX1hCKgrC2rQafsfuSoroH88zYa3G3NiC4XgOYoz96IIpFqtgOqgRebl1XQrX+g5QjOFA9KpMSIFueQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iPRmIJZ/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759126062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wBfJ6EZcrzpxQaUNzV7H/FmOU4A4hPZpwBb7rVCM3A0=;
	b=iPRmIJZ/O41BWHt9Bib6WEbZCsG9dw66mAo/o6tJ9/p3NWUauMi1kgExwXGQ9TDcE6KetC
	N7DrWNnva2d4Gj0rqIrrqaXpz5rMovTRlyn0Q8IzkOqWlkl/wsR1EuJfZvK8aqq+g7YCqD
	1DchwJx2//qOoKhddzKFQkDAQvKajZk=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-bREqQkstPaGD6z4o62yuJg-1; Mon, 29 Sep 2025 02:07:40 -0400
X-MC-Unique: bREqQkstPaGD6z4o62yuJg-1
X-Mimecast-MFC-AGG-ID: bREqQkstPaGD6z4o62yuJg_1759126060
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-6365645caf2so5807751d50.1
        for <kvm@vger.kernel.org>; Sun, 28 Sep 2025 23:07:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759126060; x=1759730860;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wBfJ6EZcrzpxQaUNzV7H/FmOU4A4hPZpwBb7rVCM3A0=;
        b=dqTsFco+CUyYtsES0Rz7Xwjx8HACHR4hs7K7Q5YZN7BfXXl25DSthK3NeWVb3x6TIp
         xOyP2IOSqYWogfdvewmH9ldSO9x/d8j6SDlik5OrkF1GnaKDaDEpn16urEyreucvPsBn
         /0aGh55TKaPJcG/aLLRof5V5gwxyAaQbxFVjP6W0UiqAOm9GRoADbGi07h+X2cNfBdn6
         IngvIPRxg76BF/OmTldhdEFkSQJB8y442e7vlz8GHUQO8qeLBq2YOlN1JyLapz8UYlyB
         vUdNpgGMC3Tjm/3rDiEYVzmNb0Jc9V7jCa/AoEeZfgwsNQ6jYfpWAkho2p4uK7ghyxN7
         d1Zg==
X-Forwarded-Encrypted: i=1; AJvYcCXq39yKUOvTR80JqTlM8YJy8ON7vuDhXJ8ruRrgDkPA6XrpjS/r3WsvzF2TcoOGNipgTww=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzr6i6S/DyofnMQQzil6pNZmFNArCGlsaza9emUJICcx6XYK1q4
	4GtsZ+l6TpimUnR30notmlcra9r/CO7X4o0CkPE4JeW5/Yk4YbGvI4KRT58HSIKLYICbmE/sGLh
	jzEet1RpA8DyEtmGjAyBlXo7g4X01ypi4WnRlbsMU3+X2JHsXy7EL4fgFD+sSC5hkIrGqq0KBWA
	GmdBb32XL09ZYrr8WwTCRbetIOU3uv
X-Gm-Gg: ASbGncupTPf0mYmS1MxbV+BzrC51/c8IQ+/5jA8eugMus/99AB9d15Cm5yrpp+vr3wa
	6HPEyZrxZ2DnStHkSAe+zXIKIz4zP1CsuC4XJa/sD50nFF73cOxW8qcFae8byPeekcB4kTuqUle
	Z/WzkYK1V8QPdIOmzP4GtOgoVqLsMbdKtEv6kP/39IG8g3QYM1J/ugPMF9dL/dSBHH5zNX6TBBr
	Bxt7O/H
X-Received: by 2002:a53:d208:0:b0:636:20c2:8eaf with SMTP id 956f58d0204a3-636dddd2be7mr7496555d50.20.1759126059830;
        Sun, 28 Sep 2025 23:07:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHruQhakXa8wGOKerNcye69UaAM4mVrSZQ9uhbK5P04HWTKnvPzXlUqVP3RMbc5y1i8ThnHdTlq1SvY2ch1664=
X-Received: by 2002:a53:d208:0:b0:636:20c2:8eaf with SMTP id
 956f58d0204a3-636dddd2be7mr7496534d50.20.1759126059494; Sun, 28 Sep 2025
 23:07:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <52c76446-117d-4953-9b33-32199f782b90@gmail.com>
In-Reply-To: <52c76446-117d-4953-9b33-32199f782b90@gmail.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Mon, 29 Sep 2025 08:07:03 +0200
X-Gm-Features: AS18NWC7XMXAuGMO8Eptz-Q_otll5LtJWRETocFL-g0lU0gc6j4WgNxpmozonlI
Message-ID: <CAJaqyWc58wnym96C79E-tG6yBvem5skE3M3vdzBxMYX0aNJVLQ@mail.gmail.com>
Subject: Re: vduse: add vq group support
To: "Colin King (gmail)" <colin.i.king@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 27, 2025 at 4:22=E2=80=AFPM Colin King (gmail)
<colin.i.king@gmail.com> wrote:
>
> Hi,
>
> Static analysis on linux-next has found an issue with the following commi=
t:
>
> commit ffc3634b66967445f3368c3b53a42bccc52b2c7f
> Author: Eugenio P=C3=A9rez <eperezma@redhat.com>
> Date:   Thu Sep 25 11:13:32 2025 +0200
>
>      vduse: add vq group support
>
>
> This issue is as follows in function vhost_vdpa_vring_ioct:
>
>          case VHOST_VDPA_GET_VRING_GROUP: {
>                  u64 group;
>
>                  if (!ops->get_vq_group)
>                          return -EOPNOTSUPP;
>                  s.index =3D idx;
>                  group =3D ops->get_vq_group(vdpa, idx);
>                  if (group >=3D vdpa->ngroups || group > U32_MAX || group=
 < 0)
>                          return -EIO;
>                  else if (copy_to_user(argp, &s, sizeof(s)))
>                          return -EFAULT;
>                  s.num =3D group;
>                  return 0;
>          }
>
>
> The copy_to_user of struct s is copying a partially initialized struct
> s, field s.num contains garbage data from the stack and this is being
> copied back to user space. Field s.num should be assigned some value
> before the copy_to_user call to avoid uninitialized data from the stack
> being leaked to user space.
>

That's right! v5 of the patch fixes the issue.

Thanks!


