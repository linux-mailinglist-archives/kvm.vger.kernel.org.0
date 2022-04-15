Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231C7502172
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 06:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349438AbiDOEsI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 00:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbiDOEsH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 00:48:07 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C65554FBF
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 21:45:38 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8BD0C68B05; Fri, 15 Apr 2022 06:45:34 +0200 (CEST)
Date:   Fri, 15 Apr 2022 06:45:34 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 04/10] vfio: Use a struct of function pointers instead
 of a many symbol_get()'s
Message-ID: <20220415044533.GA22209@lst.de>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com> <4-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 14, 2022 at 03:46:03PM -0300, Jason Gunthorpe wrote:
> kvm and VFIO need to be coupled together however neither is willing to
> tolerate a direct module dependency. Instead when kvm is given a VFIO FD
> it uses many symbol_get()'s to access VFIO.
> 
> Provide a single VFIO function vfio_file_get_ops() which validates the
> given struct file * is a VFIO file and then returns a struct of ops.
> 
> Following patches will redo each of the symbol_get() calls into an
> indirection through this ops struct.

So I got anoyed at this as well a while ago and I still think this
is the wrong way around.

I'd much rather EXPORT_SYMBOL_GPL kvm_register_device_ops and
just let kvm_vfio_ops live in a module than all the symbol_get
crazyness.  We'll need to be careful to deal with unload races
or just not allow unloading, though.
