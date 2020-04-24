Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECFF1B78F5
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 17:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgDXPKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 11:10:54 -0400
Received: from mga18.intel.com ([134.134.136.126]:34128 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbgDXPKy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 11:10:54 -0400
IronPort-SDR: GY1yEiyH3xqsNRlRQFNAB+SxvBjMmsGLe2A98xxZigxhesu3jKH7kg9ngca1gPz2AY+zao+uSV
 257vEhRHY7Vg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 08:10:49 -0700
IronPort-SDR: wmjljIv6HW5GhwZm7s0TvZQaaxz0KBjvEjC9Ruqc7fQyLP2YhAOBL90BWSJ9PLB9JeibauhHWu
 4r5VdU5DcYKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="430793969"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 24 Apr 2020 08:10:49 -0700
Date:   Fri, 24 Apr 2020 08:10:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 7/9] KVM: X86: Add userspace access interface for CET
 MSRs
Message-ID: <20200424151049.GE30013@linux.intel.com>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-8-weijiang.yang@intel.com>
 <20200423181406.GK17824@linux.intel.com>
 <20200424150246.GK24039@local-michael-cet-test>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424150246.GK24039@local-michael-cet-test>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 11:02:46PM +0800, Yang Weijiang wrote:
> On Thu, Apr 23, 2020 at 11:14:06AM -0700, Sean Christopherson wrote:
> > > +	case MSR_IA32_INT_SSP_TAB:
> > > +		if (!cet_check_ctl_msr_access(vcpu, msr_info))
> > > +			return 1;
> > > +		if (!is_64_bit_mode(vcpu))
> > 
> > This is wrong, the SDM explicitly calls out the !64 case:
> > 
> >   IA32_INTERRUPT_SSP_TABLE_ADDR (64 bits; 32 bits on processors that do not
> >   support Intel 64 architecture).
> So the check is also unnecessary as it's natual size?

It still needs a canonical check.

Note, KVM diverges from the SDM for canonical checks in that it performs
canonical checks even when the virtual CPU doesn't support 64-bit and/or
the host kernel is a 32-bit kernel.  This is intentional because the
underlying hardware will still enforce the checks, i.e. KVM needs to make
the physical CPU happy, and the number of people running KVM on hardware
without 64-bit support can probably be counted on one hand.
