Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4AC1202F4E
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 06:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgFVEcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 00:32:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:48287 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbgFVEcS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 00:32:18 -0400
IronPort-SDR: IfrdkJvhcBZLZ3jS64wy9VAfIq+HU6oT5f5lmyaCZJoVXGexJmj1Ez6rSGroQPyoMK0z6BNXWN
 D31BeQLPf/Zw==
X-IronPort-AV: E=McAfee;i="6000,8403,9659"; a="141922171"
X-IronPort-AV: E=Sophos;i="5.75,265,1589266800"; 
   d="scan'208";a="141922171"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2020 21:32:17 -0700
IronPort-SDR: Yx+XOhfbkDOqzLdXMgDXDVJRW7YxbzqttsA38FgTYJQeoyfz/be9ut09lQUtW8CFVuu0vnn6Pk
 /qkeAr3ahYgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,265,1589266800"; 
   d="scan'208";a="262860550"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.127])
  by fmsmga007.fm.intel.com with ESMTP; 21 Jun 2020 21:32:14 -0700
Date:   Mon, 22 Jun 2020 12:32:14 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Mohammed Gamal <mgamal@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, thomas.lendacky@amd.com,
        babu.moger@amd.com
Subject: Re: [PATCH v2 00/11] KVM: Support guest MAXPHYADDR < host MAXPHYADDR
Message-ID: <20200622043214.2qy4iteismo45lbb@yy-desk-7060>
References: <20200619153925.79106-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619153925.79106-1-mgamal@redhat.com>
User-Agent: NeoMutt/20171215
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  On Fri, Jun 19, 2020 at 05:39:14PM +0200, Mohammed Gamal wrote:
> When EPT/NPT is enabled, KVM does not really look at guest physical
> address size. Address bits above maximum physical memory size are reserved.
> Because KVM does not look at these guest physical addresses, it currently
> effectively supports guest physical address sizes equal to the host.
> 
> This can be problem when having a mixed setup of machines with 5-level page
> tables and machines with 4-level page tables, as live migration can change
> MAXPHYADDR while the guest runs, which can theoretically introduce bugs.
> 
> In this patch series we add checks on guest physical addresses in EPT
> violation/misconfig and NPF vmexits and if needed inject the proper
> page faults in the guest.
> 
> A more subtle issue is when the host MAXPHYADDR is larger than that of the
> guest. Page faults caused by reserved bits on the guest won't cause an EPT
> violation/NPF and hence we also check guest MAXPHYADDR and add PFERR_RSVD_MASK
> error code to the page fault if needed.
> 
> The last 3 patches (i.e. SVM bits and patch 11) are not intended for
> immediate inclusion and probably need more discussion.
> We've been noticing some unexpected behavior in handling NPF vmexits
> on AMD CPUs (see individual patches for details), and thus we are
> proposing a workaround (see last patch) that adds a capability that
> userspace can use to decide who to deal with hosts that might have
> issues supprting guest MAXPHYADDR < host MAXPHYADDR.
> 
> 
> Mohammed Gamal (7):
>   KVM: x86: Add helper functions for illegal GPA checking and page fault
>     injection
>   KVM: x86: mmu: Move translate_gpa() to mmu.c
>   KVM: x86: mmu: Add guest physical address check in translate_gpa()
>   KVM: VMX: Add guest physical address check in EPT violation and
>     misconfig
>   KVM: SVM: introduce svm_need_pf_intercept
>   KVM: SVM: Add guest physical address check in NPF/PF interception
>   KVM: x86: SVM: VMX: Make GUEST_MAXPHYADDR < HOST_MAXPHYADDR support
>     configurable
> 
> Paolo Bonzini (4):
>   KVM: x86: rename update_bp_intercept to update_exception_bitmap
>   KVM: x86: update exception bitmap on CPUID changes
>   KVM: VMX: introduce vmx_need_pf_intercept
>   KVM: VMX: optimize #PF injection when MAXPHYADDR does not match
> 
>  arch/x86/include/asm/kvm_host.h | 10 ++------
>  arch/x86/kvm/cpuid.c            |  2 ++
>  arch/x86/kvm/mmu.h              |  6 +++++
>  arch/x86/kvm/mmu/mmu.c          | 12 +++++++++
>  arch/x86/kvm/svm/svm.c          | 41 +++++++++++++++++++++++++++---
>  arch/x86/kvm/svm/svm.h          |  6 +++++
>  arch/x86/kvm/vmx/nested.c       | 28 ++++++++++++--------
>  arch/x86/kvm/vmx/vmx.c          | 45 +++++++++++++++++++++++++++++----
>  arch/x86/kvm/vmx/vmx.h          |  6 +++++
>  arch/x86/kvm/x86.c              | 29 ++++++++++++++++++++-
>  arch/x86/kvm/x86.h              |  1 +
>  include/uapi/linux/kvm.h        |  1 +
>  12 files changed, 158 insertions(+), 29 deletions(-)
> 
> -- 
> 2.26.2
> 
