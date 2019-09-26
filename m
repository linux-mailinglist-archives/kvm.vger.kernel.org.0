Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08F83BF518
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 16:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfIZOcC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 10:32:02 -0400
Received: from mga05.intel.com ([192.55.52.43]:35081 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726984AbfIZOcC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 10:32:02 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 07:32:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,552,1559545200"; 
   d="scan'208";a="190021619"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 26 Sep 2019 07:32:01 -0700
Date:   Thu, 26 Sep 2019 07:32:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Orr <marcorr@google.com>, kvm@vger.kernel.org,
        jmattson@google.com, pshier@google.com, krish.sadhukhan@oracle.com,
        rkrcmar@redhat.com, dinechin@redhat.com
Subject: Re: [kvm-unit-tests PATCH v7 2/2] x86: nvmx: test max atomic switch
 MSRs
Message-ID: <20190926143201.GA4738@linux.intel.com>
References: <20190925011821.24523-1-marcorr@google.com>
 <20190925011821.24523-2-marcorr@google.com>
 <91eb40a0-c436-5737-aa8a-c657b7221be2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91eb40a0-c436-5737-aa8a-c657b7221be2@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 26, 2019 at 11:24:57AM +0200, Paolo Bonzini wrote:
> On 25/09/19 03:18, Marc Orr wrote:
> > diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> > index 694ee3d42f3a..05122cf91ea1 100644
> > --- a/x86/unittests.cfg
> > +++ b/x86/unittests.cfg
> > @@ -227,7 +227,7 @@ extra_params = -cpu qemu64,+umip
> >  
> >  [vmx]
> >  file = vmx.flat
> > -extra_params = -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test"
> > +extra_params = -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test"
> >  arch = x86_64
> >  groups = vmx
> 
> I just noticed this, why is the test disabled by default?

The negative test triggers undefined behavior, e.g. on bare metal the
test would fail because VM-Enter would succeed due to lack of an explicit
check on the MSR count.

Since the test relies on somehwat arbitrary KVM behavior, we made it opt-in.
