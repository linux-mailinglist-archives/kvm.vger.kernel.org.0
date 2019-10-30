Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41468E9686
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 07:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfJ3GmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 02:42:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:28720 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbfJ3GmR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 02:42:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Oct 2019 23:42:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,246,1569308400"; 
   d="scan'208";a="374797609"
Received: from um.fi.intel.com (HELO um) ([10.237.72.57])
  by orsmga005.jf.intel.com with ESMTP; 29 Oct 2019 23:42:11 -0700
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     "Kang\, Luwei" <luwei.kang@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar\@redhat.com" <rkrcmar@redhat.com>,
        "Christopherson\, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets\@redhat.com" <vkuznets@redhat.com>,
        "wanpengli\@tencent.com" <wanpengli@tencent.com>,
        "jmattson\@google.com" <jmattson@google.com>,
        "joro\@8bytes.org" <joro@8bytes.org>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "mingo\@redhat.com" <mingo@redhat.com>,
        "bp\@alien8.de" <bp@alien8.de>, "hpa\@zytor.com" <hpa@zytor.com>,
        "x86\@kernel.org" <x86@kernel.org>,
        "ak\@linux.intel.com" <ak@linux.intel.com>,
        "thomas.lendacky\@amd.com" <thomas.lendacky@amd.com>,
        "acme\@kernel.org" <acme@kernel.org>,
        "mark.rutland\@arm.com" <mark.rutland@arm.com>,
        "jolsa\@redhat.com" <jolsa@redhat.com>,
        "namhyung\@kernel.org" <namhyung@kernel.org>,
        alexander.shishkin@linux.intel.com
Subject: RE: [PATCH v1 3/8] KVM: x86: Allocate performance counter for PEBS event
In-Reply-To: <82D7661F83C1A047AF7DC287873BF1E173835B1A@SHSMSX104.ccr.corp.intel.com>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com> <1572217877-26484-4-git-send-email-luwei.kang@intel.com> <20191029144612.GK4097@hirez.programming.kicks-ass.net> <82D7661F83C1A047AF7DC287873BF1E173835B1A@SHSMSX104.ccr.corp.intel.com>
Date:   Wed, 30 Oct 2019 08:42:10 +0200
Message-ID: <87o8xyg2f1.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Kang, Luwei" <luwei.kang@intel.com> writes:

>> >  static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>> >  				  unsigned config, bool exclude_user,
>> >  				  bool exclude_kernel, bool intr,
>> > -				  bool in_tx, bool in_tx_cp)
>> > +				  bool in_tx, bool in_tx_cp, bool pebs)
>> >  {
>> >  	struct perf_event *event;
>> >  	struct perf_event_attr attr = {
>> > @@ -111,9 +111,12 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>> >  		.exclude_user = exclude_user,
>> >  		.exclude_kernel = exclude_kernel,
>> >  		.config = config,
>> > +		.precise_ip = pebs ? 1 : 0,
>> > +		.aux_output = pebs ? 1 : 0,
>> 
>> srsly?
>
> Hi Peter,
>     Thanks for review. For aux_output, I think it should be set 1 when the guest wants to enabled PEBS by Intel PT.

attr.aux_output==1 means your group leader should be an intel_pt event
for this to succeed. Luckily for this instance,
perf_event_create_kernel_counter() doesn't actually check the
attr.aux_output.

Also, does 'bool pebs' mean PEBS-via-PT or just a PEBS counter? Or does
it mean that in kvm it's the same thing?

Regards,
--
Alex
