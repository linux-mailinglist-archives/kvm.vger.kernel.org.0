Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976CB3BA356
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 18:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhGBQpI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 12:45:08 -0400
Received: from smtprelay0071.hostedemail.com ([216.40.44.71]:58906 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229455AbhGBQpI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Jul 2021 12:45:08 -0400
Received: from omf19.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id C507B180A9C91;
        Fri,  2 Jul 2021 16:42:34 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf19.hostedemail.com (Postfix) with ESMTPA id 10EBB20D764;
        Fri,  2 Jul 2021 16:42:26 +0000 (UTC)
Message-ID: <34a668a0606092990326207d2acc5441592756d6.camel@perches.com>
Subject: Re: [PATCH V7 01/18] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
From:   Joe Perches <joe@perches.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>, pbonzini@redhat.com,
        bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        weijiang.yang@intel.com, kan.liang@linux.intel.com,
        ak@linux.intel.com, wei.w.wang@intel.com, eranian@google.com,
        liuxiangdong5@huawei.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, like.xu.linux@gmail.com,
        Like Xu <like.xu@linux.intel.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Guo Ren <guoren@kernel.org>, Nick Hu <nickhu@andestech.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        xen-devel@lists.xenproject.org
Date:   Fri, 02 Jul 2021 09:42:25 -0700
In-Reply-To: <YN88rE+cxb7HrEtI@hirez.programming.kicks-ass.net>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
         <20210622094306.8336-2-lingshan.zhu@intel.com>
         <YN722HIrzc6Z2+oD@hirez.programming.kicks-ass.net>
         <7379289718c6826dd1affec5824b749be2aee0a4.camel@perches.com>
         <YN88rE+cxb7HrEtI@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.40
X-Stat-Signature: ycuw4tc4dkddxofnskkdygh116nc5379
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 10EBB20D764
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18HOccKXnefKVhqRarv+ICfPC7oSScH3Ls=
X-HE-Tag: 1625244146-824246
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-07-02 at 18:19 +0200, Peter Zijlstra wrote:
> On Fri, Jul 02, 2021 at 09:00:22AM -0700, Joe Perches wrote:
> > On Fri, 2021-07-02 at 13:22 +0200, Peter Zijlstra wrote:
> > > On Tue, Jun 22, 2021 at 05:42:49PM +0800, Zhu Lingshan wrote:
> > > > diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> > []
> > > > +	if (perf_guest_cbs && perf_guest_cbs->handle_intel_pt_intr)
> > > > +		static_call_update(x86_guest_handle_intel_pt_intr,
> > > > +				   perf_guest_cbs->handle_intel_pt_intr);
> > > > +}
> > > 
> > > Coding style wants { } on that last if().
> > 
> > That's just your personal preference.
> 
> As a maintainer, those carry weight, also that's tip rules:
> 
>   https://lore.kernel.org/lkml/20181107171149.165693799@linutronix.de/

Right, definitely so.

But merely referencing 'coding style' is ambiguous at best.

btw:

ASCII commonly refers to '{' and '}', the curly brackets, to be braces
and '[' and ']', the square brackets, to be brackets.

It might be clearer to use that terminology.

belts and braces, etc...

cheers, Joe

----------------

+Bracket rules
+^^^^^^^^^^^^^
+
+Brackets should be omitted only if the statement which follows 'if', 'for',
+'while' etc. is truly a single line::
+
+	if (foo)
+		do_something();
+
+The following is not considered to be a single line statement even
+though C does not require brackets::
+
+	for (i = 0; i < end; i++)
+		if (foo[i])
+			do_something(foo[i]);
+
+Adding brackets around the outer loop enhances the reading flow::
+
+	for (i = 0; i < end; i++) {
+		if (foo[i])
+			do_something(foo[i]);
+	}


