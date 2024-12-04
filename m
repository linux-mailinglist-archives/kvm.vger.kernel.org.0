Return-Path: <kvm+bounces-32994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3065B9E377E
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 11:33:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D4D3282925
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 10:32:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0974C1AF0DD;
	Wed,  4 Dec 2024 10:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GI5yKIVx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1051A724C;
	Wed,  4 Dec 2024 10:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733308263; cv=none; b=FMw4zuNn0Qoz8kfILP4NUgrIlt17CRHdUnBsoqeUL8d5dOHZzaNySvZVy7rXtMNLDopBZ2K7KRV4DBeLH5u8IIKWlyHdJ1kEfA5sQ/RZgKvONgqi85/Brpkt94Sq4Q0bYHe3FBQZ4+QAlaJbyLdj/MBp6h4bAGCKoxe/FuAm7Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733308263; c=relaxed/simple;
	bh=Bn6eHZcPRt3zjnI1YtyTF9GMEdZ270E3qTXVp+jvgbs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TDlawlVS0tCexJcYVIR79c4VkJiPURerxBj+WcpBt2hCYtFpoZ9BfyJoRvkKl/LbQExS0GjxwdIptytUairlq+tnHxoEHMXUTI/C/a8YdGhExQ8WwGI3XmFZnWHGvVzuZkaxdncYE7b4AytbTeexezvVDh5GJCH/MdaRNj2elyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GI5yKIVx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F32FC4CED1;
	Wed,  4 Dec 2024 10:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733308262;
	bh=Bn6eHZcPRt3zjnI1YtyTF9GMEdZ270E3qTXVp+jvgbs=;
	h=From:To:Cc:Subject:Date:From;
	b=GI5yKIVxtfBpKbLtUMEXYi/sxIbQFZ9EaZ/l00fImR15x/1SzJM73oeHjMSUm6l3j
	 D1WGmuhYd7u8jdt0HG8rP9US3geVKx0j7518KhEfSvgxf9NOMEn9BCTA9XBNy24BFO
	 1eLMzBUEnqaaKTc9hDk1SNYgJ9EuBOhFR0vNAoTtkkmBirA4bm19bhL/2yJN9ReJrs
	 BUtdoa4yRCDYzggy1U2WhU6jxQmDN4YCheq/zKpdSK+4oIJV3z9FPI5jM10L0qL+4x
	 +yxmK17bTkME4nFAeqOj/XQ+AbYvn+qvS3N6JCn8S/cqCXpB4aFosOIzbRXQB9oRyC
	 FwO1iUVpAiyHw==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Shevchenko <andy@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Davide Ciminaghi <ciminaghi@gnudd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH 00/11] x86: 32-bit cleanups
Date: Wed,  4 Dec 2024 11:30:31 +0100
Message-Id: <20241204103042.1904639-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

While looking at 32-bit arm cleanups, I came across some related topics
on x86 and ended up making a series for those as well.

Primarily this is about running 32-bit kernels on 64-bit hardware,
which usually works but should probably be discouraged more clearly by
only providing support for features that are used on real 32-bit hardware:

I found only a few 2003-era high-end servers (HP DL740 and DL760 G2)
that were the only possible remaining uses of HIGHMEM64G and BIGSMP after
the removal of 32-bit NUMA machines in 2014. Similary, there is only
one generation of hardware with support for VT-x.  All these features
can be removed without hurting users.

In the CPU selection, building a 32-bit kernel optimized for AMD K8
or Intel Core2 is anachronistic, so instead only 32-bit CPU types need
to be offered as optimization targets. The "generic" target on 64-bit
turned out to be slightly broken, so I included a fix for that as well,
replacing the compiler default target with an intentional selection
between the useful levels.

