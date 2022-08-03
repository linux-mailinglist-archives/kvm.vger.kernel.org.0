Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51687588E6A
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 16:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236093AbiHCOUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 10:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiHCOUy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 10:20:54 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E0D1581B;
        Wed,  3 Aug 2022 07:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659536453; x=1691072453;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qvzA0DLXBqyk6MhWAQKb2NBSKTCR9jls3SHT+NRtjyE=;
  b=gK+RlPwvZQgZuIiMOpqtW/4v7UZdZm1tGWdR6emM2hJ+RiOcl3DPJtYm
   J/6vobPyI00nPkpCIGFB7aIOpqjf/XxYY5OGLZCzYO/Og5/seWb3+IWgC
   DZbvNnvOz3BaMJO/DyW+GzVLPWL6WLomXjy/ROQhMaXI8eR3lN6zGCAdq
   T/2KSzqnwwC2sRh1KLmGRTFpslX8NEQxs1KiexmWS+Tf8iin9VmOSxRlI
   dgXmig4g0hBahrkxNekE0i61BT/MRu+skFbX+nELmgyEBBiK5/fK62J0z
   2LSBfDR0hPymaYQmLiDddZDLL25nlqY/pmZ/xtoVfRQCgLiNKNoKQx4xs
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10428"; a="272729909"
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="272729909"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 07:20:52 -0700
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="631165944"
Received: from buichris-mobl.amr.corp.intel.com (HELO [10.209.124.150]) ([10.209.124.150])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 07:20:52 -0700
Message-ID: <54cf3e98-49d3-81f5-58e6-ca62671ab457@intel.com>
Date:   Wed, 3 Aug 2022 07:20:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v5 07/22] x86/virt/tdx: Implement SEAMCALL function
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
References: <cover.1655894131.git.kai.huang@intel.com>
 <095e6bbc57b4470e1e9a9104059a5238c9775f00.1655894131.git.kai.huang@intel.com>
 <069a062e-a4a6-09af-7b74-7f4929f2ec0b@intel.com>
 <5ce7ebfe54160ea35e432bf50207ebed32db31fc.camel@intel.com>
 <84e93539-a2f9-f68e-416a-ea3d8fc725af@intel.com>
 <6bef368ccc68676e4acaecc4b6dc52f598ea7f2f.camel@intel.com>
 <ea03e55499f556388c0a5f9ed565e72e213c276f.camel@intel.com>
 <978c3d37-97c9-79b9-426a-2c27db34c38a@intel.com>
 <0b20f1878d31658a9e3cd3edaf3826fe8731346e.camel@intel.com>
 <c96a78c6a8caf25b01e450f139c934688d1735b0.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <c96a78c6a8caf25b01e450f139c934688d1735b0.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/2/22 19:37, Kai Huang wrote:
> On Thu, 2022-07-21 at 13:52 +1200, Kai Huang wrote:
>> Also, if I understand correctly above, your suggestion is we want to prevent any
>> CMR memory going offline so it won't be hot-removed (assuming we can get CMRs
>> during boot).  This looks contradicts to the requirement of being able to allow
>> moving memory from core-mm to driver.  When we offline the memory, we cannot
>> know whether the memory will be used by driver, or later hot-removed.
> Hi Dave,
> 
> The high level flow of device hot-removal is:
> 
> acpi_scan_hot_remove()
> 	-> acpi_scan_try_to_offline()
> 		-> acpi_bus_offline()
> 			-> device_offline()
> 				-> memory_subsys_offline()
> 	-> acpi_bus_trim()
> 		-> acpi_memory_device_remove()
> 
> 
> And memory_subsys_offline() can also be triggered via /sysfs:
> 
> 	echo 0 > /sys/devices/system/memory/memory30/online
> 
> After the memory block is offline, my understanding is kernel can theoretically
> move it to, i.e. ZONE_DEVICE via memremap_pages().
> 
> As you can see memory_subsys_offline() is the entry point of memory device
> offline (before it the code is generic for all ACPI device), and it cannot
> distinguish whether the removal is from ACPI event, or from /sysfs, so it seems
> we are unable to refuse to offline memory in  memory_subsys_offline() when it is
> called from ACPI event.
> 
> Any comments?

I suggest refactoring the code in a way that makes it possible to
distinguish the two cases.

It's not like you have some binary kernel.  You have the source code for
the whole thing and can propose changes *ANYWHERE* you need.  Even better:

$ grep -A2 ^ACPI\$ MAINTAINERS
ACPI
M:	"Rafael J. Wysocki" <rafael@kernel.org>
R:	Len Brown <lenb@kernel.org>

The maintainer of ACPI works for our employer.  Plus, he's a nice
helpful guy that you can go ask how you might refactor this or
approaches you might take.  Have you talked to Rafael about this issue?

Also, from a two-minute grepping session, I noticed this:

> static acpi_status acpi_bus_offline(acpi_handle handle, u32 lvl, void *data,
>                                     void **ret_p)
> {
...
>         if (device->handler && !device->handler->hotplug.enabled) {
>                 *ret_p = &device->dev;
>                 return AE_SUPPORT;
>         }

It looks to me like if you simply set:

	memory_device_handler->hotplug.enabled = false;

you'll get most of the behavior you want.  ACPI memory hotplug would not
work and the changes would be confined to the ACPI world.  The
"lower-level" bus-based hotplug would be unaffected.

Now, I don't know what kind of locking would be needed to muck with a
global structure like that.  But, it's a start.
