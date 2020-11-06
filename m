Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4482A9980
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 17:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgKFQcT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 11:32:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43327 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725868AbgKFQcT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 11:32:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604680337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+T0wh6v8l6lQUrvw4s9+AbRJQ2Z4GCUXzV2HD9+48LQ=;
        b=Gd9fdaexEpytto1wLRYrfQavVEFPbNkzrkwnVX20MLvESGqvcwKEFnsgLEhXavWZZuTglM
        8lgm7fm7oN/zWOzImmOhfS2JcCU0XAOSmT7IvnTEx25T+NpO5kcLT+BLfJgy3AxlgD4FfY
        63jo/DHArXq0vyHZF3A3xK/vV+N2kWg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-hcRXZq1dPjaMDveOEJbP9Q-1; Fri, 06 Nov 2020 11:32:15 -0500
X-MC-Unique: hcRXZq1dPjaMDveOEJbP9Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32D5A802B45;
        Fri,  6 Nov 2020 16:32:14 +0000 (UTC)
Received: from w520.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 602CE2619E;
        Fri,  6 Nov 2020 16:32:01 +0000 (UTC)
Date:   Fri, 6 Nov 2020 09:32:00 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/2] sched/wait: Add add_wait_queue_priority()
Message-ID: <20201106093200.6d8975ae@w520.home>
In-Reply-To: <f0901be7-1526-5b6a-90cb-6489e53cb92f@redhat.com>
References: <20201026175325.585623-1-dwmw2@infradead.org>
        <20201027143944.648769-1-dwmw2@infradead.org>
        <20201027143944.648769-2-dwmw2@infradead.org>
        <20201028143509.GA2628@hirez.programming.kicks-ass.net>
        <ef4660dba8135ca5a1dc7e854babcf65d8cef46f.camel@infradead.org>
        <f0901be7-1526-5b6a-90cb-6489e53cb92f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 6 Nov 2020 11:17:21 +0100
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 04/11/20 10:35, David Woodhouse wrote:
> > On Wed, 2020-10-28 at 15:35 +0100, Peter Zijlstra wrote:  
> >> On Tue, Oct 27, 2020 at 02:39:43PM +0000, David Woodhouse wrote:  
> >>> From: David Woodhouse <dwmw@amazon.co.uk>
> >>>
> >>> This allows an exclusive wait_queue_entry to be added at the head of the
> >>> queue, instead of the tail as normal. Thus, it gets to consume events
> >>> first without allowing non-exclusive waiters to be woken at all.
> >>>
> >>> The (first) intended use is for KVM IRQFD, which currently has
> >>> inconsistent behaviour depending on whether posted interrupts are
> >>> available or not. If they are, KVM will bypass the eventfd completely
> >>> and deliver interrupts directly to the appropriate vCPU. If not, events
> >>> are delivered through the eventfd and userspace will receive them when
> >>> polling on the eventfd.
> >>>
> >>> By using add_wait_queue_priority(), KVM will be able to consistently
> >>> consume events within the kernel without accidentally exposing them
> >>> to userspace when they're supposed to be bypassed. This, in turn, means
> >>> that userspace doesn't have to jump through hoops to avoid listening
> >>> on the erroneously noisy eventfd and injecting duplicate interrupts.
> >>>
> >>> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>  
> >>
> >> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>  
> > 
> > Thanks. Paolo, the conclusion was that you were going to take this set
> > through the KVM tree, wasn't it?
> >   
> 
> Queued, except for patch 2/3 in the eventfd series which Alex hasn't 
> reviewed/acked yet.

There was no vfio patch here, nor mention why it got dropped in v2
afaict.  Thanks,

Alex

