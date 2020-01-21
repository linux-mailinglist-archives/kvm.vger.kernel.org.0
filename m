Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 097AA144834
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 00:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgAUXSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 18:18:35 -0500
Received: from mga12.intel.com ([192.55.52.136]:57248 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728665AbgAUXSf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 18:18:35 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jan 2020 15:18:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,347,1574150400"; 
   d="scan'208";a="227493488"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 21 Jan 2020 15:18:33 -0800
Date:   Tue, 21 Jan 2020 15:18:33 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>, Marc Zyngier <maz@kernel.org>,
        James Hogan <jhogan@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kurz <groug@kaod.org>
Subject: Re: [PATCH v2 12/45] KVM: PPC: Allocate vcpu struct in common PPC
 code
Message-ID: <20200121231833.GB12692@linux.intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-13-sean.j.christopherson@intel.com>
 <20200120040412.GF14307@blackberry>
 <fcd2aaf1-6f6e-303a-d7c6-f6b0c0a4555c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fcd2aaf1-6f6e-303a-d7c6-f6b0c0a4555c@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 21, 2020 at 12:05:00PM +0100, Paolo Bonzini wrote:
> On 20/01/20 05:04, Paul Mackerras wrote:
> > On Wed, Dec 18, 2019 at 01:54:57PM -0800, Sean Christopherson wrote:
> >> Move allocation of all flavors of PPC vCPUs to common PPC code.  All
> >> variants either allocate 'struct kvm_vcpu' directly, or require that
> >> the embedded 'struct kvm_vcpu' member be located at offset 0, i.e.
> >> guarantee that the allocation can be directly interpreted as a 'struct
> >> kvm_vcpu' object.
> >>
> >> Remove the message from the build-time assertion regarding placement of
> >> the struct, as compatibility with the arch usercopy region is no longer
> >> the sole dependent on 'struct kvm_vcpu' being at offset zero.
> >>
> >> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > This fails to compile for Book E configs:
> > 
> >   CC      arch/powerpc/kvm/e500.o
> > /home/paulus/kernel/kvm/arch/powerpc/kvm/e500.c: In function ‘kvmppc_core_vcpu_create_e500’:
> > /home/paulus/kernel/kvm/arch/powerpc/kvm/e500.c:464:9: error: return makes integer from pointer without a cast [-Werror=int-conversion]
> >   return vcpu;
> >          ^
> > cc1: all warnings being treated as errors
> > make[3]: *** [/home/paulus/kernel/kvm/scripts/Makefile.build:266: arch/powerpc/kvm/e500.o] Error 1
> > 
> > There is a "return vcpu" statement in kvmppc_core_vcpu_create_e500(),
> > and another in kvmppc_core_vcpu_create_e500mc(), which both need to be
> > changed to "return 0".
> > 
> > (By the way, I do appreciate you fixing the PPC code, even if there
> > are some errors.)
> 
> Squashed:

Thanks for cleaning up after me, not having to rebase and resend this
series made my day :-) 

> diff --git a/arch/powerpc/kvm/e500.c b/arch/powerpc/kvm/e500.c
> index 96d9cde3d2e3..f5dd2c7adcd4 100644
> --- a/arch/powerpc/kvm/e500.c
> +++ b/arch/powerpc/kvm/e500.c
> @@ -461,7 +461,7 @@ static int kvmppc_core_vcpu_create_e500(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  		goto uninit_tlb;
>  	}
>  
> -	return vcpu;
> +	return 0;
>  
>  uninit_tlb:
>  	kvmppc_e500_tlb_uninit(vcpu_e500);
> diff --git a/arch/powerpc/kvm/e500mc.c b/arch/powerpc/kvm/e500mc.c
> index aea588f73bf7..7c0d392f667a 100644
> --- a/arch/powerpc/kvm/e500mc.c
> +++ b/arch/powerpc/kvm/e500mc.c
> @@ -327,7 +327,7 @@ static int kvmppc_core_vcpu_create_e500mc(struct kvm *kvm, struct kvm_vcpu *vcpu
>  		goto uninit_tlb;
>  	}
>  
> -	return vcpu;
> +	return 0;
>  
>  uninit_tlb:
>  	kvmppc_e500_tlb_uninit(vcpu_e500);
> 
> 
