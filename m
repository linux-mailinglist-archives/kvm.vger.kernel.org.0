Return-Path: <kvm+bounces-71234-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8H0RAyumlWkQTAIAu9opvQ
	(envelope-from <kvm+bounces-71234-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:44:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 63B9C15600E
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:44:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9DD2E305849D
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 11:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA18030DECC;
	Wed, 18 Feb 2026 11:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U8Bj2YIi";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="R55NtWKk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0EC30DEAD
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 11:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771415022; cv=none; b=tLTL3Sea+PKyqqUjLQmLyLgdbQoEDLZvIT02DLXP6VjfnOuZHwkPrIETK5h9DyyAaP7z2ILEKnpHeSKWopxluRu/+tssfk2PQZ9UKCZA64aYi4OLnljdfucSXJ310PJuoYBZE7QeZK4UokdK+xVdmQ28ySI3Og2LD2hMTkf8ung=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771415022; c=relaxed/simple;
	bh=mYHykGSeRol6qPb0O2RCz5WVhoAbFlEQQPuIWA8vy2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGW9iio81vF7QBF4OBkvQqv2WgHHnnViaq7Z3ExL5luiDyHc76Zf2649l0Ssu4pHjeOoAWJNB3zNMlezDRNY48CMlLe1SWiwjA3ZEMUbvY8yRH0RIBPZEThfbjBA52yLCf1s9UEvhDdqNnfJMbSk/qHFa/PDEok5q9TSZZNYr9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U8Bj2YIi; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=R55NtWKk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771415020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bPhZf11AJ6OznTneTjtivFAiVtwbcW8pDml41uWPO3Y=;
	b=U8Bj2YIikquYxY8wvYYch5bTQcUFcxQ+tp6Mjp0I/V9Rn/MRaBTJiJb/Wv3E1yj1iyF1tF
	P7Ck1k6c6+QH0YbawF1CdChdQSMkst994pj7wM1sJfX+2dpH/stHh+WA1rHvqdKMeEmq99
	5uf4QN6OerLXOdhvLQGKFs9vuSs1pRA=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-4FpNn5AMP8aifwYAXPVVJw-1; Wed, 18 Feb 2026 06:43:39 -0500
X-MC-Unique: 4FpNn5AMP8aifwYAXPVVJw-1
X-Mimecast-MFC-AGG-ID: 4FpNn5AMP8aifwYAXPVVJw_1771415018
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2a7701b6353so71346715ad.3
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 03:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771415018; x=1772019818; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bPhZf11AJ6OznTneTjtivFAiVtwbcW8pDml41uWPO3Y=;
        b=R55NtWKk2GSaYWIHmmk6BNBCYoTzfQS29UNe77u6PCtR8BYTsTtXIq9pU4Mgip+SZJ
         wFwNXe4iW1XXO9G1rUkj0o9alPNzn4eIm8CEbDVc+f2Trn+T96QWD3YwnsHRTGkc8q26
         WZ93yRLgYCHuL+plDT5gAK89wuAeJI2jBXWuXIlO0DnMW8vgn9ufETVXuZmimiSbUr/T
         iGHfEs+sEHmDjbeMw8qplclBlMcRqQ7FZYuepjRfNarEz7wQASFjbWBXRb7WfVqrrgta
         r7rqn62DUxgQ/WXIjHIQ0zTIz2ZnZTMlMCOttNSmv4rKO6ekyOZIZQjozbK/8fN1uvGY
         swIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771415018; x=1772019818;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bPhZf11AJ6OznTneTjtivFAiVtwbcW8pDml41uWPO3Y=;
        b=q+OGCIaGlN9f8er8rSnz96Mfts/TEpOWskeY3f4C27Cwgclt6661LhDTWEdtxI8QRP
         UQiUeN/4o+SCIDHf10lpOZUgo8OzqUO3eeY7mVOr+ff9wy8pYEjXRwjhPNyG8Ovptwfb
         8hrCs8MpGOOsx7wsNati13tQ6TPgxZb/zPKlb7aEEJCNkIaylDIYJW6urtwyz+n7De9k
         5H4d+MHZhHM3l5z477ty3m0+cnclr4gGEy9CHhpk1UVhpTQVWjYEi70zNOdTRyYxRqfw
         oJfmJdU2fegzedVTl+YlVbDle/Zx3zgRYhvtQ3qj6LSTPLIvAA7Ia8MP6fPAhlZicBqJ
         wQQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWbbuDZi2GpS+cwYym0OXz7fRJ2G0cX5gnF0xZ0WAnkf0QkR/xcYbR93A2+om1G0lAds+8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0MW7j9oL4RBzkQthPjuPKPKDhRGGGjJ8a1QV87H4PF5mn17yC
	PxxZvbIQjpUd/sHTWPuveEkq8dDSwxMdOAEMx3bH9/WfH8uwhAbwsBbQ30BQrS7vhuRjscbN0p7
	P8qTgE8H7Sq//G4ipc2dwTg4dWIRqIN+vTx8PxUDGwU4Gn5pP2YnKyA==
X-Gm-Gg: AZuq6aKPhXWuSw6ojXs/urTnANXg8FvIRUeQR8wYbiExx/oVfRGhf1c2onjl/PJRtzZ
	V3ZoEgsXYbEii79OWw4BSrljQbWySVPrDaWRxhYqN3bX0K3ksqBYwqeaXxu4BNZsrMeRhTlzpgj
	34Hx3ZL/QGCWYvl1tR6xMXZl/ed36TKIHfAzeamBBHX0cYA2UMNLuC8jwXe8VMHk+3XvCM6t7bT
	OOuBhcndPggpbwik+kHHg7E4IwwXkZ/f6JfvIbo1XzH7ne83/xPsmss7wV03vVG2Wnuc+8jxjJV
	CBXZHtgIqPHAnLUNaX5IrgUAKLAn3UCTpM289XulljBnEZ4OitZGlZxRzbCLCU5gXok3Ush3d8g
	qa2S9nBh95E6bkuQLI4W+JvNvTybg4JLdTbrXe7jSXgEuYc1yzgeM
X-Received: by 2002:a17:902:f601:b0:2ab:344e:1400 with SMTP id d9443c01a7336-2ad17524ab4mr175576325ad.37.1771415018073;
        Wed, 18 Feb 2026 03:43:38 -0800 (PST)
X-Received: by 2002:a17:902:f601:b0:2ab:344e:1400 with SMTP id d9443c01a7336-2ad17524ab4mr175576095ad.37.1771415017711;
        Wed, 18 Feb 2026 03:43:37 -0800 (PST)
Received: from rhel9-box.lan ([117.99.83.54])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2ad1aaeab38sm127803425ad.82.2026.02.18.03.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 03:43:37 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v5 17/34] i386/tdx: add a pre-vmfd change notifier to reset tdx state
Date: Wed, 18 Feb 2026 17:12:10 +0530
Message-ID: <20260218114233.266178-18-anisinha@redhat.com>
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
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71234-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 63B9C15600E
X-Rspamd-Action: no action

