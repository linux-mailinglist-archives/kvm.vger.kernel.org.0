Return-Path: <kvm+bounces-21253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B37E92C8E7
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 05:06:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A1D7F1F23D5A
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 03:06:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8CD234545;
	Wed, 10 Jul 2024 03:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UcLR93b1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A1A17BDA
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 03:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720580766; cv=none; b=A6saCAylUFbvVGivxFy115++WbGSRHnMq+DVcsADUlR/2C0EVROJwkDigbOrzpMlagbbBXSOAI7at2JI5SiXHHnx/4M9rt04Txx8bo4g1VoVP+m/QOX1t6aRaPhvvKYMAjVhcrWYIa57hRpDt5RK+sG0/mEXwYxJQUyRH9jdoZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720580766; c=relaxed/simple;
	bh=EYv+drGfxgAVKA3MvkSYy/jUZ5AZKM8QAx68YvyMpMY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cEdCm3GXDW72SLzUyWpiViTo2y+zguitrtw6CHmd9Oc3oUFDEc+ar9CYgGGYV9XeK9WFHAmi6lUh7cKtOA/ccS96MD/2PXT4VOmMuTgf6b+YhFlTaVmMgwCP9Wl4dnHNTU0OIwVoXhN0fb/sBDdselo/O+U7RMT5VS/log7n/54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UcLR93b1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720580764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EmCQNSPX5//DDrpA1NsAAhVFDFrTcMhRa+zaTiY1dwA=;
	b=UcLR93b1lpIhaUbA3rr8BppOTXD0j2sNLKDdoTZ7ecoKl8pboASIgNcIrqp0JpTWjdPCu2
	re/ckJpxRxD0HImGgcUx3INZKWVnpKGcGZn/WW9QYcZn7jyJUPjkGZGL7wpfuTSp+sJ3M2
	xJfiqDONAUIy5QkSTEVKFBCjpw4WGQU=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-RRGtbA2ZNdy1faD7NPPnGw-1; Tue, 09 Jul 2024 23:06:02 -0400
X-MC-Unique: RRGtbA2ZNdy1faD7NPPnGw-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-255112df14aso3813865fac.1
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 20:06:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720580762; x=1721185562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EmCQNSPX5//DDrpA1NsAAhVFDFrTcMhRa+zaTiY1dwA=;
        b=iNFkLqUGgfWa2Zlbx8BV+7l1EP5mSz2ei6wVS1a3/W4xWqBMBeKCD9MmU6oGejAYf+
         hrB04oprmHU30rZihOlENwhBme170DDqGpITfaX2PArfqQrnzvN0cOzlJSY8ThLCCzfN
         VkGQMempcaFncQ56OiqErhbS4mCUOKYO7C5rZk0i2rlEDNmKYFEtmetBnVnSxNuqQlJh
         1WJYOAJ0E1cWSUd6RAta8g2o/H9B7LZVtQdXnH35H6DVPpcyMgpM5wf1JkaBKL/lLCg1
         4jEcKjue4Bi2lFY4Teal1TXC8FzKSZw56d7TjiciTRIHWrYiH7Ey628IurQiYwph+tal
         babg==
X-Forwarded-Encrypted: i=1; AJvYcCWE3t/5UEBXU7/yuhT55Jd4FESonAfplJbOpFfr3HEB6FPi99pMnoMEbsfTG1lgiwhqhIAbQt9EDAysQICfOuxe+VuL
X-Gm-Message-State: AOJu0YyJZ7msldB09cAuXc4OpCoLGqD7DA+hRbCt/B+rzQhoBe+Brepn
	oETJ8Z5vw7H/zxgQp1Tx5ligNjdMw1RTP5BVcDltkwV6pG4rq+sgYyrkc3bljct/0M2m6Wg34++
	fWU65L9iPQIM4sMpinyljyxvmHVBeTugFaxjR6E4DOnAYcbRA2lZe3/are7Bn4Ysnc+vXHPrtpr
	OpYVzhChyk3oy3jyvFEVl5pdnT
X-Received: by 2002:a05:6870:470a:b0:254:7a82:cb28 with SMTP id 586e51a60fabf-25eae9bc1a9mr3539204fac.35.1720580761737;
        Tue, 09 Jul 2024 20:06:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHGkCsClUv5KuWRwpjkBgC/upvmj64D87aIsN1C0U4KlwhgMoVY/k1ysamyySaRMmvPvzejsu/eF6WXuQBTCRM=
