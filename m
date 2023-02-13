Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C44F6953DD
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 23:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjBMW2t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 17:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjBMW2r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 17:28:47 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3ED01CF56;
        Mon, 13 Feb 2023 14:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676327326; x=1707863326;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=314vpw90/2DwHi9JOkrC++51z0wYP6vtdKNmpuIX6Gc=;
  b=kjMnN3OFudXhRQ3rX7o+dcIcXgPzUdJMTuKwPgCohU2HC++l+5eMJmJi
   LJljc3gfxLYe7xA5iyz7tIzjo/JTvJJNykWyCWmNtNk1OQ45ym0j/7Czx
   NPF75T9+ZsXTU6MfQ1w9vC6D8vvikT4oS8yuLEeytd4Y0FecvB+ohHJ3I
   x5MyrwN+/oc12ExwzB4P9I1MsNflqLlP+D+uYeUNNgVuGSyxV/zb625qm
   lc5+IBzM37hrQowNZmVtCzlV6ZdMrjeboCuhWrPH9q4iPFZZpHMh89h8n
   PrYv/77mwpacNFwC8JcmMCspn56abr4CUY0n4oR2LznQ3VBS0nL34EfF+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="358421214"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="358421214"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 14:28:46 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="737674268"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="737674268"
Received: from mlswanso-mobl.amr.corp.intel.com (HELO [10.251.26.232]) ([10.251.26.232])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 14:28:44 -0800
Message-ID: <2d7141b1-1d76-4e67-60d2-471a524c372e@intel.com>
Date:   Mon, 13 Feb 2023 14:28:43 -0800
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
 <2d9172c5-e1e7-bf94-c52b-0e9bc5b5b319@intel.com>
 <BL1PR11MB5978F562548EA22BFFD13970F7DD9@BL1PR11MB5978.namprd11.prod.outlook.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <BL1PR11MB5978F562548EA22BFFD13970F7DD9@BL1PR11MB5978.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/13/23 13:13, Huang, Kai wrote:
> Perhaps I didn't explain clearly in the comment.  Below is the updated one:
> 
>                 /*
>                  * The previous call of __tdx_enable() may only have
>                  * initialized part of present cpus during module
>                  * initialization, and new cpus may have become online
>                  * since then w/o doing per-cpu initialization.
>                  *
>                  * For example, a new CPU can become online when KVM is
>                  * unloaded, in which case tdx_cpu_enable() is not called since
>                  * KVM's CPU online callback has been removed.
>                  *
>                  * To make sure all online cpus are TDX-runnable, always
>                  * do per-cpu initialization for all online cpus here
>                  * even the module has been initialized.
>                  */

This is voodoo.

I want a TDX-specific hotplug CPU handler.  Period.  Please make that
happen.  Put that code in this patch.  That handler should:

	1. Run after the KVM handler (if present)
	2. See if VMX is on
	3. If VMX is on:
	 3a. Run smp_func_module_lp_init(), else
	 3b. Mark the CPU as needing smp_func_module_lp_init()

Then, in the 'case TDX_MODULE_INITIALIZED:', you call a function to
iterate over the cpumask that was generated in 3b.

That makes the handoff *EXPLICIT*.  You know exactly which CPUs need
what done to them.  A CPU hotplug either explicitly involves doing the
work to make TDX work on the CPU, or explicitly defers the work to a
specific later time in a specific later piece of code.