During reset, when the VM file descriptor is changed, the TDX state needs to be
re-initialized. A notifier callback is implemented to reset the old
state and free memory before the new state is initialized post VM file
descriptor change.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/tdx.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 37e91d95e1..4cae99c281 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -405,6 +405,36 @@ static void tdx_handle_reset(Object *obj, ResetType type)
     trace_tdx_handle_reset();
 }
 
+/* TDX guest reset will require us to reinitialize some of tdx guest state. */
+static int set_tdx_vm_uninitialized(NotifierWithReturn *notifier,
+                                    void *data, Error** errp)
+{
+    TdxFirmware *fw = &tdx_guest->tdvf;
+
+    if (!((VmfdChangeNotifier *)data)->pre) {
+        return 0;
+    }
+
+    if (tdx_guest->initialized) {
+        tdx_guest->initialized = false;
+    }
+
+    g_free(tdx_guest->ram_entries);
+
+    /*
+     * the firmware entries will be parsed again, see
+     * x86_firmware_configure() -> tdx_parse_tdvf()
+     */
+    fw->entries = 0;
+    g_free(fw->entries);
+
+    return 0;
+}
+
+static NotifierWithReturn tdx_vmfd_change_notifier = {
+    .notify = set_tdx_vm_uninitialized,
+};
+
 /*
  * Some CPUID bits change from fixed1 to configurable bits when TDX module
  * supports TDX_FEATURES0.VE_REDUCTION. e.g., MCA/MCE/MTRR/CORE_CAPABILITY.
@@ -1549,6 +1579,7 @@ static void tdx_guest_init(Object *obj)
 
     tdx->event_notify_vector = -1;
     tdx->event_notify_apicid = -1;
+    kvm_vmfd_add_change_notifier(&tdx_vmfd_change_notifier);
     qemu_register_resettable(obj);
 }
 
-- 
2.42.0


