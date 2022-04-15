Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84EA2502C03
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 16:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354584AbiDOOiz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 10:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354522AbiDOOix (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 10:38:53 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBE548303
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 07:36:25 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id E338A68AFE; Fri, 15 Apr 2022 16:36:21 +0200 (CEST)
Date:   Fri, 15 Apr 2022 16:36:21 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 04/10] vfio: Use a struct of function pointers instead
 of a many symbol_get()'s
Message-ID: <20220415143621.GA1958@lst.de>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com> <4-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com> <20220415044533.GA22209@lst.de> <20220415121301.GH2120790@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415121301.GH2120790@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 15, 2022 at 09:13:01AM -0300, Jason Gunthorpe wrote:
> > So I got anoyed at this as well a while ago and I still think this
> > is the wrong way around.
> 
> What I plan to do in future is to have differnt ops returned depending
> on if the file is a struct vfio_group or a struct vfio_device, so it
> is not entirely pointless like this.

Uh, I think that is a rather ugly interface.  Why would kvm pass in
FDs to both into the same interface.

> 
> > I'd much rather EXPORT_SYMBOL_GPL kvm_register_device_ops and
> > just let kvm_vfio_ops live in a module than all the symbol_get
> > crazyness.  We'll need to be careful to deal with unload races
> > or just not allow unloading, though.
> 
> This is certainly more complicated - especially considering module
> unload - than a single symbol_get(). How do you see the benefit?

Because that is the sensible layering - kvm already has an abstract
interface for emulated devices.  So instead of doing symbol_get magic
of some kind we should leverage it.

But I can see how that is something you might not want to do for
this series.  So maybe stick to the individual symbol_gets for now
and I'll send a separate series to clean that up?  Especially as
I have a half-finished series for that from a while ago anyway.

> 
> Jason
---end quoted text---
