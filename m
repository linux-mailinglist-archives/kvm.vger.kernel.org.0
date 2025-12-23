Return-Path: <kvm+bounces-66629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A9419CDAD3B
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:17:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 32830302859E
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 23:16:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E244B30F55B;
	Tue, 23 Dec 2025 23:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G0TnDdIS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9122DA771
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 23:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766531787; cv=none; b=G/DqvnQKwU+/dhC0GfyksVlmBFgK5H9IXDWbYI/0FdhutVVWO0YKVmT720kmJK8EQb4CGMTxjczhlULsDW4WUgRahvHa6uGo5xhEQ/QCfFjBNKjVITdPobPqKzf0Fv/ugmLw91EmFfdp0A2TdWlsRs1uLhMrp8zPkdQm8muP6AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766531787; c=relaxed/simple;
	bh=wcfa8UCv1PFDrNKXW7+gpOHbHZSoTaU1Ak8Xrx/H8XQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dKwcXDHL+ercEZOdu+bvSmfZ4R85/nhW/17X7cPdLxDSA/hchTxMgykDRmBgsLxgdq1KtQLvg3urAWtNozQbuu5OyNu4HrTe9PBF2oFjpiaj3RgPrqJ63eViHmubYwX0ZaVuVeGJbw+cRHbuQ16jQ9pyO3ORydLXLaLnJt6m6nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G0TnDdIS; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c213419f5so5169627a91.2
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 15:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766531784; x=1767136584; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KAsurit4CoffeQfZgLilT9SXN5ZmTqi2oQd1rjMHsLU=;
        b=G0TnDdIS3hGXKtYExvTsDB8wBQ9o/JxGYs7vEUK5CBbKBwXutribtcq+gpQ/IOh2Cx
         9djxxnXOG8KXJBkBb6vq0yasHCYNp6Aie3aET+fNh7NLD8gM5+l0A/qxczhUk8MRwCb5
         QI8zkaiwj3eNKao/p7ixXiiXXVMvGnJGMVJlWDrQwdxPTUaeLILpdJbZKzDPZfOqrBHN
         ICXsbOUUbbK0Y1CFlg2jzuH+1rrwKip2gQahYvGCJJooBHrhRFlkHgakx2q8wTZZ98KX
         23yY1KjEEtUY0g8OObbZaMSFWYWYHs5uaQ8j35tLnMHrucLRbxrpBI4qnN8mZWmCNJnV
         hQdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766531784; x=1767136584;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KAsurit4CoffeQfZgLilT9SXN5ZmTqi2oQd1rjMHsLU=;
        b=dVfr8otGYQ5n+sDPVTVvJAqbTrJ0n87TCaXuRAVaSfkWEpVmio9zKweSizq0JCwZHX
         Q2/BpZvTUPgFnBR/K/sGM2ZoK3aKtMBd04Ui8z292BztKbahxdY1czsXDpJJB457lyx0
         0+cEfQWkA8d20kh0ZRqPGfduGcQu1yJyhQ70BQuJI9i/IxIDCuyuZjYYS+o5Lr93Q6/W
         WE/5qwwlSC6az0hHPExzxxbpGZ8wCZCWX0qLlLbxeb6VSr38CRgzMaM7TJq0PWGGltml
         Ho+K+NriLS5/Bx3UdvY0JwdM+ujdt34GMyCTRQ7yvGm0P8nDCiuQwvnxuCTUSYIMJOPf
         fp1A==
X-Forwarded-Encrypted: i=1; AJvYcCUK6QC5w1InXJIORCOZ6I9dB958qWrUKvW1dV9KXs8BdvdcslOjP5OB7UlrCEcf1k1TVQM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1afe9cnv690bjm0Dd7S1DFOAFs/xPO7XOy2zj2jR8LbACoacJ
	Yk5BH0lnlPYANxA146DHigcKEtqt2ILRlEIevVhOCq7ucn6nKzHKAA/QzMEY1KrB5E8bww+My0S
	nYX+r/w==
X-Google-Smtp-Source: AGHT+IEGNORU4c06vu8tvcskbqaqO03iRG+VRpk9JFm8QEVM69jU830aaoUkr6cc7Thzn2v7b01iAuatSnE=
X-Received: from pjgg4.prod.google.com ([2002:a17:90b:57c4:b0:34c:4048:b62b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ad1:b0:34e:5aa2:cf68
 with SMTP id 98e67ed59e1d1-34e921e7148mr13890093a91.30.1766531784584; Tue, 23
 Dec 2025 15:16:24 -0800 (PST)
Date: Tue, 23 Dec 2025 15:16:23 -0800
In-Reply-To: <20251127013440.3324671-9-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev> <20251127013440.3324671-9-yosry.ahmed@linux.dev>
Message-ID: <aUsix_3KDEEFt0gC@google.com>
Subject: Re: [PATCH v3 08/16] KVM: selftests: Use a nested MMU to share nested
 EPTs between vCPUs
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 27, 2025, Yosry Ahmed wrote:
> diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
> index a3e2eae981da..5d799ec5f7c6 100644
> --- a/tools/testing/selftests/kvm/lib/x86/vmx.c
> +++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
> @@ -56,6 +56,16 @@ int vcpu_enable_evmcs(struct kvm_vcpu *vcpu)
>  	return evmcs_ver;
>  }
>  
> +void vm_enable_ept(struct kvm_vm *vm)
> +{
> +	TEST_ASSERT(kvm_cpu_has_ept(), "KVM doesn't support nested EPT");
> +	if (vm->arch.nested.mmu)

Make this an assert, attempting to enable EPT multiple times for a single VM is
a test bug.  That way we don't have to worry about silly situations in the future,
e.g. like trying to change from 4-level to 5-level after the MMU has already been
created.

Ditto for the NPT code.

> +		return;
> +
> +	/* EPTP_PWL_4 is always used */
> +	vm->arch.nested.mmu = mmu_create(vm, 4, NULL);

