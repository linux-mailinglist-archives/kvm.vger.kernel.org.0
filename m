Return-Path: <kvm+bounces-63762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F1A59C71BD9
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 02:57:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 1E4A029A17
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 01:57:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BB60268C42;
	Thu, 20 Nov 2025 01:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XXmDlSWq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hBGTOCf/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0251DE8AE
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 01:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763603847; cv=none; b=KFTE2v/mLuGwwf2Rylig2/GvtLSRgQkTrNsSMVsUm3wOS+hJUv+Pal7zPpCBGC6Cgts2Oz8COKJ5z6Nl4rFesffuRLS1LaJyHPq2ADm6MaAz1YzYbtHdDbGT3kq94yZDU3SJJ3nK/zBLhKYVc0tRhgTZjC/iZEOuy/Tkfh2oIrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763603847; c=relaxed/simple;
	bh=2WNbzwLyVV6yh0b9rLN6fCx7T6MdWJyCfYho6Zl5BSI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OUgWX2vid1qY3TG/MKWnT+AX2bnYIM1GJxvGGGu9dZ0o5/wW926bPgktV4XSg4FrOBxZzsgnGsBCX3tXuRPsbZ1y5vs2LMtBLZu8PjK4+KY32dlNypON8Ei6cuWt3dE7cu/BKtNoYznfk9+gKigb2KUtISfO5qFzclEX+52XW38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XXmDlSWq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hBGTOCf/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763603844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TgC+wxOBycuCmMOntc5tfhr1/4wD43qqUekchTy+Stc=;
	b=XXmDlSWqRuuCVNcY+JqjvEJtyQPWU79pZjoJIsJm7qybw8Y091Pu2Z0VM5RLow3lncMEzZ
	XS0lrRKHhiRCATOZAcETnFdTo2OBSfPH3dDjrZpkgSn+W/gJyDJXXv/7MPigvFfPJKBhB5
	H8cqgc4OKE6jm663+lyD+pjbBN1KKWA=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512--rFmiWyNPa27RzbJqe_RsQ-1; Wed, 19 Nov 2025 20:57:23 -0500
X-MC-Unique: -rFmiWyNPa27RzbJqe_RsQ-1
X-Mimecast-MFC-AGG-ID: -rFmiWyNPa27RzbJqe_RsQ_1763603842
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-343fb64cea6so910774a91.3
        for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 17:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763603842; x=1764208642; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TgC+wxOBycuCmMOntc5tfhr1/4wD43qqUekchTy+Stc=;
        b=hBGTOCf/UhoNA4rLMeV9+HtV1xW6CCUBqaSFLX6RxOHrgEn5sjvXkJn28+a3QztEfZ
         quy1BaHq061eEmRWhR/T1b3cDFobcR+f197NAUm69muH591kM6yP/HZDKGbWMZiXnI09
         /nb105iGYikVu4YSBIRAkqe8k4dcQ03rGJ9DsnoKQlVMI+HL/zAS6itx1BP2W0HS2S4N
         tOP5irGfE9duXF3iHtwR2QviZzuMXzm2NbR++x7wwcxLo+htY65+eXzBEbXTRCMznULu
         H+izYCMsiRnhDcgk8pjOkNO1EDwPYJemNqGors5WMclljkkP2A7UGkKccu4uaj31EDdx
         srcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763603842; x=1764208642;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TgC+wxOBycuCmMOntc5tfhr1/4wD43qqUekchTy+Stc=;
        b=tjOrxAw/QAt1/cwHi+lgQ7Yujux8QMYN5F4otyOEO84FdmniErj++DdXJTi4/T3ioF
         iuxzVapYfdjWQ1pSudsn1EuAbPJk6Ee95eKgSPPeCddgjk+0yG5j2++whjQZ0pZO9XNh
         i3u7z0Kfn13nVeX5yNeqRuaryPyQoU0G6Zv2z6P9l1ikfN3zIY/X3JnbpPbuAJPYMKk1
         AXIYl8uaz9ssERjfuRORLSlp6rXnFYiiJu/IK5Q68L0yyZtURiL9IBbVFLka+sM78MpR
         XwVYlnLnkBrhZRfjWHTCf9YIQZ9q6EIIMc27xYK+ukUBV+rkN4qTJ21KtvozrB6iWsLY
         YmYg==
X-Forwarded-Encrypted: i=1; AJvYcCVGjGQnKrKYO2GrqTWEIN3Vt9Ha1OULopfjQ7Hcd5Q/FePMDAwOtNYDN/WCloVmee45r3A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx17DeSmfTzrKB0Qn3IY8AJUJGBzwd84pDXhd0AoSd2xz9VhoKq
	rwykmZ1Hq2ZGXb6iB8AkZrJAmXVTzzXMKOjRKrsht0OU07vCam1rpRVcuRaKKBWalYIYudY57Oo
	XT4H/kndGXkJJx18HAo8J0RiILo1mTI2+vYlKccR+Xs+kTW8g1TyFJXUROs8YZE9UBgAMFwDbSJ
	JY822iI9NcoG2hFtHAoXMlsrYFvbxb
X-Gm-Gg: ASbGncvNfQrPG7PNCI/8RrUgqTVZLWHQt5AEBUWY65tGRfGuFFAQUxbqjwuQt6LKYyJ
	8iDGd72FL2W3ewXgIy0PWl+7Kel0HNWRpIzg1mMAMgCuOwcIvqIdKNspw+5pWiELXp/czv10P08
	lG7sZc5bHMMJHokG5xk18AXEcQ1G/b6g0F9srMRAdrrp3Nv9Jfy7fBkYVXx56+u4M=
