Return-Path: <kvm+bounces-16195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1703B8B6445
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 23:05:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A5101C20618
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 21:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4556C1836C4;
	Mon, 29 Apr 2024 21:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tj+dTFAg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D914179967
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 21:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714424540; cv=none; b=A17Qmw0Sixj1cD2E74Ut3EM4UNMe/gfLcg5ZSlc49WP3CnMsw+118898qgXemOOXkD+TvvWhe2hjLmL9ZcwYbin3JaKvIGx/fjZ+bYTSWH1NdjpOA0YrrftZmXs6qEvsf92yYeBW6qSxFlS3uURB9Ruov3tCvV3XNgO1Ii3URyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714424540; c=relaxed/simple;
	bh=AbBtsHCGar1oC19onEj9oM1dARfaM70Gs2h5fz5fNyM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I3TlpnyK9lgdeQ1Vk2shY/9bJgRpaebcFgJnVcT6ClCViOy70NhmdtnzMsFTrnbRJpXAEgHaAVm8kIMLSzi1bTC6yeLH0cH1a/01e3qjQsvwLHbZl/LL/BSzK4LqqK8OGFzvcfJgmF773pnMuLo/itoTSVIFycqbDkgAWLoOTUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tj+dTFAg; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso4241332a12.0
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 14:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714424538; x=1715029338; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2uDJDJTdqMi/qWILeG2gkRWiCPiQQS9JXQ1eVQSPrTY=;
        b=Tj+dTFAgatHBcqE4Z0xyBuObojJ5hArG26uziIXdEl9bZhzs1ATIxaz6y/xo2ybZv2
         6fXNUqegES9Qd0hiHyIhmLSugE1f7td1NZgYJtP75tl9xtirq3en4PqnSOBFDJX2fbmC
         ZelhfYuy4Y3rzt4p7dPZbRmhax+aEfZw0Yra+tIxXl2vAcwtfqfDEcYG4fH0yqBPVoZr
         Wp/PK2YAzWny6E+hU6eY3qTlyQgpPawqXoF2xZeCgy4cAVrem6UMvodDhMzmFL5YZFpP
         kEFa4gxe1hBe/ONypvv3mxfMOD3effQqrWj6VuStQ5yrCNox4UmZoRsy+O3jjNbPTwKa
         bcmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714424538; x=1715029338;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2uDJDJTdqMi/qWILeG2gkRWiCPiQQS9JXQ1eVQSPrTY=;
        b=tbemz19E93XGUVwAeaG4OPs/9XeysdkaFhmGqiuz0TQBMG2JV3DkFbx0pybkjfjSuu
         edvd1HfhWBCX6SAd2/1nn9OcbN9j4hSQOYFRsGtgdR6D+XOd3qz9cQH6TRgjKx8k9x1Y
         xd314rSYZTyVy7ahuhnEcZzoKRLCAYis/xWj8pHLvN/YnbRzEmcufmDkZ7y/hURnnhU0
         QKgoV844CNwi4x9Vq8yzpygbHtFgZ9/phl4d3gA1ZH9qBbD9pI0fhJPweUcjy1I8E709
         lxkTv5FPftNaB5c0zEZ0WGxfwk3XdlJWelHTcBh9OlN6YAAVwPQrGryWQXCwOQNjTvfi
         +3NA==
X-Forwarded-Encrypted: i=1; AJvYcCULRx9Y/UJPftbVhhaVId6JRRimav3rgNydsdKlBFVPt9PUbw3THRoiQjRd2UoDk5y0KSFa9//4D/+6a+ofTzLbfM6c
X-Gm-Message-State: AOJu0Yycv040dytlteL8s0X1XBTO5Tjp+lVhVI++vMvPbj6ZpDiVHyG0
	6j57AXOr1lI7hgPKFApmVQIUxWeCszKN3zt5ky+wdi0wXgH3Y3iEArCkaDmMuxsJQmqwmfJDxfb
	KhQ==
X-Google-Smtp-Source: AGHT+IHjxlO7BGwfLpJTaM2K2yepr+Df3RVVAMz1TW/z+nRfFSnOvH5P7k7vUxx/UM3fHPC+zECxCajQyZo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3d84:0:b0:5f4:246c:1406 with SMTP id
 k126-20020a633d84000000b005f4246c1406mr2059pga.3.1714424538307; Mon, 29 Apr
 2024 14:02:18 -0700 (PDT)
