Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5361A17BF9A
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 14:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgCFNxy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 08:53:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59214 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbgCFNxy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 08:53:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TvqxgncBv+tYz2iLtFMaeCImn2/6WxUyTqpfABjn9is=; b=Io8IWba5uLU8SqCXUJ77L2t1ia
        ZduZH4h0JWEmp2q4yD4xGCJ2RZdk4HUvHaDvH7QjjBw5H1zE8VE9yxta9iNFsPYLCZc8YuSwjpVlr
        rHXrPv3AZatPAvR6rOZdFlJjId0KJ+tyqZUTXskoLVHRRlXf+bcO7zD+vPT2QcJSFbX9Nj5DFxfsa
        AM/Z6M6wzy8IuSi/nlVYZDZK0VTZnuzxvn7osMG5FUcDeA3/s3GEdhPx+muHEC0fsZw6eUyH/RF4L
        HMPRD6E0QHTFOFJKaZDGIuHS2/rqs8NTB1Y+0DrKkX6YfoGjpRhZgvEiZIfft3/NJsInJ5wpCRvxM
        m3ldK9+A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jADPl-0007sV-9x; Fri, 06 Mar 2020 13:53:21 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9D1F83035D4;
        Fri,  6 Mar 2020 14:53:17 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8046C20286A0B; Fri,  6 Mar 2020 14:53:17 +0100 (CET)
Date:   Fri, 6 Mar 2020 14:53:17 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Luwei Kang <luwei.kang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, tglx@linutronix.de, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        pawan.kumar.gupta@linux.intel.com, ak@linux.intel.com,
        thomas.lendacky@amd.com, fenghua.yu@intel.com,
        kan.liang@linux.intel.com, like.xu@linux.intel.com
Subject: Re: [PATCH v1 01/11] perf/x86/core: Support KVM to assign a
 dedicated counter for guest PEBS
Message-ID: <20200306135317.GD12561@hirez.programming.kicks-ass.net>
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
 <1583431025-19802-2-git-send-email-luwei.kang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583431025-19802-2-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 06, 2020 at 01:56:55AM +0800, Luwei Kang wrote:
> From: Kan Liang <kan.liang@linux.intel.com>
> 
> The PEBS event created by host needs to be assigned specific counters
> requested by the guest, which means the guest and host counter indexes
> have to be the same or fail to create. This is needed because PEBS leaks
> counter indexes into the guest. Otherwise, the guest driver will be
> confused by the counter indexes in the status field of the PEBS record.
> 
> A guest_dedicated_idx field is added to indicate the counter index
> specifically requested by KVM. The dedicated event constraints would
> constrain the counter in the host to the same numbered counter in guest.
> 
> A intel_ctrl_guest_dedicated_mask field is added to indicate the enabled
> counters for guest PEBS events. The IA32_PEBS_ENABLE MSR will be switched
> during the VMX transitions if intel_ctrl_guest_owned is set.
> 

> +	/* the guest specified counter index of KVM owned event, e.g PEBS */
> +	int				guest_dedicated_idx;

We've always objected to guest 'owned' counters, they destroy scheduling
freedom. Why are you expecting that to be any different this time?
