Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57A7E18242C
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 22:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbgCKVq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 17:46:58 -0400
Received: from mga17.intel.com ([192.55.52.151]:57284 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729223AbgCKVq6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 17:46:58 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Mar 2020 14:46:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,542,1574150400"; 
   d="scan'208";a="441827681"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 11 Mar 2020 14:46:57 -0700
Date:   Wed, 11 Mar 2020 14:46:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH] kvm-unit-test: nVMX: Test Selector and Base Address
 fields of Guest Segment Registers on vmentry of nested guests
Message-ID: <20200311214657.GJ21852@linux.intel.com>
References: <20200310225149.31254-1-krish.sadhukhan@oracle.com>
 <20200310225149.31254-2-krish.sadhukhan@oracle.com>
 <20200311150516.GB21852@linux.intel.com>
 <0fb906f6-574f-2e2e-4113-e9d883cb713e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fb906f6-574f-2e2e-4113-e9d883cb713e@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 11, 2020 at 01:38:24PM -0700, Krish Sadhukhan wrote:
> 
> On 3/11/20 8:05 AM, Sean Christopherson wrote:
> >>+static void test_guest_segment_sel_fields(void)
> >>+{
> >>+	u16 sel_saved;
> >>+	u16 sel;
> >>+
> >>+	sel_saved = vmcs_read(GUEST_SEL_TR);
> >>+	sel = sel_saved | 0x4;
> >>+	TEST_SEGMENT_SEL(GUEST_SEL_TR, "GUEST_SEL_TR", sel, sel_saved);
> >>+
> >>+	sel_saved = vmcs_read(GUEST_SEL_LDTR);
> >>+	sel = sel_saved | 0x4;
> >>+	TEST_SEGMENT_SEL(GUEST_SEL_LDTR, "GUEST_SEL_LDTR", sel, sel_saved);
> >>+
> >>+	if (!(vmcs_read(GUEST_RFLAGS) & X86_EFLAGS_VM) &&
> >>+	    !(vmcs_read(CPU_SECONDARY) & CPU_URG)) {
> >Rather than react to the environment, these tests should configure every
> >relevant aspect and ignore the ones it can't change.  E.g. the unit tests
> >aren't going to randomly launch a vm86 guest.  Ditto for the unusuable bit,
> >it's unlikely to be set for most segments and would be something to test
> >explicitly.
> 
> 
> Just wanted to clarify on the "unusable bit" part of your comment. Do you
> mean each of the segment register checks from the SDM should have two tests,
> one with the "unusable bit" set and the other with that bit not set,
> irrespective of the checks being conditional on the setting of that bit ?

Sort of.  In an ideal world, kvm-unit-tests would verify correctness of KVM
for both unusable=1 and unusable=0.  But, the unusable=1 validation space is
enormous, i.e. there are a bazillion combinations of random garbage that can
be thrown into GUEST_*S_{SE,ARBYTE,BASE}.  So yeah, it could be as simple as
running the same test as unusable=0, but expecting VM-Entry to succeed.

That being said, I don't understand the motivation for these tests.  KVM
doesn't have any dedicated logic for checking guest segments, i.e. these
tests are validating hardware behavior, not KVM behavior.  The validation
resources thrown at hardware dwarf what kvm-unit-tests can do, i.e. the
odds of finding a silicon bug are tiny, and the odds of such a bug being
exploitable aginst L0 are downright miniscule.
