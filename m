Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95ADA1E4A27
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 18:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391054AbgE0Q3f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 12:29:35 -0400
Received: from mga03.intel.com ([134.134.136.65]:32426 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387775AbgE0Q3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 12:29:34 -0400
IronPort-SDR: cExu4OzFYGI0fpFXu/ToVuk10SG2VS8DhZ++AUIkdFAm2c0bKUH1AHR62CnRDOxCiUyF41aAMT
 a8NYlhXUx23g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 09:29:34 -0700
IronPort-SDR: uh21u8SHV7+q14LtOyLYwOt+eGk8mVFEIiJNsa7gw/hjDS31OD/dq/jKYrBt7lKEEE55o6iz/G
 PfL11Fs4E5GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,442,1583222400"; 
   d="scan'208";a="291654118"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 27 May 2020 09:29:34 -0700
Date:   Wed, 27 May 2020 09:29:33 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+904752567107eefb728c@syzkaller.appspotmail.com
Subject: Re: [PATCH] KVM: x86: Initialize tdp_level during vCPU creation
Message-ID: <20200527162933.GE24461@linux.intel.com>
References: <20200527085400.23759-1-sean.j.christopherson@intel.com>
 <40800163-2b28-9879-f21b-687f89070c91@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40800163-2b28-9879-f21b-687f89070c91@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 27, 2020 at 06:17:57PM +0200, Paolo Bonzini wrote:
> On 27/05/20 10:54, Sean Christopherson wrote:
> > Initialize vcpu->arch.tdp_level during vCPU creation to avoid consuming
> > garbage if userspace calls KVM_RUN without first calling KVM_SET_CPUID.
> > 
> > Fixes: e93fd3b3e89e9 ("KVM: x86/mmu: Capture TDP level when updating CPUID")
> > Reported-by: syzbot+904752567107eefb728c@syzkaller.appspotmail.com
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/x86.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index b226fb8abe41b..01a6304056197 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9414,6 +9414,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >  	fx_init(vcpu);
> >  
> >  	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
> > +	vcpu->arch.tdp_level = kvm_x86_ops.get_tdp_level(vcpu);
> >  
> >  	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
> 
> Queued, it is probably a good idea to add a selftests testcase for this
> (it's even okay if it doesn't use the whole selftests infrastructure and
> invokes KVM_CREATE_VM/KVM_CREATE_VCPU/KVM_RUN manually).

Ya.  syzbot is hitting a #GP due to NULL pointer during debugfs on the exact
same sequence.  I haven't been able to reproduce that one (have yet to try
syzbot's exact config), but it's another example of a "dumb" test hitting
meaningful bugs.
