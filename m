Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7080E8B8A
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2019 16:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389869AbfJ2PNX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 11:13:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41312 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389634AbfJ2PNX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Oct 2019 11:13:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wUNZyDj4/TJlrgXXw5bHvw6DqU7K35b88z8Tb9dvbUQ=; b=xP/x/gcBXpqOAHy735jtKrf/d
        IQ4ODLhdqcD6OdjDbijs52+YQ5NQvB2+e1tF0vHivEXSQUwq7dHkLms9C11FftFyzQMkEoHE+TO6s
        jyRzQYe3hEdcbaK1ucoCJA4klUDgdl/L3IKFl3P5PI7EurmbN68yTp00P69MAdcc/mSJXpSeEsfwV
        8OwfHkyzB7+jSJb5zRgI0y7dF1v8sKxjchdbGLc1OgovNcvjyTITcrDm56jOEClnYJ5BgXOzVrjav
        WIvcsbLZbg3Z1z6aqEmM6OzUQnhizgJyooZOeFxknrIPr6WHz2B/d6LGhDKQokE09v5fQQdQgCwqP
        n0mWv7Ezw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPTBA-0005Oi-6F; Tue, 29 Oct 2019 15:13:04 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 636AF306091;
        Tue, 29 Oct 2019 16:12:01 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2B8272B438376; Tue, 29 Oct 2019 16:13:02 +0100 (CET)
Date:   Tue, 29 Oct 2019 16:13:02 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Luwei Kang <luwei.kang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, ak@linux.intel.com, thomas.lendacky@amd.com,
        acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org
Subject: Re: [PATCH v1 8/8] perf/x86: Add event owner check when PEBS output
 to Intel PT
Message-ID: <20191029151302.GO4097@hirez.programming.kicks-ass.net>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
 <1572217877-26484-9-git-send-email-luwei.kang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572217877-26484-9-git-send-email-luwei.kang@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 27, 2019 at 07:11:17PM -0400, Luwei Kang wrote:
> For PEBS output to Intel PT, a Intel PT event should be the group
> leader of an PEBS counter event in host. For Intel PT
> virtualization enabling in KVM guest, the PT facilities will be
> passthrough to guest and do not allocate PT event from host perf
> event framework. This is different with PMU virtualization.
> 
> Intel new hardware feature that can make PEBS enabled in KVM guest
> by output PEBS records to Intel PT buffer. KVM need to allocate
> a event counter for this PEBS event without Intel PT event leader.
> 
> This patch add event owner check for PEBS output to PT event that
> only non-kernel event need group leader(PT).
> 
> Signed-off-by: Luwei Kang <luwei.kang@intel.com>
> ---
>  arch/x86/events/core.c     | 3 ++-
>  include/linux/perf_event.h | 1 +
>  kernel/events/core.c       | 2 +-
>  3 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 7b21455..214041a 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -1014,7 +1014,8 @@ static int collect_events(struct cpu_hw_events *cpuc, struct perf_event *leader,
>  		 * away, the group was broken down and this singleton event
>  		 * can't schedule any more.
>  		 */
> -		if (is_pebs_pt(leader) && !leader->aux_event)
> +		if (is_pebs_pt(leader) && !leader->aux_event &&
> +					!is_kernel_event(leader))

indent fail, but also, I'm not sure I buy this.

Surely pt-on-kvm has a perf event to claim PT for the vCPU context?

Even if not, this is not strictly correct. Not even now is KVM the sole
user of perf_event_create_kernel_counter(), so saying any kernel event
is excempt from this scheduling constraint is jsut wrong.

>  			return -EINVAL;
>  
>  		/*
