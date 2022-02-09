Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEDB4AF238
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 14:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbiBINAm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 08:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiBINAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 08:00:41 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDC7C0613CA;
        Wed,  9 Feb 2022 05:00:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WsOEfwHfdGK6OlGgVv/+90ZBfy4NMObfd2hptU6CEbw=; b=eBpZPsGk3XwEinAbJReC/9MJNC
        2cV45KnaMNFbX8Nqpgn9nXiQr8p8XcLefLEC+//XtVUO6tkbep1gjagjB64y+npGRpuGagRaGCmBr
        EFaXMMaJO2UKQZnA7aN/nyhLnhjBXi7W50WPpnR3/94GY3fjDRILwAdw3CA2jMzTaHFfMVBJR8iRq
        Pfx6627C5k1QbjV0WFayjVyysh+7vYE9W0vkrNvWhvpfwLDvMSkEcMNXLn/PmgghfI7PVsgZrx/rb
        AoGa1AYHpH6EPergMeDtyvoLVMdCAeU2XJYEK5G/XJ8jpReWdWRqx4apf2DVuIe7/9xCnwxiADZU/
        g6fyDIvQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHmaJ-007jI7-6Z; Wed, 09 Feb 2022 13:00:35 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A1D99300478;
        Wed,  9 Feb 2022 14:00:34 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8B30D265018D6; Wed,  9 Feb 2022 14:00:34 +0100 (CET)
Date:   Wed, 9 Feb 2022 14:00:34 +0100
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
Subject: Re: [PATCH 03/11] perf/x86: Add support for TSC in nanoseconds as a
 perf event clock
Message-ID: <YgO68ihU+ikg4QOa@hirez.programming.kicks-ass.net>
References: <20220209084929.54331-1-adrian.hunter@intel.com>
 <20220209084929.54331-4-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209084929.54331-4-adrian.hunter@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 09, 2022 at 10:49:21AM +0200, Adrian Hunter wrote:
> +	if (sched_clock_stable()) {
> +		offset = __sched_clock_offset;

The only sane behviour for !sched_clock_stable() is to completely refuse
service.
