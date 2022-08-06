Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEB758B879
	for <lists+kvm@lfdr.de>; Sat,  6 Aug 2022 23:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbiHFVsJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Aug 2022 17:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233212AbiHFVsH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Aug 2022 17:48:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71CFBBF4B
        for <kvm@vger.kernel.org>; Sat,  6 Aug 2022 14:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659822485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G/Yc0SN4MCdHWQQL7Yeq1p7bShR2bu8cCKLfrIoQmUw=;
        b=Bxjk7i2uxin8fFhTh73iLy5UQtn3iyObyFsYoC5yrkLzfC1T2JUEuFQ9LVZdGSj89jUMML
        4hNazkhOm87CrN4AupzUHS7ShdwyjGIgto+BblWf5hcPRIBR1zMZGqbK+muhYy7zAcAjXx
        C1wrWzYdQ76qWCjF5lsKTOUBX39URVY=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-VAb4klPqNu2wqppToTxGiw-1; Sat, 06 Aug 2022 17:48:03 -0400
X-MC-Unique: VAb4klPqNu2wqppToTxGiw-1
Received: by mail-lf1-f72.google.com with SMTP id n17-20020ac242d1000000b0048af11cb0f4so1176654lfl.19
        for <kvm@vger.kernel.org>; Sat, 06 Aug 2022 14:48:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=G/Yc0SN4MCdHWQQL7Yeq1p7bShR2bu8cCKLfrIoQmUw=;
        b=zl+woBqqL1yGSFary09/gtj+MH9UOYxw9plxQxpTJQ+hQ7IbToD9rBdM3YtunLHFpP
         gBWEJ/nwnzdniQA2a8F9GsQp38b5EW7D255k/CwnZUZUX3Lwet5Eiv1QH0Wvh0PLNc43
         GZUFq2nz/ZcYoNBGerd8y2VZakqd6BZNT4J/Dfw3k8c2DcFXzhnR28Vm8bnIpCVCGKtm
         diL3s2ei7YRxj5j160SGciqOSPxWgLTKrGHOhWdpMDlhvlUcD+kHf0vjKszGx1D+y9uW
         X1RQd+hst1HTXstdUB/5wp45JCX6vxDkmsT1CQUeKKh2YNC5abeXasZ9MZHE4mDT+hHw
         olxQ==
X-Gm-Message-State: ACgBeo2la1HrTtxV9yv1V/25QWLhrLkrCMh9Wbbvw0+G9FjZAbM1CArI
        HJrlVLmyGa6hK26Ui2eZUkJlLT9c3qN1eoypu+4nIlnbPCusDWAw/OHaIUw7CRv/iL6651TZDUh
        4tCVQVkNeglAqG439SoAOa5dxRqYE
X-Received: by 2002:a2e:96c1:0:b0:258:e8ec:3889 with SMTP id d1-20020a2e96c1000000b00258e8ec3889mr3830092ljj.6.1659822481966;
        Sat, 06 Aug 2022 14:48:01 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4Bq+qQub/hc9Zw+AFp/9p2wRrQxN4NisZClKldO2MHMROZVH32qxdSbMaJa+L5k/npjjS1q4gBM/6yk6Y4QVk=
X-Received: by 2002:a2e:96c1:0:b0:258:e8ec:3889 with SMTP id
 d1-20020a2e96c1000000b00258e8ec3889mr3830084ljj.6.1659822481766; Sat, 06 Aug
 2022 14:48:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220805181105.GA29848@willie-the-truck> <20220806074828.zwzgn5gj47gjx5og@sgarzare-redhat>
 <20220806094239.GA30268@willie-the-truck> <CAD60JZMbbkwFHqCm_iCrOrKgRLBUMkDQfuJ=Q1T-sZt59eTBrw@mail.gmail.com>
 <20220806143443.GA30658@willie-the-truck>
In-Reply-To: <20220806143443.GA30658@willie-the-truck>
From:   Stefan Hajnoczi <shajnocz@redhat.com>
Date:   Sat, 6 Aug 2022 17:47:50 -0400
Message-ID: <CAD60JZOwho3D-_gXZTT3aYSgo04Pd=VrM7QyJbgfp8PYqzOvgw@mail.gmail.com>
Subject: Re: IOTLB support for vhost/vsock breaks crosvm on Android
To:     Will Deacon <will@kernel.org>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Michael Tsirkin <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        torvalds@linux-foundation.org, ascull@google.com, maz@kernel.org,
        keirf@google.com, jiyong@google.com, kernel-team@android.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Aug 6, 2022 at 10:35 AM Will Deacon <will@kernel.org> wrote:
