Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFCA61C300E
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 00:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbgECWbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 18:31:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:61886 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729169AbgECWbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 May 2020 18:31:42 -0400
IronPort-SDR: 8/1HmE194oi1zbLO2/rnejHU9jNkE/TiGvcP12FBxYI3lnxBUWyjjIeiKbIHpl/EM7nbGaQmuh
 zYObXsC7cQbQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2020 15:31:41 -0700
IronPort-SDR: h1eN8y0q5xST4ryb5Z9cLrDQYQDKF00Uur5d6UK17cDirReH/CrUHK35IPsPQFDpDjJOFRcr+i
 dnvu2eumqODw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,349,1583222400"; 
   d="scan'208";a="406300076"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.212.197.87]) ([10.212.197.87])
  by orsmga004.jf.intel.com with ESMTP; 03 May 2020 15:31:39 -0700
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, maz@kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>, Yi L Liu <yi.l.liu@intel.com>,
        baolu.lu@intel.com, "Tian, Kevin" <kevin.tian@intel.com>,
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
 <20200423191846.GE13640@mellanox.com>
 <098aef60-35a4-dc44-be07-ea43c1a726c7@linux.intel.com>
 <20200503222229.GE19158@mellanox.com>
From:   "Dey, Megha" <megha.dey@linux.intel.com>
Message-ID: <5bc05b74-536f-f72d-c406-18644436f11b@linux.intel.com>
Date:   Sun, 3 May 2020 15:31:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200503222229.GE19158@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Jason,

On 5/3/2020 3:22 PM, Jason Gunthorpe wrote:
> On Fri, May 01, 2020 at 03:31:51PM -0700, Dey, Megha wrote:
>>>> This has been my concern reviewing the implementation. IMS needs more
>>>> than one in-tree user to validate degrees of freedom in the api. I had
>>>> been missing a second "in-tree user" to validate the scope of the
>>>> flexibility that was needed.
>>>
>>> IMS is too narrowly specified.
>>>
>>> All platforms that support MSI today can support IMS. It is simply a
>>> way for the platform to give the driver an addr/data pair that triggers
>>> an interrupt when a posted write is performed to that pair.
>>>
>>
>> Well, yes and no. IMS requires interrupt remapping in addition to the
>> dynamic nature of IRQ allocation.
> 
> You've mentioned remapping a few times, but I really can't understand
> why it has anything to do with platform_msi or IMS..

So after some internal discussions, we have concluded that IMS has no 
linkage with Interrupt remapping, IR is just a platform concept. IMS is 
just a name Intel came up with, all it really means is device managed 
addr/data writes to generate interrupts. Technically we can call 
something IMS even if device has its own location to store interrupts in 
non-pci standard mechanism, much like platform-msi indeed. We simply 
need to extend platform-msi to its address some of its shortcomings: 
increase number of interrupts to > 2048, enable dynamic allocation of 
interrupts, add mask/unmask callbacks in addition to write_msg etc.
FWIW, even MSI can be IMS with rules on how to manage the addr/data 
writes following pci sig .. its just that.

I will be sending out an email shortly outlining the new design for IMS 
(A.K.A platform-msi part 2) and what are the improvements we want to add 
to the already existing platform-msi infrastructure.

Thank you so much for your comments, it helped us iron out some of these 
details :)

> 
> Jason
> 
