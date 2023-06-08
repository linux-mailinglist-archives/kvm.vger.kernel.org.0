Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB127728259
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 16:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236904AbjFHOKB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 10:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236917AbjFHOJr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 10:09:47 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CAE2738;
        Thu,  8 Jun 2023 07:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686233386; x=1717769386;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Cl+Du+DP0yTdD93duOr9DtkYzxj1V9kSJNpExPyfOvc=;
  b=UEO/EN4MgYMUbtHNHP3vRpObHuv9oC5LFVn7OHizt696kLgdNE4BiJrY
   SDg7AgtvC832IPIv3A2FUZ+3ab37Puyz7R2XJliav/LVVLT36tWyzNpLs
   YLDjo1fNHeLPvkXIKUDo7xCiMENlGc2dHFFlgQ8cBZgSGNf3Fy5vYMp7P
   YCzWhmaZNL14xl2WWQC1CxUnnZ3R4PBY1MPvB2VSUdaZeXUHB8L0d74bP
   +qKUauHt+ToJ9njBiJFs0AbOzBHOWG7Kahi5W6Q8cc9xYrxuX+Lf9FUJK
   JoL35lyUcMWuxaY5fkU944cw87XFGBEv+3qs7NfEVRRzXnopyU7sc1aV5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="346944708"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="346944708"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 06:50:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="1040112788"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="1040112788"
Received: from swalker-mobl1.amr.corp.intel.com (HELO [10.209.22.184]) ([10.209.22.184])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 06:50:19 -0700
Message-ID: <44e1dca7-1071-6d1c-b6d2-c4ca139ab973@intel.com>
Date:   Thu, 8 Jun 2023 06:50:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 05/20] x86/virt/tdx: Add SEAMCALL infrastructure
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
References: <cover.1685887183.git.kai.huang@intel.com>
 <ec640452a4385d61bec97f8b761ed1ff38898504.1685887183.git.kai.huang@intel.com>
 <92e19d74-447f-19e0-d9ec-8a3f12f04927@intel.com>
 <20230607185355.GH2244082@ls.amr.corp.intel.com>
 <f7ef157e-8f26-8d7b-a9b8-cb8de7f7aa2b@intel.com>
 <20230607194721.GI2244082@ls.amr.corp.intel.com>
 <ZIDjx4i2Z/OQgUra@google.com>
 <2061ced1-59d7-f21c-490c-b650b7378386@intel.com>
 <c4695e35353513381d661c21d2ebcd786f39f327.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <c4695e35353513381d661c21d2ebcd786f39f327.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/7/23 17:51, Huang, Kai wrote:
> How about I add below to the changelog?
> 
> "
> The current TDX_MODULE_CALL macro handles neither #GP nor #UD.  The kernel would
> hit Oops if SEAMCALL were mistakenly made when TDX is enabled by the BIOS or
> when CPU isn't in VMX operation.  For the former, the callers could check
> platform_tdx_enabled() first, although that doesn't rule out the buggy BIOS in
> which case the kernel could still get Oops.  For the latter, the caller could
> check CR4.VMXE based on the fact that currently setting this bit and doing VMXON
> are done together when IRQ is disabled, although from hardware's perspective
> checking CR4.VMXE isn't enough.
> 
> However this could be problematic if SEAMCALL is called in the cases such as
> exception handler, NMI handler, etc, as disabling IRQ doesn't prevent any of
> them from happening.
> 
> To have a clean solution, just make the SEAMCALL always return error code by
> using EXTTABLE so the SEAMCALL can be safely called in any context.  A later
> patch will need to use SEAMCALL in the machine check handler.  There might be
> such use cases in the future too.
> "

No, that's just word salad.

SEAMCALL is like VMRESUME.  It's will be called by KVM in unsafe (VMX
off) contexts in normal operation like "reboot -f".  That means it needs
an exception handler for #UD(???).

I don't care if a bad BIOS can cause #GP.  Bad BIOS == oops.  You can
argue that even if I don't care, it's worth having a nice error message
and a common place for SEAMCALL error handling.  But it's not
functionally needed.
