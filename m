Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574A558D861
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 13:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242131AbiHILuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 07:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232679AbiHILuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 07:50:04 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1542024959;
        Tue,  9 Aug 2022 04:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660045801; x=1691581801;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3VhKsDGWyk3Dr+FTKAO7qj1cvLnp/fyAOljKAVQ8zUE=;
  b=kpCoRQ+/FQXRj86FPpsHcNNa2PaAxQSghC1jxB5O2/JV/CemcRzjSz+W
   oD9/sJOxhDSYl/Uqx2miiLLFlzSOituUWYBGIjbOpzf5ao4tGGBHTZvpc
   5mlbH8L1nowZxaP2fVcW44Q0kcamAxIPLs7g5EBvUx1LpypYsDHXr+i3X
   a3eP1tnLGFvot3yeYZ1gtLtXtt/nOtwTyneWi1bcoQ9VaHUpSCgiH+flt
   Q5Te0ATETPvQXVbsBmI/T6jZfWCSxD34pbvqrn6GMEOtbbMGLT4D6RHVw
   F6AUmbimbzQAyS956MxDcumnnvW5wjoq1UqWmOmJ5rpifq/+9IsMGxq05
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10433"; a="354815716"
X-IronPort-AV: E=Sophos;i="5.93,224,1654585200"; 
   d="scan'208";a="354815716"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 04:50:00 -0700
X-IronPort-AV: E=Sophos;i="5.93,224,1654585200"; 
   d="scan'208";a="932452106"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.48.82])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 04:49:57 -0700
Message-ID: <0e415212-b828-34d3-fd1b-ba518149bf89@intel.com>
Date:   Tue, 9 Aug 2022 14:49:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH 05/35] perf tools: Factor out evsel__id_hdr_size()
Content-Language: en-US
To:     Ian Rogers <irogers@google.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220711093218.10967-1-adrian.hunter@intel.com>
 <20220711093218.10967-6-adrian.hunter@intel.com>
 <CAP-5=fUChJLqfJ__joVhtKwgjLTtBtMm8M0vt9eaOfLMmck85g@mail.gmail.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <CAP-5=fUChJLqfJ__joVhtKwgjLTtBtMm8M0vt9eaOfLMmck85g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/07/22 20:09, Ian Rogers wrote:
> On Mon, Jul 11, 2022 at 2:32 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>>
>> Factor out evsel__id_hdr_size() so it can be reused.
>>
>> This is needed by perf inject. When injecting events from a guest perf.data
>> file, there is a possibility that the sample ID numbers conflict. To
>> re-write an ID sample, the old one needs to be removed first, which means
>> determining how big it is with evsel__id_hdr_size() and then subtracting
>> that from the event size.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/util/evlist.c | 28 +---------------------------
>>  tools/perf/util/evsel.c  | 26 ++++++++++++++++++++++++++
>>  tools/perf/util/evsel.h  |  2 ++
>>  3 files changed, 29 insertions(+), 27 deletions(-)
>>
>> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
>> index 48af7d379d82..03fbe151b0c4 100644
>> --- a/tools/perf/util/evlist.c
>> +++ b/tools/perf/util/evlist.c
>> @@ -1244,34 +1244,8 @@ bool evlist__valid_read_format(struct evlist *evlist)
>>  u16 evlist__id_hdr_size(struct evlist *evlist)
>>  {
>>         struct evsel *first = evlist__first(evlist);
>> -       struct perf_sample *data;
>> -       u64 sample_type;
>> -       u16 size = 0;
>>
>> -       if (!first->core.attr.sample_id_all)
>> -               goto out;
>> -
>> -       sample_type = first->core.attr.sample_type;
>> -
>> -       if (sample_type & PERF_SAMPLE_TID)
>> -               size += sizeof(data->tid) * 2;
>> -
>> -       if (sample_type & PERF_SAMPLE_TIME)
>> -               size += sizeof(data->time);
>> -
>> -       if (sample_type & PERF_SAMPLE_ID)
>> -               size += sizeof(data->id);
>> -
>> -       if (sample_type & PERF_SAMPLE_STREAM_ID)
>> -               size += sizeof(data->stream_id);
>> -
>> -       if (sample_type & PERF_SAMPLE_CPU)
>> -               size += sizeof(data->cpu) * 2;
>> -
>> -       if (sample_type & PERF_SAMPLE_IDENTIFIER)
>> -               size += sizeof(data->id);
>> -out:
>> -       return size;
>> +       return first->core.attr.sample_id_all ? evsel__id_hdr_size(first) : 0;
>>  }
>>
>>  bool evlist__valid_sample_id_all(struct evlist *evlist)
>> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
>> index a67cc3f2fa74..9a30ccb7b104 100644
>> --- a/tools/perf/util/evsel.c
>> +++ b/tools/perf/util/evsel.c
>> @@ -2724,6 +2724,32 @@ int evsel__parse_sample_timestamp(struct evsel *evsel, union perf_event *event,
>>         return 0;
>>  }
>>
>> +u16 evsel__id_hdr_size(struct evsel *evsel)
>> +{
>> +       u64 sample_type = evsel->core.attr.sample_type;
> 
> As this just uses core, would it be more appropriate to put it in libperf?

AFAIK we move to libperf only as needed.

> 
>> +       u16 size = 0;
> 
> Perhaps size_t or int? u16 seems odd.

Event header size member is 16-bit

> 
>> +
>> +       if (sample_type & PERF_SAMPLE_TID)
>> +               size += sizeof(u64);
>> +
>> +       if (sample_type & PERF_SAMPLE_TIME)
>> +               size += sizeof(u64);
>> +
>> +       if (sample_type & PERF_SAMPLE_ID)
>> +               size += sizeof(u64);
>> +
>> +       if (sample_type & PERF_SAMPLE_STREAM_ID)
>> +               size += sizeof(u64);
>> +
>> +       if (sample_type & PERF_SAMPLE_CPU)
>> +               size += sizeof(u64);
>> +
>> +       if (sample_type & PERF_SAMPLE_IDENTIFIER)
>> +               size += sizeof(u64);
>> +
>> +       return size;
>> +}
>> +
>>  struct tep_format_field *evsel__field(struct evsel *evsel, const char *name)
>>  {
>>         return tep_find_field(evsel->tp_format, name);
>> diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
>> index 92bed8e2f7d8..699448f2bc2b 100644
>> --- a/tools/perf/util/evsel.h
>> +++ b/tools/perf/util/evsel.h
>> @@ -381,6 +381,8 @@ int evsel__parse_sample(struct evsel *evsel, union perf_event *event,
>>  int evsel__parse_sample_timestamp(struct evsel *evsel, union perf_event *event,
>>                                   u64 *timestamp);
>>
>> +u16 evsel__id_hdr_size(struct evsel *evsel);
>> +
> 
> A comment would be nice, I know this is just moving code about but
> this is a new function.
> 
> Thanks,
> Ian
> 
>>  static inline struct evsel *evsel__next(struct evsel *evsel)
>>  {
>>         return list_entry(evsel->core.node.next, struct evsel, core.node);
>> --
>> 2.25.1
>>

