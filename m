Return-Path: <kvm+bounces-70907-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IIZDFqlyjWn42gAAu9opvQ
	(envelope-from <kvm+bounces-70907-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:26:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C3BF12A99E
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:26:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F3DF230B82A3
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 06:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3328296BBA;
	Thu, 12 Feb 2026 06:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R7RAnccy";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZWyAorMf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE10295DBD
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 06:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770877565; cv=none; b=Uz1iHp0NC3aAvazz2up6HUfooygyHDiPhrM9natRAwM46akSAHeDKmvw+6xE0hmvPcAwfrdg0oOq2k03YJu6Qi9AQbXc3eYiv4iqXC8lr0rY6l+jl7IM1QuSXHASAakHDqlhQNRa+7evmt+zg1bRdkWIv35JyL5maMD6IAEEges=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770877565; c=relaxed/simple;
	bh=Kut9wFHOOSKyrDbMUAW0ecXXWwZWU2fp+BYmcVp2akU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWmyheWradubuIbnPFmhPEPcUiVTtkwfHvqvtTE1oKQ8EuxHicif/787EHrD09Gk0LAlSK+8Q/HLCIIoedSKYI5Y4O++U9EZF6PmCv0dJNO+G4oCSLihlOVR3EtaQYQIjIPwP0h/4lLeLRFenyCtcBQQBRxQMapIme4IIRb1Fuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R7RAnccy; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZWyAorMf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770877562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gaiZHj5SPB/rag/yYC6RdeZjL5+Ke47uV0afXoVShvg=;
	b=R7RAnccypeC1OLoNvxpHU9oBGAdE+yYrMEXXlt5y3s9+V5m9ySjamxhUihDs/EjA2J8YtO
	YsHSYcoQbK9Lgk/Aoc7qE+9M5AJy++Cow+aARayvQGlDYWBfZhI+6btWC8M7u8IeoJO5X7
	ucUsGXo5sXBtTQzQqDtV71e113RwGHQ=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-iMwkKPRcMqiUx4c6VPU8_Q-1; Thu, 12 Feb 2026 01:26:01 -0500
X-MC-Unique: iMwkKPRcMqiUx4c6VPU8_Q-1
X-Mimecast-MFC-AGG-ID: iMwkKPRcMqiUx4c6VPU8_Q_1770877561
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3545dbb7f14so7627769a91.0
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 22:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770877560; x=1771482360; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gaiZHj5SPB/rag/yYC6RdeZjL5+Ke47uV0afXoVShvg=;
        b=ZWyAorMf5SAfFs8sX6Ybd+5YcoKbEj7KBSif0FUfPzRyqc8YQaUCW5uCtD1DXhnqQv
         E2LEKX7ywpnBXj+l4mx6ZkS1x5Z8P7EGCZD7RRup0or424d36oIYXid/LlfvsgrwbWcx
         NN+2BZHnx0OgFhB/8Gn9RBEktYKaQXllIUMY2GwXxBCDaESbuxWWnne77nzLVFZi0uUK
         /OFPewCONsO7cRe4X2oJWq038vV+lpd9EnMcKjaVkjamUI24Zjd9oNIpO8+pI+LEapEz
         6vh+emzMKwbW9PL5ZQXVEjyGXv4za05+tUt1jJuq9W6ZTmKcJP3269Eq+P5QR+OLb/DW
         I1QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770877560; x=1771482360;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gaiZHj5SPB/rag/yYC6RdeZjL5+Ke47uV0afXoVShvg=;
        b=bQ4zu1XhKHubsj++kUutlYhpJSPT49zoHXWKXxFAeTM3twoy64OO0H3A/g85LxVreA
         Ys5KirOrr32Ia5roLzY6Xj31WeWFu6BA+Bc/XPHLj94J2LEsiAeDG0ruBjdRRaGCX3aD
         8vT0dSSnsUk5EPAGWpfx2ppynxBUOifyU3bFW+YN/3T9vhnYzt74RKwx6jWRx5U9FhPh
         NABNzo2+K51J+GSLII4cWISVUUPvsaOfpGs7RCXuWBioEwf47D3DEi6FCMcLxOcy5jAB
         VF78Ijl5OE3GXLC9o4OSHJFRzxKdrACI322KiT13Ff3P/AXfNSJxNBdkjVwyfSpN9QzJ
         q15w==
X-Forwarded-Encrypted: i=1; AJvYcCWwtWjmLimm5/7ax26KhEA/KfnRNI6kzlkhM3yk2eL13oYTTvOKgjCVv7dxgIzGFlpc+c4=@vger.kernel.org
X-Gm-Message-State: AOJu0YywltBaZE+NgM/ARKkE6E8siu+ybt9EAHP21k5qjoi00L7ZJlZU
	xbSvcfg5+K9INiBe0GIbFVVifDzkc+D5CITS0ZPCFJt11D89ptMEjWk2G5ANbztreKajpo/rh5p
	GpzAlpmPX5N9SZ7l9wpOoxggeOJ7qrMC8Os/ug8d922QJX2Ufa8/9WTwmUvMrtA==
X-Gm-Gg: AZuq6aJ+XLrjQKB5y2dlYHxGCsCLap59uJepexiKtPdOXXT7oLKto9sSalPhVKXH9pI
	sRjqZ+sZCFLdVq7usnZmSemvKC5wqCQB70syGDN72J0RRr8UMloDE9eIbCZcxDK7fgVwuDnwi0s
	aoAA+aXpJfbkn7yMshEZ3tlKAnH4rQRcq1Mb5dk69tfw47MO06m3wPW8PGlvhLQNTFRvzifU7pQ
	kt37CREO+Gkfj652QFOxTMt7ZTGQDGwRGuMMLAx8hLHsnCSp2dlGlPg6jJh1Pb8tATm59opYeI+
	QpMKEthkHtEBzEcX+4iEwf5CZu4DGas0Sjx66blPdDtFh3d8o8O250iliPqznC5UGos0RbS2+5L
	iV7+PKwURXwQXAuBXi5gU2LdeKllBlHndWalUXSWbJQhX0+FzdRZ2IME=
X-Received: by 2002:a17:90b:3912:b0:353:356c:6821 with SMTP id 98e67ed59e1d1-3568f2b7610mr1774884a91.8.1770877560309;
        Wed, 11 Feb 2026 22:26:00 -0800 (PST)
X-Received: by 2002:a17:90b:3912:b0:353:356c:6821 with SMTP id 98e67ed59e1d1-3568f2b7610mr1774860a91.8.1770877559964;
        Wed, 11 Feb 2026 22:25:59 -0800 (PST)
Received: from rhel9-box.lan ([122.164.27.113])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3567e7d95d8sm4894122a91.2.2026.02.11.22.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 22:25:59 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v4 08/31] i386/kvm: unregister smram listeners prior to vm file descriptor change
Date: Thu, 12 Feb 2026 11:54:52 +0530
Message-ID: <20260212062522.99565-9-anisinha@redhat.com>
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
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70907-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1C3BF12A99E
X-Rspamd-Action: no action

