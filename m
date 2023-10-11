Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3B97C49AE
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 08:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344303AbjJKGMf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 02:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344090AbjJKGMe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 02:12:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BAD98
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 23:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZHmurmGWwtt4E216lAAMYcysVctG/cgKUWsfe7ymYQo=; b=BtO61xfe6X2Y/9XfOV0b0clw7v
        oFG3s2tTLtZVWFXivGliGkwDPXlSgzRhb5DlPAuOPVCriDnanOkC5fZkVBgyE7QqdXFgiDKWuN0FC
        zKhA8FZ+hvlu62SyM0h5tpKWBfe3wn+8PK0rvviIiikcqzwRlWvo7zHv9twMQnd02SKXsDJDy0dfj
        2qk5axXVY8MQJBb2W+6UzjTMFsEWe7RgqA59TFXaw1o3deKRUMcTUoZaKqcDPDVXruqaTxsnYcEk1
        zZIRi5LScDjTZe/9FspnJm3R1do0uTsMGzGYokgecl0gf5D/Xq3gsb4x4WfopIN4uTZ374UA2g2Om
        RaPZy4wA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qqSSI-00EuVI-1m;
        Wed, 11 Oct 2023 06:12:26 +0000
Date:   Tue, 10 Oct 2023 23:12:26 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        alex.williamson@redhat.com, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <ZSY8yjnDqEa9ylsa@infradead.org>
References: <ZR54shUxqgfIjg/p@infradead.org>
 <20231005111004.GK682044@nvidia.com>
 <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <20231010094756-mutt-send-email-mst@kernel.org>
 <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <8ea954ba-e966-0b87-b232-06ffd79db4e3@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ea954ba-e966-0b87-b232-06ffd79db4e3@nvidia.com>
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

On Tue, Oct 10, 2023 at 06:43:32PM +0300, Yishai Hadas wrote:
> > I suggest 3 but call it on the VF. commands will switch to PF
> > internally as needed. For example, intel might be interested in exposing
> > admin commands through a memory BAR of VF itself.
> > 
> The driver who owns the VF is VFIO, it's not a VIRTIO one.

And to loop back into my previous discussion: that's the fundamental
problem here.  If it is owned by the virtio subsystem, which just
calls into vfio we would not have this problem, including the
circular loops and exposed APIs.

