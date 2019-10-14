Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0DD9D61BB
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 13:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731359AbfJNLwS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 07:52:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56142 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730369AbfJNLwR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 07:52:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7VSr7BYb7+J2hDKY+7JG0niopCL5cvNnFzSou8GfhQQ=; b=EeyYP8IjsvAkXMNXfavRV9I8j
        eafH208u2y1jq2NjgLUZq5lnznDQ+L+tetsdLZaAoBq2s9Uj/0LNnVnpxP3qMsyMEtP2Br7VfD+KR
        Nx+zVESmeSsJGQg1BONDaXirf+hy8Yzjm3t8BeeRVunGQm73RedlC/q+8+P34GNdIPjlyp8qVqnWN
        EuCg7OU8EfI26+PHoR2LJkOLIxtbLMFgMYdlWwi04JLwxGfFF4TeKfGRl+9tz7u/xkgKdDgwK2/ZZ
        0fOd6ManRE7v12zs7/E1Pc0WeYMWvU4RhM2MnzmQvYt/gsGM2GuLvTIfUEZkNTjRaR3rrHev1IL71
        EVQggPzgw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iJytO-0007iT-61; Mon, 14 Oct 2019 11:52:02 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 0883D300F3F;
        Mon, 14 Oct 2019 13:51:04 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E411E200843F1; Mon, 14 Oct 2019 13:51:58 +0200 (CEST)
Date:   Mon, 14 Oct 2019 13:51:58 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] perf/core: Provide a kernel-internal interface to
 pause perf_event
Message-ID: <20191014115158.GC2328@hirez.programming.kicks-ass.net>
References: <20191013091533.12971-1-like.xu@linux.intel.com>
 <20191013091533.12971-3-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191013091533.12971-3-like.xu@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 13, 2019 at 05:15:31PM +0800, Like Xu wrote:
> Exporting perf_event_pause() as an external accessor for kernel users (such
> as KVM) who may do both disable perf_event and read count with just one
> time to hold perf_event_ctx_lock. Also the value could be reset optionally.

> +u64 perf_event_pause(struct perf_event *event, bool reset)
> +{
> +	struct perf_event_context *ctx;
> +	u64 count, enabled, running;
> +
> +	ctx = perf_event_ctx_lock(event);

> +	_perf_event_disable(event);
> +	count = __perf_event_read_value(event, &enabled, &running);
> +	if (reset)
> +		local64_set(&event->count, 0);

This local64_set() already assumes there are no child events, so maybe
write the thing like:

	WARN_ON_ONCE(event->attr.inherit);
	_perf_event_disable(event);
	count = local64_read(&event->count);
	local64_set(&event->count, 0);


> +	perf_event_ctx_unlock(event, ctx);
> +
> +	return count;
> +}
> +EXPORT_SYMBOL_GPL(perf_event_pause);
