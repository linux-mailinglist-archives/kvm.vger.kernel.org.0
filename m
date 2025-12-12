Return-Path: <kvm+bounces-65843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D5A5CB9119
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:12:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 362DE306450E
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16ACA322DD0;
	Fri, 12 Dec 2025 15:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PcNHY/zb";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PyGln4R4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4B631770E
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765551947; cv=none; b=gDdbuy8hBP9OPCrR/uRK+NyQfYT7H276h6b9rdN8VOPtNFEDRFmA9uYkTQXGNLMPuQB+YT0bmKKCl298Hd+eJ4mJo9P47Jh5AG/mYdBaL4aYvo1cAxpihRf1tPIKjZ+HYpB+bVdnTY4cYSo2ucgQMYdUEnYfONgcgyiyjfggYmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765551947; c=relaxed/simple;
	bh=VLYmcnrjii18A+RizNwWciDpF+CviB1+2bqPZBOvEwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fw/5riwNBzxbw4frEl874Odl7MfPhaxe+tEcjkjH6xZID0OOgj66OEG6rhEdaRAccEPCBUokbTmiP70DdhNcaozjcZSVGYRc8r+L6t4KalmPSXf9Rx5icyyIXL3E/f7BQVMoTQ1LKQJCKus+9Fcj28enbrVWVAsXs1q4neFT/nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PcNHY/zb; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PyGln4R4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765551937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tMdRfFGcpxCcqNkq2TVSVJsE/ZLQul0p4ArTaq9CGns=;
	b=PcNHY/zbQUe3tV4xOyXb3HY3oCB0L7bE0j4wCwgHNHfCO5E6N0hZWl1isYvqky1y3H7+H7
	fP+L/a5zdVMYOSPqPyZkjlFbiYs8TnKYyKHk3GnHWGZ9TJQVUl0l3JGlt9ebOrEwll5cQ1
	wlyQZFoZ7RAsFGehC1IIBP9yy5Nq9Ec=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-n4LMGVrRM4eRtn0_UoqPEA-1; Fri, 12 Dec 2025 10:05:36 -0500
X-MC-Unique: n4LMGVrRM4eRtn0_UoqPEA-1
X-Mimecast-MFC-AGG-ID: n4LMGVrRM4eRtn0_UoqPEA_1765551935
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-340bc4ef67fso1385360a91.3
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 07:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765551935; x=1766156735; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tMdRfFGcpxCcqNkq2TVSVJsE/ZLQul0p4ArTaq9CGns=;
        b=PyGln4R4nQrGWpjTcfPsWzzwTocAoAipsTq+t7mgfwzJSKUqXty8LZMkmR9OHMWDMh
         dRGsROpiikeWlVdyv6ig+zwY4GahBsvwfKXmHgdscaARdK7l7/57Ni+20YVhKbtO/Woj
         /8Dr29eLicNeN0dKEtm7xlDRqRyvhweRNnP+tDeS5cdB/Aku1uIhOdVBsFurFlrTJC1B
         At/f/J2NmdkiExYJxZtxvyBny4joq6GeS/KcVaiornSV8i3wg78rbQRBp1hij5nQUU2/
         Vie5Z+S8WKlCNteKc8XV1/gxp2QSkn5QN7WnOaixv3JAHFZDGnrLeriSKN1W0u1yoryh
         dLhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765551935; x=1766156735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tMdRfFGcpxCcqNkq2TVSVJsE/ZLQul0p4ArTaq9CGns=;
        b=sL9vBlrCtFX38Byy5EfQQ7crIiOHuP2ZbMd741x9A/p0D9ZPq0xONmCy2R2EXqblKj
         kWJoaUGl/ncmT2dmK+MJE7kioJ/cAin+Kq2w3gtK9a7vGK6+SKELZdSmE0Yvb+OsyH1H
         u1GgXwPw/Bg8/3WuSF8WQItrhnwt7X0jfpF/GC38ZXr8tkl5RDV4JOneiD+z7wzxP4Iy
         J1S4PHhLLlkHhfeg09mS/KjynNAX6p4WdvTJ+X/vnysHD6eEjfTgEwSDonw4Z+3PQNyc
         finoZ2m+prY98hFaID97lyS7yGSfdHyiMvLb8xFVMSTX3UYionRNuC/wdZKhnCXN45Xd
         yy5A==
