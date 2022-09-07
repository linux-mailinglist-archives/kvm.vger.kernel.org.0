Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E9A5B07DC
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 17:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiIGPCV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 11:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiIGPCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 11:02:01 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C853CB5A60;
        Wed,  7 Sep 2022 08:01:59 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6961313D5;
        Wed,  7 Sep 2022 08:02:05 -0700 (PDT)
Received: from [10.57.15.197] (unknown [10.57.15.197])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF12C3F71A;
        Wed,  7 Sep 2022 08:01:56 -0700 (PDT)
Message-ID: <de00b89e-c676-1e71-c21b-dd3d13917b48@arm.com>
Date:   Wed, 7 Sep 2022 16:01:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2 4/4] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Leon Romanovsky <leon@kernel.org>, kvm@vger.kernel.org,
        linux-rdma@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Oded Gabbay <ogabbay@kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        dri-devel@lists.freedesktop.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linaro-mm-sig@lists.linaro.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        linux-media@vger.kernel.org
References: <0-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com>
 <4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com>
 <YxcYGzPv022G2vLm@infradead.org>
 <b6b5d236-c089-7428-4cc9-a08fe4f6b4a3@amd.com> <YxczjNIloP7TWcf2@nvidia.com>
 <YxiJJYtWgh1l0wxg@infradead.org> <YxiPh4u/92chN02C@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <YxiPh4u/92chN02C@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-11.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-09-07 13:33, Jason Gunthorpe wrote:
> On Wed, Sep 07, 2022 at 05:05:57AM -0700, Christoph Hellwig wrote:
>> On Tue, Sep 06, 2022 at 08:48:28AM -0300, Jason Gunthorpe wrote:
>>> Right, this whole thing is the "standard" that dmabuf has adopted
>>> instead of the struct pages. Once the AMD GPU driver started doing
>>> this some time ago other drivers followed.
>>
>> But it is simple wrong.  The scatterlist requires struct page backing.
>> In theory a physical address would be enough, but when Dan Williams
>> sent patches for that Linus shot them down.
> 
> Yes, you said that, and I said that when the AMD driver first merged
> it - but it went in anyhow and now people are using it in a bunch of
> places.
> 
> I'm happy that Christian wants to start trying to fix it, and will
> help him, but it doesn't really impact this. Whatever fix is cooked up
> will apply equally to vfio and habana.

We've just added support for P2P segments in scatterlists, can that not 
be used here?

Robin.

>> That being said the scatterlist is the wrong interface here (and
>> probably for most of it's uses).  We really want a lot-level struct
>> with just the dma_address and length for the DMA side, and leave it
>> separate from that what is used to generate it (in most cases that
>> would be a bio_vec).
> 
> Oh definitely
> 
>>> Now we have struct pages, almost, but I'm not sure if their limits are
>>> compatible with VFIO? This has to work for small bars as well.
>>
>> Why would small BARs be problematic for the pages?  The pages are more
>> a problem for gigantic BARs do the memory overhead.
> 
> How do I get a struct page * for a 4k BAR in vfio?
> 
> The docs say:
> 
>   ..hotplug api on memory block boundaries. The implementation relies on
>   this lack of user-api constraint to allow sub-section sized memory
>   ranges to be specified to :c:func:`arch_add_memory`, the top-half of
>   memory hotplug. Sub-section support allows for 2MB as the cross-arch
>   common alignment granularity for :c:func:`devm_memremap_pages`.
> 
> Jason