X-Received: by 2002:a05:6870:470a:b0:254:7a82:cb28 with SMTP id
 586e51a60fabf-25eae9bc1a9mr3539189fac.35.1720580761338; Tue, 09 Jul 2024
 20:06:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240708064820.88955-1-lulu@redhat.com> <PH0PR12MB5481AE2FD52AEE1C10411F3DDCDB2@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACLfguXk4qiw4efRGK4Gw8OZQ_PKw6j+GVQJCVtbyJ+hxOoE0Q@mail.gmail.com> <20240709084109-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240709084109-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 10 Jul 2024 11:05:48 +0800
Message-ID: <CACGkMEtdFgbgrjNDoYfW1B+4BwG8=i9CP5ePiULm2n3837n29w@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] vdpa: support set mac address from vdpa tool
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Cindy Lu <lulu@redhat.com>, Parav Pandit <parav@nvidia.com>, 
	Dragos Tatulea <dtatulea@nvidia.com>, "sgarzare@redhat.com" <sgarzare@redhat.com>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Leonardo Milleri <lmilleri@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 9, 2024 at 8:42=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com> =
wrote:
>
> On Tue, Jul 09, 2024 at 02:19:19PM +0800, Cindy Lu wrote:
> > On Tue, 9 Jul 2024 at 11:59, Parav Pandit <parav@nvidia.com> wrote:
> > >
> > > Hi Cindy,
> > >
> > > > From: Cindy Lu <lulu@redhat.com>
> > > > Sent: Monday, July 8, 2024 12:17 PM
> > > >
> > > > Add support for setting the MAC address using the VDPA tool.
> > > > This feature will allow setting the MAC address using the VDPA tool=
.
> > > > For example, in vdpa_sim_net, the implementation sets the MAC addre=
ss to
> > > > the config space. However, for other drivers, they can implement th=
eir own
> > > > function, not limited to the config space.
> > > >
> > > > Changelog v2
> > > >  - Changed the function name to prevent misunderstanding
> > > >  - Added check for blk device
> > > >  - Addressed the comments
> > > > Changelog v3
> > > >  - Split the function of the net device from vdpa_nl_cmd_dev_attr_s=
et_doit
> > > >  - Add a lock for the network device's dev_set_attr operation
> > > >  - Address the comments
> > > >
> > > > Cindy Lu (2):
> > > >   vdpa: support set mac address from vdpa tool
> > > >   vdpa_sim_net: Add the support of set mac address
> > > >
> > > >  drivers/vdpa/vdpa.c                  | 81 ++++++++++++++++++++++++=
++++
> > > >  drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 19 ++++++-
> > > >  include/linux/vdpa.h                 |  9 ++++
> > > >  include/uapi/linux/vdpa.h            |  1 +
> > > >  4 files changed, 109 insertions(+), 1 deletion(-)
> > > >
> > > > --
> > > > 2.45.0
> > >
> > > Mlx5 device already allows setting the mac and mtu during the vdpa de=
vice creation time.
> > > Once the vdpa device is created, it binds to vdpa bus and other drive=
r vhost_vdpa etc bind to it.
> > > So there was no good reason in the past to support explicit config af=
ter device add complicate the flow for synchronizing this.
> > >
> > > The user who wants a device with new attributes, as well destroy and =
recreate the vdpa device with new desired attributes.
> > >
> > > vdpa_sim_net can also be extended for similar way when adding the vdp=
a device.
> > >
> > > Have you considered using the existing tool and kernel in place since=
 2021?
> > > Such as commit d8ca2fa5be1.
> > >
> > > An example of it is,
> > > $ vdpa dev add name bar mgmtdev vdpasim_net mac 00:11:22:33:44:55 mtu=
 9000
> > >
> > Hi Parav
> > Really thanks for your comments. The reason for adding this function
> > is to support Kubevirt.
> > the problem we meet is that kubevirt chooses one random vdpa device
> > from the pool and we don't know which one it going to pick. That means
> > we can't get to know the Mac address before it is created. So we plan
> > to have this function to change the mac address after it is created
> > Thanks
> > cindy
>
> Well you will need to change kubevirt to teach it to set
> mac address, right?

That's the plan. Adding Leonardo.

Thanks

>
> --
> MST
>


