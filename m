Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 687C1802F5
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2019 00:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392490AbfHBWsn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 18:48:43 -0400
Received: from mga07.intel.com ([134.134.136.100]:4182 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728242AbfHBWsn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 18:48:43 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Aug 2019 15:48:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,339,1559545200"; 
   d="scan'208";a="184715679"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga002.jf.intel.com with ESMTP; 02 Aug 2019 15:48:42 -0700
Date:   Fri, 2 Aug 2019 15:48:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Unconditionally call x86 ops that are always
 implemented
Message-ID: <20190802224842.GB23165@linux.intel.com>
References: <20190801164606.20777-1-sean.j.christopherson@intel.com>
 <3337d56f-de99-6879-96c2-0255db68541d@oracle.com>
 <20190801214207.GF6783@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190801214207.GF6783@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 01, 2019 at 02:42:07PM -0700, Sean Christopherson wrote:
> On Thu, Aug 01, 2019 at 02:39:38PM -0700, Krish Sadhukhan wrote:
> > 
> > 
> > On 08/01/2019 09:46 AM, Sean Christopherson wrote:
> > >Remove two stale checks for non-NULL ops now that they're implemented by
> > >both VMX and SVM.
> > >
> > >Fixes: 74f169090b6f ("kvm/svm: Setup MCG_CAP on AMD properly")
> > >Fixes: b31c114b82b2 ("KVM: X86: Provide a capability to disable PAUSE intercepts")
> > >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > >---
> > >  arch/x86/kvm/x86.c | 8 ++------
> > >  1 file changed, 2 insertions(+), 6 deletions(-)
> > >
> > >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > >index 01e18caac825..2c25a19d436f 100644
> > >--- a/arch/x86/kvm/x86.c
> > >+++ b/arch/x86/kvm/x86.c
> > >@@ -3506,8 +3506,7 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
> > >  	for (bank = 0; bank < bank_num; bank++)
> > >  		vcpu->arch.mce_banks[bank*4] = ~(u64)0;
> > >-	if (kvm_x86_ops->setup_mce)
> > >-		kvm_x86_ops->setup_mce(vcpu);
> > >+	kvm_x86_ops->setup_mce(vcpu);
> > >  out:
> > >  	return r;
> > >  }
> > >@@ -9313,10 +9312,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> > >  	kvm_page_track_init(kvm);
> > >  	kvm_mmu_init_vm(kvm);
> > >-	if (kvm_x86_ops->vm_init)
> > >-		return kvm_x86_ops->vm_init(kvm);
> > >-
> > >-	return 0;
> > >+	return kvm_x86_ops->vm_init(kvm);
> > >  }
> > >  static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
> > 
> > The following two ops are also implemented by both VMX and SVM:
> > 
> >         update_cr8_intercept
> >         update_pi_irte
> 
> Drat, I didn't think to grep for !kvm_x86_ops.  I'll spin a v2.  Thanks!

Ah, but update_cr8_intercept is zapped by VMX if hardware doesn't support
the TPR shadow.

P.S. I meant to send this before posting v2, but I got distracted...
