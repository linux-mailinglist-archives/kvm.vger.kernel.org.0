Return-Path: <kvm+bounces-25744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D8CF2969FAA
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 16:01:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E3D51F2498C
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 14:01:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 575ED28399;
	Tue,  3 Sep 2024 14:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jr6/W2qX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030891CA6A1
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 14:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725372068; cv=none; b=FYvLGcKJ3evAgR+8XiGi20MtwpRu89bDBFmNWq2XAEDZbjj+JHhjpPgbXSTB9hQcncywN8fRC9hkaf+vUf7MchjZK3f17x+OvKtdUy6DFgRWlJMvnrgl0Npvdt09EoaU+JA5fJppMm3LX4xqBz38FUOGgmMPkhZEJgSEPYirkL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725372068; c=relaxed/simple;
	bh=Xn3iLAMrdo3OxG1kOWoSpieYlIqJ2fZv+NwbNkfYGpk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IB6WFYtXUMBBhjPgbYb6ss5Unsm6e5YibYWDVj92qA/SeDqT5DDt8quKpIv6sLKf9levQfeasmCYqA/LUtQzyYvjFhpfBBrOeOAvsD9bcaLcBZ98hHhyglZs9q7Qyx5pbDAY2Rd9S2dv0DqUQVTTVtgaw5irSqweeAPWN+vUpFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jr6/W2qX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725372066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jjhSCJBJuSAurBQThL2GuR+Yd4wjnt/EI+Br8d8wwkM=;
	b=Jr6/W2qX4rymMx7wZrb3Na9edPKX8EYY1gYV+VfSkcpARvsmc2wsOiuMphtjQKGk8JQmDI
	GSPLh9UKy6CuhncuGYvOxEW+1BAvoAdT5LpWtYQdRlImdwxdkhwYPG0iAaljU9xS/SN5Ph
	eHJOGVZqos9ysG4esHerAsN63ptLgL0=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-VSQi5OkENA6HkaydK98jTw-1; Tue, 03 Sep 2024 10:01:05 -0400
X-MC-Unique: VSQi5OkENA6HkaydK98jTw-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-20383bf72easo48317935ad.3
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 07:01:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725372057; x=1725976857;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jjhSCJBJuSAurBQThL2GuR+Yd4wjnt/EI+Br8d8wwkM=;
        b=H1tFQRJ+GXGhhcHZloYWu4s3BHtFrhpP/VjkfRsRZacoxnVOWmRpbwff1yq0g1MbfI
         VXVx5kEPMvU+hfdylIb+BUW3Re/MQbzWRpvIXONpyUwVBInz25DGFzbemeoE6U8mjc2w
         AjDF/NR7gidJYvFnGj5D4ikDb6RiGEibnIY1EVMbLBcWZMSOducc5oc9uYiF3mHWc7SQ
         mvRuKf0P57LnaZo4W98mribJDxIoSrAKIALBGnXtBHXpn8uiv3ltZeSn+r0mWctk+qxL
         O+Upb8L5cV4OZz01zFWcBNL0tQ81NrMGRkdfHj4GlujmlrMKdAfELXOqYnZ71apwiODg
         puAw==
X-Forwarded-Encrypted: i=1; AJvYcCWBl7zDVsYQZpZ36moBNl6ATL5k4xf7l89spaKt+BZrI0ZkvBUCf1KtCzFDqMmBY//f3CU=@vger.kernel.org
X-Gm-Message-State: AOJu0YziKX9H3lj8kfLgXQMWfFmCzsO+4jNqLO7qF0McfJn9tB8/CZ4O
	CwPvxHVBLGIkj0l3Ju1z/ySONbziZRLA/ZP49AChlL5vZDDYC+pjN5LaQgcaJO13WQNj1kKq4+v
	AF1efTPCm9khVAc2tGnNvYQKvdO/NR+NAn0cxSaQMWBtQykt8Jg==
X-Received: by 2002:a17:902:f786:b0:203:a02c:992b with SMTP id d9443c01a7336-2054bc96937mr79291735ad.3.1725372055365;
        Tue, 03 Sep 2024 07:00:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IESt9Cl068xl1wlir0hWjmhG+W99U/WXJNrsXvb0csaMwc4arZlnKCEMz2eall7CtqN3IZy9Q==
X-Received: by 2002:a17:902:f786:b0:203:a02c:992b with SMTP id d9443c01a7336-2054bc96937mr79291325ad.3.1725372054841;
        Tue, 03 Sep 2024 07:00:54 -0700 (PDT)
Received: from localhost.localdomain ([115.96.207.26])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2057554f328sm32900445ad.266.2024.09.03.07.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 07:00:54 -0700 (PDT)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	philmd@linaro.org,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3] kvm/i386: make kvm_filter_msr() and related definitions private to kvm module
Date: Tue,  3 Sep 2024 19:30:45 +0530
Message-ID: <20240903140045.41167-1-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

kvm_filer_msr() is only used from i386 kvm module. Make it static so that its
easy for developers to understand that its not used anywhere else.
Same for QEMURDMSRHandler, QEMUWRMSRHandler and KVMMSRHandlers definitions.

CC: philmd@linaro.org
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c      | 12 +++++++++++-
 target/i386/kvm/kvm_i386.h | 11 -----------
 2 files changed, 11 insertions(+), 12 deletions(-)

changelog:
v2: make QEMURDMSRHandler, QEMUWRMSRHandler and KVMMSRHandlers private
to kvm.c
v3: typo fix. tags added.

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 2fa88ef1e3..d714f54ee4 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -92,7 +92,17 @@
  * 255 kvm_msr_entry structs */
 #define MSR_BUF_SIZE 4096
 
+typedef bool QEMURDMSRHandler(X86CPU *cpu, uint32_t msr, uint64_t *val);
+typedef bool QEMUWRMSRHandler(X86CPU *cpu, uint32_t msr, uint64_t val);
+typedef struct kvm_msr_handlers {
+    uint32_t msr;
+    QEMURDMSRHandler *rdmsr;
+    QEMUWRMSRHandler *wrmsr;
+} KVMMSRHandlers;
+
 static void kvm_init_msrs(X86CPU *cpu);
+static bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
+                           QEMUWRMSRHandler *wrmsr);
 
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_INFO(SET_TSS_ADDR),
@@ -5728,7 +5738,7 @@ static bool kvm_install_msr_filters(KVMState *s)
     return true;
 }
 
-bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
+static bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
                     QEMUWRMSRHandler *wrmsr)
 {
     int i;
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 34fc60774b..9de9c0d303 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -66,17 +66,6 @@ uint64_t kvm_swizzle_msi_ext_dest_id(uint64_t address);
 void kvm_update_msi_routes_all(void *private, bool global,
                                uint32_t index, uint32_t mask);
 
-typedef bool QEMURDMSRHandler(X86CPU *cpu, uint32_t msr, uint64_t *val);
-typedef bool QEMUWRMSRHandler(X86CPU *cpu, uint32_t msr, uint64_t val);
-typedef struct kvm_msr_handlers {
-    uint32_t msr;
-    QEMURDMSRHandler *rdmsr;
-    QEMUWRMSRHandler *wrmsr;
-} KVMMSRHandlers;
-
-bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
-                    QEMUWRMSRHandler *wrmsr);
-
 #endif /* CONFIG_KVM */
 
 void kvm_pc_setup_irq_routing(bool pci_enabled);
-- 
2.42.0


