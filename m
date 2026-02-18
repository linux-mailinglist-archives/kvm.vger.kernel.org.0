Return-Path: <kvm+bounces-71223-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qPQHGtSllWkQTAIAu9opvQ
	(envelope-from <kvm+bounces-71223-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:43:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C7101155F70
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:43:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3B2AC301DB80
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 11:42:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F143030DEAD;
	Wed, 18 Feb 2026 11:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TPIrLBM/";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="TIGEIMYd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026802DCC1F
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 11:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771414977; cv=none; b=g7UjTJWlqt97KQe5n60S3suI9RNW0Tt4B2+rWZP7cQ5WBLVB7E+eo3sn5MtAc8EpBUNGJ7nLhVVHX3esN9jJBurTABusaRITEBxvCU4W96V0p/D9tXDcsSD7uXwTeWC0zfA6GsE585dqDpq+bUCEiaTjfArBc0B04P2daWMGS6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771414977; c=relaxed/simple;
	bh=VQs3X+IirTe7aXdM1voDtjvGyrOz3Ofo1DhUMefMY48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5g8m6/6X08X9h+jjaRYdM+lRTQgnYjBEN0Ta6VAmo8vg3uL67c0H6+sG6D0e8Y/iINZGU34fVZe2KHhEhHpcrNaNahuwU9L6Me6rV8tM6goj8pM+p4qUWzErPQCVp4JMbTMoRMKkaevF22cCwe7OXfORdNeiv8f9VVgqd5C2Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TPIrLBM/; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=TIGEIMYd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771414975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p3brC6j5MVPRsa373EQ1kn7FdyUiGI8z9lGD92Jf5HY=;
	b=TPIrLBM/vr2j5L7BA8bWksieJJuudH+Qy6jfYh6srTCSSJTYlaQzNDhwwPjWqW37pBt6Of
	zegUU+GJbD1dEWTgCAipmMp6RBw7dyqVIccTAbhzvZq0QNwbfuvZOv6Z1ifnZPzKAkiXy2
	S6n3QQL02W1uOE7jnFMW+Gq/9u/+iC0=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-qog37jE-P76rX9-AUC4SnA-1; Wed, 18 Feb 2026 06:42:53 -0500
X-MC-Unique: qog37jE-P76rX9-AUC4SnA-1
X-Mimecast-MFC-AGG-ID: qog37jE-P76rX9-AUC4SnA_1771414973
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ab4de9580dso299178965ad.3
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 03:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771414973; x=1772019773; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p3brC6j5MVPRsa373EQ1kn7FdyUiGI8z9lGD92Jf5HY=;
        b=TIGEIMYdvauTT/Ero0Giwv5PlZf//uN1MCVwjWUWBqUzuDJwb3ejzqtSW2exwJSrUt
         gu0Jt/UDSmmSi9NIaSBBwN76+0LGPO6oLTvHsBA945PmH0SI74Xmzqe1akfGzOFFdGGi
         xHW2JZ1jOFI2lKGSK0XiqMyzEixuVffTb4hBZWkHGeusFN+g8isunVQuEtF1+qJEvfhK
         hjCYJwMF0BqRS1SsIdbuA7NJvr01OVkUA66AmJIi9ZbyM9bJZ0DeyBPqyoq4aAzOU4qP
         UVfuzeTkDbIZXi0ANMiZDoN8EntcflttPBsWvyPB0xdaUbmi12iB87dJyrkuANAJH8mn
         qwEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771414973; x=1772019773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p3brC6j5MVPRsa373EQ1kn7FdyUiGI8z9lGD92Jf5HY=;
        b=mlH54/8+tuWFYXquyC6t5SvnyIY/x1u90RFxHSVIiQhDxJZFrl5fw9UDLvUFxI7b64
         a+m9ZssZLopAX6mOZtnnohxLWuK8rspzCrnwXpvjRdg1UY/CdJ5r4dQvVUsIAiS0ykK7
         SY7AGzIw85M7KpxG9HSKuLnyuL/ftjuMc2GYz4OvdZtXVwpGfPE/ZkxK+xbstTwv7vtN
         eURTB8gtSyEAJhI5Jksu0zwr5VWIn9IFehHDRYr2dtykjAGf1qH3cm33aiO1Odc+bvQu
         ksTVBB0i9kJRQscmuJ2P16LQpyl3XtIGSuI1RbtSWBTzJE8c85SL3TRp0VQ/8Di+r6R8
         /cJw==
X-Forwarded-Encrypted: i=1; AJvYcCWy0A8bKkRC/dsIsZ6mLBinwtqtXVKbx3ElpQ6e/18F8oC8dpCkqlcWfYOK6P2fQbX0530=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKgO/HGn1jaAa49Bas25aiER75RRBmJEQGVkk4wb55A4r7QbZh
	0Rl9lBgSmYq7Qpk2kvXhA0CtSrkkJXfwt1cxZdLuxgz4LwOJ/7wbDyq/j9R5PjywPeZ4xt+ZC+G
	7+TTAphJ7dLchLF5fBINFns+/RfnBB8OOtNAbzljoLdXFtl6KckKF6g==
X-Gm-Gg: AZuq6aJJ9v48b0O7wizeq//qdxZuyA2mXdHESpdcrWkjshMcbrGq7zE3xGPvebTmmJB
	5Lvw3+7Nrn8FJUyYBcR4n8PSYaC0SOpyO+oMrDQGG3CWVUj8Dsj5lN3Fv0Vz+CQHdv1zlI55GwH
	jMskUaKhcDl3zpGEq7T7EaJLgeRWEXset9Y46H3wPxbIfWPL/dkK1e51c5bChyX25rUNSDyurnX
	Y9Yhd/HIODUXY4UL0bXzWpDiMakkV/IZ6ptgbX0ldV1ZTo2q6y9TI6F2f8kljj2sOTRMzzawnF3
	K3ukF2Mhi2u40feArmOfVJOwm1hNo3NneinqVaFFTevsRc/j12J/zAkZZYksyY9BsEmI6VjdzmF
	VfoXJauzzfbX+F+Nl3gL4GYJFL7XXlb8oJmyNIiZgVIQQz30WctZH
X-Received: by 2002:a17:903:1b67:b0:2a0:c35c:572e with SMTP id d9443c01a7336-2ad17501af0mr153308265ad.30.1771414972858;
        Wed, 18 Feb 2026 03:42:52 -0800 (PST)
X-Received: by 2002:a17:903:1b67:b0:2a0:c35c:572e with SMTP id d9443c01a7336-2ad17501af0mr153308155ad.30.1771414972496;
        Wed, 18 Feb 2026 03:42:52 -0800 (PST)
Received: from rhel9-box.lan ([117.99.83.54])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2ad1aaeab38sm127803425ad.82.2026.02.18.03.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 03:42:52 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v5 02/34] accel/kvm: add confidential class member to indicate guest rebuild capability
Date: Wed, 18 Feb 2026 17:11:55 +0530
Message-ID: <20260218114233.266178-3-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260218114233.266178-1-anisinha@redhat.com>
References: <20260218114233.266178-1-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71223-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C7101155F70
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
index d091a2bddd..13f32bed8c 100644
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
@@ -697,7 +696,8 @@ void qemu_system_reset_request(ShutdownCause reason)
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


