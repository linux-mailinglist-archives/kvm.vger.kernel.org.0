Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA592DC4D2
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 17:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgLPQ5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 11:57:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30133 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726758AbgLPQ5y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 11:57:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608137788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uFK8uelp0EfnpwVsJ+unzlDIADvPHcDnDcvCpIi/i5Q=;
        b=Io3a8dedCCojU8qha1MJOPbLdJ+pBKOczipvPb5Q7+kcTaLeVdPcS0OqePg69ngqK8vv2U
        iaz2eqVPaG1li3JdGdgyFoWGbmyd8Mq7nWvDUaPPyK0mdyRtOk7Dr5y5MIv1ecM5n//anA
        9/RvU9ygjfMJIHXPySjK59yOb3g1qRk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-crZqldqkO2O1uPxUIhu4fA-1; Wed, 16 Dec 2020 11:56:25 -0500
X-MC-Unique: crZqldqkO2O1uPxUIhu4fA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59FF580400F;
        Wed, 16 Dec 2020 16:56:20 +0000 (UTC)
Received: from treble (ovpn-112-170.rdu2.redhat.com [10.10.112.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 860D160CD0;
        Wed, 16 Dec 2020 16:56:07 +0000 (UTC)
Date:   Wed, 16 Dec 2020 10:56:05 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     =?utf-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org, luto@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Deep Shah <sdeep@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Subject: Re: [PATCH v2 00/12] x86: major paravirt cleanup
Message-ID: <20201216165605.4h5q7os5dutjgdqi@treble>
References: <20201120114630.13552-1-jgross@suse.com>
 <20201120125342.GC3040@hirez.programming.kicks-ass.net>
 <20201123134317.GE3092@hirez.programming.kicks-ass.net>
 <6771a12c-051d-1655-fb3a-cc45a3c82e29@suse.com>
 <20201215141834.GG3040@hirez.programming.kicks-ass.net>
 <20201215145408.GR3092@hirez.programming.kicks-ass.net>
 <20201216003802.5fpklvx37yuiufrt@treble>
 <20201216084059.GL3040@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201216084059.GL3040@hirez.programming.kicks-ass.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 16, 2020 at 09:40:59AM +0100, Peter Zijlstra wrote:
> > So much algorithm.
> 
> :-)
> 
> It's not really hard, but it has a few pesky details (as always).

It really hurt my brain to look at it.

> > Could we make it easier by caching the shared
> > per-alt-group CFI state somewhere along the way?
> 
> Yes, but when I tried it grew the code required. Runtime costs would be
> less, but I figured that since alternatives are typically few and small,
> that wasn't a real consideration.

Aren't alternatives going to be everywhere now with paravirt using them?

> That is, it would basically cache the results of find_alt_unwind(), but
> you still need find_alt_unwind() to generate that data, and so you gain
> the code for filling and using the extra data structure.
> 
> Yes, computing it 3 times is naf, but meh.

Haha, I loved this sentence.

> > Thoughts?  This is all theoretical of course, I could try to do a patch
> > tomorrow.
> 
> No real objection, I just didn't do it because 1) it works, and 2) even
> moar lines.

I'm kind of surprised it would need moar lines.  Let me play around with
it and maybe I'll come around ;-)

-- 
Josh

