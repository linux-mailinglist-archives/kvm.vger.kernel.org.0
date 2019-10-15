Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 852EED7777
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 15:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731843AbfJON3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 09:29:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47493 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727745AbfJON3c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 09:29:32 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8D31A7FDE5;
        Tue, 15 Oct 2019 13:29:31 +0000 (UTC)
Received: from localhost (ovpn-116-20.phx2.redhat.com [10.3.116.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B20B5C21F;
        Tue, 15 Oct 2019 13:29:30 +0000 (UTC)
Date:   Tue, 15 Oct 2019 10:29:29 -0300
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     "Kang, Luwei" <luwei.kang@intel.com>
Cc:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>
Subject: Re: [PATCH v4 2/2] i386: Add support to get/set/migrate Intel
 Processor Trace feature
Message-ID: <20191015132929.GY4084@habkost.net>
References: <1520182116-16485-1-git-send-email-luwei.kang@intel.com>
 <1520182116-16485-2-git-send-email-luwei.kang@intel.com>
 <20191012031407.GK4084@habkost.net>
 <82D7661F83C1A047AF7DC287873BF1E17382A209@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82D7661F83C1A047AF7DC287873BF1E17382A209@SHSMSX104.ccr.corp.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 15 Oct 2019 13:29:31 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 15, 2019 at 12:51:48PM +0000, Kang, Luwei wrote:
> qemu> > diff --git a/target/i386/kvm.c b/target/i386/kvm.c index
> > > f9f4cd1..097c953 100644
> > > --- a/target/i386/kvm.c
> > > +++ b/target/i386/kvm.c
> > > @@ -1811,6 +1811,25 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
> > >                  kvm_msr_entry_add(cpu, MSR_MTRRphysMask(i), mask);
> > >              }
> > >          }
> > > +        if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) {
> > > +            int addr_num = kvm_arch_get_supported_cpuid(kvm_state,
> > > +                                                    0x14, 1, R_EAX) &
> > > + 0x7;
> > > +
> > > +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_CTL,
> > > +                            env->msr_rtit_ctrl);
> > > +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_STATUS,
> > > +                            env->msr_rtit_status);
> > > +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_OUTPUT_BASE,
> > > +                            env->msr_rtit_output_base);
> > 
> > This causes the following crash on some hosts:
> > 
> >   qemu-system-x86_64: error: failed to set MSR 0x560 to 0x0
> >   qemu-system-x86_64: target/i386/kvm.c:2673: kvm_put_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.
> > 
> > Checking for CPUID_7_0_EBX_INTEL_PT is not enough: KVM has additional conditions that might prevent writing to this MSR
> > (PT_CAP_topa_output && PT_CAP_single_range_output).  This causes QEMU to crash if some of the conditions aren't met.
> > 
> > Writing and reading this MSR (and the ones below) need to be conditional on KVM_GET_MSR_INDEX_LIST.
> > 
> 
> Hi Eduardo,
>     I found this issue can't be reproduced in upstream source code but can be reproduced on RHEL8.1. I haven't got the qemu source code of RHEL8.1. But after adding some trace in KVM, I found the KVM has reported the complete Intel PT CPUID information to qemu but the Intel PT CPUID (0x14) is lost when qemu setting the CPUID to KVM (cpuid level is 0xd). It looks like lost the below patch.
> 
> commit f24c3a79a415042f6dc195f029a2ba7247d14cac
> Author: Luwei Kang <luwei.kang@intel.com>
> Date:   Tue Jan 29 18:52:59 2019 -0500
>     i386: extended the cpuid_level when Intel PT is enabled
> 
>     Intel Processor Trace required CPUID[0x14] but the cpuid_level
>     have no change when create a kvm guest with
>     e.g. "-cpu qemu64,+intel-pt".

Thanks for the pointer.  This may avoid triggering the bug in the
default configuration, but we still need to make the MSR writing
conditional on KVM_GET_MSR_INDEX_LIST.  Older machine-types have
x-intel-pt-auto-level=off, and the user may set `level` manually.

-- 
Eduardo
