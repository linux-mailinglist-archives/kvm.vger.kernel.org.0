Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2B758BAEE
	for <lists+kvm@lfdr.de>; Sun,  7 Aug 2022 15:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbiHGNO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 09:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiHGNOz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 09:14:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BBF9F11A
        for <kvm@vger.kernel.org>; Sun,  7 Aug 2022 06:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659878092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xE1ql9r1WlnpphQLIhOk9A5gTFrWDcEvErV3HfUz44Q=;
        b=GoYHbnsC85pX43NXb6iH/rxLeJG0PycIu4I4Mzrzc/I99vvmNYcyLbl2Wmlo68yEK6BvSs
        pnmWlcu8jRl4cx2U7Tzlr4WzYTxdhoZrq3DpPVP1t1Ftue72DAUKGPJSWpDwuCUPnv50gn
        nj3u7jE0LK05DRfpPtYhy8hIGSEU7i0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607--CnVR6FCNpWu3VEM9RiyaQ-1; Sun, 07 Aug 2022 09:14:51 -0400
X-MC-Unique: -CnVR6FCNpWu3VEM9RiyaQ-1
Received: by mail-wm1-f69.google.com with SMTP id 131-20020a1c0289000000b003a52a0c70b0so1785849wmc.2
        for <kvm@vger.kernel.org>; Sun, 07 Aug 2022 06:14:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=xE1ql9r1WlnpphQLIhOk9A5gTFrWDcEvErV3HfUz44Q=;
        b=HP/9PEHSji+I3l3KImRQBci6YlCKWleCmH1f1v7JGdPiu4ikYxB1aKwGKB8L1+EWae
         y3+EcI1cwBQAZZ0yte9xck5x9BOqf6blAEjcu6Vkx54asqLYHcNejY4FSMDEXAaZMhL8
         YLNrAEMJcvw/O7zMAh3/r7N52AD7/aEeBf0/WWMWvJOm2Lm1i9fRiPQRi3J3OigeYIiS
         a79LuBk46CZ2XB1YwnBdem7GGB88xlw9jZJU4VM/XNmSwuxLM12MR5E8H8ADjGYdL8Yq
         4mCaxO4CaVoXR89Uol3ic0t+83CmW9D+Zci0PgSL71n8WaUIH1JkLIjQngWTFfR0cNEB
         kDag==
X-Gm-Message-State: ACgBeo10SM9g4RVdlDP4GU+aOuxYNCRkufmJ2J+9VP3SfEX4YMqSNmt7
        ohHpISKcs0QHpOXA5Haorcv4cAGOCH9yC51lyERr9wPEpUw7kG0oHf+qgStmHEVEkL+KLvx8Lxr
        JFSa6f2AQ4AJn
X-Received: by 2002:a7b:cb55:0:b0:3a5:41a:829c with SMTP id v21-20020a7bcb55000000b003a5041a829cmr12476234wmj.153.1659878090318;
        Sun, 07 Aug 2022 06:14:50 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7XPmSXHx0uphBUati04hlAT8Kv454CdlO9eCJMcNZrnnQufGNHHbsrZu1If3gI3BrvRzX2yQ==
X-Received: by 2002:a7b:cb55:0:b0:3a5:41a:829c with SMTP id v21-20020a7bcb55000000b003a5041a829cmr12476216wmj.153.1659878090075;
        Sun, 07 Aug 2022 06:14:50 -0700 (PDT)
Received: from redhat.com ([2.52.21.123])
        by smtp.gmail.com with ESMTPSA id ba5-20020a0560001c0500b0021efc75914esm9570153wrb.79.2022.08.07.06.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Aug 2022 06:14:49 -0700 (PDT)
Date:   Sun, 7 Aug 2022 09:14:43 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Will Deacon <will@kernel.org>
Cc:     stefanha@redhat.com, jasowang@redhat.com,
        torvalds@linux-foundation.org, ascull@google.com, maz@kernel.org,
        keirf@google.com, jiyong@google.com, kernel-team@android.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: IOTLB support for vhost/vsock breaks crosvm on Android
Message-ID: <20220807042408-mutt-send-email-mst@kernel.org>
References: <20220805181105.GA29848@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805181105.GA29848@willie-the-truck>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Will, thanks very much for the analysis and the writeup!

On Fri, Aug 05, 2022 at 07:11:06PM +0100, Will Deacon wrote:
> So how should we fix this? One possibility is for us to hack crosvm to
> clear the VIRTIO_F_ACCESS_PLATFORM flag when setting the vhost features,
> but others here have reasonably pointed out that they didn't expect a
> kernel change to break userspace. On the flip side, the offending commit
> in the kernel isn't exactly new (it's from the end of 2020!) and so it's
> likely that others (e.g. QEMU) are using this feature.

Exactly, that's the problem.

vhost is reusing the virtio bits and it's only natural that
what you are doing would happen.

To be precise, this is what we expected people to do (and what QEMU does):


#define QEMU_VHOST_FEATURES ((1 << VIRTIO_F_VERSION_1) |
			     (1 << VIRTIO_NET_F_RX_MRG) | .... )

VHOST_GET_FEATURES(... &host_features);
host_features &= QEMU_VHOST_FEATURES
VHOST_SET_FEATURES(host_features & guest_features)


Here QEMU_VHOST_FEATURES are the bits userspace knows about.

Our assumption was that whatever userspace enables, it
knows what the effect on vhost is going to be.

But yes, I understand absolutely how someone would instead just use the
guest features. It is unfortunate that we did not catch this in time.


In hindsight, we should have just created vhost level macros
instead of reusing virtio ones. Would address the concern
about naming: PLATFORM_ACCESS makes sense for the
guest since there it means "whatever access rules platform has",
but for vhost a better name would be VHOST_F_IOTLB.
We should have also taken greater pains to document what
we expect userspace to do. I remember now how I thought about something
like this but after coding this up in QEMU I forgot to document this :(
Also, I suspect given the history the GET/SET features ioctl and burned
wrt extending it and we have to use a new when we add new features.
All this we can do going forward.


But what can we do about the specific issue?
I am not 100% sure since as Will points out, QEMU and other
userspace already rely on the current behaviour.

Looking at QEMU specifically, it always sends some translations at
startup, this in order to handle device rings.

So, *maybe* we can get away with assuming that if no IOTLB ioctl was
ever invoked then this userspace does not know about IOTLB and
translation should ignore IOTLB completely.

I am a bit nervous about breaking some *other* userspace which actually
wants device to be blocked from accessing memory until IOTLB
has been setup. If we get it wrong we are making guest
and possibly even host vulnerable.
And of course just revering is not an option either since there
are now whole stacks depending on the feature.

Will I'd like your input on whether you feel a hack in the kernel
is justified here.

Also yes, I think it's a good idea to change crosvm anyway.  While the
work around I describe might make sense upstream I don't think it's a
reasonable thing to do in stable kernels.
I think I'll prepare a patch documenting the legal vhost features
as a 1st step even though crosvm is rust so it's not importing
the header directly, right?

-- 
MST

