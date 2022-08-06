Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F5358B488
	for <lists+kvm@lfdr.de>; Sat,  6 Aug 2022 10:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241712AbiHFIRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Aug 2022 04:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241596AbiHFIRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Aug 2022 04:17:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A7A7E13F86
        for <kvm@vger.kernel.org>; Sat,  6 Aug 2022 01:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659773865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QUhhyhwWziHPf4owDIioKjw2klBpNCGgWh43vGMAw90=;
        b=eymqhqULnNwPdR4y/XJIfPseMVkZTHtfB/KVj1NoTA26DQrewPmvdelDRiuL/7pTf40LoK
        vpIDDNBn86wZVVrJ4nFOU6JCC/wfREhTDopUTAPPNWwqAseYxCObRiaZG4Tx1Tzj7U3H3E
        tW/wCumOoe5dy8yGjRnTpJaX0p7n2QE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-TL0Da7HLO7iF_JKQNzdP8A-1; Sat, 06 Aug 2022 04:17:42 -0400
X-MC-Unique: TL0Da7HLO7iF_JKQNzdP8A-1
Received: by mail-qk1-f200.google.com with SMTP id x22-20020a05620a259600b006b552a69231so3766124qko.18
        for <kvm@vger.kernel.org>; Sat, 06 Aug 2022 01:17:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=QUhhyhwWziHPf4owDIioKjw2klBpNCGgWh43vGMAw90=;
        b=xgaopNwvQYi02Jy4SQG31lSsZIQYe2IN54Sv5DxW8/19RI/Vf51kwGyhO1NhFELamf
         qA62Ct/4pJCk8ZxZqift/C7KEaIKGKTakUUVsPIcTGO9fADEpxlBilQzkdna06UNHajC
         Dll4yLiE/ke7Xx87pdhMkhupPQUYloDXyayC97RfalyEbWs5KXMudxqt4t4opaqsO6ot
         JbRRMBJELIqGbC7VjEEB5GFnOYhOx1hmFF1c1yCMJo6UWerClWjiEujOsKt9A2gZNyT4
         1drnW2du+AqWNX4I1LJjQ/xXZrT2xiMOD1JPmsslVaMWoQpdRVc/AjmTH0tLOyNQ3QV4
         D/dw==
X-Gm-Message-State: ACgBeo3Jt/v6DEjtJEIhwg+aS/Gau8RWH4VdlWNEvOA1MBywdqP2XHUL
        LsLFSewAUDDzCM3jNRnWxdSee/VfzRxmef3e/AS4UAYnG/Up5cA6DWgC6GqkpBvs6RU9XHCmOyD
        H9mAgucrYBcX4
X-Received: by 2002:a05:622a:d5:b0:31e:eb65:e832 with SMTP id p21-20020a05622a00d500b0031eeb65e832mr9059519qtw.92.1659773862200;
        Sat, 06 Aug 2022 01:17:42 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7tYxINyBqtVppCff7bDw/5gEb1ZvpfEu6NMMMRX3xBGvdOSDUK2l2oCDIf8Yd83eFnoOADtA==
X-Received: by 2002:a05:622a:d5:b0:31e:eb65:e832 with SMTP id p21-20020a05622a00d500b0031eeb65e832mr9059511qtw.92.1659773861963;
        Sat, 06 Aug 2022 01:17:41 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id u4-20020a05620a430400b006b5988b2ca8sm4658290qko.40.2022.08.06.01.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Aug 2022 01:17:40 -0700 (PDT)
Date:   Sat, 6 Aug 2022 10:17:32 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>, mst@redhat.com,
        jasowang@redhat.com
Cc:     Will Deacon <will@kernel.org>, stefanha@redhat.com,
        ascull@google.com, maz@kernel.org, keirf@google.com,
        jiyong@google.com, kernel-team@android.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: IOTLB support for vhost/vsock breaks crosvm on Android
Message-ID: <20220806081732.a553jsoe2sfwghjg@sgarzare-redhat>
References: <20220805181105.GA29848@willie-the-truck>
 <CAHk-=wip-Lju3ZdNwknS6ouyw+nKXeRSnhqVyNo8WSEdk-BfGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAHk-=wip-Lju3ZdNwknS6ouyw+nKXeRSnhqVyNo8WSEdk-BfGw@mail.gmail.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

