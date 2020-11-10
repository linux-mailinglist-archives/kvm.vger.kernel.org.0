Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C622AD9E2
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 16:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731961AbgKJPNe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 10:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730981AbgKJPNe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 10:13:34 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B16C0613CF;
        Tue, 10 Nov 2020 07:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yfbAAv9z74vMPfwpK6dKFLRG/wgLDIDQH7gNqCp74iM=; b=X/P7RGRFOzuHDkfSWhHrq0oxGU
        a4SpAv+nTkiRzo1hMZ6JbF/TxR0o3K7jPnjwja3ywnq25LMYqArUclBG/EjYHBlIMfc6oGtg3Wbwk
        G6Ul3i3sNWw7cyTNjE86U3KtFq0FLG3FulaFLveDm8rgk/kka2L/zXCgmpa7H46K/FYHwu8XcAywp
        /FYsD0RUE/NuD+DxxfzdrzaWkm1dWexiGL3YQ/vEGF4nI9+c+4BzyoBd8aJcp1ClrwHPPaOPyplL9
        z2CxWO2G8ZzL1ZBoijg3CPMH0yZs5yIAzSZ/pZXBFaNkneeYl0XqnrR50NOLmRQwE8iCr/IRbSwwJ
        venWvckA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kcVKO-0006L3-9E; Tue, 10 Nov 2020 15:13:00 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 32FC5301E02;
        Tue, 10 Nov 2020 16:12:57 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 19AE920289CB5; Tue, 10 Nov 2020 16:12:57 +0100 (CET)
Date:   Tue, 10 Nov 2020 16:12:57 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>, luwei.kang@intel.com,
        Thomas Gleixner <tglx@linutronix.de>, wei.w.wang@intel.com,
        Tony Luck <tony.luck@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Mark Gross <mgross@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 00/17] KVM: x86/pmu: Add support to enable Guest
 PEBS via DS
Message-ID: <20201110151257.GP2611@hirez.programming.kicks-ass.net>
References: <20201109021254.79755-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109021254.79755-1-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 09, 2020 at 10:12:37AM +0800, Like Xu wrote:
> The Precise Event Based Sampling(PEBS) supported on Intel Ice Lake server
> platforms can provide an architectural state of the instruction executed
> after the instruction that caused the event. This patch set enables the
> the PEBS via DS feature for KVM (also non) Linux guest on the Ice Lake.
> The Linux guest can use PEBS feature like native:
> 
>   # perf record -e instructions:ppp ./br_instr a
>   # perf record -c 100000 -e instructions:pp ./br_instr a
> 
> If the counter_freezing is not enabled on the host, the guest PEBS will
> be disabled on purpose when host is using PEBS facility. By default,
> KVM disables the co-existence of guest PEBS and host PEBS.

Uuhh, what?!? counter_freezing should never be enabled, its broken. Let
me go delete all that code.
