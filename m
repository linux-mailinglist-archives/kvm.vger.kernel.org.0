Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6563B143DC7
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 14:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgAUNRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 08:17:55 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41703 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725890AbgAUNRz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 08:17:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579612673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OwXlzBEQhwCa8wParpIDpsxijVGaBsk9N2BIUCVw5x0=;
        b=M9phjKZrh86I3bUJchHV2cjmR6co4A2pIC4Mi7CmdSeD4ku+bU37Sw5sdjT2oHDdJRa5FI
        sOusQQQJeDRDpkETWzQsfnNMJ7eC4w4u20FeZOOVIM2KuEEjvupouHOJetLZf9HSaDEKZW
        4X2UNJ6aR5is83QHqahAfdIADOSwgpY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-HZWepzHeN9uLTece5MYilQ-1; Tue, 21 Jan 2020 08:17:50 -0500
X-MC-Unique: HZWepzHeN9uLTece5MYilQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C34B108BD0D;
        Tue, 21 Jan 2020 13:17:49 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4711110002A2;
        Tue, 21 Jan 2020 13:17:48 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com
Subject: [PATCH kvm-unit-tests 1/3] arm/arm64: Improve memory region management
Date:   Tue, 21 Jan 2020 14:17:43 +0100
Message-Id: <20200121131745.7199-2-drjones@redhat.com>
In-Reply-To: <20200121131745.7199-1-drjones@redhat.com>
References: <20200121131745.7199-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add expected I/O regions and provide a way to check memory region
properties of a physical address. We also bump the initial number
of regions and even prepare for a unit test to reallocate for
growth if necessary.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm/asm/setup.h |  8 +++++--
 lib/arm/mmu.c       | 24 ++++++-------------
 lib/arm/setup.c     | 56 +++++++++++++++++++++++++++++++++------------
 3 files changed, 55 insertions(+), 33 deletions(-)

diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
index 81cac019b1d1..c8afb2493f8d 100644
--- a/lib/arm/asm/setup.h
+++ b/lib/arm/asm/setup.h
@@ -13,16 +13,20 @@
 extern u64 cpus[NR_CPUS];	/* per-cpu IDs (MPIDRs) */
 extern int nr_cpus;
=20
-#define NR_MEM_REGIONS		8
 #define MR_F_PRIMARY		(1U << 0)
+#define MR_F_IO			(1U << 1)
+#define MR_F_UNKNOWN		(1U << 31)
+
 struct mem_region {
 	phys_addr_t start;
 	phys_addr_t end;
 	unsigned int flags;
 };
-extern struct mem_region mem_regions[NR_MEM_REGIONS];
+extern struct mem_region *mem_regions;
 extern phys_addr_t __phys_offset, __phys_end;
=20
+extern unsigned int mem_region_get_flags(phys_addr_t paddr);
+
 #define PHYS_OFFSET		(__phys_offset)
 #define PHYS_END		(__phys_end)
