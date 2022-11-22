Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C7463404F
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 16:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbiKVPgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 10:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232849AbiKVPfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 10:35:52 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BF3716D8;
        Tue, 22 Nov 2022 07:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669131337; x=1700667337;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2tW2G1a+1TR8Etq8K8ec13/rDo30wsBLYx7iORND+kY=;
  b=DiDdvOVivO+wOoiOJDU5c1Maa7/lzAJNMaDhRH/aDflTV//NYyx51e5F
   FOQX6oBnZW0Jj814nMl8sAz94v4uwNsipO9cS0lBDDrnBHnUS2IBGbDkn
   gNbZAqwLUxqEcY1bM8ZtGejGG8EUXfs/Z0iUqQ2KxsyDqvzOusIIQARWK
   sIjOIAatk/OvkaekOgjb+cSjuhuc6OMBNtqy2v8b55QG0UTr75Kl9g8xF
   PZgngfTH5rLSWL+RtIhhb48VPVBpeJ7Lp7Xp5r/U/q5x04My/qnKpdJAT
   23gOAOZ4zPPyJ3KNVgQWi5KBreF1/IKg/V2V2aKOqZS8wRZw041W0AlXW
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="314991383"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="314991383"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 07:35:36 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="592179088"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="592179088"
Received: from lcano-mobl1.amr.corp.intel.com (HELO [10.255.231.75]) ([10.255.231.75])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 07:35:34 -0800
Message-ID: <19d93ff0-df0d-dc9d-654b-a9ca6f7be1d0@intel.com>
Date:   Tue, 22 Nov 2022 07:35:33 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 04/20] x86/virt/tdx: Add skeleton to initialize TDX on
 demand
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1668988357.git.kai.huang@intel.com>
 <d26254af8e5b3dcca8a070703c5d6d04f48d47a9.1668988357.git.kai.huang@intel.com>
 <Y3yQKDZFC8+oCyqK@hirez.programming.kicks-ass.net> <87edtvgu1l.ffs@tglx>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <87edtvgu1l.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/22/22 02:31, Thomas Gleixner wrote:
> Nothing in the TDX specs and docs mentions physical hotplug or a
> requirement for invoking seamcall on the world.

The TDX module source is actually out there[1] for us to look at.  It's
in a lovely, convenient zip file, but you can read it if sufficiently
motivated.

It has this lovely nugget in it:

WARNING!!! Proprietary License!!  Avert your virgin eyes!!!

>     if (tdx_global_data_ptr->num_of_init_lps < tdx_global_data_ptr->num_of_lps)
>     {
>         TDX_ERROR("Num of initialized lps %d is smaller than total num of lps %d\n",
>                     tdx_global_data_ptr->num_of_init_lps, tdx_global_data_ptr->num_of_lps);
>         retval = TDX_SYS_CONFIG_NOT_PENDING;
>         goto EXIT;
>     }

tdx_global_data_ptr->num_of_init_lps is incremented at TDH.SYS.INIT
time.  That if() is called at TDH.SYS.CONFIG time to help bring the
module up.

So, I think you're right.  I don't see the docs that actually *explain*
this "you must seamcall all the things" requirement.

1.
https://www.intel.com/content/www/us/en/developer/articles/technical/intel-trust-domain-extensions.html


