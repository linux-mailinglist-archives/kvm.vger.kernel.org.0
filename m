Return-Path: <kvm+bounces-29127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E2C439A33F9
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 06:55:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C1D11F24027
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 04:55:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D101F13AA3F;
	Fri, 18 Oct 2024 04:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DC6swlRM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6D720E318
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 04:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729227305; cv=none; b=YaVQo+hh4rkxP6UxGMUP+abTBGKUidKa3TUyzoxuGBdK7PxnWS6+JQ3puiy0aXYvEDyNg/VXPRa+NTZT99JWDDRYt0zibAQjb5ocTB8w1UFaYzlsaEYGLxqBkj2bzIusR48toaPtKUb9O8VqpwPw+3UiPtuG9Mv/vvQQvjMtMG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729227305; c=relaxed/simple;
	bh=JIqvG2jCtfUzqKikp6Uyzo7Po4a2fnUn52lM0O7ye2U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sqimCzuqOpIjRVJPadhnE9E01Xl9ezIP/mUccr6kamhu1HKW/E9TZAVFbu81vUEJHnupG968X0+m8jmVYJ5hyFymLipoOWUGihFHhvoR63vRIRdZ+wxqBGDCJspc5pN+X/TJSio9uaUkopB+gyByPvaipRr1Ltb8OET+XbJHbS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DC6swlRM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729227302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=szoLsmL231n26j+M8ujJ4xDFFgCiCGUDcshF849Y4SY=;
	b=DC6swlRM1c3FaT/B5LCaYT/wF05/zJx3YHXM1s1JFCr/tInoJ8dYBe/opM/5yhkxHMBMDo
	AR7F07QjTy+z7CqMCETZGHGbcM1DPWdeze56VgHEWUtRXOEc7gazKLdcogII/BZCklnwgQ
	PhcSawk/7k2RCZC2+e8HUrwIhrl+tPw=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-q9lgw0WiP_GLvbs8B9e6KA-1; Fri, 18 Oct 2024 00:55:00 -0400
X-MC-Unique: q9lgw0WiP_GLvbs8B9e6KA-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2e3984f50c3so1585683a91.1
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 21:55:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729227299; x=1729832099;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=szoLsmL231n26j+M8ujJ4xDFFgCiCGUDcshF849Y4SY=;
        b=uKdwsIVv5Xv3V68JyKIa3wiRFkbzgUsBwIzc66lSUTaswBgsd642zo0l4fPZLAifjA
         3hWY4sYe9cG97/9rmUj5FuH2MUwtRvav8KtuZu77YI29mskNJT6jJGqDY6ui0Bx/MUw6
         0ZKGcdCqwDtJyRGoctm/6b6jNKTE6aF4wsazemmEo0SQ8JD3ZuBAPWynI8R8gtpbJxUo
         CjsXx4COZQUgmq5pe2YvrkbGBDS0fSRL8DWQaFT9tcVaHBfKW/vbdujoKqFDbTM1yDpJ
         NRCDAd9AFhMTIdHlWIZnQ4xOhDV6Y43baJQ+uvGzwpeBN5aFNz5kWQ/5DXr0BScf54bf
         gWLA==
X-Forwarded-Encrypted: i=1; AJvYcCVwCyX3SdDrkPt30Q2OPW4F9mPg/T5XxWORw9M7nZfcGPACwhTvTikPSJtOJtY5HEr47mE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy63TjqCyAmL8Zm8DaveHKIkmFVondc9NrkIUtMfCPE8gUXUSF6
	2rs9YgHKyBnSSDLlZAb6+4aC+v5nSlI51q+XyxGFbjptdaNNWGZzU115a3Pp1dSfe2m9bQVu1Tx
	mvXtDPVvc/Cyri3bVIP+ni2BP4MnbjA4jHqpvZVAZV7UyhYnBHy+R/JdySIrT7ztqscMzknZxYk
	r15Ud5UkVX1PdDIvrObCMWpNwx
X-Received: by 2002:a17:902:ea08:b0:20c:aae9:7bf8 with SMTP id d9443c01a7336-20e5a79f484mr18664585ad.5.1729227299442;
        Thu, 17 Oct 2024 21:54:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFa2qtY5gLDoKqA6Yco3p4816y2zQXXPzBeUVcOWJS6Zu2NpeNQ0xtaSVTScNoct/TB2ZVWLO0OINwXOzis3OI=
X-Received: by 2002:a17:902:ea08:b0:20c:aae9:7bf8 with SMTP id
 d9443c01a7336-20e5a79f484mr18664325ad.5.1729227299043; Thu, 17 Oct 2024
 21:54:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240920140530.775307-1-schalla@marvell.com> <Zvu3HktM4imgHpUw@infradead.org>
 <DS0PR18MB5368BC2C0778D769C4CAC835A0442@DS0PR18MB5368.namprd18.prod.outlook.com>
 <Zw3mC3Ej7m0KyZVv@infradead.org> <DS0PR18MB5368CB509A66A6617E519672A0462@DS0PR18MB5368.namprd18.prod.outlook.com>
 <ZxCsaMSBpoozpEQH@infradead.org> <DS0PR18MB53686815E2F86EFC5DFE1E45A0472@DS0PR18MB5368.namprd18.prod.outlook.com>
In-Reply-To: <DS0PR18MB53686815E2F86EFC5DFE1E45A0472@DS0PR18MB5368.namprd18.prod.outlook.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 18 Oct 2024 12:54:48 +0800
Message-ID: <CACGkMEs81qAn4sOzNBiUUd=VgFuP5QvUtsfSjKVx3Uv2aHnK0Q@mail.gmail.com>
Subject: Re: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
 NO-IOMMU mode
To: Srujana Challa <schalla@marvell.com>
Cc: Christoph Hellwig <hch@infradead.org>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mst@redhat.com" <mst@redhat.com>, 
	"eperezma@redhat.com" <eperezma@redhat.com>, Nithin Kumar Dabilpuram <ndabilpuram@marvell.com>, 
	Jerin Jacob <jerinj@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 17, 2024 at 4:53=E2=80=AFPM Srujana Challa <schalla@marvell.com=
> wrote:
>
> > Subject: Re: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for =
NO-
> > IOMMU mode
> >
> > On Wed, Oct 16, 2024 at 05:28:27PM +0000, Srujana Challa wrote:
> > > When using the DPDK virtio user PMD, we=E2=80=99ve noticed a signific=
ant 70%
> > > performance improvement when IOMMU is disabled on specific low-end
> > > x86 machines. This performance improvement can be particularly
> > > advantageous for embedded platforms where applications operate in
> > > controlled environments. Therefore, we believe supporting the
> > > intel_iommu=3Doff mode is beneficial.
> >
> > While making the system completely unsafe to use.  Maybe you should fix
> > your stack to use the iommu more itelligently instead?
>
> We observed better performance with "intel_iommu=3Don" in high-end x86 ma=
chines,
> indicating that the performance limitations are specific to low-end x86 h=
ardware.

Do you have any analysis on why Intel IOMMU is slow on "low-end" x86
hardware? Anyhow, we can ask Intel IOMMU experts to help here.

Thanks

> This presents a trade-off between performance and security. Since intel_i=
ommu
> is enabled by default, users who prioritize security over performance do =
not need to
> disable this option.


