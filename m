Return-Path: <kvm+bounces-12658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 851FF88BB15
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 08:19:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5CAC1C2B0AB
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 07:19:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90B701327F7;
	Tue, 26 Mar 2024 07:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="gkyybzVd"
X-Original-To: kvm@vger.kernel.org
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B37130491;
	Tue, 26 Mar 2024 07:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711437527; cv=none; b=NT9ne3Fzlsy4IF2aAbnL7jIc649YJTtoYGW2+bDcqL0OoypgvWbzgzql99Qrh3m16yXv26SrH+2Iuxt7fncy7UaMd7ITHKCq1mVXBeXm2Rid+hPwmL3BHuSCaxNpezJ7DlRe35OiIa65Woxmsx/3crK4PAr+zEi2FgYPU0hG5VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711437527; c=relaxed/simple;
	bh=lvPHXAmlthw4ylJLu+8Br+cOBpAUBI32m3n1uEjmn1s=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To:
	 Content-Type; b=jlMwPHjS0ZdhVg77Y0IM5sU4wwt3Hpo/SRG+tc6tZasq2aDsS4DJNZRkfCcLA8OcZMGFGU8frxS5I8p+ehAEXvvDtANAFl0qe7r2h+78slyHi2Lzxuglpne9m4tWrLk6rcliWIWwFmW2Ux0RoJSBZMBw2OOqxf+NgEPMXYKku5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=gkyybzVd; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711437522; h=Message-ID:Subject:Date:From:To:Content-Type;
	bh=lvPHXAmlthw4ylJLu+8Br+cOBpAUBI32m3n1uEjmn1s=;
	b=gkyybzVd12Wj0lP8fyoAI4me0aDKKN/4vrK6NKmkacdb8k4Mb9qXN9zz9SYySq8I/OqCR72DE32eHwwMkMWpA5FpMIrKy6vjYCB+iOUgdzS4sqMOy+4PGxyn1R9ilsEpvtUnmRjmbfEEJiMTOShFar72DpQqxYWl7boBdpvh8DI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R501e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0W3K6Xbp_1711437519;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W3K6Xbp_1711437519)
          by smtp.aliyun-inc.com;
          Tue, 26 Mar 2024 15:18:40 +0800
Message-ID: <1711437497.65582-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v5 1/6] virtio_balloon: remove the dependence where names[] is null
Date: Tue, 26 Mar 2024 15:18:17 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.linux.dev,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Hans de Goede <hdegoede@redhat.com>,
 =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Vadim Pasternak <vadimp@nvidia.com>,
 Bjorn Andersson <andersson@kernel.org>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Cornelia Huck <cohuck@redhat.com>,
 Halil Pasic <pasic@linux.ibm.com>,
 Eric Farman <farman@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 David Hildenbrand <david@redhat.com>,
 linux-um@lists.infradead.org,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org
References: <20240325090419.33677-1-xuanzhuo@linux.alibaba.com>
 <20240325090419.33677-2-xuanzhuo@linux.alibaba.com>
 <CACGkMEtBw86fXjFrk6Rt4ytOYOn2q7r5a4WuvsgqPGT8O7tr0g@mail.gmail.com>
In-Reply-To: <CACGkMEtBw86fXjFrk6Rt4ytOYOn2q7r5a4WuvsgqPGT8O7tr0g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Tue, 26 Mar 2024 12:14:17 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Mon, Mar 25, 2024 at 5:04=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba=
.com> wrote:
> >
> > Currently, the init_vqs function within the virtio_balloon driver relies
> > on the condition that certain names array entries are null in order to
> > skip the initialization of some virtual queues (vqs).
>
> If there's a respin I would add something like:
>
> 1) the virtqueue index is contiguous for all the existing devices.
> 2) the current behaviour of virtio-balloon device is different from
> what is described in the spec 1.0-1.2
> 3) there's no functional changes and explain why
>
> > This behavior is
> > unique to this part of the codebase. In an upcoming commit, we plan to
> > eliminate this dependency by removing the function entirely. Therefore,
> > with this change, we are ensuring that the virtio_balloon no longer
> > depends on the aforementioned function.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>
> With the above tweak.


OK. I will add these in next version.

Thanks.


>
> Acked-by: Jason Wang <jasowang@redhat.com>
>
> Thanks
>

