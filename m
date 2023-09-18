Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75B07A4DAB
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 17:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjIRP5M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 11:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjIRP5H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 11:57:07 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297761729;
        Mon, 18 Sep 2023 08:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695052537; x=1726588537;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kJ0CYEQlLTz2M55BKeG/DtPrqJTf7eCb6Wpd+3qKrgE=;
  b=JFcATaBdF64Sa7Zv48SKRKN5QhcCsdg/uiwUC3BO3gKrJCMbvqYkdQPH
   HjeUl7yDxKihtWQ0lkav+2Yx3c/TKCPdjPii1sDFrL8wnAYOXwIQXHgpb
   iOwbfjzg3LtueYinHKrCsieAZOXcNN5z0980fPlrglCuAftWRwMEkI9t0
   FJ5mMEKuotOeRgcvddfeZ/lISbmBZv84+rCpEEECUBT3HMO4lX/Nobgbs
   cXzMWOe7I6WGUhawonrKbMWmgdN0rLLNPqIeY/17Os+SZIMjtDkEi3oA7
   LZ3EiLk99l1PLATJshTwU/zreA+6l8VRiL/O/t4c4rnHJR8woP56KlXJ4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10837"; a="446158379"
X-IronPort-AV: E=Sophos;i="6.02,156,1688454000"; 
   d="scan'208";a="446158379"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2023 08:44:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10837"; a="836076981"
X-IronPort-AV: E=Sophos;i="6.02,156,1688454000"; 
   d="scan'208";a="836076981"
Received: from ecochran-mobl1.amr.corp.intel.com (HELO [10.212.244.237]) ([10.212.244.237])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2023 08:44:52 -0700
Message-ID: <ad1a55eb-0476-401a-9839-eae51e1fd426@intel.com>
Date:   Mon, 18 Sep 2023 08:44:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v13 17/22] x86/kexec: Flush cache of TDX private memory
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
References: <cover.1692962263.git.kai.huang@intel.com>
 <1fa1eb80238dc19b4c732706b40604169316eb34.1692962263.git.kai.huang@intel.com>
 <fb70d8c29ebc91dc63e524a5d5cdf1f64cdbec73.camel@intel.com>
 <52e9ae7e-2e08-5341-99f7-b68eb62974df@intel.com>
 <b6b5f6f06ccdbbef900cfe7db87f490aac3e77a4.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <b6b5f6f06ccdbbef900cfe7db87f490aac3e77a4.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/18/23 05:08, Huang, Kai wrote:
> On Fri, 2023-09-15 at 10:50 -0700, Dave Hansen wrote:
>> On 9/15/23 10:43, Edgecombe, Rick P wrote:
>>> On Sat, 2023-08-26 at 00:14 +1200, Kai Huang wrote:
>>>> There are two problems in terms of using kexec() to boot to a new
>>>> kernel when the old kernel has enabled TDX: 1) Part of the memory
>>>> pages are still TDX private pages; 2) There might be dirty
>>>> cachelines associated with TDX private pages.
>>> Does TDX support hibernate?
>> No.
>>
>> There's a whole bunch of volatile state that's generated inside the CPU
>> and never leaves the CPU, like the ephemeral key that protects TDX
>> module memory.
>>
>> SGX, for instance, never even supported suspend, IIRC.  Enclaves just
>> die and have to be rebuilt.
> 
> Right.  AFAICT TDX cannot survive from S3 either.  All TDX keys get lost when
> system enters S3.  However I don't think TDX can be rebuilt after resume like
> SGX.  Let me confirm with TDX guys on this.

By "rebuilt" I mean all private data is totally destroyed and rebuilt
from scratch.  The SGX architecture provides zero help other than
delivering a fault and saying: "whoops all your data is gone".

> I think we can register syscore_ops->suspend for TDX, and refuse to suspend when
> TDX is enabled.  This covers hibernate case too.
> 
> In terms of how to check "TDX is enabled", ideally it's better to check whether
> TDX module is actually initialized, but the worst case is we can use
> platform_tdx_enabled(). (I need to think more on this)

*Ideally* the firmware would have a choke point where it could just tell
the OS that it can't suspend rather than the OS having to figure it out.
