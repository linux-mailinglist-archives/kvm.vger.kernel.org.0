Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1540030341E
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 06:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731416AbhAZFQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727949AbhAYMVC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 07:21:02 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FA5C0611BE;
        Mon, 25 Jan 2021 03:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XQNE380mf8MyZPTbvq3CiyPi2sBRm44UXxzB0gfGkD8=; b=PD6nPFC3TKsP3y4tBWF47SfUrg
        WemPXWK/Gk/CQp3LT7qeRWpKVbve3/xouiNU9MVX7yrGhwPO1GADoXiOX/WUPiHn2Qycd7cWDo2U6
        mIkub09hhBk8n6BVJ7+buDgvZXZZ+nM9pvGDdAs6RozEPZYHrBMrFhQkwNeD6/somQuov6s8unJeW
        OmdwK5FP90gSvmP4xMPMqQlIdGKnAAIYWL8PZIhNubhFbtxB/zNC1ASbJWEgC3geIa/8JQdd3HN4n
        qQ8PcUwLsO1ez5AUricnaIeKq4nXgCxOP2HeMooUZ//Dm/KO9olK26kJ2v7R9iYYzR28Sf3BcJK7A
        +vWRvPKg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l40L8-0002jt-IO; Mon, 25 Jan 2021 11:47:26 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 728C0300DB4;
        Mon, 25 Jan 2021 12:47:24 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 04B902B0615EF; Mon, 25 Jan 2021 12:47:23 +0100 (CET)
Date:   Mon, 25 Jan 2021 12:47:23 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org,
        "Xu, Like" <like.xu@intel.com>
Subject: Re: [PATCH v3 04/17] perf: x86/ds: Handle guest PEBS overflow PMI
 and inject it to guest
Message-ID: <YA6vy509FT8IUddS@hirez.programming.kicks-ass.net>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <20210104131542.495413-5-like.xu@linux.intel.com>
 <X/86UWuV/9yt14hQ@hirez.programming.kicks-ass.net>
 <9c343e40-bbdf-8af0-3307-5274070ee3d2@intel.com>
 <YAGEFgqQv281jVHc@hirez.programming.kicks-ass.net>
 <2c197d5a-09a8-968c-a942-c95d18983c9d@intel.com>
 <YAGqWNl2FKxVussV@hirez.programming.kicks-ass.net>
 <ed5b16cb-30c7-dab7-92c3-b70ba8483d1e@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed5b16cb-30c7-dab7-92c3-b70ba8483d1e@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 25, 2021 at 04:26:22PM +0800, Like Xu wrote:

> In the host and guest PEBS both enabled case,
> we'll get a crazy dmesg *bombing* about spurious PMI warning
> if we pass the host PEBS PMI "harmlessly" to the guest:
> 
> [11261.502536] Uhhuh. NMI received for unknown reason 2c on CPU 36.
> [11261.502539] Do you have a strange power saving mode enabled?
> [11261.502541] Dazed and confused, but trying to continue

How? AFAICT handle_pmi_common() will increment handled when
GLOBAL_STATUS_BUFFER_OVF_BIT is set, irrespective of DS containing
data.


