Return-Path: <kvm+bounces-26137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25F8E971E4F
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 17:41:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1D85285231
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 15:41:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 365034D8B1;
	Mon,  9 Sep 2024 15:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nl4xEppp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD583B791
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 15:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725896482; cv=none; b=TEIDgFzd2lAVI9v+6a8RDc/gWAPFK5HWtSUV/IGpqtngmJ8ptnQcfErpOZTVIV2o4x8pFMza7UOLeQ81el9VCDLwfkhnBpymAw3ipv4IR3ahnBgpkBNKf//grOry0g7stH6SJTECjjxvlK/TSLUTF94fsd6/zzqUsJZnfjr7kTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725896482; c=relaxed/simple;
	bh=zZxnXquR9DYCPBjgjvpa9fPaOPw1UKc4QBW+bwvYbBI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kbn7TCelAz4NgjrBV2uA3O3u6U80rjsJowunUiEM0pkh8fQ9OSOYGYGkPFNWgFIGyUlFMBVCJ3ANOwMHmAo3G5RUoZjKDZ3AxVJt+ve/S6oVMi0xW3Dtext2IN3gwDd/QfcE5hQJPyezBTetxjrZ2sCg7diN33wj6LdZo9yWWVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nl4xEppp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725896478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JI9jdrA1pwrzYoUJkQ/dbUC0Ow4MhaVrQtDY9JRYPWw=;
	b=Nl4xEpppzoFt1b+vDHW+CYZWhQY27S6H2/Cym2cJ4weyMAoMMRHotBkO25QtWZ525Mv9LM
	TaHu+kDVTzZsU7DjTGGGQ7yPnLnJMujQOE+rZcVmK+I4ndmZpUc1oa+U7RMQy8LdiorY44
	tLGk8IKUY/3/Sxi1CWgum7ODPEJw2Xw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-UgysphTHMim5foRLmt1mvg-1; Mon, 09 Sep 2024 11:41:17 -0400
X-MC-Unique: UgysphTHMim5foRLmt1mvg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42cbadcbb6eso4653865e9.2
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 08:41:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725896476; x=1726501276;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JI9jdrA1pwrzYoUJkQ/dbUC0Ow4MhaVrQtDY9JRYPWw=;
        b=qBlHJdbJiX3ylFEgNlCnSV19pF+p1Ix2L6/OcOqmUBqS4MSFHwk89bmCyy64WNBlGS
         skpn9PIimqwNWGiXRn+7/a+uCg30cLtswB+gloYGEhtGgnrmfEjhnVtF7IddtCEMdV1A
         mW7kOF0tv85kQ4AI9cmb2TSdTdcrSGVyLYdPg24t4vCRLbJ2rDN3BKmwZ2ui1Y9Vr0Q1
         C4RdPpG3Qgcm31g/UMyC64wcH9wOQIPR1ITdWJrwJEvu2W7pm7O3f4PZy5gNPyaiRdWf
         qXW1XjyoqrMNFXF0wcu88uEp1AyfhANWrM6xbnUuXAJIVTkTOxHvlmdwu3s2RxWowWQ+
         6C4g==
X-Forwarded-Encrypted: i=1; AJvYcCW8p4vP8rR7zSDxFtSzTUEtfOAhChiwNqlM+ZjofVf3Y/w5mDooWBLBuTBIZCF/GU+mC9I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf7CzCipDXWCeAiAaXkzK3PeoWSagetOU/A5A/K/yvJ/zc1F4I
	KR/diRmWXUtClPzuseSNdzTgd/2TLPLz2ziSiHsVJapmdpR05nw5P/SFbj7VwQniHdGosBKMtXu
	OZQIJf2GQPYPl7ZonRO5hl7U5fmVAoSsuCh9ob57LmLQijM4UaA==
X-Received: by 2002:a05:600c:4506:b0:428:1ce0:4dfd with SMTP id 5b1f17b1804b1-42c9f9e1980mr82477815e9.34.1725896476023;
        Mon, 09 Sep 2024 08:41:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEy7JGszyHmEw/v6aX4uxNl6gtNV3DASeqmjvLnSg7Hp/mo+kMdRp5XkP1tARqKcwFPHVWIlg==
