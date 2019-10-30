Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E50D8E9983
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 10:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfJ3Jva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 05:51:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49498 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbfJ3Jva (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 05:51:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jRKyx6SUKkvSDFCEAwskilfMXwesN//eLUYzavH2RME=; b=jh1p16GUGKSUFIb0/7OtclVI3
        VctW84x95IpvzyFDdpO6S+2eWDs/4+uadm3iTDheOQhCt4DWeW1g7EBmHhCeVxB/duNb4CTn/u+nh
        vZHLNS8K3JmOSzqvw0NgghuKJtSCDz870/ds4FejeMaQaN/pROYJImGeGQ7o/ADYseRaN1q67bSAm
        l5adZJ4SaCpp7sIkP58clVP0R2/0cJ/BZISe0wQurnuVDTd3lGWZAcmI16ghrwMdZVed5u8zhzz5A
        cDVloQdpOv0mXEEwTbCQQ4u+MyPzrQVpRZBJbnh/HLyCA+jkuDz/R1NUOCCEKUiX5GGLLUREfmD4Y
        J6gT0z/aA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPkdA-00070s-Q6; Wed, 30 Oct 2019 09:51:08 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 538F5306B4A;
        Wed, 30 Oct 2019 10:50:06 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 736102B4574F3; Wed, 30 Oct 2019 10:51:07 +0100 (CET)
Date:   Wed, 30 Oct 2019 10:51:07 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Kang, Luwei" <luwei.kang@intel.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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
Subject: Re: [PATCH v1 3/8] KVM: x86: Allocate performance counter for PEBS
 event
Message-ID: <20191030095107.GS4097@hirez.programming.kicks-ass.net>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
 <1572217877-26484-4-git-send-email-luwei.kang@intel.com>
 <20191029144612.GK4097@hirez.programming.kicks-ass.net>
 <82D7661F83C1A047AF7DC287873BF1E173835B1A@SHSMSX104.ccr.corp.intel.com>
 <87o8xyg2f1.fsf@ashishki-desk.ger.corp.intel.com>
 <82D7661F83C1A047AF7DC287873BF1E173835CAA@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82D7661F83C1A047AF7DC287873BF1E173835CAA@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 30, 2019 at 06:49:42AM +0000, Kang, Luwei wrote:
> > >> >  static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
> > >> >  				  unsigned config, bool exclude_user,
> > >> >  				  bool exclude_kernel, bool intr,
> > >> > -				  bool in_tx, bool in_tx_cp)
> > >> > +				  bool in_tx, bool in_tx_cp, bool pebs)
> > >> >  {
> > >> >  	struct perf_event *event;
> > >> >  	struct perf_event_attr attr = {
> > >> > @@ -111,9 +111,12 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
> > >> >  		.exclude_user = exclude_user,
> > >> >  		.exclude_kernel = exclude_kernel,
> > >> >  		.config = config,
> > >> > +		.precise_ip = pebs ? 1 : 0,
> > >> > +		.aux_output = pebs ? 1 : 0,
> > >>
> > >> srsly?
> > >
> > > Hi Peter,
> > >     Thanks for review. For aux_output, I think it should be set 1 when the guest wants to enabled PEBS by Intel PT.
> > 
> > attr.aux_output==1 means your group leader should be an intel_pt event for this to succeed. Luckily for this instance,
> > perf_event_create_kernel_counter() doesn't actually check the attr.aux_output.
> > 
> > Also, does 'bool pebs' mean PEBS-via-PT or just a PEBS counter? Or does it mean that in kvm it's the same thing?
> 
> It is the same thing. Allocate a counter for PEBS event and use PEBS-via-PT.

It is not the same thing, obviously. It strictly means pebs-over-pt
here.
