Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C267E96C3
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 07:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfJ3Gts convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 30 Oct 2019 02:49:48 -0400
Received: from mga06.intel.com ([134.134.136.31]:22962 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726262AbfJ3Gtr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 02:49:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Oct 2019 23:49:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,246,1569308400"; 
   d="scan'208";a="198591325"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga008.fm.intel.com with ESMTP; 29 Oct 2019 23:49:46 -0700
Received: from fmsmsx161.amr.corp.intel.com (10.18.125.9) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 29 Oct 2019 23:49:46 -0700
Received: from shsmsx108.ccr.corp.intel.com (10.239.4.97) by
 FMSMSX161.amr.corp.intel.com (10.18.125.9) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 29 Oct 2019 23:49:46 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX108.ccr.corp.intel.com ([169.254.8.41]) with mapi id 14.03.0439.000;
 Wed, 30 Oct 2019 14:49:43 +0800
From:   "Kang, Luwei" <luwei.kang@intel.com>
To:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
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
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>
Subject: RE: [PATCH v1 3/8] KVM: x86: Allocate performance counter for PEBS
 event
Thread-Topic: [PATCH v1 3/8] KVM: x86: Allocate performance counter for PEBS
 event
Thread-Index: AQHVjLd13+lWyOpx00qD/bA0eE059qdxL6sAgAEppjD//+FzAIAAhsSA
Date:   Wed, 30 Oct 2019 06:49:42 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E173835CAA@SHSMSX104.ccr.corp.intel.com>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
 <1572217877-26484-4-git-send-email-luwei.kang@intel.com>
 <20191029144612.GK4097@hirez.programming.kicks-ass.net>
 <82D7661F83C1A047AF7DC287873BF1E173835B1A@SHSMSX104.ccr.corp.intel.com>
 <87o8xyg2f1.fsf@ashishki-desk.ger.corp.intel.com>
In-Reply-To: <87o8xyg2f1.fsf@ashishki-desk.ger.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZjc4NDBlYjItZGZmYS00ODBlLWFiMTYtYWIxZThhZjYwOTY2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoia2Y3VGpQRitMU3g0MW9pXC9NQjlKRjBOWlRCaFwvcFdQWmhnT1RxSWh3OHU2eUFTTlFhcEZTRTNwSDhtbFRGMFJEIn0=
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

> >> >  static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
> >> >  				  unsigned config, bool exclude_user,
> >> >  				  bool exclude_kernel, bool intr,
> >> > -				  bool in_tx, bool in_tx_cp)
> >> > +				  bool in_tx, bool in_tx_cp, bool pebs)
> >> >  {
> >> >  	struct perf_event *event;
> >> >  	struct perf_event_attr attr = {
> >> > @@ -111,9 +111,12 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
> >> >  		.exclude_user = exclude_user,
> >> >  		.exclude_kernel = exclude_kernel,
> >> >  		.config = config,
> >> > +		.precise_ip = pebs ? 1 : 0,
> >> > +		.aux_output = pebs ? 1 : 0,
> >>
> >> srsly?
> >
> > Hi Peter,
> >     Thanks for review. For aux_output, I think it should be set 1 when the guest wants to enabled PEBS by Intel PT.
> 
> attr.aux_output==1 means your group leader should be an intel_pt event for this to succeed. Luckily for this instance,
> perf_event_create_kernel_counter() doesn't actually check the attr.aux_output.
> 
> Also, does 'bool pebs' mean PEBS-via-PT or just a PEBS counter? Or does it mean that in kvm it's the same thing?

It is the same thing. Allocate a counter for PEBS event and use PEBS-via-PT.

Thanks,
Luwei Kang

> 
> Regards,
> --
> Alex
