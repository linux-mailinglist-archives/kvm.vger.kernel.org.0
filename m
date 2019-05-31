Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B57D331511
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 21:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbfEaTGs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 15:06:48 -0400
Received: from smtprelay0112.hostedemail.com ([216.40.44.112]:39990 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726808AbfEaTGs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 May 2019 15:06:48 -0400
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 May 2019 15:06:47 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave03.hostedemail.com (Postfix) with ESMTP id C49CE1801BB75
        for <kvm@vger.kernel.org>; Fri, 31 May 2019 18:57:19 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 12990181D3377;
        Fri, 31 May 2019 18:57:18 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:599:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3874:4321:5007:6117:6119:6120:7901:7903:10004:10400:10848:11026:11232:11658:11914:12043:12048:12296:12740:12760:12895:13069:13255:13311:13357:13439:13548:14181:14659:14721:21080:21627:30029:30054:30056:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:26,LUA_SUMMARY:none
X-HE-Tag: sugar66_548a73896a2d
X-Filterd-Recvd-Size: 2569
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Fri, 31 May 2019 18:57:16 +0000 (UTC)
Message-ID: <53e1591ef288135f1dd803c15e971c96d06f54ba.camel@perches.com>
Subject: Re: [PATCH v2 2/2] KVM: LAPIC: remove the trailing newline used in
 the fmt parameter of TP_printk
From:   Joe Perches <joe@perches.com>
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Theodore Tso <tytso@mit.edu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date:   Fri, 31 May 2019 11:57:04 -0700
In-Reply-To: <1559284814-20378-2-git-send-email-wanpengli@tencent.com>
References: <1559284814-20378-1-git-send-email-wanpengli@tencent.com>
         <1559284814-20378-2-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2019-05-31 at 14:40 +0800, Wanpeng Li wrote:
> The trailing newlines will lead to extra newlines in the trace file
[]
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
[]
> @@ -1365,7 +1365,7 @@ TRACE_EVENT(kvm_hv_timer_state,
>  			__entry->vcpu_id = vcpu_id;
>  			__entry->hv_timer_in_use = hv_timer_in_use;
>  			),
> -		TP_printk("vcpu_id %x hv_timer %x\n",
> +		TP_printk("vcpu_id %x hv_timer %x",
>  			__entry->vcpu_id,
>  			__entry->hv_timer_in_use)
>  );

Not about the kvm subsystem, but generically there are
many of these that could be removed.

$ git grep -w TP_printk | grep '\\n' | wc -l
45

Also, aren't all TP_printk formats supposed to be single line?

If not, these are odd as well.

$ git grep -w TP_printk | grep '\\n[^"]'
include/trace/events/9p.h:	    TP_printk("clnt %lu %s(tag = %d)\n%.3x: %16ph\n%.3x: %16ph\n",
net/tipc/trace.h:	TP_printk("%s\n%s", __get_str(header), __get_str(buf))
net/tipc/trace.h:	TP_printk("%s\n%s", __get_str(header), __get_str(buf))
net/tipc/trace.h:	TP_printk("<%u> %s\n%s%s", __entry->portid, __get_str(header),
net/tipc/trace.h:	TP_printk("<%s> %s\n%s", __entry->name, __get_str(header),
net/tipc/trace.h:	TP_printk("<%x> %s\n%s", __entry->addr, __get_str(header),

Perhaps the documentation files around these formats
	Documentation/trace/events.rst
	Documentation/trace/tracepoints.rst
could be improved as well.


