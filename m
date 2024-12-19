Return-Path: <kvm+bounces-34145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 40E179F7BB5
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 13:45:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE8AB1880562
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 12:44:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34A0722488F;
	Thu, 19 Dec 2024 12:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I4IdH9l7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C835F1FC7D1
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 12:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734612273; cv=none; b=ESHs09zrA7r5xw73prYMI5StPB5nwvivdSIJ3xv3lAADThjeOg4ZONonr9CQHqZ1vHAlpcD1qD+4M/t2Va2tqZi0ENn0YrqY1gQHEU2nodK30/eholfIdVTUIiPNiD/UZnxut9FH1RdSAJBb8+IaIwodySSt+6sf6ewhm5nJ6rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734612273; c=relaxed/simple;
	bh=PxHuyoleux1MDN/YLFClHsS+bwZTORbbOcRZxaY/tEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fmnH9joj0sHpAW6lC0+/EV226hDb+Awq2XNmCzkFmYohTNV/tQZEdzYc/gpCHaaBGujrFRp6znaZuFyPlGd3godNs0XWa2zebo1GFcRvnvZZgv8IYg+xyGbdAv/2UMotqVKwN+Uc1I+daZAzQIGo2L6awRuzsJIHEBNEcb9Wczs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I4IdH9l7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734612270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZG/jfeN6c7v9IK49GXsc5lkOVD/BwL8H9nvYiDoxjj0=;
	b=I4IdH9l7ziABLSUdlJ0djjVeZy8UbEeqWxpBhKHLakPORIQt3jgXEr7OQrcEoy/hO1L3OH
	V8O8dvps2sdIalC2IJZCKWibsxD9qzkpKDEiu2IeOCy8INWt3m2F/VD798BPipkAWP0YO6
	Boh68XmqvWxqeDPIIUsESbgSBrhOuyw=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-524-88JYdQMaMcWHERAvb_p9UQ-1; Thu,
 19 Dec 2024 07:44:29 -0500
X-MC-Unique: 88JYdQMaMcWHERAvb_p9UQ-1
X-Mimecast-MFC-AGG-ID: 88JYdQMaMcWHERAvb_p9UQ
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1311419560BA;
	Thu, 19 Dec 2024 12:44:28 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6B0D419560A2;
	Thu, 19 Dec 2024 12:44:27 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com
Subject: [PATCH] KVM: x86: let it be known that ignore_msrs is a bad idea
Date: Thu, 19 Dec 2024 07:44:26 -0500
Message-ID: <20241219124426.325747-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

When running KVM with ignore_msrs=1 and report_ignored_msrs=0, the user has
no clue that that the guest is being lied to.  This may cause bug reports
such as https://gitlab.com/qemu-project/qemu/-/issues/2571, where enabling
a CPUID bit in QEMU caused Linux guests to try reading MSR_CU_DEF_ERR; and
being lied about the existence of MSR_CU_DEF_ERR caused the guest to assume
other things about the local APIC which were not true:

  Sep 14 12:02:53 kernel: mce: [Firmware Bug]: Your BIOS is not setting up LVT offset 0x2 for deferred error IRQs correctly.
  Sep 14 12:02:53 kernel: unchecked MSR access error: RDMSR from 0x852 at rIP: 0xffffffffb548ffa7 (native_read_msr+0x7/0x40)
  Sep 14 12:02:53 kernel: Call Trace:
  ...
  Sep 14 12:02:53 kernel:  native_apic_msr_read+0x20/0x30
  Sep 14 12:02:53 kernel:  setup_APIC_eilvt+0x47/0x110
  Sep 14 12:02:53 kernel:  mce_amd_feature_init+0x485/0x4e0
  ...
  Sep 14 12:02:53 kernel: [Firmware Bug]: cpu 0, try to use APIC520 (LVT offset 2) for vector 0xf4, but the register is already in use for vector 0x0 on this cpu

Without reported_ignored_msrs=0 at least the host kernel log will contain
enough information to avoid going on a wild goose chase.  But if reports
about individual MSR accesses are being silenced too, at least complain
loudly the first time a VM is started.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c8160baf3838..1b7c8db0cf63 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12724,6 +12724,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_hv_init_vm(kvm);
 	kvm_xen_init_vm(kvm);
 
+	if (ignore_msrs && !report_ignored_msrs) {
+		pr_warn_once("Running KVM with ignore_msrs=1 and report_ignored_msrs=0 is not a\n");
+		pr_warn_once("a supported configuration.  Lying to the guest about the existence of MSRs\n");
+		pr_warn_once("may cause the guest operating system to hang or produce errors.  If a guest\n");
+		pr_warn_once("does not run without ignore_msrs=1, please report it to kvm@vger.kernel.org.\n");
+	}
+
 	return 0;
 
 out_uninit_mmu:
-- 
2.43.5


