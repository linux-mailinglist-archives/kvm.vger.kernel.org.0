Return-Path: <kvm+bounces-2568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D4007FB2A6
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 08:25:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCFF5281E18
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 07:25:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C617513AC0;
	Tue, 28 Nov 2023 07:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MbjKLOhV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87ED510F0
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 23:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701156309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iANepy4LcEVc0PFmyCqY5MwriaBXl1P+qYoxDZZLGVY=;
	b=MbjKLOhVkYLVg0wwR35XY5OjrE9KRBLWxXcctp7Dl9kmzTG5xigeNQgbqlEniYgk1A8qr5
	ilw/UNmiXBd3RjsptG3U30SilxIlGtY5wtVppYeQYjzUv4wdP54x1N+Q9g9BisxPJS5tBB
	uqgP4ARNebnTfhRJOTECvjaCA/JIERM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-FvHyAim6NTGjD67Mb8Y6yA-1; Tue, 28 Nov 2023 02:25:06 -0500
X-MC-Unique: FvHyAim6NTGjD67Mb8Y6yA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-332ee6c2a1aso2558777f8f.1
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 23:25:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701156306; x=1701761106;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iANepy4LcEVc0PFmyCqY5MwriaBXl1P+qYoxDZZLGVY=;
        b=FzlDguXI1Oj2oXRVB/mrQt7BHUkBv1K9v+pEf0bEO7jrbVGalKVz3oiCpSRj+LdtWS
         RIc31Zq39bN53F59mfFxL56+yBaP1j6eynGnx9hOLd94l7LjL9LvTiNst/o9Z7z3u4NF
         1xFPXq1S4oSJ9/UL3eQLr19OnoET9G+D3EkX5U1p34Nvm/ehV9GLb9VqY6/ivkJe/CjM
         kCJ21cOl3SzRurpEoCX8v+MHtYMfrfrfZpVbMIhIKRiDM0rR6Do2UL/LXUbjnLNzpVS9
         vS5wsTariHooR1c8qC/4hGUON2goEC6cOk4NDvt9973FgCeppHd9m/NIHne2VMBUrLND
         wqTQ==
X-Gm-Message-State: AOJu0YziADGthBsJ+Td6DHWNX3h9ImMiI3LEmdKNJ1NIkzSXehBS7pWJ
	QKR2v86CBkTv0rS93Cui3tg+2ZtxtGkTzZatBb8tgESGL41ZQqPqeDfcRsEHEC935Z2oiEnsYRK
	VRcjrXpKCINdD
X-Received: by 2002:a5d:464f:0:b0:32d:bb4a:525c with SMTP id j15-20020a5d464f000000b0032dbb4a525cmr10101821wrs.14.1701156305909;
        Mon, 27 Nov 2023 23:25:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE0QQYA/ChFd9v/3X2VV1Y1Nh7hNFAIVNaVFuTH1R2mIuDpnEA9cp9CcfXyFdGFcLHjPhMM+Q==
X-Received: by 2002:a5d:464f:0:b0:32d:bb4a:525c with SMTP id j15-20020a5d464f000000b0032dbb4a525cmr10101791wrs.14.1701156305564;
        Mon, 27 Nov 2023 23:25:05 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id d21-20020adf9b95000000b003316ad360c1sm14269010wrc.24.2023.11.27.23.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 23:25:05 -0800 (PST)
Message-ID: <c9d68c7f42a5ea936179b676bdf0970062d4f3a7.camel@redhat.com>
Subject: Re: [RFC 09/33] KVM: x86: hyper-v: Introduce per-VTL vcpu helpers
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 anelkz@amazon.com,  graf@amazon.com, dwmw@amazon.co.uk, jgowans@amazon.com,
 corbert@lwn.net,  kys@microsoft.com, haiyangz@microsoft.com,
 decui@microsoft.com, x86@kernel.org,  linux-doc@vger.kernel.org
Date: Tue, 28 Nov 2023 09:25:03 +0200
In-Reply-To: <20231108111806.92604-10-nsaenz@amazon.com>
References: <20231108111806.92604-1-nsaenz@amazon.com>
	 <20231108111806.92604-10-nsaenz@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-11-08 at 11:17 +0000, Nicolas Saenz Julienne wrote:
> Introduce two helper functions. The first one queries a vCPU's VTL
> level, the second one, given a struct kvm_vcpu and VTL pair, returns the
> corresponding 'sibling' struct kvm_vcpu at the right VTL.
> 
> We keep track of each VTL's state by having a distinct struct kvm_vpcu
> for each level. VTL-vCPUs that belong to the same guest CPU share the
> same physical APIC id, but belong to different APIC groups where the
> apic group represents the vCPU's VTL.
> 
> Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> ---
>  arch/x86/kvm/hyperv.h | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index 2bfed69ba0db..5433107e7cc8 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -23,6 +23,7 @@
>  
>  #include <linux/kvm_host.h>
>  #include "x86.h"
> +#include "lapic.h"
>  
>  /* "Hv#1" signature */
>  #define HYPERV_CPUID_SIGNATURE_EAX 0x31237648
> @@ -83,6 +84,23 @@ static inline struct kvm_hv_syndbg *to_hv_syndbg(struct kvm_vcpu *vcpu)
>  	return &vcpu->kvm->arch.hyperv.hv_syndbg;
>  }
>  
> +static inline struct kvm_vcpu *kvm_hv_get_vtl_vcpu(struct kvm_vcpu *vcpu, int vtl)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	u32 target_id = kvm_apic_id(vcpu);
> +
> +	kvm_apic_id_set_group(kvm, vtl, &target_id);
> +	if (vcpu->vcpu_id == target_id)
> +		return vcpu;
> +
> +	return kvm_get_vcpu_by_id(kvm, target_id);
> +}

> +
> +static inline u8 kvm_hv_get_active_vtl(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_apic_group(vcpu);
> +}
> +
>  static inline u32 kvm_hv_get_vpindex(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);


Ideally I'll prefer the kernel to not know the VTL mapping at all but rather,
that each vCPU be assigned to an apic group / namespace and has its assigned VTL.

Then the kernel works in this way:

* Regular APIC IPI -> send it to the apic namespace to which the sender belongs or if we go with the idea of using
  multiple VMs, then this will work unmodified.

* Hardware interrupt -> send it to the vCPU/VM which userspace configured it to send via GSI mappings.

* HyperV IPI -> if same VTL as the vCPU assigned VTL -> deal with it the same as with regular IPI
             -> otherwise exit to the userspace.

* Page fault -> if related to violation of current VTL protection,
  exit to userspace, and the userspace can then queue the SynIC message, and wakeup the higher VTL.


Best regards,
	Maxim Levitsky




