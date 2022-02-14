Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C274B546C
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 16:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355729AbiBNPSs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 10:18:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbiBNPSr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 10:18:47 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77C40593BC;
        Mon, 14 Feb 2022 07:18:39 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E72F1063;
        Mon, 14 Feb 2022 07:18:39 -0800 (PST)
Received: from [10.57.70.89] (unknown [10.57.70.89])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 972823F70D;
        Mon, 14 Feb 2022 07:18:35 -0800 (PST)
Message-ID: <08e90a61-8491-acf1-ab0f-f93f97366d24@arm.com>
Date:   Mon, 14 Feb 2022 15:18:31 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v1 3/8] iommu: Extend iommu_at[de]tach_device() for
 multi-device groups
Content-Language: en-GB
To:     Joerg Roedel <joro@8bytes.org>, Jason Gunthorpe <jgg@nvidia.com>
Cc:     Stuart Yoder <stuyoder@gmail.com>, rafael@kernel.org,
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
        Daniel Vetter <daniel@ffwll.ch>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-4-baolu.lu@linux.intel.com>
 <Ygo/eCRFnraY01WA@8bytes.org> <20220214130313.GV4160@nvidia.com>
 <Ygppub+Wjq6mQEAX@8bytes.org>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <Ygppub+Wjq6mQEAX@8bytes.org>
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

On 2022-02-14 14:39, Joerg Roedel wrote:
> On Mon, Feb 14, 2022 at 09:03:13AM -0400, Jason Gunthorpe wrote:
>> Groups should disappear into an internal implementation detail, not be
>> so prominent in the API.
> 
> Not going to happen, IOMMU groups are ABI and todays device assignment
> code, including user-space, relies on them.
> 
> Groups implement and important aspect of hardware IOMMUs that the API
> can not abstract away: That there are devices which share the same
> request-id.
> 
> This is not an issue for devices concerned by iommufd, but for legacy
> device assignment it is. The IOMMU-API needs to handle both in a clean
> API, even if it means that drivers need to lookup the sub-group of a
> device first.
> 
> And I don't see how a per-device API can handle both in a device-centric
> way. For sure it is not making it 'device centric but operate on groups
> under the hood'.

Arguably, iommu_attach_device() could be renamed something like 
iommu_attach_group_for_dev(), since that's effectively the semantic that 
all the existing API users want anyway (even VFIO at the high level - 
the group is the means for the user to assign their GPU/NIC/whatever 
device to their process, not the end in itself). That's just a lot more 
churn.

It's not that callers should be blind to the entire concept of groups 
altogether - they remain a significant reason why iommu_attach_device() 
might fail, for one thing - however what callers really shouldn't need 
to be bothered with is the exact *implementation* of groups. I do 
actually quite like the idea of refining the group abstraction into 
isolation groups as a superset of alias groups, but if anything that's a 
further argument for not having the guts of the current abstraction 
exposed in places that don't need to care - otherwise that would be 
liable to be a microcosm of this series in itself: widespread churn vs. 
"same name, new meaning" compromises.

Robin.
