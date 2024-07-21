Return-Path: <kvm+bounces-22028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BC95D93869E
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 01:01:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 646E41F21388
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2024 23:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B272168C4;
	Sun, 21 Jul 2024 23:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EfJEUXyX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6983F9463;
	Sun, 21 Jul 2024 23:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721602884; cv=none; b=ipemP2xvcvJT9kbxv2EMjI2AXctzUTr7Mz+cLBtmIZSHk22Z+v0wcUXpyswPuyEw2bwnl04Z7g5qkaHnetjWRHMc6Ftq4vZY7+SAIOtkihlFdF/wfmsZpjZlBPgRU1LJyKK/u5PwjTPtb+Yn8ppPMvsE8fOv9vm4+r3zS1cVLlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721602884; c=relaxed/simple;
	bh=qHiXy97WqrqdWDaxvMhPKIxEqFyPM5RjKT0hDBluGeo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ByMMf85nd6igTw0rVtpq3zzBA+frTaNgSmD9SJo5dbXbcZHj+8Lp4oqg70tswG07HM0SPrM6X8QhHj4QlD65odcrkd+JO4QDEuGD2wWMazhImigT43r1jiusqDkNtJhKR0eY6bXCXiHfLibk3ePVzdL0jfUXjgnH0B81yQgvMJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EfJEUXyX; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-260e5b2dfb5so2157138fac.3;
        Sun, 21 Jul 2024 16:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721602882; x=1722207682; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PIk+tn4TdOmmwm70v6l/KFa/IUuNmPetDUKr3HxFV9c=;
        b=EfJEUXyXRQ6EGmSY2NTX8C74Qcjs7TwYS3Zhs4GnYUGF2BdU7+iRwgi1RgRRQqk6Hz
         r+80sqYdaE4Nw1xbjhlCadKpFnOXsw30xwwC0xIFJZ/Udsm13VtzO3i8LiLq5eA1sLzO
         61RIRoQFAmYUT6jRLdRpK2ekuIk6Tg8ya4H/i2SJdu5FrCBMt77YxAAzMhYql6AWdczb
         UcAoXMdFp/klyCMxMbIzoCpk5RQCEaB8pRO567PkHJHGec++4pXSd+Mw76KhjeJRkcAd
         QAYgk3LUxRZAzGuJc8Rz60OrDsE2YgIC/Dau52wovX0w7Bnobu41yX7oz/fJl1G/gNpW
         Kneg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721602882; x=1722207682;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PIk+tn4TdOmmwm70v6l/KFa/IUuNmPetDUKr3HxFV9c=;
        b=fIgjOaGEEnz1AUDVi7mSBxGZR4gitjKMt+80pE9fqzI3C4T0+dsmDxEVM41LEest5E
         1z2I1YlYmPUIurJUS09MEfdfpIDnPi1XQJAVy1darnsRjAgNw08itZPwMRD4iFRnxnz/
         RWy3iDG/tt8r4zGCswSYZ8HxBklSN0eGzknimOYdBL7ZjY5h/UVGkOCbOPADN6lxUzcv
         KlhBZR4qzeRpFYEtG14jbZ87ughUCOuc7HX+BYneGCbDb1Wv11ktwEZFA8P7aT54A5V8
         XahkjlByj/qXqE3LVoZ7Mtc/t1qWmcAv1oq3Z10f1G01lSR2pwleR5uKpiZPB+m038XN
         fkcg==
X-Forwarded-Encrypted: i=1; AJvYcCX3dZVAwh59wNSgXkwERLUeHYTzs6LdYua3faZtlRKuRe7v9gbjl3+fVA29aat48Ah0I/IPcZ+kG40Lreu7CPqedV474UYSmv8hHRxkUC+GAbnMHg6x52AdfIxVPGOlJarnVRCqhxYCCsoa/3b+xnhv80zRa6v5t1FKR0gW
X-Gm-Message-State: AOJu0YxVMjfHVBKyo4t2hjVwUJ5AfabF7M8sn+BgRGtxCJ50UQnEAfRz
	iqWnI3hdv3PdcstWEnaC/By3QV+fvv5Gih/oOUBVknMmCs1now/P
X-Google-Smtp-Source: AGHT+IGwNeV9M4R4X6CjHDisDYMRllDiei577vEHLgFOqRN1d1Ou2AFcOHtsoQsriEmw3ad0i5Bs+Q==
X-Received: by 2002:a05:6871:e419:b0:261:236c:2bb8 with SMTP id 586e51a60fabf-2638de9db8fmr5167480fac.12.1721602882260;
        Sun, 21 Jul 2024 16:01:22 -0700 (PDT)
Received: from ?IPv6:2605:59c8:829:4c00:82ee:73ff:fe41:9a02? ([2605:59c8:829:4c00:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-70cff4b5cd7sm4270341b3a.69.2024.07.21.16.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jul 2024 16:01:21 -0700 (PDT)
Message-ID: <8ea3f19a274c58cb7cf2ffa98fb41ee530f5a614.camel@gmail.com>
Subject: Re: [RFC v11 05/14] mm: page_frag: avoid caller accessing
 'page_frag_cache' directly
From: Alexander H Duyck <alexander.duyck@gmail.com>
To: Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
 kuba@kernel.org,  pabeni@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael S.
 Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Eugenio
 =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>, Andrew Morton
 <akpm@linux-foundation.org>, Eric Dumazet <edumazet@google.com>, David
 Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
 Neil Brown <neilb@suse.de>, Olga Kornievskaia <kolga@netapp.com>, Dai Ngo
 <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,  Trond Myklebust
 <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 kvm@vger.kernel.org,  virtualization@lists.linux.dev, linux-mm@kvack.org, 
 linux-afs@lists.infradead.org, linux-nfs@vger.kernel.org
Date: Sun, 21 Jul 2024 16:01:19 -0700
In-Reply-To: <20240719093338.55117-6-linyunsheng@huawei.com>
References: <20240719093338.55117-1-linyunsheng@huawei.com>
	 <20240719093338.55117-6-linyunsheng@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2024-07-19 at 17:33 +0800, Yunsheng Lin wrote:
> Use appropriate frag_page API instead of caller accessing
> 'page_frag_cache' directly.
>=20
> CC: Alexander Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  drivers/vhost/net.c             |  2 +-
>  include/linux/page_frag_cache.h | 10 ++++++++++
>  mm/page_frag_test.c             |  2 +-
>  net/core/skbuff.c               |  6 +++---
>  net/rxrpc/conn_object.c         |  4 +---
>  net/rxrpc/local_object.c        |  4 +---
>  net/sunrpc/svcsock.c            |  6 ++----
>  7 files changed, 19 insertions(+), 15 deletions(-)
>=20

Looks fine to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>


