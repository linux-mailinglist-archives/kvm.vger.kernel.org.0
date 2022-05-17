Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03DA45298EB
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 06:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235558AbiEQEyi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 00:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiEQEyg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 00:54:36 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB603F8A5;
        Mon, 16 May 2022 21:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652763275; x=1684299275;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BSqwOUbYppupXsN7qYjzHGq5o7sy9483GsNVLho0/Vo=;
  b=EI8+zkD3BZKGPPckk8ylzjGs2tuWzmV9GQAW17DA4GDbUcVXkwraqICp
   GzCLJC2x/QxiqvdQpJCbTewMPdP9ME0l/NwXiTLGbvXhPeuhv4Pt2GV17
   rwsWO0XQi5G1ucEyefsKzOtWegX0awZWxW9T57xERipSjshhT8w0DtUhO
   JbhCROM98xr+QRxDCHgmm6uxsvX0fg6YKQ+RFQnK48CO+WdV3iixZeAZJ
   YujkWZycYnh2Yb+gYwVob0VYngBKbd7arBfZhqewC0CzTIdBsPeI6EsNi
   QDaYeZZ9T6/0rX/z0pKojM9FUex20cfqbxMVWzWhhRUFLilF2HKv48IG9
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="253109292"
X-IronPort-AV: E=Sophos;i="5.91,231,1647327600"; 
   d="scan'208";a="253109292"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 21:54:34 -0700
X-IronPort-AV: E=Sophos;i="5.91,231,1647327600"; 
   d="scan'208";a="596917734"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.52.217])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 21:54:32 -0700
Message-ID: <cedfc68b-a15e-045e-747d-29d8c2218bd9@intel.com>
Date:   Tue, 17 May 2022 07:54:28 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [PATCH 3/6] perf tools: Add guest_code support
Content-Language: en-US
To:     Namhyung Kim <namhyung@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
        Leo Yan <leo.yan@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
References: <20220513090237.10444-1-adrian.hunter@intel.com>
 <20220513090237.10444-4-adrian.hunter@intel.com>
 <CAM9d7chFeVZNm_WTqrLzv74U13RPQtTvezxbP41GLte+ir6P_A@mail.gmail.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <CAM9d7chFeVZNm_WTqrLzv74U13RPQtTvezxbP41GLte+ir6P_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/05/22 06:13, Namhyung Kim wrote:
> Hi Adrian,
> 
> On Fri, May 13, 2022 at 2:03 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>>
>> A common case for KVM test programs is that the guest object code can be
>> found in the hypervisor process (i.e. the test program running on the
>> host). To support that, copy the host thread's maps to the guest thread's
>> maps. Note, we do not discover the guest until we encounter a guest event,
>> which works well because it is not until then that we know that the host
>> thread's maps have been set up.
>>
>> Typically the main function for the guest object code is called
>> "guest_code", hence the name chosen for this feature.
> 
> Ok, so that's just a convention and there's no hard-coded
> support for the "guest_code" function in this code, right?

That is correct.

> 
>>
>> This is primarily aimed at supporting Intel PT, or similar, where trace
>> data can be recorded for a guest. Refer to the final patch in this series
>> "perf intel-pt: Add guest_code support" for an example.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/util/event.c       |  7 +++-
>>  tools/perf/util/machine.c     | 70 +++++++++++++++++++++++++++++++++++
>>  tools/perf/util/machine.h     |  2 +
>>  tools/perf/util/session.c     |  7 ++++
>>  tools/perf/util/symbol_conf.h |  3 +-
>>  5 files changed, 86 insertions(+), 3 deletions(-)
>>
>> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
>> index 6439c888ae38..0476bb3a4188 100644
>> --- a/tools/perf/util/event.c
>> +++ b/tools/perf/util/event.c
>> @@ -683,9 +683,12 @@ static bool check_address_range(struct intlist *addr_list, int addr_range,
>>  int machine__resolve(struct machine *machine, struct addr_location *al,
>>                      struct perf_sample *sample)
>>  {
>> -       struct thread *thread = machine__findnew_thread(machine, sample->pid,
>> -                                                       sample->tid);
>> +       struct thread *thread;
>>
>> +       if (symbol_conf.guest_code && !machine__is_host(machine))
>> +               thread = machine__findnew_guest_code(machine, sample->pid);
>> +       else
>> +               thread = machine__findnew_thread(machine, sample->pid, sample->tid);
>>         if (thread == NULL)
>>                 return -1;
>>
>> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
>> index e67b5a7670f3..ae2e1fb422e2 100644
>> --- a/tools/perf/util/machine.c
>> +++ b/tools/perf/util/machine.c
>> @@ -392,6 +392,76 @@ struct machine *machines__find_guest(struct machines *machines, pid_t pid)
>>         return machine;
>>  }
>>
>> +/*
>> + * A common case for KVM test programs is that the guest object code can be
>> + * found in the hypervisor process (i.e. the test program running on the host).
>> + * To support that, copy the host thread's maps to the guest thread's maps.
>> + * Note, we do not discover the guest until we encounter a guest event,
>> + * which works well because it is not until then that we know that the host
>> + * thread's maps have been set up.
>> + */
>> +static struct thread *findnew_guest_code(struct machine *machine,
> 
> But this function returns a thread and IIUC that's the task which
> does the host to guest transition.  Then why not calling it just
> findnew__hypervisor() ?

The thread returned is in the guest machine.  While the code comes
from the hypervisor, it is in the guest VM when it runs.

From Intel PT point of view, this function allows finding the guest
object code by setting up the guest thread and its maps.

I will try to improve on the explanation in V2.

> 
> Thanks,
> Namhyung
> 
> 
>> +                                        struct machine *host_machine,
>> +                                        pid_t pid)
>> +{
>> +       struct thread *host_thread;
>> +       struct thread *thread;
>> +       int err;
>> +
>> +       if (!machine)
>> +               return NULL;
>> +
>> +       thread = machine__findnew_thread(machine, -1, pid);
>> +       if (!thread)
>> +               return NULL;
>> +
>> +       /* Assume maps are set up if there are any */
>> +       if (thread->maps->nr_maps)
>> +               return thread;
>> +
>> +       host_thread = machine__find_thread(host_machine, -1, pid);
>> +       if (!host_thread)
>> +               goto out_err;
>> +
>> +       thread__set_guest_comm(thread, pid);
>> +
>> +       /*
>> +        * Guest code can be found in hypervisor process at the same address
>> +        * so copy host maps.
>> +        */
>> +       err = maps__clone(thread, host_thread->maps);
>> +       thread__put(host_thread);
>> +       if (err)
>> +               goto out_err;
>> +
>> +       return thread;
>> +
>> +out_err:
>> +       thread__zput(thread);
>> +       return NULL;
>> +}
>> +

