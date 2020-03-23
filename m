Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23FA118F99A
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 17:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbgCWQXc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 12:23:32 -0400
Received: from mga04.intel.com ([192.55.52.120]:36300 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgCWQXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 12:23:32 -0400
IronPort-SDR: gQzCMp241bU8eK/RZ3x29jPXZD5tVTjHHEeE/FpEcmBgTNEHxni39DUJhrf9LZPrassVE8tPmz
 chz8MUI144Ew==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 09:23:06 -0700
IronPort-SDR: MSUbytwPG21W6dHu5U5WS4F+QkOtlYnEVMtPHZM2yy05ToGOBSa/Iia6kA8iGdkqDv5h8AChKj
 rBEIy+2a4Nvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,297,1580803200"; 
   d="scan'208";a="357139587"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 23 Mar 2020 09:23:05 -0700
Date:   Mon, 23 Mar 2020 09:23:05 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/9] KVM: VMX: Configure runtime hooks using
 vmx_x86_ops
Message-ID: <20200323162305.GL28711@linux.intel.com>
References: <20200321202603.19355-1-sean.j.christopherson@intel.com>
 <20200321202603.19355-5-sean.j.christopherson@intel.com>
 <87ftdz9ryn.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ftdz9ryn.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 23, 2020 at 01:27:28PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Configure VMX's runtime hooks by modifying vmx_x86_ops directly instead
> > of using the global kvm_x86_ops.  This sets the stage for waiting until
> > after ->hardware_setup() to set kvm_x86_ops with the vendor's
> > implementation.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 15 ++++++++-------
> >  arch/x86/kvm/vmx/nested.h |  3 ++-
> >  arch/x86/kvm/vmx/vmx.c    | 27 ++++++++++++++-------------
> >  3 files changed, 24 insertions(+), 21 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 4ff859c99946..87fea22c3799 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -6241,7 +6241,8 @@ void nested_vmx_hardware_unsetup(void)
> >  	}
> >  }
> >  
> > -__init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
> > +__init int nested_vmx_hardware_setup(struct kvm_x86_ops *ops,
> > +				     int (*exit_handlers[])(struct kvm_vcpu *))
> >  {
> >  	int i;
> >  
> > @@ -6277,12 +6278,12 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
> >  	exit_handlers[EXIT_REASON_INVVPID]	= handle_invvpid;
> >  	exit_handlers[EXIT_REASON_VMFUNC]	= handle_vmfunc;
> >  
> > -	kvm_x86_ops->check_nested_events = vmx_check_nested_events;
> > -	kvm_x86_ops->get_nested_state = vmx_get_nested_state;
> > -	kvm_x86_ops->set_nested_state = vmx_set_nested_state;
> > -	kvm_x86_ops->get_vmcs12_pages = nested_get_vmcs12_pages;
> > -	kvm_x86_ops->nested_enable_evmcs = nested_enable_evmcs;
> > -	kvm_x86_ops->nested_get_evmcs_version = nested_get_evmcs_version;
> > +	ops->check_nested_events = vmx_check_nested_events;
> > +	ops->get_nested_state = vmx_get_nested_state;
> > +	ops->set_nested_state = vmx_set_nested_state;
> > +	ops->get_vmcs12_pages = nested_get_vmcs12_pages;
> > +	ops->nested_enable_evmcs = nested_enable_evmcs;
> > +	ops->nested_get_evmcs_version = nested_get_evmcs_version;
> 
> 
> A lazy guy like me would appreciate 'ops' -> 'vmx_x86_ops' rename as it
> would make 'git grep vmx_x86_ops' output more complete.

Ah, didn't think about that, obviously.
