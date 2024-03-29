Return-Path: <kvm+bounces-13084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 38D918916F5
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 11:40:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A1DB21F24BD8
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 10:40:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF51369D3C;
	Fri, 29 Mar 2024 10:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d/KLHUG6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD17657C6
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 10:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711708812; cv=none; b=Y6rfTzgn3NsUB61CQ1AmTn63pzyA3uOSyYmyJt08uw3tzr+cmWfESd3QAYEulpogI1DFCLsafkkNi+NWIYKKSayTUho9gBWGoKVthOkz7ghiYV9hMI7o+A3A9xzAq871aQdNzrqfHiCojh+y12H/nbq99noefurbC8A0wqAUaK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711708812; c=relaxed/simple;
	bh=aWlw1knI6iA9pHb6F2hZMi+1qAncr3KP7cFanst0N6Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oLqQTRmqVQxpy/UphreYz88sS4k22GjCjuR5ddpwNr7uQYVIwEMEOY2hUWSTsF8v4JT9JKGbWSC3ZDAauCVCkPyO0+EB95FfH1pCIG0c5NFsA7FVZCsWO1valjC5S5DJwbkkcOmp7lP68Oq9/ILT6kxWTHq+Mow7ZS2kkL8DUpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d/KLHUG6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711708809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aWlw1knI6iA9pHb6F2hZMi+1qAncr3KP7cFanst0N6Q=;
	b=d/KLHUG6fcF8Ddff/B9+IdVCTMxBQ1YlIR8y8tpnJ43in2X6/0qzFW0i30oEVqHlIBJwlO
	DRhhoW+Qvc2yywA0x4jmAYsZbdwFMo0ggCJAb3PdOg4P7BGUAKgadujx2hyxNd6gxYd03r
	3qxebr8K6NpmuW26aHAt9I51wC9SuqE=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-NL-T364-MNmE6AOZxaseaQ-1; Fri, 29 Mar 2024 06:40:08 -0400
X-MC-Unique: NL-T364-MNmE6AOZxaseaQ-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-29df9eab3d4so1649286a91.0
        for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 03:40:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711708807; x=1712313607;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aWlw1knI6iA9pHb6F2hZMi+1qAncr3KP7cFanst0N6Q=;
        b=PmgSX268+FL9e4VFYBWvdmpi0Ozc/jEUToHH1pfngKK1/FxbOFZdY3EnOFfnH36hqd
         gKovwZg4+Aw+Uawyc0cojMuFzsLUOGg/NYlRAVhZbLZXrZcI3ltzNxeSAJitbty726y8
         UapJC+DkAXC/TNSHTqY39roF0BTP6dWRTsx71gVF7l9XCGkgz3dL7zrN40oCHgrl3wR8
         q289zBk/oclHgs9DrWrpoifp4sHejSBg/WcoBrbgXejKuZUSAVTJQ2hZIr4ZOtm1BCxB
         fSAc8b7XDC1YKBp8KpnXY/OGJXlGlMLn9vl+XssGEkhB67GINN64Io3mmICUmTPjpDxv
         2frQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtuYQYgfHxgSTWGZnfvkyjd8aSJoxu2/SKNN0GV4l8SZ6u/cezHrqI2v6zhslZD9s54q5HyzBAP6wTkEaptNxoJx2Z
X-Gm-Message-State: AOJu0YzAlpsA1F4/XrNWQ7wMeMRE7gj8vhyL4LmvdVxrIBeh8IEhzgyS
	XVpyFCU9geIsNdU7MetXxFPNK7wxw1UzSIIS9ghfO85Ay3q9fE9joXB7MGqnt2FcfKUkJZyWORa
	9HBpwJfHBvlvbvVWc/67qMTVXMYf/xlXfZ+MEe3e+R73lrgZ2JCAtdSvr2M7HFBjLN01pWHkxcy
	dzho+O/JeO37JL0+lPUIT9J+wY
X-Received: by 2002:a17:90b:8c6:b0:2a2:9f6:759e with SMTP id ds6-20020a17090b08c600b002a209f6759emr1875592pjb.20.1711708807052;
        Fri, 29 Mar 2024 03:40:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGb2wOAwuZXQWgzWL66EpG6vLDeyAJyD0oneTmmJW/T8q+bGhu652fGejrNwbcPHG3zyYzfHXasccYzy+nbzx0=
X-Received: by 2002:a17:90b:8c6:b0:2a2:9f6:759e with SMTP id
 ds6-20020a17090b08c600b002a209f6759emr1875582pjb.20.1711708806789; Fri, 29
 Mar 2024 03:40:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240320101912.28210-1-w_angrong@163.com> <20240321025920-mutt-send-email-mst@kernel.org>
 <CACGkMEuHRf0ZfBiAYxyNHB3pxuzz=QCWt5VyHPLz-+-+LM=+bg@mail.gmail.com>
 <CACGkMEuM9bdvgH7_v6F=HT-x10+0tCzG56iuU05guwqNN1+qKQ@mail.gmail.com> <20240329051334-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240329051334-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 29 Mar 2024 18:39:54 +0800
Message-ID: <CACGkMEvdw4Yf2B1QGed0W7wLhOHU9+Vo_Z3h=4Yr9ReBfvuh=g@mail.gmail.com>
Subject: Re: [PATCH v3] vhost/vdpa: Add MSI translation tables to iommu for
 software-managed MSI
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Wang Rong <w_angrong@163.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Cindy Lu <lulu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 29, 2024 at 5:13=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Fri, Mar 29, 2024 at 11:55:50AM +0800, Jason Wang wrote:
> > On Wed, Mar 27, 2024 at 5:08=E2=80=AFPM Jason Wang <jasowang@redhat.com=
> wrote:
> > >
> > > On Thu, Mar 21, 2024 at 3:00=E2=80=AFPM Michael S. Tsirkin <mst@redha=
t.com> wrote:
> > > >
> > > > On Wed, Mar 20, 2024 at 06:19:12PM +0800, Wang Rong wrote:
> > > > > From: Rong Wang <w_angrong@163.com>
> > > > >
> > > > > Once enable iommu domain for one device, the MSI
> > > > > translation tables have to be there for software-managed MSI.
> > > > > Otherwise, platform with software-managed MSI without an
> > > > > irq bypass function, can not get a correct memory write event
> > > > > from pcie, will not get irqs.
> > > > > The solution is to obtain the MSI phy base address from
> > > > > iommu reserved region, and set it to iommu MSI cookie,
> > > > > then translation tables will be created while request irq.
> > > > >
> > > > > Change log
> > > > > ----------
> > > > >
> > > > > v1->v2:
> > > > > - add resv iotlb to avoid overlap mapping.
> > > > > v2->v3:
> > > > > - there is no need to export the iommu symbol anymore.
> > > > >
> > > > > Signed-off-by: Rong Wang <w_angrong@163.com>
> > > >
> > > > There's in interest to keep extending vhost iotlb -
> > > > we should just switch over to iommufd which supports
> > > > this already.
> > >
> > > IOMMUFD is good but VFIO supports this before IOMMUFD. This patch
> > > makes vDPA run without a backporting of full IOMMUFD in the productio=
n
> > > environment. I think it's worth.
> > >
> > > If you worry about the extension, we can just use the vhost iotlb
> > > existing facility to do this.
> > >
> > > Thanks
> >
> > Btw, Wang Rong,
> >
> > It looks that Cindy does have the bandwidth in working for IOMMUFD supp=
ort.
>
> I think you mean she does not.

Yes, you are right.

Thanks

>
> > Do you have the will to do that?
> >
> > Thanks
>


