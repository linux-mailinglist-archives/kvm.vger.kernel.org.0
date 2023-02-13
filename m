Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A436953FC
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 23:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjBMWnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 17:43:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBMWnQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 17:43:16 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350A61D920;
        Mon, 13 Feb 2023 14:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676328195; x=1707864195;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+1Sbf2PVMPRSLBzz7cIUPSlDGOlIYXOpOZ7P5hGNOWg=;
  b=maWulVR0XD3PtTK9IqwmQpMHSfwSI37aEYyubixtCHVQvK4AzhwIZud2
   4uG4HhHyym56iaFDu0cJPKQjQMDTyIMRHwkiLWvCYkn+PC+AkAru0wV6D
   pGUoWL+PkN0leJnqqS8sSsGPK7tS4e29lyWJ4N6p+9m7tQhryzdUeLLrB
   GYqmVRJQt9h34u45y7ApJENtl302U3Oz5iWdDdkX379QIZs+DMQt9YzQk
   hAUcwgiL+xBBbvzSMLrelWtjk+5wbmOywI8nG+CeFvhR3dpt+iY+8cF8/
   xpTXexqhrcLw2b2ZvbWNyYX0BkHN7jwdF3XcL6/NJMEsr731BpUEEX+Pd
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="395633987"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="395633987"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 14:43:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="671002184"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="671002184"
Received: from mlswanso-mobl.amr.corp.intel.com (HELO [10.251.26.232]) ([10.251.26.232])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 14:43:12 -0800
Message-ID: <af6034c3-98a3-239b-2c79-ff878f5d9673@intel.com>
Date:   Mon, 13 Feb 2023 14:43:12 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>
References: <cover.1676286526.git.kai.huang@intel.com>
 <557c526a1190903d11d67c4e2c76e01f67f6eb15.1676286526.git.kai.huang@intel.com>
 <86a8fe2f-566a-d0b9-7a22-9b41c91796f8@intel.com>
 <BL1PR11MB59789A024CFA9E9DE715C2F1F7DD9@BL1PR11MB5978.namprd11.prod.outlook.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <BL1PR11MB59789A024CFA9E9DE715C2F1F7DD9@BL1PR11MB5978.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/13/23 13:19, Huang, Kai wrote:
>> On 2/13/23 03:59, Kai Huang wrote:
>>> To avoid duplicated code, add a
>>> helper to call SEAMCALL on all online cpus one by one but with a skip
>>> function to check whether to skip certain cpus, and use that helper to
>>> do the per-cpu initialization.
>> ...
>>> +/*
>>> + * Call @func on all online cpus one by one but skip those cpus
>>> + * when @skip_func is valid and returns true for them.
>>> + */
>>> +static int tdx_on_each_cpu_cond(int (*func)(void *), void *func_data,
>>> +                           bool (*skip_func)(int cpu, void *),
>>> +                           void *skip_data)
>> I only see one caller of this.  Where is the duplicated code?
> The other caller is in patch 15 (x86/virt/tdx: Configure global KeyID on all packages).
> 
> I kinda mentioned this in the changelog:
> 
>         " Similar to the per-cpu module initialization, a later step to config the key for the global KeyID..."
> 
> If we don't have this helper, then we can end up with having below loop in two functions:
> 
>         for_each_online(cpu) {
>                 if (should_skip(cpu))
>                         continue;
> 
>                 // call @func on @cpu.
>         }

I don't think saving two lines of actual code is worth the opacity that
results from this abstraction.
