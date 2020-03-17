Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAE95188D0B
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 19:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgCQSWx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 14:22:53 -0400
Received: from mga04.intel.com ([192.55.52.120]:30210 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgCQSWx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 14:22:53 -0400
IronPort-SDR: 7c1EC2KIzUAwU6HcZeWRhvsfqTkhjR/AHdzdvGcHeej+/uSQ9nHh3kiQ6Lks9mbqcraVh2Xzr+
 kRG372nkY8tQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2020 11:22:52 -0700
IronPort-SDR: wfhquiynLjI52JTnso+EMzRHDns9uNj7cZE3ex2Z0u/q8HwyXcRl3UAcbQu3HtPmznTB4qd1Wv
 MaZn8sNfMiPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,565,1574150400"; 
   d="scan'208";a="247911240"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 17 Mar 2020 11:22:52 -0700
Date:   Tue, 17 Mar 2020 11:22:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 31/32] KVM: nVMX: Don't flush TLB on nested VM
 transition with EPT enabled
Message-ID: <20200317182251.GD12959@linux.intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
 <20200317045238.30434-32-sean.j.christopherson@intel.com>
 <97f91b27-65ac-9187-6b60-184e1562d228@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97f91b27-65ac-9187-6b60-184e1562d228@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 17, 2020 at 06:18:37PM +0100, Paolo Bonzini wrote:
> On 17/03/20 05:52, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index d816f1366943..a77eab5b0e8a 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -1123,7 +1123,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
> >  	}
> >  
> >  	if (!nested_ept)
> > -		kvm_mmu_new_cr3(vcpu, cr3, false);
> > +		kvm_mmu_new_cr3(vcpu, cr3, enable_ept);
> 
> Even if enable_ept == false, we could have already scheduled or flushed
> the TLB soon due to one of 1) nested_vmx_transition_tlb_flush 2)
> vpid_sync_context in prepare_vmcs02 3) the processor doing it for
> !enable_vpid.
> 
> So for !enable_ept only KVM_REQ_MMU_SYNC is needed, not
> KVM_REQ_TLB_FLUSH_CURRENT I think.  Worth adding a TODO?

Now that you point it out, I think it makes sense to unconditionally pass
%true here, i.e. rely 100% on nested_vmx_transition_tlb_flush() to do the
right thing.
