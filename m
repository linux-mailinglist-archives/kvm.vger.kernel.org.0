Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8584BEC04
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 21:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbiBUUoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 15:44:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiBUUoF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 15:44:05 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 80065237F0;
        Mon, 21 Feb 2022 12:43:41 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 47AEA1063;
        Mon, 21 Feb 2022 12:43:41 -0800 (PST)
Received: from [10.57.40.147] (unknown [10.57.40.147])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 51ACA3F66F;
        Mon, 21 Feb 2022 12:43:37 -0800 (PST)
Message-ID: <1d8004d3-1887-4fc7-08d2-0e2ee6b5fdcb@arm.com>
Date:   Mon, 21 Feb 2022 20:43:33 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v6 02/11] driver core: Add dma_cleanup callback in
 bus_type
Content-Language: en-GB
To:     Christoph Hellwig <hch@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
References: <20220218005521.172832-1-baolu.lu@linux.intel.com>
 <20220218005521.172832-3-baolu.lu@linux.intel.com>
 <YhCdEmC2lYStmUSL@infradead.org>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <YhCdEmC2lYStmUSL@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-02-19 07:32, Christoph Hellwig wrote:
> So we are back to the callback madness instead of the nice and simple
> flag?  Sigh.

TBH, I *think* this part could be a fair bit simpler. It looks like this 
whole callback mess is effectively just to decrement group->owner_cnt, 
but since we should only care about ownership at probe, hotplug, and 
other places well outside critical fast-paths, I'm not sure we really 
need to keep track of that anyway - it can always be recalculated by 
walking the group->devices list, and some of the relevant places have to 
do that anyway. It should be pretty straightforward for 
iommu_bus_notifier to clear group->owner automatically upon an unbind of 
the matching driver when it's no longer bound to any other devices in 
the group either. And if we still want to entertain the notion of VFIO 
being able to release ownership without unbinding (I'm not entirely 
convinced that's a realistically necessary use-case) then it should be 
up to VFIO to decide when it's finally finished with the whole group, 
rather than pretending we can keep track of nested ownership claims from 
inside the API.

Furthermore, If Greg was willing to compromise just far enough to let us 
put driver_managed_dma in the 3-byte hole in the generic struct 
device_driver, we wouldn't have to have quite so much boilerplate 
repeated across the various bus implementations (I'm not suggesting to 
move any actual calls back into the driver core, just the storage of 
flag itself). FWIW I have some ideas for re-converging .dma_configure in 
future which I think should probably be able to subsume this into a 
completely generic common path, given a common flag.

Robin.
