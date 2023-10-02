Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85667B4B73
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 08:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235489AbjJBG2f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 02:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjJBG2e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 02:28:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9AE9B
        for <kvm@vger.kernel.org>; Sun,  1 Oct 2023 23:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZMdkpPxBqBuLB1qTmV7JqN4JNT6W1zFmaXJs7hkvDC4=; b=wZl9gSkXIHzF800cPVU/NDbl4d
        rWXNsjMEV+yc+M+QKLnRBUOpj/2ud75qGUqt9y6OlThQ67l40Qfr1Yw8n05jkIJrmJuFvfbhFTS/1
        +4O4JPJyxQsIaS9TDIOeMo0u9xWqpmc780gXm37GGmgZUIc0CKzSnfPgNzJZG4LX2uz3T3qHKWrBP
        SIAslog9M0/b+lVXVWQGein+9hjmI47HK47/Lkhp6zn7rDxkH+QosjzCiSChSkH2pEvpVom1bjCgL
        9CUt/NM5HP0qI4HUyGn0zWynG93dsho5DshFKnUvIKUF7B1SDV7MVk37+e07Pds+XH6BmyzK4cz5g
        tEhvxt8Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qnCPq-00C1hQ-31;
        Mon, 02 Oct 2023 06:28:26 +0000
Date:   Sun, 1 Oct 2023 23:28:26 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, jgg@nvidia.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <ZRpjClKM5mwY2NI0@infradead.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-11-yishaih@nvidia.com>
 <20230922055336-mutt-send-email-mst@kernel.org>
 <c3724e2f-7938-abf7-6aea-02bfb3881151@nvidia.com>
 <20230926072538-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230926072538-mutt-send-email-mst@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023 at 07:41:44AM -0400, Michael S. Tsirkin wrote:
> 
> Except, there's no reasonable way for virtio to know what is done with
> the device then. You are not using just 2 symbols at all, instead you
> are using the rich vq API which was explicitly designed for the driver
> running the device being responsible for serializing accesses. Which is
> actually loaded and running. And I *think* your use won't conflict ATM
> mostly by luck. Witness the hack in patch 01 as exhibit 1 - nothing
> at all even hints at the fact that the reason for the complicated
> dance is because another driver pokes at some of the vqs.

Fully agreed.  The smart nic vendors are trying to do the same mess
in nvme, and we really need to stop them and agree on proper standarized
live migration features implemented in the core virtio/nvme code.

