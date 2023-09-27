Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC987B0323
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 13:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbjI0Ldx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 07:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbjI0Ldl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 07:33:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E23D199;
        Wed, 27 Sep 2023 04:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ELXRd2+VoCH1I99QYOA/3TEPv4nC2Y881FhqGK/auxc=; b=YWKDH/YiyjT5Dq/JDiSk6c7qUD
        c5/JkA5GFfOxYnB/+9sbB9SGxVf8M24jp0utbGyNIKU852uCoZS5CqxpPznaCBrWe1luDFC68fBlw
        RJQ4M2K6sG6UhKeGNtNRKdMVH/5DuYyGcK4TxtDcLP4NwAig5vy69nnNMWbIVt/PtDs8souYj8kwD
        fXDliBfzL66rBFFMwPDc6/lw7zhkrL/X604/DSIW3Oz3cXE5vjWd0XknfxKYTcDx/Gx8HwKivqpCY
        Rm2TISRgyw6nOXPc0Tc8ePBGGsGUHUkeO47+sr0R2E5ljQgWgLG+0e7XhbdjEZqKAIC1u57yzITAv
        6Ch4WpgA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qlSn3-00DcAy-8o; Wed, 27 Sep 2023 11:33:13 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id E8AF3300473; Wed, 27 Sep 2023 13:33:12 +0200 (CEST)
Date:   Wed, 27 Sep 2023 13:33:12 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
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
        Dapeng Mi <dapeng1.mi@intel.com>
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics
 event
Message-ID: <20230927113312.GD21810@noisy.programming.kicks-ass.net>
References: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
 <20230927033124.1226509-8-dapeng1.mi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927033124.1226509-8-dapeng1.mi@linux.intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 27, 2023 at 11:31:18AM +0800, Dapeng Mi wrote:
> When guest wants to use PERF_METRICS MSR, a virtual metrics event needs
> to be created in the perf subsystem so that the guest can have exclusive
> ownership of the PERF_METRICS MSR.

Urgh, can someone please remind me how all that is supposed to work
again? The guest is just a task that wants the event. If the
host creates a CPU event, then that gets scheduled with higher priority
and the task looses out, no joy.

So you cannot guarantee the guest gets anything.

That is, I remember we've had this exact problem before, but I keep
forgetting how this all is supposed to work. I don't use this virt stuff
(and every time I try qemu arguments defeat me and I give up in
disgust).


