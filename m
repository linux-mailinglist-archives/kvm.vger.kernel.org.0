Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D01029FC1
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 22:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403884AbfEXUXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 16:23:34 -0400
Received: from mga05.intel.com ([192.55.52.43]:48550 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403785AbfEXUXe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 16:23:34 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 May 2019 13:23:33 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga007.jf.intel.com with ESMTP; 24 May 2019 13:23:33 -0700
Date:   Fri, 24 May 2019 13:23:33 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Wanpeng Li <kernellwp@gmail.com>
Subject: Re: [PATCH] KVM: lapic: Reuse auto-adjusted timer advance of first
 stable vCPU
Message-ID: <20190524202333.GG365@linux.intel.com>
References: <20190508214702.25317-1-sean.j.christopherson@intel.com>
 <3ea5ae51-89b2-ee0c-d156-88198af90b95@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ea5ae51-89b2-ee0c-d156-88198af90b95@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 20, 2019 at 03:03:10PM +0200, Paolo Bonzini wrote:
> On 08/05/19 23:47, Sean Christopherson wrote:
> > +
> > +		/*
> > +		 * The first vCPU to get a stable advancement time "wins" and
> > +		 * sets the advancement time that is used for *new* vCPUS that
> > +		 * are created with auto-adjusting enabled.
> > +		 */
> > +		if (apic->lapic_timer.timer_advance_adjust_done)
> > +			(void)cmpxchg(&adjusted_timer_advance_ns, -1,
> > +				      timer_advance_ns);
> 
> This is relatively expensive, so it should only be done after setting
> timer_advance_adjust_done to true.

That's already the case, or am I missing something?

This code is inside "if (!apic->lapic_timer.timer_advance_adjust_done)",
and apic->lapic_timer.timer_advance_adjust_done is set to true at creation
time if "adjusted_timer_advance_ns != -1", i.e. the cmpxchg() will only
be reached on vCPUs that are created before adjusted_timer_advance_ns is
set and will be reached at most once per vCPU.
