Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C8E68ABCE
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 19:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbjBDSTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Feb 2023 13:19:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbjBDSS6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Feb 2023 13:18:58 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1492B302A0;
        Sat,  4 Feb 2023 10:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675534737; x=1707070737;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LJ4cMeZIdCvh32LatinduqIdFOt1FGNQelyqXlGY+gw=;
  b=NRNC/1Z1tJ6CMu/0A8Lqg6VranTkxOaPNK9u6VsA4JXf3HCjtpk7IEA4
   dBjl+00NzJ5C9VO1jdnTGihz8JaTZK8zp6h7DL9UA19FlB/fvpv1LaDc7
   upiIGnyCZpRrg0UOig/opJtu1DgO8mbuLQA4PSaNLV42KObPGf974ywQe
   Jwefs14SSEB0t5elhOBkJtVB4IGjuDGYlEqrW+Y99xPg94WCsQGUON/54
   xYxRu41+jSLpyRjk7DuYc3U5rO9XTdTt5yY4ztWpmRCGI0kG/DF8lIHEk
   kc8fOOHLawy4dESY/6UQfJr3cLXbdFEXYgMyaVNeLl6SX1Wt3gEYEFmpV
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10611"; a="312629890"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="312629890"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2023 10:18:56 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10611"; a="696455105"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="696455105"
Received: from gmekkari-mobl.amr.corp.intel.com (HELO [10.209.74.85]) ([10.209.74.85])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2023 10:18:55 -0800
Message-ID: <5ba476f3-e0ac-d630-ce1d-18ab9885496f@linux.intel.com>
Date:   Sat, 4 Feb 2023 10:18:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v6 07/11] x86/smpboot: Disable parallel boot for AMD CPUs
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Usama Arif <usama.arif@bytedance.com>, tglx@linutronix.de
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, Mario Limonciello <Mario.Limonciello@amd.com>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-8-usama.arif@bytedance.com>
 <b3d9fbbf-e760-5d1d-9182-44c144abd1bf@amd.com>
 <d3ec562fd2e03c3aef9534f64915a14a8cb89ae1.camel@infradead.org>
From:   Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <d3ec562fd2e03c3aef9534f64915a14a8cb89ae1.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> 
> However...
> 
> Even though we *can* support non-X2APIC processors, we *might* want to
> play it safe and not go back that far; only enabling parallel bringup
> on machines with X2APIC which roughly correlates with "lots of CPUs"
> since that's where the benefit is.

I think that this is the right approach, at least on the initial patch series.
KISS principle; do all the easy-but-important cases first, get it stable and working
and in later series/kernels the range can be expanded.... if it matters.


> 
> 
> 

