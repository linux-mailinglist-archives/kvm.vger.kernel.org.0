Return-Path: <kvm+bounces-10314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D2CA86BACE
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 23:40:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 712611F27B2D
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 22:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A309D71ECC;
	Wed, 28 Feb 2024 22:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VRSMvcUR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548AE4CB30
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 22:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709160029; cv=none; b=EZlSJPeD1pkp/hZOQWw+TRcHgsjLtClZC060gB4NPMqNgNDRsSq3cXFHs/TOlRHHr7C77dW0R5wqxwYHhheVmx4S39yhOKtC3cd/Otkr30IB00SCwbIZgZVojOzKiOdPxgPY0e+VhnklcQ7SW2qe9YZWIqcY03c/unfx5QbQAmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709160029; c=relaxed/simple;
	bh=UI4N3O0p1OPV51s6ww8VE+iOxUsmCX0+oAuufGaCP2g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PmC4Fr8yTQ1A5gZ/RQ462Dp6j0ewALq+5lCGAMq1P2GCcjiCQoBsRe5VQWY/dFY5xJ4KFRKSO/f42IyDkMNDh9O4pL/szQSGjKhjpqMJIVyuMDPkrQEcy2UcgPA0ruaOpafZRFrwh6i0Rx4K9dHYa1eOBD36cIjufzMADYkQQ18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VRSMvcUR; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc693399655so552927276.1
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 14:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709160027; x=1709764827; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l+UTQgqjeTeuB4joWxs/sUGJ8L/gPUO2H1zeCMeGlUc=;
        b=VRSMvcUR1Z0nR83k7kzHQOcmnt39dGdDGXjA13POB7UJv2hWZ0yA/arivRbHMA9P6z
         KoyAjPSxTiL6qG4WHjqff/8lF1QnnBOGg75yYA8g16fpAW55Z5SRr6nKhV9fLVRftcvM
         OctCfnY2e94ZDFNg4tKOvyV1BGy/mgnD9oydYGiESvjNpj/1Qm41qqylFSIiCfB+qlSU
         EjVuWlQmbAaq0ZCsl77+efIaBzkkoK5ZX1JDxOQxZQ/JSrh9Z3Don3zIgHBjhlfln6ZH
         mmJb3n/Sx/LYAiWqzmaxL4uz+uZlFVpXYS/sTe0SVMx2unLTd9pa9ChMBLdXw3MBKbSt
         Obdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709160027; x=1709764827;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l+UTQgqjeTeuB4joWxs/sUGJ8L/gPUO2H1zeCMeGlUc=;
        b=oBSNN3arsU/fWHDLXye0hNYOZtiIeVqFRrZU5wLHqiuHQqlG5r+KGsrnJKifl9CGO1
         UeSesawIJo2Fzr4bH6gIhunEDm96sadtbYz9gmvKCvUhir6yPoA6rbEvoQCMlCVL5yo2
         8U8hsTakHeVmz/+Br/ZevqE94AjghpbDkjgmM2diPAJRnvyg+T+Z8tTy2IMUfXuuMzX3
         q/t74Kb416BIf9Y/IOHuM4ZUA9/p7nm0HwLrxVSW6RaIKHGV0V/1TRa4lEzWLag5qB/D
         mrGtRewPpn1g0f2V9fkela/N0krV0K4LJrdgaA5Pmh+CovawTeBllQAtqm/ZgEpNyQHe
         pHPw==
X-Gm-Message-State: AOJu0YwXHcAZ3q4/nzBINTdxpXoamkSH0d9sBtIYjR5HuS9jHeuzAQ/m
	T/hOIJtlAsyoan0Fr7zZoBaHdurS02ZOWQ2f8x21cK5Br1z7MYzBg19OFYAkBYB5NSJ0WSFCUnu
	tnA==
X-Google-Smtp-Source: AGHT+IFUPZtJnUkx4ZeqCTT90Ca+tWDsq48kFwktE+9CygIbxZw4LB/eimUqGjDzbeY7BpvlpduVfE/E17k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:abc2:0:b0:dc7:48ce:d17f with SMTP id
 v60-20020a25abc2000000b00dc748ced17fmr140494ybi.10.1709160027352; Wed, 28 Feb
 2024 14:40:27 -0800 (PST)
Date: Wed, 28 Feb 2024 14:40:20 -0800
In-Reply-To: <170900037528.3692126.18029642068469384283.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223004258.3104051-1-seanjc@google.com> <170900037528.3692126.18029642068469384283.b4-ty@google.com>
Message-ID: <Zd-2VK2kvMr_t1jx@google.com>
Subject: Re: [PATCH v9 00/11] KVM: selftests: Add SEV and SEV-ES smoke tests
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Carlos Bilbao <carlos.bilbao@amd.com>, 
	Peter Gonda <pgonda@google.com>, Itaru Kitayama <itaru.kitayama@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 26, 2024, Sean Christopherson wrote:
