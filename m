Return-Path: <kvm+bounces-33000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 712B19E3793
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 11:34:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D1EA163AAA
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 10:34:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE5061D5174;
	Wed,  4 Dec 2024 10:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lsoTfQNw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0850F1AA1EB;
	Wed,  4 Dec 2024 10:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733308285; cv=none; b=g4YQPeMXPVnqzmOH0OJYiSGlzrgQSRFRS4T12Av9F5bjUWfeYyE5fJg0wm8NChccBWJxgpmLt7TAfC1qW4NMC8lnwjR5eMKSu3lG7vOHt88/9AjNB+0cmWAwa9IJZ6mfuLjVuIO2tzrinZuOiMzKssgu8VK8HPernypqGDUi+C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733308285; c=relaxed/simple;
	bh=XoKZKhug6sRi6vamG7QA5kHYOwwNVkVd85l9YuV2i3U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gcQfveDTOMCNHfTeiAWrKRfDK8dXIeEFOX75FpRy3uTyRHYlWuYes1uSfL4CP84YgWo1kjROZHgJMX1EG/8yCxZz1PxpxMG2q57CyMwbeiq0CwCw3Z8kzff3RcdxDaYaElAXxz6yFufQk6u+obS3VIlbo0xNbXenSFdaBpsUHbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lsoTfQNw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795CDC4CEE1;
	Wed,  4 Dec 2024 10:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733308284;
	bh=XoKZKhug6sRi6vamG7QA5kHYOwwNVkVd85l9YuV2i3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lsoTfQNwTpriaLqLBjfMh2kM3gClxnnPf8d5/Vo703RX/vkrLhG8uM77j69LxkUSm
	 1Xly6KJlshqQdfVTWcRpWhn0Tf5PXjzk43kL0b5yUg7W6yQg+h6IpN27SuAXE8ynp2
	 IXqCsaOnZbm0FHLEVBis9aIRINNwJTh4rSqbMHR9eEtJX1JgArRDFsRe1f1kvIokhY
	 p5EUdKbC+RewTb9z8Y5Lksq2fG2C7CJHQc734Z7TFMHM+kOVhBRSw34Xpt2EJveUji
	 ++9rT7eiWP33meBXNa9KrOGQhWfdrqvbI3s0bzp6lLrN+WsaBrAl/l9+ELdPKG1a4I
	 qFQqTLUj3y6BQ==
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
Subject: [PATCH 06/11] x86: drop SWIOTLB and PHYS_ADDR_T_64BIT for PAE
Date: Wed,  4 Dec 2024 11:30:37 +0100
Message-Id: <20241204103042.1904639-7-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241204103042.1904639-1-arnd@kernel.org>
References: <20241204103042.1904639-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

Since kernels with and without CONFIG_X86_PAE are now limited
to the low 4GB of physical address space, there is no need to
use either swiotlb or 64-bit phys_addr_t any more, so stop
selecting these and fix up the build warnings from that.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/x86/Kconfig      | 2 --
 arch/x86/mm/pgtable.c | 2 +-
 include/linux/mm.h    | 2 +-
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b373db8a8176..d0d055f6f56e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1456,8 +1456,6 @@ config HIGHMEM
 config X86_PAE
 	bool "PAE (Physical Address Extension) Support"
 	depends on X86_32 && X86_HAVE_PAE
-	select PHYS_ADDR_T_64BIT
-	select SWIOTLB
 	help
 	  PAE is required for NX support, and furthermore enables
 	  larger swapspace support for non-overcommit purposes. It
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 5745a354a241..bdf63524e30a 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -769,7 +769,7 @@ int pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot)
 	mtrr_type_lookup(addr, addr + PMD_SIZE, &uniform);
 	if (!uniform) {
 		pr_warn_once("%s: Cannot satisfy [mem %#010llx-%#010llx] with a huge-page mapping due to MTRR override.\n",
-			     __func__, addr, addr + PMD_SIZE);
+			     __func__, (u64)addr, (u64)addr + PMD_SIZE);
 		return 0;
 	}
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index c39c4945946c..7725e9e46e90 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -99,7 +99,7 @@ extern int mmap_rnd_compat_bits __read_mostly;
 
 #ifndef DIRECT_MAP_PHYSMEM_END
 # ifdef MAX_PHYSMEM_BITS
-# define DIRECT_MAP_PHYSMEM_END	((1ULL << MAX_PHYSMEM_BITS) - 1)
+# define DIRECT_MAP_PHYSMEM_END	(phys_addr_t)((1ULL << MAX_PHYSMEM_BITS) - 1)
 # else
 # define DIRECT_MAP_PHYSMEM_END	(((phys_addr_t)-1)&~(1ULL<<63))
 # endif
-- 
2.39.5


