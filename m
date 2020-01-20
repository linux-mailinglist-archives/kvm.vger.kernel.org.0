Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91BE214223F
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 04:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgATD4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jan 2020 22:56:51 -0500
Received: from ozlabs.org ([203.11.71.1]:56027 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729011AbgATD4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Jan 2020 22:56:51 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 481Hsr4GqVz9sRK; Mon, 20 Jan 2020 14:56:48 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1579492608; bh=lAGKBdtognRp9MuKBdR+5b2SjLz9x55FpMJWqSfQ6qY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dUAKAq0v+fVttWJxioZvNG0BtMhcZUat99t698VbzX1F/zlmSKB330Etdpr8dhc76
         LgQ0zJdbhuyR1H/vR0aYkaoRDTWcKoSWaqcXj6ErDly+Tn2yz7PSXHSNyMImPMl9tP
         xyavDDW3J6vU7xLt0EzjiAP8W7GOt+xqqQHnwlIoIwKSt8mNIQuX2kFmVUUOR/AB+1
         223kTr75BFvJJpA2PeWzgxHtia7sYccOJwK6fdQs+TGCFIgaTI9QqAo127pLrxO2BS
         vw/3QB56iD9jMWi9IFVNiAA2HJNbXbWM7qMcFTfg7AwfcraXsEohfC0CAqwPxUayYv
         d19QF6AMoz1qQ==
Date:   Mon, 20 Jan 2020 14:56:44 +1100
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
Message-ID: <20200120035644.GE14307@blackberry>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-16-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Another error to fix:

> diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
> index 047c9f707704..dd7440e50c7a 100644
> --- a/arch/powerpc/kvm/booke.c
> +++ b/arch/powerpc/kvm/booke.c
> @@ -2114,10 +2114,9 @@ int kvmppc_core_init_vm(struct kvm *kvm)
>  	return kvm->arch.kvm_ops->init_vm(kvm);
>  }
>  
> -int kvmppc_core_vcpu_create(struct kvm *kvm, struct kvm_vcpu *vcpu,
> -			    unsigned int id)
> +int kvmppc_core_vcpu_create(struct kvm_vcpu *vcpu)
>  {
> -	return kvm->arch.kvm_ops->vcpu_create(kvm, vcpu, id);
> +	return kvm->arch.kvm_ops->vcpu_create(vcpu);

This also needs s/kvm/vcpu->kvm/.

Paul.
