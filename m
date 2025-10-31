Return-Path: <kvm+bounces-61690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EEBBC25914
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 15:28:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 114264616A0
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 14:24:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5256345CD4;
	Fri, 31 Oct 2025 14:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YAHqVDl+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFEE264FB5
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 14:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761920635; cv=none; b=mJIiVxcgOaFRnxTET8c7JjuZiG7CBkCrVGOmer+9TF+5s5rliWPUX2h03MHD7Sqth4rLJklLOowzmTH3U5x875jGDcCU7Xb6kEssbcT2APBhOmtqDr/Yysj3wEKGWW9TBO1yCc0ciUeBVfOJ6wSl7xbJPd+LsZ3fQ76pndcTfZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761920635; c=relaxed/simple;
	bh=9n5vVdklEJTZdnM2Nr3Xl3wd/OjExaSJYdKGhYgHf/c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D+2M4r7ZzXYC78xUN4oP3ACCwICHNp5nmCsUux4ZojDg6iy8jKEKOrksuy9nDYAw3S1mRu8HotsrSYP/5zIgOmry4XNqjRaslDCiJsHza0A3UsgQuEBIumBfaVWtxW5XiYIUdxcj5LeYVgNPyUdD2iHdM8GwKVG8CwjrDtSvdWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YAHqVDl+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761920632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z8NsndKxi9wjfiwiNCzQ0sDwvjij+/0YwRPZVMGXiAQ=;
	b=YAHqVDl+iZSv7GYhnlzNRSP0/byHBvTEPYtuhgCn4DKAtJxAWYYku9gO0uAPl20N1chnJl
	q/ftF13jk2e6L2QfbFqW2dQ4QdzmsQoLSoYbSdx6ctHBOwISewpr9v1QEP7CmY2auZAiWN
	qjVDqd2L5kV/MU8pNRIU8zOGiRfKWqo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-i6qPS5--NJaBOTonRmX74g-1; Fri, 31 Oct 2025 10:23:51 -0400
X-MC-Unique: i6qPS5--NJaBOTonRmX74g-1
X-Mimecast-MFC-AGG-ID: i6qPS5--NJaBOTonRmX74g_1761920630
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-470fd92ad57so25559275e9.3
        for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 07:23:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761920630; x=1762525430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z8NsndKxi9wjfiwiNCzQ0sDwvjij+/0YwRPZVMGXiAQ=;
        b=Cvgf4SBCyL1G6Xdkn5gTPcd4RY72S0gmXz1ckbu64lz/ggHpNPLtnNUbkGXBGOhiRz
         1dlIRaGAOFgbNrm6dSpfL3o3CLdKY1fJVCNqTbJSHcsknPjVIohCL+nyAvhL686jsEKk
         AtRv5QA9eeMgHjjGDbTqwxGmnBCFagOMtHhiYkctm+shOpQTaDm9YzfpBrnKoqS9TzMm
         nVEesIuVU+whaVnpGq3uKpFN0L7XrBG4meVrVRxf+tqPTuYkTweTuFAC3KzKZlc1LMr7
         IhjEgprth70m7imGw8Z76r8l4xV6LZi6zY6HyDMKD6xwy2zPVFQ5/x5pOUTdrOugmYsG
         XgLA==
X-Forwarded-Encrypted: i=1; AJvYcCXkOHu7jXCK9ULJxxRIuk/PMx7oC/9ofdNQJ9Nt1uqHHZyoS4QFabWobD00K8Qm3P5P17U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFKcIntbw5yfE7WUbKQDckPbs3+36tr2w066lbf/RXqYOrWcto
	n6+Louef46XGWsqMdbqJ04vhVb9iO3B8DUT5GlSLEZfiumR9/5aMB4oXxkvuIfj03oPfWaGkCdQ
	5k7IwpRh5+8hfwaS42kzKd0WSOjMxT6mXitOk7zyydMVKpELf5ecstQ==
