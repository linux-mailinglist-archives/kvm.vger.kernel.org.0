Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7126E727BDE
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 11:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234793AbjFHJs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 05:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234703AbjFHJs5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 05:48:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F35D2273E
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 02:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686217682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qJkqbDxJbGuLRNFoh+RhZZol0vchzC/C3TXtJPnBQMs=;
        b=AdloyzYUx0BsUo+9XtBjGdeFdBptXhk7e5MHmTIhGAQ7CW00AOf5QnNGZMLTdeRbYBuU4k
        k2JB5y/bKUMjE+ND5A+ATAYzhoJJ2KRKS44TvlI26eOusqo+E8jEiDdG/dG7icJ/08+E2T
        OYXVKiDBkqejV+RNyFay36/M4me1Z1w=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-422-ephnN-pGOXiEe9kXeHs57w-1; Thu, 08 Jun 2023 05:48:01 -0400
X-MC-Unique: ephnN-pGOXiEe9kXeHs57w-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-514b05895f7so475308a12.0
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 02:48:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686217680; x=1688809680;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qJkqbDxJbGuLRNFoh+RhZZol0vchzC/C3TXtJPnBQMs=;
        b=cdM96oNlFvENpRqcO3ylPCvLWdBV3Zd7yv+5v5rlzvwb9V+2PSdvkM20g6h1XB4yIL
         Rlb8agRatfdp7G7DBVcy6666vRBZH6HPiAw02Y2RLvSlhqqd77ZZI1geJ752efEJ38lx
         oL4L3xF4YFZXsMz30EHbV6N6Z1+xGdmsQ+1RdooC+ZX7caunH0zhKa79Eyhv3scyg+PR
         WiqcLupQOoAitwidAvXPc6cSw1h4IR1cubrMTsC3d8URQTCnsa967dS3uBMP4qjk5r94
         KH9Xrana7QMyf8PsvF0cQF0IpGmnSbjtUS9aLxl4WKhWf0+pgInrShLGEFVqiUlrRbbt
         WC3g==
X-Gm-Message-State: AC+VfDzBQieMDDD2yrsPHpKvf4jrgRVnx3LSez6pUG3Z/P3Ra4nZZaS3
        sgmOF9JQE8/HLbUC7mcGo3FlGLmCHYw4POrSLkqCzTuldJz9F5ApbKovIZlTS7JGZLQ+WtLYb3T
        25YXAZAzPyeW1
X-Received: by 2002:a17:906:fe4d:b0:969:e9ec:9a0 with SMTP id wz13-20020a170906fe4d00b00969e9ec09a0mr8201387ejb.77.1686217679953;
        Thu, 08 Jun 2023 02:47:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6NJp+wlr+w+M7l9N5lK1cvOGgUHySBO4evePM0JMqeGlWTtsRtzk3HhVko4gsZJNpXU4WPjA==
X-Received: by 2002:a17:906:fe4d:b0:969:e9ec:9a0 with SMTP id wz13-20020a170906fe4d00b00969e9ec09a0mr8201367ejb.77.1686217679599;
        Thu, 08 Jun 2023 02:47:59 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-111.business.telecomitalia.it. [87.12.25.111])
        by smtp.gmail.com with ESMTPSA id t7-20020a1c7707000000b003f6cf9afc25sm4641635wmi.40.2023.06.08.02.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 02:47:59 -0700 (PDT)
Date:   Thu, 8 Jun 2023 11:47:56 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Shannon Nelson <shannon.nelson@amd.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <t6ci7ek54zwss2w3kxaduirfi7vp5df5ydjxjlnr5fhv4ji3c5@aw26xy66pjc7>
References: <20230606085643-mutt-send-email-mst@kernel.org>
 <CAGxU2F7fkgL-HpZdj=5ZEGNWcESCHQpgRAYQA3W2sPZaoEpNyQ@mail.gmail.com>
 <20230607054246-mutt-send-email-mst@kernel.org>
 <CACGkMEuUapKvUYiJiLwtsN+x941jafDKS9tuSkiNrvkrrSmQkg@mail.gmail.com>
 <20230608020111-mutt-send-email-mst@kernel.org>
 <CACGkMEt4=3BRVNX38AD+mJU8v3bmqO-CdNj5NkFP-SSvsuy2Hg@mail.gmail.com>
 <5giudxjp6siucr4l3i4tggrh2dpqiqhhihmdd34w3mq2pm5dlo@mrqpbwckpxai>
 <CACGkMEtqn1dbrQZn3i-W_7sVikY4sQjwLRC5xAhMnyqkc3jwOw@mail.gmail.com>
 <lw3nmkdszqo6jjtneyp4kjlmutooozz7xj2fqyxgh4v2ralptc@vkimgnbfafvi>
 <CACGkMEt1yRV9qOLBqtQQmJA_UoRLCpznT=Gvd5D51Uaz2jakHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEt1yRV9qOLBqtQQmJA_UoRLCpznT=Gvd5D51Uaz2jakHA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 08, 2023 at 05:29:58PM +0800, Jason Wang wrote:
