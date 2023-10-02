Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D517B533F
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 14:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237106AbjJBM3o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 08:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237028AbjJBM3m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 08:29:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55191EB;
        Mon,  2 Oct 2023 05:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KL1v3ERuqGAckhQouBuxqqIbYjdQyTtkhHki0C/q84c=; b=YP5xSF1Oemu2I0hFWrgo43pZ4h
        fCiZhQofphigB6JQOLIKI/85S60pcMYf1mSHKG39Qsw1JPGo+kXmrufEBFbb+X7zBIQsztHNbTVVD
        +DjOXt1FD2ZYeisEBDVigdkdAIqZTlY6hWxGBbWQOdtURVMGlg7J9Qw/NXiWPz46GC9WVdLPwuDZx
        Vn3YHkqkwGFvsm2qDNP4Fe+DV/Z1i0NU5bMns0C73DW25bNMz9NXviIf2iR99M4zXS4KdwNQhJ2pw
        UeCnkQP33VhvHvHzin+hhLfMRzHFjbIEADlEhAjD0rQI2m+0yNBQkIxbFnY7LvXlc9ECyaQCD1Ly1
        l0EOqJNw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qnI2v-0091Eh-Ne; Mon, 02 Oct 2023 12:29:09 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id 64E33300454; Mon,  2 Oct 2023 14:29:09 +0200 (CEST)
Date:   Mon, 2 Oct 2023 14:29:09 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Ravi Bangoria <ravi.bangoria@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
        Mingwei Zhang <mizhang@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Manali Shukla <manali.shukla@amd.com>
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics
 event
Message-ID: <20231002122909.GC13957@noisy.programming.kicks-ass.net>
References: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
 <20230927033124.1226509-8-dapeng1.mi@linux.intel.com>
 <20230927113312.GD21810@noisy.programming.kicks-ass.net>
 <ZRRl6y1GL-7RM63x@google.com>
 <20230929115344.GE6282@noisy.programming.kicks-ass.net>
 <957d37c8-c833-e1d3-2afb-45e5ef695b22@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <957d37c8-c833-e1d3-2afb-45e5ef695b22@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 29, 2023 at 08:50:07PM +0530, Ravi Bangoria wrote:
> On 29-Sep-23 5:23 PM, Peter Zijlstra wrote:

> > I don't think you need to go that far, host can use PMU just fine as
> > long as it doesn't overlap with a vCPU. Basically, if you force
> > perf_attr::exclude_guest on everything your vCPU can haz the full thing.

^ this..

> How about keying off based on PMU specific KVM module parameter? Something
> like what Manali has proposed for AMD VIBS? Please see solution 1.1:
> 
> https://lore.kernel.org/r/3a6c693e-1ef4-6542-bc90-d4468773b97d@amd.com

So I hadn't read that, but isn't that more or less what I proposed
above?