Date: Mon, 29 Apr 2024 13:45:21 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <171442343194.161918.3828509492626949358.b4-ty@google.com>
Subject: Re: [PATCH 00/18] KVM: selftests: Clean up x86's DT initialization
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 14 Mar 2024 16:26:19 -0700, Sean Christopherson wrote:
> The vast majority of this series is x86 specific, and aims to clean up the
> core library's handling of descriptor tables and segments.  Currently, the
> library (a) waits until vCPUs are created to allocate per-VM assets, and
> (b) forces tests to opt-in to allocate the structures needed to handler
> exceptions, which has result in some rather odd tests, and makes it
> unnecessarily difficult to debug unexpected exceptions.
> 
> [...]

Applied to kvm-x86 selftests_utils (I had already pushed stuff to "selftests",
so the name is less than awesome).

Other KVM maintainers, I also created tags/kvm-x86-selftests-utils if you want
to pull this into your tree to avoid later merge conflicts with the
kvm_util_base.h => kvm_util.h rename.  I don't expect to push anything else to
the branch, but never say never. 

Note, this branch+tag also has the _GNU_SOURCE change, and the global pseudo-RNG
series ("thank yous" incoming), i.e. it's hopefuly a one stop shop for all your
6.10 selftests needs!

[01/18] Revert "kvm: selftests: move base kvm_util.h declarations to kvm_util_base.h"
        https://github.com/kvm-x86/linux/commit/2b7deea3ec7c
[02/18] KVM: sefltests: Add kvm_util_types.h to hold common types, e.g. vm_vaddr_t
        https://github.com/kvm-x86/linux/commit/f54884f93898
[03/18] KVM: selftests: Move GDT, IDT, and TSS fields to x86's kvm_vm_arch
        https://github.com/kvm-x86/linux/commit/3a085fbf8228
[04/18] KVM: selftests: Fix off-by-one initialization of GDT limit
        https://github.com/kvm-x86/linux/commit/0d95817e0753
[05/18] KVM: selftests: Move platform_info_test's main assert into guest code
        https://github.com/kvm-x86/linux/commit/53635ec253c0
[06/18] KVM: selftests: Rework platform_info_test to actually verify #GP
        https://github.com/kvm-x86/linux/commit/dec79eab2b48
[07/18] KVM: selftests: Explicitly clobber the IDT in the "delete memslot" testcase
        https://github.com/kvm-x86/linux/commit/61c3cffd4cbf
[08/18] KVM: selftests: Move x86's descriptor table helpers "up" in processor.c
        https://github.com/kvm-x86/linux/commit/b62c32c532cd
[09/18] KVM: selftests: Rename x86's vcpu_setup() to vcpu_init_sregs()
        https://github.com/kvm-x86/linux/commit/d8c63805e4e5
[10/18] KVM: selftests: Init IDT and exception handlers for all VMs/vCPUs on x86
        https://github.com/kvm-x86/linux/commit/c1b9793b45d5
[11/18] KVM: selftests: Map x86's exception_handlers at VM creation, not vCPU setup
        https://github.com/kvm-x86/linux/commit/44c93b277269
[12/18] KVM: selftests: Allocate x86's GDT during VM creation
        https://github.com/kvm-x86/linux/commit/2a511ca99493
[13/18] KVM: selftests: Drop superfluous switch() on vm->mode in vcpu_init_sregs()
        https://github.com/kvm-x86/linux/commit/1051e29cb915
[14/18] KVM: selftests: Fold x86's descriptor tables helpers into vcpu_init_sregs()
        https://github.com/kvm-x86/linux/commit/23ef21f58cf8
[15/18] KVM: selftests: Allocate x86's TSS at VM creation
        https://github.com/kvm-x86/linux/commit/a2834e6e0b98
[16/18] KVM: selftests: Add macro for TSS selector, rename up code/data macros
        https://github.com/kvm-x86/linux/commit/f18ef97fc602
[17/18] KVM: selftests: Init x86's segments during VM creation
        https://github.com/kvm-x86/linux/commit/0f53a0245068
[18/18] KVM: selftests: Drop @selector from segment helpers
        https://github.com/kvm-x86/linux/commit/b093f87fd195

--
https://github.com/kvm-x86/linux/tree/next