X-Received: by 2002:a17:90a:c110:b0:340:f05a:3ebd with SMTP id 98e67ed59e1d1-34727c5a321mr1248030a91.28.1763603842264;
        Wed, 19 Nov 2025 17:57:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFiOBx5TtGT/ofIvTzG4rvjAW5DLBaw7wYScD05ecl8tqaojALyu5Wx2zCrUNx+TEAVc448NdvTDVTmBdWDDT0=
X-Received: by 2002:a17:90a:c110:b0:340:f05a:3ebd with SMTP id
 98e67ed59e1d1-34727c5a321mr1248009a91.28.1763603841887; Wed, 19 Nov 2025
 17:57:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113005529.2494066-1-jon@nutanix.com> <CACGkMEtQZ3M-sERT2P8WV=82BuXCbBHeJX+zgxx+9X7OUTqi4g@mail.gmail.com>
 <E1226897-C6D1-439C-AB3B-012F8C4A72DF@nutanix.com> <CACGkMEuPK4=Tf3x-k0ZHY1rqL=2rg60-qdON8UJmQZTqpUryTQ@mail.gmail.com>
 <A0AFD371-1FA3-48F7-A259-6503A6F052E5@nutanix.com>
In-Reply-To: <A0AFD371-1FA3-48F7-A259-6503A6F052E5@nutanix.com>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 20 Nov 2025 09:57:10 +0800
X-Gm-Features: AWmQ_bkp3-p1ykT07gW2-3QafOCuEJ3dN95qJ-5YwVEPAGAlLFk5vJNIKwB0qOY
Message-ID: <CACGkMEvD16y2rt+cXupZ-aEcPZ=nvU7+xYSYBkUj7tH=ER3f-A@mail.gmail.com>
Subject: Re: [PATCH net-next] vhost: use "checked" versions of get_user() and put_user()
To: Jon Kohler <jon@nutanix.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2025 at 1:35=E2=80=AFAM Jon Kohler <jon@nutanix.com> wrote:
>
>
>
> > On Nov 16, 2025, at 11:32=E2=80=AFPM, Jason Wang <jasowang@redhat.com> =
wrote:
> >
> > On Fri, Nov 14, 2025 at 10:53=E2=80=AFPM Jon Kohler <jon@nutanix.com> w=
rote:
> >>
> >>
> >>
> >>> On Nov 12, 2025, at 8:09=E2=80=AFPM, Jason Wang <jasowang@redhat.com>=
 wrote:
> >>>
> >>> !-------------------------------------------------------------------|
> >>> CAUTION: External Email
> >>>
> >>> |-------------------------------------------------------------------!
> >>>
> >>> On Thu, Nov 13, 2025 at 8:14=E2=80=AFAM Jon Kohler <jon@nutanix.com> =
wrote:
> >>>>
> >>>> vhost_get_user and vhost_put_user leverage __get_user and __put_user=
,
> >>>> respectively, which were both added in 2016 by commit 6b1e6cc7855b
> >>>> ("vhost: new device IOTLB API").
> >>>
> >>> It has been used even before this commit.
> >>
> >> Ah, thanks for the pointer. I=E2=80=99d have to go dig to find its gen=
esis, but
> >> its more to say, this existed prior to the LFENCE commit.
> >>
> >>>
> >>>> In a heavy UDP transmit workload on a
> >>>> vhost-net backed tap device, these functions showed up as ~11.6% of
> >>>> samples in a flamegraph of the underlying vhost worker thread.
> >>>>
> >>>> Quoting Linus from [1]:
> >>>>   Anyway, every single __get_user() call I looked at looked like
> >>>>   historical garbage. [...] End result: I get the feeling that we
> >>>>   should just do a global search-and-replace of the __get_user/
> >>>>   __put_user users, replace them with plain get_user/put_user instea=
d,
> >>>>   and then fix up any fallout (eg the coco code).
> >>>>
> >>>> Switch to plain get_user/put_user in vhost, which results in a sligh=
t
> >>>> throughput speedup. get_user now about ~8.4% of samples in flamegrap=
h.
> >>>>
> >>>> Basic iperf3 test on a Intel 5416S CPU with Ubuntu 25.10 guest:
> >>>> TX: taskset -c 2 iperf3 -c <rx_ip> -t 60 -p 5200 -b 0 -u -i 5
> >>>> RX: taskset -c 2 iperf3 -s -p 5200 -D
> >>>> Before: 6.08 Gbits/sec
> >>>> After:  6.32 Gbits/sec
> >>>
> >>> I wonder if we need to test on archs like ARM.
> >>
> >> Are you thinking from a performance perspective? Or a correctness one?
> >
> > Performance, I think the patch is correct.
> >
> > Thanks
> >
>
> Ok gotcha. If anyone has an ARM system stuffed in their
> front pocket and can give this a poke, I=E2=80=99d appreciate it, as
> I don=E2=80=99t have ready access to one personally.
>
> That said, I think this might end up in =E2=80=9Cwell, it is what it is=
=E2=80=9D
> territory as Linus was alluding to, i.e. if performance dips on
> ARM for vhost, then thats a compelling point to optimize whatever
> ends up being the culprit for get/put user?
>
> Said another way, would ARM perf testing (or any other arch) be a
> blocker to taking this change?

Not a must but at least we need to explain the implication for other
archs as the discussion you quoted are all for x86.

Thanks

>
> Thanks - Jon
>


