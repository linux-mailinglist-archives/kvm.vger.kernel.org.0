Return-Path: <kvm+bounces-52831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FFC0B09998
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 04:04:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1BF641C46955
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 02:05:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2578219F13F;
	Fri, 18 Jul 2025 02:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VA4hiFRh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D1735959
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 02:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752804284; cv=none; b=WP7wS6jq07gXx4FVOjaTuiBNl87GpuDfqOPKoGuyFF0TUt+hPwuBpRCXbTvUedykeg1d/o5cHUdulG5AosKw87jtJK51s/mVKkxYSNkUl5oNEbaZoQ/IiYRHZmJfIMvvGwrsYGt7QbQL1W8/Uy2MUJLWuIiszb7MeGd9L/7ugGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752804284; c=relaxed/simple;
	bh=F9KoY0fWAyT0ZBg+rowE+1s3YIsLeaL/832ZnoeP1Wc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dFtPDiw2JorhTYWgbrM6bUlkRIV7LPKKSHbbTpurU3CzzqqVFx74pl57a8Ry8e99AvRLi7iy2H7CrWmszBXtcwTARQYd0Zhz0/meoA/7m7Iy/JgxC8eN5aScSLujqwzxn0RljGQvWXnnfBbAusGtvN0uFMjVGcb9sv9j2IW6Jko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VA4hiFRh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752804281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F9KoY0fWAyT0ZBg+rowE+1s3YIsLeaL/832ZnoeP1Wc=;
	b=VA4hiFRhesqVmBUM+5sKPmL85Q7c1wpVu9NiPSxk5wDQ1LFBrgxZAyjaSnH7RGWgBu+V7L
	YeHN2cbSirZilNhrJMnMFh4f1s/ohWjdlxuUhAIg1x57lCFlwH2VjCCswYZGaSEmQgL5HZ
	SN8KM3ZYqtv9hdabCPKHbZVT3Oq+v2E=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-1fhrMwWyOmiXcxUz_KOQQQ-1; Thu, 17 Jul 2025 22:04:38 -0400
X-MC-Unique: 1fhrMwWyOmiXcxUz_KOQQQ-1
X-Mimecast-MFC-AGG-ID: 1fhrMwWyOmiXcxUz_KOQQQ_1752804278
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3139c0001b5so1408208a91.2
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 19:04:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752804277; x=1753409077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F9KoY0fWAyT0ZBg+rowE+1s3YIsLeaL/832ZnoeP1Wc=;
        b=JgDkpafsUi2gUmrQ40tMr825uS33QBzJ7XUaxwL9QxTXrwPx6iEumYSN4nQSuBK08E
         THK5fLC4MUlm4wpPKyRBNVnZUlVUmIJXy/F/IJGGBtaitfTkGFoGYdCgPornfp3It0WI
         1Zv8HEoLXa8+JebEobtujV+XFjmPPVdhEgJeabmbD/m/dH1w5Hxjs1FClqLd3UhPv7yW
         8t1OrtrF7R5UL94ChTHmTpwxShCI53ODET0dl5ai5r6ZMFPXlgV2eyKlRby4Xs19rQpk
         SwxnM2XjVtm8DuuNE0rptn9GqmcmoBMhUrKB9jQKy7fs5KMMAJdCLA7WhXen54fHRd+m
         Y0sw==
X-Forwarded-Encrypted: i=1; AJvYcCWIZH7U0HeCwdZ6JNBKTjyt8G7pWGgZEE52wMNlegItpGKrsYTt+Lg07QraTBMmGHB7sg4=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywbdi0SMhMmlcyZKmCNz5pk9nvOqlVVdDJAE2o8p1nQL3mzS8l4
	gpcd8bmjwZ7TIrQ5Btr8qnKUsLev41y4TgnaP7fcwx1c8aMRB8o4esZ84pb5rtzM/9xgDBA8jcy
	E8t7xB+Ed2y2lePLWW3c+8cRZhvFeDIELWG/Na3fNvurXRgrADBwr7lST1cREtfmOKEzFue/3RF
	2b+hD5t9KkiEufvTer+hvxQRErL6hZXD1ngrqKQt5+iA==