X-Received: by 2002:a05:600c:4506:b0:428:1ce0:4dfd with SMTP id 5b1f17b1804b1-42c9f9e1980mr82477495e9.34.1725896475348;
        Mon, 09 Sep 2024 08:41:15 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-42caeb815e8sm81045245e9.31.2024.09.09.08.41.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2024 08:41:14 -0700 (PDT)
Message-ID: <4449bc94-7c5e-4095-8e91-7cd0544bb831@redhat.com>
Date: Mon, 9 Sep 2024 17:41:13 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 21/21] KVM: TDX: Handle vCPU dissociation
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
 yan.y.zhao@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-22-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 xsEhBFRCcBIBDqDGsz4K0zZun3jh+U6Z9wNGLKQ0kSFyjN38gMqU1SfP+TUNQepFHb/Gc0E2
 CxXPkIBTvYY+ZPkoTh5xF9oS1jqI8iRLzouzF8yXs3QjQIZ2SfuCxSVwlV65jotcjD2FTN04
 hVopm9llFijNZpVIOGUTqzM4U55sdsCcZUluWM6x4HSOdw5F5Utxfp1wOjD/v92Lrax0hjiX
 DResHSt48q+8FrZzY+AUbkUS+Jm34qjswdrgsC5uxeVcLkBgWLmov2kMaMROT0YmFY6A3m1S
 P/kXmHDXxhe23gKb3dgwxUTpENDBGcfEzrzilWueOeUWiOcWuFOed/C3SyijBx3Av/lbCsHU
 Vx6pMycNTdzU1BuAroB+Y3mNEuW56Yd44jlInzG2UOwt9XjjdKkJZ1g0P9dwptwLEgTEd3Fo
 UdhAQyRXGYO8oROiuh+RZ1lXp6AQ4ZjoyH8WLfTLf5g1EKCTc4C1sy1vQSdzIRu3rBIjAvnC
 tGZADei1IExLqB3uzXKzZ1BZ+Z8hnt2og9hb7H0y8diYfEk2w3R7wEr+Ehk5NQsT2MPI2QBd
 wEv1/Aj1DgUHZAHzG1QN9S8wNWQ6K9DqHZTBnI1hUlkp22zCSHK/6FwUCuYp1zcAEQEAAc0j
 UGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT7CwU0EEwECACMFAlRCcBICGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRB+FRAMzTZpsbceDp9IIN6BIA0Ol7MoB15E
 11kRz/ewzryFY54tQlMnd4xxfH8MTQ/mm9I482YoSwPMdcWFAKnUX6Yo30tbLiNB8hzaHeRj
 jx12K+ptqYbg+cevgOtbLAlL9kNgLLcsGqC2829jBCUTVeMSZDrzS97ole/YEez2qFpPnTV0
 VrRWClWVfYh+JfzpXmgyhbkuwUxNFk421s4Ajp3d8nPPFUGgBG5HOxzkAm7xb1cjAuJ+oi/K
 CHfkuN+fLZl/u3E/fw7vvOESApLU5o0icVXeakfSz0LsygEnekDbxPnE5af/9FEkXJD5EoYG
 SEahaEtgNrR4qsyxyAGYgZlS70vkSSYJ+iT2rrwEiDlo31MzRo6Ba2FfHBSJ7lcYdPT7bbk9
 AO3hlNMhNdUhoQv7M5HsnqZ6unvSHOKmReNaS9egAGdRN0/GPDWr9wroyJ65ZNQsHl9nXBqE
 AukZNr5oJO5vxrYiAuuTSd6UI/xFkjtkzltG3mw5ao2bBpk/V/YuePrJsnPFHG7NhizrxttB
 nTuOSCMo45pfHQ+XYd5K1+Cv/NzZFNWscm5htJ0HznY+oOsZvHTyGz3v91pn51dkRYN0otqr
 bQ4tlFFuVjArBZcapSIe6NV8C4cEiSTOwE0EVEJx7gEIAMeHcVzuv2bp9HlWDp6+RkZe+vtl
 KwAHplb/WH59j2wyG8V6i33+6MlSSJMOFnYUCCL77bucx9uImI5nX24PIlqT+zasVEEVGSRF
 m8dgkcJDB7Tps0IkNrUi4yof3B3shR+vMY3i3Ip0e41zKx0CvlAhMOo6otaHmcxr35sWq1Jk
 tLkbn3wG+fPQCVudJJECvVQ//UAthSSEklA50QtD2sBkmQ14ZryEyTHQ+E42K3j2IUmOLriF
 dNr9NvE1QGmGyIcbw2NIVEBOK/GWxkS5+dmxM2iD4Jdaf2nSn3jlHjEXoPwpMs0KZsgdU0pP
 JQzMUMwmB1wM8JxovFlPYrhNT9MAEQEAAcLBMwQYAQIACQUCVEJx7gIbDAAKCRB+FRAMzTZp
 sadRDqCctLmYICZu4GSnie4lKXl+HqlLanpVMOoFNnWs9oRP47MbE2wv8OaYh5pNR9VVgyhD
 OG0AU7oidG36OeUlrFDTfnPYYSF/mPCxHttosyt8O5kabxnIPv2URuAxDByz+iVbL+RjKaGM
 GDph56ZTswlx75nZVtIukqzLAQ5fa8OALSGum0cFi4ptZUOhDNz1onz61klD6z3MODi0sBZN
 Aj6guB2L/+2ZwElZEeRBERRd/uommlYuToAXfNRdUwrwl9gRMiA0WSyTb190zneRRDfpSK5d
 usXnM/O+kr3Dm+Ui+UioPf6wgbn3T0o6I5BhVhs4h4hWmIW7iNhPjX1iybXfmb1gAFfjtHfL
 xRUr64svXpyfJMScIQtBAm0ihWPltXkyITA92ngCmPdHa6M1hMh4RDX+Jf1fiWubzp1voAg0
 JBrdmNZSQDz0iKmSrx8xkoXYfA3bgtFN8WJH2xgFL28XnqY4M6dLhJwV3z08tPSRqYFm4NMP
 dRsn0/7oymhneL8RthIvjDDQ5ktUjMe8LtHr70OZE/TT88qvEdhiIVUogHdo4qBrk41+gGQh
 b906Dudw5YhTJFU3nC6bbF2nrLlB4C/XSiH76ZvqzV0Z/cAMBo5NF/w=