X-Forwarded-Encrypted: i=1; AJvYcCULDe3N+rm73MJuqZhdL7eer3UkYpjXZS9AFjw3QBELp1Mj8apZNhEv+xPc2848eXB66UY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr0rALZDpB0flfaJZLtkoAYDJ7LBUTnRVRZMUzx+9nKZpfx8bq
	GPnhDeTDG9OQplGHsugPgsD8TfV6Jq2H2m0a5/WCSOYhuQ6fJHhtu0O7KSxVbhwoK/10YHRuYC0
	T7iptB/aYNdhLYukxZqPMBpcp6u2qV45WxzOzlMNs0Tb9EJP5PCZrdQ==
X-Gm-Gg: AY/fxX5krhD/3hh87K+MsR7DOc9Xz2m5E7+R/z23Cv1llEAShcP+BUMPPPXd01m5zSk
	vKhigIFIQWKtor/KVKjk3da7QpAB4gM9HAU/F7ajqohxTIQGcPvTeNhD6CiZR4DfFPCSe8MnNPO
	INP/gmPqtanyFD3FDUDdTeE/8g+6yvsq4xMWv+RN9ItIxNHjeMF1DvO/ey7ukLeyHgezrdOmNZd
	PMHPxUAtZkK+8y+man7sVh3DHgEYXikhqea6MH1Krg0uII3Og+cBUB1JyvnFM/0Sp1UPwxGD5O/
	dI+yYvJZyxZT6IoARZKkQDUoLbyl2FdytzKEOsbKAyhkim/VCRPfWhUIOlyPtzsx8Qjwtw0YmIg
	MzjLLXCsETWl+l8cHs8Lf5okES1GWk0KeNivyoBodH5k=
X-Received: by 2002:a17:903:acf:b0:294:fcae:826 with SMTP id d9443c01a7336-29f244d24c1mr23437835ad.59.1765551934978;
        Fri, 12 Dec 2025 07:05:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGedReOhIbFJBin/uwXKIliBnvQTpJto3XxixePrYDFlN9AlFUFlcGPxEcKxB7IBSK0yyzltA==
X-Received: by 2002:a17:903:acf:b0:294:fcae:826 with SMTP id d9443c01a7336-29f244d24c1mr23437305ad.59.1765551934309;
        Fri, 12 Dec 2025 07:05:34 -0800 (PST)
Received: from rhel9-box.lan ([122.172.173.62])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29ee9d38ad1sm57046655ad.29.2025.12.12.07.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 07:05:34 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Cc: vkuznets@redhat.com,
	kraxel@redhat.com,
	qemu-devel@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH v1 22/28] accel/kvm: add a per-confidential class callback to unlock guest state
Date: Fri, 12 Dec 2025 20:33:50 +0530
Message-ID: <20251212150359.548787-23-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20251212150359.548787-1-anisinha@redhat.com>
References: <20251212150359.548787-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As a part of the confidential guest reset process, the existing encrypted guest
state must be made mutable since it would be discarded after reset. A new
encrypted and locked guest state must be established after the reset. To this
end, a new callback per confidential guest support class (eg, tdx or sev-snp)
is added that will indicate whether its possible to rebuild guest state:

bool (*can_rebuild_guest_state)(ConfidentialGuestSupport *cgs)

This api returns true if rebuilding guest state is possible,
false otherwise. A KVM based confidential guest reset is only possible when
the existing state is locked but its possible to rebuild guest state.
Otherwise, the guest is not resettable.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 include/system/confidential-guest-support.h | 27 +++++++++++++++++++++
 system/runstate.c                           | 11 +++++++--
 target/i386/kvm/tdx.c                       |  6 +++++
 target/i386/sev.c                           |  9 +++++++
 4 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/include/system/confidential-guest-support.h b/include/system/confidential-guest-support.h
