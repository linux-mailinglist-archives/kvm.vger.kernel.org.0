Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E1B3C5A39
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 13:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237694AbhGLJmh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 05:42:37 -0400
Received: from mga07.intel.com ([134.134.136.100]:4552 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383350AbhGLJlw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 05:41:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10042"; a="273785002"
X-IronPort-AV: E=Sophos;i="5.84,232,1620716400"; 
   d="scan'208";a="273785002"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 02:39:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,232,1620716400"; 
   d="scan'208";a="491957731"
Received: from michael-optiplex-9020.sh.intel.com (HELO localhost) ([10.239.159.182])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Jul 2021 02:39:01 -0700
Date:   Mon, 12 Jul 2021 17:53:05 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        like.xu.linux@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 06/13] KVM: x86/vmx: Save/Restore host
 MSR_ARCH_LBR_CTL state
Message-ID: <20210712095305.GE12162@intel.com>
References: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com>
 <1625825111-6604-7-git-send-email-weijiang.yang@intel.com>
 <CALMp9eQEs9pUyy1PpwLPG0_PtF07tR2Opw+1b=w4-knOwYPvvg@mail.gmail.com>
 <CALMp9eQ+9czB0ayBFR3-nW-ynKuH0v9uHAGeV4wgkXYJMSs1=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eQ+9czB0ayBFR3-nW-ynKuH0v9uHAGeV4wgkXYJMSs1=w@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 09, 2021 at 04:41:30PM -0700, Jim Mattson wrote:
> On Fri, Jul 9, 2021 at 3:54 PM Jim Mattson <jmattson@google.com> wrote:
> >
> > On Fri, Jul 9, 2021 at 2:51 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
> > >
> > > If host is using MSR_ARCH_LBR_CTL then save it before vm-entry
> > > and reload it after vm-exit.
> >
> > I don't see anything being done here "before VM-entry" or "after
> > VM-exit." This code seems to be invoked on vcpu_load and vcpu_put.
> >
> > In any case, I don't see why this one MSR is special. It seems that if
> > the host is using the architectural LBR MSRs, then *all* of the host
> > architectural LBR MSRs have to be saved on vcpu_load and restored on
> > vcpu_put. Shouldn't  kvm_load_guest_fpu() and kvm_put_guest_fpu() do
> > that via the calls to kvm_save_current_fpu(vcpu->arch.user_fpu) and
> > restore_fpregs_from_fpstate(&vcpu->arch.user_fpu->state)?
> 
> It does seem like there is something special about IA32_LBR_DEPTH, though...
> 
> Section 7.3.1 of the Intel® Architecture Instruction Set Extensions
> and Future Features Programming Reference
> says, "IA32_LBR_DEPTH is saved by XSAVES, but it is not written by
> XRSTORS in any circumstance." It seems like that would require some
> special handling if the host depth and the guest depth do not match.
In our vPMU design, guest depth is alway kept the same as that of host,
so this won't be a problem. But I'll double check the code again, thanks!
