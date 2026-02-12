Return-Path: <kvm+bounces-70903-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0JAtDYFyjWn42gAAu9opvQ
	(envelope-from <kvm+bounces-70903-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:26:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C1AE612A958
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:26:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 22401307862F
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 06:25:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45E7829B8E6;
	Thu, 12 Feb 2026 06:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NVDNfbdG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zne0OM0r"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2295F28C862
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 06:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770877547; cv=none; b=OhaE+d3o257N/vau56kh9WsIJqKZAsjIZFQ1/GOHrFgfPw/M1n2BpEDmuAq3BIQ17h7ef9OasEnmTy3sOLengJtmfYtQl/h9NU7Q5DjAGDd6lU6xRincYrnRvXu3Jd8W3L+IXXFJVC0brzF3jCf+59tXAUuez6FZJbZwafahcXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770877547; c=relaxed/simple;
	bh=GmRLIbZjchC+pycXBCsZ9qMUepqQ/xLrB0k7+qfmtlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7RIPSbPZxFuT4x3jvtlYkNL5s4FaR1O6l/VRg5m8EULjA9woYlwDFkx47X31hECI3SA0ODM1Qcr9mxzX+21JR309VDBP22Q5Eu5QJ0TUATBK3QWYTgUzSgiu/uCS4zrg1GzOMR0K2DOZIbSCF0Wxt0TB4rRh8EPslEwVbf9GW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NVDNfbdG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zne0OM0r; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770877545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/1VlHtYGbkfW+qN/OA1sAKbbnZvFUDWI/CtmetDJXqY=;
	b=NVDNfbdGLv5n4A228J1bftSZ8vpsOE8Q9XxQ2FFHeJsRozMrNycA4M2SXD27l2RcP9E7EG
	P5XpINdOF6I2rumFLP4CPU3y8e1Z9FcSZQL7LMSSBUScP8c7UNnn7sylpeXBlVKcKKIcYs
	McULGWZ0BhfQCBSqwwZ3bjZUQQdp57o=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-sXzoBSwAPxS_XQsdu3uMgw-1; Thu, 12 Feb 2026 01:25:43 -0500
X-MC-Unique: sXzoBSwAPxS_XQsdu3uMgw-1
X-Mimecast-MFC-AGG-ID: sXzoBSwAPxS_XQsdu3uMgw_1770877542
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c6187bdadcdso4615540a12.0
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 22:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770877542; x=1771482342; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/1VlHtYGbkfW+qN/OA1sAKbbnZvFUDWI/CtmetDJXqY=;
        b=Zne0OM0rOXDeMxVLKZjaSeFeayPckwNSNgOWgHzBCGiaFrzMLUS1JDA0f/aEp6kf/U
         IcPiXbQbpw/R4MzmsXs3hajQhrPq/LxTwUSBElnQvwVXtDUD7KMjSJLD8MKNnbln0qkX
         V9RIdAEI0nXTMlfsE4gqXQOi4QkiPdAhQQ09rrD8xe2kjDGiGfERp+Zl93fdBYstHo4j
         2FjgPPm1uRRVGPoQ8GP0p/NUlELiZ1Fn7bF0Dc2YJrsjQ+uLPTw91U1Q+PjLmL3s9+hh
         D9xSPQtdd3W+0d9J/OS1ckHHHgFxr6FhAVKXPIywHOCSKAhL8gHCjf20veiewdfLtjZv
         V3AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770877542; x=1771482342;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/1VlHtYGbkfW+qN/OA1sAKbbnZvFUDWI/CtmetDJXqY=;
        b=bQTEgN7eoqcwqBjoN5SNyGD8a7RJ78SyJ7ouTru1PIKpFXE+GKCbge4OL/GcBL0k0H
         BeA1awbrieXX5ccsBT6ylAXPif8TjzmJxDXX6WNMXodiSYmQwLIRYqiFz2yJNrISrNmZ
         MMEBeI5wpXMGWhYAOyTumzKcXizPr9/YEvfo022hWVurxz1SVowFzOY5QIG7Lg0cjnEK
         e9Bjy9xzRLYvbj1SYAmV3vqHe7IC5ByfMkAyPT8rQf3x5L3zewpVuyTy+Oq0f4melykh
         8X+ZOMRHN7ONiGTrFegEPgGiQ47IzZJfFKdQO0bw/ApsV4stpSNWVxtp5w5kEQgfXfPk
         UQIg==
X-Forwarded-Encrypted: i=1; AJvYcCVDtmcwXz8VfPL9Hl+MTklzGZtGfjSdTTvesfieSLlQ4kDPUAzWI7Kqy8eri/FoGiMXwYo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNmU02mCWp0Uly4dCyqytAV5h20LLss47Y8/3koEIqKR4CWido
	eevCS1+HHvCfKL4VfjquDBZZdH/mi7y7s3OM5nFtN3JbRBHp9FIf+a9QCHQA39l6PMnIA56Cq7Y
	HwSjFMIz17ryEmW6BMJ4Y7C2mypHM4v7ejI99yWWge7wx0R/G6i9JYg==
X-Gm-Gg: AZuq6aIey/h9VNR6zqT5k8TvZFySGk0vTai89KuoW7Cktxrnmyb0TfDIhuXkZ1rVg0y
	5TYzY+B44BJ2bclcvu9TKlKr3OGtOzSA0zc0HC/pYAqlbXiBMeqRG9ukRXkzselCQ1PlrZL7hjU
	ttpdWhN2+hTJhfOEy6jHLIHbTwl43rlLBvAfw/WQD2awBH/V1lP8nGWH0WRQAnOIqcJj3ULl0ax
	BWf2tB102TWAqkfecgerV0AxiQzeYlrdzB/z2cjeARNHlxNEK4RTpZ6RcLRSM85PtvO8PBlirDv
	rU3Q29xc/ZMCfsyFxxOsTAg+g2QtIaB/034gN4I3EwKQJGWofS80LQ6YTA80462HUANpb6CKxGW
	gnzAXv39pdyh8YVjhpOliLtWZjkvx6EJuW2izF2trBCRPusbSMzYVPIg=
X-Received: by 2002:a05:6a21:3b49:b0:35e:e604:f78b with SMTP id adf61e73a8af0-3944845c420mr1507973637.3.1770877542147;
        Wed, 11 Feb 2026 22:25:42 -0800 (PST)
X-Received: by 2002:a05:6a21:3b49:b0:35e:e604:f78b with SMTP id adf61e73a8af0-3944845c420mr1507949637.3.1770877541761;
        Wed, 11 Feb 2026 22:25:41 -0800 (PST)
Received: from rhel9-box.lan ([122.164.27.113])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3567e7d95d8sm4894122a91.2.2026.02.11.22.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 22:25:41 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v4 02/31] accel/kvm: add confidential class member to indicate guest rebuild capability
Date: Thu, 12 Feb 2026 11:54:46 +0530
Message-ID: <20260212062522.99565-3-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260212062522.99565-1-anisinha@redhat.com>
References: <20260212062522.99565-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70903-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C1AE612A958
X-Rspamd-Action: no action

