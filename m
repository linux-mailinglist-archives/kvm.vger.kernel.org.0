Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E291E9C7C
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 14:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfJ3NlM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 09:41:12 -0400
Received: from mga04.intel.com ([192.55.52.120]:45426 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbfJ3NlL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 09:41:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Oct 2019 06:41:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,247,1569308400"; 
   d="scan'208";a="283555445"
Received: from um.fi.intel.com (HELO um) ([10.237.72.57])
  by orsmga001.jf.intel.com with ESMTP; 30 Oct 2019 06:41:05 -0700
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        "Kang\, Luwei" <luwei.kang@intel.com>
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
Subject: Re: [PATCH v1 3/8] KVM: x86: Allocate performance counter for PEBS event
In-Reply-To: <20191030094941.GQ4097@hirez.programming.kicks-ass.net>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com> <1572217877-26484-4-git-send-email-luwei.kang@intel.com> <20191029144612.GK4097@hirez.programming.kicks-ass.net> <82D7661F83C1A047AF7DC287873BF1E173835B1A@SHSMSX104.ccr.corp.intel.com> <20191030094941.GQ4097@hirez.programming.kicks-ass.net>
Date:   Wed, 30 Oct 2019 15:41:04 +0200
Message-ID: <87k18mfj0v.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Oct 30, 2019 at 04:06:36AM +0000, Kang, Luwei wrote:
>> > >  static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>> > >  				  unsigned config, bool exclude_user,
>> > >  				  bool exclude_kernel, bool intr,
>> > > -				  bool in_tx, bool in_tx_cp)
>> > > +				  bool in_tx, bool in_tx_cp, bool pebs)
>> > >  {
>> > >  	struct perf_event *event;
>> > >  	struct perf_event_attr attr = {
>> > > @@ -111,9 +111,12 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>> > >  		.exclude_user = exclude_user,
>> > >  		.exclude_kernel = exclude_kernel,
>> > >  		.config = config,
>> > > +		.precise_ip = pebs ? 1 : 0,
>> > > +		.aux_output = pebs ? 1 : 0,
>> > 
>> > srsly?
>> 
>> Hi Peter,
>>     Thanks for review. For aux_output, I think it should be set 1 when the guest wants to enabled PEBS by Intel PT.
>>      For precise_ip, it is the precise level in perf and set by perf command line in KVM guest, this may not reflect the accurate value (can be 0~3) here. Here set to 1 is used to allocate a counter for PEBS event and set the MSR_IA32_PEBS_ENABLE register. For PMU virtualization, KVM will trap the guest's write operation to PMU registers and allocate/free event counter from host if a counter enable/disable in guest. We can't always deduce the exact parameter of perf command line from the value of the guest writers to the register.
>
> Please, teach your MUA to wrap on 78 chars.
>
> The thing I really fell over is the gratuitous 'bool ? 1 : 0'. But yes,

Notice the .exclude_kernel assignment above that does the same thing the
other way around.

Regards,
--
Alex
