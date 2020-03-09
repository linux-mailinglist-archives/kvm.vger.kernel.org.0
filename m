Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C702917E3E1
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 16:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgCIPoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 11:44:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:48920 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726804AbgCIPoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 11:44:46 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Mar 2020 08:44:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,533,1574150400"; 
   d="scan'208";a="245377488"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.21])
  by orsmga006.jf.intel.com with ESMTP; 09 Mar 2020 08:44:45 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id A0610301BCC; Mon,  9 Mar 2020 08:44:45 -0700 (PDT)
Date:   Mon, 9 Mar 2020 08:44:45 -0700
From:   Andi Kleen <ak@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "Liang, Kan" <kan.liang@linux.intel.com>,
        Luwei Kang <luwei.kang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, tglx@linutronix.de, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        pawan.kumar.gupta@linux.intel.com, thomas.lendacky@amd.com,
        fenghua.yu@intel.com, like.xu@linux.intel.com
Subject: Re: [PATCH v1 01/11] perf/x86/core: Support KVM to assign a
 dedicated counter for guest PEBS
Message-ID: <20200309154445.GL1454533@tassilo.jf.intel.com>
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
 <1583431025-19802-2-git-send-email-luwei.kang@intel.com>
 <20200306135317.GD12561@hirez.programming.kicks-ass.net>
 <b72cb68e-1a0a-eeff-21b4-ce412e939cfd@linux.intel.com>
 <20200309100443.GG12561@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309100443.GG12561@hirez.programming.kicks-ass.net>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Suppose your KVM thing claims counter 0/2 (ICL/SKL) for some random PEBS
> event, and then the host wants to use PREC_DIST.. Then one of them will
> be screwed for no reason what so ever.

It's no different from some user using an event that requires some
specific counter.

> 
> How is that not destroying scheduling freedom? Any other situation we'd
> have moved the !PREC_DIST PEBS event to another counter.

Anyways what are you suggesting to do instead? Do you have a better proposal?

The only alternative I know to doing this would be to go through the PEBS
buffer in the guest and patch the applicable counter field up on each PMI.

I tried that at some point (still have code somewhere), but it was
quite complicated and tricky and somewhat slow, so I gave up eventually.

It's also inherently racy because if the guest starts looking at
the PEBS buffer before an PMI it could see the unpatched values
Given I don't know any real software which would break from this,
but such "polled PEBS" usages are certainly concievable.

The artificial constraint is a lot simpler and straight forward,
and also doesn't have any holes like this.

-Andi

