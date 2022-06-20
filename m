Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30127551059
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 08:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238471AbiFTGcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 02:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiFTGcR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 02:32:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2FCBE1E;
        Sun, 19 Jun 2022 23:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oft8FlbmjHBjJqlnhBPI4YswqmZIF+Cnzz/NNEVVT+E=; b=1XYMUd/2v7vTlQnwMxOtngE7gl
        uwvrBST6y4aRz4Rgyvs1Y/GfkVLkbhk9d65Dd91y++7i+PqcFe6tCmlR+p33CmdHLdA35CWJYcePw
        582xxxz0W6kCtRcoz/CEhxGuRbDDcLtU6Xk48x6+/+sT1PImmNtk7swPaJ7QXb98J/ksnWRhgjRlN
        JYADWPL56pc3Z65TUqHDycWlrfcK4kbex92PdAEcrOUaRvRPjKi6OC3quFJwvaTFkQYZYwAljpqer
        nFr7/BVhfFvNN0DndogwkjF/DFNbwsRgdmzo1VzYU85R2BQGpzVo1k8icWLT0CF2BbVKoScyfRHZo
        1mM1DdVg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o3AxD-00GRZI-Uf; Mon, 20 Jun 2022 06:32:07 +0000
Date:   Sun, 19 Jun 2022 23:32:07 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Nicolin Chen <nicolinc@nvidia.com>, kwankhede@nvidia.com,
        corbet@lwn.net, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, tvrtko.ursulin@linux.intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com,
        akrowiak@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, cohuck@redhat.com,
        kevin.tian@intel.com, jchrist@linux.ibm.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [RFT][PATCH v1 5/6] vfio/ccw: Add kmap_local_page() for memcpy
Message-ID: <YrAUZ7hXy2FcZcjl@infradead.org>
References: <20220616235212.15185-1-nicolinc@nvidia.com>
 <20220616235212.15185-6-nicolinc@nvidia.com>
 <Yqw+7gM3Lz96UFdz@infradead.org>
 <20220620025726.GA5219@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620025726.GA5219@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 19, 2022 at 11:57:26PM -0300, Jason Gunthorpe wrote:
> The remark about io memory is because on s390 memcpy() will crash even
> on ioremapped memory, you have to use the memcpy_to/fromio() which
> uses the special s390 io access instructions.

Yes.  The same is true for various other architectures, inluding arm64
under the right circumstances.

> This helps because we now block io memory from ever getting into these
> call paths. I'm pretty sure this is a serious security bug, but would
> let the IBM folks remark as I don't know it all that well..

Prevent as in crash when trying to convert it to a page?

> As for the kmap, I thought it was standard practice even if it is a
> non-highmem? Aren't people trying to use this for other security
> stuff these days?

Ira has been lookin into the protection keys, although they don't
apply to s390.  Either way I don't object to using kmap, but the
commit log doesn't make much sense to me.
