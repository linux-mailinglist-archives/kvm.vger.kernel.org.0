Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E6458DC6B
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 18:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244997AbiHIQsS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 12:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244667AbiHIQsQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 12:48:16 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E528622B1C;
        Tue,  9 Aug 2022 09:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660063695; x=1691599695;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=u8cyW2Hmpz0IJ7FaPyT0aFd0QCXNWrP+9Wt7ociOwPg=;
  b=VrOEiTibsigCUL/WlRXovabc5XSmVyVUtyDS8qaoV30fQsfmecuNap0v
   xiJZApCr33h0Bw0yBG4ELbmzAdSOXZX3WLlLWSL+aCYutUlRShe6lWOQT
   0H3MeKJWNjSa0lBRieGDXWGH+3smbfqRO+6oIrH3HO3NlzGIPKOBikxRq
   cpsbZCqi8mXyYup+2GxIha/RFtxjiieQBSZCxT/rtzzWUAyxnnrxANDQE
   qAadodwCdXrLA+DK/dlHkJyPxKX1Cy0oEJhiFnDN1/CZS3Cb5AbM/AOaK
   axRGP+YEr73SwTWt9G3sXNznt+CqvjaoPhZGg/VQUilci2ED3PkZYZJbX
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10434"; a="290885785"
X-IronPort-AV: E=Sophos;i="5.93,225,1654585200"; 
   d="scan'208";a="290885785"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 09:48:15 -0700
X-IronPort-AV: E=Sophos;i="5.93,225,1654585200"; 
   d="scan'208";a="664509363"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.48.82])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 09:48:13 -0700
Message-ID: <3992b293-a72d-aeeb-e6df-9f56db812e74@intel.com>
Date:   Tue, 9 Aug 2022 19:48:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH 23/35] perf tools: Add reallocarray_as_needed()
Content-Language: en-US
To:     Ian Rogers <irogers@google.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220711093218.10967-1-adrian.hunter@intel.com>
 <20220711093218.10967-24-adrian.hunter@intel.com>
 <CAP-5=fWOcK75gc6VicZUu_KPJHVteHES4+rjFMJWyuT09AC56g@mail.gmail.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <CAP-5=fWOcK75gc6VicZUu_KPJHVteHES4+rjFMJWyuT09AC56g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/07/22 03:55, Ian Rogers wrote:
> On Mon, Jul 11, 2022 at 2:33 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>>
>> Add helper reallocarray_as_needed() to reallocate an array to a larger
>> size and initialize the extra entries to an arbitrary value.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/util/util.c | 33 +++++++++++++++++++++++++++++++++
>>  tools/perf/util/util.h | 15 +++++++++++++++
>>  2 files changed, 48 insertions(+)
>>
>> diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
>> index 9b02edf9311d..391c1e928bd7 100644
>> --- a/tools/perf/util/util.c
>> +++ b/tools/perf/util/util.c
>> @@ -18,6 +18,7 @@
>>  #include <linux/kernel.h>
>>  #include <linux/log2.h>
>>  #include <linux/time64.h>
>> +#include <linux/overflow.h>
>>  #include <unistd.h>
>>  #include "cap.h"
>>  #include "strlist.h"
>> @@ -500,3 +501,35 @@ char *filename_with_chroot(int pid, const char *filename)
>>
>>         return new_name;
>>  }
>> +
>> +/*
>> + * Reallocate an array *arr of size *arr_sz so that it is big enough to contain
>> + * x elements of size msz, initializing new entries to *init_val or zero if
>> + * init_val is NULL
>> + */
>> +int do_realloc_array_as_needed(void **arr, size_t *arr_sz, size_t x, size_t msz, const void *init_val)
> 
> This feels a little like a 1-dimensional xyarray, could we make a
> similar abstraction to avoid passing all these values around?

xyarray does not realloc which is the only thing that is needed in
this case. C isn't C++, so adding an abstraction would be clunky.

> 
> Thanks,
> Ian
> 
>> +{
>> +       size_t new_sz = *arr_sz;
>> +       void *new_arr;
>> +       size_t i;
>> +
>> +       if (!new_sz)
>> +               new_sz = msz >= 64 ? 1 : roundup(64, msz); /* Start with at least 64 bytes */
>> +       while (x >= new_sz) {
>> +               if (check_mul_overflow(new_sz, (size_t)2, &new_sz))
>> +                       return -ENOMEM;
>> +       }
>> +       if (new_sz == *arr_sz)
>> +               return 0;
>> +       new_arr = calloc(new_sz, msz);
>> +       if (!new_arr)
>> +               return -ENOMEM;
>> +       memcpy(new_arr, *arr, *arr_sz * msz);
>> +       if (init_val) {
>> +               for (i = *arr_sz; i < new_sz; i++)
>> +                       memcpy(new_arr + (i * msz), init_val, msz);
>> +       }
>> +       *arr = new_arr;
>> +       *arr_sz = new_sz;
>> +       return 0;
>> +}
>> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
>> index 0f78f1e7782d..c1f2d423a9ec 100644
>> --- a/tools/perf/util/util.h
>> +++ b/tools/perf/util/util.h
>> @@ -79,4 +79,19 @@ struct perf_debuginfod {
>>  void perf_debuginfod_setup(struct perf_debuginfod *di);
>>
>>  char *filename_with_chroot(int pid, const char *filename);
>> +
>> +int do_realloc_array_as_needed(void **arr, size_t *arr_sz, size_t x,
>> +                              size_t msz, const void *init_val);
>> +
>> +#define realloc_array_as_needed(a, n, x, v) ({                 \
>> +       typeof(x) __x = (x);                                    \
>> +       __x >= (n) ?                                            \
>> +               do_realloc_array_as_needed((void **)&(a),       \
>> +                                          &(n),                \
>> +                                          __x,                 \
>> +                                          sizeof(*(a)),        \
>> +                                          (const void *)(v)) : \
>> +               0;                                              \
>> +       })
>> +
>>  #endif /* GIT_COMPAT_UTIL_H */
>> --
>> 2.25.1
>>

