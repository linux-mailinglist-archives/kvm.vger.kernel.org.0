Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACBEE513F3D
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 01:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353398AbiD1X5D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 19:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiD1X47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 19:56:59 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF901B3C78;
        Thu, 28 Apr 2022 16:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651190023; x=1682726023;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=c+sAzt2o0UKRKpXJlOxWmvT2lgcpIolw3UTKXSk1UVQ=;
  b=NSWzvN2Y/6yC4QryqaYDKnVwq/7CsCd2C/5VSNsCCXcXqf2A4Qca/2Gx
   6eMzhI1C7dSAwvrxOTqy38urMIxcmMBmExC68CwlYJ10vOGOefVYV8JKp
   gYLc/j2ItPwjY49+cYHDlcCI715twBVmjt1LH4sizxII0AUF0q7aUHUDT
   qBCTbxNYRFvTE+TVIdx55rRrnJNywYgMTOX98WxRSTDNbjTlmc+2uvZxm
   cW2KcWtbBflf+SPqJ8vGlCytkdIiFBHct0CeVHc5fOhbOQyBKm1MOY9Wt
   KvG34HaPqvYRj1E+/C+LCJVeqjkRLm8PdaLs9whwGF3/TV+AEjrGli7WO
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="265991706"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="265991706"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 16:53:43 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="565862963"
Received: from mpoursae-mobl2.amr.corp.intel.com (HELO [10.212.0.84]) ([10.212.0.84])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 16:53:42 -0700
Message-ID: <0aa81fd0-a491-847d-9fc6-4b853f2cf7b4@intel.com>
Date:   Thu, 28 Apr 2022 16:53:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 04/21] x86/virt/tdx: Add skeleton for detecting and
 initializing TDX on demand
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
 <32dcf4c7acc95244a391458d79cd6907125c5c29.1649219184.git.kai.huang@intel.com>
 <ac482f2b-d2d1-0643-faa4-1b36340268c5@intel.com>
 <22e3adf42b8ea2cae3aabc26f762acb983133fea.camel@intel.com>
 <c833aff2-b459-a1d7-431f-bce5c5f29182@intel.com>
 <37efe2074eba47c51bf5c1a2369a05ddf9082885.camel@intel.com>
 <3731a852-71b8-b081-2426-3b0a650e174c@intel.com>
 <edcae7ab1e6a074255a6624e8e0536bd77f84eed.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <edcae7ab1e6a074255a6624e8e0536bd77f84eed.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/28/22 16:44, Kai Huang wrote:
>> Just like the SME test, it doesn't even need to be precise.  It just
>> needs to be 100% accurate in that it is *ALWAYS* set for any system that
>> might have dirtied cache aliases.
>>
>> I'm not sure why you are so fixated on SEAMRR specifically for this.
> I see.  I think I can simply use MTRR.SEAMRR bit check.  If CPU supports SEAMRR,
> then basically it supports MKTME.
> 
> Is this look good for you?

Sure, fine, as long as it comes with a coherent description that
explains why the check is good enough.

>>> "During initializing the TDX module, one step requires some SEAMCALL must be
>>> done on all logical cpus enabled by BIOS, otherwise a later step will fail. 
>>> Disable CPU hotplug during the initialization process to prevent any CPU going
>>> offline during initializing the TDX module.  Note it is caller's responsibility
>>> to guarantee all BIOS-enabled CPUs are in cpu_present_mask and all present CPUs
>>> are online."
>> But, what if a CPU went offline just before this lock was taken?  What
>> if the caller make sure all present CPUs are online, makes the call,
>> then a CPU is taken offline.  The lock wouldn't do any good.
>>
>> What purpose does the lock serve?
> I thought cpus_read_lock() can prevent any CPU from going offline, no?

It doesn't prevent squat before the lock is taken, though.
