Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A817B1740
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 11:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbjI1JZK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 05:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbjI1JZE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 05:25:04 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805381AB;
        Thu, 28 Sep 2023 02:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695893095; x=1727429095;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=d3HSJgxmIHVNYhHahBnx8D0eOMl0pZAVqEK+uI2PB0o=;
  b=ZPKKdE9E6/iTkSe5bx+jIjCoLxJXS4atEM6mp7xv1j6HYuKLFPMn3D4h
   eNHuMZwLEayQ557Hf9o3/7gca6ih4VebgRCLSDvTnXLgKl2GDGmykACGu
   T1uH4aVks6uhUlrggTSHsYL8TANy8ON/xktCujXLrFmzQ/DafLUAoanOr
   jQHPWJey6rBRdIfZdWwO98G7ShoN13FSPAS8eTRUBaIVLBoW+xDiKQmIp
   T5iPnKZoq5zEfO20GVuO6ImyP5ciKsqfkDYl1oM5yViKfC5bKHvotszgz
   +mZZPgwQcQaGBhYeaqnpT573RPYYg4dBNok6UxaD4+IYELyRPNv0XBdLB
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="361393494"
X-IronPort-AV: E=Sophos;i="6.03,183,1694761200"; 
   d="scan'208";a="361393494"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2023 02:24:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="865190491"
X-IronPort-AV: E=Sophos;i="6.03,183,1694761200"; 
   d="scan'208";a="865190491"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.5.53]) ([10.93.5.53])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2023 02:24:40 -0700
Message-ID: <6601b6f9-b3d2-4da8-a07b-a07ef9fe96e1@linux.intel.com>
Date:   Thu, 28 Sep 2023 17:24:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics
 event
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Mingwei Zhang <mizhang@google.com>
References: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
 <20230927033124.1226509-8-dapeng1.mi@linux.intel.com>
 <20230927113312.GD21810@noisy.programming.kicks-ass.net>
 <ZRRl6y1GL-7RM63x@google.com>
From:   "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZRRl6y1GL-7RM63x@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/28/2023 1:27 AM, Sean Christopherson wrote:
> +Jim, David, and Mingwei
>
> On Wed, Sep 27, 2023, Peter Zijlstra wrote:
>> On Wed, Sep 27, 2023 at 11:31:18AM +0800, Dapeng Mi wrote:
>>> When guest wants to use PERF_METRICS MSR, a virtual metrics event needs
>>> to be created in the perf subsystem so that the guest can have exclusive
>>> ownership of the PERF_METRICS MSR.
>> Urgh, can someone please remind me how all that is supposed to work
>> again? The guest is just a task that wants the event. If the
>> host creates a CPU event, then that gets scheduled with higher priority
>> and the task looses out, no joy.


It looks I used the inaccurate words in the comments. Yes, it's not 
*exclusive* from host's point view.  Currently the perf events created 
by KVM are task-pinned events, they are indeed possible to be preempted 
by CPU-pinned host events which have higher priority. This is a long 
term issue which vPMU encountered. We ever have some internal discussion 
about this issue, but it seems we don't have a good way to solve this 
issue thoroughly in current vPMU framework.

But if there is no such CPU-pinned events which have the highest 
priority on host, KVM perf events can share the HW resource with other 
host events with the way of time-multiplexing.

>> So you cannot guarantee the guest gets anything.
>>
>> That is, I remember we've had this exact problem before, but I keep
>> forgetting how this all is supposed to work. I don't use this virt stuff
>> (and every time I try qemu arguments defeat me and I give up in
>> disgust).
> I don't think it does work, at least not without a very, very carefully crafted
> setup and a host userspace that knows it must not use certain aspects of perf.
> E.g. for PEBS, if the guest virtual counters don't map 1:1 to the "real" counters
> in hardware, KVM+perf simply disables the counter.
>
> And for top-down slots, getting anything remotely accurate requires pinning vCPUs
> 1:1 with pCPUs and enumerating an accurate toplogy to the guest:
>
>    The count is distributed among unhalted logical processors (hyper-threads) who
>    share the same physical core, in processors that support Intel Hyper-Threading
>    Technology.
>
> Jumping the gun a bit (we're in the *super* early stages of scraping together a
> rough PoC), but I think we should effectively put KVM's current vPMU support into
> maintenance-only mode, i.e. stop adding new features unless they are *very* simple
> to enable, and instead pursue an implementation that (a) lets userspace (and/or
> the kernel builder) completely disable host perf (or possibly just host perf usage
> of the hardware PMU) and (b) let KVM passthrough the entire hardware PMU when it
> has been turned off in the host.
>
> I.e. keep KVM's existing best-offset vPMU support, e.g. for setups where the
> platform owner is also the VM ueer (running a Windows VM on a Linux box, hosting
> a Linux VM in ChromeOS, etc...).  But for anything advanced and for hard guarantees,
> e.g. cloud providers that want to expose fully featured vPMU to customers, force
> the platform owner to choose between using perf (or again, perf with hardware PMU)
> in the host, and exposing the hardware PMU to the guest.
>
> Hardware vendors are pushing us in the direction whether we like it or not, e.g.
> SNP and TDX want to disallow profiling the guest from the host, ARM has an
> upcoming PMU model where (IIUC) it can't be virtualized without a passthrough
> approach, Intel's hybrid CPUs are a complete trainwreck unless vCPUs are pinned,
> and virtualizing things like top-down slots, PEBS, and LBRs in the shared model
> requires an absurd amount of complexity throughout the kernel and userspace.
>
> Note, a similar idea was floated and rejected in the past[*], but that failed
> proposal tried to retain host perf+PMU functionality by making the behavior dynamic,
> which I agree would create an awful ABI for the host.  If we make the "knob" a
> Kconfig or kernel param, i.e. require the platform owner to opt-out of using perf
> no later than at boot time, then I think we can provide a sane ABI, keep the
> implementation simple, all without breaking existing users that utilize perf in
> the host to profile guests.
>
> [*] https://lore.kernel.org/all/CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com
