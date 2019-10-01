Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B41EC2ECA
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 10:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732992AbfJAIXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 04:23:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58940 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfJAIXo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 04:23:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gGeaYFs4bdA7xPmyy+azgQMth/2oXWf7Tl63bP6CEY0=; b=ON+g6YOgA2qDnJ19wUIBM7ci9
        H9J9f3tU+TYT4GsARKS1FQo6vO6R4TSzSKGKW2tZ5QCxd+SlJt4mLXOTG69Xkzzauubswfg/FFXkK
        lRITm95PlUqBRnWcYb8lNbPAncGzPj+0zbO1mlxrpmjB3ztO9OPRHzugw2mGMHIXmTBSZPqKEcp1d
        yinEQLrAOdilPeFe3VoJdCty40HJSmJwT3/EiPvGhIbSawXrPmeXmZQXoMoi8hmnG+M6dBBYzZ7o2
        GOy57/OZoTPD+hH9vY7KC0Z+P7ZDqLD734paPaAK6XcJzmEW/JiHhJ+pXP5tpsuYrpoKiGCUv4uDz
        A31XxcIjQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iFDRM-0001wa-Tm; Tue, 01 Oct 2019 08:23:25 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7A8B7305E4E;
        Tue,  1 Oct 2019 10:22:33 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CDA4423E90CDA; Tue,  1 Oct 2019 10:23:21 +0200 (CEST)
Date:   Tue, 1 Oct 2019 10:23:21 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: x86/vPMU: Add lazy mechanism to release
 perf_event per vPMC
Message-ID: <20191001082321.GL4519@hirez.programming.kicks-ass.net>
References: <20190930072257.43352-1-like.xu@linux.intel.com>
 <20190930072257.43352-4-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930072257.43352-4-like.xu@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 30, 2019 at 03:22:57PM +0800, Like Xu wrote:
> +	union {
> +		u8 event_count :7; /* the total number of created perf_events */
> +		bool enable_cleanup :1;

That's atrocious, don't ever create a bitfield with base _Bool.

> +	} state;
