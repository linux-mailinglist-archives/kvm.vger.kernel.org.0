Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C676630CB
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 20:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237470AbjAITwf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 14:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237418AbjAITwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 14:52:21 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E18CD50;
        Mon,  9 Jan 2023 11:52:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673293939; x=1704829939;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rblSatFgkQX+6uOg/BWjvl2hRNBzPB7DjbscdtDtOdQ=;
  b=g2StAJWisJzm3rXIN8+dE8YOWPxId/ofDw4qYRD7VDXkCITXttUNiNR2
   y0g+Nv8voIYaMtE61XAIwVXT5HgjyLJz5rzBdkksUYyLRAMzZ7+c7g9Fo
   7ejT2zzEhn3Tk+3e7keW6ARcGfnl1k29gLsEi532ztO+Ee/GkUgAmydKC
   HSRStgTY0LPa5X3iQILdUN3X5fsSDGQX9MiALYLezBEb486Z8Zj8kJGFK
   JeVfkUMz1c5Nh24yQ6l4vy/E1vZYB0+GVBCpb9hSnsiZ42135AmPCi0Fj
   EOMsak7rykW7UC5wdXift1qVIv4wmphkN5RWvatbYqr/0C2rkHCMhYA7M
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="306481855"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="306481855"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 11:52:19 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="985504267"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="985504267"
Received: from swapnadi-mobl2.amr.corp.intel.com (HELO [10.209.29.117]) ([10.209.29.117])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 11:52:17 -0800
Message-ID: <bea7dbd0-f6ec-5103-9d00-9617154d6be9@intel.com>
Date:   Mon, 9 Jan 2023 11:52:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 06/16] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
 <7c21a3de810397901bade0b1021912bbbf2d18bd.1670566861.git.kai.huang@intel.com>
 <d1093b3e-cdab-b138-d488-19b9456be978@intel.com>
 <e605ce95f1b92fae630bf6abb801774bc28d8072.camel@intel.com>
Content-Language: en-US
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <e605ce95f1b92fae630bf6abb801774bc28d8072.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/9/23 02:25, Huang, Kai wrote:
> On Fri, 2023-01-06 at 09:46 -0800, Dave Hansen wrote:
...
>>> Note not all members in the 1024 bytes TDX module information are used
>>> (even by the KVM).
>>
>> I'm not sure what this has to do with anything.
> 
> You mentioned in v7 that:
>>>> This is also a great place to mention that the tdsysinfo_struct
contains
>>> a *lot* of gunk which will not be used for a bit or that may never get
>>> used.
> 
> https://lore.kernel.org/linux-mm/cc195eb6499cf021b4ce2e937200571915bfe66f.camel@intel.com/T/#m168e619aac945fa418ccb1d6652113003243d895
> 
> Perhaps I misunderstood something but I was trying to address this.
> 
> Should I remove this sentence?

If someone goes looking at this patch, the see tdsysinfo_struct with
something like two dozen defined fields.  But, very few of them get used
in this patch.  Why?  Just saying that they are unused is a bit silly.

	The 'tdsysinfo_struct' is fairly large (1k) and contains a lot
	of info about the TD.  Fully define the entire structure, but
	only use the fields necessary to build the PAMT and TDMRs and
	pr_info() some basics about the module.

	The rest of the fields will get used... (by kvm?  never??)

...
>>> +	struct tdsysinfo_struct *sysinfo = &PADDED_STRUCT(tdsysinfo);
>>> +	int ret;
>>> +
>>> +	ret = tdx_get_sysinfo(sysinfo, cmr_array);
>>> +	if (ret)
>>> +		goto out;
>>> +
>>>  	/*
>>>  	 * TODO:
>>>  	 *
>>> -	 *  - Get TDX module information and TDX-capable memory regions.
>>>  	 *  - Build the list of TDX-usable memory regions.
>>>  	 *  - Construct a list of TDMRs to cover all TDX-usable memory
>>>  	 *    regions.
>>> @@ -166,7 +239,9 @@ static int init_tdx_module(void)
>>>  	 *
>>>  	 *  Return error before all steps are done.
>>>  	 */
>>> -	return -EINVAL;
>>> +	ret = -EINVAL;
>>> +out:
>>> +	return ret;
>>>  }
>>
>> I'm going to be lazy and not look into the future.  But, you don't need
>> the "out:" label here, yet.  It doesn'serve any purpose like this, so
>> why introduce it here?
> 
> The 'out' label is here because of below code:
> 
> 	ret = tdx_get_sysinfo(...);
> 	if (ret)
> 		goto out;
> 
> If I don't have 'out' label here in this patch, do you mean something below?
> 
> 	ret = tdx_get_sysinfo(...);
> 	if (ret)
> 		return ret;
> 
> 	/*
> 	 * TODO:
> 	 * ...
> 	 * Return error before all steps are done.
> 	 */
> 	return -EINVAL;

Yes, if you remove the 'out:' label like you've shown in your reply,
it's actually _less_ code.  The labels are really only necessary when
you have common work to "undo" something before returning from the
function.  Here, you can just return.

