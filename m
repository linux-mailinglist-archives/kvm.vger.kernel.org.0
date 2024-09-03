Return-Path: <kvm+bounces-25741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BDFA969F50
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:45:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 144FD1F245CA
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 13:45:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0927D8C1E;
	Tue,  3 Sep 2024 13:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jNIObRT/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A225763D5
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 13:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725371100; cv=none; b=BycacdV+6qyFM3IhvqwhQqDOnBFUDygwr41pdHzn1uJGm0ynu2x58fuwYwve+Iha7HZ8TpGvOf3p2N7QMKKTgYzVXUVX8YioM2nraKADJY5Z6sMoH1kp+6eA6N46fi11eVnxzQyhcCAusjkMgFqF44DfIIS6V3HVOIh/wat36+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725371100; c=relaxed/simple;
	bh=7SNbJIJpw9pMjr+o9Jq79ZQ3lyuy8TfRugReSB+Nzw4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tijLkCrmMQvRdemT3cM45Vvinib7uD9gWl/e3rMpmcxIqkkFwKEcRGPF1noK5kKmVFtFj8z5LaZV1dCdlkIZXa3MHz2ZTvk3LxZMB7M0TIrVG1X9lUAue3k3kZyrcXnWnLnRoBLecCo9dnk75YEgOnv90x0z7EHO+pPQPrAdCfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jNIObRT/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725371097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=51dTN7MmTiEpTD17LoLSRBqs9+ZPE1zu8h5Dd7a9Uh4=;
	b=jNIObRT/1BXb41PbAEr2g0gvZ7Qr/i056ck6j8xtDLBu/1rnL2t4vntZOyb5k/p7Zn2JJM
	Dt15C2jZPVihDRFIUmDnpKf+9CxfoPTXzV6Kg9PR4Lj2w134EzHe73H/+UY7yzj2qh3GxQ
	F3DIol6JyOQYwgB8LvtHuOj2kOkEUXk=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-KKsB3wwpOdiQspEapVTMZg-1; Tue, 03 Sep 2024 09:44:56 -0400
X-MC-Unique: KKsB3wwpOdiQspEapVTMZg-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-20536fb5af5so44280815ad.1
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 06:44:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725371095; x=1725975895;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=51dTN7MmTiEpTD17LoLSRBqs9+ZPE1zu8h5Dd7a9Uh4=;
        b=YVTV6iyDafDP9z/g7epoEnkvd6Wk0fVBsaJLDsfJRxBiW1zHPpfv4gt++/2GeX7CQF
         GYLynGsNDzhpiZZDCAiPKuhX4dzB1OQz6y2xX8rl1Tj+G26MJsGLPQ88RLsnOJFCk28Y
         m/WRnSnlIBtHaYqi7oZTygNhwZoe7ylE1F0c6Ca9CHSShoeyMlDGv5sD8mfdHiRxDJ5G
         mdgS87tu0qFXBCZIdzbMw5Ni0GXWaZxdXx0vJB+9OnMw341iMb5K7TGOC/VlIYBTxIfh
         Jo6NO9f7220kHg2P71S754XoX3aWFhiW79Xs3decIFYC4QDIjqrAutZHOYBYH5tyKoVY
         8EqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrv8q+ALKlyAm2XhQ26rvIvzsCkBW26RatwfeW4/tNe4C/RnhvI9ECNeiAj5fdoQ2qgHs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu8zR8HHHx97KnXhEKgJ4LhUM39TJPDXDUiQcxKLztYVhPYGVT
	NEYms+U2Evjuw87Ex3tgfZu9zFy0f7liWaQoN7didevNW11OZuQ9AQ/IVOjZ9ftUTkaAuuVET4M
	I3gw3mnR6Qt6Km3ko4C0WUXn0043WRtBOF5z84WBL9ip+q4dWPA==
X-Received: by 2002:a17:902:dacb:b0:205:5136:b2fb with SMTP id d9443c01a7336-205841a4376mr63797785ad.23.1725371095174;
        Tue, 03 Sep 2024 06:44:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHkgI5zV7G/OfX9mZdLAgTTnOsa1DlSYl0W1zMp7fZyMcYyBFePdiPohhZh6ka7KNNAEWdSZA==
X-Received: by 2002:a17:902:dacb:b0:205:5136:b2fb with SMTP id d9443c01a7336-205841a4376mr63797535ad.23.1725371094763;
        Tue, 03 Sep 2024 06:44:54 -0700 (PDT)
Received: from localhost.localdomain ([115.96.207.26])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2051554407bsm81030575ad.217.2024.09.03.06.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 06:44:54 -0700 (PDT)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	philmd@linaro.org,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2] kvm/i386: make kvm_filter_msr() and related definitions private to kvm module
Date: Tue,  3 Sep 2024 19:14:41 +0530
Message-ID: <20240903134441.40549-1-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_filer_msr() is only used from i386 kvm module. Make it static so that its
easy for developers to understand that its not used anywhere else.
Same for QEMURDMSRHandler, QEMUWRMSRHandler and KVMMSRHandlers defintions.

CC: philmd@linaro.org
Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c      | 12 +++++++++++-
 target/i386/kvm/kvm_i386.h | 11 -----------
 2 files changed, 11 insertions(+), 12 deletions(-)

changelog:
v2: make QEMURDMSRHandler, QEMUWRMSRHandler and KVMMSRHandlers private
to kvm.c

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


