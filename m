Return-Path: <kvm+bounces-43199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ED613A870FF
	for <lists+kvm@lfdr.de>; Sun, 13 Apr 2025 10:09:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8AE177ADFDC
	for <lists+kvm@lfdr.de>; Sun, 13 Apr 2025 08:08:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B20E5189916;
	Sun, 13 Apr 2025 08:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MN8zXW6N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FEAA94F;
	Sun, 13 Apr 2025 08:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744531747; cv=none; b=KhUOJOe58gEq4/uxsJ1Wuc8lJrAI3567rG4Vvpozht7hoUl9nMuN0yDRsLocb4EkFp0p0GJPXR62nmKyx/TFnMhSYmkpr0lwvHX/gfeo5BKUXV5mmUzR1vVzWT4ZcbLo/9BcxoNT2Lz7TABW/SV2GFdCuSDemSFAfxsTez8/WR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744531747; c=relaxed/simple;
	bh=GWG8SgNv4zgzWOzEgAd0tDbX+g4hYTllIbDYmfzfxEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxn3DjBTP1648tJ75yxB8ztp2WDFztCUV+e5eFN9yQ7k0IPvProKOQz8J9+KkPYdAb6vrY7gE2QIj61oB8WcZNlGaHVMNCtlD4hZ0/W7JkTdimc1IcJfMas7RxiulTTHig2cEXQYqOvIpGtqRbGbFGp6cBCNCZGcq5XSOPKIh3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MN8zXW6N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDA9C4CEE7;
	Sun, 13 Apr 2025 08:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744531747;
	bh=GWG8SgNv4zgzWOzEgAd0tDbX+g4hYTllIbDYmfzfxEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MN8zXW6NWqiEm1NU32mHLEUFjEn9HJllLre0U+FM6w89QVgeh687Yt4mmMNQN9asl
	 cuJ63bc0ne3AZjw5OgOC8evY24iwVncl90BQtr7dROpoJKQWOeEqomeNyGfXzcgPM/
	 jYHCpUnKTWCpHl1IFTheYhxC8xvPIR6KyYnl1sTcNRYEAAuwyhrW3zf9FB29ayBuh4
	 gDxm+zXqii+7BuJLCFyRK4Z2dDACm7he8Nxf46FFUgIWDlFHSBDCf8rupxFjsBg/Vx
	 n2R8MFQITgFJhSlV3otHxUeEyVKOtGLhFEUy9tKb46wIk7iMCyieoE+aslh8xN2sXO
	 gynQe22cMV4tQ==
From: Mike Rapoport <rppt@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andy Shevchenko <andy@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Arnd Bergmann <arnd@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Davide Ciminaghi <ciminaghi@gnudd.com>,
	Ingo Molnar <mingo@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH] x86/e820: discard high memory that can't be addressed by 32-bit systems
Date: Sun, 13 Apr 2025 11:08:58 +0300
Message-ID: <20250413080858.743221-1-rppt@kernel.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <Z_rDdnlSs0rts3b9@gmail.com>
References: <Z_rDdnlSs0rts3b9@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Dave Hansen reports the following crash on a 32-bit system with
CONFIG_HIGHMEM=y and CONFIG_X86_PAE=y:

  > 0xf75fe000 is the mem_map[] entry for the first page >4GB. It
  > obviously wasn't allocated, thus the oops.

  BUG: unable to handle page fault for address: f75fe000
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  *pdpt = 0000000002da2001 *pde = 000000000300c067 *pte = 0000000000000000
  Oops: Oops: 0002 [#1] SMP NOPTI
  CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.15.0-rc1-00288-ge618ee89561b-dirty #311 PREEMPT(undef)
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
  EIP: __free_pages_core+0x3c/0x74
  Code: c3 d3 e6 83 ec 10 89 44 24 08 89 74 24 04 c7 04 24 c6 32 3a c2 89 55 f4 e8 a9 11 45 fe 85 f6 8b 55 f4 74 19 89 d8 31 c9 66 90 <0f> ba 30 0d c7 40 1c 00 00 00 00 41 83 c0 28 39 ce 75 ed 8b

  EAX: f75fe000 EBX: f75fe000 ECX: 00000000 EDX: 0000000a
  ESI: 00000400 EDI: 00500000 EBP: c247becc ESP: c247beb4
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210046
  CR0: 80050033 CR2: f75fe000 CR3: 02da6000 CR4: 000000b0
  Call Trace:
   memblock_free_pages+0x11/0x2c
   memblock_free_all+0x2ce/0x3a0
   mm_core_init+0xf5/0x320
   start_kernel+0x296/0x79c
   ? set_init_arg+0x70/0x70
   ? load_ucode_bsp+0x13c/0x1a8
   i386_start_kernel+0xad/0xb0
   startup_32_smp+0x151/0x154
  Modules linked in:
  CR2: 00000000f75fe000

The mem_map[] is allocated up to the end of ZONE_HIGHMEM which is defined
by max_pfn.

Before 6faea3422e3b ("arch, mm: streamline HIGHMEM freeing") freeing of
high memory was also clamped to the end of ZONE_HIGHMEM but after
6faea3422e3b memblock_free_all() tries to free memory above the of
ZONE_HIGHMEM as well and that causes access to mem_map[] entries beyond
the end of the memory map.

Discard the memory after max_pfn from memblock on 32-bit systems so that
core MM would be aware only of actually usable memory.

Reported-by: Dave Hansen <dave.hansen@intel.com>
Tested-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/kernel/e820.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 57120f0749cc..5f673bd6c7d7 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1300,6 +1300,14 @@ void __init e820__memblock_setup(void)
 		memblock_add(entry->addr, entry->size);
 	}
 
+	/*
+	 * 32-bit systems are limited to 4BG of memory even with HIGHMEM and
+	 * to even less without it.
+	 * Discard memory after max_pfn - the actual limit detected at runtime.
+	 */
+	if (IS_ENABLED(CONFIG_X86_32))
+		memblock_remove(PFN_PHYS(max_pfn), -1);
+
 	/* Throw away partial pages: */
 	memblock_trim_memory(PAGE_SIZE);
 

base-commit: 0af2f6be1b4281385b618cb86ad946eded089ac8
-- 
2.47.2


