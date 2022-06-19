Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97AA05508DE
	for <lists+kvm@lfdr.de>; Sun, 19 Jun 2022 08:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbiFSGSa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jun 2022 02:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbiFSGS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Jun 2022 02:18:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4874BA444;
        Sat, 18 Jun 2022 23:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=j/JBNwa/VyqAIaEnsFXpkXodHo6vqnGAI1xYD1tiqZo=; b=jLy3lF1kmifcevO6HwuwLb2bFh
        cICoOWdEb52iimiuzsyFdgSGbDfBBC787zRztZfYBUzRkU3DbiisicNQha2BbgsLDASZAqlpbDqX+
        CayphOqce8z+TfP2HkVcrHrm2hHTIy8TWjnWp29vlBJQCVPNbRwYvTisXiVrym+4d8fsSzlTNF8jG
        7w53PIyh2fuPAL/nVK5V2AB0RS2rivSUMvoExuxG5X4NfK3QTjdT3ES8S5RwQ+x+hewyZrG6fZzsL
        FfoWD4w/eycsn6U0AMNoWXmZphF8mWTSvbeuLBmDvLOr81ZFwgR3gAHlhSrhrZyPWZinA3hRHEMd4
        Eklp6K+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o2oGH-00DL70-A1; Sun, 19 Jun 2022 06:18:17 +0000
Date:   Sat, 18 Jun 2022 23:18:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>, kwankhede@nvidia.com,
        corbet@lwn.net, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, tvrtko.ursulin@linux.intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com,
        akrowiak@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, cohuck@redhat.com, jgg@nvidia.com,
        kevin.tian@intel.com, jchrist@linux.ibm.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [RFT][PATCH v1 6/6] vfio: Replace phys_pfn with phys_page for
 vfio_pin_pages()
Message-ID: <Yq6/qS+AE1LfO+/q@infradead.org>
References: <20220616235212.15185-1-nicolinc@nvidia.com>
 <20220616235212.15185-7-nicolinc@nvidia.com>
 <YqxBLbu8yPJiwK6Z@infradead.org>
 <Yqz64VK1IQ0QzXEe@Asurada-Nvidia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yqz64VK1IQ0QzXEe@Asurada-Nvidia>
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

On Fri, Jun 17, 2022 at 03:06:25PM -0700, Nicolin Chen wrote:
> On Fri, Jun 17, 2022 at 01:54:05AM -0700, Christoph Hellwig wrote:
> > There is a bunch of code an comments in the iommu type1 code that
> > suggest we can pin memory that is not page backed.  
> 
> Would you mind explaining the use case for pinning memory that
> isn't page backed? And do we have such use case so far?

Sorry, I should have deleted that sentence.  I wrote it before spending
some more time to dig through the code and all the locked memory has
page backing.  There just seem to be a lot of checks left inbetween
if a pfn is page backed, mostly due to the pfn based calling convetions.

> I can do that. I tried once, but there were just too much changes
> inside type1 code that felt like a chain reaction. If we plan to
> eventually replace with IOMMUFD implementations, these changes in
> type1 might not be necessary, I thought.

To make sure we keep full compatibility I suspect the final iommufd
implementation has to be gradutally created from the existing code
anyway.
