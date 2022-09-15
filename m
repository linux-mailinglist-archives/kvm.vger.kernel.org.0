Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7005B9C63
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 15:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiIONzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 09:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiIONy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 09:54:58 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D8DB7C7;
        Thu, 15 Sep 2022 06:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663250097; x=1694786097;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=kSLBIJMFHgAMOK1rpfvr5xW32NUCiVRz+7cGdfCp+vQ=;
  b=n7jrXBCy/JBo2T3D+7g41rPVXH37BAdlUKrcBBPJjnadg2ihKcPq/rKP
   WbWheXc5PUs6zotBJKzTAM5mJDmGuGfxHTGrpr58hfvQMXUnDnH5jL3Cl
   VinZZ27hr3rOUbPitQsnqrs+gLGtF92puKZTF4Z4oHOHXFglD+E83z7+M
   Uh4izpZZdNBjZq9sYOlexwwa4iUUwUe9SR28N8XeWSaQMb5HxDqNKFDO/
   sP+gdCU2HOza65xcnen9BxI5QhhZQz6ytkmgT3OA37ftydog8+HKilrYU
   8/dd/txMNEazijdzuOX7lUyrz9xSzDtgeI3uxrOmcojEvVEmwAgjEO9Hj
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="360455457"
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="360455457"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 06:54:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="721005868"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga002.fm.intel.com with ESMTP; 15 Sep 2022 06:54:56 -0700
Received: from [10.252.210.17] (kliang2-mobl1.ccr.corp.intel.com [10.252.210.17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 29E75580801;
        Thu, 15 Sep 2022 06:54:54 -0700 (PDT)
Message-ID: <ef391316-cde5-3cda-ff0d-980e8ecc9aef@linux.intel.com>
Date:   Thu, 15 Sep 2022 09:54:52 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Liang, Kan" <kan.liang@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>
Cc:     "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20220825085625.867763-1-xiaoyao.li@intel.com>
 <CY5PR11MB6365897E8E6D0B590A298FA0DC769@CY5PR11MB6365.namprd11.prod.outlook.com>
 <815586ac-1eaa-5e38-1e08-492c29d0729d@intel.com>
 <CY5PR11MB63659EBEAEA0E64812E96111DC469@CY5PR11MB6365.namprd11.prod.outlook.com>
 <f7cfb391-c38b-84d2-b2fe-5e289d82862c@linux.intel.com>
 <CY5PR11MB6365676799EBF86B3931D336DC499@CY5PR11MB6365.namprd11.prod.outlook.com>
Content-Language: en-US
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Subject: Re: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
In-Reply-To: <CY5PR11MB6365676799EBF86B3931D336DC499@CY5PR11MB6365.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022-09-14 10:46 p.m., Wang, Wei W wrote:
> On Thursday, September 15, 2022 4:26 AM, Liang, Kan wrote:
>> The perf_event_disable() eventually invokes the intel_pt_stop().
>> We already expose the intel_pt_stop()/cpu_emergency_stop_pt() to other
>> modules. I don't think we have to use the perf_event_disable(). Also, the
>> perf_event_disable() requires extra codes.
>>
>> I went through the discussions. I agree with Sean's suggestion.
>> We should only put the logic in the KVM but all the MSR access details into the PT
>> driver. 
> 
> Even the driver itself doesn’t drive the save/restore of the MSRs, it is drived by perf.

It through perf_event, not driven by perf_event. The perf_event generic
code never knows when should invokes each driver to save/restore
information. It should be driven by the other subsystem e.g., scheduler.

For this case, KVM should drive the save/restore, and the PT driver
eventually does all the MSR access details.

> 1. If we make KVM a user of perf, we should do this via perf_event_disable/enable_*.
> 2. If we make KVM an alternative to perf (i.e. have direct control over PMU HW),
> we can do this via driver interfaces like perf.
> Per my experience, we should go for 1. Probably need Peter's opinions on this.
>

For 1, the perf_event_disable/enable_* are not enough. They don't
save/restore MSRs. If we go to this way, we have to introduce a new
generic interface to ask each driver to save/restore their MSRs when the
guest is entering/exiting. We'd better combine the new interface with
the existing perf_guest_get_msrs() of the core driver.
I think that's an ideal solution, but requires big changes in the code.

2 is the current KVM implementation. See pt_save_msr()/pt_load_msr(). I
don't think it's a right way. We'd better fix it.

The suggestion should be 3. The KVM notify the PT driver via the
interface provided by PT. The PT driver save/restore all the registers.
I think it's an acceptable solution with small code changes.

So I prefer 3.

Thanks,
Kan

>> But I prefer a more generic and straightforward function name, e.g.,
>> intel_pt_stop_save()/intel_pt_start_load(), in case other modules may want to
>> save/restore the PT information in their context switch later.
>>
>> Thanks,
>> Kan
>>
>>>
>>>> It seems perf_event_disable() is not used widely by other kernel
>>>> component. 
> 
> Because there are not lots of kernel users.
> You can check another user, watchdog_hld.c, perf_event_enable/disable are used there.
