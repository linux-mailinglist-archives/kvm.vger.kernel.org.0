Return-Path: <kvm+bounces-61712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8952CC264C0
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 18:12:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D43911895479
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 17:10:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F016302141;
	Fri, 31 Oct 2025 17:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fud+pnBF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37F02FFF84
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 17:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761930577; cv=none; b=X+BY/FCAVeOurBeBoJxtWCYMGQx9B5EzMPhaHbnBGtJ9CjpXHI8GypvOGbuusOj/+JfXf89H9sH02tYHurx2XKc+XHY0OVVg15WI5FQMPfPY/4FeXarsr0ZXyLNaXQ7Uxv0hU6UHyH3xvw4pehBlrK8K+JQhgbn1I1zCEJ+arPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761930577; c=relaxed/simple;
	bh=Zal0qUvQYA99X2Dr2KFud1Dc/yidJYhG7mu7wr/gO1g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GvpCfKia8ywF63IfIAqsBHpkto9odVzDivcjp7W23gs5Z1GA20PG2bKb3jpQlphjL/B65GkpEztdpgkV4hlq0V+qcMpKBQlnqLOHcccNy3OhP2/GJTLMuc29669myntUmlqc2M+KzxvjdUXwTk0FmuB8Lb6UGmKc7HNKdqkmYR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fud+pnBF; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ea12242d2eso13271cf.1
        for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 10:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761930574; x=1762535374; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nL/56SuWwh5/Qtuu8QLg7wfoYDppiLXxfP3gfkDqRJ4=;
        b=Fud+pnBFejx6yO/IxC3TkqmhS8eDD2JHMypc/F5uQnEkPo766+5ZXPTdWVXrkTbJRB
         0r+nQyH3WHBHWhOAPUEGp+zGf0+LnPGLkp5bWszq64CCp4IS+lW1P7hyHutJ6CoVOeA+
         BqvAO1NVAinlMDpbdx4SU1y8/+7REObvRA8nw2UA7lSik7E79UymgPBXv/RvQB1go+8I
         doZ04JZMH1yY/I13et/lojuXDlAbxc7eUXAArZAR13n+TpIxwzbTcoQA0gQByhjeVglR
         fHgeP2WjxpIhP7hvjHAswQgPlgdIBxOgsaXBR931AYt9uLN4qEE4Ll5BZKxa3lXlLjIM
         nNAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761930574; x=1762535374;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nL/56SuWwh5/Qtuu8QLg7wfoYDppiLXxfP3gfkDqRJ4=;
        b=w1epACA2TSy/5uyxC3thqvN4BuZi2mEsQVStjOyWxRev3JwoHgm5HPbWlZOzxNLGr9
         Nwt6T4uTUVvh7rAjT69ft3Jg3zI1KXMqcmFK736/1LUro4xs0gFonO0FXXYRpiTtMbD+
         IKpVFgdiQfdQjw6vtnzFhRwMqTvgtJYWDZlPXq9uMlanFqoHK/IZ0cKDklJK0UbjQ0Uc
         Mac67p15kgiWeN7N43OpheUg+//DsO58ygwQQatkCKTn218ff2P0773A7OZYUQyk1Q+M
         TOBRSJEdBOt55666V0ZV5Obz9cRnfZA2Pd8V4+abKggh7KHiq0RYok05mmqXNqkHq6Zd
         kYtA==
X-Forwarded-Encrypted: i=1; AJvYcCXY4VB7giqGU3Hv3XYOIFf8hXyhLUzXXMuuX27+xdMM5/hFQ5SQHt5rmt1FAMrbsKy6XiQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yytcr6omr+p2/KYoIhcs4/Xf91skcigEVpArKN01hjyERw5xd2P
	9+GueWinF+ERldpR8smRPBo7PK4Zwjwx9voYDOjfJv2N0Hn92cy6iprzjxrb6tFkgiezzUb3y19
	0uxl1WlQVWFuXuiTJ6IoIXzVrMnyw32Xj+zF89WVe
