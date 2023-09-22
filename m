Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62ABE7AA769
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 05:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjIVDqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 23:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjIVDqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 23:46:02 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAEF198
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 20:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695354356; x=1726890356;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=v4cdlljyHLqw/8xQkGrTtjHHqC8Nlaq+67sezAeMrhs=;
  b=Yneyqtpv9z+nAZLTuR6YHwXjyg9x0U3AQKdTB0Y4LhdwhylpuUL2z1jc
   MAEaNTpg0YqkedIQs8G65tTCmmvuKwR1V/Yhqp8ETO6SMjVol04uNlVeP
   AwPYPwFY8Sy+Y9qw6Q7ImUE0asPe4k4VIEVPBAr2qH/flCBl3199NQUQM
   WzDgnksjtuOU7WZpXNHi1voD8tqEc0E8efExegb3mqD0g6uv5NRZXgERE
   ViSQ7k4ufZjdJP0RZyQdySEt6Of2NCysEKqCTe885Xhi18I/jn8iHqS/H
   qBhX2MdJyIq7bgtc3fV7F6pTYVN7VmvNQijOoLiGQhoiEgDlz+5Tme3qs
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="380636239"
X-IronPort-AV: E=Sophos;i="6.03,167,1694761200"; 
   d="scan'208";a="380636239"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 20:45:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="747392168"
X-IronPort-AV: E=Sophos;i="6.03,167,1694761200"; 
   d="scan'208";a="747392168"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.93.21.134]) ([10.93.21.134])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 20:45:50 -0700
Message-ID: <dcf42003-8658-1876-313c-d0ac951d8b97@intel.com>
Date:   Fri, 22 Sep 2023 11:45:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.15.1
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921090844-mutt-send-email-mst@kernel.org>
 <20230921141125.GM13733@nvidia.com>
 <20230921101509-mutt-send-email-mst@kernel.org>
 <20230921164139.GP13733@nvidia.com>
 <20230921124331-mutt-send-email-mst@kernel.org>
 <20230921183926.GV13733@nvidia.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20230921183926.GV13733@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/22/2023 2:39 AM, Jason Gunthorpe wrote:
> On Thu, Sep 21, 2023 at 12:53:04PM -0400, Michael S. Tsirkin wrote:
>>> vdpa is not vfio, I don't know how you can suggest vdpa is a
>>> replacement for a vfio driver. They are completely different
>>> things.
>>> Each side has its own strengths, and vfio especially is accelerating
>>> in its capability in way that vpda is not. eg if an iommufd conversion
>>> had been done by now for vdpa I might be more sympathetic.
>> Yea, I agree iommufd is a big problem with vdpa right now. Cindy was
>> sick and I didn't know and kept assuming she's working on this. I don't
>> think it's a huge amount of work though.  I'll take a look.
>> Is there anything else though? Do tell.
> Confidential compute will never work with VDPA's approach.
I don't understand why vDPA can not and will never support Confidential 
computing?

Do you see any blockers?
>
>> There are a bunch of things that I think are important for virtio
>> that are completely out of scope for vfio, such as migrating
>> cross-vendor.
> VFIO supports migration, if you want to have cross-vendor migration
> then make a standard that describes the VFIO migration data format for
> virtio devices.
>
>> What is the huge amount of work am I asking to do?
> You are asking us to invest in the complexity of VDPA through out
> (keep it working, keep it secure, invest time in deploying and
> debugging in the field)
>
> When it doesn't provide *ANY* value to the solution.
>
> The starting point is a completely working vfio PCI function and the
> end goal is to put that function into a VM. That is VFIO, not VDPA.
>
> VPDA is fine for what it does, but it is not a reasonable replacement
> for VFIO.
>
> Jason

