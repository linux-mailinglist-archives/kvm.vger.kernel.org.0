Return-Path: <kvm+bounces-7552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B10F1843ACC
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 10:17:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66F741F25331
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 09:17:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D41117AE54;
	Wed, 31 Jan 2024 09:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MhGM0+Rf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954FC69D19
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 09:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706692400; cv=none; b=SCIwLFdxirS7VDQlpU8DMC4RDXNj8spAXwogSjG4P9ZXJxzbSo9TfBgnVjnIZSvxgaWV70GHvsfkOcBHFarsgX0LqnwZtQKt9jtijsNdpKCnk+Z0wwMwW/STrzQYMWEWae0aYzfwxCdY4JX2RqwUZOBfMtuzcUkZ2lvYh1b6P38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706692400; c=relaxed/simple;
	bh=ONLOpdhFVTK1PKOUo0h7113+HYlDSSoXMBK7/7cDZ1Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h7v7uJ7xTOUbjJCj0tFBfTasMwBbl2ziB+RZ34pcaRu+w5XJYHlCmUXOH1pfGvTl97YIEnihB98OPNdHmvujPM+qn6+5UGobQhigJkJg6jQVUAnyGHuutudklm/XTPMChNsmFHAIlkTnHWwz5Oo/Ix8oZ24r2d7TGNmothTd5Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MhGM0+Rf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706692397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ONLOpdhFVTK1PKOUo0h7113+HYlDSSoXMBK7/7cDZ1Q=;
	b=MhGM0+RfbT5EBrWmE0hy7AOz2cCFwSsUhrkUAOe3NNRHRFUjeiBm9RbUQLDaWqxaFnbSTW
	g++aA3Y65jgz/cYW+IhN0gBJyYROG4Qj4o5trDyBGdNXrGN2R6Cxh95Y3CnQ/++g6HW7Ek
	Cx7HkqNxTA/+lqOoIFdJPFttTyQzJ1k=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-246-1KjMHZGhOqOQiCTHAS4oPg-1; Wed, 31 Jan 2024 04:13:16 -0500
X-MC-Unique: 1KjMHZGhOqOQiCTHAS4oPg-1
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-46b3b76a6c5so925604137.2
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 01:13:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706692396; x=1707297196;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ONLOpdhFVTK1PKOUo0h7113+HYlDSSoXMBK7/7cDZ1Q=;
        b=SeKXOCAD92UjgU5jscu16q1WrqJHsBtMpUhiJNR6MEjAgJs8gth5gNqWAwdPYB8iKp
         FWmsn5aaDWzUHxIA1BIYhiFhJ7w0nVaN+/2YNyQw1gI4jUju6QsT36QQ/nTAqmYXGz5F
         0rilkvcTGKM+hnHvDJ9Wmzb1b05qph3NU5cUuoX/Mf6oHhkhFVqOpHM5D1yDTqWDtyA3
         JfWlWzDOIg4qNnHJ795yjtWFFLrlfJPucRLZ4egk2G8aOEnsVhRXdKp6GDizW4Ku9Lrm
         VxiKIpB9lJJP45eGWFy6upm7AQ1kUn1MnW8Zsv7zz+TYaOgGp8WsqoKNertO6mroc8Ak
         Escw==
X-Gm-Message-State: AOJu0YwXhZ/yY9YkCRLC0IhOcx9mXFdC1YQX5BSFePrG2aOpv4KYWFU1
	WoPmUdO1ctLl3IF/7zPdoIddclQgxJ74FO/wPDmGpAheRfmyjO/x+mqYQJT2oy4QXRInTMFrWaq
	hlEvvE1SsKYGQsAlf5YNPZka4I2qBShAhgKMYrjnBouXi7BC6aMZ5VMbrvMar31pWyDswZIyUAJ
	c9pU1Z+RBQ3nYFPoy5bmYNOUrc
X-Received: by 2002:a05:6102:2753:b0:468:90e:2c88 with SMTP id p19-20020a056102275300b00468090e2c88mr691997vsu.35.1706692395781;
        Wed, 31 Jan 2024 01:13:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGlqIGzGC6WJa2cNQxkOvPsG3lWuLc6yY/NsL+Ul0eahHSt+TTWHH5K0CdWrrzXTYNRodEQ2LjsVmuQ6Q+WlRc=
X-Received: by 2002:a05:6102:2753:b0:468:90e:2c88 with SMTP id
 p19-20020a056102275300b00468090e2c88mr691962vsu.35.1706692395533; Wed, 31 Jan
 2024 01:13:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240130114224.86536-1-xuanzhuo@linux.alibaba.com> <20240130114224.86536-12-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20240130114224.86536-12-xuanzhuo@linux.alibaba.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 31 Jan 2024 17:12:43 +0800
Message-ID: <CACGkMEtWt1ROwJCeEa5FbQfxV2eqo0xRqHQZMsq-Q2TcQBur9g@mail.gmail.com>
Subject: Re: [PATCH vhost 11/17] virtio_ring: export premapped to driver by
 struct virtqueue
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux.dev, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	"Michael S. Tsirkin" <mst@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Hans de Goede <hdegoede@redhat.com>, 
	=?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Vadim Pasternak <vadimp@nvidia.com>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Cornelia Huck <cohuck@redhat.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, Benjamin Berg <benjamin.berg@intel.com>, 
	Yang Li <yang.lee@linux.alibaba.com>, linux-um@lists.infradead.org, 
	netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org, 
	linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org, 
	kvm@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 30, 2024 at 7:43=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> Export the premapped to drivers, then drivers can check
> the vq premapped mode after the find_vqs().

This looks odd, it's the charge of the driver to set premapped, so it
should know it?

Thanks


