Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBB91BC4EB
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 18:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbgD1QRm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 12:17:42 -0400
Received: from mga12.intel.com ([192.55.52.136]:37679 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728156AbgD1QRl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 12:17:41 -0400
IronPort-SDR: zf7GrIhMBjxFAYhNqoINlsjBiaU5VnMSFSAWszRXvRISkAKbfsUDW+WH0OAkXb1IuoK0LQl2mz
 0daagmj8pVwQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2020 09:17:41 -0700
IronPort-SDR: habY9dDlpjQSbFwhsKrvFROBzve+61bPVytg/y6AG7KN3g3EJj0oWnK86Qswq51t94UxTKiLT8
 zElpX3RgXOQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,328,1583222400"; 
   d="scan'208";a="367543361"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 28 Apr 2020 09:17:40 -0700
Date:   Tue, 28 Apr 2020 09:17:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: nVMX: Tweak handling of failure code for nested
 VM-Enter failure
Message-ID: <20200428161740.GE12735@linux.intel.com>
References: <20200424171925.1178-1-sean.j.christopherson@intel.com>
 <CALMp9eRG=L_dQfS_qpYhJ_86B-yyfYYg+pwcixQOfWT4hwCa1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRG=L_dQfS_qpYhJ_86B-yyfYYg+pwcixQOfWT4hwCa1Q@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 10:47:04AM -0700, Jim Mattson wrote:
> On Fri, Apr 24, 2020 at 10:19 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >         if (from_vmentry) {
> >                 exit_reason = EXIT_REASON_MSR_LOAD_FAIL;
> > -               exit_qual = nested_vmx_load_msr(vcpu,
> > -                                               vmcs12->vm_entry_msr_load_addr,
> > -                                               vmcs12->vm_entry_msr_load_count);
> > -               if (exit_qual)
> > +               failed_msr = nested_vmx_load_msr(vcpu,
> > +                                                vmcs12->vm_entry_msr_load_addr,
> > +                                                vmcs12->vm_entry_msr_load_count);
> > +               if (failed_msr) {
> > +                       entry_failure_code = failed_msr;
> 
> This assignment is a bit dodgy from a type perspective, and suggests
> that perhaps a better type for the local variable is an
> undiscriminated union of the enumerated type and a sufficiently large
> unsigned integer type. But I won't be a stickler if you add a comment.
> :-)

This is a bit ugly.  A union doesn't work well because writing the enum
field isn't guaranteed to write the full width of the union, i.e. could
lead to uninitialized variable usage without additional initialization
of the union.  The reverse is true as well, e.g. if the compiler sizes the
enum to be larger than an unisigned int.

Rather than use a common local variable, I think it's best to set vmcs12
directly.  That also provides an opportunity to set exit_reason on demand
instead of speculatively setting it, which has always bugged me.

v2 incoming.
