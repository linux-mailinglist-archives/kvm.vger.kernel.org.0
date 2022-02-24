Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 389CC4C273D
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 10:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbiBXI7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 03:59:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbiBXI7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 03:59:16 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6403615C9F2;
        Thu, 24 Feb 2022 00:58:46 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21F78D6E;
        Thu, 24 Feb 2022 00:58:46 -0800 (PST)
Received: from [10.57.40.147] (unknown [10.57.40.147])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 73E543F70D;
        Thu, 24 Feb 2022 00:58:40 -0800 (PST)
Message-ID: <31dc9d19-362d-4c1a-1483-cc7f525c6dd3@arm.com>
Date:   Thu, 24 Feb 2022 08:58:36 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v6 01/11] iommu: Add dma ownership management interfaces
Content-Language: en-GB
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220218005521.172832-1-baolu.lu@linux.intel.com>
 <20220218005521.172832-2-baolu.lu@linux.intel.com>
 <f830c268-daca-8e8f-a429-0c80496a7273@arm.com>
 <20220223180244.GA390403@nvidia.com>
 <dd944ab4-cf25-fa41-0170-875e5c5fd0e8@linux.intel.com>
 <c591f91a-392c-21a2-e9bd-10c64073e9e8@linux.intel.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <c591f91a-392c-21a2-e9bd-10c64073e9e8@linux.intel.com>
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

On 2022-02-24 05:29, Lu Baolu wrote:
> On 2/24/22 1:16 PM, Lu Baolu wrote:
>> Hi Robin and Jason,
>>
>> On 2/24/22 2:02 AM, Jason Gunthorpe wrote:
>>> On Wed, Feb 23, 2022 at 06:00:06PM +0000, Robin Murphy wrote:
>>>
>>>> ...and equivalently just set owner_cnt directly to 0 here. I don't 
>>>> see a
>>>> realistic use-case for any driver to claim the same group more than 
>>>> once,
>>>> and allowing it in the API just feels like opening up various potential
>>>> corners for things to get out of sync.
>>> I am Ok if we toss it out to get this merged, as there is no in-kernel
>>> user right now.
>>
>> So we don't need the owner pointer in the API anymore, right?
> 
> Oh, NO.
> 
> The owner token represents that the group has been claimed for user
> space access. And the default domain auto-attach policy will be changed
> accordingly.
> 
> So we still need this. Sorry for the noise.

Exactly. In fact we could almost go the other way, and rename owner_cnt 
to dma_api_users and make it mutually exclusive with owner being set, 
but that's really just cosmetic. It's understandable enough as-is that 
owner_cnt > 0 with owner == NULL represents implicit DMA API ownership.

Cheers,
Robin.
