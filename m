Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1010251365D
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 16:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348128AbiD1OKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 10:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348141AbiD1OJw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 10:09:52 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD2E286EF;
        Thu, 28 Apr 2022 07:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651154798; x=1682690798;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iu+rc0+JdwazCgqT5q1CfpFbh0ggfQOpl3l/mKEVveo=;
  b=VDwdo7B+Hq7QUc4GrAxdo7o2ycv4cZ/Sw4Kp5cD7nKr/lLNSjHAXjaYk
   UzjA8pkGmVdfNyJEkj10ofMI/wU+D6nuJd9Pg8Mid55PIKg9LO6dQqYc6
   8DYNSDD/fpa7N48/bV3iw7uR0ntYsxqv1LDNpiJcpQ6o4ZURm8n+I7g7z
   5RGpKuaOFF9JvdEPJlwQCA4Z6dPHaLEyC2nyrCl7oPSNOvtHR4egryeZE
   7MieoerhnnRabBIV/M+NJmZmubT/fpch0JuLn2lEEm5HiaPnLi5a/sQqZ
   HtU0eGzCwRhmhHdx3dYCY1JPHA5EL8M1HUYTepR3DXe8mPC8l2xcegODo
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="352732658"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="352732658"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 07:06:37 -0700
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="559685466"
Received: from mpoursae-mobl2.amr.corp.intel.com (HELO [10.212.0.84]) ([10.212.0.84])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 07:06:36 -0700
Message-ID: <98f81eed-e532-75bc-d2d8-4e020517b634@intel.com>
Date:   Thu, 28 Apr 2022 07:06:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 09/21] x86/virt/tdx: Get information about TDX module
 and convertible memory
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
References: <cover.1649219184.git.kai.huang@intel.com>
 <145620795852bf24ba2124a3f8234fd4aaac19d4.1649219184.git.kai.huang@intel.com>
 <f929fb7a-5bdc-2567-77aa-762a098c8513@intel.com>
 <0bab7221179229317a11311386c968bd0d40e344.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <0bab7221179229317a11311386c968bd0d40e344.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/22 17:15, Kai Huang wrote:
> On Wed, 2022-04-27 at 15:15 -0700, Dave Hansen wrote:
>> On 4/5/22 21:49, Kai Huang wrote:
>>> TDX provides increased levels of memory confidentiality and integrity.
>>> This requires special hardware support for features like memory
>>> encryption and storage of memory integrity checksums.  Not all memory
>>> satisfies these requirements.
>>>
>>> As a result, TDX introduced the concept of a "Convertible Memory Region"
>>> (CMR).  During boot, the firmware builds a list of all of the memory
>>> ranges which can provide the TDX security guarantees.  The list of these
>>> ranges, along with TDX module information, is available to the kernel by
>>> querying the TDX module via TDH.SYS.INFO SEAMCALL.
>>>
>>> Host kernel can choose whether or not to use all convertible memory
>>> regions as TDX memory.  Before TDX module is ready to create any TD
>>> guests, all TDX memory regions that host kernel intends to use must be
>>> configured to the TDX module, using specific data structures defined by
>>> TDX architecture.  Constructing those structures requires information of
>>> both TDX module and the Convertible Memory Regions.  Call TDH.SYS.INFO
>>> to get this information as preparation to construct those structures.
>>>
>>> Signed-off-by: Kai Huang <kai.huang@intel.com>
>>> ---
>>>  arch/x86/virt/vmx/tdx/tdx.c | 131 ++++++++++++++++++++++++++++++++++++
>>>  arch/x86/virt/vmx/tdx/tdx.h |  61 +++++++++++++++++
>>>  2 files changed, 192 insertions(+)
>>>
>>> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
>>> index ef2718423f0f..482e6d858181 100644
>>> --- a/arch/x86/virt/vmx/tdx/tdx.c
>>> +++ b/arch/x86/virt/vmx/tdx/tdx.c
>>> @@ -80,6 +80,11 @@ static DEFINE_MUTEX(tdx_module_lock);
>>>  
>>>  static struct p_seamldr_info p_seamldr_info;
>>>  
>>> +/* Base address of CMR array needs to be 512 bytes aligned. */
>>> +static struct cmr_info tdx_cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMENT);
>>> +static int tdx_cmr_num;
>>> +static struct tdsysinfo_struct tdx_sysinfo;
>>
>> I really dislike mixing hardware and software structures.  Please make
>> it clear which of these are fully software-defined and which are part of
>> the hardware ABI.
> 
> Both 'struct tdsysinfo_struct' and 'struct cmr_info' are hardware structures. 
> They are defined in tdx.h which has a comment saying the data structures below
> this comment is hardware structures:
> 
> 	+/*
> 	+ * TDX architectural data structures
> 	+ */
> 
> It is introduced in the P-SEAMLDR patch.
> 
> Should I explicitly add comments around the variables saying they are used by
> hardware, something like:
> 
> 	/*
> 	 * Data structures used by TDH.SYS.INFO SEAMCALL to return CMRs and
> 	 * TDX module system information.
> 	 */

I think we know they are data structures. :)

But, saying:

	/* Used in TDH.SYS.INFO SEAMCALL ABI: */

*is* actually helpful.  It (probably) tells us where in the spec we can
find the definition and tells how it gets used.  Plus, it tells us this
isn't a software data structure.

>>> +	/* Get TDX module information and CMRs */
>>> +	ret = tdx_get_sysinfo();
>>> +	if (ret)
>>> +		goto out;
>>
>> Couldn't we get rid of that comment if you did something like:
>>
>> 	ret = tdx_get_sysinfo(&tdx_cmr_array, &tdx_sysinfo);
> 
> Yes will do.
> 
>> and preferably make the variables function-local.
> 
> 'tdx_sysinfo' will be used by KVM too.

In other words, it's not a part of this series so I can't review whether
this statement is correct or whether there's a better way to hand this
information over to KVM.

This (minor) nugget influencing the design also isn't even commented or
addressed in the changelog.
