Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 430584CD451
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 13:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239727AbiCDMei (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 07:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235385AbiCDMei (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 07:34:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD00419E0B8;
        Fri,  4 Mar 2022 04:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Vn48osy6LA6O0kSNq05QHzn6ctMgdZe+vT9bEcjUMXc=; b=E3mAYbqfGXVk4EGsJ1QRslJy3W
        8STGCwhWoiednWfw4fv8rRDtsKkzNQa3ZshUuH6ko11yL+FSgDDE1wbU9BzuEUY2qBNL0FlDRAyyY
        gQhYIJawBaLSXPF32OcImZmUzUYpfBiYeDTR2bUEi4WrEMnVs/4EGdwLflyzA3C819xiionRsoCS6
        ReurNJChVCxF+op20IXuTp9kfAFDZWZeEy7HVClBV7X86rlLU2lBqDWjpARoar26qo8TMJWwTRbf9
        rfKlwTUV+3CMhM+4+bIkTG38fPWmdUKge9H3+KtEjpYyZiILiQ2TzdQ1IBrRIW89UOBx8HdnX+j73
        1vhgDWHA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nQ77s-00CcrP-Pf; Fri, 04 Mar 2022 12:33:40 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 6CC34300230;
        Fri,  4 Mar 2022 13:33:40 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5C66F201A4139; Fri,  4 Mar 2022 13:33:40 +0100 (CET)
Date:   Fri, 4 Mar 2022 13:33:40 +0100
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
Subject: Re: [PATCH V2 02/11] perf/x86: Add support for TSC as a perf event
 clock
Message-ID: <YiIHJAfqY0XKsmya@hirez.programming.kicks-ass.net>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
 <20220214110914.268126-3-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214110914.268126-3-adrian.hunter@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 01:09:05PM +0200, Adrian Hunter wrote:
> +u64 perf_hw_clock(void)
> +{
> +	return rdtsc_ordered();
> +}

Why the _ordered ?
