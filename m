Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5CB279286
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 22:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729104AbgIYUpa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 16:45:30 -0400
Received: from mga05.intel.com ([192.55.52.43]:41395 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729068AbgIYUpW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 16:45:22 -0400
IronPort-SDR: j8QfebcWgvtS6F9AUQwdW3ZqscOtdUE5k7FJki9beL6f6ppqmuFEIkpwM2iX5FOAc33yyt1x8B
 vZpzNNAMnCMQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9755"; a="246421199"
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="246421199"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 13:40:45 -0700
IronPort-SDR: vHGr7RoTrIepSSH5z9XxuBhD6pPC3ZYVQnUOhjOrh18IzRmdl0eOWsux+wkbWwRf+yO1y0TcrZ
 My54RI0QHqRw==
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="292908495"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 13:40:44 -0700
Date:   Fri, 25 Sep 2020 13:40:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH 0/4] KVM: x86/mmu: Page fault handling cleanups
Message-ID: <20200925204043.GH31528@linux.intel.com>
References: <20200923220425.18402-1-sean.j.christopherson@intel.com>
 <ca36404c-9b2a-dbce-d5e4-a3fc3cc620bc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca36404c-9b2a-dbce-d5e4-a3fc3cc620bc@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 10:38:02PM +0200, Paolo Bonzini wrote:
> On 24/09/20 00:04, Sean Christopherson wrote:
> > Cleanups for page fault handling that were encountered during early TDX
> > enabling, but are worthwhile on their own.  Specifically, patch 4 fixes an
> > issue where KVM doesn't detect a spurious page fault (due to the fault
> > being fixed by a different pCPU+vCPU) and does the full gamut of writing
> > the SPTE, updating stats, and prefetching SPTEs.
> > 
> > Sean Christopherson (4):
> >   KVM: x86/mmu: Return -EIO if page fault returns RET_PF_INVALID
> >   KVM: x86/mmu: Invert RET_PF_* check when falling through to emulation
> >   KVM: x86/mmu: Return unique RET_PF_* values if the fault was fixed
> >   KVM: x86/mmu: Bail early from final #PF handling on spurious faults
> > 
> >  arch/x86/kvm/mmu/mmu.c         | 70 +++++++++++++++++++++-------------
> >  arch/x86/kvm/mmu/mmutrace.h    | 13 +++----
> >  arch/x86/kvm/mmu/paging_tmpl.h |  3 ++
> >  3 files changed, 52 insertions(+), 34 deletions(-)
> > 
> 
> Queued, thanks.  Looking at the KVM_BUG_ON now since patch 1 is somewhat
> related.

Ha, very prescient of you, that's actually a KVM_BUG_ON() in my "kitchen sink"
combo of everything :-)
