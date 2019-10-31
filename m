Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECEEEAE7C
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2019 12:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbfJaLKW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 31 Oct 2019 07:10:22 -0400
Received: from mga06.intel.com ([134.134.136.31]:12603 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727277AbfJaLKV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Oct 2019 07:10:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Oct 2019 04:10:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,250,1569308400"; 
   d="scan'208";a="400460813"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga005.fm.intel.com with ESMTP; 31 Oct 2019 04:10:20 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 31 Oct 2019 04:10:20 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 31 Oct 2019 04:10:20 -0700
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 31 Oct 2019 04:10:19 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.2]) with mapi id 14.03.0439.000;
 Thu, 31 Oct 2019 19:10:18 +0800
From:   "Kang, Luwei" <luwei.kang@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "alexander.shishkin@linux.intel.com" 
        <alexander.shishkin@linux.intel.com>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>
Subject: RE: [PATCH v1 3/8] KVM: x86: Allocate performance counter for PEBS
 event
Thread-Topic: [PATCH v1 3/8] KVM: x86: Allocate performance counter for PEBS
 event
Thread-Index: AQHVjLd13+lWyOpx00qD/bA0eE059qdxL6sAgAEppjCAABXXgIACK7fw
Date:   Thu, 31 Oct 2019 11:10:18 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E17383642D@SHSMSX104.ccr.corp.intel.com>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
 <1572217877-26484-4-git-send-email-luwei.kang@intel.com>
 <20191029144612.GK4097@hirez.programming.kicks-ass.net>
 <82D7661F83C1A047AF7DC287873BF1E173835B1A@SHSMSX104.ccr.corp.intel.com>
 <20191030094941.GQ4097@hirez.programming.kicks-ass.net>
In-Reply-To: <20191030094941.GQ4097@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNzE3NjQyYjEtYmE2OS00YjI4LTk2MjUtMmVlZTIwM2Y2M2UzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiR2xDRGN4bHZSakV6S01JcHJMaVJnZFFmcTl3NHRyN0U4UkNOTmoxR0RsXC8rVmJKV1g4WGx0NWVDQTlvT3hFXC9EIn0=
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

> > > >  static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
> > > >  				  unsigned config, bool exclude_user,
> > > >  				  bool exclude_kernel, bool intr,
> > > > -				  bool in_tx, bool in_tx_cp)
> > > > +				  bool in_tx, bool in_tx_cp, bool pebs)
> > > >  {
> > > >  	struct perf_event *event;
> > > >  	struct perf_event_attr attr = {
> > > > @@ -111,9 +111,12 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc,
> u32 type,
> > > >  		.exclude_user = exclude_user,
> > > >  		.exclude_kernel = exclude_kernel,
> > > >  		.config = config,
> > > > +		.precise_ip = pebs ? 1 : 0,
> > > > +		.aux_output = pebs ? 1 : 0,
> > >
> > > srsly?
> >
> > Hi Peter,
> >     Thanks for review. For aux_output, I think it should be set 1 when the guest wants to
> enabled PEBS by Intel PT.
> >      For precise_ip, it is the precise level in perf and set by perf command line in KVM
> guest, this may not reflect the accurate value (can be 0~3) here. Here set to 1 is used to
> allocate a counter for PEBS event and set the MSR_IA32_PEBS_ENABLE register. For
> PMU virtualization, KVM will trap the guest's write operation to PMU registers and
> allocate/free event counter from host if a counter enable/disable in guest. We can't
> always deduce the exact parameter of perf command line from the value of the guest
> writers to the register.
> 
> Please, teach your MUA to wrap on 78 chars.
> 
> The thing I really fell over is the gratuitous 'bool ? 1 : 0'. But yes, the aux_output without
> a group leader is dead wrong. We'll go fix
> perf_event_create_kernel_counter() to refuse that.

Yes, I also think it is a little gratuitous here. But it is a little hard to reconstruct the guest perf parameters from the register value, especially the "precise_ip". Do you have any advice?

About refuse the perf_event_create_kernel_counter() request w/o aux_ouput, I think I need to allocate the PT event as group leader here,  is that right?

Thanks,
Luwei Kang
