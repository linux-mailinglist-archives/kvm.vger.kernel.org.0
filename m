Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2473B247B
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 03:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhFXBWz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 21:22:55 -0400
Received: from mga18.intel.com ([134.134.136.126]:23743 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229759AbhFXBWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 21:22:54 -0400
IronPort-SDR: Rp3uolIvG4kSR8A0qwJuUEj5I4iwMU5PhV9nXrYVpyGOlD0iHuq4MLquymIJr+1mbt1r5YIP6p
 YdbxoylfX9zg==
X-IronPort-AV: E=McAfee;i="6200,9189,10024"; a="194676400"
X-IronPort-AV: E=Sophos;i="5.83,295,1616482800"; 
   d="scan'208";a="194676400"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2021 18:20:36 -0700
IronPort-SDR: tac5mdNb3TRW2zCX7aYeaEw/PrSAYMm4FPomcKXiPCsXeARGJjj/ei0UhvRMipfXkfRn6aXZ8J
 FFhGHxLxycXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,295,1616482800"; 
   d="scan'208";a="557156873"
Received: from michael-optiplex-9020.sh.intel.com (HELO localhost) ([10.239.159.182])
  by fmsmga001.fm.intel.com with ESMTP; 23 Jun 2021 18:20:32 -0700
Date:   Thu, 24 Jun 2021 09:35:10 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH v4 04/10] KVM: vmx/pmu: Add MSR_ARCH_LBR_CTL
 emulation for Arch LBR
Message-ID: <20210624013510.GB15841@intel.com>
References: <20210510081535.94184-1-like.xu@linux.intel.com>
 <20210510081535.94184-5-like.xu@linux.intel.com>
 <CALMp9eQG+JLnHe4zRKg0sHtxynSiGGKPw--5J+cY2-f3QWRW2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQG+JLnHe4zRKg0sHtxynSiGGKPw--5J+cY2-f3QWRW2A@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23, 2021 at 11:29:08AM -0700, Jim Mattson wrote:
> On Mon, May 10, 2021 at 1:16 AM Like Xu <like.xu@linux.intel.com> wrote:
> >
> > Arch LBRs are enabled by setting MSR_ARCH_LBR_CTL.LBREn to 1. A new guest
> > state field named "Guest IA32_LBR_CTL" is added to enhance guest LBR usage.
> > When guest Arch LBR is enabled, a guest LBR event will be created like the
> > model-specific LBR does.
> >
> > On processors that support Arch LBR, MSR_IA32_DEBUGCTLMSR[bit 0] has no
> > meaning. It can be written to 0 or 1, but reads will always return 0.
> > Like IA32_DEBUGCTL, IA32_ARCH_LBR_CTL msr is also reserved on INIT.
> >
> > Signed-off-by: Like Xu <like.xu@linux.intel.com>
> > ---
> >  arch/x86/events/intel/lbr.c      |  2 --
> >  arch/x86/include/asm/msr-index.h |  1 +
> >  arch/x86/include/asm/vmx.h       |  2 ++
> >  arch/x86/kvm/vmx/pmu_intel.c     | 31 ++++++++++++++++++++++++++-----
> >  arch/x86/kvm/vmx/vmx.c           |  9 +++++++++
> >  5 files changed, 38 insertions(+), 7 deletions(-)
> >
> Same comments as on the previous patch. Your guard for ensuring that
> the new VMCS fields exist can be spoofed by a malicious userspace, and
> the new MSR has to be enumerated by KVM_GET_MSR_INDEX_LIST.

OK, will modify the code, thanks!
