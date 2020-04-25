Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D721B853C
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 11:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgDYJ0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 05:26:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:58013 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbgDYJ0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 05:26:49 -0400
IronPort-SDR: apiDngCKYF3FELEZVm8E7POm7MkrXQP7XNUDpmOOfGiKv+XBlaZwMLgfdcadzm5EbJmQYKpFaS
 l2esYUPPwmYg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2020 02:26:49 -0700
IronPort-SDR: OGUwxH2c3aAWuWNGOrK46cidTHHZsGVnRUv4X5ca6oJS58nyRdi/AV9QOh5wpfr2E5/3gPoS6m
 qLVW9aDUiDwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,315,1583222400"; 
   d="scan'208";a="256679320"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga003.jf.intel.com with ESMTP; 25 Apr 2020 02:26:47 -0700
Date:   Sat, 25 Apr 2020 17:28:48 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 7/9] KVM: X86: Add userspace access interface for CET
 MSRs
Message-ID: <20200425092847.GC26221@local-michael-cet-test>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-8-weijiang.yang@intel.com>
 <20200423181406.GK17824@linux.intel.com>
 <20200424150246.GK24039@local-michael-cet-test>
 <20200424151049.GE30013@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424151049.GE30013@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 08:10:49AM -0700, Sean Christopherson wrote:
> On Fri, Apr 24, 2020 at 11:02:46PM +0800, Yang Weijiang wrote:
> > On Thu, Apr 23, 2020 at 11:14:06AM -0700, Sean Christopherson wrote:
> > > > +	case MSR_IA32_INT_SSP_TAB:
> > > > +		if (!cet_check_ctl_msr_access(vcpu, msr_info))
> > > > +			return 1;
> > > > +		if (!is_64_bit_mode(vcpu))
> > > 
> > > This is wrong, the SDM explicitly calls out the !64 case:
> > > 
> > >   IA32_INTERRUPT_SSP_TABLE_ADDR (64 bits; 32 bits on processors that do not
> > >   support Intel 64 architecture).
> > So the check is also unnecessary as it's natual size?
> 
> It still needs a canonical check.
> 
> Note, KVM diverges from the SDM for canonical checks in that it performs
> canonical checks even when the virtual CPU doesn't support 64-bit and/or
> the host kernel is a 32-bit kernel.  This is intentional because the
> underlying hardware will still enforce the checks, i.e. KVM needs to make
> the physical CPU happy, and the number of people running KVM on hardware
> without 64-bit support can probably be counted on one hand.
Got it, thank you!
