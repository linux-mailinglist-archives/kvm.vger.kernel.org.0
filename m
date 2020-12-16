Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A852DB7DB
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 01:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgLPAki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 19:40:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38583 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726097AbgLPAkd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Dec 2020 19:40:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608079147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BCyr+zCzlSHQ1KjMAt3Zb/a+qisNyayFH7/e91jTxqk=;
        b=Snze6ynPda7VvaiqdJe7E9l3GeM58gKaIloPQs+ANvI1sEK34ZibQBIx+MxhhjuvUcDIDP
        EeD3idBJARoX/pc3LR7k5Wn75nvXJMwOIqNEM5KXsQ5nSvEudETMIJVoQF+/OSHxgDM98H
        84Aiayq3rfDJ8KNllsHRt/GplGB9CO8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-wYBKR5ESPACLwIRJr6G_JA-1; Tue, 15 Dec 2020 19:39:03 -0500
X-MC-Unique: wYBKR5ESPACLwIRJr6G_JA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B14061054F8E;
        Wed, 16 Dec 2020 00:38:10 +0000 (UTC)
Received: from treble (ovpn-112-170.rdu2.redhat.com [10.10.112.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 44CAF5DD87;
        Wed, 16 Dec 2020 00:38:04 +0000 (UTC)
Date:   Tue, 15 Dec 2020 18:38:02 -0600
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
Message-ID: <20201216003802.5fpklvx37yuiufrt@treble>
References: <20201120114630.13552-1-jgross@suse.com>
 <20201120125342.GC3040@hirez.programming.kicks-ass.net>
 <20201123134317.GE3092@hirez.programming.kicks-ass.net>
 <6771a12c-051d-1655-fb3a-cc45a3c82e29@suse.com>
 <20201215141834.GG3040@hirez.programming.kicks-ass.net>
 <20201215145408.GR3092@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201215145408.GR3092@hirez.programming.kicks-ass.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 15, 2020 at 03:54:08PM +0100, Peter Zijlstra wrote:
> The problem is that a single instance of unwind information (ORC) must
> capture and correctly unwind all alternatives. Since the trivially
> correct mandate is out, implement the straight forward brute-force
> approach:
> 
>  1) generate CFI information for each alternative
> 
>  2) unwind every alternative with the merge-sort of the previously
>     generated CFI information -- O(n^2)
> 
>  3) for any possible conflict: yell.
> 
>  4) Generate ORC with merge-sort
> 
> Specifically for 3 there are two possible classes of conflicts:
> 
>  - the merge-sort itself could find conflicting CFI for the same
>    offset.
> 
>  - the unwind can fail with the merged CFI.

So much algorithm.  Could we make it easier by caching the shared
per-alt-group CFI state somewhere along the way?

For example:

struct alt_group_info {

	/* first original insn in the group */
	struct instruction *orig_insn;

	/* max # of bytes in the group (cfi array size) */
	unsigned long nbytes;

	/* byte-offset-addressed array of CFI pointers */
	struct cfi_state **cfi;
};

We could change 'insn->alt_group' to be a pointer to a shared instance
of the above struct, so that all original and replacement instructions
in a group have a pointer to it.

Starting out, 'cfi' array is all NULLs.  Then when updating CFI, check
'insn->alt_group.cfi[offset]'.

[ 'offset' is a byte offset from the beginning of the group.  It could
  be calculated based on 'orig_insn' or 'orig_insn->alts', depending on
  whether 'insn' is an original or a replacement. ]

If the array entry is NULL, just update it with a pointer to the CFI.
If it's not NULL, make sure it matches the existing CFI, and WARN if it
doesn't.

Also, with this data structure, the ORC generation should also be a lot
more straightforward, just ignore the NULL entries.

Thoughts?  This is all theoretical of course, I could try to do a patch
tomorrow.

-- 
Josh

