Return-Path: <kvm+bounces-27604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B241D987D99
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 06:31:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1B26AB2279B
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 04:31:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 086A1170A27;
	Fri, 27 Sep 2024 04:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eceOl/hf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2D4EEAA
	for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 04:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727411501; cv=none; b=I11wINsq1FRnRTJiKzXPTKkMhy6LTAndGnkvSkEDqUuQ+Qf2kwM4uUuylEkRIsAvlUVaIfNKplD0EbjZuoP9dmNnYeH91xHkmcYR+m2V1SrcwE7/vidBpxWkhzioyeyVS5jpScFqEEDpcTtaVl5ujb3x6WaKRYEavO0wERV3tRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727411501; c=relaxed/simple;
	bh=uBFmWoNeX1W+Cqs2iNWdisHneux0lZanwha6u5m3aww=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XM7ZTtJvZ+idnKWTUl087FRFDKQXL//moncS9NCXyb6IGYxV1HwEbPK6o8C9TdV9dz5Pr3LNvchYxCCJuR3Wo5ekBBih1elEtRCtCw7AVBVhfIUcrYebFVSVDYTGKtVMQWhdeXy+dzFJB/zx2MLKOAWK2vtgS+hmRmDS3u59Oyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eceOl/hf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727411498;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uBFmWoNeX1W+Cqs2iNWdisHneux0lZanwha6u5m3aww=;
	b=eceOl/hfxFC6N2gsnjPjFnA+kySEiWcXXuwUtWECgY6uTtyDMCuq1uwxjOky+Q+vAUEJZ4
	mzrcy7yB3wI2i/INsKMAHkpRvbCECDrVUU+ED0/9Ankc9FDub0Yoa4uGmtOiWCi4l5OiFd
	LZjFw0ciCaHkd/Xf3km30dmIpRGjhrQ=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-vw6a8x0KOjy4bpmeg3r8yw-1; Fri, 27 Sep 2024 00:31:36 -0400
X-MC-Unique: vw6a8x0KOjy4bpmeg3r8yw-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2e072f4300cso2304188a91.1
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 21:31:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727411495; x=1728016295;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uBFmWoNeX1W+Cqs2iNWdisHneux0lZanwha6u5m3aww=;
        b=XF9AorR50pogrpDpI7EMioUuUt8hY2KG8fPgXAFdDp0FfyHrD2t54Hetg2saoQCsI/
         fsgF403+erMaNefEUQx7o8qTEvW4y4HBHaNuTj85kBtD16keb5VXgRcxI7d11USzaT40
         HZhVbOCt0449Qs6CdpzeBGH3nTZtkW51FAAUAqg4WBS7spheOoPUudw5MnUiP/YOd90g
         sO2dks27jro2VkddkNpMKxylyJybQBh+RyHftJp+Tmq2L0XsTqiUcw+rpeSGMBbZEi9y
         jmNTLAvrwybB0rwfkEHShImgUUCqk9fr3nOfwwhb3xSxTmgXIgmFV4CcYdyDF/iVUaUz
         YClg==
X-Forwarded-Encrypted: i=1; AJvYcCVm/c2Yiwu6zpcN+YjsxWGPQsxrnTqoOFWg2Xv6e9WzQW0b+rVqSaYhkmkhOR3NIsTzujw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzc2Esa3K14j/No5lsyTpefZ4p17W9f8WFaCPcfojIUXlowHGyQ
	tv+ZEemRxHCog1chji8q+hrGMT8aoWoLQMlOMsRNIXpjA9s5YznsUKXhyrkR+7vy5LFJY0byV8r
	1VSKT1TH2YEt88f83lPX5tyccwSqYhaefdRaa9fnFSfSTl0n76q4IqXFSTxeYnROtZNbrNtbg7z
	RjLFSFQV8r/jBr+OvFmPjePoLS
X-Received: by 2002:a17:90b:234a:b0:2c2:df58:bb8c with SMTP id 98e67ed59e1d1-2e0b8b149dcmr2167125a91.18.1727411495495;
        Thu, 26 Sep 2024 21:31:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGIh5lwZF9CJKh17SEpxaaZJy38bFfod3VEXz7y4ASCqLDiCeaKdZmiGJ67AwnOYjAbQZ+yUYlkT0W4m1tjn8U=
X-Received: by 2002:a17:90b:234a:b0:2c2:df58:bb8c with SMTP id
 98e67ed59e1d1-2e0b8b149dcmr2167084a91.18.1727411494914; Thu, 26 Sep 2024
 21:31:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240924-rss-v4-0-84e932ec0e6c@daynix.com> <CACGkMEvMuBe5=wQxZMns4R-oJtVOWGhKM3sXy8U6wSQX7c=iWQ@mail.gmail.com>
 <c3bc8d58-1f0e-4633-bb01-d646fcd03f54@daynix.com>
In-Reply-To: <c3bc8d58-1f0e-4633-bb01-d646fcd03f54@daynix.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 27 Sep 2024 12:31:23 +0800
Message-ID: <CACGkMEu3u=_=PWW-=XavJRduiHJuZwv11OrMZbnBNVn1fptRUw@mail.gmail.com>
Subject: Re: [PATCH RFC v4 0/9] tun: Introduce virtio-net hashing feature
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
	Yuri Benditovich <yuri.benditovich@daynix.com>, Andrew Melnychenko <andrew@daynix.com>, 
	Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2024 at 10:11=E2=80=AFAM Akihiko Odaki <akihiko.odaki@dayni=
x.com> wrote:
>
> On 2024/09/25 12:30, Jason Wang wrote:
> > On Tue, Sep 24, 2024 at 5:01=E2=80=AFPM Akihiko Odaki <akihiko.odaki@da=
ynix.com> wrote:
> >>
> >> virtio-net have two usage of hashes: one is RSS and another is hash
> >> reporting. Conventionally the hash calculation was done by the VMM.
> >> However, computing the hash after the queue was chosen defeats the
> >> purpose of RSS.
> >>
> >> Another approach is to use eBPF steering program. This approach has
> >> another downside: it cannot report the calculated hash due to the
> >> restrictive nature of eBPF.
> >>
> >> Introduce the code to compute hashes to the kernel in order to overcom=
e
> >> thse challenges.
> >>
> >> An alternative solution is to extend the eBPF steering program so that=
 it
> >> will be able to report to the userspace, but it is based on context
> >> rewrites, which is in feature freeze. We can adopt kfuncs, but they wi=
ll
> >> not be UAPIs. We opt to ioctl to align with other relevant UAPIs (KVM
> >> and vhost_net).
> >>
> >
> > I wonder if we could clone the skb and reuse some to store the hash,
> > then the steering eBPF program can access these fields without
> > introducing full RSS in the kernel?
>
> I don't get how cloning the skb can solve the issue.
>
> We can certainly implement Toeplitz function in the kernel or even with
> tc-bpf to store a hash value that can be used for eBPF steering program
> and virtio hash reporting. However we don't have a means of storing a
> hash type, which is specific to virtio hash reporting and lacks a
> corresponding skb field.

I may miss something but looking at sk_filter_is_valid_access(). It
looks to me we can make use of skb->cb[0..4]?

Thanks

>
> Regards,
> Akihiko Odaki
>


