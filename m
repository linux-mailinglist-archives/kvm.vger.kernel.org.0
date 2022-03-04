Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001954CD55A
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 14:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235944AbiCDNnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 08:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237225AbiCDNmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 08:42:55 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62A91B8BC3;
        Fri,  4 Mar 2022 05:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=y9PpE0gkDy9J4jeFuVca7c+WURC8tyGMPwoneuqmxJo=; b=i2dMqtCBRJbiz7rFAWzNKCr52E
        philOHD1okKyQDRyMeL9Gcwmh4Yi/19FrTp81UNuP21poIVa16/x/QwNAnqN5zZuLNN2lD9iEd+H0
        H/kgTxQumAnsf+qpSKxGwfc703k1iBKK+v5m8TYQ3UIQTCZWsmntCYK9JUTd6KBA0HZYUs1LrDww9
        PlUK0tV2WHFMz6w9UqyucqAcgWOHdzvlYJ3kizKztQkQvFKsj6tHyR57QHsegm8adXNYHJMFMK1LV
        h+7YpME0R03XHQWQsJobOR8JTFuAcj6zSzfOV4E9yYDHk6bsKu0OskAiAzoT+ebET1PLREB6jXyBx
        LLlRHYRA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nQ8Bk-00FCcj-A2; Fri, 04 Mar 2022 13:41:44 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8ADFC3001EA;
        Fri,  4 Mar 2022 14:41:42 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7550C201A4139; Fri,  4 Mar 2022 14:41:42 +0100 (CET)
Date:   Fri, 4 Mar 2022 14:41:42 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, H Peter Anvin <hpa@zytor.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Leo Yan <leo.yan@linaro.org>
Subject: Re: [PATCH V2 03/11] perf/x86: Add support for TSC in nanoseconds as
 a perf event clock
Message-ID: <YiIXFmA4vpcTSk2L@hirez.programming.kicks-ass.net>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
 <20220214110914.268126-4-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214110914.268126-4-adrian.hunter@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 01:09:06PM +0200, Adrian Hunter wrote:
> Currently, when Intel PT is used within a VM guest, it is not possible to
> make use of TSC because perf clock is subject to paravirtualization.

Yeah, so how much of that still makes sense, or ever did? AFAIK the
whole pv_clock thing is utter crazy. Should we not fix that instead?
