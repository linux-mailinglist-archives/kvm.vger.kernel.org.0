Return-Path: <kvm+bounces-22899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 80EA494474A
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:01:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36C3E284FED
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21E0616EB7A;
	Thu,  1 Aug 2024 09:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EJ27S9CM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C776C85628
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 09:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722502883; cv=none; b=IDe2Y6rtaZBEF116KCezNgK/P2KM2vJVkSQ+AhH/eTzsNHe28B9n8zT879aBYUrRWshtDuVhRHxD83ales3RuQI4LkDagdXDGXx5uSWJOC5eWihsPTwUVhHH62LtBs2q6G7p96l6G6M83cZHGectQCtwCNooeCT8SJd02IfdMQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722502883; c=relaxed/simple;
	bh=dVvqGGclYa5Phvh1oH8esztGPgkXEH0RFwp+p6mwmcs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=iWiXCeU1YyQHTYWpJ0/03Tii5DVtGkx/KeKPpS7OMgBln3YjRwnqF2FuKvAv+PJg/SKV8j31NGKn3NRLRwojzPUyxujOag0R/mlTQSb7l/kc75mgSQF+vas1s1jKFakkq9cORJit0m/VdiHDi6unzX0AZc+ju/YLSHITe0vXBL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EJ27S9CM; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-666010fb35cso31837237b3.0
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 02:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722502881; x=1723107681; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Xe9JulU9ubZjSforyL5UPrTOuPupt79Dp6Z8m7FP7ps=;
        b=EJ27S9CMCK4qTBglPFavVec3z3kAFTw88TfImFIXntVRVCqP9zpuFE8/czd//fbVDp
         TnYQgtVP8sqJ9ZsYd8nz8quIxIxH3QFqu4fhTnAF86GREZaGOyaiHUMLY5al0HN3LGuo
         YIC+QfnUDk7aR4UbU3Ta07h0hqtZookVLdIHRzYCAeKlvBlOxbkoe1Hf8whKqLhpATrY
         XC9WysAbX657PFoYrI9i6qvDHFKxBBJ7RZhyeJgTKUTqvIDRVWw6Q5y8F3/TBjiV+bXz
         QZmdZ8iC9HnKvQSylfP1yvRfKX/vbKhYT8uLelXmsz2pulhTyT/4CvmSNdpknXxODccm
         feEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722502881; x=1723107681;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xe9JulU9ubZjSforyL5UPrTOuPupt79Dp6Z8m7FP7ps=;
        b=k8E5WEKdJh6xZ6lrlWN/qTnLMQNrarqPmFRBRpe3o6Yit+YA7pNIMcd/yRjj8jsc7q
         qgPK6V6Ify/8DeSeVQYNsqLA8wYgDufgJn7KGSlL2Vc9lDMfBd69Cq6qLbaO5EtLMRyy
         VejJEpmN5HoL8kGytyhdZnfbd3FsAVcKZFwIewY77cixhxDi7NLOQnUE1bPkVDE9BQ1x
         Op0+5WCTxJ+3HoVijJN7qi9m+ZeC/iWz1qjltGps6FTXuMuEFk0tE/+leDsbdwXmBsrw
         kX1XJGqpilfyqUHgpeJFXMeD6ysDfuI6dkaAKFhXmpr19NW0W90MHJQDZE2OvpVtf7T4
         tj0w==
X-Gm-Message-State: AOJu0YwVjHADj9BvQM6jYIH7eyGXwOWHxdbVQgBj93JhpHNUTtlpV/fC
	nZqm4EjctOZqQOq6Rtj8rcneH6LVn9uq0iutPTKAuSJS6CaQ1/2YYhphhs4v5jUJYnoCzp6WpIT
	7BJs972dQJ05QlS+Nxd49aJJgGOy3MWKRxiPvQhaAqAScEdOyOxIXSVgKca6MH14eRTfuqCWRU0
	2IWaEzQGMXQdBCwPYRJXNVVA4=
X-Google-Smtp-Source: AGHT+IEkbm7eKiyptnKtDvqF54Af0lY5WtNDdg1rza9U70uM2cyHwfK08+zwYTkSwgPVnTm5E0t39WV6jw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:690c:fcf:b0:64b:5675:3ff5 with SMTP id
 00721157ae682-68850f45332mr21307b3.2.1722502880221; Thu, 01 Aug 2024 02:01:20
 -0700 (PDT)
Date: Thu,  1 Aug 2024 10:01:07 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801090117.3841080-1-tabba@google.com>
Subject: [RFC PATCH v2 00/10] KVM: Restricted mapping of guest_memfd at the
 host and pKVM/arm64 support
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

