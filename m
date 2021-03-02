Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A77132A6D3
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575858AbhCBPxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:53:23 -0500
Received: from mga05.intel.com ([192.55.52.43]:62889 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377782AbhCBAso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 19:48:44 -0500
IronPort-SDR: O17Dm/16mWT8W9NlsSQ86fiByzNnoBD4ICqDyMcaQsBKtTPoPapkcMMf03AZexJohuK/9Axyn7
 qaRXM9nkqscA==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="271645401"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="271645401"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 16:48:03 -0800
IronPort-SDR: DNJkPt3igpY/dyB8xh/RC/2FzxjiRvtglHy2RTkZde7Ub0jiFXLBkmGvLHHmv6HW9q5H3ZJ1kZ
 OVmGIvCN24tw==
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="517630897"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.212.197.33]) ([10.212.197.33])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 16:48:01 -0800
Subject: Re: [PATCH v5 05/14] vfio/mdev: idxd: add basic mdev registration and
 helper functions
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, parav@mellanox.com, netanelg@mellanox.com,
        shahafs@mellanox.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
 <161255840486.339900.5478922203128287192.stgit@djiang5-desk3.ch.intel.com>
 <20210210235924.GJ4247@nvidia.com>
 <b41828e1-ab67-856b-f2c0-6215106ba813@intel.com>
 <20210302002922.GC4247@nvidia.com>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <3dd57aa0-3f64-d8cd-8f61-d91d7b1a1bdd@intel.com>
Date:   Mon, 1 Mar 2021 17:48:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210302002922.GC4247@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/1/2021 5:29 PM, Jason Gunthorpe wrote:
> On Mon, Mar 01, 2021 at 05:23:47PM -0700, Dave Jiang wrote:
>> So after looking at the code in vfio_pci_intrs.c, I agree that the set_irqs
>> code between VFIO_PCI and this driver can be made in common. Given that Alex
>> doesn't want a vfio_pci device embedded in the driver,
> idxd isn't a vfio_pci so it would be improper to do something like
> that here anyhow.
>
>> I think we'll need some sort of generic VFIO device that can be used
>> from the vfio_pci side and vfio_mdev side to pass down in order to
>> have common support library functions.
> Why do you need more layers?
>
> Just make some helper functions to manage this and build them into
> their own struct and function family. All this needs is some callback
> to for the end driver to hook in the raw device programming and some
> entry points to direct the emulation access to the module.
>
> It should be fully self contained and completely unrelated to vfio_pci
>
Maybe I'm looking at this wrong. I see a some code in vfio_pci_intrs.c 
that we can reuse with some changes here and there. But, I think see 
where you are getting at with just common functions for mdev side. Let 
me create it just for IMS emulation and then we can go from there trying 
to figure if that's the right path to go down or if we need to share 
code with vfio_pci.
