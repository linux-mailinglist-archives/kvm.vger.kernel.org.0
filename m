Return-Path: <kvm+bounces-17388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D6A78C58DA
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 17:37:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F05B1C21A10
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 15:37:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8274F17EBA4;
	Tue, 14 May 2024 15:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lbF1N4hf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B11E3C467
	for <kvm@vger.kernel.org>; Tue, 14 May 2024 15:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715701029; cv=none; b=uFz/ei087tIrPaLPllrfQzuZHo2pQbUDyRsBDeadFju28ok7VbOSKMS3jsQC+TR5aqkJ6N4WrOF1+79DR1knxi9dTsuf/SPpt9+m78oZBYXbH1lHFYkaNQ89PqiFXdmqbU8neqHg5GxphKNydd4N9F/wneKDmka44XRZ/ESrqDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715701029; c=relaxed/simple;
	bh=fSMA9aAYBLIjIILh6Xnp5+5fDoWdqmTC0SuzgiPDCCM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BIahd5ZKV8yiKk/1t+tbtMabam5SX1hO7p9hpJuVtdyE/nxXy/2U8ovh4HP51sVgTnvBzQIbYNj80qtEQP1jGwmPkDDgtDF/VXBgdvUvG65ikUVA1d7OQJ/otueBQ3P9H8C4IkgscjGbjJmSpKq49wXcyseauYtE8XdFhRa/qDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lbF1N4hf; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-5b2d065559cso884780eaf.3
        for <kvm@vger.kernel.org>; Tue, 14 May 2024 08:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715701027; x=1716305827; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yMQb4KIHQDIrqPcbmE4v7Ll5kxEBDFIBZtt5pWk8wLo=;
        b=lbF1N4hf0YsLWMAA0WDPKYdIcDfpvBf3kSSPlbnxUInzTnKWBtutbeMDFoCjMdFBnV
         kq0+Hyeiv149gRWt5azDXrMB6N+kQETFQUyhDhI/pG5/ICKYu5ZqursQCMGEYUvi3dYq
         IfbehzH4ZBh6+elJJEFCTyneSzcg+Ry10vl7C2+3WkT56AKollBcknfQw22DeNhxGWgG
         MMaVoSXZIzh0iKQs/Xhp9UzHvDs3DwID88SwfpSfvsyHVj2gswCuGhMgeFfnLJjmpvGJ
         EKITdUQu3JD97vvCBOg9Rs1RyS6ecmf/WUbQCNvbdyaYceGZhp3uA8jhzVbb6XTydoeu
         04Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715701027; x=1716305827;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yMQb4KIHQDIrqPcbmE4v7Ll5kxEBDFIBZtt5pWk8wLo=;
        b=jJ65KFJA/eIswnvYqcamjvkf53nUWyUoSCLJeTq1PA/ZSuF/zoGble84Uh8jppASRb
         lxzeCLoBK6yFHKmJfoVK6g8Fs8DA0fZnxkYnbX9vgbgCZ1lt+731rrkW77UKvQW1tV0d
         wTtXD2vQ29hAJDov+wLTtQqumADnlF4elnc6Wo8zTG7QOEPWZq5iQF2vYnYq/1IXrPpX
         J4PsnddvAYqsWM7+ZD6pLwoACgEKHPrUC/pVYveEWhsSplNMRjufrgd/WXIF8VMvdrE/
         DzjkZcTScxmAJV/xwbxVFmcRxxrgDEeSLxAqCRg+9V27gXrx46z5qAlq42fd+QFNdwIo
         A5xQ==
X-Gm-Message-State: AOJu0YxFDo6DltIXnQhxjmvyVo1pCPSU9YqBElCSgm3DsoLw01/AUKtB
	IUl3uKLOF8STsfOhKLLLDzSh7+jBd0R3kFodc2E/XcZshT96Wkg9b++BKmCyEUYuJK7OESIj7YM
	17LA8M2nt86pJdXuLRilXfywh8vAmvquvupFYJA==
X-Google-Smtp-Source: AGHT+IGZJQTuPblwprrpW3KTWrqaGn4gyRtzPYNtktMcwbDoyg6o6qraweax4cgBhiPMo4nFti4Q/IMqmsQOEKoBUeA=
X-Received: by 2002:a4a:aa09:0:b0:5b2:73e5:1d9c with SMTP id
 006d021491bc7-5b2819a7b0bmr12235587eaf.6.1715701027461; Tue, 14 May 2024
 08:37:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1710566754-3532-1-git-send-email-zhanglikernel@gmail.com> <CACGkMEs1t-ipP7TasHkKNKd=peVEES6Xdw1zSsJkb-bc9Etx9Q@mail.gmail.com>
In-Reply-To: <CACGkMEs1t-ipP7TasHkKNKd=peVEES6Xdw1zSsJkb-bc9Etx9Q@mail.gmail.com>
From: li zhang <zhanglikernel@gmail.com>
Date: Tue, 14 May 2024 23:36:56 +0800
Message-ID: <CAAa-AGm1gYmeBG1QmZcdc0cPUeVGYU9UaFNdCdgu2+gG88A1Wg@mail.gmail.com>
Subject: Re: [PATCH]virtio-pci: Check if is_avq is NULL
To: Jason Wang <jasowang@redhat.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,
Two months have passed and this bug seems to have not been fixed.
Sincerely,
Li Zhang

Jason Wang <jasowang@redhat.com> =E4=BA=8E2024=E5=B9=B43=E6=9C=8821=E6=97=
=A5=E5=91=A8=E5=9B=9B 14:19=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sat, Mar 16, 2024 at 1:26=E2=80=AFPM Li Zhang <zhanglikernel@gmail.com=
> wrote:
> >
> > [bug]
> > In the virtio_pci_common.c function vp_del_vqs, vp_dev->is_avq is invol=
ved
> > to determine whether it is admin virtqueue, but this function vp_dev->i=
s_avq
> >  may be empty. For installations, virtio_pci_legacy does not assign a v=
alue
> >  to vp_dev->is_avq.
> >
> > [fix]
> > Check whether it is vp_dev->is_avq before use.
> >
> > [test]
> > Test with virsh Attach device
> > Before this patch, the following command would crash the guest system
> >
> > After applying the patch, everything seems to be working fine.
> >
> > Signed-off-by: Li Zhang <zhanglikernel@gmail.com>
>
> Acked-by: Jason Wang <jasowang@redhat.com>
>
> Thanks
>
> > ---
> >  drivers/virtio/virtio_pci_common.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio=
_pci_common.c
> > index b655fcc..3c18fc1 100644
> > --- a/drivers/virtio/virtio_pci_common.c
> > +++ b/drivers/virtio/virtio_pci_common.c
> > @@ -236,7 +236,7 @@ void vp_del_vqs(struct virtio_device *vdev)
> >         int i;
> >
> >         list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
> > -               if (vp_dev->is_avq(vdev, vq->index))
> > +               if (vp_dev->is_avq && vp_dev->is_avq(vdev, vq->index))
> >                         continue;
> >
> >                 if (vp_dev->per_vq_vectors) {
> > --
> > 1.8.3.1
> >
> >
>
>

