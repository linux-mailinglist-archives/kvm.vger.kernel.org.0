Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0712250263E
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 09:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236718AbiDOHd7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 03:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234855AbiDOHd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 03:33:58 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F017CA0BE3
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 00:31:29 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6286968B05; Fri, 15 Apr 2022 09:31:26 +0200 (CEST)
Date:   Fri, 15 Apr 2022 09:31:25 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 05/10] vfio: Move vfio_external_user_iommu_id() to
 vfio_file_ops
Message-ID: <20220415073125.GC24824@lst.de>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com> <5-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 14, 2022 at 03:46:04PM -0300, Jason Gunthorpe wrote:
> The only user wants to get a pointer to the struct iommu_group associated
> with the VFIO file being used. Instead of returning the group ID then
> searching sysfs for that string just directly return the iommu_group
> pointer already held by the vfio_group struct.
> 
> It already has a safe lifetime due to the struct file kref.

Except for the strange function pointer indirection this does looks
sensible to me, but I wonder if we want to do this change even more
high level: The only thing that needs the IOMMU group is the PPC
kvm_spapr_tce_attach_iommu_group / kvm_spapr_tce_release_vfio_group
helpers.  And these use it only to find the iommu_table_group
structure.  Why can't we just have the vfio_group point to that
table group diretly in vfio or the vfio SPAPR backend and remove
all the convoluted lookups?