We will re-register smram listeners after the VM file descriptors has changed.
We need to unregister them first to make sure addresses and reference counters
work properly.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 83c15f098e..5d9b79529f 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -112,6 +112,11 @@ typedef struct {
 static void kvm_init_msrs(X86CPU *cpu);
 static int kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
                           QEMUWRMSRHandler *wrmsr);
+static int unregister_smram_listener(NotifierWithReturn *notifier,
+                                     void *data, Error** errp);
+NotifierWithReturn kvm_vmfd_change_notifier = {
+    .notify = unregister_smram_listener,
+};
 
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_INFO(SET_TSS_ADDR),
@@ -2748,6 +2753,17 @@ static void register_smram_listener(Notifier *n, void *unused)
     }
 }
 
+static int unregister_smram_listener(NotifierWithReturn *notifier,
+                                     void *data, Error** errp)
+{
+    if (!((VmfdChangeNotifier *)data)->pre) {
+        return 0;
+    }
+
+    memory_listener_unregister(&smram_listener.listener);
+    return 0;
+}
+
 /* It should only be called in cpu's hotplug callback */
 void kvm_smm_cpu_address_space_init(X86CPU *cpu)
 {
@@ -3400,6 +3416,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    kvm_vmfd_add_change_notifier(&kvm_vmfd_change_notifier);
+
     return 0;
 }
 
-- 
2.42.0


