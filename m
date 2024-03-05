Return-Path: <kvm+bounces-11050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CA849872554
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 18:10:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FAD41F2653F
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:10:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D77D418EBB;
	Tue,  5 Mar 2024 17:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ox5edQsP"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D08175A6
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 17:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709658568; cv=none; b=ci3S+7EAVmC1tLh0i2IQtyVeEbkQvVQDjhMx/luAueU84GVHkcR3M91YAWNSVDqVsfV1uJ5LWK22jVDxgatLtn2A0uEHccIJOfAfNgcM85GMFQXeuLzgJS9tYLEqoWhs3ZKVVtUED85h/pkZGvWSur/dwfsdwlaKn1dbgsnIdEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709658568; c=relaxed/simple;
	bh=LMwq9BidVgZ1vkBplHg2V2z3Wsc9HFMsDHszgEs/6RY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=RxI/vNAkQFOkJAVYbFQ0GZjUvdMoekV329WYTsXg1TlUSJHYiWEjnVxP6uGSK2SkXZrHoAfMqkfr7RD8/RPD6USGoYBANS0a1ZOWU1AH++LUQ+zNYb+EmqQYeBPValqIV1pJUjt2isa/7HNlhxB5aypKNSXeYtEm7L+2dmeu5/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ox5edQsP; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709658564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=93j558n2c9M/wnd4Gl+GXqrjA0pFzvhNpPqZFAfZ8b4=;
	b=ox5edQsP4fReVT1V3AREl0nJmBkXszE9KZAr8+enA6Qkas/hdHhDRh+nvIiLc70P3cXtTA
	+VGvAelPsLiqHfTRWlOBuVFy7TbiS3lqkQEVduPdPENy2nA+gV+8qSKXYF+8mj662eeCS9
	DLu4DhSn2+Spmk5+8dG4Ca6qCRpBvPw=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 09/13] efi: Add support for obtaining the boot hartid
Date: Tue,  5 Mar 2024 18:09:08 +0100
Message-ID: <20240305170858.395836-24-andrew.jones@linux.dev>
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

riscv needs to use an EFI protocol to get the boot hartid.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/efi.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/lib/efi.c b/lib/efi.c
index 12c66c6ffd1f..5314eaa81e66 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -29,6 +29,31 @@ extern int main(int argc, char **argv, char **envp);
 
 efi_system_table_t *efi_system_table = NULL;
 
+#ifdef __riscv
+#define RISCV_EFI_BOOT_PROTOCOL_GUID EFI_GUID(0xccd15fec, 0x6f73, 0x4eec,  0x83, 0x95, 0x3e, 0x69, 0xe4, 0xb9, 0x40, 0xbf)
+
+unsigned long boot_hartid;
+
+struct riscv_efi_boot_protocol {
+	u64 revision;
+	efi_status_t (*get_boot_hartid)(struct riscv_efi_boot_protocol *,
+		      unsigned long *boot_hartid);
+};
+
+static efi_status_t efi_get_boot_hartid(void)
+{
+	efi_guid_t boot_protocol_guid = RISCV_EFI_BOOT_PROTOCOL_GUID;
+	struct riscv_efi_boot_protocol *boot_protocol;
+	efi_status_t status;
+
+	status = efi_bs_call(locate_protocol, &boot_protocol_guid, NULL,
+			     (void **)&boot_protocol);
+	if (status != EFI_SUCCESS)
+		return status;
+	return efi_call_proto(boot_protocol, get_boot_hartid, &boot_hartid);
+}
+#endif
+
 static void efi_free_pool(void *ptr)
 {
 	efi_bs_call(free_pool, ptr);
@@ -421,6 +446,14 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 		goto efi_main_error;
 	}
 
+#ifdef __riscv
+	status = efi_get_boot_hartid();
+	if (status != EFI_SUCCESS) {
+		printf("Failed to get boot haritd\n");
+		goto efi_main_error;
+	}
+#endif
+
 	/* 
 	 * Exit EFI boot services, let kvm-unit-tests take full control of the
 	 * guest
-- 
2.44.0