X-Gm-Gg: ASbGncs1GEbQgENGztoyVgcnnZ9gmRwwDm1ijOoY0tr5mr+kREVv02FYKov21/5rYe4
	yYZQzXBbtmKr2TV1+1mh/CHa3r91PBJUS8MszRXEU2YZdbWBJivWbMinxeZcJ4NUV36k0VXkcyz
	lnxA8WzoYCCR8UguaRP9uGv+eLlTofkA7/TZDIqiqkho1xA4lKeFdAkaqABQr+FSo5/UdoEF9Rn
	S1bjfzr8Quj2mug/sDFvxQWtOWcsRT8jH8HadUfFcWaAKbJYKfF3jCT67jBu8O2TGa+je1BGd7X
	NKqrdBi576LNhLCuIQR58OFLOQqmN/UeWdKHDffxzfyPJf53dHs3VHx7LShTC/xBLw==
X-Received: by 2002:a05:600c:c16a:b0:46f:b42e:e39e with SMTP id 5b1f17b1804b1-477308c60aamr38306715e9.39.1761920629801;
        Fri, 31 Oct 2025 07:23:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH73DZHEsR+mQzo+LpxpAHYqi6uaGXmBv0wFmteO6GGOwU3gZyA1bUah7DEckHfOtZkUbifcg==
X-Received: by 2002:a05:600c:c16a:b0:46f:b42e:e39e with SMTP id 5b1f17b1804b1-477308c60aamr38306415e9.39.1761920629398;
        Fri, 31 Oct 2025 07:23:49 -0700 (PDT)
Received: from fedora ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4773c2ed409sm664775e9.2.2025.10.31.07.23.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 07:23:48 -0700 (PDT)
Date: Fri, 31 Oct 2025 15:23:45 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>,
 qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
 kvm@vger.kernel.org, Sergio Lopez <slp@redhat.com>, Gerd Hoffmann
 <kraxel@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Laurent
 Vivier <lvivier@redhat.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu
 <yi.l.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, Eduardo
 Habkost <eduardo@habkost.net>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, Alistair Francis <alistair.francis@wdc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, qemu-riscv@nongnu.org, Weiwei Li
 <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>, Yanan Wang
 <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>, Palmer Dabbelt
 <palmer@dabbelt.com>, Ani Sinha <anisinha@redhat.com>, Fabiano Rosas
 <farosas@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Liu Zhiwei
 <zhiwei_liu@linux.alibaba.com>, =?UTF-8?B?Q2zDqW1lbnQ=?= Mathieu--Drif
 <clement.mathieu--drif@eviden.com>, qemu-arm@nongnu.org, =?UTF-8?B?TWFy?=
 =?UTF-8?B?Yy1BbmRyw6k=?= Lureau <marcandre.lureau@redhat.com>, Huacai Chen
 <chenhuacai@kernel.org>, Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v4 00/27] hw/i386/pc: Remove deprecated 2.6 and 2.7 PC
 machines
Message-ID: <20251031152345.65b2caed@fedora>
In-Reply-To: <aQTEKyQjqIIGtyP0@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
	<20251031113344.7cb11540@imammedo-mac>
	<0942717b-214f-4e08-9e2a-6b87ded991c9@linaro.org>
	<aQTEKyQjqIIGtyP0@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 31 Oct 2025 22:14:03 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> Hi Igor and Philippe,
>=20
> > On 31/10/25 11:33, Igor Mammedov wrote: =20
> > > On Thu,  8 May 2025 15:35:23 +0200
> > > Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:
> > >=20
> > > Are you planning to resping it?
> > > (if yes, I can provide you with a fixed 2/27 patch that removes all l=
egacy cpu hp leftovers) =20
> >=20
> > Sorry, no, I already burned all the x86 credits I had for 2025 :S =20
>=20
> Don't say that, thanks for your efforts! :-)
>=20
> > Zhao kindly offered to help with respin :) =20
>=20
> I haven't forgotten about this. I also plan to help it move forward
> in the coming weeks.

in this case, I'll send reworked patch (not really tested)
as a reply 2/27 so you could incorporate it on respin.

=20
> Thanks,
> Zhao
>=20


