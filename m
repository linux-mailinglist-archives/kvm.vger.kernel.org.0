Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCF42046BA
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 03:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731853AbgFWBbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 21:31:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:34260 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731572AbgFWBbO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 21:31:14 -0400
IronPort-SDR: sdd61Fmjis3csYauweirzlatTzOD2gQgK7V3jTIawqGoX7vM4shzfNX09ROY12NtocjzE8sTH5
 CT0RQb9ufJBg==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="142192752"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="142192752"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 18:31:12 -0700
IronPort-SDR: cPVmBRoexshcGq3le/Hx4xRbS5QEUaEdxjP2bt7ofWqBso70NQG16s04e+QU4I6iRzHTHPKXTm
 WoOKPWpLo6/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="293039433"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga002.jf.intel.com with ESMTP; 22 Jun 2020 18:31:11 -0700
Date:   Mon, 22 Jun 2020 18:31:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jingqi Liu <jingqi.liu@intel.com>,
        Tao Xu <tao3.xu@intel.com>
Subject: Re: [PATCH] KVM: VMX: Stop context switching MSR_IA32_UMWAIT_CONTROL
Message-ID: <20200623013111.GE6151@linux.intel.com>
References: <20200623005135.10414-1-sean.j.christopherson@intel.com>
 <7e840f1c-d8e2-3374-5009-f2ab41a87386@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e840f1c-d8e2-3374-5009-f2ab41a87386@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 09:21:28AM +0800, Xiaoyao Li wrote:
> On 6/23/2020 8:51 AM, Sean Christopherson wrote:
> >Remove support for context switching between the guest's and host's
> >desired UMWAIT_CONTROL.  Propagating the guest's value to hardware isn't
> >required for correct functionality, e.g. KVM intercepts reads and writes
> >to the MSR, and the latency effects of the settings controlled by the
> >MSR are not architecturally visible.
> >
> >As a general rule, KVM should not allow the guest to control power
> >management settings unless explicitly enabled by userspace, e.g. see
> >KVM_CAP_X86_DISABLE_EXITS.  E.g. Intel's SDM explicitly states that C0.2
> >can improve the performance of SMT siblings.  A devious guest could
> >disable C0.2 so as to improve the performance of their workloads at the
> >detriment to workloads running in the host or on other VMs.
> >
> >Wholesale removal of UMWAIT_CONTROL context switching also fixes a race
> >condition where updates from the host may cause KVM to enter the guest
> >with the incorrect value.  Because updates are are propagated to all
> >CPUs via IPI (SMP function callback), the value in hardware may be
> >stale with respect to the cached value and KVM could enter the guest
> >with the wrong value in hardware.  As above, the guest can't observe the
> >bad value, but it's a weird and confusing wart in the implementation.
> >
> >Removal also fixes the unnecessary usage of VMX's atomic load/store MSR
> >lists.  Using the lists is only necessary for MSRs that are required for
> >correct functionality immediately upon VM-Enter/VM-Exit, e.g. EFER on
> >old hardware, or for MSRs that need to-the-uop precision, e.g. perf
> >related MSRs.  For UMWAIT_CONTROL, the effects are only visible in the
> >kernel via TPAUSE/delay(), and KVM doesn't do any form of delay in
> >vcpu_vmx_run().
> 
> >Using the atomic lists is undesirable as they are more
> >expensive than direct RDMSR/WRMSR.
> 
> Do you mean the extra handling of atomic list facility in kvm? Or just mean
> vm-exit/-entry MSR-load/save in VMX hardware is expensive than direct
> RDMSR/WRMSR instruction?

Both.  The KVM handling is the bigger cost, e.g. requires two VMWRITEs to
update the list counts, on top of the list processing.  The actual ucode
cost is also somewhat expensive if adding an MSR to the list causes the
load/store lists to be activated, e.g. on top of the memory accesses for
the list, VM-Enter ucode needs to do its consistency checks.

Expensive is obviously relative, but as far as the lists are concerned it's
an easy penalty to avoid.