> On Thu, 22 Feb 2024 16:42:47 -0800, Sean Christopherson wrote:
> > Add basic SEV and SEV-ES smoke tests.  Unlike the intra-host migration tests,
> > this one actually runs a small chunk of code in the guest.
> > 
> > Unless anyone strongly objects to the quick and dirty approach I've taken for
> > SEV-ES, I'll get all of this queued for 6.9 soon-ish.
> > 
> > As for _why_ I added the quick-and-dirty SEV-ES testcase, I have a series to
> > cleanup __svm_sev_es_vcpu_run(), and found out that apparently I have a version
> > of OVMF that doesn't quite have to the right <something> for SEV-ES, and so I
> > could even get a "real" VM to reach KVM_RUN.  I assumed (correctly, yay!) that
> > hacking together a selftest would be faster than figuring out what firmware
> > magic I am missing.
> > 
> > [...]
> 
> Applied to kvm-x86 selftests, thanks!
> 
> [01/11] KVM: selftests: Extend VM creation's @shape to allow control of VM subtype
>         https://github.com/kvm-x86/linux/commit/309d1ad7b6ff
> [02/11] KVM: selftests: Make sparsebit structs const where appropriate
>         https://github.com/kvm-x86/linux/commit/6077c3ce4021
> [03/11] KVM: selftests: Add a macro to iterate over a sparsebit range
>         https://github.com/kvm-x86/linux/commit/8811565ff68e
> [04/11] KVM: selftests: Add support for allocating/managing protected guest memory
>         https://github.com/kvm-x86/linux/commit/29e749e8faff
> [05/11] KVM: selftests: Add support for protected vm_vaddr_* allocations
>         https://github.com/kvm-x86/linux/commit/1e3af7cf984a
> [06/11] KVM: selftests: Explicitly ucall pool from shared memory
>         https://github.com/kvm-x86/linux/commit/5ef7196273b6
> [07/11] KVM: selftests: Allow tagging protected memory in guest page tables
>         https://github.com/kvm-x86/linux/commit/a8446cd81de8
> [08/11] KVM: selftests: Add library for creating and interacting with SEV guests
>         https://github.com/kvm-x86/linux/commit/f3ff1e9b2f9c
> [09/11] KVM: selftests: Use the SEV library APIs in the intra-host migration test
>         https://github.com/kvm-x86/linux/commit/0837ddb51f9b
> [10/11] KVM: selftests: Add a basic SEV smoke test
>         https://github.com/kvm-x86/linux/commit/5101f1e27683
> [11/11] KVM: selftests: Add a basic SEV-ES smoke test
>         https://github.com/kvm-x86/linux/commit/f3750b0c7f6e

FYI, the hashes changed due to a force push to squash a bug in a different
series.

[1/11] KVM: selftests: Extend VM creation's @shape to allow control of VM subtype
      https://github.com/kvm-x86/linux/commit/126190379c57
[2/11] KVM: selftests: Make sparsebit structs const where appropriate
      https://github.com/kvm-x86/linux/commit/35f50c91c43e
[3/11] KVM: selftests: Add a macro to iterate over a sparsebit range
      https://github.com/kvm-x86/linux/commit/57e19f057758
[4/11] KVM: selftests: Add support for allocating/managing protected guest memory
      https://github.com/kvm-x86/linux/commit/cd8eb2913205
[5/11] KVM: selftests: Add support for protected vm_vaddr_* allocations
      https://github.com/kvm-x86/linux/commit/d210eebb51a2
[6/11] KVM: selftests: Explicitly ucall pool from shared memory
      https://github.com/kvm-x86/linux/commit/31e00dae72fd
[7/11] KVM: selftests: Allow tagging protected memory in guest page tables
      https://github.com/kvm-x86/linux/commit/bf47e87c65be
[8/11] KVM: selftests: Add library for creating and interacting with SEV guests
      https://github.com/kvm-x86/linux/commit/bdceeebcddb8
[9/11] KVM: selftests: Use the SEV library APIs in the intra-host migration test
      https://github.com/kvm-x86/linux/commit/8b174eb9d289
[10/11] KVM: selftests: Add a basic SEV smoke test
      https://github.com/kvm-x86/linux/commit/faa0d7027de3
[11/11] KVM: selftests: Add a basic SEV-ES smoke test
      https://github.com/kvm-x86/linux/commit/974ba6f0e595

