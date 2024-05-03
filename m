Return-Path: <kvm+bounces-16529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 71E8C8BB2AB
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 20:19:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9519A1C2031F
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 18:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B65A158A36;
	Fri,  3 May 2024 18:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KY9EphbW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948E215530D
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 18:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714760261; cv=none; b=N/tHfzWGlJ+izNKF/vxU17TfVmU4P8m9tykqajaMpq1ahL96ORiOXJmUD1JdQhaNHhj2uw46QgQ3sPk6pqYC57VSigeF/LItKHT2qLn4s3GxPJ43V4TQ5EymHmYwaCg+nKqYt48+qyxvwIKceWJu5QnxWP+Cn97Qrq4ovSznTRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714760261; c=relaxed/simple;
	bh=xBGFTYdyUOnHArOcW3JXAxjXjjvPLqJKxAY8xK+n/W4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=dlNLJe64OqSynX93MWI1Pgnddn2QjZXSEl+N1DL42IR9DPEAG/IAycENHYXiMU3sOcfqy8LcR7ZCSrGVqEalv0SYZQwnV6+uqoA96eGILHr5FMjh3VoZb/FJRe0kGBZURmqgncBnj7BimCnPSh0xG+b9Gq6X8LZdxnUJg+JHsHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KY9EphbW; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de615257412so8633538276.0
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 11:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714760258; x=1715365058; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=u5lOataUl4CqNIE0BOfGoSKjtAnehJHFOaimjTGPj/Y=;
        b=KY9EphbWEvaWYHycofn0JF+oFT1mV0XIuivbBWnIfDJQv5jMYDnOjvyO88kHqX/HPE
         nyf3+FOHtdA20hzKXRBcBOzvP9+LTiarTyJnqxGSC9QPoR58KUpIQSTmDmCMZzxW+XdF
         jd3SD5VL/OA52STy0Q3yg0JlonqF8mSC4G+asI65FHUYrkp5Q3NlcKcOn21NhvTnFoV2
         +yZ/Ru2gU4aN8o8mnjH4aZflGF54Ug1F3T4nV+5zh75Ooi+pcznvJx1Wr5GV7AeIYY9V
         hL7VUF9eQ7AcTO0263AQ58k0PyG+JbI0onDpo5Ylle4A1Dwr9Xy8p9dSWFv3Edmk4GKW
         yZsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714760258; x=1715365058;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u5lOataUl4CqNIE0BOfGoSKjtAnehJHFOaimjTGPj/Y=;
        b=pmb1UWao5IsPw006zi0jWaUAnq09bhjm5h1NLHDh2k3JR8X4arGa2oyYyWRS/J/3Vv
         2m9ktT4ajkgyfemn6zxpqlX//4lgpRxAbub6/UlnTBMmpLCNpWtZkDIrHhi7HOapSVkY
         2hkyniALEZWfql0Yrm+clWPt1fbmTxO2DOPNG/3MWL5aEH4qOZyFkPjOzoDs8v5hZG7O
         ewRrDCdCpTapKXeVR+K/f9us4gTrJjl8MaE7v9jqDFfEOLsViViQoXe3Jws7R/p089rF
         7N0VA+rEz0ipQEey9UICbTOmZ5S+hUBvnNIKC46gcMcyXyHaWG5e5OSyv0M5QpWh82U5
         JjVg==
X-Forwarded-Encrypted: i=1; AJvYcCU9PNWWXhTw4gXTChN1D72kwZ3jlWCGtPACft3VNqLN3IlCp9RcWl721bSBhquumnYO1UnGFFDHqhodp+c9LVndf6B/
X-Gm-Message-State: AOJu0YxAwyOOOdJ/t4eEoGVfYgXPUG9w4OrWP/2D2VAwlIQk114dcHwn
	1WZ3muO1tuRXuUuhwehvSF2vAwWkZ1VdhavQX5eAfadFvzHsMmCW+ThPQlHZCMZsxiok42wFB01
	y/FqVEeGI5g==
X-Google-Smtp-Source: AGHT+IGi/6BGSqLUvb7wYnWHXOlhd9obpauunW/BcufWuEVmkE7H211A4Dm9y03t3pfp70UoCYU1Se1aO50snA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6902:729:b0:dcc:c57c:8873 with SMTP
 id l9-20020a056902072900b00dccc57c8873mr1104781ybt.9.1714760258668; Fri, 03
 May 2024 11:17:38 -0700 (PDT)
Date: Fri,  3 May 2024 11:17:31 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240503181734.1467938-1-dmatlack@google.com>
Subject: [PATCH v3 0/3] KVM: Set vcpu->preempted/ready iff scheduled out while running
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

This series changes KVM to mark a vCPU as preempted/ready if-and-only-if
it's scheduled out while running. i.e. Do not mark a vCPU
preempted/ready if it's scheduled out during a non-KVM_RUN ioctl() or
when userspace is doing KVM_RUN with immediate_exit=true.

This is a logical extension of commit 54aa83c90198 ("KVM: x86: do not
set st->preempted when going back to user space"), which  stopped
marking a vCPU as preempted when returning to userspace. But if userspace
invokes a KVM vCPU ioctl() that gets preempted, the vCPU will be marked
preempted/ready. This is arguably incorrect behavior since the vCPU was
not actually preempted while the guest was running, it was preempted
while doing something on behalf of userspace.

In practice, this avoids KVM dirtying guest memory via the steal time
page after userspace has paused vCPUs, e.g. for Live Migration, which
allows userspace to collect the final dirty bitmap before or in parallel
with saving vCPU state without having to worry about saving vCPU state
triggering writes to guest memory.

Patch 1 introduces vcpu->wants_to_run to allow KVM to detect when a vCPU
is in its core run loop.

Patch 2 renames immediated_exit to immediated_exit__unsafe within KVM to
ensure that any new references get extra scrutiny.

Patch 3 perform leverages vcpu->wants_to_run to contrain when
vcpu->preempted and vcpu->ready are set.

v3:
 - Use READ_ONCE() to read immediate_exit [Sean]
 - Replace use of immediate_exit with !wants_to_run to avoid TOCTOU [Sean]
 - Hide/Rename immediate_exit in KVM to harden against TOCTOU bugs [Sean]

v2: https://lore.kernel.org/kvm/20240307163541.92138-1-dmatlack@google.com/
 - Drop Google-specific "PRODKERNEL: " shortlog prefix [me]

v1: https://lore.kernel.org/kvm/20231218185850.1659570-1-dmatlack@google.com/

David Matlack (3):
  KVM: Introduce vcpu->wants_to_run
  KVM: Ensure new code that references immediate_exit gets extra
    scrutiny
  KVM: Mark a vCPU as preempted/ready iff it's scheduled out while
    running

 arch/arm64/kvm/arm.c       |  2 +-
 arch/loongarch/kvm/vcpu.c  |  2 +-
 arch/mips/kvm/mips.c       |  2 +-
 arch/powerpc/kvm/powerpc.c |  2 +-
 arch/riscv/kvm/vcpu.c      |  2 +-
 arch/s390/kvm/kvm-s390.c   |  2 +-
 arch/x86/kvm/x86.c         |  4 ++--
 include/linux/kvm_host.h   |  1 +
 include/uapi/linux/kvm.h   | 15 ++++++++++++++-
 virt/kvm/kvm_main.c        |  5 ++++-
 10 files changed, 27 insertions(+), 10 deletions(-)


base-commit: 296655d9bf272cfdd9d2211d099bcb8a61b93037
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


