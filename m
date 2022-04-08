Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D614F9A03
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 17:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237875AbiDHQB3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 12:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiDHQB2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 12:01:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363CDCEA;
        Fri,  8 Apr 2022 08:59:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC18562075;
        Fri,  8 Apr 2022 15:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40ECC385A1;
        Fri,  8 Apr 2022 15:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649433564;
        bh=L/Sp0bHMk3mx20gCUpx3dC8SctQpezEy6viyRYrihq0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=L+lo9BrbQYtTNb1DgX8qbVaefwj4fxENZ6ygVswZmOCj6jOCN4fwQ0t128jZQZcqP
         oE+tKEyuM+tzHDg+kNKbBBUXMaqHJ7M9b+3yuVjqWAnpdETm2UjaLZFVwPpfI738k9
         qsC/CCdiwgwfVTJaObIWfnFHKD9wWez8IpG2fGVrcTYmXP7soBZdStZylnYn3jpLEL
         6WURLmm/sjdcKB/tQigWF8K694tsn0BLmrulsl3+3HBt7euzzB7WNR7ENbF8S6OdLG
         jcORWeAxDxx00czoe/2M0CP9zRBo1yWKngoKpVOO3FpUXY1JFvrFS3mE0/DvjCS3vt
         OGrqAXQzsGUtA==
Date:   Fri, 8 Apr 2022 10:59:22 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>, rafael@kernel.org,
        David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>, Ashok Raj <ashok.raj@intel.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v8 00/11] Fix BUG_ON in vfio_iommu_group_notifier()
Message-ID: <20220408155922.GA317094@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlBWrE7kxX9vraOD@8bytes.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 08, 2022 at 05:37:16PM +0200, Joerg Roedel wrote:
> On Fri, Apr 08, 2022 at 11:17:47AM -0300, Jason Gunthorpe wrote:
> > You might consider using a linear tree instead of the topic branches,
> > topics are tricky and I'm not sure it helps a small subsystem so much.
> > Conflicts between topics are a PITA for everyone, and it makes
> > handling conflicts with rc much harder than it needs to be.
> 
> I like the concept of a branch per driver, because with that I can just
> exclude that branch from my next-merge when there are issues with it.
> Conflicts between branches happen too, but they are quite manageable
> when the branches have the same base.

FWIW, I use the same topic branch approach for PCI.  I like the
ability to squash in fixes or drop things without having to clutter
the history with trivial commits and reverts.  I haven't found
conflicts to be a problem.

Bjorn
