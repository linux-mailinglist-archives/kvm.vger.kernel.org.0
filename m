Return-Path: <kvm+bounces-8225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 041FF84CCEB
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 15:35:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 67D331F22F80
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 14:35:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABEE87F7DC;
	Wed,  7 Feb 2024 14:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fxQvsSpG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F8C7E765
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 14:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707316516; cv=none; b=gTLAvPxRM4wuApvs1g/RyCxtEhJfhqtsAIZjs30u6/DKROnIoyquezzFB5JyEBRVuBSVaKwmYmkopAsgreczL6LuTDM6NmgYZ1v3sRi+ZWNgx7gIr5QGl6GMnoMQA2eRlnacUTbgO7ZtbbREBr6cXSvLJy1T0iIMXSLnPQ7f79c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707316516; c=relaxed/simple;
	bh=gpczSAxiMi16s36upVGETQy331v3qZNDG6hZpWEIo9A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mspDeil0ZSoq0EmV4gjTrhgv3k2mNM2KJUEybawXM/7Tgm1fYGNXHxbCDVLTfw6TD/hD1MsEfZHO68LTiP5XIBMwKhUPB9fnHjRPQWjfhEDZBZl6Q26T9YDAcefAmmCnGoCEQs+uRwGkdS3VqMr3L8ELsYtIJLvpJizX6qfjxWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fxQvsSpG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707316514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GS8oKSLwKnX/1OmCvP477VoPbNUPt8nzRLpvXwaBKqk=;
	b=fxQvsSpGPjicc4McUOvTraVlNQxZlZBWWf8PQbfLN1oqu0wadrYMrRykLhaLSIrjzM6SHh
	QnPAJvnTNnc3TUnLLIFcwBHW0t5vfxAOqNnpHmt0jootgEni9qI/HTk31/T5iY9FTklwgv
	wrtt0dnopoo77jRlXQ4Gm2uyieMvO1U=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-444-DxZCXl9uNmK2pxX7rzpouA-1; Wed, 07 Feb 2024 09:35:12 -0500
X-MC-Unique: DxZCXl9uNmK2pxX7rzpouA-1
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-dc6cd10fd4aso950801276.1
        for <kvm@vger.kernel.org>; Wed, 07 Feb 2024 06:35:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707316512; x=1707921312;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GS8oKSLwKnX/1OmCvP477VoPbNUPt8nzRLpvXwaBKqk=;
        b=gP5uE+ZZULuPPHx7w3Zp98wFVeRh84rCh5+P0WGI8014OqLcAeVMKOpwX6d/YAADoY
         g3S6BmeFdkMG3pJFOKfNVy46lpS27P8xQWp/dB8bWhFW9qXptVFQPFPPEhlpck5dUW3u
         ukfS3KqHvhqLjwrPeHsY7pjaTVJlZ32uvIz6qTDann/AGPrZXMfU52lkLbGR9FXUaZla
         G5LW+TFOHa9iaru5GGygRXJMzkApe1CnWaQdVccBz3MWGLSImk2SsM3YnBlNPNSzcK/k
         3QXvzWHRLlctKSSw00PZBwwsMbYwhw2wywUsydHc2VmMOzVRp1Ox48ffQVh0ANBxDxes
         9SSA==
X-Forwarded-Encrypted: i=1; AJvYcCXIq6O5t6VUMEweMordyL6aPZTVmTc/bDqZmWF/vHxcEqVyGJhwhh3SE5FC1+B5nqBKFvkqmOwyQbVbW2WU388aQrgm
X-Gm-Message-State: AOJu0YylpfMhXAsAgKaY/Jl4XtwPzbgMFTfE7rMKVAQyIWGssAmgACWo
	6p3vwa9ZAWal5cZ+hoWQjNk/7LnEHDRARJ6UV80KvmGhjJwELkIccxmbChOl07+80Njgv14YJaK
	7j/JGnwuIV7YCoyuU9rJdg/WgJy85elexmfLUMbx/h/j6Z8FS6aCMmMoEIlq4VVcxsO1UEdBTNw
	7crR6fKYP48kMAGNwrDNNG5r1C
X-Received: by 2002:a25:ac4a:0:b0:dc2:6698:2c7f with SMTP id r10-20020a25ac4a000000b00dc266982c7fmr4891913ybd.33.1707316512034;
        Wed, 07 Feb 2024 06:35:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHE++5w1moQLuHaAqcodu9tX5wQSeMmoBwfQu91lEa9262GLOPvEjAZwMad0/0OUSEvws/4fl6Yzjr0KEw6orY=
X-Received: by 2002:a25:ac4a:0:b0:dc2:6698:2c7f with SMTP id
 r10-20020a25ac4a000000b00dc266982c7fmr4891893ybd.33.1707316511720; Wed, 07
 Feb 2024 06:35:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231122-vfs-eventfd-signal-v2-0-bd549b14ce0c@kernel.org> <20231122-vfs-eventfd-signal-v2-2-bd549b14ce0c@kernel.org>
In-Reply-To: <20231122-vfs-eventfd-signal-v2-2-bd549b14ce0c@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 7 Feb 2024 15:34:59 +0100
Message-ID: <CABgObfaSVv=TFmwh+bxjaw3fpWAnemnf1Z5Us5kJtNN=oeGrag@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] eventfd: simplify eventfd_signal()
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>, Oded Gabbay <ogabbay@kernel.org>, 
	Wu Hao <hao.wu@intel.com>, Tom Rix <trix@redhat.com>, Moritz Fischer <mdf@kernel.org>, 
	Xu Yilun <yilun.xu@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Zhi Wang <zhi.a.wang@intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>, David Airlie <airlied@gmail.com>, 
	Daniel Vetter <daniel@ffwll.ch>, Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Frederic Barrat <fbarrat@linux.ibm.com>, Andrew Donnellan <ajd@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Farman <farman@linux.ibm.com>, 
	Matthew Rosato <mjrosato@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, 
	Vineeth Vijayan <vneethv@linux.ibm.com>, Peter Oberparleiter <oberpar@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Tony Krowiak <akrowiak@linux.ibm.com>, 
	Jason Herne <jjherne@linux.ibm.com>, Harald Freudenberger <freude@linux.ibm.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Diana Craciun <diana.craciun@oss.nxp.com>, 
	Alex Williamson <alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>, 
	Fei Li <fei1.li@intel.com>, Benjamin LaHaise <bcrl@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, 
	Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-fpga@vger.kernel.org, 
	intel-gvt-dev@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	linux-rdma@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-s390@vger.kernel.org, linux-usb@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-aio@kvack.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 22, 2023 at 1:49=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> Ever since the evenfd type was introduced back in 2007 in commit
> e1ad7468c77d ("signal/timer/event: eventfd core") the eventfd_signal()
> function only ever passed 1 as a value for @n. There's no point in
> keeping that additional argument.
>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  arch/x86/kvm/hyperv.c                     |  2 +-
>  arch/x86/kvm/xen.c                        |  2 +-
>  virt/kvm/eventfd.c                        |  4 ++--
>  30 files changed, 60 insertions(+), 63 deletions(-)

For KVM:

Acked-by: Paolo Bonzini <pbonzini@redhat.com>


