Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151CD741CEC
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 02:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjF2AcP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 20:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjF2AcO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 20:32:14 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884161BFE;
        Wed, 28 Jun 2023 17:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687998733; x=1719534733;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sqRArJ9svcYk8Srvkb99FaaP4ltBUPw0xtk0ZlIVfjk=;
  b=QV/GX4LHVL7oonoqRN5/fZJrvDXcnSlIE1vr3SJpN+wVcqi7tV2+a/26
   9ib7h0OXwHGOrou380D4jA2cg1s2crAqxq3AwkK+hMO0PVEjcceHEyok0
   +RJv/OmMyOElyAXAI83327/iWEqo6xclkOOX0yA5G13vVZdzo9jTIY/W1
   4nBae17Q12w5FWDZUsALojGPAIowo6SseuQpY1jNFlQn4V0aqweEyHnxp
   yvPH62lrYVihlCQYeT16cBkXKrtxmPFG9BS4Rl+kD//8DNT8s0msJ8zAm
   CQL8SsEKbXuGyC3apiryjixqjSbe2KeYje7MLSgDGDDRPIjkNFqQfCW4c
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="365455150"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="365455150"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 17:32:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="891226114"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="891226114"
Received: from adamha2x-mobl.amr.corp.intel.com (HELO [10.209.108.95]) ([10.209.108.95])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 17:32:12 -0700
Message-ID: <dc30a8c6-c313-9d85-c41e-07171dfdf056@intel.com>
Date:   Wed, 28 Jun 2023 17:32:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v12 19/22] x86/kexec(): Reset TDX private memory on
 platforms with TDX erratum
Content-Language: en-US
To:     Nikolay Borisov <nik.borisov@suse.com>,
        Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, x86@kernel.org,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1687784645.git.kai.huang@intel.com>
 <28aece770321e307d58df77eddee2d3fa851d15a.1687784645.git.kai.huang@intel.com>
 <1662a5ef-c333-d6d6-7605-060f4bcca6fd@suse.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <1662a5ef-c333-d6d6-7605-060f4bcca6fd@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/28/23 02:20, Nikolay Borisov wrote:
>>
>>   +    /*
>> +     * Starting from this point the system may have TDX private
>> +     * memory.  Make it globally visible so tdx_reset_memory() only
>> +     * reads TDMRs/PAMTs when they are stable.
>> +     *
>> +     * Note using atomic_inc_return() to provide the explicit memory
>> +     * ordering isn't mandatory here as the WBINVD above already
>> +     * does that.  Compiler barrier isn't needed here either.
>> +     */
> 
> If it's not needed, then why use it? Simply do atomic_inc() and instead
> rephrase the comment to state what are the ordering guarantees and how
> they are achieved (i.e by using wbinvd above).

Even better, explain why the barrier needs to be there and *IGNORE* the
WBVIND.

If the WBINVD gets moved -- or if the gods ever bless us with a halfway
reasonable way to flush the caches that's not full serializing -- this
code is screwed.

There is _zero_ reason to try and "optimize" this junk by trying to get
rid of a memory barrier at the risk of screwing it over later.

I use "optimize" in quotes because that's a highly charitable way of
describing this activity.


