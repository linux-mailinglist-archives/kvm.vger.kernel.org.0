Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A46D63521
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 13:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfGILqP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 07:46:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37700 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfGILqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 07:46:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RhpUavX3vbcOLn7vixcej5cSL4YtkOwjsTEyylpANYk=; b=Rwzl/RiBE0JKBZle7CY/uKMh9
        3rMg/EFkiJOgN7xmvsg60CfJr527j4CZPmkaYWQUwXyD/S4gQv5DBZ4HaUrNKzquxKbWHKkdEkNTG
        I/KfWe7GeaJrlEiPibsqmgT30bYh7vVdVYfUQjVyPy9GSf/ge+0hfZJVrb+OhMYNgKL/QTcL+UqrX
        Ut5DPG7WblBnaoYXLCt4l3uNkdsgz0A4JJUePbUsn1rMHInzZKepet0tBYw+eALEQAA6ZX62tGr8L
        GNbk6/ozZS4sHc5fi2ppq0OeqaqTNt8iZBe1JXkVUSFGibMbdT6vgdiSPHpsXApESWmKC8NkMx/jq
        kuIfY8YKA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hkoZI-0006My-2z; Tue, 09 Jul 2019 11:45:56 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CD84020120CB1; Tue,  9 Jul 2019 13:45:54 +0200 (CEST)
Date:   Tue, 9 Jul 2019 13:45:54 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, ak@linux.intel.com, kan.liang@intel.com,
        mingo@redhat.com, rkrcmar@redhat.com, like.xu@intel.com,
        jannh@google.com, arei.gonglei@huawei.com, jmattson@google.com
Subject: Re: [PATCH v7 08/12] KVM/x86/vPMU: Add APIs to support host
 save/restore the guest lbr stack
Message-ID: <20190709114554.GW3402@hirez.programming.kicks-ass.net>
References: <1562548999-37095-1-git-send-email-wei.w.wang@intel.com>
 <1562548999-37095-9-git-send-email-wei.w.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562548999-37095-9-git-send-email-wei.w.wang@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 08, 2019 at 09:23:15AM +0800, Wei Wang wrote:
> +int intel_pmu_enable_save_guest_lbr(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	struct perf_event *event;
> +
> +	/*
> +	 * The main purpose of this perf event is to have the host perf core
> +	 * help save/restore the guest lbr stack on vcpu switching. There is
> +	 * no perf counters allocated for the event.
> +	 *
> +	 * About the attr:
> +	 * exclude_guest: set to true to indicate that the event runs on the
> +	 *                host only.

That's a lie; it _never_ runs. You specifically don't want the host to
enable LBR so as not to corrupt the guest state.

> +	 * pinned:        set to false, so that the FLEXIBLE events will not
> +	 *                be rescheduled for this event which actually doesn't
> +	 *                need a perf counter.

Unparsable gibberish. Specifically by making it flexible it is
susceptible to rotation and there's no guarantee it will actually get
scheduled.

> +	 * config:        Actually this field won't be used by the perf core
> +	 *                as this event doesn't have a perf counter.
> +	 * sample_period: Same as above.

If it's unused; why do we need to set it at all?

> +	 * sample_type:   tells the perf core that it is an lbr event.
> +	 * branch_sample_type: tells the perf core that the lbr event works in
> +	 *                the user callstack mode so that the lbr stack will be
> +	 *                saved/restored on vCPU switching.

Again; doesn't make sense. What does the user part have to do with
save/restore? What happens when this vcpu thread drops to userspace for
an assist?

> +	 */
> +	struct perf_event_attr attr = {
> +		.type = PERF_TYPE_RAW,
> +		.size = sizeof(attr),
> +		.exclude_guest = true,
> +		.pinned = false,
> +		.config = 0,
> +		.sample_period = 0,
> +		.sample_type = PERF_SAMPLE_BRANCH_STACK,
> +		.branch_sample_type = PERF_SAMPLE_BRANCH_CALL_STACK |
> +				      PERF_SAMPLE_BRANCH_USER,
> +	};
> +
> +	if (pmu->vcpu_lbr_event)
> +		return 0;
> +
> +	event = perf_event_create(&attr, -1, current, NULL, NULL, false);
> +	if (IS_ERR(event)) {
> +		pr_err("%s: failed %ld\n", __func__, PTR_ERR(event));
> +		return -ENOENT;
> +	}
> +	pmu->vcpu_lbr_event = event;
> +
> +	return 0;
> +}
