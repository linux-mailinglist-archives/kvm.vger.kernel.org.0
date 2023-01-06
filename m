Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0362F660562
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 18:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbjAFROq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 12:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjAFROo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 12:14:44 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE9934D71;
        Fri,  6 Jan 2023 09:14:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673025283; x=1704561283;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4O8Pfzee9suId3D3oEwPVIn6YNM/oTj5BaqLDLcPnvY=;
  b=QOMw9SCxFljrIqDZ/Pygo1Euf7tmE+FH13Ftceit1BbeVmQ2ioVU54pS
   eWaH4B9pvZCzOAcvrDxWmd3SXfH8fZOHviOl1hmNU6LOpPI3VnJA9ApUo
   bkah1gD7u2/wpSNMh6eEoNLLpKeL9/Vp3t7izBZwbOu5VEkpSYV+AJejb
   pZ2Fv7jRSptzCUqDvbG4vq44L03Xsw2LYxed9bmrXN0BSyXBQrTnFj70Z
   ThhspGgHskcrCq6nRyfZoBhvq6kgrH4ma1xWckSdqRjNms80Lcs3dFL76
   8FIr47caY7BHWAY5TktOkb/5kiasDdQoougt+ksnMeCHzzaUerpcYl71v
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="322590300"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="322590300"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 09:14:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="719252663"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="719252663"
Received: from xiangyuy-mobl.amr.corp.intel.com (HELO [10.212.251.186]) ([10.212.251.186])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 09:14:41 -0800
Message-ID: <b6e72ab7-eb48-22bb-f7f7-6869408d1dda@intel.com>
Date:   Fri, 6 Jan 2023 09:14:41 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 04/16] x86/virt/tdx: Add skeleton to initialize TDX on
 demand
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1670566861.git.kai.huang@intel.com>
 <5ea3f199c0d6f9f3e1738fa5c211c52d4d618e84.1670566861.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <5ea3f199c0d6f9f3e1738fa5c211c52d4d618e84.1670566861.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/22 22:52, Kai Huang wrote:
> 
> The TDX module will be initialized in multi-steps defined by the TDX
> module and most of those steps involve a specific SEAMCALL:
> 
>  1) Get the TDX module information and TDX-capable memory regions
>     (TDH.SYS.INFO).
>  2) Build the list of TDX-usable memory regions.
>  3) Construct a list of "TD Memory Regions" (TDMRs) to cover all
>     TDX-usable memory regions.
>  4) Pick up one TDX private KeyID as the global KeyID.
>  5) Configure the TDMRs and the global KeyID to the TDX module
>     (TDH.SYS.CONFIG).
>  6) Configure the global KeyID on all packages (TDH.SYS.KEY.CONFIG).
>  7) Initialize all TDMRs (TDH.SYS.TDMR.INIT).

I don't think you really need this *AND* the "TODO" comments in
init_tdx_module().  Just say:

	Add a placeholder tdx_enable() to initialize the TDX module on
	demand.  The TODO list will be pared down as functionality is
	added.
