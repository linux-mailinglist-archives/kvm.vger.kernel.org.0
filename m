Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4A4216811
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 10:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgGGIOq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 04:14:46 -0400
Received: from mga05.intel.com ([192.55.52.43]:15586 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgGGIOq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 04:14:46 -0400
IronPort-SDR: 3ZrIrXrnREHacF2pCqf+vwnyJzdp+/UsBry5nrR9vLtGCnxtSyEC9pFQ5IPWFKU5kzkU/snJhm
 ANXd8Eua5XGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="232418321"
X-IronPort-AV: E=Sophos;i="5.75,323,1589266800"; 
   d="scan'208";a="232418321"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 01:14:45 -0700
IronPort-SDR: iWXnmWfF7WjbYVS9uIAnIyK+6IP6h3A3sqKLYfhU4aGaOJsqtU2fu934B8nCftSomqWeGCt0Kf
 Ey81F/WybHAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,323,1589266800"; 
   d="scan'208";a="279528555"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga003.jf.intel.com with ESMTP; 07 Jul 2020 01:14:44 -0700
Date:   Tue, 7 Jul 2020 01:14:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] kvm: x86: rewrite kvm_spec_ctrl_valid_bits
Message-ID: <20200707081444.GA7417@linux.intel.com>
References: <20200702174455.282252-1-mlevitsk@redhat.com>
 <20200702181606.GF3575@linux.intel.com>
 <3793ae0da76fe00036ed0205b5ad8f1653f58ef2.camel@redhat.com>
 <20200707061105.GH5208@linux.intel.com>
 <7c1d9bbe-5f59-5b86-01e9-43c929b24218@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c1d9bbe-5f59-5b86-01e9-43c929b24218@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Aren't you supposed to be on vacation? :-)

On Tue, Jul 07, 2020 at 10:04:22AM +0200, Paolo Bonzini wrote:
> On 07/07/20 08:11, Sean Christopherson wrote:
> > One oddity with this whole thing is that by passing through the MSR, KVM is
> > allowing the guest to write bits it doesn't know about, which is definitely
> > not normal.  It also means the guest could write bits that the host VMM
> > can't.
> 
> That's true.  However, the main purpose of the kvm_spec_ctrl_valid_bits
> check is to ensure that host-initiated writes are valid; this way, you
> don't get a #GP on the next vmentry's WRMSR to MSR_IA32_SPEC_CTRL.
> Checking the guest CPUID bit is not even necessary.

Right, what I'm saying is that rather than try and decipher specs to
determine what bits are supported, just throw the value at hardware and
go from there.  That's effectively what we end up doing for the guest writes
anyways.

Actually, the current behavior will break migration if there are ever legal
bits that KVM doesn't recognize, e.g. guest writes a value that KVM doesn't
allow and then migration fails when the destination tries to stuff the value
into KVM.