In-Reply-To: <20240904030751.117579-22-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/24 05:07, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Handle vCPUs dissociations by invoking SEAMCALL TDH.VP.FLUSH which flushes
> the address translation caches and cached TD VMCS of a TD vCPU in its
> associated pCPU.
> 
> In TDX, a vCPUs can only be associated with one pCPU at a time, which is
> done by invoking SEAMCALL TDH.VP.ENTER. For a successful association, the
> vCPU must be dissociated from its previous associated pCPU.
> 
> To facilitate vCPU dissociation, introduce a per-pCPU list
> associated_tdvcpus. Add a vCPU into this list when it's loaded into a new
> pCPU (i.e. when a vCPU is loaded for the first time or migrated to a new
> pCPU).
> 
> vCPU dissociations can happen under below conditions:
> - On the op hardware_disable is called.
>    This op is called when virtualization is disabled on a given pCPU, e.g.
>    when hot-unplug a pCPU or machine shutdown/suspend.
>    In this case, dissociate all vCPUs from the pCPU by iterating its
>    per-pCPU list associated_tdvcpus.
> 
> - On vCPU migration to a new pCPU.
>    Before adding a vCPU into associated_tdvcpus list of the new pCPU,
>    dissociation from its old pCPU is required, which is performed by issuing
>    an IPI and executing SEAMCALL TDH.VP.FLUSH on the old pCPU.
>    On a successful dissociation, the vCPU will be removed from the
>    associated_tdvcpus list of its previously associated pCPU.
> 
> - On tdx_mmu_release_hkid() is called.
>    TDX mandates that all vCPUs must be disassociated prior to the release of
>    an hkid. Therefore, dissociation of all vCPUs is a must before executing
>    the SEAMCALL TDH.MNG.VPFLUSHDONE and subsequently freeing the hkid.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>

I think this didn't apply correctly to kvm-coco-queue, but I'll wait for 
further instructions on next postings.

Paolo

