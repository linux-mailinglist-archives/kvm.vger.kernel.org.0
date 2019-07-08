Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9324B6282E
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 20:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731029AbfGHSSA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 14:18:00 -0400
Received: from mga17.intel.com ([192.55.52.151]:44501 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728765AbfGHSSA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 14:18:00 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 11:17:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,466,1557212400"; 
   d="scan'208";a="192400011"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by fmsmga002.fm.intel.com with ESMTP; 08 Jul 2019 11:17:58 -0700
Date:   Mon, 8 Jul 2019 11:17:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com, pbonzini@redhat.com,
        jmattson@google.com
Subject: Re: [PATCH 0/5] KVM: nVMX: Skip vmentry checks that are necessary
 only if VMCS12 is dirty
Message-ID: <20190708181759.GB20791@linux.intel.com>
References: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jul 07, 2019 at 03:11:42AM -0400, Krish Sadhukhan wrote:
> The following functions,
> 
> 	nested_vmx_check_controls
> 	nested_vmx_check_host_state
> 	nested_vmx_check_guest_state
> 
> do a number of vmentry checks for VMCS12. However, not all of these checks need
> to be executed on every vmentry. This patchset makes some of these vmentry
> checks optional based on the state of VMCS12 in that if VMCS12 is dirty, only
> then the checks will be executed. This will reduce performance impact on
> vmentry of nested guests.

All of these patches break vmx_set_nested_state(), which sets dirty_vmcs12
only after the aforementioned consistency checks pass.

The new nomenclature for the dirty paths is "rare", not "full".

In general, I dislike directly associating the consistency checks with
dirty_vmcs12.

  - It's difficult to assess the correctness of the resulting code, e.g.
    changing CPU_BASED_VM_EXEC_CONTROL doesn't set dirty_vmcs12, which
    calls into question any and all SECONDARY_VM_EXEC_CONTROL checks since
    an L1 could toggle CPU_BASED_ACTIVATE_SECONDARY_CONTROLS.

  - We lose the existing organization of the consistency checks, e.g.
    similar checks get arbitrarily split into separate flows based on
    the rarity of the field changing.

  - The performance gains are likely minimal since the majority of checks
    can't be skipped due to the coarseness of dirty_vmcs12.

Rather than a quick and dirty (pun intended) change to use dirty_vmcs12,
I think we should have some amount of dedicated infrastructure for
optimizing consistency checks from the get go, e.g. perhaps something
similar to how eVMCS categorizes fields.  The initial usage could be very
coarse grained, e.g. based purely on dirty_vmcs12, but having the
infrastructure would make it easier to reason about the correctness of
the code.  Future patches could then refine the triggerring of checks to
achieve better optimization, e.g. skipping the vast majority of checks
when L1 is simply toggling CPU_BASED_VIRTUAL_INTR_PENDING.
