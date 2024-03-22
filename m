Return-Path: <kvm+bounces-12524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DAF88873B8
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 20:16:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC88E1F21CEE
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 19:16:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 274C778681;
	Fri, 22 Mar 2024 19:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Fbp40RoV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF4078673
	for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 19:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711135012; cv=none; b=PvBykORw3C6oVzmCwwwK9B2l6+M3tNvHdYmjPPqp9CxrbXMpyruT6dxKsVOAxCJAppzGdYooFjXJSzsn5RLUWsI9N+Lbi0k+Oc75szKsExhaoueClJAiTN7T3U4FjKQZTogrFLNyuxIuQiBal1A3LXASGQTPRM+z5NFWaOzHl6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711135012; c=relaxed/simple;
	bh=75iHcA9RFOUt3YMY5SehfwsBmnLNCyI0S4Wb9m834B8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tKzCi/NAv/LDXxaZkgG41HWNW9AUelJ6liA5fTwWvI77QaSyCjnRfhxyBzWUqh2WO5NO5G3yhkSHpgPwvqeA6cXiWwoQDAhworfYfyL7zP4IUePRsTVRe5YrWrZG4+FukD2USU0tRw9l0bmqV9Of8/uvts6CvBEKqLxMKRmzh5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Fbp40RoV; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5684db9147dso2944128a12.2
        for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 12:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1711135009; x=1711739809; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=75iHcA9RFOUt3YMY5SehfwsBmnLNCyI0S4Wb9m834B8=;
        b=Fbp40RoVAsq2zk1ka1gJaBVxa6uz99wpoMLenh/9yBLVvpceTB4KQRr06SkTJpUJGi
         24TQjFD2aHPnfYS7i8pZJT6nAQebyCJgkrlbzxuOpz+KCS479Y16t4nuQ2BC7onZOU8N
         qvKmaD5PZST5LydVDOLyyckCC2Jmf/vf25y6Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711135009; x=1711739809;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=75iHcA9RFOUt3YMY5SehfwsBmnLNCyI0S4Wb9m834B8=;
        b=Yz4q5vxQGB03Z9TQ1gbWvST7UMITcOk1uvAO/jqBy6NHqUZcPdT4qyg4hasayxRBWh
         t55MbWlhYWWurqd1VihrFWs6WWSCimFF+F7hDLRIoszxmdO7JrOkStK4YaOyrn5fLNSe
         nLt9hLdLyD10DQMcLltY0NsYcr4qIFwo3laFlw3mpihrqsLt1qfGmt/1ozEdohxLHo+w
         jpDnJluaoFTPbsNk4qjvZ3ZqhT4XmFyDaOBdNBDUiSK2DvhTFRPRpF5oXKQVJINYGIWT
         yYJ8hr6cbTeekmNqjDxzA32bYrHMIq2Uqz85DeUDuc0ywezb8zPlOWi53GuJWo2M8BpM
         In4w==
X-Forwarded-Encrypted: i=1; AJvYcCWas9AKK4UZel47BJg4QgZwv31RoHbwhjum2+bgFN33oesDAA5oXXPDNuL/SPNVRdsfbX2RsDtcv9Oa/w6gj2T/u4lc
X-Gm-Message-State: AOJu0YyW253oCvNncIFk78mVQbN7uGE9UL6QmoziLq89fIimCSa73DUK
	PT6uqutP9saOXF1tBW1Ldr78bzix2U0HihVixcj0dpK8l6PY0lBiNIuJ/45To4DTn4uAzizfMrt
	yKQ==