>
> On Sat, Aug 06, 2022 at 06:52:15AM -0400, Stefan Hajnoczi wrote:
> > On Sat, Aug 6, 2022 at 5:50 AM Will Deacon <will@kernel.org> wrote:
> > > On Sat, Aug 06, 2022 at 09:48:28AM +0200, Stefano Garzarella wrote:
> > > > On Fri, Aug 05, 2022 at 07:11:06PM +0100, Will Deacon wrote:
> > > > If the VMM implements the translation feature, it is right in my opinion
> > > > that it does not enable the feature for the vhost device. Otherwise, if it
> > > > wants the vhost device to do the translation, enable the feature and send
> > > > the IOTLB messages to set the translation.
> > > >
> > > > QEMU for example masks features when not required or supported.
> > > > crosvm should negotiate only the features it supports.
> > > >
> > > > @Michael and @Jason can correct me, but if a vhost device negotiates
> > > > VIRTIO_F_ACCESS_PLATFORM, then it expects the VMM to send IOTLB messages to
> > > > set the translation.
> > >
> > > As above, the issue is that vhost now unconditionally advertises this in
> > > VHOST_GET_FEATURES and so a VMM with no knowledge of IOTLB can end up
> > > enabling it by accident.
> >
> > Unconditionally exposing all vhost feature bits to the guest is
> > incorrect. The emulator must filter out only the feature bits that it
> > supports.
>
> I've evidently done a bad job of explaining this, sorry.
>
> crosvm _does_ filter the feature bits which it passes to vhost. It takes the
> feature set which it has negotiated with the guest and then takes the
> intersection of this set with the set of features which vhost advertises.
> The result is what is passed to VHOST_SET_FEATURES. I included the rust
> for this in my initial mail, but in C it might look something like:
>
>         u64 features = negotiate_features_with_guest(dev);
>
>         ioctl(vhost_fd, VHOST_GET_FEATURES, &vhost_features);
>         vhost_features &= features;     /* Mask out unsupported features */
>         ioctl(vhost_fd, VHOST_SET_FEATURES, &vhost_features);

This is unrelated to the current issue, but this code looks wrong.
VHOST_GET_FEATURES must be called before negotiating with the guest.
The device features must be restricted by vhost before advertising
them to the guest. For example, if a new crosvm binary runs on an old
kernel then feature bits crosvm negotiated with the guest may not be
supported by the vhost kernel module and the device is broken.

> The problem is that crosvm has negotiated VIRTIO_F_ACCESS_PLATFORM with
> the guest so that restricted DMA is used for the virtio devices. With
> e13a6915a03f, VIRTIO_F_ACCESS_PLATFORM is now advertised by
> VHOST_GET_FEATURES and so IOTLB is enabled by the sequence above.
>
> > For example, see QEMU's vhost-net device's vhost feature bit allowlist:
> > https://gitlab.com/qemu-project/qemu/-/blob/master/hw/net/vhost_net.c#L40
>
> I agree that changing crosvm to use an allowlist would fix the problem,
> I'm just questioning whether we should be changing userspace at all to
> resolve this issue.
>
> > The reason why the emulator (crosvm/QEMU/etc) must filter out feature
> > bits is that vhost devices are full VIRTIO devices. They are a subset
> > of a VIRTIO device and the emulator is responsible for the rest of the
> > device. Some features will require both vhost and emulator support.
> > Therefore it is incorrect to expect the device to work correctly if
> > the vhost feature bits are passed through to the guest.
>
> I think crosvm is trying to cater for this by masking out the features
> it doesn't know about.

Can you point to the guest driver code for restricted DMA? It's
unclear to me what the guest drivers are doing and whether that is
VIRTIO spec compliant. Is the driver compliant with VIRTIO 1.2 "6.1
Driver Requirements: Reserved Feature Bits":

  A driver SHOULD accept VIRTIO_F_ACCESS_PLATFORM if it is offered,
and it MUST then either disable the IOMMU or configure the IOMMU to
translate bus addresses passed to the device into physical addresses
in memory. If VIRTIO_F_ACCESS_PLATFORM is not offered, then a driver
MUST pass only physical addresses to the device.

Stefan

