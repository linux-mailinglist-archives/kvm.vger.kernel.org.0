Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F8863447B
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 20:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234743AbiKVTY5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 14:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234426AbiKVTYz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 14:24:55 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A88E7FF21;
        Tue, 22 Nov 2022 11:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669145094; x=1700681094;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OKm7UJo5SyFqT5YmYkDdQ5nt3mpnIZkSEfunTTVs3qE=;
  b=UKpm2Bq0PtKiHN2VGC8sSV3IwF8v5Qmu+080Zfb9h3+clw2zNJ1aT6ff
   rP0oNdIPDKJSGJfoVrAKypuZN63BkyIy9fgETxz1lJaYEOyWsNFLt+pO9
   X+K6/D9TfduQF82hOVxNfw1NiwruJi/xfAa0aQGlwH4bdeUX9VjHtzqMn
   2lKzqjmhPRjsOI925lwY3r7v6DdAKRaeadNbSQg/F9irQvXfSjb9gujHT
   l12bfP8vGsK2SbA1nE85KvDJv3MxhQgNyJAIB9lA+/P0vdUFH+upnIwzG
   liMiqmuf3TQxGKIlVi789IhuYz4LmAQSUTU7JphQC3yyfBhPGyBqgE26K
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="400187018"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="400187018"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 11:24:53 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="641525771"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="641525771"
Received: from coltsavx-mobl1.amr.corp.intel.com (HELO [10.255.0.114]) ([10.255.0.114])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 11:24:47 -0800
Message-ID: <b3938f3a-e4f8-675a-0c0e-4b4618019145@intel.com>
Date:   Tue, 22 Nov 2022 11:24:48 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org, seanjc@google.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1668988357.git.kai.huang@intel.com>
 <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
 <Y3ySxEr64HkUaEDq@hirez.programming.kicks-ass.net>
 <52b2be9b-defd-63ce-4cb2-96cd624a95a6@intel.com>
 <Y30fUS5/JClpBHVc@hirez.programming.kicks-ass.net>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <Y30fUS5/JClpBHVc@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/22/22 11:13, Peter Zijlstra wrote:
> On Tue, Nov 22, 2022 at 07:14:14AM -0800, Dave Hansen wrote:
>> On 11/22/22 01:13, Peter Zijlstra wrote:
>>> On Mon, Nov 21, 2022 at 01:26:28PM +1300, Kai Huang wrote:
>>>> +/*
>>>> + * Call the SEAMCALL on all online CPUs concurrently.  Caller to check
>>>> + * @sc->err to determine whether any SEAMCALL failed on any cpu.
>>>> + */
>>>> +static void seamcall_on_each_cpu(struct seamcall_ctx *sc)
>>>> +{
>>>> +	on_each_cpu(seamcall_smp_call_function, sc, true);
>>>> +}
>>>
>>> Suppose the user has NOHZ_FULL configured, and is already running
>>> userspace that will terminate on interrupt (this is desired feature for
>>> NOHZ_FULL), guess how happy they'll be if someone, on another parition,
>>> manages to tickle this TDX gunk?
>>
>> Yeah, they'll be none too happy.
>>
>> But, what do we do?
> 
> Not intialize TDX on busy NOHZ_FULL cpus and hard-limit the cpumask of
> all TDX using tasks.

I don't think that works.  As I mentioned to Thomas elsewhere, you don't
just need to initialize TDX on the CPUs where it is used.  Before the
module will start working you need to initialize it on *all* the CPUs it
knows about.  The module itself has a little counter where it tracks
this and will refuse to start being useful until it gets called
thoroughly enough.

>> There are technical solutions like detecting if NOHZ_FULL is in play and
>> refusing to initialize TDX.  There are also non-technical solutions like
>> telling folks in the documentation that they better modprobe kvm early
>> if they want to do TDX, or their NOHZ_FULL apps will pay.
> 
> Surely modprobe kvm isn't the point where TDX gets loaded? Because
> that's on boot for everybody due to all the auto-probing nonsense.
> 
> I was expecting TDX to not get initialized until the first TDX using KVM
> instance is created. Am I wrong?

I went looking for it in this series to prove you wrong.  I failed.  :)

tdx_enable() is buried in here somewhere:

> https://lore.kernel.org/lkml/CAAhR5DFrwP+5K8MOxz5YK7jYShhaK4A+2h1Pi31U_9+Z+cz-0A@mail.gmail.com/T/

I don't have the patience to dig it out today, so I guess we'll have Kai
tell us.

>> We could also force the TDX module to be loaded early in boot before
>> NOHZ_FULL is in play, but that would waste memory on TDX metadata even
>> if TDX is never used.
> 
> I'm thikning it makes sense to have a tdx={off,on-demand,force} toggle
> anyway.

Yep, that makes total sense.  Kai had one in an earlier version but I
made him throw it out because it wasn't *strictly* required and this set
is fat enough.

>> How do NOHZ_FULL folks deal with late microcode updates, for example?
>> Those are roughly equally disruptive to all CPUs.
> 
> I imagine they don't do that -- in fact I would recommend we make the
> whole late loading thing mutually exclusive with nohz_full; can't have
> both.

So, if we just use schedule_on_cpu() for now and have the TDX code wait,
will a NOHZ_FULL task just block the schedule_on_cpu() indefinitely?

That doesn't seem like _horrible_ behavior to start off with for a
minimal series.