X-Google-Smtp-Source: AGHT+IHYwcZ2OcYoz1NdiQo2NYaEzatBorJ331JoUs/CHhQFace1Xj2Tf0wx+rxQK69/QaFPs/Vs+A==
X-Received: by 2002:a17:906:4a89:b0:a43:b269:d27f with SMTP id x9-20020a1709064a8900b00a43b269d27fmr440276eju.64.1711135008899;
        Fri, 22 Mar 2024 12:16:48 -0700 (PDT)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com. [209.85.128.49])
        by smtp.gmail.com with ESMTPSA id bo11-20020a170906d04b00b00a46d049ff63sm130807ejb.21.2024.03.22.12.16.48
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Mar 2024 12:16:48 -0700 (PDT)
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4146f2bf8ecso18515905e9.3
        for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 12:16:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWQy4+8N2YPUzfxfa0XcK2+3id2JUwSc3Nbz7PSUKSBVZmvJfuS/POHaJls/r/1Nyn2yiTMpgUleDT2o2vJKVPLywPc
X-Received: by 2002:a05:6512:32b2:b0:513:4b90:ae9a with SMTP id
 q18-20020a05651232b200b005134b90ae9amr255604lfe.67.1711134987739; Fri, 22 Mar
 2024 12:16:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240321101532.59272-1-xuanzhuo@linux.alibaba.com> <20240321101532.59272-2-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20240321101532.59272-2-xuanzhuo@linux.alibaba.com>
From: Daniel Verkamp <dverkamp@chromium.org>
Date: Fri, 22 Mar 2024 12:16:00 -0700
X-Gmail-Original-Message-ID: <CABVzXAkwcKMb7pC21aUDLEM=RoyOtGA2Vim+LF0oWQ7mjUx68g@mail.gmail.com>
Message-ID: <CABVzXAkwcKMb7pC21aUDLEM=RoyOtGA2Vim+LF0oWQ7mjUx68g@mail.gmail.com>
Subject: Re: [PATCH vhost v4 1/6] virtio_balloon: remove the dependence where
 names[] is null
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux.dev, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Hans de Goede <hdegoede@redhat.com>, =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Vadim Pasternak <vadimp@nvidia.com>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Cornelia Huck <cohuck@redhat.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	David Hildenbrand <david@redhat.com>, Jason Wang <jasowang@redhat.com>, linux-um@lists.infradead.org, 
	platform-driver-x86@vger.kernel.org, linux-remoteproc@vger.kernel.org, 
	linux-s390@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 21, 2024 at 3:16=E2=80=AFAM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> Currently, the init_vqs function within the virtio_balloon driver relies
> on the condition that certain names array entries are null in order to
> skip the initialization of some virtual queues (vqs). This behavior is
> unique to this part of the codebase. In an upcoming commit, we plan to
> eliminate this dependency by removing the function entirely. Therefore,
> with this change, we are ensuring that the virtio_balloon no longer
> depends on the aforementioned function.

This is a behavior change, and I believe means that the driver no
longer follows the spec [1].

For example, the spec says that virtqueue 4 is reporting_vq, and
reporting_vq only exists if VIRTIO_BALLOON_F_PAGE_REPORTING is set,
but there is no mention of its virtqueue number changing if other
features are not set. If a device/driver combination negotiates
VIRTIO_BALLOON_F_PAGE_REPORTING but not VIRTIO_BALLOON_F_STATS_VQ or
VIRTIO_BALLOON_F_FREE_PAGE_HINT, my reading of the specification is
that reporting_vq should still be vq number 4, and vq 2 and 3 should
be unused. This patch would make the reporting_vq use vq 2 instead in
this case.

If the new behavior is truly intended, then the spec does not match
reality, and it would need to be changed first (IMO); however,
changing the spec would mean that any devices implemented correctly
per the previous spec would now be wrong, so some kind of mechanism
for detecting the new behavior would be warranted, e.g. a new
non-device-specific virtio feature flag.

I have brought this up previously on the virtio-comment list [2], but
it did not receive any satisfying answers at that time.

Thanks,
-- Daniel

[1]: https://docs.oasis-open.org/virtio/virtio/v1.2/csd01/virtio-v1.2-csd01=
.html#x1-3140005
[2]: https://lists.oasis-open.org/archives/virtio-comment/202308/msg00280.h=
tml

