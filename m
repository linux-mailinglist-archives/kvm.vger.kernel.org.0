Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFA97C5693
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 16:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347019AbjJKORe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 10:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347024AbjJKORb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 10:17:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33ED1B8
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 07:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=17Hg6kGHCOgU0Ms0AduR83aFqotdoFUXv6TjFFYWHj0=; b=e4N5pa9Ss2bbnDPRcL2fhVrsX9
        MTyCngG3sagVj43C48O8opbBPCE9zBiwHi5/52PlVZyBHcj8tMG8H07ntEm3aq7IULjZbDYoL+B3x
        xH9nF4tYPWB1RJEpRDg1CQvPi/PdTARqpJl0zlAjcXjORDnXOh+r+WcLELiZa7XkypN6o2BVbm6ct
        sVM+WmfChkm2gssYQYNHYbERaPCuRCmSO2nkmb3a38eWWX19VBVyf80qTIgik1UWDTAfBPTzhxnJy
        awjWqNnOGP/t/FYvrQW2yt2tTH6Iuzhq6fso1qk0vVee0iDlLc2neGBGNq4AQV6djUakUre4v4Pvu
        2Ki25qyQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qqa1d-00G4WZ-0N;
        Wed, 11 Oct 2023 14:17:25 +0000
Date:   Wed, 11 Oct 2023 07:17:25 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <ZSaudclSEHDEsyDP@infradead.org>
References: <c3724e2f-7938-abf7-6aea-02bfb3881151@nvidia.com>
 <20230926072538-mutt-send-email-mst@kernel.org>
 <ZRpjClKM5mwY2NI0@infradead.org>
 <20231002151320.GA650762@nvidia.com>
 <ZR54shUxqgfIjg/p@infradead.org>
 <20231005111004.GK682044@nvidia.com>
 <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <ZSZAIl06akEvdExM@infradead.org>
 <20231011135709.GW3952@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011135709.GW3952@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023 at 10:57:09AM -0300, Jason Gunthorpe wrote:
> > Independent of my above points on the doubts on VF-controlled live
> > migration for PCe device I absolutely agree with your that the Linux
> > abstraction and user interface should be VF based.  Which further
> > reinforeces my point that the VFIO driver for the controlled function
> > (PF or VF) and the Linux driver for the controlling function (better
> > be a PF in practice) must be very tightly integrated.  And the best
> > way to do that is to export the vfio nodes from the Linux driver
> > that knowns the hardware and not split out into a separate one.
> 
> I'm not sure how we get to "very tightly integrated". We have many
> examples of live migration vfio drivers now and they do not seem to
> require tight integration. The PF driver only has to provide a way to
> execute a small number of proxied operations.

Yes.  And for that I need to know what VF it actually is dealing
with.  Which is tight integration in my book.

> Regardless, I'm not too fussed about what directory the implementation
> lives in, though I do prefer the current arrangement where VFIO only
> stuff is in drivers/vfio. I like the process we have where subsystems
> are responsible for the code that implements the subsystem ops.

I really don't care about where the code lives (in the directory tree)
either.  But as you see with virtio trying to split it out into
an arbitrary module causes all kinds of pain.

> 
> E800 also made some significant security mistakes that VFIO side
> caught. I think would have been missed if it went into a netdev
> tree.
> 
> Even unrelated to mdev, Intel GPU is still not using the vfio side
> properly, and the way it hacked into KVM to try to get page tracking
> is totally logically wrong (but Works For Me (tm))
> 
> Aside from technical concerns, I do have a big process worry
> here. vfio is responsible for the security side of the review of
> things implementing its ops.

Yes, anytjing exposing a vfio node needs vfio review, period.  And
I don't think where the code lived was the i915 problem.  The problem
was they they were the first open user of the mdev API, which was
just a badly deisgned hook for never published code at that time, and
they then shoehorned it into a weird hypervisor abstraction.  There's
no good way to succeed with that.