>On Thu, Jun 8, 2023 at 5:21 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> On Thu, Jun 08, 2023 at 05:00:00PM +0800, Jason Wang wrote:
>> >On Thu, Jun 8, 2023 at 4:00 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>> >>
>> >> On Thu, Jun 08, 2023 at 03:46:00PM +0800, Jason Wang wrote:
>> >>
>> >> [...]
>> >>
>> >> >> > > > > I have a question though, what if down the road there
>> >> >> > > > > is a new feature that needs more changes? It will be
>> >> >> > > > > broken too just like PACKED no?
>> >> >> > > > > Shouldn't vdpa have an allowlist of features it knows how
>> >> >> > > > > to support?
>> >> >> > > >
>> >> >> > > > It looks like we had it, but we took it out (by the way, we were
>> >> >> > > > enabling packed even though we didn't support it):
>> >> >> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6234f80574d7569444d8718355fa2838e92b158b
>> >> >> > > >
>> >> >> > > > The only problem I see is that for each new feature we have to modify
>> >> >> > > > the kernel.
>> >> >> > > > Could we have new features that don't require handling by vhost-vdpa?
>> >> >> > > >
>> >> >> > > > Thanks,
>> >> >> > > > Stefano
>> >> >> > >
>> >> >> > > Jason what do you say to reverting this?
>> >> >> >
>> >> >> > I may miss something but I don't see any problem with vDPA core.
>> >> >> >
>> >> >> > It's the duty of the parents to advertise the features it has. For example,
>> >> >> >
>> >> >> > 1) If some kernel version that is packed is not supported via
>> >> >> > set_vq_state, parents should not advertise PACKED features in this
>> >> >> > case.
>> >> >> > 2) If the kernel has support packed set_vq_state(), but it's emulated
>> >> >> > cvq doesn't support, parents should not advertise PACKED as well
>> >> >> >
>> >> >> > If a parent violates the above 2, it looks like a bug of the parents.
>> >> >> >
>> >> >> > Thanks
>> >> >>
>> >> >> Yes but what about vhost_vdpa? Talking about that not the core.
>> >> >
>> >> >Not sure it's a good idea to workaround parent bugs via vhost-vDPA.
>> >>
>> >> Sorry, I'm getting lost...
>> >> We were talking about the fact that vhost-vdpa doesn't handle
>> >> SET_VRING_BASE/GET_VRING_BASE ioctls well for packed virtqueue before
>> >> that series [1], no?
>> >>
>> >> The parents seem okay, but maybe I missed a few things.
>> >>
>> >> [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
>> >
>> >Yes, more below.
>> >
>> >>
>> >> >
>> >> >> Should that not have a whitelist of features
>> >> >> since it interprets ioctls differently depending on this?
>> >> >
>> >> >If there's a bug, it might only matter the following setup:
>> >> >
>> >> >SET_VRING_BASE/GET_VRING_BASE + VDUSE.
>> >> >
>> >> >This seems to be broken since VDUSE was introduced. If we really want
>> >> >to backport something, it could be a fix to filter out PACKED in
>> >> >VDUSE?
>> >>
>> >> mmm it doesn't seem to be a problem in VDUSE, but in vhost-vdpa.
>> >> I think VDUSE works fine with packed virtqueue using virtio-vdpa
>> >> (I haven't tried), so why should we filter PACKED in VDUSE?
>> >
>> >I don't think we need any filtering since:
>> >
>> >PACKED features has been advertised to userspace via uAPI since
>> >6234f80574d7569444d8718355fa2838e92b158b. Once we relax in uAPI, it
>> >would be very hard to restrict it again. For the userspace that tries
>> >to negotiate PACKED:
>> >
>> >1) if it doesn't use SET_VRING_BASE/GET_VRING_BASE, everything works well
>> >2) if it uses SET_VRING_BASE/GET_VRING_BASE. it might fail or break silently
>> >
>> >If we backport the fixes to -stable, we may break the application at
>> >least in the case 1).
>>
>> Okay, I see now, thanks for the details!
>>
>> Maybe instead of "break silently", we can return an explicit error for
>> SET_VRING_BASE/GET_VRING_BASE in stable branches.
>> But if there are not many cases, we can leave it like that.
>
>A second thought, if we need to do something for stable. is it better
>if we just backport Shannon's series to stable?

I tried to look at it, but it looks like we have to backport quite a few
patches, I wrote a few things here:

https://lore.kernel.org/virtualization/32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an/

But if you think it's the best way, though, we can take a better look
at how many patches are to backport and whether it's risky or not.

>
>>
>> I was just concerned about how does the user space understand that it
>> can use SET_VRING_BASE/GET_VRING_BASE for PACKED virtqueues in a given
>> kernel or not.
>
>My understanding is that if packed is advertised, the application
>should assume SET/GET_VRING_BASE work.
>

Same here. So as an alternative to backporting a large set of patches,
I proposed to completely disable packed for stable branches where
vhost-vdpa IOCTLs doesn't support them very well.

Thanks,
Stefano

