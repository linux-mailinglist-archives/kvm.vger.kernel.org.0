Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931E250269E
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 10:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351363AbiDOI22 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 04:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiDOI20 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 04:28:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8439AAB47;
        Fri, 15 Apr 2022 01:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3wN74fu5w+jCy3hi8iGGJYQXAXjvPWi0PsASSr2Y7Dc=; b=qB+tQbvLGYevQ0Oht3Gx0nbcRm
        qdtuhUtZl9ToQzFaFI8dFYLvW4wMdTiO+uu5llhZGKwdake5TtTPjudt7yACs6bhOLM7jv+XQKPGU
        nRwpmVKVigyKF2dgs5JKUdPHfFQGtHwD07owR+aC0YV3yOxRnfs9J8+g/IYO0P+eHL/cgexQ5gTty
        TMtHlkrbyO00YbHKGphJQcP6RndiOaYIxd4vzwWaRx5JwzQR9vkoNdbFNVa9VDR1BZ0ia76rZoYl4
        7IQdUjVcRsXKnaCi9tn0ijyAeCB2Lx0fhxKyascV4NxGh5zXKrVUH7v0k/xjQsnx/cf1cwJdRJPeh
        zkVtm7Sg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nfHGu-00Fy61-OS; Fri, 15 Apr 2022 08:25:40 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 008BE3002DE;
        Fri, 15 Apr 2022 10:25:39 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 95920202508B9; Fri, 15 Apr 2022 10:25:39 +0200 (CEST)
Date:   Fri, 15 Apr 2022 10:25:39 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: Re: [PATCH v3 09/11] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
Message-ID: <YlksA1gR0ehoU2VP@hirez.programming.kicks-ass.net>
References: <20220411093537.11558-1-likexu@tencent.com>
 <20220411093537.11558-10-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411093537.11558-10-likexu@tencent.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 11, 2022 at 05:35:35PM +0800, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Currently, we have [intel|knc|p4|p6]_perfmon_event_map on the Intel
> platforms and amd_[f17h]_perfmon_event_map on the AMD platforms.
> 
> Early clumsy KVM code or other potential perf_event users may have
> hard-coded these perfmon_maps (e.g., arch/x86/kvm/svm/pmu.c), so
> it would not make sense to program a common hardware event based
> on the generic "enum perf_hw_id" once the two tables do not match.
> 
> Let's provide an interface for callers outside the perf subsystem to get
> the counter config based on the perfmon_event_map currently in use,
> and it also helps to save bytes.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Like Xu <likexu@tencent.com>

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
