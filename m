Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B956E1C20A2
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 00:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgEAWbQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 18:31:16 -0400
Received: from mga05.intel.com ([192.55.52.43]:7820 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgEAWbP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 May 2020 18:31:15 -0400
IronPort-SDR: 7VW1FGZhBElBZsA932mO7UrFHDkm24NGqJPtJFN61FHF1gzmcWkzYyTnoekJuc8c4rUlLi2M2u
 KW1OSCHkMP9Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 15:31:15 -0700
IronPort-SDR: Eaq5lnlgfSmBZO76/H/R8N96/MVxzX7b9QbV4njbjrtVZxxa4PlA8ycND7dnjtPhuK4sq/FZum
 86Q0MhPfLEAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,341,1583222400"; 
   d="scan'208";a="248656973"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.251.135.85]) ([10.251.135.85])
  by fmsmga007.fm.intel.com with ESMTP; 01 May 2020 15:31:14 -0700
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
To:     Jason Gunthorpe <jgg@mellanox.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc:     Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vkoul@kernel.org>,
        maz@kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>, Yi L Liu <yi.l.liu@intel.com>,
        Baolu Lu <baolu.lu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Sanjay K Kumar <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>, Jing Lin <jing.lin@intel.com>,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dmaengine@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, linux-pci@vger.kernel.org,
        KVM list <kvm@vger.kernel.org>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <20200421235442.GO11945@mellanox.com>
 <CAPcyv4gMYz1wCYjfnujyGXP0jGehpb+dEYV7hJoAAsDsj9+afQ@mail.gmail.com>
 <CAPcyv4hGX5jCzag8oQVUZ6Eq9GvZYLN_6kmBAgQMbrBbNzJ0yg@mail.gmail.com>
 <20200423194941.GG13640@mellanox.com>
From:   "Dey, Megha" <megha.dey@linux.intel.com>
Message-ID: <c50c2eda-88aa-00bc-7cd6-37cc26052cd5@linux.intel.com>
Date:   Fri, 1 May 2020 15:31:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423194941.GG13640@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 4/23/2020 12:49 PM, Jason Gunthorpe wrote:
> On Thu, Apr 23, 2020 at 12:17:50PM -0700, Dan Williams wrote:
> 
>> Per Megha's follow-up can you send the details about that other device
>> and help clear a path for a device-specific MSI addr/data table
>> format. Ever since HMM I've been sensitive, perhaps overly-sensitive,
>> to claims about future upstream users. The fact that you have an
>> additional use case is golden for pushing this into a common area and
>> validating the scope of the proposed API.
> 
> I think I said it at plumbers, but yes, we are interested in this, and
> would like dynamic MSI-like interrupts available to the driver (what
> Intel calls IMS)
> 

So basically you are looking for a way to dynamically allocate the 
platform-msi interrupts, correct?

Since I don't have access to any of the platform-msi devices, it is hard 
for me to test this code for other drivers expect idxd for now.
Once I submit the next round of patches, after addressing all the 
comments, would it be possible for you to test this code for any of your 
devices?

> It is something easy enough to illustrate with any RDMA device really,
> just open a MR against the addr and use RDMA_WRITE to trigger the
> data. It should trigger a Linux IRQ. Nothing else should be needed.
> 
> Jason
> 
