Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9AB7142208
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 04:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgATDeL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jan 2020 22:34:11 -0500
Received: from ozlabs.org ([203.11.71.1]:41341 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729021AbgATDeL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Jan 2020 22:34:11 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 481HMj19Cqz9sR1; Mon, 20 Jan 2020 14:34:09 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1579491249; bh=CYQ1aZ17JhSt3DjEaZvaRhmx5aaB56ZpLc9jKEgrQHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XhZomLA0ZQA5ksrIQZqTYTjoL3DPHU68CbqTHKmAYu16fL/fIE1BYH7UjUNBUUN96
         BOuEpy2CunYKbeiub7mIts8QMfAiWmeBeKcarVFg26ySQX+0isv7JeVEL1d4Z7b45d
         5m7sEPD4iauKp3dpRpTlihU23q+pd7On1gqkqYQPHrJPglWg+MBbDBmbYJkatU8xz0
         Uz3Fq5i/6DiaknB95EBdraZENg7mGA9XAyQVsRAdFWKMiy5SfqI7mq2lhpVa6uDvRO
         oWMfXTCMsTK2ig1sBV5Ak32Iy5mNr3ucrWW4O2iQ2wR/sSeHCe8APza70YCBWrJGVb
         GMaswqr6dHlKA==
Date:   Mon, 20 Jan 2020 14:34:02 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
Subject: Re: [PATCH v2 15/45] KVM: PPC: Move kvm_vcpu_init() invocation to
 common code
Message-ID: <20200120033402.GC14307@blackberry>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-16-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191218215530.2280-16-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 18, 2019 at 01:55:00PM -0800, Sean Christopherson wrote:
> Move the kvm_cpu_{un}init() calls to common PPC code as an intermediate
> step towards removing kvm_cpu_{un}init() altogether.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

This doesn't compile:

  CC [M]  arch/powerpc/kvm/book3s.o
/home/paulus/kernel/kvm/arch/powerpc/kvm/book3s.c: In function ‘kvmppc_core_vcpu_create’:
/home/paulus/kernel/kvm/arch/powerpc/kvm/book3s.c:794:9: error: ‘kvm’ undeclared (first use in this function)
  return kvm->arch.kvm_ops->vcpu_create(vcpu);
         ^
/home/paulus/kernel/kvm/arch/powerpc/kvm/book3s.c:794:9: note: each undeclared identifier is reported only once for each function it appears in
/home/paulus/kernel/kvm/arch/powerpc/kvm/book3s.c:795:1: warning: control reaches end of non-void function [-Wreturn-type]
 }
 ^
make[3]: *** [/home/paulus/kernel/kvm/scripts/Makefile.build:266: arch/powerpc/kvm/book3s.o] Error 1

> diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
> index 13385656b90d..5ad20fc0c6a1 100644
> --- a/arch/powerpc/kvm/book3s.c
> +++ b/arch/powerpc/kvm/book3s.c
> @@ -789,10 +789,9 @@ void kvmppc_decrementer_func(struct kvm_vcpu *vcpu)
>  	kvm_vcpu_kick(vcpu);
>  }
>  
> -int kvmppc_core_vcpu_create(struct kvm *kvm, struct kvm_vcpu *vcpu,
> -			    unsigned int id)
> +int kvmppc_core_vcpu_create(struct kvm_vcpu *vcpu)
>  {
> -	return kvm->arch.kvm_ops->vcpu_create(kvm, vcpu, id);
> +	return kvm->arch.kvm_ops->vcpu_create(vcpu);

Needs s/kvm/vcpu->kvm/ here.

You also need to change the declaration of the vcpu_create function
pointer in the kvmppc_ops struct in kvm_ppc.h to have just the vcpu
parameter instead of 3 parameters.

Paul.
