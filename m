Return-Path: <kvm+bounces-56173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCB69B3AAB4
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 21:18:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59BD53B8D28
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 19:18:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A55CB1A073F;
	Thu, 28 Aug 2025 19:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aam6nEE9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5714A2566
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 19:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756408682; cv=none; b=nDSWlHRkQMx+VWAU2ToimdNcOxa1nqptzNiamF/vuuVjTE2uIEDL/FUNrYYrgZUFQxW6YtJ8D9f7+NAGqg5Xi+BkhySCgYJ5pM1PhRVtZX9Sr8J5F6aE2WXoNLNPhh/89nuKUXkhBR43tn4HG7eRIP9muuK6vlp0BkzL2ckv98E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756408682; c=relaxed/simple;
	bh=R705VEBv41nDva1h893E5FrviUy3ssr090lY6E3dLkE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y9d6iPqi08OML6qF2uDzKxGa5KRU5DARtWLQo6JqvpTZK2gcOIA1duc8JvX96M2qK0wjAjPUzx4/yg/FLzfwAU3zshWkwuLERMmI7aOwMO0oebaEIEzPuuElOQOjf2Tc1FhJpTfI7lxMeJeAn5P9iaQXdNnsCgeki8cW82c2Ws4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aam6nEE9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756408680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ubm3+se5IJSP12F5GTCl+6z267rBFgrOWgFZkZu9Pzs=;
	b=aam6nEE9RNwUVtjIexshlMucqxUewV3BcAZDNN13qaV+qTeINKtuczpARtymmOYZQO7X4P
	M1UHppXlkgddwWYiG6iA0EkntAAWtpb7TeEU0uuAiGSpMt+rpk/H+qQGH6fsz4ZOgj47Ev
	AswAANPcTnuH6lu+8oT/i2Nyy0wHJgg=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-_kJzYT_APomIQA5EllhcbQ-1; Thu, 28 Aug 2025 15:17:58 -0400
X-MC-Unique: _kJzYT_APomIQA5EllhcbQ-1
X-Mimecast-MFC-AGG-ID: _kJzYT_APomIQA5EllhcbQ_1756408678
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-88432e707b0so12740139f.3
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 12:17:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756408678; x=1757013478;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ubm3+se5IJSP12F5GTCl+6z267rBFgrOWgFZkZu9Pzs=;
        b=aS4JmgtMmBo4xRjIG+Z7bByuxweLwM+IMCmFRF1Qkrzt4nJMOYEhgqOFS18t7ZZ2LN
         b2I9PSVZnmDaClqbcMSQAmWkIWCmYvd8/x1XLU3zaeMqHwy3jS5QkNSTbEnCqWsDpMKl
         wCY+vEv3wVnuHtP/xNzB+fBjIuY4WVyHLcv5PDADTF5Wb3J52uXriO3CKQUYeD6Sa7gE
         W8zGdKZ2eGF8vf6dsq66HcNEAjjBB8MN3ttHXcYCDHKx9S+RG31PjGsHJ/5kOOG0N3p8
         numl91k5XJfDPHoarFmf8RgCDXVxlIhodWdbIGT1NBOY7qODqBKhmWUi96V8biMGpUG7
         waxg==
X-Forwarded-Encrypted: i=1; AJvYcCWGuXjx+2b8zOBOYs+IHsrksHcOc/97XqzKliIE1lgAen/sYJBOGW7EO9uFApYHp/9t98o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2IHJ2nJKjG2ck+efF8MfuM8xWVTSQ5yylI6ZhxjdDHY4qOfTU
	oc0rd91enIKECr7qPOSk5sK+LM+J5KEYti4Ryjw/ysytaPjel3it6+q7RII44sN1nsHmD601Vvx
	2HelNsKArHUBC9InKw02l78B7lrUyORPycDm/9klZacmpBM0mIhrlXg==
X-Gm-Gg: ASbGncsTdhIGvtiYm0ZYMXA860z8sObbU0BeUvDq+4hjRXgeYo/mmGio2g/6mZUnRYo
	eoEnyeqIDXJc48Dl1lLGRVe94Eodjj5vOUPUiRxcCP7DMLGc5nlBK2SzLo1+V4lDelnFFq0obUc
	gss5/B4iEUHQreeqElSrpxUuynfGJ2c64duos98AeQK3aAXppf7+uIbIwezs5rozy2b3OPYr5+R
	VWdNocxqLFJngApEef9P/kwVnQJ0jAHFQV7sN89NyKdqwGbBQq+OWLpPYnbnRcvYtUBtwtfhzOG
	FA61gNvrAaDxTphs5+8Xo2aaHtrgNCPK1SS2OjIYYno=
