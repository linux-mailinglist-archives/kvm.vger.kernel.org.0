Return-Path: <kvm+bounces-54437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AF97B21478
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 20:34:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C9AE2A2521
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 18:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B11B22E284D;
	Mon, 11 Aug 2025 18:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y72PIfkk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768462D47FA
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 18:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754937286; cv=none; b=YHpJQx2qM2lpeM/MGph+KtikcxMZFe/To5/jiHYCGAQizCvIxEMpUfM2cTeYmxgRiFHbr2auU/P9wiy4c8l4otOTSUENyJghHjeV/d84MW0sgp9b+wdYEEpowo+B+fFF3p3ehyKlj2OOhlYCmv6z6RUwEofSog7NtkZ92N7tU78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754937286; c=relaxed/simple;
	bh=89BVW4CxbY/SENQfPJ7/A4sDeevyKuGh8PKlN3OlB1A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DXNgZEeMa2nFIVNtGkIuEK/T8FHCTA8rUpMgQevPM1sKioqqJSrW8zHJUaULjLKcpxXb5o5piVXrBI3iVBW8yjjBccSb26mIbQRon53a8qY17OyscmXuz7v/pHCxcW6FbSarXM11xgeDChiWZNufxpDZw+bP37+/yBVxysZOHzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y72PIfkk; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31f65d519d3so9076936a91.2
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 11:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754937285; x=1755542085; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ToF3yXnhihdF6GyDCHn8N8VwTIczvJFrYRhEkfB4nXQ=;
        b=Y72PIfkk3EimVpwQfvhIThXlS43AJ0SN1ymQkNT9xV81q33O+kWVJ9EJ8HeVpX/vAI
         azaPg6QK9LvUC3kp7qY/ybiDgV3IBmSFEMG1jbxoXyNwSDE6XuzteXFMzTOl/tiYM6jb
         CfaijOYWzUsFhaygu9qMt2+uVmFH+kxfNnVdB3DqxoItSXqQY6JkqATvGGfXUEHg6jDw
         SC4ql5sao5YA25tOzJ1Xgv7IKL0ybe42mGmR2RspkCgQMsWphD93thgquevowDM9E3o5
         86KFluVoTCx0THdNzj5vnm+oRwFAsh3beXjMt/EcSlJyNf7n/Gf4EOlb283LT71AvEWw
         4vlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754937285; x=1755542085;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ToF3yXnhihdF6GyDCHn8N8VwTIczvJFrYRhEkfB4nXQ=;
        b=thVAY+F1h4d/GuVXitWzwnGHdnRBvsGozEUuBrc/x4l/p36aJGFHbWD1G0vEvZ2lrI
         GTE9Jw4OdScc0UUr/2NOPsXbsAURMILcVntrR8eJ4nHnOK5kCZEV2jii+7aP/bGrnKzH
         R4/K+oVL9YffTuhCeaX7A1iAlK7niPlTKIywtWuoT+QM+4p3v9faOv+fZLk9hH/0784h
         8VDzrzF9k+QDCKwHfqgCjeCZdMrdUAoZZNUIFO0LrhWuSxtI+iie/WfroExL33N0FRia
         3M5+SKn+nMwVcaqtr6aF9FGXlCJ1VtT0TPC2oHBP88g3xgeYukqJLQaNLJPAMicB+Er2
         8ciQ==
X-Forwarded-Encrypted: i=1; AJvYcCUq7/CmvRUNArjUcD/idK4yC/t2qQAsU2SAbRvjeE1W4ytXloTUtQZqKQ7fyFmlKIyEaBQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyienT5WVSuiomMbImtX9vXHSvYxH3B+Jp0APOHf30dcu8UP1XG
	BnzD8COzC3/s1E3PvK1UXgKTZCk63vPoayAl4Pt8Jw6zS+PqYn8Pmci5eT3+J4Hw2GSGgn5cm+w
	W52Kd2w==
X-Google-Smtp-Source: AGHT+IEzxU6pFuNb3BtPBhG6Z5TrAr6QqxE/xuu3duY0IG5Y4k+nffZFa2m4lFhIOOskf01RQZHaHzFdLb4=
X-Received: from pjbsz13.prod.google.com ([2002:a17:90b:2d4d:b0:31c:38fb:2958])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:584f:b0:31f:104f:e4b1
 with SMTP id 98e67ed59e1d1-321c09f244emr865365a91.7.1754937284804; Mon, 11
 Aug 2025 11:34:44 -0700 (PDT)
