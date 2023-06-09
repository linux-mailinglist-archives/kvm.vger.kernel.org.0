Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951E6729157
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 09:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238920AbjFIHit (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 03:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239032AbjFIHiP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 03:38:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93158173B
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 00:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686296239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bYfLgsVFNCZ8nRyAtdqv5Pzu6gYjvla7lXAg7Aj2Y+s=;
        b=gc0+ZDpHXUSAamNuFCdyN5cEUUXc6aez3q6xyeatDdsI15IWznPATSIFI9gjIlBZ9Yb45N
        RG4gujtr5xFSPQvMB6NGAe22cK7BF92URhCnTk3tjLOi+SwLO/LkRXrCjxgOPiAn+GtO4E
        2iPgnTdb+HfwOC3ENZiy0mie4niNrDU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-61-CJ8MXcCfNma3BD3n29dbyQ-1; Fri, 09 Jun 2023 03:37:17 -0400
X-MC-Unique: CJ8MXcCfNma3BD3n29dbyQ-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5142da822cbso1697895a12.2
        for <kvm@vger.kernel.org>; Fri, 09 Jun 2023 00:37:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686296236; x=1688888236;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bYfLgsVFNCZ8nRyAtdqv5Pzu6gYjvla7lXAg7Aj2Y+s=;
        b=eSF6w5Ghr6i7saxuT4C17fW/siEl1fW9mnvIJCp84klaG90iv/Jx1tbYuUnvAqooHG
         u44mUdlw7KOIc+0JkvuRdgJEHCowoj9t6tx/SqUa4dkXbVwHBVSw49a02kgM+6pX4W2T
         3VxTE2zC/UPa4xucSedn8N2BtfB97BOBeO16eVgec2Lymu8MuWJ0Kdtg7UFLc4IjIAtY
         deQQWiBl7uhtg54hZy80Oqg0/l3okK4v9QwqPRD/Vh+GdmXJqtz4M54XQgWEkX8dt235
         NKxHWGVZsJ2uWYi9hICWxce9AQ/Bs2uEiWr2CXPDzk15FovVmqUoiWID9IqpjXpuD9YT
         PCGw==
X-Gm-Message-State: AC+VfDzOZZCrIL3JvBGBw/uZ3SCNoHFLhVn6YfjdA072Atlt0xZbBMLx
        ItputbSOJkmGXfUdZ6JEAhIskoyx6zVHFpF4Uve7lobD7/VsCruIT+5WW0+8JWX29sPPbHdLz1l
        4ehVRubgaHbHF
X-Received: by 2002:a17:907:7ba9:b0:978:62c1:6b4b with SMTP id ne41-20020a1709077ba900b0097862c16b4bmr1270371ejc.61.1686296236531;
        Fri, 09 Jun 2023 00:37:16 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ78zAqU5nBkhqiiGWgfNgN+8MZicyBWov8iB0bm42uQl0fbHbGsJwIj+9uJE05ls1/Y70zGGw==
X-Received: by 2002:a17:907:7ba9:b0:978:62c1:6b4b with SMTP id ne41-20020a1709077ba900b0097862c16b4bmr1270345ejc.61.1686296236130;
        Fri, 09 Jun 2023 00:37:16 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-111.business.telecomitalia.it. [87.12.25.111])
        by smtp.gmail.com with ESMTPSA id v7-20020a1709063bc700b00965b5540ad7sm967116ejf.17.2023.06.09.00.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 00:37:15 -0700 (PDT)
Date:   Fri, 9 Jun 2023 09:37:12 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Shannon Nelson <shannon.nelson@amd.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <of6exzv2q6eculovjesz3mf4jxjxqfy27gz3jmihsnu6ummdux@k2zdfafgawla>
References: <CAGxU2F7fkgL-HpZdj=5ZEGNWcESCHQpgRAYQA3W2sPZaoEpNyQ@mail.gmail.com>
 <20230607054246-mutt-send-email-mst@kernel.org>
 <CACGkMEuUapKvUYiJiLwtsN+x941jafDKS9tuSkiNrvkrrSmQkg@mail.gmail.com>
 <20230608020111-mutt-send-email-mst@kernel.org>
 <CACGkMEt4=3BRVNX38AD+mJU8v3bmqO-CdNj5NkFP-SSvsuy2Hg@mail.gmail.com>
 <5giudxjp6siucr4l3i4tggrh2dpqiqhhihmdd34w3mq2pm5dlo@mrqpbwckpxai>
 <CACGkMEtqn1dbrQZn3i-W_7sVikY4sQjwLRC5xAhMnyqkc3jwOw@mail.gmail.com>
 <lw3nmkdszqo6jjtneyp4kjlmutooozz7xj2fqyxgh4v2ralptc@vkimgnbfafvi>
 <CACGkMEt1yRV9qOLBqtQQmJA_UoRLCpznT=Gvd5D51Uaz2jakHA@mail.gmail.com>
 <20230608102259-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230608102259-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 08, 2023 at 10:23:21AM -0400, Michael S. Tsirkin wrote:
