Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570D722892B
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 21:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730697AbgGUTbd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 15:31:33 -0400
Received: from mga18.intel.com ([134.134.136.126]:50213 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728577AbgGUTbc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 15:31:32 -0400
IronPort-SDR: +EMrKY7Pb8NyvywDOq0+Hh1u3s3ubdz3+qCDfoVgcUWlsawzrZh5EFTdi6dtBwhQCE/0IPOvZ0
 nvu73s6p9mwQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="137716888"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="137716888"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 12:31:31 -0700
IronPort-SDR: +NFDXtIG4y6K5jVpo9ZIo8zj5SALsFZBMQS3Hdm4SxhohYH+KB9rumnvBiOOr9zMU+04Zjy0Y2
 aSHx4UfruiSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="270530669"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga007.fm.intel.com with ESMTP; 21 Jul 2020 12:31:31 -0700
Date:   Tue, 21 Jul 2020 12:31:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 6/7] KVM: x86: Use common definition for
 kvm_nested_vmexit tracepoint
Message-ID: <20200721193130.GH22083@linux.intel.com>
References: <20200718063854.16017-1-sean.j.christopherson@intel.com>
 <20200718063854.16017-7-sean.j.christopherson@intel.com>
 <87365mqgcg.fsf@vitty.brq.redhat.com>
 <20200721002717.GC20375@linux.intel.com>
 <87imehotp1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87imehotp1.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Steve

Background: KVM has two tracepoints that effectively trace the same thing
(VM-Exit vs. nested VM-Exit), but use completely different formatting and
nomenclature for each of the existing tracepoints.  I want to add a common
macro to create the tracepoints so that they capture the exact same info
and report it with the exact same format.  But that means breaking the
"ABI" for one of the tracepoints, e.g. trace-cmd barfs on the rename of
exit_code to exit_reason.

Was there ever a verdict on whether or not tracepoints are considered ABI
and thus must retain backwards compatibility?

If not, what's the proper way to upstream changes to trace-cmd?

Thanks!

On Tue, Jul 21, 2020 at 03:59:06PM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> >> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> >> With so many lines removed I'm almost in love with the patch! However,
> >> when testing on SVM (unrelated?) my trace log looks a bit ugly:
> >> 
> >>            <...>-315119 [010]  3733.092646: kvm_nested_vmexit:    CAN'T FIND FIELD "rip"<CANT FIND FIELD exit_code>vcpu 0 reason npf rip 0x400433 info1 0x0000000200000006 info2 0x0000000000641000 intr_info 0x00000000 error_code 0x00000000
> >>            <...>-315119 [010]  3733.092655: kvm_nested_vmexit:    CAN'T FIND FIELD "rip"<CANT FIND FIELD exit_code>vcpu 0 reason npf rip 0x400433 info1 0x0000000100000014 info2 0x0000000000400000 intr_info 0x00000000 error_code 0x00000000
> >> 
> >> ...
> >> 
> >> but after staring at this for some time I still don't see where this
> >> comes from :-( ... but reverting this commit helps:
> >
> > The CAN'T FIND FIELD blurb comes from tools/lib/traceevent/event-parse.c.
> >
> > I assume you are using tooling of some form to generate the trace, i.e. the
> > issue doesn't show up in /sys/kernel/debug/tracing/trace.  If that's the
> > case, this is more or less ABI breakage :-(
> >  
> 
> Right you are,
> 
> the tool is called 'trace-cmd record -e kvm ...' / 'trace-cmd report'
> but I always thought it's not any different from looking at
> /sys/kernel/debug/tracing/trace directly. Apparently I was wrong. 'cat
> /sys/kernel/debug/tracing/trace' seems to be OK, e.g.:
> 
>  qemu-system-x86-20263 [006] .... 75982.292657: kvm_nested_vmexit: vcpu 0 reason hypercall rip 0x40122f info1 0x0000000000000000 info2 0x0000000000000000 intr_info 0x00000000 error_code 0x00000000
> 
> -- 
> Vitaly
> 