X-Received: by 2002:a05:6e02:12ca:b0:3f1:931f:bc41 with SMTP id e9e14a558f8ab-3f1931fbdb7mr13967095ab.4.1756408678002;
        Thu, 28 Aug 2025 12:17:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGiXWbrJpO3qPTGp21RLRK1OogxDTndHy1kCD83SNnl8Qtoe312kQFOjPjF+taXZUUwLw/11w==
X-Received: by 2002:a05:6e02:12ca:b0:3f1:931f:bc41 with SMTP id e9e14a558f8ab-3f1931fbdb7mr13966915ab.4.1756408677514;
        Thu, 28 Aug 2025 12:17:57 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50d78ef4f91sm62913173.45.2025.08.28.12.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 12:17:56 -0700 (PDT)
Date: Thu, 28 Aug 2025 13:17:55 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Mahmoud Nagy Adam <mngyadam@amazon.de>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Benjamin Herrenschmidt
 <benh@kernel.crashing.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Kumar, Praveen" <pravkmr@amazon.de>, "Woodhouse, David"
 <dwmw@amazon.co.uk>, "nagy@khwaternagy.com" <nagy@khwaternagy.com>
Subject: Re: [RFC PATCH 0/9] vfio: Introduce mmap maple tree
Message-ID: <20250828131755.0b646987.alex.williamson@redhat.com>
In-Reply-To: <lrkyq8qj33jzv.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
References: <20250804104012.87915-1-mngyadam@amazon.de>
	<20250804124909.67462343.alex.williamson@redhat.com>
	<lrkyq5xf27ss7.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
	<20250805143134.GP26511@ziepe.ca>
	<lrkyqpld96a8a.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
	<20250805130046.0527d0c7.alex.williamson@redhat.com>
	<80dc87730f694b2d6e6aabbd29df49cf3c7c44fb.camel@amazon.com>
	<20250806115224.GB377696@ziepe.ca>
	<cec694f109f705ab9e20c2641c1558aa19bcb25b.camel@amazon.com>
	<20250807130605.644ac9f6.alex.williamson@redhat.com>
	<20250811155558.GF377696@ziepe.ca>
	<20250811160710.174ca708.alex.williamson@redhat.com>
	<lrkyq349uut66.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
	<20250814115247.4458764a.alex.williamson@redhat.com>
	<lrkyq8qj33jzv.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 28 Aug 2025 10:53:24 +0200
Mahmoud Nagy Adam <mngyadam@amazon.de> wrote:

> Hi all,
>=20
> Since it looks like creating alias regions is the path forward, I=E2=80=
=99d like
> to summarize the discussion to make sure we=E2=80=99re all aligned. From =
my
> understanding, the main steps are:
>=20
>     - Introduce helpers to create compact offsets, likely leveraging
>     mt. No changes to the vfio ops APIs are required, since the mt should
>     live within the vfio struct itself.

I think we also established, or at least there were arguments in the
direction, that the maple tree is just an implementation detail of the
address space management.  Obviously it contributes to compact and
efficient use of the address space, but for small numbers of alias
regions, we could continue to use the upper bits of the offset,
returning -ENOSPC if exceeded.  I don't want to discourage the maple
tree, but it seems like it could be split to a separate series to me.

With the maple tree, an opt-in to continue to use the existing offsets
for the pre-defined vfio-pci region indexes could prove to be a useful
feature as well as we potentially learn about userspace drivers that
don't follow the ABI.

>     - Add a WC flag to regions.

If we go the route of the DEVICE_FEATURE, we have the PROBE as an
option here.  This might make sense if we to avoid redefining flags for
specific attributes between REGION_INFO and the new DEVICE_FEATURE uAPI.

>     - Define a new UAPI for creating alias regions with new
>     offsets. This UAPI should support aliasing existing regions as well
>     as specifying additional flags such as WC.

I thought we'd discussed de-duplication, ie. if a user asks for an alias
with the same attributes as already defined, they get back the existing
region index/offset.  I don't see the utility in creating an arbitrary
number of aliases with the same attributes.  Thanks,

Alex

>     - Enable WC support for mmap.
>=20
> I plan to start working on an RFC covering these points over the next
> 1=E2=80=932 weeks.
>=20
> Thanks,
> MNAdam
>=20
>=20
>=20
> Amazon Web Services Development Center Germany GmbH
> Tamara-Danz-Str. 13
> 10243 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
> Sitz: Berlin
> Ust-ID: DE 365 538 597