index 0cc8b26e64..3c37227263 100644
--- a/include/system/confidential-guest-support.h
+++ b/include/system/confidential-guest-support.h
@@ -152,6 +152,11 @@ typedef struct ConfidentialGuestSupportClass {
      */
     int (*get_mem_map_entry)(int index, ConfidentialGuestMemoryMapEntry *entry,
                              Error **errp);
+
+    /*
+     * is it possible to rebuild the guest state?
+     */
+    bool (*can_rebuild_guest_state)(ConfidentialGuestSupport *cgs);
 } ConfidentialGuestSupportClass;
 
 static inline int confidential_guest_kvm_init(ConfidentialGuestSupport *cgs,
@@ -167,6 +172,28 @@ static inline int confidential_guest_kvm_init(ConfidentialGuestSupport *cgs,
     return 0;
 }
 
+static inline bool
+confidential_guest_can_rebuild_state(ConfidentialGuestSupport *cgs)
+{
+    ConfidentialGuestSupportClass *klass;
+
+    if (!cgs) {
+        /* non-confidential guests */
+        return true;
+    }
+
+    klass = CONFIDENTIAL_GUEST_SUPPORT_GET_CLASS(cgs);
+    if (klass->can_rebuild_guest_state) {
+        return klass->can_rebuild_guest_state(cgs);
+    }
+
+    /*
+     * by default, we should not be able to unprotect the
+     * confidential guest state
+     */
+    return false;
+}
+
 static inline int confidential_guest_kvm_reset(ConfidentialGuestSupport *cgs,
                                                Error **errp)
 {
diff --git a/system/runstate.c b/system/runstate.c
index f5e57fd1f7..fb878c2992 100644
--- a/system/runstate.c
+++ b/system/runstate.c
@@ -58,6 +58,7 @@
 #include "system/reset.h"
 #include "system/runstate.h"
 #include "system/runstate-action.h"
+#include "system/confidential-guest-support.h"
 #include "system/system.h"
 #include "system/tpm.h"
 #include "trace.h"
@@ -564,7 +565,12 @@ void qemu_system_reset(ShutdownCause reason)
     if (cpus_are_resettable()) {
         cpu_synchronize_all_post_reset();
     } else {
-        assert(runstate_check(RUN_STATE_PRELAUNCH));
+        /*
+         * for confidential guests, cpus are not resettable but their
+         * state can be rebuilt under some conditions.
+         */
+        assert(runstate_check(RUN_STATE_PRELAUNCH) ||
+               (current_machine->cgs && runstate_is_running()));
     }
 
     vm_set_suspended(false);
@@ -713,7 +719,8 @@ void qemu_system_reset_request(ShutdownCause reason)
     if (reboot_action == REBOOT_ACTION_SHUTDOWN &&
         reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
         shutdown_requested = reason;
-    } else if (!cpus_are_resettable()) {
+    } else if (!cpus_are_resettable() &&
+               !confidential_guest_can_rebuild_state(current_machine->cgs)) {
         error_report("cpus are not resettable, terminating");
         shutdown_requested = reason;
     } else {
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index b6fac162bd..20f9d63eff 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -1594,6 +1594,11 @@ static ResettableState *tdx_reset_state(Object *obj)
     return &tdx->reset_state;
 }
 
+static bool tdx_can_rebuild_guest_state(ConfidentialGuestSupport *cgs)
+{
+    return true;
+}
+
 static void tdx_guest_class_init(ObjectClass *oc, const void *data)
 {
     ConfidentialGuestSupportClass *klass = CONFIDENTIAL_GUEST_SUPPORT_CLASS(oc);
@@ -1601,6 +1606,7 @@ static void tdx_guest_class_init(ObjectClass *oc, const void *data)
     ResettableClass *rc = RESETTABLE_CLASS(oc);
 
     klass->kvm_init = tdx_kvm_init;
+    klass->can_rebuild_guest_state = tdx_can_rebuild_guest_state;
     x86_klass->kvm_type = tdx_kvm_type;
     x86_klass->cpu_instance_init = tdx_cpu_instance_init;
     x86_klass->adjust_cpuid_features = tdx_adjust_cpuid_features;
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 246a58c752..4eea58d160 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -2659,6 +2659,14 @@ static int cgs_set_guest_state(hwaddr gpa, uint8_t *ptr, uint64_t len,
     return -1;
 }
 
+static bool sev_can_rebuild_guest_state(ConfidentialGuestSupport *cgs)
+{
+    if (!sev_snp_enabled() && !sev_es_enabled()) {
+        return false;
+    }
+    return true;
+}
+
 static int cgs_get_mem_map_entry(int index,
                                  ConfidentialGuestMemoryMapEntry *entry,
                                  Error **errp)
@@ -2833,6 +2841,7 @@ sev_common_instance_init(Object *obj)
     cgs->set_guest_state = cgs_set_guest_state;
     cgs->get_mem_map_entry = cgs_get_mem_map_entry;
     cgs->set_guest_policy = cgs_set_guest_policy;
+    cgs->can_rebuild_guest_state = sev_can_rebuild_guest_state;
 
     qemu_register_resettable(OBJECT(sev_common));
 
-- 
2.42.0


