Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44C07D76DC
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 14:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfJOMvx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 15 Oct 2019 08:51:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:59821 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfJOMvx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 08:51:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Oct 2019 05:51:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,300,1566889200"; 
   d="scan'208";a="347064321"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga004.jf.intel.com with ESMTP; 15 Oct 2019 05:51:51 -0700
Received: from fmsmsx101.amr.corp.intel.com (10.18.124.199) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 15 Oct 2019 05:51:51 -0700
Received: from shsmsx151.ccr.corp.intel.com (10.239.6.50) by
 fmsmsx101.amr.corp.intel.com (10.18.124.199) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 15 Oct 2019 05:51:50 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.166]) by
 SHSMSX151.ccr.corp.intel.com ([10.239.6.50]) with mapi id 14.03.0439.000;
 Tue, 15 Oct 2019 20:51:49 +0800
From:   "Kang, Luwei" <luwei.kang@intel.com>
To:     Eduardo Habkost <ehabkost@redhat.com>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>
Subject: RE: [PATCH v4 2/2] i386: Add support to get/set/migrate Intel
 Processor Trace feature
Thread-Topic: [PATCH v4 2/2] i386: Add support to get/set/migrate Intel
 Processor Trace feature
Thread-Index: AQHVgKsg+eNsNdVZH0GZ6Dwyyz/Lp6dbpngw
Date:   Tue, 15 Oct 2019 12:51:48 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E17382A209@SHSMSX104.ccr.corp.intel.com>
References: <1520182116-16485-1-git-send-email-luwei.kang@intel.com>
 <1520182116-16485-2-git-send-email-luwei.kang@intel.com>
 <20191012031407.GK4084@habkost.net>
In-Reply-To: <20191012031407.GK4084@habkost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYWUzYjc0YjktZTE2MC00MjgxLTgxMDgtZjUyMTk4YzgzNmM4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoicjBtTjVcL3dZSzBlS1lyOWV6cTA2bnRtaVdoWWxLaUdcLyt5dm9zVGErMllGXC9GTFdibHdTaWc3Q2I4ZEk5aEsyTSJ9
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

qemu> > diff --git a/target/i386/kvm.c b/target/i386/kvm.c index
> > f9f4cd1..097c953 100644
> > --- a/target/i386/kvm.c
> > +++ b/target/i386/kvm.c
> > @@ -1811,6 +1811,25 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
> >                  kvm_msr_entry_add(cpu, MSR_MTRRphysMask(i), mask);
> >              }
> >          }
> > +        if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) {
> > +            int addr_num = kvm_arch_get_supported_cpuid(kvm_state,
> > +                                                    0x14, 1, R_EAX) &
> > + 0x7;
> > +
> > +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_CTL,
> > +                            env->msr_rtit_ctrl);
> > +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_STATUS,
> > +                            env->msr_rtit_status);
> > +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_OUTPUT_BASE,
> > +                            env->msr_rtit_output_base);
> 
> This causes the following crash on some hosts:
> 
>   qemu-system-x86_64: error: failed to set MSR 0x560 to 0x0
>   qemu-system-x86_64: target/i386/kvm.c:2673: kvm_put_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.
> 
> Checking for CPUID_7_0_EBX_INTEL_PT is not enough: KVM has additional conditions that might prevent writing to this MSR
> (PT_CAP_topa_output && PT_CAP_single_range_output).  This causes QEMU to crash if some of the conditions aren't met.
> 
> Writing and reading this MSR (and the ones below) need to be conditional on KVM_GET_MSR_INDEX_LIST.
> 

Hi Eduardo,
    I found this issue can't be reproduced in upstream source code but can be reproduced on RHEL8.1. I haven't got the qemu source code of RHEL8.1. But after adding some trace in KVM, I found the KVM has reported the complete Intel PT CPUID information to qemu but the Intel PT CPUID (0x14) is lost when qemu setting the CPUID to KVM (cpuid level is 0xd). It looks like lost the below patch.

commit f24c3a79a415042f6dc195f029a2ba7247d14cac
Author: Luwei Kang <luwei.kang@intel.com>
Date:   Tue Jan 29 18:52:59 2019 -0500
    i386: extended the cpuid_level when Intel PT is enabled

    Intel Processor Trace required CPUID[0x14] but the cpuid_level
    have no change when create a kvm guest with
    e.g. "-cpu qemu64,+intel-pt".

Thanks,
Luwei Kang

