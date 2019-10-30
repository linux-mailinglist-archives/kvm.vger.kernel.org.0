Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF54DE9971
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 10:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfJ3JuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 05:50:12 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35384 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfJ3JuM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 05:50:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ezNM7rdzF5GJdI/K6pMEPr7zdlKZrHRBRwkru5SQrtE=; b=R0clArm67jwuWvTDRXiU7RQgq
        dN4B5u5eqgS5Qjq0APyuS4Pv7WLScC80OjqnhhiZ1AzTSOspYYy/LddVxQgL0XvQvhrmhryCHqdDk
        YsCMRVdRzsxPeiRYqfVEemenwVMq5utH23Tu0i/AZwfChMX+NgPYuLmvj2Va/+vWhoBRHEFUyXhHD
        tnGlvajJ6sVyVUanY+RcIpL5yqmalcCD32A6WlWDnJlVrCcvPgsbYURf1kIR27HMfXC6mOzzSpXKx
        EoPNz+pB6GMB9vztUBcDjYgFRLbpsrqGDI4UUuLMCsbzb6Kxe2P1UrMbXabxLMcS6nPk7nrBY0mA1
        YIm099NSA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPkbp-0008Mh-T0; Wed, 30 Oct 2019 09:49:46 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B43A03006D0;
        Wed, 30 Oct 2019 10:48:40 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CF47F2B438360; Wed, 30 Oct 2019 10:49:41 +0100 (CET)
Date:   Wed, 30 Oct 2019 10:49:41 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Kang, Luwei" <luwei.kang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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
Subject: Re: [PATCH v1 3/8] KVM: x86: Allocate performance counter for PEBS
 event
Message-ID: <20191030094941.GQ4097@hirez.programming.kicks-ass.net>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
 <1572217877-26484-4-git-send-email-luwei.kang@intel.com>
 <20191029144612.GK4097@hirez.programming.kicks-ass.net>
 <82D7661F83C1A047AF7DC287873BF1E173835B1A@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82D7661F83C1A047AF7DC287873BF1E173835B1A@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 30, 2019 at 04:06:36AM +0000, Kang, Luwei wrote:
> > >  static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
> > >  				  unsigned config, bool exclude_user,
> > >  				  bool exclude_kernel, bool intr,
> > > -				  bool in_tx, bool in_tx_cp)
> > > +				  bool in_tx, bool in_tx_cp, bool pebs)
> > >  {
> > >  	struct perf_event *event;
> > >  	struct perf_event_attr attr = {
> > > @@ -111,9 +111,12 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
> > >  		.exclude_user = exclude_user,
> > >  		.exclude_kernel = exclude_kernel,
> > >  		.config = config,
> > > +		.precise_ip = pebs ? 1 : 0,
> > > +		.aux_output = pebs ? 1 : 0,
> > 
> > srsly?
> 
> Hi Peter,
>     Thanks for review. For aux_output, I think it should be set 1 when the guest wants to enabled PEBS by Intel PT.
>      For precise_ip, it is the precise level in perf and set by perf command line in KVM guest, this may not reflect the accurate value (can be 0~3) here. Here set to 1 is used to allocate a counter for PEBS event and set the MSR_IA32_PEBS_ENABLE register. For PMU virtualization, KVM will trap the guest's write operation to PMU registers and allocate/free event counter from host if a counter enable/disable in guest. We can't always deduce the exact parameter of perf command line from the value of the guest writers to the register.

Please, teach your MUA to wrap on 78 chars.

The thing I really fell over is the gratuitous 'bool ? 1 : 0'. But yes,
the aux_output without a group leader is dead wrong. We'll go fix
perf_event_create_kernel_counter() to refuse that.
