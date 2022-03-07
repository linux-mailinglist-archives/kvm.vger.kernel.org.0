Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE3E34CF91F
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 11:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239851AbiCGKDk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 05:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241202AbiCGKBq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 05:01:46 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE53171C9F;
        Mon,  7 Mar 2022 01:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=F33OJew4f+X9EGyrX9UFDzNmD+8SJD5GlTnGdBvVako=; b=l29VVU0vNjudQfmRlD//2Ai5r4
        Rb+GvW9iJclOfRU4GCvEkvP37BglXQGkWNdbR9UtqNDH7Bd7uNMQTzk6GQO/3RrgBAK92YJPN+Gxz
        hmdhnmemQGbjdAakq68Sl3xDp2W7oSx7yoYDF+U55QRcn1hqpaDZX/h1Zyw3Sv7rLP/+rdGyTBYZA
        irmfqZgm8l2HmkKiZZ31K7VhEMil+fheol+qvc06hlmbEo4d8FiIGMLtmGd3lA47z7T/HYJz48Sge
        QILp/zYvt2fLhpl9YQcEH7SYyGRpLEYHP4sDoMdMnAg5VRIOhIN4hykzWAtmP/fB3VicXW0j1V6fh
        ioJsNaJw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRA16-00F53J-8g; Mon, 07 Mar 2022 09:51:00 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 513993002BE;
        Mon,  7 Mar 2022 10:50:57 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id EC3C92BA7BE19; Mon,  7 Mar 2022 10:50:56 +0100 (CET)
Date:   Mon, 7 Mar 2022 10:50:56 +0100
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
        Leo Yan <leo.yan@linaro.org>, jgross@suse.com,
        sdeep@vmware.com, pv-drivers@vmware.com, pbonzini@redhat.com,
        seanjc@google.com, kys@microsoft.com, sthemmin@microsoft.com,
        virtualization@lists.linux-foundation.org,
        Andrew.Cooper3@citrix.com
Subject: Re: [PATCH V2 03/11] perf/x86: Add support for TSC in nanoseconds as
 a perf event clock
Message-ID: <YiXVgEk/1UClkygX@hirez.programming.kicks-ass.net>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
 <20220214110914.268126-4-adrian.hunter@intel.com>
 <YiIXFmA4vpcTSk2L@hirez.programming.kicks-ass.net>
 <853ce127-25f0-d0fe-1d8f-0b0dd4f3ce71@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <853ce127-25f0-d0fe-1d8f-0b0dd4f3ce71@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 04, 2022 at 08:27:45PM +0200, Adrian Hunter wrote:
> On 04/03/2022 15:41, Peter Zijlstra wrote:
> > On Mon, Feb 14, 2022 at 01:09:06PM +0200, Adrian Hunter wrote:
> >> Currently, when Intel PT is used within a VM guest, it is not possible to
> >> make use of TSC because perf clock is subject to paravirtualization.
> > 
> > Yeah, so how much of that still makes sense, or ever did? AFAIK the
> > whole pv_clock thing is utter crazy. Should we not fix that instead?
> 
> Presumably pv_clock must work with different host operating systems.
> Similarly, KVM must work with different guest operating systems.
> Perhaps I'm wrong, but I imagine re-engineering time virtualization
> might be a pretty big deal,  far exceeding the scope of these patches.

I think not; on both counts. That is, I don't think it's going to be
hard, and even it if were, it would still be the right thing to do.

We're not going to add interface just to work around a known broken
piece of crap just because we don't want to fix it.

So I'm thinking we should do the below and simply ignore any paravirt
sched clock offered when there's ART on.

---
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 4420499f7bb4..a1f179ed39bf 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -145,6 +145,15 @@ DEFINE_STATIC_CALL(pv_sched_clock, native_sched_clock);
 
 void paravirt_set_sched_clock(u64 (*func)(void))
 {
+	/*
+	 * Anything with ART on promises to have sane TSC, otherwise the whole
+	 * ART thing is useless. In order to make ART useful for guests, we
+	 * should continue to use the TSC. As such, ignore any paravirt
+	 * muckery.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_ART))
+		return;
+
 	static_call_update(pv_sched_clock, func);
 }
 
