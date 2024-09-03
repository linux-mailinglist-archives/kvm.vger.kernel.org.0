Return-Path: <kvm+bounces-25708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 40BEE969425
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 08:50:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F26B1C211C0
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 06:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85BCC1D6185;
	Tue,  3 Sep 2024 06:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PyDoxqCZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45A11D54D3
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 06:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725346221; cv=none; b=FNsA1YDM/1BibGVFfi/r14cJW/qdJxqX8Zbrgqs5SzU8wY+PhKitAiYETgXLajHgArueZrOZ6IWIi51nOXHTOmu3iYoE1Y1wIm8Vj0K1Qd5uPqLWGNB84el3TWuHWbT0zuwXTxIU5SvwZXYXAZUi+wkrKEpbbMFMQJfcJOyHobY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725346221; c=relaxed/simple;
	bh=jYinUL/FZw1P2EJgOysjIPl1pErKNw9GS9JCR+xVAmk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YJoH/z/sHU/rzZSdedl0xfwDXoZoQ9XRyOUrJ8gSAR1GD5Q4s7/zRM6oaVW9vAAQZW6DNyjR8xMaCcBhsi973EVXqoZOQuswqe45Wm8uA4+iBfZWonKR4m/vfKmIMBJyDddJvUGZvF+EzYOVjah4ZbcdRRcnkNZphv08Jwn6P18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PyDoxqCZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725346218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MHqs+YS6/b7STpoCXDmibaNhuPWk00ztD0j0/H40oIk=;
	b=PyDoxqCZ0Zopt+YqXeAiQ8rG8PNuQgCJF/cITiGm2FXvo59kKJQSpGE9q8b/LxZf510xZ3
	b7yd98F6bf6RUnJ3DgGtjnStM5DBJ9bg+0nysCRX/sgFlBxIO4ZAnMEQbBQF2TwFG88pjc
	dP5+ARbj1W+dOM4rtIldeWhryrC4F8A=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-iDCkB0ZOPYCGDqWot-onAA-1; Tue, 03 Sep 2024 02:50:17 -0400
X-MC-Unique: iDCkB0ZOPYCGDqWot-onAA-1
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-70f64d8fe54so4789390a34.0
        for <kvm@vger.kernel.org>; Mon, 02 Sep 2024 23:50:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725346216; x=1725951016;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MHqs+YS6/b7STpoCXDmibaNhuPWk00ztD0j0/H40oIk=;
        b=sKcbMKIHaz1ZcQMqchk4K+j0MjVPvNKFtGMPbP4hlSSIZ8tx7ff1p1zTheZmiIuUHb
         6vPzhKzu6TR1VBj/jAGTG9Yxra2dRX2lCAOZw/JPgf4UXF+B1afBJBG5qLwULlOMQZPy
         n89NIr0r11HhPpQc/zGUvwVx2aaSDjRSxbgl0IgC4S1ljzebzS5stWXWQXo2KQucchT+
         J6SC7wdMKzHwwAEw02Ri7yiIBwCdrsk9sV2e8pi0Nks2Mem7HNiMXaN08nAremG+6ZRY
         MpfWeBdb7BDEWS6jvY1L0WCkEf38htuvmQroYXGKe8ajF8ZOxedAZH4SzGPdfEdnfUke
         w5fA==
X-Forwarded-Encrypted: i=1; AJvYcCU9Rc0nUvCfaSRzhsb8HUdBAApxLM5zGRcpOZ+QlBwkDhzdzs2LwWwSPSN8lpEFno8Yvs0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKlPp+v46zRU8nHbpcjCcUOdPppviaVj+8iB5g5y8BRTFB5jy3
	gHpa5lhnCRXPpO5g9FPlkRRl0+m8qgB8iEi8Hwr1qa4jSpRWMdv1sHpRIq1J5Boij0df4JmUf/v
	ZPPYC17GSGzUkF0QNsyf5KDmph2ijocCfnMNu565/uLLNDT3PNA==
X-Received: by 2002:a05:6358:9044:b0:1ac:f7ac:e302 with SMTP id e5c5f4694b2df-1b603c40028mr1925506755d.18.1725346216646;
        Mon, 02 Sep 2024 23:50:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDtYxMXLuRJDtY5csiopW6kPGbzvKgGHPu7MUMQjm/EhG9u+Eyv7nvtPc8zH+3RhnngMO0RQ==
X-Received: by 2002:a05:6358:9044:b0:1ac:f7ac:e302 with SMTP id e5c5f4694b2df-1b603c40028mr1925505455d.18.1725346216333;
        Mon, 02 Sep 2024 23:50:16 -0700 (PDT)
Received: from localhost.localdomain ([115.96.207.26])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-715e55771f3sm8098617b3a.12.2024.09.02.23.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 23:50:15 -0700 (PDT)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH] kvm/i386: declare kvm_filter_msr() static
Date: Tue,  3 Sep 2024 12:20:07 +0530
Message-ID: <20240903065007.31522-1-anisinha@redhat.com>
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

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c      | 4 +++-
 target/i386/kvm/kvm_i386.h | 3 ---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 2fa88ef1e3..11c7619bfd 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -93,6 +93,8 @@
 #define MSR_BUF_SIZE 4096
 
 static void kvm_init_msrs(X86CPU *cpu);
+static bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
+                           QEMUWRMSRHandler *wrmsr);
 
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_INFO(SET_TSS_ADDR),
@@ -5728,7 +5730,7 @@ static bool kvm_install_msr_filters(KVMState *s)
     return true;
 }
 
-bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
+static bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
                     QEMUWRMSRHandler *wrmsr)
 {
     int i;
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 34fc60774b..26d7c57512 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -74,9 +74,6 @@ typedef struct kvm_msr_handlers {
     QEMUWRMSRHandler *wrmsr;
 } KVMMSRHandlers;
 
-bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
-                    QEMUWRMSRHandler *wrmsr);
-
 #endif /* CONFIG_KVM */
 
 void kvm_pc_setup_irq_routing(bool pci_enabled);
-- 
2.42.0


