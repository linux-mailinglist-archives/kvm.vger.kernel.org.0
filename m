Return-Path: <kvm+bounces-26612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EF596976156
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 08:19:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F9981F24272
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 06:19:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76AF718BC19;
	Thu, 12 Sep 2024 06:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OcY9LYFr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA02B1898FF
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 06:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726121938; cv=none; b=FpPRx3CrdP3aLHOBAD32jvJ27KCeVmbNCa4fkP2L6mLKtR/X6me2kGkt1oY7QMNLjeN7VjS/YLwD3DigtJUgW9qKcErUnPSFCs+q+/sqEJU3dtC9Ck9WnSBNqcDvvRgRKPLYKjQ3El7FjNhFAKNfYpBeEEI/py5uMvbD8pY3nHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726121938; c=relaxed/simple;
	bh=xcslnuCERcjC9lwAVTu/CHoCINHS52P3Je/mcZC++MY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KIJ5xTEZXIkx8ORcIWGc9cyKzJ0i6EL1uil9xVLMBG20DxMMzybm+BP041QgLMNMuCeHuL61n2ZPT/jxQZyFebCRM0/ol1o8MjdzK9MUd2+IZY2mu8Gx7dhREoQ2KeMA0YeRHPUav8ObyGsOrDHH0dV05B1/ZcM53DA0fOxFdVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OcY9LYFr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726121935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qdljBIE1wnO1o1WeSrRcjuRU9723daTDWmWRls2lHV8=;
	b=OcY9LYFrvHI+igAE65afB9L+YpdAM1Pz4qmdSHNYRlzkYlttAOjcRQvW9FxHAkX61fTfdO
	fVFTWdW5LLTjEQ2dXdY9A9P83DY0gYmXtx8vG2ZpdiNBuqS9wygbjeiaO6m/RRQ/A5tMAf
	p7zhGmq/gvZm5r12oMeoyAjrIMPARfc=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-a_lD_b96Oz6x2Prhxwg5Hg-1; Thu, 12 Sep 2024 02:18:53 -0400
X-MC-Unique: a_lD_b96Oz6x2Prhxwg5Hg-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-206f9b1bc52so8234525ad.0
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 23:18:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726121933; x=1726726733;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qdljBIE1wnO1o1WeSrRcjuRU9723daTDWmWRls2lHV8=;
        b=IzPw4eCRgaE83zI+hpNHVIIKSbtK78eJcNMK30YBwxwxZpNvOiI7o8lghEdTE7YMGR
         nacKUSCyinE0T0Z2gJ6qfaYyclovnx0DNaEAYejKSjrD+cn3kabJiR5RUMHGz5iE3X2o
         +TnZ8FsERfUw+91EzWBqgelSFMqjFVqYEuPLKReb+c8PclVBYIAcux5yJG4v1IXp1AA1
         38yT2DZbOpOb6+o5hx4RIGpjkQ3RwBLupbihCCexSmNBN76a6g4ZGn459e3HXE83XUTr
         YmAd9DzLvilKcJAW1tI5RCYV4u8MZ/jJfCvLJ6AcGD3DcFBKmhcyubBg2BgUzkmqOlIF
         SHgA==
X-Forwarded-Encrypted: i=1; AJvYcCUVsdfVFk2g8YUHjg4HhV93iCXCe64Rr0vBYHrFRs3XF2f64kj6fZwaPW9hSmbm6QlE7rg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpdEaH9+JMp5u0fP5tslC9m38IzUCglyqQY1J1q3TK4+aZKYay
	KpLx+CqZctvtd8S7n3qGoC7B8BFBzEEpJzBCQwJEXvk3gKpFGUG6azjjG4j2diYc4PitwRLiRg5
	sXgfa4PoaXyfnzoOFzLtpEa0GAPR0BIHLnSoDA1Pn834wFWos0Q==
X-Received: by 2002:a17:902:e852:b0:202:49e:6a35 with SMTP id d9443c01a7336-2076e33e935mr28065045ad.19.1726121932618;
        Wed, 11 Sep 2024 23:18:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHKzhzW+CekLd+GsI4x5ghgEvoYSLHVyPmx+X/rUn7ap1rlRZgslul0eln4r/hrDoSF6i6SjA==
X-Received: by 2002:a17:902:e852:b0:202:49e:6a35 with SMTP id d9443c01a7336-2076e33e935mr28064685ad.19.1726121932116;
        Wed, 11 Sep 2024 23:18:52 -0700 (PDT)
Received: from localhost.localdomain ([115.96.132.12])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2076af49af0sm8420995ad.107.2024.09.11.23.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 23:18:51 -0700 (PDT)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH] accel/kvm: refactor dirty ring setup
Date: Thu, 12 Sep 2024 11:48:38 +0530
Message-ID: <20240912061838.4501-1-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor setting up of dirty ring code in kvm_init() so that is can be
reused in the future patchsets.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c | 88 +++++++++++++++++++++++++--------------------
 1 file changed, 50 insertions(+), 38 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 75d11a07b2..92f954ecfb 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2385,6 +2385,55 @@ uint32_t kvm_dirty_ring_size(void)
     return kvm_state->kvm_dirty_ring_size;
 }
 
+static int kvm_setup_dirty_ring(KVMState *s)
+{
+    uint64_t dirty_log_manual_caps;
+    int ret;
+
+    /*
+     * Enable KVM dirty ring if supported, otherwise fall back to
+     * dirty logging mode
+     */
+    ret = kvm_dirty_ring_init(s);
+    if (ret < 0) {
+        return ret;
+    }
+
+    /*
+     * KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 is not needed when dirty ring is
+     * enabled.  More importantly, KVM_DIRTY_LOG_INITIALLY_SET will assume no
+     * page is wr-protected initially, which is against how kvm dirty ring is
+     * usage - kvm dirty ring requires all pages are wr-protected at the very
+     * beginning.  Enabling this feature for dirty ring causes data corruption.
+     *
+     * TODO: Without KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 and kvm clear dirty log,
+     * we may expect a higher stall time when starting the migration.  In the
+     * future we can enable KVM_CLEAR_DIRTY_LOG to work with dirty ring too:
+     * instead of clearing dirty bit, it can be a way to explicitly wr-protect
+     * guest pages.
+     */
+    if (!s->kvm_dirty_ring_size) {
+        dirty_log_manual_caps =
+            kvm_check_extension(s, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
+        dirty_log_manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
+                                  KVM_DIRTY_LOG_INITIALLY_SET);
+        s->manual_dirty_log_protect = dirty_log_manual_caps;
+        if (dirty_log_manual_caps) {
+            ret = kvm_vm_enable_cap(s, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, 0,
+                                    dirty_log_manual_caps);
+            if (ret) {
+                warn_report("Trying to enable capability %"PRIu64" of "
+                            "KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 but failed. "
+                            "Falling back to the legacy mode. ",
+                            dirty_log_manual_caps);
+                s->manual_dirty_log_protect = 0;
+            }
+        }
+    }
+
+    return 0;
+}
+
 static int kvm_init(MachineState *ms)
 {
     MachineClass *mc = MACHINE_GET_CLASS(ms);
@@ -2404,7 +2453,6 @@ static int kvm_init(MachineState *ms)
     const KVMCapabilityInfo *missing_cap;
     int ret;
     int type;
-    uint64_t dirty_log_manual_caps;
 
     qemu_mutex_init(&kml_slots_lock);
 
@@ -2551,47 +2599,11 @@ static int kvm_init(MachineState *ms)
     s->coalesced_pio = s->coalesced_mmio &&
                        kvm_check_extension(s, KVM_CAP_COALESCED_PIO);
 
-    /*
-     * Enable KVM dirty ring if supported, otherwise fall back to
-     * dirty logging mode
-     */
-    ret = kvm_dirty_ring_init(s);
+    ret = kvm_setup_dirty_ring(s);
     if (ret < 0) {
         goto err;
     }
 
-    /*
-     * KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 is not needed when dirty ring is
-     * enabled.  More importantly, KVM_DIRTY_LOG_INITIALLY_SET will assume no
-     * page is wr-protected initially, which is against how kvm dirty ring is
-     * usage - kvm dirty ring requires all pages are wr-protected at the very
-     * beginning.  Enabling this feature for dirty ring causes data corruption.
-     *
-     * TODO: Without KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 and kvm clear dirty log,
-     * we may expect a higher stall time when starting the migration.  In the
-     * future we can enable KVM_CLEAR_DIRTY_LOG to work with dirty ring too:
-     * instead of clearing dirty bit, it can be a way to explicitly wr-protect
-     * guest pages.
-     */
-    if (!s->kvm_dirty_ring_size) {
-        dirty_log_manual_caps =
-            kvm_check_extension(s, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
-        dirty_log_manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
-                                  KVM_DIRTY_LOG_INITIALLY_SET);
-        s->manual_dirty_log_protect = dirty_log_manual_caps;
-        if (dirty_log_manual_caps) {
-            ret = kvm_vm_enable_cap(s, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, 0,
-                                    dirty_log_manual_caps);
-            if (ret) {
-                warn_report("Trying to enable capability %"PRIu64" of "
-                            "KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 but failed. "
-                            "Falling back to the legacy mode. ",
-                            dirty_log_manual_caps);
-                s->manual_dirty_log_protect = 0;
-            }
-        }
-    }
-
 #ifdef KVM_CAP_VCPU_EVENTS
     s->vcpu_events = kvm_check_extension(s, KVM_CAP_VCPU_EVENTS);
 #endif
-- 
2.42.0


