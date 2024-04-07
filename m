Return-Path: <kvm+bounces-13830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7201089AECD
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 08:09:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E0200B22DE8
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 06:09:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB3BC6AB9;
	Sun,  7 Apr 2024 06:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="u83ZXHgo"
X-Original-To: kvm@vger.kernel.org
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D3E10A14;
	Sun,  7 Apr 2024 06:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712470180; cv=none; b=lwtSm4sabxyUtC6vW3SdjGmG+mQtXt/6msxBcSuYWQzDo7WapWwUblBMmliuQUMg/GXAbx5V9PPJPx0NPuS3b2eY5tuBRYpeXt7ORjvQ8DcHYkRzseCyoILDi31HAqsK5VaafAyFsvfe+HI33w5qbbGNyout+B7WiBTzkizYR1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712470180; c=relaxed/simple;
	bh=ofRHBQ9pjEzVTU+BhIfnFz15PkMBDFjuXoHrdk58MLg=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To:
	 Content-Type; b=HAXxFeqMY5yTSz8gIBPEfyGY2GxmSC+3Z4+GB+IfYBiXkLF6+wOLZMlOK4rTdWTbtJFoNLC751ROIyQVvPXYo4Qpj0WgacuedRw0ZixaG8fCxRaUnWQe4pSZxPUMEAoHsTm1caGQMevVCa9P3FTAAAYTHUid1Unw6xs2abnvEco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=u83ZXHgo; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1712470170; h=Message-ID:Subject:Date:From:To:Content-Type;
	bh=nv5U4hxWPS4bKJYdRAmApCzcDyYdxKTgR8eKush4hJU=;
	b=u83ZXHgoUCPBRvV27j5Z9AGqCPMmOPgBC57FMHbfW8cT0NcQd4Z24pM6DK4ziKP1xcrKTVNgwNdB3WSGxu9Nw/yULmZBTeOpRRgehiekGC6c9wFaj+xxV5BF2YcmRAuf/3I8r12ClsF4HX+Wrf6A3wMfgEAIdsAUUWd1rtEfrPY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0W4.JPHS_1712470168;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W4.JPHS_1712470168)
          by smtp.aliyun-inc.com;
          Sun, 07 Apr 2024 14:09:28 +0800
Message-ID: <1712470058.1558342-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v7 0/6] refactor the params of find_vqs()
Date: Sun, 7 Apr 2024 14:07:38 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: Eric Farman <farman@linux.ibm.com>
Cc: Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Hans de Goede <hdegoede@redhat.com>,
 =?utf-8?q?IlpoJ=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Vadim Pasternak <vadimp@nvidia.com>,
 Bjorn Andersson <andersson@kernel.org>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Cornelia Huck <cohuck@redhat.com>,
 Halil Pasic <pasic@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 David Hildenbrand <david@redhat.com>,
 Jason Wang <jasowang@redhat.com>,
 linux-um@lists.infradead.org,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org,
 virtualization@lists.linux.dev
References: <20240328080348.3620-1-xuanzhuo@linux.alibaba.com>
 <cbdce01bbf2843062f4afd7e5c9af767e69cc70b.camel@linux.ibm.com>
In-Reply-To: <cbdce01bbf2843062f4afd7e5c9af767e69cc70b.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Mon, 01 Apr 2024 15:57:53 -0400, Eric Farman <farman@linux.ibm.com> wrot=
e:
> On Thu, 2024-03-28 at 16:03 +0800, Xuan Zhuo wrote:
> > This pathset is splited from the
> >
> > =C2=A0=C2=A0=C2=A0=C2=A0
> > http://lore.kernel.org/all/20240229072044.77388-1-xuanzhuo@linux.alibab=
a.com
> >
> > That may needs some cycles to discuss. But that notifies too many
> > people.
>
> This will need to be rebased to 6.9; there were some conflicts when I
> tried to apply this locally which I didn't chase down, but it works
> fine on 6.8.

The target branch is Michael's vhost branch.

	https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=3Dlin=
ux-next

I will rebase that after Michael updates the branch.

Thanks.


>
> Thanks,
> Eric