> ---
> TDX MMU part 2 v1:
>   - Changed title to "KVM: TDX: Handle vCPU dissociation" .
>   - Updated commit log.
>   - Removed calling tdx_disassociate_vp_on_cpu() in tdx_vcpu_free() since
>     no new TD enter would be called for vCPU association after
>     tdx_mmu_release_hkid(), which is now called in vt_vm_destroy(), i.e.
>     after releasing vcpu fd and kvm_unload_vcpu_mmus(), and before
>     tdx_vcpu_free().
>   - TODO: include Isaku's fix
>     https://eclists.intel.com/sympa/arc/kvm-qemu-review/2024-07/msg00359.html
>   - Update for the wrapper functions for SEAMCALLs. (Sean)
>   - Removed unnecessary pr_err() in tdx_flush_vp_on_cpu().
>   - Use KVM_BUG_ON() in tdx_flush_vp_on_cpu() for consistency.
>   - Capitalize the first word of tile. (Binbin)
>   - Minor fixed in changelog. (Binbin, Reinette(internal))
>   - Fix some comments. (Binbin, Reinette(internal))
>   - Rename arg_ to _arg (Binbin)
>   - Updates from seamcall overhaul (Kai)
>   - Remove lockdep_assert_preemption_disabled() in tdx_hardware_setup()
>     since now hardware_enable() is not called via SMP func call anymore,
>     but (per-cpu) CPU hotplug thread
>   - Use KVM_BUG_ON() for SEAMCALLs in tdx_mmu_release_hkid() (Kai)
>   - Update based on upstream commit "KVM: x86: Fold kvm_arch_sched_in()
>     into kvm_arch_vcpu_load()"
>   - Eliminate TDX_FLUSHVP_NOT_DONE error check because vCPUs were all freed.
>     So the error won't happen. (Sean)
> ---
>   arch/x86/kvm/vmx/main.c    |  22 +++++-
>   arch/x86/kvm/vmx/tdx.c     | 151 +++++++++++++++++++++++++++++++++++--
>   arch/x86/kvm/vmx/tdx.h     |   2 +
>   arch/x86/kvm/vmx/x86_ops.h |   4 +
>   4 files changed, 169 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 8f5dbab9099f..8171c1412c3b 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -10,6 +10,14 @@
>   #include "tdx.h"
>   #include "tdx_arch.h"
>   
> +static void vt_hardware_disable(void)
> +{
> +	/* Note, TDX *and* VMX need to be disabled if TDX is enabled. */
> +	if (enable_tdx)
> +		tdx_hardware_disable();
> +	vmx_hardware_disable();
> +}
> +
>   static __init int vt_hardware_setup(void)
>   {
>   	int ret;
> @@ -113,6 +121,16 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	vmx_vcpu_reset(vcpu, init_event);
>   }
>   
> +static void vt_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		tdx_vcpu_load(vcpu, cpu);
> +		return;
> +	}
> +
> +	vmx_vcpu_load(vcpu, cpu);
> +}
> +
>   static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
>   {
>   	/*
> @@ -217,7 +235,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.hardware_unsetup = vmx_hardware_unsetup,
>   
>   	.hardware_enable = vmx_hardware_enable,
> -	.hardware_disable = vmx_hardware_disable,
> +	.hardware_disable = vt_hardware_disable,
>   	.emergency_disable = vmx_emergency_disable,
>   
>   	.has_emulated_msr = vmx_has_emulated_msr,
> @@ -234,7 +252,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.vcpu_reset = vt_vcpu_reset,
>   
>   	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
> -	.vcpu_load = vmx_vcpu_load,
> +	.vcpu_load = vt_vcpu_load,
>   	.vcpu_put = vmx_vcpu_put,
>   
>   	.update_exception_bitmap = vmx_update_exception_bitmap,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 3083a66bb895..554154d3dd58 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -57,6 +57,14 @@ static DEFINE_MUTEX(tdx_lock);
>   /* Maximum number of retries to attempt for SEAMCALLs. */
>   #define TDX_SEAMCALL_RETRIES	10000
>   
> +/*
> + * A per-CPU list of TD vCPUs associated with a given CPU.  Used when a CPU
> + * is brought down to invoke TDH_VP_FLUSH on the appropriate TD vCPUS.
> + * Protected by interrupt mask.  This list is manipulated in process context
> + * of vCPU and IPI callback.  See tdx_flush_vp_on_cpu().
> + */
> +static DEFINE_PER_CPU(struct list_head, associated_tdvcpus);
> +
>   static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
>   {
>   	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
> @@ -88,6 +96,22 @@ static inline bool is_td_finalized(struct kvm_tdx *kvm_tdx)
>   	return kvm_tdx->finalized;
>   }
>   
> +static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
> +{
> +	lockdep_assert_irqs_disabled();
> +
> +	list_del(&to_tdx(vcpu)->cpu_list);
> +
> +	/*
> +	 * Ensure tdx->cpu_list is updated before setting vcpu->cpu to -1,
> +	 * otherwise, a different CPU can see vcpu->cpu = -1 and add the vCPU
> +	 * to its list before it's deleted from this CPU's list.
> +	 */
> +	smp_wmb();
> +
> +	vcpu->cpu = -1;
> +}
> +
>   static void tdx_clear_page(unsigned long page_pa)
>   {
>   	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> @@ -168,6 +192,83 @@ static void tdx_reclaim_control_page(unsigned long ctrl_page_pa)
>   	free_page((unsigned long)__va(ctrl_page_pa));
>   }
>   
> +struct tdx_flush_vp_arg {
> +	struct kvm_vcpu *vcpu;
> +	u64 err;
> +};
> +
> +static void tdx_flush_vp(void *_arg)
> +{
> +	struct tdx_flush_vp_arg *arg = _arg;
> +	struct kvm_vcpu *vcpu = arg->vcpu;
> +	u64 err;
> +
> +	arg->err = 0;
> +	lockdep_assert_irqs_disabled();
> +
> +	/* Task migration can race with CPU offlining. */
> +	if (unlikely(vcpu->cpu != raw_smp_processor_id()))
> +		return;
> +
> +	/*
> +	 * No need to do TDH_VP_FLUSH if the vCPU hasn't been initialized.  The
> +	 * list tracking still needs to be updated so that it's correct if/when
> +	 * the vCPU does get initialized.
> +	 */
> +	if (is_td_vcpu_created(to_tdx(vcpu))) {
> +		/*
> +		 * No need to retry.  TDX Resources needed for TDH.VP.FLUSH are:
> +		 * TDVPR as exclusive, TDR as shared, and TDCS as shared.  This
> +		 * vp flush function is called when destructing vCPU/TD or vCPU
> +		 * migration.  No other thread uses TDVPR in those cases.
> +		 */
> +		err = tdh_vp_flush(to_tdx(vcpu));
> +		if (unlikely(err && err != TDX_VCPU_NOT_ASSOCIATED)) {
> +			/*
> +			 * This function is called in IPI context. Do not use
> +			 * printk to avoid console semaphore.
> +			 * The caller prints out the error message, instead.
> +			 */
> +			if (err)
> +				arg->err = err;
> +		}
> +	}
> +
> +	tdx_disassociate_vp(vcpu);
> +}
> +
> +static void tdx_flush_vp_on_cpu(struct kvm_vcpu *vcpu)
> +{
> +	struct tdx_flush_vp_arg arg = {
> +		.vcpu = vcpu,
> +	};
> +	int cpu = vcpu->cpu;
> +
> +	if (unlikely(cpu == -1))
> +		return;
> +
> +	smp_call_function_single(cpu, tdx_flush_vp, &arg, 1);
> +	if (KVM_BUG_ON(arg.err, vcpu->kvm))
> +		pr_tdx_error(TDH_VP_FLUSH, arg.err);
> +}
> +
> +void tdx_hardware_disable(void)
> +{
> +	int cpu = raw_smp_processor_id();
> +	struct list_head *tdvcpus = &per_cpu(associated_tdvcpus, cpu);
> +	struct tdx_flush_vp_arg arg;
> +	struct vcpu_tdx *tdx, *tmp;
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	/* Safe variant needed as tdx_disassociate_vp() deletes the entry. */
> +	list_for_each_entry_safe(tdx, tmp, tdvcpus, cpu_list) {
> +		arg.vcpu = &tdx->vcpu;
> +		tdx_flush_vp(&arg);
> +	}
> +	local_irq_restore(flags);
> +}
> +
>   static void smp_func_do_phymem_cache_wb(void *unused)
>   {
>   	u64 err = 0;
> @@ -204,22 +305,21 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
>   	bool packages_allocated, targets_allocated;
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>   	cpumask_var_t packages, targets;
> -	u64 err;
> +	struct kvm_vcpu *vcpu;
> +	unsigned long j;
>   	int i;
> +	u64 err;
>   
>   	if (!is_hkid_assigned(kvm_tdx))
>   		return;
>   
> -	/* KeyID has been allocated but guest is not yet configured */
> -	if (!is_td_created(kvm_tdx)) {
> -		tdx_hkid_free(kvm_tdx);
> -		return;
> -	}
> -
>   	packages_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
>   	targets_allocated = zalloc_cpumask_var(&targets, GFP_KERNEL);
>   	cpus_read_lock();
>   
> +	kvm_for_each_vcpu(j, vcpu, kvm)
> +		tdx_flush_vp_on_cpu(vcpu);
> +
>   	/*
>   	 * TDH.PHYMEM.CACHE.WB tries to acquire the TDX module global lock
>   	 * and can fail with TDX_OPERAND_BUSY when it fails to get the lock.
> @@ -233,6 +333,16 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
>   	 * After the above flushing vps, there should be no more vCPU
>   	 * associations, as all vCPU fds have been released at this stage.
>   	 */
> +	err = tdh_mng_vpflushdone(kvm_tdx);
> +	if (err == TDX_FLUSHVP_NOT_DONE)
> +		goto out;
> +	if (KVM_BUG_ON(err, kvm)) {
> +		pr_tdx_error(TDH_MNG_VPFLUSHDONE, err);
> +		pr_err("tdh_mng_vpflushdone() failed. HKID %d is leaked.\n",
> +		       kvm_tdx->hkid);
> +		goto out;
> +	}
> +
>   	for_each_online_cpu(i) {
>   		if (packages_allocated &&
>   		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
> @@ -258,6 +368,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
>   		tdx_hkid_free(kvm_tdx);
>   	}
>   
> +out:
>   	mutex_unlock(&tdx_lock);
>   	cpus_read_unlock();
>   	free_cpumask_var(targets);
> @@ -409,6 +520,26 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>   	return 0;
>   }
>   
> +void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
> +	if (vcpu->cpu == cpu)
> +		return;
> +
> +	tdx_flush_vp_on_cpu(vcpu);
> +
> +	local_irq_disable();
> +	/*
> +	 * Pairs with the smp_wmb() in tdx_disassociate_vp() to ensure
> +	 * vcpu->cpu is read before tdx->cpu_list.
> +	 */
> +	smp_rmb();
> +
> +	list_add(&tdx->cpu_list, &per_cpu(associated_tdvcpus, cpu));
> +	local_irq_enable();
> +}
> +
>   void tdx_vcpu_free(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_tdx *tdx = to_tdx(vcpu);
> @@ -1977,7 +2108,7 @@ static int __init __do_tdx_bringup(void)
>   static int __init __tdx_bringup(void)
>   {
>   	const struct tdx_sys_info_td_conf *td_conf;
> -	int r;
> +	int r, i;
>   
>   	if (!tdp_mmu_enabled || !enable_mmio_caching)
>   		return -EOPNOTSUPP;
> @@ -1987,6 +2118,10 @@ static int __init __tdx_bringup(void)
>   		return -EOPNOTSUPP;
>   	}
>   
> +	/* tdx_hardware_disable() uses associated_tdvcpus. */
> +	for_each_possible_cpu(i)
> +		INIT_LIST_HEAD(&per_cpu(associated_tdvcpus, i));
> +
>   	/*
>   	 * Enabling TDX requires enabling hardware virtualization first,
>   	 * as making SEAMCALLs requires CPU being in post-VMXON state.
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 25a4aaede2ba..4b6fc25feeb6 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -39,6 +39,8 @@ struct vcpu_tdx {
>   	unsigned long *tdcx_pa;
>   	bool td_vcpu_created;
>   
> +	struct list_head cpu_list;
> +
>   	bool initialized;
>   
>   	/*
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index d8a00ab4651c..f4aa0ec16980 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -119,6 +119,7 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
>   void vmx_setup_mce(struct kvm_vcpu *vcpu);
>   
>   #ifdef CONFIG_INTEL_TDX_HOST
> +void tdx_hardware_disable(void);
>   int tdx_vm_init(struct kvm *kvm);
>   void tdx_mmu_release_hkid(struct kvm *kvm);
>   void tdx_vm_free(struct kvm *kvm);
> @@ -128,6 +129,7 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>   int tdx_vcpu_create(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_free(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
> +void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>   u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
>   
>   int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
> @@ -145,6 +147,7 @@ void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
>   void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
>   int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
>   #else
> +static inline void tdx_hardware_disable(void) {}
>   static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
>   static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
>   static inline void tdx_vm_free(struct kvm *kvm) {}
> @@ -154,6 +157,7 @@ static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOP
>   static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
>   static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
>   static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
> +static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
>   static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
>   
>   static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }


