Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07E0628726
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 18:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237694AbiKNRdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 12:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237797AbiKNRdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 12:33:33 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44648626A;
        Mon, 14 Nov 2022 09:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+woNkKK6JSXdy4mqNbD3Tr9quE3pzUwSQqKVI1X/BPE=; b=fHomstRuFLzlEHSxV4ihy4uUn6
        YvJdVaKHoB+i1x8XYxSv3RpRMcxe61Xrh62ZbL1CwCk6Pr8pRA6a6ruyE4XUevOmmP1GYaM65Z6JE
        bOs796MYabZLN6vCCZ9sEuLMIP+GK74A4IDH6h6GgoM2T2TCVkv4bqNOB46QIKMbv3kMzG6iaxEOg
        pHlajUP6vBPH3+6JbTx45ahU1qwxFpmhRL9js5GtDZ5T0wRN+UWRLztFD5QIVIyKnOHnHuhg4YRWN
        mi6C8iRL5EJHP5lJNaT83bcrM0VpC2TN3hRJ2yLArQUrQZpqP4/DDgnFeA9JBgWRiI31OER4LkS3e
        HQ33BaAA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oudKt-00FbcY-M8; Mon, 14 Nov 2022 17:33:31 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3B3EC300348;
        Mon, 14 Nov 2022 13:46:27 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 24AF320242906; Mon, 14 Nov 2022 13:46:27 +0100 (CET)
Date:   Mon, 14 Nov 2022 13:46:27 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        Kan Liang <kan.liang@linux.intel.com>
Subject: Re: [PATCH v3 3/3] perf/x86/intel: Expose EPT-friendly PEBS for SPR
 and future models
Message-ID: <Y3I4o4Y/TcqidyJT@hirez.programming.kicks-ass.net>
References: <20221109082802.27543-1-likexu@tencent.com>
 <20221109082802.27543-4-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109082802.27543-4-likexu@tencent.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022 at 04:28:02PM +0800, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> According to Intel SDM, the EPT-friendly PEBS is supported by all the
> platforms after ICX, ADL and the future platforms with PEBS format 5.
> 
> Currently the only in-kernel user of this capability is KVM, which has
> very limited support for hybrid core pmu, so ADL and its successors do
> not currently expose this capability. When both hybrid core and PEBS
> format 5 are present, KVM will decide on its own merits.

Oh right; the whole ADL KVM trainwreck :/ What's the plan there?

> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: linux-perf-users@vger.kernel.org
> Suggested-by: Kan Liang <kan.liang@linux.intel.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
> ---
> Nit: This change is proposed to be applied via the KVM tree.

Works for me;

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
