Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24387636654
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 17:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238552AbiKWQ7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 11:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238060AbiKWQ67 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 11:58:59 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947C368C61;
        Wed, 23 Nov 2022 08:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669222738; x=1700758738;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6G5Mp68iqToBzIfY887gjlmXUVBeK2AFrXb5/cTUWOM=;
  b=GxPx15yhGJ7DjkxBslg/oBJbdRGNjMONTPKm2JELNlPOj0fG3Mp7Y0iL
   N1ctCOWHfqG3dmr3LniP1QpEt1lqk85V9qZ6m1Cpjp6Unx9YOiozXHOEI
   GeNLedfM3sbPpggSx+lOgXcrSPY7xv8eYgn3yY6apiAt0cQPTrbNh3Xla
   Xz5o782orDMFcL49LInGuKMe0ipvyoEbZnSgWeSylIFDitxQHLU846e3f
   y7z9IzS39fQAGFJwmGgGCcBox+SBPQoeqXgimH1Z0Yv3EAQoRatbVWgIb
   SXkOxu+02Cp96sPfiM5C7ShqEGqPhTaKcswu/xcKsyU2/RLr4oKcVCIZf
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="378370369"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="378370369"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 08:58:57 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="674786756"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="674786756"
Received: from vcbudden-mobl3.amr.corp.intel.com (HELO [10.212.129.67]) ([10.212.129.67])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 08:58:57 -0800
Message-ID: <e87b68ed-c51c-85aa-1cf9-7a67b8eebe00@intel.com>
Date:   Wed, 23 Nov 2022 08:58:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 04/20] x86/virt/tdx: Add skeleton to initialize TDX on
 demand
Content-Language: en-US
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
References: <cover.1668988357.git.kai.huang@intel.com>
 <d26254af8e5b3dcca8a070703c5d6d04f48d47a9.1668988357.git.kai.huang@intel.com>
 <ea588f69-3b9e-b0ec-e5e1-a174d6031681@intel.com>
 <f9bff97abe68cc09aecfd96226ba91e972e5a2e8.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <f9bff97abe68cc09aecfd96226ba91e972e5a2e8.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/23/22 02:18, Huang, Kai wrote:
>> Again, there are a lot of words in that comment, but I'm not sure why
>> it's here.  Despite all the whinging about ACPI, doesn't it boil down to:
>>
>>       The TDX module itself establishes its own concept of how many
>>       logical CPUs there are in the system when it is loaded.
>>
> This isn't accurate.  TDX MCHECK records the total number of logical CPUs when
> the BIOS enables TDX.  This happens before the TDX module is loaded.  In fact
> the TDX module only gets this information from a secret location.

Kai, this is the point where I lose patience with the conversation
around this series.  I'll you paste you the line of code where the TDX
module literally "establishes its own concept of how many logical CPUs
there are in the system":

>     //NUM_LPS
>     tdx_global_data_ptr->num_of_lps = sysinfo_table_ptr->mcheck_fields.tot_num_lps;

Yes, this is derived directly from MCHECK.  But, this concept is
separate from MCHECK.  We have seen zero actual facts from you or other
folks at Intel that this is anything other than an arbitrary choice made
for the convenience of the TDX module.  It _might_ not be this way.  I'm
open to hearing those facts and changing my position on this.

But, please bring facts, not random references to "secret locations"
that aren't that secret.
