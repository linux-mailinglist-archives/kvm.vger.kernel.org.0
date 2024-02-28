Return-Path: <kvm+bounces-10278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5C9786B2A6
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 16:05:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FE162876DB
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 15:05:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16AC715D5C1;
	Wed, 28 Feb 2024 15:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="P5SxD/wu"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D6015D5CA
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709132691; cv=none; b=elX6UP4tD3rHY1dME1wpXjeX0RLIN6KoXMJ0jL+E1b2T9ZPrqVR2el7VCLA5L4GkCwmgHNoQwgbQbgiUEY9UGyw+A30Be/V67xFpnxr/gUCYcD388paxWq/qao+3NeauCAuk8mhAjy88UeSLfeO08bRSvA7pvnce17wGny63UnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709132691; c=relaxed/simple;
	bh=Gxu124jYD7uHNxUGgsV4eXj6jrJ38NoL7RfHKxH7qJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=KyP0qNi/a9PSALgFFZtvKyuTIOWcDs0INqhjW8+5EUPRdbaX5hK136tQGKq7Yjf9FvXanZ3CUjtHa0FmICASketyva4VUaN/df8U4GszLElWBIgcLTgg4TiUCclsHWVWygj3eYFw0uFuDlouSo8xNsgEW3EKp0AXxRlVPjqpaDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=P5SxD/wu; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709132688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dEDlPhP5bKzGjPEEgT4uTqoeAOZN/lxyA2JBkzi/kJY=;
	b=P5SxD/wuM8WgVXZE3V48Ah3E3kP8EmyvJwzrtGCEWf4EJepWhmhNXgK6PLyv5qKdqr/+8V
	4gyMbiqvIP6sMpjdK4Fqb/DLbyXKzPpxKnLUO59GreveEzbVoFNiTOMtjmR4f+D9lyfk+p
	dQYIJNaftfyIDamAUGgc1U72UEBRhog=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH 09/13] efi: Add support for obtaining the boot hartid
Date: Wed, 28 Feb 2024 16:04:25 +0100
Message-ID: <20240228150416.248948-24-andrew.jones@linux.dev>
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

riscv needs to use an EFI protocol to get the boot hartid.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/efi.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/lib/efi.c b/lib/efi.c
index edfcc80ef114..77cfbfac50ed 100644
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
@@ -422,6 +447,14 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
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
2.43.0


