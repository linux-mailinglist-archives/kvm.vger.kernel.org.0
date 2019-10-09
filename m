Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A484D04FA
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 03:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbfJIBDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 21:03:18 -0400
Received: from mga14.intel.com ([192.55.52.115]:47971 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729700AbfJIBDR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 21:03:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 18:03:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="206765238"
Received: from txu2-mobl.ccr.corp.intel.com (HELO [10.239.196.191]) ([10.239.196.191])
  by fmsmga001.fm.intel.com with ESMTP; 08 Oct 2019 18:03:16 -0700
Subject: Re: [PATCH v5 0/2] x86: Enable user wait instructions
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Cc:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu, Jingqi" <jingqi.liu@intel.com>
References: <20190929015718.19562-1-tao3.xu@intel.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <032bc3fa-d950-a30a-cb95-8fb11b398fd2@intel.com>
Date:   Wed, 9 Oct 2019 09:03:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190929015718.19562-1-tao3.xu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping for comments :)

On 9/29/2019 9:57 AM, Xu, Tao3 wrote:
> UMONITOR, UMWAIT and TPAUSE are a set of user wait instructions.
> 
> UMONITOR arms address monitoring hardware using an address. A store
> to an address within the specified address range triggers the
> monitoring hardware to wake up the processor waiting in umwait.
> 
> UMWAIT instructs the processor to enter an implementation-dependent
> optimized state while monitoring a range of addresses. The optimized
> state may be either a light-weight power/performance optimized state
> (c0.1 state) or an improved power/performance optimized state
> (c0.2 state).
> 
> TPAUSE instructs the processor to enter an implementation-dependent
> optimized state c0.1 or c0.2 state and wake up when time-stamp counter
> reaches specified timeout.
> 
> Availability of the user wait instructions is indicated by the presence
> of the CPUID feature flag WAITPKG CPUID.0x07.0x0:ECX[5].
> 
> The patches enable the umonitor, umwait and tpause features in KVM.
> Because umwait and tpause can put a (psysical) CPU into a power saving
> state, by default we dont't expose it in kvm and provide a capability to
> enable it. Use kvm capability to enable UMONITOR, UMWAIT and TPAUSE when
> QEMU use "-overcommit cpu-pm=on, a VM can use UMONITOR, UMWAIT and TPAUSE
> instructions. If the instruction causes a delay, the amount of time
> delayed is called here the physical delay. The physical delay is first
> computed by determining the virtual delay (the time to delay relative to
> the VM’s timestamp counter). Otherwise, UMONITOR, UMWAIT and TPAUSE cause
> an invalid-opcode exception(#UD).
> 
> The release document ref below link:
> https://software.intel.com/sites/default/files/\
> managed/39/c5/325462-sdm-vol-1-2abcd-3abcd.pdf
> 
> Changelog:
> v5:
> 	Remove CPUID_7_0_ECX_WAITPKG if enable_cpu_pm is not set. (Paolo)
> v4:
> 	Set IA32_UMWAIT_CONTROL 32bits
> v3:
> 	Simplify the patches, expose user wait instructions when the guest
> 	has CPUID (Paolo)
> v2:
> 	Separated from the series
> 	https://www.mail-archive.com/qemu-devel@nongnu.org/msg549526.html
> 	Use kvm capability to enable UMONITOR, UMWAIT and TPAUSE when
> 	QEMU use "-overcommit cpu-pm=on"	
> v1:
> 	Sent out with MOVDIRI/MOVDIR64B instructions patches
> 
> Tao Xu (2):
>    x86/cpu: Add support for UMONITOR/UMWAIT/TPAUSE
>    target/i386: Add support for save/load IA32_UMWAIT_CONTROL MSR
> 
>   target/i386/cpu.c     |  3 ++-
>   target/i386/cpu.h     |  3 +++
>   target/i386/kvm.c     | 19 +++++++++++++++++++
>   target/i386/machine.c | 20 ++++++++++++++++++++
>   4 files changed, 44 insertions(+), 1 deletion(-)
> 

