Return-Path: <kvm+bounces-11052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ABC8A872557
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 18:11:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6834628A5BB
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:11:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF0231AAD3;
	Tue,  5 Mar 2024 17:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aXpZyFtU"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1A71A29A
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 17:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709658572; cv=none; b=eNfYBoyetoTTrbkT67VWYwIlnUusjlVksmwhcPXbRwbuOMaBhmK+9DWEdnUb/aElZkj14eA+w/la96QGCjMLjMg+tUJef9+c6VTkN+I3iPDNVtPPvYx/LuTsRhZmMKNC4Pha+6B6mHY5LUP7qLZ/H5bostzuwGl69DSTzfze4aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709658572; c=relaxed/simple;
	bh=+G75Lb3eKKFA0/UVdFnVlCTjn9jY1KC7czWmO6yLZqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=JOGrJw0/2EhXxs+vWBXDBr5Y6VWtIwRXZOF+mOvKhc0mMfwUn+rgiuQjzfg28jmCGckZmxXWGdR4vxILP0nhW1/kfxSWYTM0cXr55HpWvZTOOuqbFTqbzKCTcynqGishqK09L0j3O/GzaO6JatPmTRCrTi2faNCZ1AX4jO6YctE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aXpZyFtU; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709658568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i2nUgA7Q/AniI8IUgvQEmLo7VLZ71Ynay5/iXRJIkG8=;
	b=aXpZyFtUck+6JUNQy3ncNnN4wCOeLLgzucCc6eVuyWED9x3nGx2zA07Q9gZvATwszgHtc8
	JN99riYYi8N95UibvtTvAqRRsvI+Dv5TfNAiEe58ttJbpJfPry9kzBEw3pB+PIFnfD02rQ
	OiCqbCADpUiYCcM+1q7XppaTy5Vx3/Y=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 11/13] riscv: Enable EFI boot
Date: Tue,  5 Mar 2024 18:09:10 +0100
Message-ID: <20240305170858.395836-26-andrew.jones@linux.dev>
In-Reply-To: <20240305170858.395836-15-andrew.jones@linux.dev>
References: <20240305170858.395836-15-andrew.jones@linux.dev>
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
index f721d81192ac..50ffb0d0751b 100644
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
+	if (efi_bootinfo->fdt)
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
2.44.0