This series adds restricted mmap() support to guest_memfd, as
well as support for guest_memfd on pKVM/arm64. It is based on
Linux 6.10.

Main changes since V1 [1]:

- Decoupled whether guest memory is mappable from KVM memory
attributes (SeanC)

Mappability is now tracked in the guest_mem object, orthogonal to
whether userspace wants the memory to be private or shared.
Moreover, the memory attributes capability (i.e.,
KVM_CAP_MEMORY_ATTRIBUTES) is not enabled for pKVM, since for
software-based hypervisors such as pKVM and Gunyah, userspace is
informed of the state of the memory via hypervisor exits if
needed.

Even if attributes are enabled, this patch series would still
work (modulo bugs), without compromising guest memory nor
crashing the system.

- Use page_mapped() instead of page_mapcount() to check if page
is mapped (DavidH)

- Add a new capability, KVM_CAP_GUEST_MEMFD_MAPPABLE, to query
whether guest private memory can be mapped (with aforementioned
restrictions)

- Add a selftest to check whether memory is mappable when the
capability is enabled, and not mappable otherwise. Also, test the
effect of punching holes in mapped memory. (DavidH)

By design, guest_memfd cannot be mapped, read, or written by the
host. In pKVM, memory shared between a protected guest and the
host is shared in-place, unlike the other confidential computing
solutions that guest_memfd was originally envisaged for (e.g,
TDX). When initializing a guest, as well as when accessing memory
shared by the guest with the host, it would be useful to support
mapping that memory at the host to avoid copying its contents.

One of the benefits of guest_memfd is that it prevents a
misbehaving host process from crashing the system when attempting
to access (deliberately or accidentally) protected guest memory,
since this memory isn't mapped to begin with. Without
guest_memfd, the hypervisor would still prevent such accesses,
but in certain cases the host kernel wouldn't be able to recover,
causing the system to crash.

Support for mmap() in this patch series maintains the invariant
that only memory shared with the host, either explicitly by the
guest or implicitly before the guest has started running (in
order to populate its memory) is allowed to have a valid mapping
at the host. At no time should private (as viewed by the
hypervisor) guest memory be mapped at the host.

This patch series is divided into two parts:

The first part is to the KVM core code. It adds opt-in support
for mapping guest memory only as long as it is shared. For that,
the host needs to know the mappability status of guest memory.
Therefore, the series adds a structure to track whether memory is
mappable. This new structure is associated with each guest_memfd
object.

The second part of the series adds guest_memfd support for
pKVM/arm64.

We don't enforce the invariant that only memory shared with the
host can be mapped by the host userspace in
file_operations::mmap(), but we enforce it in
vm_operations_struct:fault(). On vm_operations_struct::fault(),
we check whether the page is allowed to be mapped. If not, we
deliver a SIGBUS to the current task, as discussed in the Linux
MM Alignment Session on this topic [2].

Currently there's no support for huge pages, which is something
we hope to add in the future, and seems to be a hot topic for the
upcoming LPC 2024 [3].

Cheers,
/fuad

[1] https://lore.kernel.org/all/20240222161047.402609-1-tabba@google.com/

[2] https://lore.kernel.org/all/20240712232937.2861788-1-ackerleytng@google.com/

[3] https://lpc.events/event/18/sessions/183/#20240919

Fuad Tabba (10):
  KVM: Introduce kvm_gmem_get_pfn_locked(), which retains the folio lock
  KVM: Add restricted support for mapping guestmem by the host
  KVM: Implement kvm_(read|/write)_guest_page for private memory slots
  KVM: Add KVM capability to check if guest_memfd can be mapped by the
    host
  KVM: selftests: guest_memfd mmap() test when mapping is allowed
  KVM: arm64: Skip VMA checks for slots without userspace address
  KVM: arm64: Do not allow changes to private memory slots
  KVM: arm64: Handle guest_memfd()-backed guest page faults
  KVM: arm64: arm64 has private memory support when config is enabled
  KVM: arm64: Enable private memory kconfig for arm64

 arch/arm64/include/asm/kvm_host.h             |   3 +
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/mmu.c                          | 139 +++++++++-
 include/linux/kvm_host.h                      |  72 +++++
 include/uapi/linux/kvm.h                      |   3 +-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/guest_memfd_test.c  |  47 +++-
 virt/kvm/Kconfig                              |   4 +
 virt/kvm/guest_memfd.c                        | 129 ++++++++-
 virt/kvm/kvm_main.c                           | 253 ++++++++++++++++--
 10 files changed, 628 insertions(+), 24 deletions(-)


base-commit: 0c3836482481200ead7b416ca80c68a29cfdaabd
-- 
2.46.0.rc1.232.g9752f9e123-goog


