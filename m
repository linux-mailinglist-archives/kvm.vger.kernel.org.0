Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61AF016D72
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 00:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfEGWPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 18:15:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58226 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfEGWPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 18:15:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6yspUXhtCc5m+Xrh7rQU5TbEjYHPNSoicVC5+DlX5Cg=; b=m3D0K/ULVXwGwo+zbxza8nByV
        HEf9WGJHMR4KTMjQTaF4YfKpdbjDL16lsK5XZhKzB0WCtGd9/hvNet8KhuMG5dtPP/hGFjQq8PEby
        b4H0zX+lTirtYPemlhvHOie8qZHguV24Smx844h0RQU+dh3Tc0toxCgkdL72+gzBHoTL9W3CB8CAy
        MsieQdnQlttpH2w50kyEKWRqn6tOo9k+jlnxtS1taPyD7L9Og59DXvQ0iGT/6xmRTPvHkp6J+BrqA
        FhHCFP5Crf4RpoZREsp7s/GhTeMRy5UvKBTzvxMEWXBNpf0+CmbOBoEvjS45JclARZ0DiWx0klnzV
        7kBy1cQxQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hO8Mr-0005to-EI; Tue, 07 May 2019 22:15:21 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B87C920D0941D; Wed,  8 May 2019 00:15:19 +0200 (CEST)
Date:   Wed, 8 May 2019 00:15:19 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Bandan Das <bsd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] sched: introduce configurable delay before entering idle
Message-ID: <20190507221519.GE2677@hirez.programming.kicks-ass.net>
References: <20190507185647.GA29409@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507185647.GA29409@amt.cnet>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 07, 2019 at 03:56:49PM -0300, Marcelo Tosatti wrote:
> 
> Certain workloads perform poorly on KVM compared to baremetal
> due to baremetal's ability to perform mwait on NEED_RESCHED
> bit of task flags (therefore skipping the IPI).
> 
> This patch introduces a configurable busy-wait delay before entering the
> architecture delay routine, allowing wakeup IPIs to be skipped 
> (if the IPI happens in that window).
> 
> The real-life workload which this patch improves performance
> is SAP HANA (by 5-10%) (for which case setting idle_spin to 30 
> is sufficient).
> 
> This patch improves the attached server.py and client.py example 
> as follows:
> 
> Host:                           31.814230202231556
> Guest:                          38.17718765199993       (83 %)
> Guest, idle_spin=50us:          33.317709898000004      (95 %)
> Guest, idle_spin=220us:         32.27826551499999       (98 %)
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Thanks for the CC..

NAK, this is something that should live in a virt idle governor or
something along those lines.
