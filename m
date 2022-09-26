Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4F055EAD3D
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 18:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiIZQzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 12:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiIZQyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 12:54:49 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D931A47C;
        Mon, 26 Sep 2022 08:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664207320; x=1695743320;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BSqCeRy7/n93LT8fIhy5SYrIqEP2/I0vvdbmBAF90pk=;
  b=joxqlrNKIatUTJJ1IDMvV70/VA3BabQLpNxV2DVnppyP3K4+d7xHt85F
   PiyKFL7ApCAxCsRMCrkhi/G9PR+CnB9nHvsNVmGHdfckwWRxt9h2tnN9m
   qZX+LbAsJq4y4nm7mdSgLbmTQdneCueAbFSUOLnZsGATjC+9M0tPNIubd
   R2bwQqkVboiqDHPW2ZlJzDt9xLm6tx2zxcDXjlLkvelwMzy9VoMXwfl/m
   mLA1KipK8VP1B6RonJtLb5WZGOAzI2VF+u/i9kNJ/N+IswySeccOQH6Iz
   SIBYvAyltJktVb1UBeAmIvxVpR2g3GCkkQCCBU7tGt//KBF6FSOf5Wthg
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="280788694"
X-IronPort-AV: E=Sophos;i="5.93,346,1654585200"; 
   d="scan'208";a="280788694"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 08:48:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="683577771"
X-IronPort-AV: E=Sophos;i="5.93,346,1654585200"; 
   d="scan'208";a="683577771"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga008.fm.intel.com with ESMTP; 26 Sep 2022 08:48:39 -0700
Received: from [10.252.214.241] (kliang2-mobl1.ccr.corp.intel.com [10.252.214.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id DF42F580979;
        Mon, 26 Sep 2022 08:48:37 -0700 (PDT)
Message-ID: <62d4bec1-a0c3-3b01-61bb-f284eede6378@linux.intel.com>
Date:   Mon, 26 Sep 2022 11:48:36 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [RFC PATCH v2 2/3] perf/x86/intel/pt: Introduce and export
 pt_get_curr_event()
Content-Language: en-US
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20220921164521.2858932-1-xiaoyao.li@intel.com>
 <20220921164521.2858932-3-xiaoyao.li@intel.com>
 <175b518c-d202-644e-a3a7-67e877852548@linux.intel.com>
 <DS0PR11MB6373C84139621DC447D3F466DC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Yyxke/IO+AP4EWwT@hirez.programming.kicks-ass.net>
 <DS0PR11MB637346E9F224C5330CDEF3BFDC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
 <YyxsnAFYMLn2U9BT@hirez.programming.kicks-ass.net>
 <DS0PR11MB63730A85E00683AB7F6F3E26DC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <DS0PR11MB63730A85E00683AB7F6F3E26DC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022-09-22 10:42 a.m., Wang, Wei W wrote:
> On Thursday, September 22, 2022 10:10 PM, Peter Zijlstra wrote:
>> On Thu, Sep 22, 2022 at 01:59:53PM +0000, Wang, Wei W wrote:
>>> On Thursday, September 22, 2022 9:35 PM, Peter Zijlstra
>>>> On Thu, Sep 22, 2022 at 12:58:49PM +0000, Wang, Wei W wrote:
>>>>
>>>>> Add a function to expose the current running PT event to users.
>>>>> One usage is in KVM, it needs to get and disable the running host
>>>>> PT event before VMEnter to the guest and resumes the event after
>> VMexit to host.
>>>>
>>>> You cannot just kill a host event like that. If there is a host
>>>> event, the guest looses out.
>>>
>>> OK. The intention was to pause the event (that only profiles host
>>> info) when switching to guest, and resume when switching back to host.
>>
>> If the even doesn't profile guest context, then yes. If it does profile guest
>> context, you can't.
> 
> Seems better to add this one:

If the guest host mode is enabled, I think the PT driver should not
allow the perf tool to create a host event with !exclude_guest.

Thanks,
Kan
> 
> +int perf_event_disable_local_exclude_guest(struct perf_event *event)
> +{
> +       struct perf_event_attr *attr = &event->attr;
> +
> +       if (!attr->exclude_guest)
> +               return -EPERM;
> +
> +       event_function_local(event, __perf_event_disable, NULL);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(perf_event_disable_local_exclude_guest);
> 
