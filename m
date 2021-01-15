Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225592F77BF
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 12:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbhAOLgj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 06:36:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbhAOLgi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 06:36:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530B6C061757;
        Fri, 15 Jan 2021 03:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=n7b0j6ZnpjR0uvwKHqBC1yHKTSPAWtivnsJi023r8K0=; b=qNRd6LPZfN2CdKG5QAOhJagyVF
        cPLXOcZm47U6c3wfPxXh9E9m5YyF9zFOHBHQgyrKXY/wc7YovPAXM0gKwIm/PHBjvQY3E2TdYaeKS
        Ep7ZBLzdqMIOZ+DbNOEceKeXj2A5cbL5fnxjtNCh9BWyQQSYyIiiI4aZ0KEEtKHk0zUbKycAYvNkw
        UV37TFJa/Mr/JAe6eKekEmRALKpWkPg8Dpcwh1gzbbFsSqsl6Jwuiz44luGK7pUzUquPKB8Riu1EW
        nTGKa8IgDVu3N/5xK9YgEsZe73OeIkiIRM6uUHb1GESY+AQorfEfm+TBtpRZEFBGCY1pD9Fbjshne
        rNHMPRww==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l0NMZ-008qrT-49; Fri, 15 Jan 2021 11:34:17 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E63A0301324;
        Fri, 15 Jan 2021 12:33:46 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CA6622C9CD1CD; Fri, 15 Jan 2021 12:33:46 +0100 (CET)
Date:   Fri, 15 Jan 2021 12:33:46 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>,
        Kan Liang <kan.liang@linux.intel.com>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 05/17] KVM: x86/pmu: Reprogram guest PEBS event to
 emulate guest PEBS counter
Message-ID: <YAF9mulfhGCIyNz+@hirez.programming.kicks-ass.net>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <20210104131542.495413-6-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104131542.495413-6-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 04, 2021 at 09:15:30PM +0800, Like Xu wrote:
> When a guest counter is configured as a PEBS counter through
> IA32_PEBS_ENABLE, a guest PEBS event will be reprogrammed by
> configuring a non-zero precision level in the perf_event_attr.
> 
> The guest PEBS overflow PMI bit would be set in the guest
> GLOBAL_STATUS MSR when PEBS facility generates a PEBS
> overflow PMI based on guest IA32_DS_AREA MSR.
> 
> The attr.precise_ip would be adjusted to a special precision
> level when the new PEBS-PDIR feature is supported later which
> would affect the host counters scheduling.

This seems like a random collection of changes, all required, but
loosely related.

> The guest PEBS event would not be reused for non-PEBS
> guest event even with the same guest counter index.

/me rolls eyes at the whole destroy+create nonsense...
