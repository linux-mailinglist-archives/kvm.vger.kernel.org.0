Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A733640B3
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 13:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238650AbhDSLou (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 07:44:50 -0400
Received: from mga12.intel.com ([192.55.52.136]:6729 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232530AbhDSLot (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 07:44:49 -0400
IronPort-SDR: GfaJ/B6LuCsr286pOew442ZcbbfdmLxIjRKL8HF85IR4pJ47OhvQ4fPFCs96eqMYctMIOdTKsu
 G9Tng2JSIFpg==
X-IronPort-AV: E=McAfee;i="6200,9189,9958"; a="174799633"
X-IronPort-AV: E=Sophos;i="5.82,234,1613462400"; 
   d="scan'208";a="174799633"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2021 04:44:20 -0700
IronPort-SDR: 9/tjO/HwJm57vhHJbzRUUvfTb0gc45dvntD9P+C1Sbjv/vPmN3AnNPIji+MSFwAB+JNs5eNos8
 ht3JS53D7rzQ==
X-IronPort-AV: E=Sophos;i="5.82,234,1613462400"; 
   d="scan'208";a="419968835"
Received: from nmpepper-mobl1.amr.corp.intel.com ([10.254.115.49])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2021 04:44:16 -0700
Message-ID: <3d376fef419077376eecb017ab494ba7ffc393a7.camel@intel.com>
Subject: Re: [PATCH v5 10/11] KVM: VMX: Enable SGX virtualization for SGX1,
 SGX2 and LC
From:   Kai Huang <kai.huang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org
Cc:     seanjc@google.com, bp@alien8.de, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
Date:   Mon, 19 Apr 2021 23:44:14 +1200
In-Reply-To: <9f568584-8b09-afe6-30a1-cbe280749f5d@redhat.com>
References: <cover.1618196135.git.kai.huang@intel.com>
         <a99e9c23310c79f2f4175c1af4c4cbcef913c3e5.1618196135.git.kai.huang@intel.com>
         <9f568584-8b09-afe6-30a1-cbe280749f5d@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2021-04-17 at 16:11 +0200, Paolo Bonzini wrote:
> On 12/04/21 06:21, Kai Huang wrote:
> > @@ -4377,6 +4380,15 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
> >   	if (!vcpu->kvm->arch.bus_lock_detection_enabled)
> >   		exec_control &= ~SECONDARY_EXEC_BUS_LOCK_DETECTION;
> >   
> > 
> > +	if (cpu_has_vmx_encls_vmexit() && nested) {
> > +		if (guest_cpuid_has(vcpu, X86_FEATURE_SGX))
> > +			vmx->nested.msrs.secondary_ctls_high |=
> > +				SECONDARY_EXEC_ENCLS_EXITING;
> > +		else
> > +			vmx->nested.msrs.secondary_ctls_high &=
> > +				~SECONDARY_EXEC_ENCLS_EXITING;
> > +	}
> > +
> 
> This is incorrect, I've removed it.  The MSRs can only be written by 
> userspace.
> 
> If SGX is disabled in the guest CPUID, nested_vmx_exit_handled_encls can 
> just do:
> 
> 	if (!guest_cpuid_has(vcpu, X86_FEATURE_SGX) ||
> 	    !nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENCLS_EXITING))
> 		return false;
> 
> and the useless ENCLS exiting bitmap in vmcs12 will be ignored.
> 
> Paolo
> 

Thanks for queuing this series!

Looks good to me. However if I read code correctly, in this way a side effect would be
vmx->nested.msrs.secondary_ctls_high will always have SECONDARY_EXEC_ENCLS_EXITING bit
set, even SGX is not exposed to guest, which means a guest can set this even SGX is not
present, but I think it is OK since ENCLS exiting bitmap in vmcs12 will be ignored anyway
in nested_vmx_exit_handled_encls() as you mentioned above.

Anyway, I have tested this code and it works at my side (by creating L2 with SGX support
and running SGX workloads inside it).

Sean, please also comment if you have any.


