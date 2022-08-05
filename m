Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F2E58AF96
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 20:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240899AbiHESLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 14:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiHESLP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 14:11:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF52229839;
        Fri,  5 Aug 2022 11:11:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CBD761830;
        Fri,  5 Aug 2022 18:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F51C433D6;
        Fri,  5 Aug 2022 18:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659723072;
        bh=uhsU2yeYQMb8fBkEMlPeo+n2vx1ZR0ocIn28vvJncwk=;
        h=Date:From:To:Cc:Subject:From;
        b=gH90EbPR6ETqG2olJRa1NFfdoe3plAI05vQYCjX6mFcgIMfmxFSa5ozj6KJVkGTkG
         c5e6m8r4VDePVhDczpr4ExiZ1GXLYnFCDAEEHQymVkeynv+8aKWoVM2zB8xJy3BYzk
         y3Iz9xaLfoiHTa7k1DFkKN+0nGySY2xVHA1kPngSr57yDMyL1SVIV4plCxDvBD4XS1
         qnubREx0SXLIIogO2ESbJVDfkX17Pw7C9BO/7FszG2ADDnqEfekjtCUL+7B4zrleMq
         HlRJNuera50lgcaP3n5+SNykti/JkDFJ1+n5mTkN6IQOjCTQ6bHqKOEdoQeRKbis8d
         vG/XVRTGMMusA==
Date:   Fri, 5 Aug 2022 19:11:06 +0100
From:   Will Deacon <will@kernel.org>
To:     mst@redhat.com, stefanha@redhat.com
Cc:     jasowang@redhat.com, torvalds@linux-foundation.org,
        ascull@google.com, maz@kernel.org, keirf@google.com,
        jiyong@google.com, kernel-team@android.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: IOTLB support for vhost/vsock breaks crosvm on Android
Message-ID: <20220805181105.GA29848@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi folks,

[tl;dr a change from ~18 months ago breaks Android userspace and I don't
 know what to do about it]

As part of the development work for next year's Android, we've recently
been bringing up a 5.15 KVM host and have observed that vsock no longer
works for communicating with a guest because crosvm gets an unexpected
-EFAULT back from the VHOST_VSOCK_SET_RUNNING ioctl():

 | E crosvm : vpipe worker thread exited with error: VhostVsockStart(IoctlError(Os { code: 14, kind: Uncategorized, message: "Bad address" }))

The same guest payload works correctly on a 5.10 KVM host kernel.

After some digging, we narrowed this change in behaviour down to
e13a6915a03f ("vhost/vsock: add IOTLB API support") and further digging
reveals that the infamous VIRTIO_F_ACCESS_PLATFORM feature flag is to
blame. Indeed, our tests once again pass if we revert that patch (there's
a trivial conflict with the later addition of VIRTIO_VSOCK_F_SEQPACKET
but otherwise it reverts cleanly).

On Android, KVM runs in a mode where the host kernel is, by default,
unable to access guest memory [1] and so memory used for virtio (e.g.
the rings and descriptor data) needs to be shared explicitly with the
host using hypercalls issued by the guest. We implement this on top of
restricted DMA [2], whereby the guest allocates a pool of shared memory
during boot and bounces all virtio transfers through this window. In
order to get the guest to use the DMA API for virtio devices (which is
required for the SWIOTLB code to kick in and do the aforementioned
bouncing), crosvm sets the VIRTIO_F_ACCESS_PLATFORM feature flag on its
emulated devices and this is picked up by virtio_has_dma_quirk() in the
guest kernel. This has been working well for us so far.

With e13a6915a03f, the vhost backend for vsock now advertises
VIRTIO_F_ACCESS_PLATFORM in its response to the VHOST_GET_FEATURES
ioctl() and accepts it in the VHOST_SET_FEATURES as a mechanism to
enable the IOTLB feature (note: this is nothing to do with SWIOTLB!).
This feature is used for emulation of a virtual IOMMU and requires
explicit support for issuing IOTLB messages (see VHOST_IOTLB_MSG and
VHOST_IOTLB_MSG_V2) from userspace to manage address translations for
the virtio device.

Looking at how crosvm uses these vhost ioctl()s, we can see:

        let avail_features = self
            .vhost_handle
            .get_features()
            .map_err(Error::VhostGetFeatures)?;

        let features: c_ulonglong = self.acked_features & avail_features;
        self.vhost_handle
            .set_features(features)
            .map_err(Error::VhostSetFeatures)?;

where 'acked_features' is the feature set negotiated between crosvm and
the guest, while 'avail_features' is the supported feature set
advertised by vhost. The intersection of these now includes
VIRTIO_F_ACCESS_PLATFORM in the 5.15 kernel and so we quietly start
enabling IOTLB, despite not having any of the necessary support in
crosvm and therefore the vsock thread effectively grinds to a halt and
we cannot communicate with the guest.

The fundamental issue is, I think, that VIRTIO_F_ACCESS_PLATFORM is
being used for two very different things within the same device; for the
guest it basically means "use the DMA API, it knows what to do" but for
vhost it very specifically means "enable IOTLB". We've recently had
other problems with this flag [3] but in this case it used to work
reliably and now it doesn't anymore.

So how should we fix this? One possibility is for us to hack crosvm to
clear the VIRTIO_F_ACCESS_PLATFORM flag when setting the vhost features,
but others here have reasonably pointed out that they didn't expect a
kernel change to break userspace. On the flip side, the offending commit
in the kernel isn't exactly new (it's from the end of 2020!) and so it's
likely that others (e.g. QEMU) are using this feature. I also strongly
suspect that vhost net suffers from exactly the same issue, we just
don't happen to be using that (yet) in Android.

Thanks,

Will

[1] https://lwn.net/Articles/836693/
[2] https://lwn.net/Articles/841916/
[3] https://lore.kernel.org/lkml/YtkCQsSvE9AZyrys@google.com/
