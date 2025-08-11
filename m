Return-Path: <kvm+bounces-54434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C6352B213E1
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 20:12:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E46C77A4DF8
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 18:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CA7B2D6E7B;
	Mon, 11 Aug 2025 18:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nDVOoPJp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23599202C3A
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 18:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754935949; cv=none; b=EUUdyf/ZkOlzemkpBfcI+S4KD+/a++BiyvIIaBhpYYev3vHTYVfqdodFibo2Jx/SleWXDdIxLkKgZmaaDnaxcf4fi+iHDyT3R9N+iHWMhAXa9jVQyuTF8dFHdtkZJ2cD4sVpwSvB7xWjT21T2eib38ZuOQz2avtxXKJ3tUxDLY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754935949; c=relaxed/simple;
	bh=FzOg6Gm3MW4IPs7jA4/xJvicN/CaJUg67oRbvLuamlI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K86CbkdHi2yiwKl0kP3++rgFQ2KVL0VpYTIAuShkL11Gz/Ilpm+Qb46HiptoHNFoLhraDmmLdsxpTT6wqjCX3MMCCCNlgWInJS0TKx9eG5HYpJJjHQqWNKcMfThkhXBxow6d73x9zUmIQaxh0Gh/kveRtW+MCqRS0aPydAoPKu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nDVOoPJp; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b4253124e77so3873563a12.2
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 11:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754935947; x=1755540747; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SRc0fYLfNBxDY1KDX/QBsS5DOeiuAL5ez/Hfr3jBonQ=;
        b=nDVOoPJpe/QH/jOx2tlT6ijXzO/0R8FrO0oA6gVA26cO9xPnonWVaYHjn7kjmr7Zjs
         er6CDsWWX5iCpl8Lnhr4tlnKO8fT0qkN+/0xbWHA0zy84aqSHgVmXQMAH8MdmPdtTnNj
         00k1Uh9jaMJiScOlUbjQosYc9Lmv2zQllUzmJ2ulF97DNVaYLeg1SGPf9KKaeDQ8mqZj
         XwDQmf3cs7YBT8RI9Cmry60Nuv+xoDzkQuKXV76Gkxl7LYktopvHflEovfEIDAWrjHy+
         HP9dfmrVsaqr+jL7YN0CXwqenYUv93zWXmU4l888oQmT9fldnO0XpZqCvrU9+5IzOIQU
         hHAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754935947; x=1755540747;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SRc0fYLfNBxDY1KDX/QBsS5DOeiuAL5ez/Hfr3jBonQ=;
        b=wSYuc40FhGGlod0+qZXK2wXZwDG4bXVm4pfI5Y0RHEjjR2bi3yxUXqSolWJwdiOmII
         VGyHPXiaP5M9IlFpa6OIWxeX9s6NUbCA0NBPNOnOUMVFlg23JatFW0tL7ApXyU7l6whK
         2XlJU2SBgJ96lXndE1RMDtavRAS3BaufHM4xHuK2jVpnwFNB+fPZjcaBGIz/nGrgRSQ/
         MePABhWZSpdc6+iFBDA0BskIa2D0cK0hhi7d7jektmTchN4Um0qmG+6T1Y0mnyrW9A7g
         JjNLOFtFPbGDMs2a3G0xna7J2/BvRxhLU4HpjbH8fjHkssRje0D5zJFEue/st1EmOcvy
         zRfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXu5iONLLVsc2rRsEVNtMJZkWwgPBQksZ1exHWQMCJBpQwOgL+6vQmX7JjpzR33QMd0tqg=@vger.kernel.org
X-Gm-Message-State: AOJu0YygD56ZZ9mRNmvTDaC5cJ1GGmcJblx6k2nlVXdVRd9YyIgl/l4o
	EccyEAUtV0TGJpw5s2AIBq5ABvGD6zXYhfw9iGvwf45GcFlYkzBirmXwTqi1hzKctw4ExEiUCds
	keJRSWA==
X-Google-Smtp-Source: AGHT+IHOP4ne+RCo8LBy9R/wPC7yjLE7VfoibrRFWgnNuPAHpXQrKLTCbq7f2PknDxd5bB2lpT5baWgx0WM=
X-Received: from pjbpx16.prod.google.com ([2002:a17:90b:2710:b0:2e0:915d:d594])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b4d:b0:31f:150:e02b
 with SMTP id 98e67ed59e1d1-321839e75a3mr20356778a91.4.1754935947409; Mon, 11
 Aug 2025 11:12:27 -0700 (PDT)
Date: Mon, 11 Aug 2025 11:12:25 -0700
In-Reply-To: <20250807201628.1185915-4-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250807201628.1185915-1-sagis@google.com> <20250807201628.1185915-4-sagis@google.com>
Message-ID: <aJoyiVlz1cxgW7Xm@google.com>
Subject: Re: [PATCH v8 03/30] KVM: selftests: Store initial stack address in
 struct kvm_vcpu
From: Sean Christopherson <seanjc@google.com>
To: Sagi Shahar <sagis@google.com>
Cc: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Ackerley Tng <ackerleytng@google.com>, 
	Ryan Afranji <afranji@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Erdem Aktas <erdemaktas@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 07, 2025, Sagi Shahar wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> TDX guests' registers cannot be initialized directly using
> vcpu_regs_set(), hence the stack pointer needs to be initialized by
> the guest itself, running boot code beginning at the reset vector.
> 
> Store the stack address as part of struct kvm_vcpu so that it can
> be accessible later to be passed to the boot code for rsp
> initialization.

NAK.  This bleeds x86 details into common code, and is again a convoluted way of
passing information into TDX specific code.

> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sagi Shahar <sagis@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h  | 1 +
>  tools/testing/selftests/kvm/lib/x86/processor.c | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 9994861d2acb..5c4ca25803ac 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -58,6 +58,7 @@ struct kvm_vcpu {
>  	int fd;
>  	struct kvm_vm *vm;
>  	struct kvm_run *run;
> +	vm_vaddr_t initial_stack_addr;
>  #ifdef __x86_64__
>  	struct kvm_cpuid2 *cpuid;
>  #endif
> diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
> index 002303e2a572..da6e9315ebe2 100644
> --- a/tools/testing/selftests/kvm/lib/x86/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86/processor.c
> @@ -694,6 +694,8 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
>  	vcpu_init_sregs(vm, vcpu);
>  	vcpu_init_xcrs(vm, vcpu);
>  
> +	vcpu->initial_stack_addr = stack_vaddr;
> +
>  	/* Setup guest general purpose registers */
>  	vcpu_regs_get(vcpu, &regs);
>  	regs.rflags = regs.rflags | 0x2;
> -- 
> 2.51.0.rc0.155.g4a0f42376b-goog
> 