Arnd Bergmann (11):
  x86/Kconfig: Geode CPU has cmpxchg8b
  x86: drop 32-bit "bigsmp" machine support
  x86: Kconfig.cpu: split out 64-bit atom
  x86: split CPU selection into 32-bit and 64-bit
  x86: remove HIGHMEM64G support
  x86: drop SWIOTLB and PHYS_ADDR_T_64BIT for PAE
  x86: drop support for CONFIG_HIGHPTE
  x86: document X86_INTEL_MID as 64-bit-only
  x86: rework CONFIG_GENERIC_CPU compiler flags
  x86: remove old STA2x11 support
  x86: drop 32-bit KVM host support

 Documentation/admin-guide/kdump/kdump.rst     |   4 -
 .../admin-guide/kernel-parameters.txt         |  11 -
 Documentation/arch/x86/usb-legacy-support.rst |  11 +-
 arch/x86/Kconfig                              | 119 ++-------
 arch/x86/Kconfig.cpu                          | 130 +++++++---
 arch/x86/Makefile                             |  10 +-
 arch/x86/Makefile_32.cpu                      |   3 +-
 arch/x86/configs/xen.config                   |   2 -
 arch/x86/include/asm/page_32_types.h          |   4 +-
 arch/x86/include/asm/pgalloc.h                |   5 -
 arch/x86/include/asm/sta2x11.h                |  13 -
 arch/x86/include/asm/vermagic.h               |   4 -
 arch/x86/kernel/apic/Makefile                 |   3 -
 arch/x86/kernel/apic/apic.c                   |   3 -
 arch/x86/kernel/apic/bigsmp_32.c              | 105 --------
 arch/x86/kernel/apic/local.h                  |  13 -
 arch/x86/kernel/apic/probe_32.c               |  29 ---
 arch/x86/kernel/head32.c                      |   3 -
 arch/x86/kvm/Kconfig                          |   6 +-
 arch/x86/kvm/Makefile                         |   4 +-
 arch/x86/kvm/cpuid.c                          |   9 +-
 arch/x86/kvm/emulate.c                        |  34 +--
 arch/x86/kvm/fpu.h                            |   4 -
 arch/x86/kvm/hyperv.c                         |   5 +-
 arch/x86/kvm/i8254.c                          |   4 -
 arch/x86/kvm/kvm_cache_regs.h                 |   2 -
 arch/x86/kvm/kvm_emulate.h                    |   8 -
 arch/x86/kvm/lapic.c                          |   4 -
 arch/x86/kvm/mmu.h                            |   4 -
 arch/x86/kvm/mmu/mmu.c                        | 134 ----------
 arch/x86/kvm/mmu/mmu_internal.h               |   9 -
 arch/x86/kvm/mmu/paging_tmpl.h                |   9 -
 arch/x86/kvm/mmu/spte.h                       |   5 -
 arch/x86/kvm/mmu/tdp_mmu.h                    |   4 -
 arch/x86/kvm/smm.c                            |  19 --
 arch/x86/kvm/svm/sev.c                        |   2 -
 arch/x86/kvm/svm/svm.c                        |  23 +-
 arch/x86/kvm/svm/vmenter.S                    |  20 --
 arch/x86/kvm/trace.h                          |   4 -
 arch/x86/kvm/vmx/main.c                       |   2 -
 arch/x86/kvm/vmx/nested.c                     |  24 +-
 arch/x86/kvm/vmx/vmcs.h                       |   2 -
 arch/x86/kvm/vmx/vmenter.S                    |  25 +-
 arch/x86/kvm/vmx/vmx.c                        | 117 +--------
 arch/x86/kvm/vmx/vmx.h                        |  23 +-
 arch/x86/kvm/vmx/vmx_ops.h                    |   7 -
 arch/x86/kvm/vmx/x86_ops.h                    |   2 -
 arch/x86/kvm/x86.c                            |  74 +-----
 arch/x86/kvm/x86.h                            |   4 -
 arch/x86/kvm/xen.c                            |  61 ++---
 arch/x86/mm/init_32.c                         |   9 +-
 arch/x86/mm/pgtable.c                         |  29 +--
 arch/x86/pci/Makefile                         |   2 -
 arch/x86/pci/sta2x11-fixup.c                  | 233 ------------------
 include/linux/mm.h                            |   2 +-
 55 files changed, 185 insertions(+), 1216 deletions(-)
 delete mode 100644 arch/x86/include/asm/sta2x11.h
 delete mode 100644 arch/x86/kernel/apic/bigsmp_32.c
 delete mode 100644 arch/x86/pci/sta2x11-fixup.c

-- 
2.39.5

To: x86@kernel.org 
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sean Christopherson <seanjc@google.com> 
Cc: Davide Ciminaghi <ciminaghi@gnudd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org

