Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C8828BE0D
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 18:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403880AbgJLQc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 12:32:28 -0400
Received: from mga03.intel.com ([134.134.136.65]:33604 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403866AbgJLQc1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 12:32:27 -0400
IronPort-SDR: L/k4CxzJQhtxmSNEtGphdVF9Njg3PH77ryEEQcFEia20g4WspuHihgaVmPNqZGppj/yBZdKlsF
 mwAoD2ZbgnpA==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165826367"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165826367"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 09:32:24 -0700
IronPort-SDR: LFDw9mqMwnWwkl/Nym0wtoCxRIccKcjrVuzWFU6MfDHtOwDzijOfp6D5k5u2dTFmIOlDrsa7eN
 +fqShnMph6qg==
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="355849108"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 09:32:22 -0700
Date:   Mon, 12 Oct 2020 09:32:21 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: VMX: Add a VMX-preemption timer
 expiration test
Message-ID: <20201012163219.GC26135@linux.intel.com>
References: <20200508203938.88508-1-jmattson@google.com>
 <D121A03E-6861-4736-8070-5D1E4FEE1D32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D121A03E-6861-4736-8070-5D1E4FEE1D32@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 10, 2020 at 01:42:26AM -0700, Nadav Amit wrote:
> > 
> > On May 8, 2020, at 1:39 PM, Jim Mattson <jmattson@google.com> wrote:
> > 
> > When the VMX-preemption timer is activated, code executing in VMX
> > non-root operation should never be able to record a TSC value beyond
> > the deadline imposed by adding the scaled VMX-preemption timer value
> > to the first TSC value observed by the guest after VM-entry.
> > 
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Peter Shier <pshier@google.com>
> 
> This test failed on my bare-metal machine (Broadwell):
> 
> Test suite: vmx_preemption_timer_expiry_test
> FAIL: Last stored guest TSC (44435478250637180) < TSC deadline (44435478250419552)
> 
> Any hints why, perhaps based on the motivation for the test?

This test also fails intermittently on my Haswell and Coffee Lake systems when
running on KVM.  I haven't done any "debug" beyond a quick glance at the test.

The intent of the test is to verify that KVM injects preemption timer VM-Exits
without violating the architectural guarantees of the timer, e.g. that the exit
isn't delayed by something else happening in the system.
