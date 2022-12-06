Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEDEE644434
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 14:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbiLFNLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 08:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235008AbiLFNKr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 08:10:47 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5ED2DABB;
        Tue,  6 Dec 2022 05:09:11 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id B000068B05; Tue,  6 Dec 2022 14:09:01 +0100 (CET)
Date:   Tue, 6 Dec 2022 14:09:01 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Christoph Hellwig <hch@lst.de>, Lei Rao <lei.rao@intel.com>,
        kbusch@kernel.org, axboe@fb.com, kch@nvidia.com, sagi@grimberg.me,
        alex.williamson@redhat.com, cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH 5/5] nvme-vfio: Add a document for the NVMe device
Message-ID: <20221206130901.GB24358@lst.de>
References: <20221206055816.292304-1-lei.rao@intel.com> <20221206055816.292304-6-lei.rao@intel.com> <20221206062604.GB6595@lst.de> <Y48+AaG5rSCviIhl@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y48+AaG5rSCviIhl@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 09:05:05AM -0400, Jason Gunthorpe wrote:
> In this case Intel has a real PCI SRIOV VF to expose to the guest,
> with a full VF RID.

RID?

> The proper VFIO abstraction is the variant PCI
> driver as this series does. We want to use the variant PCI drivers
> because they properly encapsulate all the PCI behaviors (MSI, config
> space, regions, reset, etc) without requiring re-implementation of this
> in mdev drivers.

I don't think the code in this series has any chance of actually
working.  There is a lot of state associated with a NVMe subsystem,
controller and namespace, such as the serial number, subsystem NQN,
namespace uniqueue identifiers, Get/Set features state, pending AENs,
log page content.  Just migrating from one device to another without
capturing all this has no chance of actually working.

> I don't think we know enough about this space at the moment to fix a
> specification to one path or the other, so I hope the TPAR will settle
> on something that can support both models in SW and people can try
> things out.

I've not seen anyone from Intel actually contributing to the live
migration TPAR, which is almost two month old by now.
