Return-Path: <kvm+bounces-10280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A5A2186B2A8
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 16:05:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6065328B145
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 15:05:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DF0B15B96D;
	Wed, 28 Feb 2024 15:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JuilRahO"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31DB15B96A
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 15:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709132696; cv=none; b=BRFdynsLTuVev4aa3ZuEHIHnuN8b7Cutq/Ky0SXa++CmVdFQLRCWnWprNtaRwhTdew9EJIkLlyQqbvjlqP0WgXIdqcifKsptr1vHKcvuc6CtHkg/z4UjE93a3lxrFGfNKf+SrR6yMx+Hb+SVO5sdhjm9CHqz9Y9DxKNcNQFxXfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709132696; c=relaxed/simple;
	bh=M7l9WcQjRCRPIaALDcYvRNDAhGrswB9B7HMxRw2YrXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=QuM2u0LyYFO4rla2zhMjsrhHOpQJLPP+X79zhtWtTwjrW87YgtRks6+FqRrCvRZX4BAV1cHwcBlXA9Tq2JwTLOt73+xKhSCmxwt0USWOVMvwBOp5MzqcDD5Fn705djwroiyA1vDNKyRZcNbksGfCYOLQAz8bQAzhvuMJaium3d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JuilRahO; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709132693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Haw5zmzBY2q3Vdx4wPZtDT0E5FiekDAKsYYwrB1PwwM=;
	b=JuilRahOR7Rql+r3UbXYCCynjvxKD48tqQfj/f9EPGp6aK7WcrG9NLCl/nkuB36rROrVxh
	HBqt/R50F8D4KQeD00by9l412w7lCPkoVXN6V47MBnnInoy0OWqVlg4amQCuyZTaZ0EJwr
	z9/89ZdVOHg6ULOv8kLb2sQ5f7sObaE=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH 11/13] riscv: Enable EFI boot
Date: Wed, 28 Feb 2024 16:04:27 +0100
Message-ID: <20240228150416.248948-26-andrew.jones@linux.dev>
In-Reply-To: <20240228150416.248948-15-andrew.jones@linux.dev>
References: <20240228150416.248948-15-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Mimicking Arm's setup_efi() and duplicating some code from riscv's
setup(), add the EFI setup code needed to boot unit tests from EFI-
capable bootloaders. The selftest unit test can now be run with

  qemu-system-riscv64 \
    -nodefaults -nographic -serial mon:stdio \
    -accel tcg -cpu max \
    -machine virt,pflash0=pflash0 \
    -blockdev node-name=pflash0,driver=file,read-only=on,filename=RISCV_VIRT_CODE.fd \
    -smp 16 \
    -kernel riscv/selftest.efi \
    -initrd test-env \
    -append 'selftest.efi foo bar baz' \
    -machine acpi=off

where test-env has the environment variables
  $ cat test-env
  FOO=foo
  BAR=bar
  BAZ=baz

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/asm/setup.h |  2 +-
 lib/riscv/setup.c     | 63 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/lib/riscv/asm/setup.h b/lib/riscv/asm/setup.h
index dfc8875fbb3b..7f81a705ca4f 100644
--- a/lib/riscv/asm/setup.h
+++ b/lib/riscv/asm/setup.h
@@ -14,7 +14,7 @@ void setup(const void *fdt, phys_addr_t freemem_start);
 
 #ifdef CONFIG_EFI
 #include <efi.h>
-static inline efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo) { return 0; }
+efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo);
 #endif
 
 #endif /* _ASMRISCV_SETUP_H_ */
diff --git a/lib/riscv/setup.c b/lib/riscv/setup.c
index f721d81192ac..7c681ea3a13c 100644
--- a/lib/riscv/setup.c
+++ b/lib/riscv/setup.c
@@ -213,3 +213,66 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 
 	banner();
 }
+
+#ifdef CONFIG_EFI
+#include <efi.h>
+
+extern unsigned long exception_vectors;
+extern unsigned long boot_hartid;
+
+static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
+{
+	struct mem_region *freemem_mr = NULL, *code, *data;
+	void *freemem;
+
+	memregions_init(riscv_mem_regions, NR_MEM_REGIONS);
+
+	memregions_efi_init(&efi_bootinfo->mem_map, &freemem_mr);
+	if (!freemem_mr)
+		return EFI_OUT_OF_RESOURCES;
+
+	memregions_split((unsigned long)&_etext, &code, &data);
+	assert(code && (code->flags & MR_F_CODE));
+	if (data)
+		data->flags &= ~MR_F_CODE;
+
+	for (struct mem_region *m = mem_regions; m->end; ++m)
+		assert(m == code || !(m->flags & MR_F_CODE));
+
+	freemem = (void *)PAGE_ALIGN(freemem_mr->start);
+
+	if (efi_bootinfo->fdt_valid)
+		freemem_push_fdt(&freemem, efi_bootinfo->fdt);
+
+	mmu_disable();
+	mem_allocator_init((unsigned long)freemem, freemem_mr->end);
+
+	return EFI_SUCCESS;
+}
+
+efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
+{
+	efi_status_t status;
+
+	csr_write(CSR_STVEC, (unsigned long)&exception_vectors);
+	csr_write(CSR_SSCRATCH, boot_hartid);
+
+	status = efi_mem_init(efi_bootinfo);
+	if (status != EFI_SUCCESS) {
+		printf("Failed to initialize memory\n");
+		return status;
+	}
+
+	cpu_init();
+	thread_info_init();
+	io_init();
+	initrd_setup();
+
+	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
+		setup_vm();
+
+	banner();
+
+	return EFI_SUCCESS;
+}
+#endif /* CONFIG_EFI */
-- 
2.43.0