=20
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 5fb56180d334..540a1e842d5b 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -152,6 +152,7 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t vir=
t_offset,
 void *setup_mmu(phys_addr_t phys_end)
 {
 	uintptr_t code_end =3D (uintptr_t)&etext;
+	struct mem_region *r;
=20
 	/* 0G-1G =3D I/O, 1G-3G =3D identity, 3G-4G =3D vmalloc */
 	if (phys_end > (3ul << 30))
@@ -163,23 +164,12 @@ void *setup_mmu(phys_addr_t phys_end)
=20
 	mmu_idmap =3D alloc_page();
=20
-	/*
-	 * mach-virt I/O regions:
-	 *   - The first 1G (arm/arm64)
-	 *   - 512M at 256G (arm64, arm uses highmem=3Doff)
-	 *   - 512G at 512G (arm64, arm uses highmem=3Doff)
-	 */
-	mmu_set_range_sect(mmu_idmap,
-		0, 0, (1ul << 30),
-		__pgprot(PMD_SECT_UNCACHED | PMD_SECT_USER));
-#ifdef __aarch64__
-	mmu_set_range_sect(mmu_idmap,
-		(1ul << 38), (1ul << 38), (1ul << 38) | (1ul << 29),
-		__pgprot(PMD_SECT_UNCACHED | PMD_SECT_USER));
-	mmu_set_range_sect(mmu_idmap,
-		(1ul << 39), (1ul << 39), (1ul << 40),
-		__pgprot(PMD_SECT_UNCACHED | PMD_SECT_USER));
-#endif
+	for (r =3D mem_regions; r->end; ++r) {
+		if (!(r->flags & MR_F_IO))
+			continue;
+		mmu_set_range_sect(mmu_idmap, r->start, r->start, r->end,
+				   __pgprot(PMD_SECT_UNCACHED | PMD_SECT_USER));
+	}
=20
 	/* armv8 requires code shared between EL1 and EL0 to be read-only */
 	mmu_set_range_ptes(mmu_idmap, PHYS_OFFSET,
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 4f02fca85607..385e135f4865 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -24,6 +24,8 @@
=20
 #include "io.h"
=20
+#define NR_INITIAL_MEM_REGIONS 16
+
 extern unsigned long stacktop;
=20
 char *initrd;
@@ -32,7 +34,8 @@ u32 initrd_size;
 u64 cpus[NR_CPUS] =3D { [0 ... NR_CPUS-1] =3D (u64)~0 };
 int nr_cpus;
=20
-struct mem_region mem_regions[NR_MEM_REGIONS];
+static struct mem_region __initial_mem_regions[NR_INITIAL_MEM_REGIONS + =
1];
+struct mem_region *mem_regions =3D __initial_mem_regions;
 phys_addr_t __phys_offset, __phys_end;
=20
 int mpidr_to_cpu(uint64_t mpidr)
@@ -65,41 +68,66 @@ static void cpu_init(void)
 	set_cpu_online(0, true);
 }
=20
+unsigned int mem_region_get_flags(phys_addr_t paddr)
+{
+	struct mem_region *r;
+
+	for (r =3D mem_regions; r->end; ++r) {
+		if (paddr >=3D r->start && paddr < r->end)
+			return r->flags;
+	}
+
+	return MR_F_UNKNOWN;
+}
+
 static void mem_init(phys_addr_t freemem_start)
 {
-	struct dt_pbus_reg regs[NR_MEM_REGIONS];
+	struct dt_pbus_reg regs[NR_INITIAL_MEM_REGIONS];
 	struct mem_region primary, mem =3D {
 		.start =3D (phys_addr_t)-1,
 	};
 	phys_addr_t base, top;
-	int nr_regs, i;
+	int nr_regs, nr_io =3D 0, i;
=20
-	nr_regs =3D dt_get_memory_params(regs, NR_MEM_REGIONS);
+	/*
+	 * mach-virt I/O regions:
+	 *   - The first 1G (arm/arm64)
+	 *   - 512M at 256G (arm64, arm uses highmem=3Doff)
+	 *   - 512G at 512G (arm64, arm uses highmem=3Doff)
+	 */
+	mem_regions[nr_io++] =3D (struct mem_region){ 0, (1ul << 30), MR_F_IO }=
;
+#ifdef __aarch64__
+	mem_regions[nr_io++] =3D (struct mem_region){ (1ul << 38), (1ul << 38) =
| (1ul << 29), MR_F_IO };
+	mem_regions[nr_io++] =3D (struct mem_region){ (1ul << 39), (1ul << 40),=
 MR_F_IO };
+#endif
+
+	nr_regs =3D dt_get_memory_params(regs, NR_INITIAL_MEM_REGIONS - nr_io);
 	assert(nr_regs > 0);
=20
 	primary =3D (struct mem_region){ 0 };
=20
 	for (i =3D 0; i < nr_regs; ++i) {
-		mem_regions[i].start =3D regs[i].addr;
-		mem_regions[i].end =3D regs[i].addr + regs[i].size;
+		struct mem_region *r =3D &mem_regions[nr_io + i];
+
+		r->start =3D regs[i].addr;
+		r->end =3D regs[i].addr + regs[i].size;
=20
 		/*
 		 * pick the region we're in for our primary region
 		 */
-		if (freemem_start >=3D mem_regions[i].start
-				&& freemem_start < mem_regions[i].end) {
-			mem_regions[i].flags |=3D MR_F_PRIMARY;
-			primary =3D mem_regions[i];
+		if (freemem_start >=3D r->start && freemem_start < r->end) {
+			r->flags |=3D MR_F_PRIMARY;
+			primary =3D *r;
 		}
=20
 		/*
 		 * set the lowest and highest addresses found,
 		 * ignoring potential gaps
 		 */
-		if (mem_regions[i].start < mem.start)
-			mem.start =3D mem_regions[i].start;
-		if (mem_regions[i].end > mem.end)
-			mem.end =3D mem_regions[i].end;
+		if (r->start < mem.start)
+			mem.start =3D r->start;
+		if (r->end > mem.end)
+			mem.end =3D r->end;
 	}
 	assert(primary.end !=3D 0);
 	assert(!(mem.start & ~PHYS_MASK) && !((mem.end - 1) & ~PHYS_MASK));
--=20
2.21.1