X-Gm-Gg: ASbGnctvmDyhqtJlFBU9Pc8WPP+ujyFxSACuVqPjGGld/jOxhE+Os8aVyzBl2b07e0s
	5e1dqqVo8rV5xnjl3xWPvWqFESUhg7t7374fBKRLvV6CpotITkljLS7HglOmmNmad0+jnhms9kd
	v4uWGLVJdK3PzaBitLX5FUqgbyBCsEIw7lSZ2/BMboailt0wNPPcPbZgJ864A+0SzJOP9R5tCfi
	hVxWokKn5ZCkZZ7eFp/vUsqWK9dol2RPGJPx78JNKkwag6LPkhC+WtamkPWkWOslHZ+hYeF5dcC
	13I6k15I3SXmipSm7A==
X-Google-Smtp-Source: AGHT+IGkg40mPW3bovCZHX0roaA3kWbGoki1BIr82JU93FEnyQBIurMN/CgDlciqSLrXLxGUzokfypjDG670BnEk3sY=
X-Received: by 2002:a05:622a:1911:b0:4b7:9c77:6ba5 with SMTP id
 d75a77b69052e-4ed338fe804mr6958681cf.15.1761930573914; Fri, 31 Oct 2025
 10:09:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251030171238.1674493-1-rananta@google.com> <5e24cb1e-4ee8-166b-48c7-88fa6857c8dc@huawei.com>
In-Reply-To: <5e24cb1e-4ee8-166b-48c7-88fa6857c8dc@huawei.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Fri, 31 Oct 2025 10:09:22 -0700
X-Gm-Features: AWmQ_bl8RKNXMnZYsYniUFcgOw-utCMK_OFyrH-gMOtH0dhIyQfPT7TfvZpSNAw
Message-ID: <CAJHc60yak=kOQmap7Tmp=84cx7Z=h_15K_ZP9kdvxBc1h15rgg@mail.gmail.com>
Subject: Re: [PATCH] vfio: Fix ksize arg while copying user struct in vfio_df_ioctl_bind_iommufd()
To: liulongfang <liulongfang@huawei.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, David Matlack <dmatlack@google.com>, Josh Hilke <jrhilke@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, alex@shazbot.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2025 at 6:34=E2=80=AFPM liulongfang <liulongfang@huawei.com=
> wrote:
>
> On 2025/10/31 1:12, Raghavendra Rao Ananta wrote:
> > For the cases where user includes a non-zero value in 'token_uuid_ptr'
> > field of 'struct vfio_device_bind_iommufd', the copy_struct_from_user()
> > in vfio_df_ioctl_bind_iommufd() fails with -E2BIG. For the 'minsz' pass=
ed,
> > copy_struct_from_user() expects the newly introduced field to be zero-e=
d,
> > which would be incorrect in this case.
> >
> > Fix this by passing the actual size of the kernel struct. If working
> > with a newer userspace, copy_struct_from_user() would copy the
> > 'token_uuid_ptr' field, and if working with an old userspace, it would
> > zero out this field, thus still retaining backward compatibility.
> >
> > Fixes: 86624ba3b522 ("vfio/pci: Do vf_token checks for VFIO_DEVICE_BIND=
_IOMMUFD")
>
> Hi Ananta,
>
> This patch also has another bug: in the hisi_acc_vfio_pci.c driver, It ha=
ve two "struct vfio_device_ops"
> Only one of them, "hisi_acc_vfio_pci_ops" has match_token_uuid added,
> while the other one, "hisi_acc_vfio_pci_migrn_ops", is missing it.
> This will cause a QEMU crash (call trace) when QEMU tries to start the de=
vice.
>
> Could you please help include this fix in your patchset as well?
>
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -1637,6 +1637,7 @@ static const struct vfio_device_ops hisi_acc_vfio_p=
ci_migrn_ops =3D {
>         .mmap =3D hisi_acc_vfio_pci_mmap,
>         .request =3D vfio_pci_core_request,
>         .match =3D vfio_pci_core_match,
> +       .match_token_uuid =3D vfio_pci_core_match_token_uuid,
>         .bind_iommufd =3D vfio_iommufd_physical_bind,
>         .unbind_iommufd =3D vfio_iommufd_physical_unbind,
>         .attach_ioas =3D vfio_iommufd_physical_attach_ioas,
>
Sent as a separate patch in v2:
https://lore.kernel.org/all/20251031170603.2260022-3-rananta@google.com/
(untested).

Thank you.
Raghavendra