As a part of the confidential guest reset process, the existing encrypted guest
state must be made mutable since it would be discarded after reset. A new
encrypted and locked guest state must be established after the reset. To this
end, a new boolean member per confidential guest support class
(eg, tdx or sev-snp) is added that will indicate whether its possible to
rebuild guest state:

bool can_rebuild_guest_state;

This is true if rebuilding guest state is possible, false otherwise.
A KVM based confidential guest reset is only possible when
the existing state is locked but its possible to rebuild guest state.
Otherwise, the guest is not resettable.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 include/system/confidential-guest-support.h | 20 ++++++++++++++++++++
 system/runstate.c                           |  6 +++---
 target/i386/kvm/tdx.c                       |  1 +
 target/i386/sev.c                           |  1 +
 4 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/include/system/confidential-guest-support.h b/include/system/confidential-guest-support.h
index 0cc8b26e64..5dca717308 100644
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
+    bool can_rebuild_guest_state;
 } ConfidentialGuestSupportClass;
 
 static inline int confidential_guest_kvm_init(ConfidentialGuestSupport *cgs,
@@ -167,6 +172,21 @@ static inline int confidential_guest_kvm_init(ConfidentialGuestSupport *cgs,
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
+    return klass->can_rebuild_guest_state;
+
+}
+
 static inline int confidential_guest_kvm_reset(ConfidentialGuestSupport *cgs,
                                                Error **errp)
 {
diff --git a/system/runstate.c b/system/runstate.c
index ed2db56480..5d58260ed5 100644
--- a/system/runstate.c
+++ b/system/runstate.c
@@ -57,6 +57,7 @@
 #include "system/reset.h"
 #include "system/runstate.h"
 #include "system/runstate-action.h"
+#include "system/confidential-guest-support.h"
 #include "system/system.h"
 #include "system/tpm.h"
 #include "trace.h"
@@ -543,8 +544,6 @@ void qemu_system_reset(ShutdownCause reason)
      */
     if (cpus_are_resettable()) {
         cpu_synchronize_all_post_reset();
-    } else {
-        assert(runstate_check(RUN_STATE_PRELAUNCH));
     }
 
     vm_set_suspended(false);
@@ -693,7 +692,8 @@ void qemu_system_reset_request(ShutdownCause reason)
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
index 0161985768..a3e81e1c0c 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -1543,6 +1543,7 @@ static void tdx_guest_class_init(ObjectClass *oc, const void *data)
     X86ConfidentialGuestClass *x86_klass = X86_CONFIDENTIAL_GUEST_CLASS(oc);
 
     klass->kvm_init = tdx_kvm_init;
+    klass->can_rebuild_guest_state = true;
     x86_klass->kvm_type = tdx_kvm_type;
     x86_klass->cpu_instance_init = tdx_cpu_instance_init;
     x86_klass->adjust_cpuid_features = tdx_adjust_cpuid_features;
diff --git a/target/i386/sev.c b/target/i386/sev.c
index acdcb9c4e6..66e38ca32e 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -2760,6 +2760,7 @@ sev_common_instance_init(Object *obj)
     cgs->set_guest_state = cgs_set_guest_state;
     cgs->get_mem_map_entry = cgs_get_mem_map_entry;
     cgs->set_guest_policy = cgs_set_guest_policy;
+    cgs->can_rebuild_guest_state = true;
 
     QTAILQ_INIT(&sev_common->launch_vmsa);
 }
-- 
2.42.0