X-Gm-Gg: ASbGncsznP/y3T1+dMmf3fp57ECWrLSqVAfiS1HpyVd4o/tfzafeN30uTesbM1Z/jZ4
	KTwT0L1pGO2tQ/VfF1aThzIRbtNdP0VbPdebAUewHuyRE3b2+82gRfydfRk9ShJUSKNwAU7nWC8
	LgTKK3/dNfEbRLXQsQ77LT
X-Received: by 2002:a17:90b:1b05:b0:313:fa28:b223 with SMTP id 98e67ed59e1d1-31c9f3c3538mr10850943a91.3.1752804277412;
        Thu, 17 Jul 2025 19:04:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8KqrUIVNAEyJPRiT2OM9FATHXOwO2SqN0Txk9K1dB4PdC1uDpWK6ggmwhD+ohejDdUwFOfVzzFbUMJaFde+g=
X-Received: by 2002:a17:90b:1b05:b0:313:fa28:b223 with SMTP id
 98e67ed59e1d1-31c9f3c3538mr10850916a91.3.1752804276960; Thu, 17 Jul 2025
 19:04:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250714084755.11921-1-jasowang@redhat.com> <20250716170406.637e01f5@kernel.org>
 <CACGkMEvj0W98Jc=AB-g8G0J0u5pGAM4mBVCrp3uPLCkc6CK7Ng@mail.gmail.com>
 <20250717015341-mutt-send-email-mst@kernel.org> <CACGkMEvX==TSK=0gH5WaFecMY1E+o7mbQ6EqJF+iaBx6DyMiJg@mail.gmail.com>
 <bea4ea64-f7ec-4508-a75f-7b69d04f743a@redhat.com>
In-Reply-To: <bea4ea64-f7ec-4508-a75f-7b69d04f743a@redhat.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 18 Jul 2025 10:04:25 +0800
X-Gm-Features: Ac12FXy68XSJi1v7t16tcsLyYegSvV6N-LmJH3rh-wlnh3moxbcvqEtUDzYQPos
Message-ID: <CACGkMEv3gZLPgimK6=f0Zrt_SSux8ssA5-UeEv+DHPoeSrNBQQ@mail.gmail.com>
Subject: Re: [PATCH net-next V2 0/3] in order support for vhost-net
To: Paolo Abeni <pabeni@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jakub Kicinski <kuba@kernel.org>, eperezma@redhat.com, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, jonah.palmer@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2025 at 9:52=E2=80=AFPM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On 7/17/25 8:01 AM, Jason Wang wrote:
> > On Thu, Jul 17, 2025 at 1:55=E2=80=AFPM Michael S. Tsirkin <mst@redhat.=
com> wrote:
> >> On Thu, Jul 17, 2025 at 10:03:00AM +0800, Jason Wang wrote:
> >>> On Thu, Jul 17, 2025 at 8:04=E2=80=AFAM Jakub Kicinski <kuba@kernel.o=
rg> wrote:
> >>>>
> >>>> On Mon, 14 Jul 2025 16:47:52 +0800 Jason Wang wrote:
> >>>>> This series implements VIRTIO_F_IN_ORDER support for vhost-net. Thi=
s
> >>>>> feature is designed to improve the performance of the virtio ring b=
y
> >>>>> optimizing descriptor processing.
> >>>>>
> >>>>> Benchmarks show a notable improvement. Please see patch 3 for detai=
ls.
> >>>>
> >>>> You tagged these as net-next but just to be clear -- these don't app=
ly
> >>>> for us in the current form.
> >>>>
> >>>
> >>> Will rebase and send a new version.
> >>>
> >>> Thanks
> >>
> >> Indeed these look as if they are for my tree (so I put them in
> >> linux-next, without noticing the tag).
> >
> > I think that's also fine.
> >
> > Do you prefer all vhost/vhost-net patches to go via your tree in the fu=
ture?
> >
> > (Note that the reason for the conflict is because net-next gets UDP
> > GSO feature merged).
>
> FTR, I thought that such patches should have been pulled into the vhost
> tree, too. Did I miss something?

See: https://www.spinics.net/lists/netdev/msg1108896.html

>
> Thanks,
>
> Paolo
>

Thanks


