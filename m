Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F17B47B5B9A
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 21:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238958AbjJBTur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 15:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjJBTuq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 15:50:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745CCB3;
        Mon,  2 Oct 2023 12:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696276241; x=1727812241;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PYugQSadN1sU4I76zsSR3ousR9bhAhoozl4QCo+YBEk=;
  b=eSGXxC87fOl3AWQ8uzZ8BG9p7ZUKSR9rpVEzAS+1iXf9yrEBvWCSvdZi
   HEBXXFoPlyuvM8NSUEN4ibK/4ndnVWU/XnrrRhdVpgc00Q3hQ1qPTIg2r
   ZwvJi62eryYEJnxJ9x34g2mGEfY8T10wEcjilFQidnwLOlBJobOmhQ9Is
   UzPO7nqykTO/7wsaxxXQi4rJnsIUgb3B/9AVh5F2nn/DenbP9um03fSHI
   Y6JtCZ1aD55khu/cbr/YXt5KKGtCteLhHgfEIfzWNhcXrJFzSyuXZ7iC3
   PBmvr1dgBkGwzIxvktjjELnmt3J3i+MkQsbl2f46IPL9gr+08jQYdGoXT
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="446882356"
X-IronPort-AV: E=Sophos;i="6.03,194,1694761200"; 
   d="scan'208";a="446882356"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 12:50:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="780049233"
X-IronPort-AV: E=Sophos;i="6.03,194,1694761200"; 
   d="scan'208";a="780049233"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 12:50:29 -0700
Received: from [10.212.65.113] (kliang2-mobl1.ccr.corp.intel.com [10.212.65.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 4DD90580AFF;
        Mon,  2 Oct 2023 12:50:26 -0700 (PDT)
Message-ID: <f6b295f2-966c-f566-14c0-dbe02cad2bd2@linux.intel.com>
Date:   Mon, 2 Oct 2023 15:50:24 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics
 event
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
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
        Mingwei Zhang <mizhang@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
 <20230927033124.1226509-8-dapeng1.mi@linux.intel.com>
 <20230927113312.GD21810@noisy.programming.kicks-ass.net>
 <ZRRl6y1GL-7RM63x@google.com>
 <20230929115344.GE6282@noisy.programming.kicks-ass.net>
 <ZRbxb15Opa2_AusF@google.com>
 <20231002115718.GB13957@noisy.programming.kicks-ass.net>
 <ZRrF38RGllA04R8o@gmail.com> <ZRroQg6flyGBtZTG@google.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <ZRroQg6flyGBtZTG@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2023-10-02 11:56 a.m., Sean Christopherson wrote:
> I am completely ok with either approach, but I am not ok with being nak'd on both.
> Because unless there's a magical third option lurking, those two options are the
> only ways for KVM to provide a vPMU that meets the requirements for slice-of-hardware
> use cases.

It may be doable to introduce a knob to enable/disable the "CPU-pinned"
capability of perf_event. If the capability is disabled, the KVM doesn't
need to worry about the counters being gone without notification, since
the "task pinned" has the highest priority at the moment.

It should also keeps the flexibility that sometimes the host wants to
profile the guest.

Now, the NMI watchdog is using a "CPU-pinned" event. But I think it can
be replaced by the buddy system, commit 1f423c905a6b
("watchdog/hardlockup: detect hard lockups using secondary (buddy) CPUs")

Thanks,
Kan
