Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0764E1686A8
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 19:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729530AbgBUS2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 13:28:15 -0500
Received: from mga12.intel.com ([192.55.52.136]:11194 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbgBUS2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 13:28:14 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Feb 2020 10:28:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,469,1574150400"; 
   d="scan'208";a="229271098"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga007.fm.intel.com with ESMTP; 21 Feb 2020 10:28:13 -0800
Date:   Fri, 21 Feb 2020 10:28:13 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] KVM: x86: Move #PF retry tracking variables into
 emulation context
Message-ID: <20200221182813.GK12665@linux.intel.com>
References: <20200218230310.29410-1-sean.j.christopherson@intel.com>
 <20200218230310.29410-4-sean.j.christopherson@intel.com>
 <40c8d560-1a5d-d592-5682-720980ca3dd9@redhat.com>
 <20200219151644.GB15888@linux.intel.com>
 <d5626891-82f6-0a0c-401c-89a901a8455d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5626891-82f6-0a0c-401c-89a901a8455d@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 21, 2020 at 06:14:03PM +0100, Paolo Bonzini wrote:
> On 19/02/20 16:16, Sean Christopherson wrote:
> > The easy solution to that is to move retry_instruction() into emulate.c.
> > That would also allow making x86_page_table_writing_insn() static.  All
> > other functions invoked from retry_instruction() are exposed via kvm_host.h.
> 
> emulate.c is supposed to invoke no (or almost no) function outside the
> ctxt->ops struct.  In particular, retry_instruction() invokes
> kvm_mmu_gva_to_gpa_write and kvm_mmu_unprotect_page.

Ah, right.  We could split the logic, e.g.

	if (x86_retry_pf_instruction(ctxt, cr2_or_gpa, emulation_type)) {
		gpa_t = gpa = cr2_or_gpa;

		if (!vcpu->arch.mmu->direct_map)
			gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);

		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
		return 1;
	}

but that's probably a net negative in terms of clarity.  And there's also
vcpu->arch.write_fault_to_shadow_pgtable, which is consumed only by
reexecute_instruction(), and I 100% agree that that variable should stay
in vcpu->arch.  Moving one flag used to retry #PF instructions and not the
other would be weird.

That was a long winded way of saying I agree we should drop this patch :-)