Date: Mon, 11 Aug 2025 11:34:43 -0700
In-Reply-To: <20250807201628.1185915-6-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250807201628.1185915-1-sagis@google.com> <20250807201628.1185915-6-sagis@google.com>
Message-ID: <aJo3ww82Ln-PxgGL@google.com>
Subject: Re: [PATCH v8 05/30] KVM: selftests: Update kvm_init_vm_address_properties()
 for TDX
From: Sean Christopherson <seanjc@google.com>
To: Sagi Shahar <sagis@google.com>
Cc: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Ackerley Tng <ackerleytng@google.com>, 
	Ryan Afranji <afranji@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Erdem Aktas <erdemaktas@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 07, 2025, Sagi Shahar wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Let kvm_init_vm_address_properties() initialize vm->arch.{s_bit, tag_mask}
> similar to SEV.
> 
> Set shared bit position based on guest maximum physical address width
> instead of maximum physical address width, because that is what KVM
> uses,

"because KVM does it" is not an acceptable explanation.

> refer to setup_tdparams_eptp_controls(), and because maximum physical
> address width can be different.
> 
> In the case of SRF, guest maximum physical address width is 48 because SRF
> does not support 5-level EPT, even though the maximum physical address
> width is 52.

Referencing a specific Intel microarchitecture is not proper justification for
why something is supported/legal/correct.  Using its three-letter acronym is
just icing on the cake.

> Co-developed-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Sagi Shahar <sagis@google.com>
> ---
>  tools/testing/selftests/kvm/lib/x86/processor.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
> index d082d429e127..5718b5911b0a 100644
> --- a/tools/testing/selftests/kvm/lib/x86/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86/processor.c
> @@ -1166,10 +1166,19 @@ void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
>  
>  void kvm_init_vm_address_properties(struct kvm_vm *vm)
>  {
> +	uint32_t gpa_bits = kvm_cpu_property(X86_PROPERTY_GUEST_MAX_PHY_ADDR);
> +
>  	if (is_sev_vm(vm)) {
>  		vm->arch.sev_fd = open_sev_dev_path_or_exit();
>  		vm->arch.c_bit = BIT_ULL(this_cpu_property(X86_PROPERTY_SEV_C_BIT));
>  		vm->gpa_tag_mask = vm->arch.c_bit;
> +	} else if (vm->type == KVM_X86_TDX_VM) {

Please add an is_tdx_vm() helper.

> +		TEST_ASSERT(gpa_bits == 48 || gpa_bits == 52,
> +			    "TDX: bad X86_PROPERTY_GUEST_MAX_PHY_ADDR value: %u", gpa_bits);
> +		vm->arch.sev_fd = -1;
> +		vm->arch.s_bit = 1ULL << (gpa_bits - 1);
> +		vm->arch.c_bit = 0;

The VM is zero-initialized, no need to set c_bit.

> +		vm->gpa_tag_mask = vm->arch.s_bit;
>  	} else {
>  		vm->arch.sev_fd = -1;

I think it makes sense to set sev_fd to -1 by default instead of duplicating the
non-SEV logic into all non-SEV paths.  SEV VMs will write it twice, but that's a
non-issue.  E.g.

	vm->arch.sev_fd = -1;

	if (is_sev_vm(vm)) {
		vm->arch.sev_fd = open_sev_dev_path_or_exit();
		vm->arch.c_bit = BIT_ULL(this_cpu_property(X86_PROPERTY_SEV_C_BIT));
		vm->gpa_tag_mask = vm->arch.c_bit;
	} else if (is_tdx_vm(vm)) {
		TEST_ASSERT(gpa_bits == 48 || gpa_bits == 52,
			    "TDX: bad X86_PROPERTY_GUEST_MAX_PHY_ADDR value: %u", gpa_bits);
		vm->arch.s_bit = 1ULL << (gpa_bits - 1);
		vm->gpa_tag_mask = vm->arch.s_bit;
	}


