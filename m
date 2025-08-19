Return-Path: <kvm+bounces-55015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3389EB2CA62
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 19:18:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BCB217DE7E
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 17:18:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DA1D2FE057;
	Tue, 19 Aug 2025 17:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DNhtBOsy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FEB2F0680
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 17:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755623910; cv=none; b=Oeqkrp2hbzCbel8FXM3G2Y/hnVBEG+GuXlcGOif7Wuu4Xm7g0ed850gSpP2pv58I3kiv2h0OfpepItWt4MdgqX65lFLFc/+/jMqbSKKuzGLOmSXGPVZDbGZ7C3s2osLXT4fTQbBUMFkxS698wsDUC5JwCct4z3mj9JYX0mm1+AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755623910; c=relaxed/simple;
	bh=PloZW4qYMq4Bc2fEvPDWXxdFo829T4fxjI9JYrCuCVE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DAollQNhbaVG4L48ymWJ67HFtaQ6juGBgsgxNVFKBNbpC58Z7HS1lNCFuUA5g8ri9BSPYF3LKlW0rEs45hvbLmES1a/d/UHBMzPyXNvA6wz8kYoJEPQkTJa39LEdtBr8EoV0Q4LXycCan1qD7xIHYOcwNqTYG0VfXdD+GJPrLzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DNhtBOsy; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32326e017efso5675475a91.3
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 10:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755623908; x=1756228708; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sdunIMtBL5Zf9ScbNPV0INPIlGpoPAUen4jDfBOFl4I=;
        b=DNhtBOsyJrD31FfRUr/wvPIqGLdF4LIJAEznTfltLv05Sb+OVrxQf66UV+zuFpoGWj
         nrbGJjc2IgNWpTdf1k2vAFa339EChYwUqUSy+Hie5FLWjbVuHGPA/v06H4Ru3bxyWHoO
         giS0Bk+MeQK+yuOGmZukfd51kyMsGbSfHrndcx8UVH96O+uRvCERy1H5ygKjFbB4JaxQ
         q7SNc3E+KVd5Goz0hoM0FQda+DzEbrkQ7i1DjqWujx7qH8k30AlRKC7/+6YEvnRiHqAe
         kAzJNjmyZj2tpmg6iAROtN/DZhQRyucGg0js9Buq5gWMCwZUuL76PXRIhRZUTNAYlSJ/
         JyIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755623908; x=1756228708;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sdunIMtBL5Zf9ScbNPV0INPIlGpoPAUen4jDfBOFl4I=;
        b=nQRwr5EV88j/3Seu7WEV6QrYVtL3KIZ6uthvG08uRlsVTG1XMO8g1FVbM9pZ7HOX4W
         Fog3kmyABQSsI5wC0YM071qzJ+mmx+dfeErTYjpwpZ15H4563JUex1WQ/CohdEQjBdC9
         NBRyTVyOMeXQGWPVM5SRFp2JZu79GnZGyDTnP4KJQBX9LZGfBH09Ms/0poEdxbN+3+2H
         OfKpcVCSYMJHFb6WUGpXtxedZnyKHJFRGvkAMeUNFeirmM3nbTdU/aVuit72Suqm5rRE
         QkTzSVw+ppA1QWcAf3WqCPvjfdABdKmL3Z0lbOr0Q882Cp8B3BitP68wgAmxpwoYSFIT
         y8YA==
X-Gm-Message-State: AOJu0Yx2RoFr9YOqA64QBvVPABRzMVDIyim11C0vbcRsRzhN/Xsrcnkc
	PuxsLUghFBEOJ1BPzWrvxnMlqY3ZiU0LXF6UR6JQbDg7B+Q95fZhU06v7BPgo9/YUTeaJTTnPNG
	YReSkSg==
X-Google-Smtp-Source: AGHT+IExDY4f3mT+46JVokZkfLCwwzGNF9zAqmzjPJffqHmG05iwkQN4+z0jwppQ4klR4osxAofXnQTrOts=
X-Received: from pjwx11.prod.google.com ([2002:a17:90a:c2cb:b0:31e:998f:7b79])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5585:b0:315:fefe:bebf
 with SMTP id 98e67ed59e1d1-324e12e2848mr34966a91.13.1755623908148; Tue, 19
 Aug 2025 10:18:28 -0700 (PDT)
Date: Tue, 19 Aug 2025 10:18:26 -0700
In-Reply-To: <20250812025606.74625-23-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250812025606.74625-1-chao.gao@intel.com> <20250812025606.74625-23-chao.gao@intel.com>
Message-ID: <aKSx4gisPrcHdq1h@google.com>
Subject: Re: [PATCH v12 22/24] KVM: nVMX: Enable CET support for nested guest
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mlevitsk@redhat.com, 
	rick.p.edgecombe@intel.com, weijiang.yang@intel.com, xin@zytor.com, 
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 11, 2025, Chao Gao wrote:
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 618cc6c6425c..f20f205c6560 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -721,6 +721,27 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>  	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>  					 MSR_IA32_MPERF, MSR_TYPE_R);
>  
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_IA32_U_CET, MSR_TYPE_RW);
> +
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_IA32_S_CET, MSR_TYPE_RW);
> +
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_IA32_PL0_SSP, MSR_TYPE_RW);
> +
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_IA32_PL1_SSP, MSR_TYPE_RW);
> +
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_IA32_PL2_SSP, MSR_TYPE_RW);
> +
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_IA32_PL3_SSP, MSR_TYPE_RW);
> +
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW);

As with the "regular" support, I don't think MSR_IA32_INT_SSP_TAB needs to be
passed through (though it's entirely possible I'm missing/forgetting something).

> +
>  	kvm_vcpu_unmap(vcpu, &map);
>  
>  	vmx->nested.force_msr_bitmap_recalc = false;
> @@ -2521,6 +2542,32 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
>  	}
>  }
>  
> +static inline

Do not use "inline" for functions that are visible only to the local compilation
unit.  "inline" is just a hint, and modern compilers are smart enough to inline
functions when appropriate without a hint.

A longer explanation/rant here: https://lore.kernel.org/all/ZAdfX+S323JVWNZC@google.com


> void cet_vmcs_fields_get(struct kvm_vcpu *vcpu, u64 *s_cet,

I don't love the names, as it's not super clear what they are doing.  How about:

  vmcs_{read,write}_cet_state()

I like that vmcs_{read,write} matches the vmcs_{read,write}{l,16,32,64} helpers
(makes it clear they are reading/writing VMCS fields), and the cet_state connects
the dots to VM_EXIT_LOAD_CET_STATE (helps clarify which CET fields are accessed).

