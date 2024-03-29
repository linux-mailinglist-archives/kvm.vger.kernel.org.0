Return-Path: <kvm+bounces-13051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 10287891234
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 04:56:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C32991F222BE
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 03:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1E733A1AC;
	Fri, 29 Mar 2024 03:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gyGiD1Wy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3D738F9B
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 03:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711684568; cv=none; b=V5irBWPFHJvbnYKjalJEaDR1lvC6UoY8XHn6+haqRiFbSX+EWffTEhHBAHrztagjt46Cs6PBPrRCc6XoeRNlJMfzAsvCkhfAFhpCyZ6U6+T88c1jU1m+NKTFVITAif7FWkP2xSapVi9dzRrQZPp+z5rSBm6vpNDbPBpfik9WAzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711684568; c=relaxed/simple;
	bh=LJdVzIjhdB6S/DcfelzDKPP9Yk+5ga0skvUpr5ygfQM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gbpbBVPcdX/xdC2bsZcGlm4ZuEnlCHKUfYlVaMhHpejtEE9Kc1XTfAe6XoKXV9ZXcLCq5P6ms8pYJw5RxkKEa5XBbZYLH8eTUPgb+djNJXtlxgexJXqiTQLexNTOZGjLY/Ctnzwtgayhq5djXp5/EAUTtmFoVtLKxeMc4tmyItQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gyGiD1Wy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711684566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LJdVzIjhdB6S/DcfelzDKPP9Yk+5ga0skvUpr5ygfQM=;
	b=gyGiD1Wyt+1Jhi83kuzdCNeLA3KxmqJ6x+wJBZW3eahEfRuahfIEzaDFnCPrGqTeCp71QT
	3VCLYRE5BmjaoJKw4pS0ME+helrX6ZlWXWrNCV5f8mjBN0eb7XcmbBzcOnOb3AefSR0We9
	O6fy+fdU3Tulx1KyCcX2S3WgouojH6M=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-Cj2_3_XtNmCaYEN96kKb8A-1; Thu, 28 Mar 2024 23:56:03 -0400
X-MC-Unique: Cj2_3_XtNmCaYEN96kKb8A-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2a039b47c5fso2080720a91.0
        for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 20:56:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711684563; x=1712289363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LJdVzIjhdB6S/DcfelzDKPP9Yk+5ga0skvUpr5ygfQM=;
        b=suMP3KNlXtKmLjP8UJCdMM6VoN2ehfLzzt6uFszm8aGY/5gcLdJa9YnYCzaJkwh/B2
         9vkHkMO6RXLZaYHPElL1tgA2+2KyPI1L82tVbcHWPL2MtGSy9lIBZoi6PbTkhK5NIiiS
         pi6eHTmCsP7nAQyDzzeBDnRgyB9Kag9K+51U38GWbfOHojG0vMyy9QVXpveaUXl+dhZj
         ceaptT+67QhcXmWZedPMjpVMWUks2MvM0Un6IzWIWNQ1ZV76HHqK7QMkEhCw+ISVyFFm
         WauNJcb5y1+3AnEAAuEzXTrhbF8qgxHd1zxzeJw3JNZUGKiFB/yJqK34gNUqTPxNhqLL
         a8kQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1piuifuyboQy6qWBKjYK4IfaWciOY5JFp41yQcT82L6OENgm6xJDVIWKmLvk9vHhBJBtGpKu4AkvNGDM95EHmiAqp
X-Gm-Message-State: AOJu0YyysBS0+aKgzBY4rVZOBb9Cla6p6H2O34s0kXpDy1T9DkMRXY36
	Ufp3pz4hJlthwTjVBnfnBe4YaQRLvzPgClU0B1Zk1nFuCl5P4edXUyCd3XujZE3o78lt++7jbOO
	lysAMLWh2RxtojaCmFxYm6/IqO4kKjmkkvO6r8tIZIqUvX2dV0BuvB7+6udztOW2IjktcBqjrpR
	MFfaN+WoYW2teH+1mvoNMh6+8g
X-Received: by 2002:a17:90a:d515:b0:2a0:8d17:948d with SMTP id t21-20020a17090ad51500b002a08d17948dmr1838129pju.1.1711684562667;
        Thu, 28 Mar 2024 20:56:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF5WpbyriUxjePwEjGO5X6q+YKYhB1eZJaJgrj4rVieoGSzVLIkn+ALnR8ZipwbzdgGvrRXqkbuUUu/vp0RL8A=
X-Received: by 2002:a17:90a:d515:b0:2a0:8d17:948d with SMTP id
 t21-20020a17090ad51500b002a08d17948dmr1838120pju.1.1711684562345; Thu, 28 Mar
 2024 20:56:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240320101912.28210-1-w_angrong@163.com> <20240321025920-mutt-send-email-mst@kernel.org>
 <CACGkMEuHRf0ZfBiAYxyNHB3pxuzz=QCWt5VyHPLz-+-+LM=+bg@mail.gmail.com>
In-Reply-To: <CACGkMEuHRf0ZfBiAYxyNHB3pxuzz=QCWt5VyHPLz-+-+LM=+bg@mail.gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 29 Mar 2024 11:55:50 +0800
Message-ID: <CACGkMEuM9bdvgH7_v6F=HT-x10+0tCzG56iuU05guwqNN1+qKQ@mail.gmail.com>
Subject: Re: [PATCH v3] vhost/vdpa: Add MSI translation tables to iommu for
 software-managed MSI
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Wang Rong <w_angrong@163.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Cindy Lu <lulu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 27, 2024 at 5:08=E2=80=AFPM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Thu, Mar 21, 2024 at 3:00=E2=80=AFPM Michael S. Tsirkin <mst@redhat.co=
m> wrote:
> >
> > On Wed, Mar 20, 2024 at 06:19:12PM +0800, Wang Rong wrote:
> > > From: Rong Wang <w_angrong@163.com>
> > >
> > > Once enable iommu domain for one device, the MSI
> > > translation tables have to be there for software-managed MSI.
> > > Otherwise, platform with software-managed MSI without an
> > > irq bypass function, can not get a correct memory write event
> > > from pcie, will not get irqs.
> > > The solution is to obtain the MSI phy base address from
> > > iommu reserved region, and set it to iommu MSI cookie,
> > > then translation tables will be created while request irq.
> > >
> > > Change log
> > > ----------
> > >
> > > v1->v2:
> > > - add resv iotlb to avoid overlap mapping.
> > > v2->v3:
> > > - there is no need to export the iommu symbol anymore.
> > >
> > > Signed-off-by: Rong Wang <w_angrong@163.com>
> >
> > There's in interest to keep extending vhost iotlb -
> > we should just switch over to iommufd which supports
> > this already.
>
> IOMMUFD is good but VFIO supports this before IOMMUFD. This patch
> makes vDPA run without a backporting of full IOMMUFD in the production
> environment. I think it's worth.
>
> If you worry about the extension, we can just use the vhost iotlb
> existing facility to do this.
>
> Thanks

Btw, Wang Rong,

It looks that Cindy does have the bandwidth in working for IOMMUFD support.

Do you have the will to do that?

Thanks


