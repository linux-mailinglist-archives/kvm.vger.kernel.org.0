Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695E626230A
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 00:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730435AbgIHWnT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 8 Sep 2020 18:43:19 -0400
Received: from mga04.intel.com ([192.55.52.120]:10153 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730092AbgIHWnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 18:43:15 -0400
IronPort-SDR: GJRUn/ojALcYr1RnQwXtJb4vfVpIM+iMYhTKEsRJJmSuR0QCKvnU2/cEV6emdqRBBj42WeNm51
 +cj9GQRzvnnA==
X-IronPort-AV: E=McAfee;i="6000,8403,9738"; a="155638268"
X-IronPort-AV: E=Sophos;i="5.76,407,1592895600"; 
   d="scan'208";a="155638268"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2020 15:43:14 -0700
IronPort-SDR: VZ4y8B/AwjLCLGKaGQt4gPJzvJIQTGKkkJh64Q92xroDBsUYzh0IFoEFRHaEMVDh+kwPWDc2xS
 2lnl8/38qWWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,407,1592895600"; 
   d="scan'208";a="341345209"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Sep 2020 15:43:13 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 8 Sep 2020 15:43:13 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 8 Sep 2020 15:43:12 -0700
Received: from orsmsx611.amr.corp.intel.com ([10.22.229.24]) by
 ORSMSX611.amr.corp.intel.com ([10.22.229.24]) with mapi id 15.01.1713.004;
 Tue, 8 Sep 2020 15:43:12 -0700
From:   "Christopherson, Sean J" <sean.j.christopherson@intel.com>
To:     Ingo Molnar <mingo@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
CC:     "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Will Deacon <will@kernel.org>
Subject: RE: [GIT PULL] First batch of KVM changes for Linux 5.9
Thread-Topic: [GIT PULL] First batch of KVM changes for Linux 5.9
Thread-Index: AQHWa1ww4KOzvmpD9UyaU7UPqtFMUqlftQ+A///WEpA=
Date:   Tue, 8 Sep 2020 22:43:12 +0000
Message-ID: <6a83e6f1e9c34e44ae818ef88ec185a7@intel.com>
References: <20200805182606.12621-1-pbonzini@redhat.com>
 <20200908180939.GA2378263@gmail.com>
In-Reply-To: <20200908180939.GA2378263@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ingo Molnar wrote:
> * Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> > Paolo Bonzini (11):
> >       Merge branch 'kvm-async-pf-int' into HEAD
> 
> kvmtool broke in this merge window, hanging during bootup right after CPU bringup:
> 
>  [    1.289404]  #63
>  [    0.012468] kvm-clock: cpu 63, msr 6ff69fc1, secondary cpu clock
>  [    0.012468] [Firmware Bug]: CPU63: APIC id mismatch. Firmware: 3f APIC: 14
>  [    1.302320] kvm-guest: KVM setup async PF for cpu 63
>  [    1.302320] kvm-guest: stealtime: cpu 63, msr 1379d7600
> 
> Eventually trigger an RCU stall warning:
> 
>  [   22.302392] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
>  [   22.302392] rcu: 	1-...!: (68 GPs behind) idle=00c/0/0x0 softirq=0/0 fqs=0  (false positive?)
> 
> I've bisected this down to the above merge commit. The individual commit:
> 
>    b1d405751cd5: ("KVM: x86: Switch KVM guest to using interrupts for page ready APF delivery")
> 
> appears to be working fine standalone.
> 
> I'm using x86-64 defconfig+kvmconfig on SVM. Can send more info on request.
> 
> The kvmtool.git commit I've tested is 90b2d3adadf2.

Looks a lot like the lack of APIC EOI issue that Vitaly reported[*].

---
 arch/x86/kernel/kvm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index d45f34cbe1ef..9663ba31347c 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -271,6 +271,8 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_asyncpf_interrupt)
 	struct pt_regs *old_regs = set_irq_regs(regs);
 	u32 token;
 
+	ack_APIC_irq();
+
 	inc_irq_stat(irq_hv_callback_count);
 
 	if (__this_cpu_read(apf_reason.enabled)) {
--

[*] https://lkml.kernel.org/r/20200908135350.355053-1-vkuznets@redhat.com
