Return-Path: <kvm+bounces-71749-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aB6YO4FxnmlqVQQAu9opvQ
	(envelope-from <kvm+bounces-71749-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:50:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9573B1914A2
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:50:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 76950306710F
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 03:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 836D32BD00C;
	Wed, 25 Feb 2026 03:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KJry5Z+d";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="UMPimMYM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DA879CD
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 03:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991420; cv=none; b=ELB256Hoi5iS8gnijEEYzm6VfUeV3x1YUCVLtEePotR0mw4ndU/bWlrxGW5uGG4KIwPqV3IsotEVuRXfXHA1KDeUIo/iV5Bc1nh/LNrxh9CYQOjHWz61H6eregB6CRtEsnNfriAuewLVYPfKeHYGpfxTP+Mk+NOceTDvP3oF+50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991420; c=relaxed/simple;
	bh=VQs3X+IirTe7aXdM1voDtjvGyrOz3Ofo1DhUMefMY48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DkqglpX7Vf8eENGMF6Kl0xbiymDciaPJ5EwEnEte2QwqMX68JQ77s/34zU2nYUIgK4rmyDsHl1Tx7NROxn8zuTS8jByqhIaBT5gq9JwxmyCRruDU/mxT/J8RtpSVcUeJ6KVyr4HAmI3qTuLcvtJBE4AZnIb0bY6eLhy+CRw6PHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KJry5Z+d; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=UMPimMYM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771991418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p3brC6j5MVPRsa373EQ1kn7FdyUiGI8z9lGD92Jf5HY=;
	b=KJry5Z+dlF+mpN2oLu1FKJBbr28NyeCdr6HxELyuTTcmkXYy+0JUWFz2B7OXtZeHrRhGId
	J8ofV+vONoyPbc11UWC9y1HuUc1IbwW76zXg92dS9XaPA0fUK6NAIsThVqeo7GT48i7KC0
	sZN6En0c+keYcZgsFHLXY9LoSOcbQgo=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-61-wxZS8CwYPdy96AAr0OivgQ-1; Tue, 24 Feb 2026 22:50:17 -0500
X-MC-Unique: wxZS8CwYPdy96AAr0OivgQ-1
X-Mimecast-MFC-AGG-ID: wxZS8CwYPdy96AAr0OivgQ_1771991416
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-35626b11c51so4863184a91.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771991416; x=1772596216; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p3brC6j5MVPRsa373EQ1kn7FdyUiGI8z9lGD92Jf5HY=;
        b=UMPimMYM5j+na4JDCgbs6h1e0K9uHgvffshK4ZitB6CbEf9gWu578rFTfeQNfuHANC
         pw3CM2i3vzTrVh4QFfkieaqUZ+ZJwBfwOAJL7tyHavxTfBJLLYrItaXqMEJzAnmuRPHy
         VppSEz2mtOxmI7S5WF2KZ7zsa/xq0Ga6ij5BJHVUXxFs34b7OEi7cMTcsVzkiFJcqvcv
         WqKe8x0uiT7dQZgapxSc9p/x8kYdlZm8x6bfY4NBXJY6mY75gu1NwJKMetVTvfkjXps5
         jsDVimNUAcO/aqboBV4O0Gry1vQZcqtFJ9+nF6pZFPeuO3WgMkAWtQ0yfhBDVFbwbyh1
         Asxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771991416; x=1772596216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p3brC6j5MVPRsa373EQ1kn7FdyUiGI8z9lGD92Jf5HY=;
        b=tsaqL/XB2AoDEf1GPYsq7e5B9PJTJuQcIHoDAUhNT/9+ZHwf+auRaFtID/l2YeTDis
         3/TAqqNGcDEuNv6PA3am6CFlKdcf0J+p1A7doNls9e0+SSN8I1pbqHcQM/HSoj8GSXww
         +Ni27aUrrEKOJ+2hFqO5GC36Yf7/rSg9qqNV0gngqOG/r3Jayilz9QTFBC2SqKslvGvr
         urigbZMU2MbOKZZk+VNvib+4Q2CNPwJXrX6ih0RA94QXs2Mgn8tIi3TuRnr0uVOJcebC
         gCoNX/Ja2E3OETdluqF7xb7zX8uCbcK5Om/LB7YBLHT3YflQhxmFZbHnxGm5h6n4CDcL
         L3qA==
X-Forwarded-Encrypted: i=1; AJvYcCVh3er3ZFwV6uA0pUoQGuitLFcFaYY/V0KPG1lBC/oFSXOLmrBVIs98+bD8fkm5v5CA/OI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzslHx52JcRajPbefuGYXWaDCZsPwlYhLIu8OnzV1MvNFPqIx1/
	lhutp+snmRVlaeShYxuo/zr2nIXTUcD0sT2ID6IiLom5x7MEMDoaVwcWxXvPbm5p1jVdF0S6UpQ
	aqKlSHIu8kJH/MnTvfN4s9M5/wSYJjhAm5i4rFJWrsteVD7T1K0EU5g==
X-Gm-Gg: ATEYQzwWoG0baPxzbtwe3fMADXaFH4amBbdBJIS/aNKlIlCB34nL7KGTDRua1GGjaWz
	rr5jJmGFnIc1gpjGqfaD1eY8l6XwU8nlkFsJ8BxFkcPdmHWa3Su9O+B5fi8C48OevOTl0EbnLsa
	9tR3UgD56NQ4sQkMbHUtnR08nIDQrQ5gFqipPdsqzryN83EmeB3axe5OW37ffiW0r4RpaiSNqq3
	y7aIxl2jfSkD7voqYDWZZ557Mb/u/Uuc+liybMxVelCxl2X5Ky6Pk/L63n0/6AGaJpSSYb+A7GV
	2i6eYTCDMKzUupj8rKGrczvCEoGtTEPRemetS9Xs2dR8EYqRWM5E3BttDznBgp6lVOBhPtcXlJe
	l269f+U4MOGJnNnigYtzRI65VLcvWxx8Hn76uezcvFj+EqmFj4vSq/gA=
X-Received: by 2002:a17:90b:2d43:b0:353:f7b:6d60 with SMTP id 98e67ed59e1d1-358ae8d5b49mr12678329a91.33.1771991416074;
        Tue, 24 Feb 2026 19:50:16 -0800 (PST)
X-Received: by 2002:a17:90b:2d43:b0:353:f7b:6d60 with SMTP id 98e67ed59e1d1-358ae8d5b49mr12678308a91.33.1771991415673;
        Tue, 24 Feb 2026 19:50:15 -0800 (PST)
Received: from rhel9-box.lan ([122.176.129.56])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-359018838b2sm1186006a91.5.2026.02.24.19.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 19:50:15 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	ani@anisinha.ca,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v6 02/35] accel/kvm: add confidential class member to indicate guest rebuild capability
Date: Wed, 25 Feb 2026 09:19:07 +0530
Message-ID: <20260225035000.385950-3-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260225035000.385950-1-anisinha@redhat.com>
References: <20260225035000.385950-1-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71749-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9573B1914A2
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


