Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD843A227
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2019 23:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727625AbfFHV1M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Jun 2019 17:27:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727456AbfFHV1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Jun 2019 17:27:12 -0400
Received: from oasis.local.home (unknown [12.156.218.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC1EB208E3;
        Sat,  8 Jun 2019 21:27:10 +0000 (UTC)
Date:   Sat, 8 Jun 2019 17:27:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Joe Perches <joe@perches.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Theodore Tso <tytso@mit.edu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v2 2/2] KVM: LAPIC: remove the trailing newline used in
 the fmt parameter of TP_printk
Message-ID: <20190608172708.172594be@oasis.local.home>
In-Reply-To: <53e1591ef288135f1dd803c15e971c96d06f54ba.camel@perches.com>
References: <1559284814-20378-1-git-send-email-wanpengli@tencent.com>
        <1559284814-20378-2-git-send-email-wanpengli@tencent.com>
        <53e1591ef288135f1dd803c15e971c96d06f54ba.camel@perches.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 31 May 2019 11:57:04 -0700
Joe Perches <joe@perches.com> wrote:

> On Fri, 2019-05-31 at 14:40 +0800, Wanpeng Li wrote:
> > The trailing newlines will lead to extra newlines in the trace file  
> []
> > diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h  
> []
> > @@ -1365,7 +1365,7 @@ TRACE_EVENT(kvm_hv_timer_state,
> >  			__entry->vcpu_id = vcpu_id;
> >  			__entry->hv_timer_in_use = hv_timer_in_use;
> >  			),
> > -		TP_printk("vcpu_id %x hv_timer %x\n",
> > +		TP_printk("vcpu_id %x hv_timer %x",
> >  			__entry->vcpu_id,
> >  			__entry->hv_timer_in_use)
> >  );  
> 
> Not about the kvm subsystem, but generically there are
> many of these that could be removed.
> 
> $ git grep -w TP_printk | grep '\\n' | wc -l
> 45
> 
> Also, aren't all TP_printk formats supposed to be single line?

Yeah they should be, otherwise it makes the trace look funny. We do
have some legitimate ones (stack traces for example), but really,
unless there's a good reason, it shouldn't have them.

> 
> If not, these are odd as well.
> 
> $ git grep -w TP_printk | grep '\\n[^"]'
> include/trace/events/9p.h:	    TP_printk("clnt %lu %s(tag = %d)\n%.3x: %16ph\n%.3x: %16ph\n",
> net/tipc/trace.h:	TP_printk("%s\n%s", __get_str(header), __get_str(buf))
> net/tipc/trace.h:	TP_printk("%s\n%s", __get_str(header), __get_str(buf))
> net/tipc/trace.h:	TP_printk("<%u> %s\n%s%s", __entry->portid, __get_str(header),
> net/tipc/trace.h:	TP_printk("<%s> %s\n%s", __entry->name, __get_str(header),
> net/tipc/trace.h:	TP_printk("<%x> %s\n%s", __entry->addr, __get_str(header),
> 
> Perhaps the documentation files around these formats
> 	Documentation/trace/events.rst
> 	Documentation/trace/tracepoints.rst
> could be improved as well.
> 

Sure, like most documentation ;-)

-- Steve
