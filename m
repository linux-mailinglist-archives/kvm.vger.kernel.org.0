Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D341E1C748F
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 17:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbgEFP0A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 11:26:00 -0400
Received: from mga17.intel.com ([192.55.52.151]:41773 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730101AbgEFPZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 11:25:58 -0400
IronPort-SDR: dcHSiCM3vgRR09duiMv0QcXUIDYQO4+xZ+DCiE3+dnxMvjrGdVYfja9Rz01cMl2qdVt7deD7CQ
 KJSW4vgHK4Xw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 08:25:56 -0700
IronPort-SDR: H8WpSrdasOv+Eg9opQHuG6IWm1U6e//IfKS9wZqZkRr4I+v89g3/UVRynO3LhlWtKN1frMjQ3R
 SwXLIXOW6b6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,359,1583222400"; 
   d="scan'208";a="251226510"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 06 May 2020 08:25:55 -0700
Date:   Wed, 6 May 2020 08:25:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH] kvm: x86: get vmcs12 pages before checking pending
 interrupts
Message-ID: <20200506152555.GA3329@linux.intel.com>
References: <20200505232201.923-1-oupton@google.com>
 <262881d0-cc24-99c2-2895-c5cbdc3487d0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <262881d0-cc24-99c2-2895-c5cbdc3487d0@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 06, 2020 at 02:07:17PM +0200, Paolo Bonzini wrote:
> On 06/05/20 01:22, Oliver Upton wrote:
> > +	/*
> > +	 * We must first get the vmcs12 pages before checking for interrupts
> > +	 * (done in kvm_arch_vcpu_runnable) in case L1 is using
> > +	 * virtual-interrupt delivery.
> > +	 */
> > +	if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu)) {
> > +		if (unlikely(!kvm_x86_ops.nested_ops->get_vmcs12_pages(vcpu)))
> > +			return 0;
> > +	}
> > +
> 
> 
> The patch is a bit ad hoc, I'd rather move the whole "if
> (kvm_request_pending(vcpu))" from vcpu_enter_guest to vcpu_run (via a
> new function).

It might make sense to go with an ad hoc patch to get the thing fixed, then
worry about cleaning up the pending request crud.  It'd be nice to get rid
of the extra nested_ops->check_events() call in kvm_vcpu_running(), as well
as all of the various request checks in (or triggered by) vcpu_block().

I was very tempted to dive into that mess when working on the nested events
stuff, but was afraid that I would be opening up pandora's box.
