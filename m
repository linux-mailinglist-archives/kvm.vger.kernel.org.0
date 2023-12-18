Return-Path: <kvm+bounces-4747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 142CE81796F
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 19:14:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CA221C21E7E
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 18:14:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70B315D74E;
	Mon, 18 Dec 2023 18:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BWtF+un6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171435D732
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 18:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-552eaf800abso911a12.0
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 10:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702923263; x=1703528063; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DPggsM3NCSPNHuDW6MYkybcIgkppTmiteb7qARs7Z58=;
        b=BWtF+un6752vqmkcElNRbra4G8AL7vWd0Q0/4iFu5IbKRN4M3aJ8E4KjKqp0TS6mE0
         fjLc2KSlNOzadOiEl3Ik/m6tSwq//QFcSGxxm46KPA65++ucVdv53gDTNF/FRCX8Vq85
         w6l3TYM6SAkgOkou9Xnes/rwDBDKfYOp3MJy1kI3rHIQE9t0jlRCzcR/dGuNCDEa0xP8
         ksDXGasI+eaH/WtJTeBFH67Fe8mMsHS0Qsq3tTB33CDYfISQs56zpYZXnTOS/bZwdIvv
         egQpsHvQAG2WH6hmn9I5+gGBIpBLAxOrc+a0WrCUOclwug3BB+MCxu0N6dKzCyF7fTuF
         imJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702923263; x=1703528063;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DPggsM3NCSPNHuDW6MYkybcIgkppTmiteb7qARs7Z58=;
        b=CZd9jC72R7Q4F7GH3OVYrEQExlTeZDf1xdTfWomiVj08LlqRrC7eSEXGlkAy2/3Yl/
         6uMbzs5x9prKoH9uYhty6GxzWETEX+NNZxQdAA06pyMhp7tgUDQ59U5OpqtZcDwnX3oj
         d/M7WbKyJqQyP4YspA1BHkRn3Q2CLO/8vpcE+T2Ae1AuDoUEGDUawWl7sSliZUugOYnC
         q3hEUA4EkwGGtUtVSpkEkabAnhBf7MPc7aHXPgiV2lnyR8GCYY0z1YIc6yqRnIgSFzU8
         BjZ31+tE5tFFL2dOdJdu/iPA8UcGwkrmH12n+3Fg+1mKWvQdlwjMVC5woM1wCwzNI49T
         raFA==
X-Gm-Message-State: AOJu0Yx4auhydn5zZKSMYB4+8RvLy/MLbu/JiLQQ/gutWUm7nqHIE1hm
	2wRVrdGO+LQWph2aY+l6ulxtAY5zLUnvSPfH8WVjowqXaScjk2IwW8HebHq5
X-Google-Smtp-Source: AGHT+IEEzb76/Ah4Nlk8QgfziJRiEwlA6qkmZn/0hGHqfDBA43ntvwLYD5q36eVD4juH+vKRnm9fEY94vwSvJAHuo1g=
X-Received: by 2002:a50:9e49:0:b0:553:62b4:5063 with SMTP id
 z67-20020a509e49000000b0055362b45063mr16629ede.4.1702923263119; Mon, 18 Dec
 2023 10:14:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231214103520.7198-1-yan.y.zhao@intel.com> <BN9PR11MB5276BE04CBB6D07039086D658C93A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZXzx1zXfZ6GV9TgI@google.com>
In-Reply-To: <ZXzx1zXfZ6GV9TgI@google.com>
From: Yiwei Zhang <zzyiwei@google.com>
Date: Mon, 18 Dec 2023 10:14:09 -0800
Message-ID: <CAKT=dDnMaX=sxU5i=tdPDB5Wpw6TQUVrUL-JJYD3xrgxEE=acw@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: Introduce KVM VIRTIO device
To: Sean Christopherson <seanjc@google.com>
Cc: Kevin Tian <kevin.tian@intel.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "olvaffe@gmail.com" <olvaffe@gmail.com>, 
	Zhiyuan Lv <zhiyuan.lv@intel.com>, Zhenyu Z Wang <zhenyu.z.wang@intel.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, 
	"wanpengli@tencent.com" <wanpengli@tencent.com>, "jmattson@google.com" <jmattson@google.com>, 
	"joro@8bytes.org" <joro@8bytes.org>, 
	"gurchetansingh@chromium.org" <gurchetansingh@chromium.org>, "kraxel@redhat.com" <kraxel@redhat.com>
