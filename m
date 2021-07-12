Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668DF3C5A34
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 13:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237655AbhGLJmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 05:42:35 -0400
Received: from mga17.intel.com ([192.55.52.151]:12193 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237631AbhGLJjU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 05:39:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10042"; a="190332116"
X-IronPort-AV: E=Sophos;i="5.84,232,1620716400"; 
   d="scan'208";a="190332116"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 02:36:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,232,1620716400"; 
   d="scan'208";a="491957343"
Received: from michael-optiplex-9020.sh.intel.com (HELO localhost) ([10.239.159.182])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Jul 2021 02:36:30 -0700
Date:   Mon, 12 Jul 2021 17:50:34 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        like.xu.linux@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 06/13] KVM: x86/vmx: Save/Restore host
 MSR_ARCH_LBR_CTL state
Message-ID: <20210712095034.GD12162@intel.com>
References: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com>
 <1625825111-6604-7-git-send-email-weijiang.yang@intel.com>
 <CALMp9eQEs9pUyy1PpwLPG0_PtF07tR2Opw+1b=w4-knOwYPvvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQEs9pUyy1PpwLPG0_PtF07tR2Opw+1b=w4-knOwYPvvg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 09, 2021 at 03:54:53PM -0700, Jim Mattson wrote:
> On Fri, Jul 9, 2021 at 2:51 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
> >
> > If host is using MSR_ARCH_LBR_CTL then save it before vm-entry
> > and reload it after vm-exit.
> 
> I don't see anything being done here "before VM-entry" or "after
> VM-exit." This code seems to be invoked on vcpu_load and vcpu_put.
> 
> In any case, I don't see why this one MSR is special. It seems that if
> the host is using the architectural LBR MSRs, then *all* of the host
> architectural LBR MSRs have to be saved on vcpu_load and restored on
> vcpu_put. Shouldn't  kvm_load_guest_fpu() and kvm_put_guest_fpu() do
> that via the calls to kvm_save_current_fpu(vcpu->arch.user_fpu) and
> restore_fpregs_from_fpstate(&vcpu->arch.user_fpu->state)?
I looked back on the discussion thread:
https://patchwork.kernel.org/project/kvm/patch/20210303135756.1546253-8-like.xu@linux.intel.com/
not sure why this code is added, but IMO, although fpu save/restore in outer loop
covers this LBR MSR, but the operation points are far away from vm-entry/exit
point, i.e., the guest MSR setting could leak to host side for a signicant
long of time, it may cause host side profiling accuracy. if we save/restore it
manually, it'll mitigate the issue signifcantly.
