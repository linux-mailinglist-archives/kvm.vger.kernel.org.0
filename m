Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 121316AD9D
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 19:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387488AbfGPR1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 13:27:11 -0400
Received: from mga07.intel.com ([134.134.136.100]:43595 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728575AbfGPR1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 13:27:11 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 10:27:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,271,1559545200"; 
   d="scan'208";a="175461573"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jul 2019 10:27:10 -0700
Date:   Tue, 16 Jul 2019 10:27:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
Message-ID: <20190716172710.GD1987@linux.intel.com>
References: <20190715203043.100483-1-liran.alon@oracle.com>
 <20190715203043.100483-2-liran.alon@oracle.com>
 <1ef0f594-2039-1aeb-4fe0-edbc21fa1f60@amd.com>
 <CF48BCA4-4BC8-4AC8-8B48-85FA29E16719@oracle.com>
 <f6c78d65-70fc-4a79-44db-6abb0434db73@amd.com>
 <F2442A5C-702A-433D-9156-056E1844F378@oracle.com>
 <20190716164151.GC1987@linux.intel.com>
 <60D01C4B-EC2E-453E-B5F6-BBE8FA94E31D@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <60D01C4B-EC2E-453E-B5F6-BBE8FA94E31D@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 16, 2019 at 07:56:31PM +0300, Liran Alon wrote:
> 
> > On 16 Jul 2019, at 19:41, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > 
> > On Tue, Jul 16, 2019 at 07:20:42PM +0300, Liran Alon wrote:
> >> How can a SMAP fault occur when CPL==3? One of the conditions for SMAP is
> >> that CPL<3.
> > 
> > The CPU is effectively at CPL0 when it does the decode assist, e.g.:
> > 
> >  1. CPL3 guest hits reserved bit NPT fault (MMIO access)
> >  2. CPU transitions to CPL0 on VM-Exit
> >  3. CPU performs data access on **%rip**, encounters SMAP violation
> >  4. CPU squashes SMAP violation, sets VMCB.insn_len=0
> >  5. CPU delivers VM-Exit to software for original NPT fault
> > 
> > The original NPT fault is due to a reserved bit (or not present) entry for
> > a MMIO GPA, *not* the GPA corresponding to %rip.  The fault on the decode
> > assist is never delivered to software, it simply results in having invalid
> > info in the VMCB's insn_bytes and insn_len fields.
> 
> If the CPU performs the VMExit transition of state before doing the data read
> for DecodeAssist, then I agree that CPL will be 0 on data-access regardless
> of vCPU CPL. But this also means that SMAP violation should be raised based
> on host CR4.SMAP value and not vCPU CR4.SMAP value as KVM code checks.
> Furthermore, vCPU CPL of guest doesn’t need to be 3 in order to trigger this
> Errata.

Doh, #2 above is likely wrong.  My *guess* is that the DecodeAssist walk
starts with %rip, i.e. does a NPT walk using the guest context, and that
the access is always an implicit system (CPL0) access.

I'll get out of the way and let Brijesh answer :-)
