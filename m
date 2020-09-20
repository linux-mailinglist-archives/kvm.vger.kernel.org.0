Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5002715A0
	for <lists+kvm@lfdr.de>; Sun, 20 Sep 2020 18:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgITQQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Sep 2020 12:16:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:34883 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726311AbgITQQD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Sep 2020 12:16:03 -0400
IronPort-SDR: Z/btV2oIZEGEE4OQBmo0xIMclj5hatdZqETj6rkChzv1weMYldD50leviV/xs7ANQWDPZohkAK
 vcowZdJMwHcQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9750"; a="147907847"
X-IronPort-AV: E=Sophos;i="5.77,283,1596524400"; 
   d="scan'208";a="147907847"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2020 09:16:03 -0700
IronPort-SDR: 2OiPkCNNx5PxzODqcuEyjmlGwl+i9mA/YoOKObe+NWpf6W3Imv6Rv9aqis8zuAINJgB2P3Fa99
 forf2oD8sLNA==
X-IronPort-AV: E=Sophos;i="5.77,283,1596524400"; 
   d="scan'208";a="453615387"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2020 09:16:03 -0700
Date:   Sun, 20 Sep 2020 09:16:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4 2/2] KVM: nSVM: implement ondemand allocation of the
 nested state
Message-ID: <20200920161602.GA17325@linux.intel.com>
References: <20200917101048.739691-1-mlevitsk@redhat.com>
 <20200917101048.739691-3-mlevitsk@redhat.com>
 <20200917162942.GE13522@sjchrist-ice>
 <d9c0d190-c6ea-2e21-92ca-2a53efb86a1d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9c0d190-c6ea-2e21-92ca-2a53efb86a1d@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 19, 2020 at 05:09:09PM +0200, Paolo Bonzini wrote:
> On 17/09/20 18:29, Sean Christopherson wrote:
> >> +				vcpu->arch.efer = old_efer;
> >> +				kvm_make_request(KVM_REQ_OUT_OF_MEMORY, vcpu);
> > I really dislike KVM_REQ_OUT_OF_MEMORY.  It's redundant with -ENOMEM and
> > creates a huge discrepancy with respect to existing code, e.g. nVMX returns
> > -ENOMEM in a similar situation.
> 
> Maxim, your previous version was adding some error handling to
> kvm_x86_ops.set_efer.  I don't remember what was the issue; did you have
> any problems propagating all the errors up to KVM_SET_SREGS (easy),
> kvm_set_msr (harder) etc.?

I objected to letting .set_efer() return a fault.  A relatively minor issue is
the code in vmx_set_efer() that handles lack of EFER because technically KVM
can emulate EFER.SCE+SYSCALL without supporting EFER in hardware.  Returning
success/'0' would avoid that particular issue.  My primary concern is that I'd
prefer not to add another case where KVM can potentially ignore a fault
indicated by a helper, a la vmx_set_cr4().

To that end, I'd be ok with adding error handling to .set_efer() if KVM
enforces, via WARN in one of the .set_efer() call sites, that SVM/VMX can only
return negative error codes, i.e. let SVM handle the -ENOMEM case but disallow
fault injection.  It doesn't actually change anything, but it'd give me a warm
fuzzy feeling.
