Return-Path: <kvm+bounces-34297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4196E9FA728
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 18:11:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E14C87A1C95
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 17:11:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6F0A191493;
	Sun, 22 Dec 2024 17:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="czS88L20"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D121F185B4C
	for <kvm@vger.kernel.org>; Sun, 22 Dec 2024 17:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734887232; cv=none; b=m6pdKdD8GUCjVTbWyNnTIcoseL8irIz48jtFGdtqPpzYTFj8GOoVdhFynMeZfgOX7L3d8tocp191p+UJrqz0lfvUoutlFAfx255HJvQ7NYGJBTPXqBmxqEN8eL6pTJ+bbTMSa5fNoMdyEnmy0EE/r4p5bzyFzytUv5fAFKaFJO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734887232; c=relaxed/simple;
	bh=IQ4+JSDMinTy+psTjBLDEErWCRdCZfAmVg/qfbOHaVY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oqe5dH2a2A5p4uEAJ+p5tdc/BedRGD3EyvExGtijLsA96umtV1ATphtyqXHlQkC4pzSY5V0YhvY1EiprmCC2Gy6mbyd9UPAe0pDEpBoFEnCQeEeFdm+NHpeUJznl8NdokWIS1nERhm1YK9nofHY3s6e6i2zZQQ6wQq5wzDkC5p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=czS88L20; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734887229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=y+R7BjqhyjEJzqinMfiFvEJo2vYtdPLc/QEalTKd9X4=;
	b=czS88L20A5HuckJMexQ/PK/9tTDdeIeX8ycm/sTKm/1LsuYODtg0rGD/7LcVflTRRLQqKO
	+9Qu/4jo+On8qSPX9oobtfgnSo3vPhbsqBmNFP2KsPo4VfJC0I2x/CYc+ITEsmrCZrGzTj
	jRDWfosAPCj/EaaLaOSWgrFxYTjcGKE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-333-359qiiwqPE-28EftS7u0Kg-1; Sun,
 22 Dec 2024 12:07:06 -0500
X-MC-Unique: 359qiiwqPE-28EftS7u0Kg-1
X-Mimecast-MFC-AGG-ID: 359qiiwqPE-28EftS7u0Kg
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DBC8619560A2;
	Sun, 22 Dec 2024 17:07:05 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5B45319560A3;
	Sun, 22 Dec 2024 17:07:05 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v2] KVM: x86: let it be known that ignore_msrs is a bad idea
Date: Sun, 22 Dec 2024 12:07:04 -0500
Message-ID: <20241222170704.331776-1-pbonzini@redhat.com>
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
index c8160baf3838..12fa68a06966 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12724,6 +12724,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_hv_init_vm(kvm);
 	kvm_xen_init_vm(kvm);
 
+	if (ignore_msrs && !report_ignored_msrs) {
+		pr_warn_once("Running KVM with ignore_msrs=1 and report_ignored_msrs=0 is not a\n"
+			     "a supported configuration.  Lying to the guest about the existence of MSRs\n"
+			     "may cause the guest operating system to hang or produce errors.  If a guest\n"
+			     "does not run without ignore_msrs=1, please report it to kvm@vger.kernel.org.\n");
+	}
+
 	return 0;
 
 out_uninit_mmu:
-- 
2.43.5