>On Thu, Jun 08, 2023 at 05:29:58PM +0800, Jason Wang wrote:
>> On Thu, Jun 8, 2023 at 5:21 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>> >
>> > On Thu, Jun 08, 2023 at 05:00:00PM +0800, Jason Wang wrote:
>> > >On Thu, Jun 8, 2023 at 4:00 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>> > >>
>> > >> On Thu, Jun 08, 2023 at 03:46:00PM +0800, Jason Wang wrote:
>> > >>
>> > >> [...]
>> > >>
>> > >> >> > > > > I have a question though, what if down the road there
>> > >> >> > > > > is a new feature that needs more changes? It will be
>> > >> >> > > > > broken too just like PACKED no?
>> > >> >> > > > > Shouldn't vdpa have an allowlist of features it knows how
>> > >> >> > > > > to support?
>> > >> >> > > >
>> > >> >> > > > It looks like we had it, but we took it out (by the way, we were
>> > >> >> > > > enabling packed even though we didn't support it):
>> > >> >> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6234f80574d7569444d8718355fa2838e92b158b
>> > >> >> > > >
>> > >> >> > > > The only problem I see is that for each new feature we have to modify
>> > >> >> > > > the kernel.
>> > >> >> > > > Could we have new features that don't require handling by vhost-vdpa?
>> > >> >> > > >
>> > >> >> > > > Thanks,
>> > >> >> > > > Stefano
>> > >> >> > >
>> > >> >> > > Jason what do you say to reverting this?
>> > >> >> >
>> > >> >> > I may miss something but I don't see any problem with vDPA core.
>> > >> >> >
>> > >> >> > It's the duty of the parents to advertise the features it has. For example,
>> > >> >> >
>> > >> >> > 1) If some kernel version that is packed is not supported via
>> > >> >> > set_vq_state, parents should not advertise PACKED features in this
>> > >> >> > case.
>> > >> >> > 2) If the kernel has support packed set_vq_state(), but it's emulated
>> > >> >> > cvq doesn't support, parents should not advertise PACKED as well
>> > >> >> >
>> > >> >> > If a parent violates the above 2, it looks like a bug of the parents.
>> > >> >> >
>> > >> >> > Thanks
>> > >> >>
>> > >> >> Yes but what about vhost_vdpa? Talking about that not the core.
>> > >> >
>> > >> >Not sure it's a good idea to workaround parent bugs via vhost-vDPA.
>> > >>
>> > >> Sorry, I'm getting lost...
>> > >> We were talking about the fact that vhost-vdpa doesn't handle
>> > >> SET_VRING_BASE/GET_VRING_BASE ioctls well for packed virtqueue before
>> > >> that series [1], no?
>> > >>
>> > >> The parents seem okay, but maybe I missed a few things.
>> > >>
>> > >> [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
>> > >
>> > >Yes, more below.
>> > >
>> > >>
>> > >> >
>> > >> >> Should that not have a whitelist of features
>> > >> >> since it interprets ioctls differently depending on this?
>> > >> >
>> > >> >If there's a bug, it might only matter the following setup:
>> > >> >
>> > >> >SET_VRING_BASE/GET_VRING_BASE + VDUSE.
>> > >> >
>> > >> >This seems to be broken since VDUSE was introduced. If we really want
>> > >> >to backport something, it could be a fix to filter out PACKED in
>> > >> >VDUSE?
>> > >>
>> > >> mmm it doesn't seem to be a problem in VDUSE, but in vhost-vdpa.
>> > >> I think VDUSE works fine with packed virtqueue using virtio-vdpa
>> > >> (I haven't tried), so why should we filter PACKED in VDUSE?
>> > >
>> > >I don't think we need any filtering since:
>> > >
>> > >PACKED features has been advertised to userspace via uAPI since
>> > >6234f80574d7569444d8718355fa2838e92b158b. Once we relax in uAPI, it
>> > >would be very hard to restrict it again. For the userspace that tries
>> > >to negotiate PACKED:
>> > >
>> > >1) if it doesn't use SET_VRING_BASE/GET_VRING_BASE, everything works well
>> > >2) if it uses SET_VRING_BASE/GET_VRING_BASE. it might fail or break silently
>> > >
>> > >If we backport the fixes to -stable, we may break the application at
>> > >least in the case 1).
>> >
>> > Okay, I see now, thanks for the details!
>> >
>> > Maybe instead of "break silently", we can return an explicit error for
>> > SET_VRING_BASE/GET_VRING_BASE in stable branches.
>> > But if there are not many cases, we can leave it like that.
>>
>> A second thought, if we need to do something for stable. is it better
>> if we just backport Shannon's series to stable?
>>
>> >
>> > I was just concerned about how does the user space understand that it
>> > can use SET_VRING_BASE/GET_VRING_BASE for PACKED virtqueues in a given
>> > kernel or not.
>>
>> My understanding is that if packed is advertised, the application
>> should assume SET/GET_VRING_BASE work.
>>
>> Thanks
>
>
>Let me ask you this. This is a bugfix yes? What is the appropriate Fixes
>tag?

I would say:

Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")

because we had an allow list and enabled PACKED explicitly.

I'm not sure if the parents at that time supported PACKED, but
maybe it doesn't matter since we are talking about the code in
vhost-vdpa.

Thanks,
Stefano

