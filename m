Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2319D3F4F04
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 19:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhHWRMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 13:12:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:64991 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhHWRMe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 13:12:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="204342899"
X-IronPort-AV: E=Sophos;i="5.84,344,1620716400"; 
   d="scan'208";a="204342899"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2021 10:11:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,344,1620716400"; 
   d="scan'208";a="507325544"
Received: from um.fi.intel.com (HELO um) ([10.237.72.62])
  by orsmga001.jf.intel.com with ESMTP; 23 Aug 2021 10:11:48 -0700
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>, kvm@vger.kernel.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        alexander.shishkin@linux.intel.com
Subject: Re: [PATCH] kvm/x86: Fix PT "host mode"
In-Reply-To: <YSPJ8/PgcFRnp4N9@google.com>
References: <20210823134239.45402-1-alexander.shishkin@linux.intel.com>
 <YSPJ8/PgcFRnp4N9@google.com>
Date:   Mon, 23 Aug 2021 20:11:47 +0300
Message-ID: <87zgt8hyr0.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Aug 23, 2021, Alexander Shishkin wrote:
>
>> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
>> Fixes: ff9d07a0e7ce7 ("KVM: Implement perf callbacks for guest sampling")
>
> This should be another clue that the fix isn't correct.
> That patch is from 2010,

Right, this should have been 8479e04e7d6b1 ("KVM: x86: Inject PMI for
KVM guest") instead.

> Intel PT was announced in 2013 and merged in 2019.

Technically, 2019 is when kvm started breaking host PT.

> This is not remotely correct.  vmx.c's "pt_mode", which is queried via this path,
> is modified by hardware_setup(), a.k.a. kvm_x86_ops.hardware_setup(), which runs
> _after_ this code.  And as alluded to above, these are generic perf callbacks,
> installing them if and only if Intel PT is enabled in a specific mode completely
> breaks "regular" perf.

I see your point, the callchain code will catch fire.

> I'll post a small series, there's a bit of code massage needed to fix this
> properly.  The PMI handler can also be optimized to avoid a retpoline when PT is
> not exposed to the guest.

The actual PMU handler also needs to know that kvm won't be needing it
so it can call the regular PT handler.

One could unset cbs->handle_intel_pt_intr() or one could have it return
different things depending on whether it was actually taken in kvm. But
both are rather disgusting.

Regards,
--
Alex
