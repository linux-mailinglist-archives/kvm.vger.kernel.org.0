Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB7E748671
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 16:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbjGEOfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 10:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbjGEOfX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 10:35:23 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A074712A;
        Wed,  5 Jul 2023 07:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688567722; x=1720103722;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WQapOgHKiFYlx2YNIHI1rc9qJxC2isYNrPhJNnI3h7Y=;
  b=HS9Q9q3+4Gv4VVR+IuriLTVR0Il6r4qzpvboPHY/+kA6EC/Sm7jW3a/w
   3cyOLVLsRE6qhwb0QiytHoX94AlEaGRnjF4UEShupvX32fu/vl4DqOGzF
   gs9rbz3Vo6n+slJKiZsAPE1uZbxfk1AheIoauzztTfiWG1Czv7HYLIGs2
   +Xu3HuNPJrbgRSOSWrAgnR+3rtn5ryJfNQousd3OpIulfKvx/ot+JEDdM
   By0SrSPbkKCBTbF9OXpowqYUHOXXCiOiq3QO15c096mJ7zRZ+wcWTZfwD
   yots5AKWIYPtIA2MqHaSHxm+ygndUGZkVaR1HvVLUZQ2czsquwnVYtzQD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="427040562"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="427040562"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 07:34:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="713217660"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="713217660"
Received: from subrator-mobl1.amr.corp.intel.com (HELO [10.209.29.125]) ([10.209.29.125])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 07:34:06 -0700
Message-ID: <1a8099e2-da28-6b2a-7b5a-1d6346b7f95d@intel.com>
Date:   Wed, 5 Jul 2023 07:34:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, Sagi Shahar <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, Chao Gao <chao.gao@intel.com>,
        Len Brown <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Ying Huang <ying.huang@intel.com>,
        Dan J Williams <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
References: <cover.1687784645.git.kai.huang@intel.com>
 <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
 <20230628131717.GE2438817@hirez.programming.kicks-ass.net>
 <0c9639db604a0670eeae5343d456e43d06b35d39.camel@intel.com>
 <20230630092615.GD2533791@hirez.programming.kicks-ass.net>
 <2659d6eef84f008635ba300f4712501ac88cef2c.camel@intel.com>
 <20230630183020.GA4253@hirez.programming.kicks-ass.net>
 <20230630190514.GH3436214@ls.amr.corp.intel.com>
 <ZJ9IKALhz1Q6ogu1@google.com>
 <20230704165836.GB462772@hirez.programming.kicks-ass.net>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230704165836.GB462772@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/4/23 09:58, Peter Zijlstra wrote:
> If we have concerns about allocating the PAMT array, can't we use CMA
> for this? Allocate the whole thing at boot as CMA such that when not
> used for TDX it can be used for regular things like userspace and
> filecache pages?

I never thought of CMA as being super reliable.  Maybe it's improved
over the years.

KVM also has a rather nasty habit of pinning pages, like for device
passthrough.  I suspect that means that we'll have one of two scenarios:

 1. CMA works great, but the TDX/CMA area is unusable for KVM because
    it's pinning all its pages and they just get moved out of the CMA
    area immediately.  The CMA area is effectively wasted.
 2. CMA sucks, and users get sporadic TDX failures when they wait a long
    time to run a TDX guest after boot.  Users just work around the CMA
    support by starting up TDX guests at boot or demanding a module
    parameter be set.  Hacking in CMA support was a waste.

Am I just too much of a pessimist?