Content-Type: text/plain; charset="UTF-8"

> +Yiwei
>
> On Fri, Dec 15, 2023, Kevin Tian wrote:
> > > From: Zhao, Yan Y <yan.y.zhao@intel.com>
> > > Sent: Thursday, December 14, 2023 6:35 PM
> > >
> > > - For host non-MMIO pages,
> > >   * virtio guest frontend and host backend driver should be synced to use
> > >     the same memory type to map a buffer. Otherwise, there will be
> > >     potential problem for incorrect memory data. But this will only impact
> > >     the buggy guest alone.
> > >   * for live migration,
> > >     as QEMU will read all guest memory during live migration, page aliasing
> > >     could happen.
> > >     Current thinking is to disable live migration if a virtio device has
> > >     indicated its noncoherent state.
> > >     As a follow-up, we can discuss other solutions. e.g.
> > >     (a) switching back to coherent path before starting live migration.
> >
> > both guest/host switching to coherent or host-only?
> >
> > host-only certainly is problematic if guest is still using non-coherent.
> >
> > on the other hand I'm not sure whether the host/guest gfx stack is
> > capable of switching between coherent and non-coherent path in-fly
> > when the buffer is right being rendered.
> >
> > >     (b) read/write of guest memory with clflush during live migration.
> >
> > write is irrelevant as it's only done in the resume path where the
> > guest is not running.
> >
> > >
> > > Implementation Consideration
> > > ===
> > > There is a previous series [1] from google to serve the same purpose to
> > > let KVM be aware of virtio GPU's noncoherent DMA status. That series
> > > requires a new memslot flag, and special memslots in user space.
> > >
> > > We don't choose to use memslot flag to request honoring guest memory
> > > type.
> >
> > memslot flag has the potential to restrict the impact e.g. when using
> > clflush-before-read in migration?
>
> Yep, exactly.  E.g. if KVM needs to ensure coherency when freeing memory back to
> the host kernel, then the memslot flag will allow for a much more targeted
> operation.
>
> > Of course the implication is to honor guest type only for the selected slot
> > in KVM instead of applying to the entire guest memory as in previous series
> > (which selects this way because vmx_get_mt_mask() is in perf-critical path
> > hence not good to check memslot flag?)
>
> Checking a memslot flag won't impact performance.  KVM already has the memslot
> when creating SPTEs, e.g. the sole caller of vmx_get_mt_mask(), make_spte(), has
> access to the memslot.
>
> That isn't coincidental, KVM _must_ have the memslot to construct the SPTE, e.g.
> to retrieve the associated PFN, update write-tracking for shadow pages, etc.
>
> I added Yiwei, who I think is planning on posting another RFC for the memslot
> idea (I actually completely forgot that the memslot idea had been thought of and
> posted a few years back).

We've deferred to Yan (Intel side) to drive the userspace opt-in. So
it's up to Yan to
revise the series to be memslot flag based. I'm okay with what
upstream folks think
to be safer for the opt-in. Thanks!

> > > Instead we hope to make the honoring request to be explicit (not tied to a
> > > memslot flag). This is because once guest memory type is honored, not only
> > > memory used by guest virtio device, but all guest memory is facing page
> > > aliasing issue potentially. KVM needs a generic solution to take care of
> > > page aliasing issue rather than counting on memory type of a special
> > > memslot being aligned in host and guest.
> > > (we can discuss what a generic solution to handle page aliasing issue will
> > > look like in later follow-up series).
> > >
> > > On the other hand, we choose to introduce a KVM virtio device rather than
> > > just provide an ioctl to wrap kvm_arch_[un]register_noncoherent_dma()
> > > directly, which is based on considerations that
> >
> > I wonder it's over-engineered for the purpose.
> >
> > why not just introducing a KVM_CAP and allowing the VMM to enable?
> > KVM doesn't need to know the exact source of requiring it...
>
> Agreed.  If we end up needing to grant the whole VM access for some reason, just
> give userspace a direct toggle.

