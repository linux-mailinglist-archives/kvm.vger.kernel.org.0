Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201BF58B9DC
	for <lists+kvm@lfdr.de>; Sun,  7 Aug 2022 08:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbiHGGwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 02:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbiHGGwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 02:52:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94017A18A;
        Sat,  6 Aug 2022 23:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=T5G3kNwYRK7zLNUCU3R4YTUeZT4VSRInrZ5Z/Pp3Lkw=; b=dCJLYoEWdMdq7/FPcLfiG3jJ3W
        wv4d+6ODFzDjRx+CPUhu0szsBENo+10WjIWSfgFDu2Ee0AWGv+cDPHlYrZuy6lXjevoWiSI071j0l
        CUUKF2QWwn4hZjEzNAiW9mL3Tvl/7cLETJ6yvSC/ZWFZ+Zzm+IU1c8VfwKR5wJX4+3FUzubPbehxK
        R/DdhY1UjhTq1kFAj+grLPDvto3F2m5EE/IC4lrC/a+LQEoeGVoLvsqqnuWm+59a9mXfwcGlicWsD
        NZRhuAHRJshRVzaEFOsu5cfFZLH8U9Qxab1KuBhwvdgDtlwJxsG9XC3ZBMgn9dmpramTuL7rqo7nb
        AghKr/vg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oKa8z-007LfM-Rq; Sun, 07 Aug 2022 06:52:13 +0000
Date:   Sat, 6 Aug 2022 23:52:13 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Will Deacon <will@kernel.org>, mst@redhat.com, stefanha@redhat.com,
        jasowang@redhat.com, ascull@google.com, maz@kernel.org,
        keirf@google.com, jiyong@google.com, kernel-team@android.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: IOTLB support for vhost/vsock breaks crosvm on Android
Message-ID: <Yu9hHef3VawCbJT9@infradead.org>
References: <20220805181105.GA29848@willie-the-truck>
 <CAHk-=wip-Lju3ZdNwknS6ouyw+nKXeRSnhqVyNo8WSEdk-BfGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wip-Lju3ZdNwknS6ouyw+nKXeRSnhqVyNo8WSEdk-BfGw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 05, 2022 at 03:57:08PM -0700, Linus Torvalds wrote:
> Why is "IOMMU support" called "VIRTIO_F_ACCESS_PLATFORM"?

Because, as far as the virtio spec and virtio "guest" implementation is
concerned it is not about IOMMU support at all.  It is about treating
virtio DMA as real DMA by the platform, which lets the platform let
whatever method of DMA mapping it needs to the virtio device.  This
is needed to make sure harware virtio device are treated like actual
hardware and not like a magic thing bypassing the normal PCIe rules.

Using an IOMMU if one is present for bus is just one thing, others
are using offets of DMAs that are very common on non-x86 platforms,
or doing the horrible cache flushing needed on devices where PCIe
is not cache coherent.

It really is vhost that seems to abuse it so that if the guest
claims it can handle VIRTIO_F_ACCESS_PLATFORM (which every modern
guest should) it enables magic behavior, which I don't think is what
the virtio spec intended.