On Fri, Aug 05, 2022 at 03:57:08PM -0700, Linus Torvalds wrote:
>On Fri, Aug 5, 2022 at 11:11 AM Will Deacon <will@kernel.org> wrote:
>>
>> [tl;dr a change from ~18 months ago breaks Android userspace and I don't
>>  know what to do about it]
>
>Augh.
>
>I had hoped that android being "closer" to upstream would have meant
>that somebody actually tests android with upstream kernels. People
>occasionally talk about it, but apparently it's not actually done.
>
>Or maybe it's done onl;y with a very limited android user space.
>
>The whole "we notice that something that happened 18 months ago broke
>our environment" is kind of broken.
>
>> After some digging, we narrowed this change in behaviour down to
>> e13a6915a03f ("vhost/vsock: add IOTLB API support") and further digging
>> reveals that the infamous VIRTIO_F_ACCESS_PLATFORM feature flag is to
>> blame. Indeed, our tests once again pass if we revert that patch (there's
>> a trivial conflict with the later addition of VIRTIO_VSOCK_F_SEQPACKET
>> but otherwise it reverts cleanly).
>
>I have to say, this smells for *so* many reasons.
>
>Why is "IOMMU support" called "VIRTIO_F_ACCESS_PLATFORM"?
>
>That seems insane, but seems fundamental in that commit e13a6915a03f
>("vhost/vsock: add IOTLB API support")
>
>This code
>
>        if ((features & (1ULL << VIRTIO_F_ACCESS_PLATFORM))) {
>                if (vhost_init_device_iotlb(&vsock->dev, true))
>                        goto err;
>        }
>
>just makes me go "What?"  It makes no sense. Why isn't that feature
>called something-something-IOTLB?

I honestly don't know the reason for the name but 
VIRTIO_F_ACCESS_PLATFORM comes from the virtio specification:
   https://docs.oasis-open.org/virtio/virtio/v1.2/cs01/virtio-v1.2-cs01.html#x1-6600006

   VIRTIO_F_ACCESS_PLATFORM(33)
      This feature indicates that the device can be used on a platform
      where device access to data in memory is limited and/or translated.
      E.g. this is the case if the device can be located behind an IOMMU
      that translates bus addresses from the device into physical
      addresses in memory, if the device can be limited to only access
      certain memory addresses or if special commands such as a cache
      flush can be needed to synchronise data in memory with the device.
      Whether accesses are actually limited or translated is described by
      platform-specific means. If this feature bit is set to 0, then the
      device has same access to memory addresses supplied to it as the
      driver has. In particular, the device will always use physical
      addresses matching addresses used by the driver (typically meaning
      physical addresses used by the CPU) and not translated further, and
      can access any address supplied to it by the driver. When clear,
      this overrides any platform-specific description of whether device
      access is limited or translated in any way, e.g. whether an IOMMU
      may be present.

>
>Can we please just split that flag into two, and have that odd
>"platform access" be one bit, and the "enable iommu" be an entirely
>different bit?

IIUC the problem here is that the VMM does the translation and then for 
the device there is actually no need to translate, so this feature 
should not be negotiated by crosvm and vhost-vsock, but just between 
guest's driver and crosvm.

Perhaps the confusion is that we use VIRTIO_F_ACCESS_PLATFORM both 
between guest and VMM and between VMM and vhost device.

In fact, prior to commit e13a6915a03f ("vhost/vsock: add IOTLB API 
support"), vhost-vsock did not work when a VMM (e.g., QEMU) tried to 
negotiate translation with the device: 
https://bugzilla.redhat.com/show_bug.cgi?id=1894101

The simplest solution is that crosvm doesn't negotiate 
VIRTIO_F_ACCESS_PLATFORM with the vhost-vsock device if it doesn't want 
to use translation and send messages to set it.

In fact before commit e13a6915a03f ("vhost/vsock: add IOTLB API 
support") this feature was not exposed by the vhost-vsock device, so it 
was never negotiated. Now crosvm is enabling a new feature (not masking 
guest-negotiated features) so I don't think it's a break in user space, 
if the user space enable it.

I tried to explain what I understood when I made the change, Michael and 
Jason surely can add more information.

Thanks,
Stefano

