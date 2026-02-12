Return-Path: <kvm+bounces-70913-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QBpKGudyjWn42gAAu9opvQ
	(envelope-from <kvm+bounces-70913-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:27:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F3E612AA2C
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:27:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 65E70307A3AA
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 06:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD6AE28D850;
	Thu, 12 Feb 2026 06:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WWHWJ3/Y";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="KcMJan/i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33EC1EB9FA
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 06:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770877590; cv=none; b=StR4VMkvRqgBDKGo59ilEEaBMhZgJk4KEvGS0YbB/r27IG8mw4i2LCPdtl96fw8NQ/O/jlOaHtEBQvlD+FRcVbFFC0oKD3qqwVWXx61BuOB0R70CYtj2lgSeOCZVEC4m2As0x16HXPi4vkvHDUqlo70dGyO5js4uLHXt9YfOiyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770877590; c=relaxed/simple;
	bh=mYHykGSeRol6qPb0O2RCz5WVhoAbFlEQQPuIWA8vy2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=askD029jJFuTffBaDtkLHLQcWwwpFgAFqN5f1pPEWURee59m8D3pIAGRmgotzDSIU+GAA2sjSZ4JMR5ujMqQziJHH0vPn9l/ZOZ3SmiU0QoYDVcQeiXjT/BMoQ7vE007QWSPnbd3/18PeFl5wF/3mbZmJlOKKJ8E9Pk564MXFBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WWHWJ3/Y; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=KcMJan/i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770877587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bPhZf11AJ6OznTneTjtivFAiVtwbcW8pDml41uWPO3Y=;
	b=WWHWJ3/YCmBkkqQRZc1xnCMiDiaAnMVipXU69zcma8cq1goHIzUIZ5nmCzoyxBBsLaWViG
	pVROi7f8WMo3mGqrAd3KBw6iTvYvwytJbOMHUCGn1qtsyXHFn7W1IYElIqsQ5jMckaXGwK
	NXZTy+OmqwBOWBqn8dyyGaAVUlwob5I=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-xS-MIULYMHqF1iAy78g6tg-1; Thu, 12 Feb 2026 01:26:26 -0500
X-MC-Unique: xS-MIULYMHqF1iAy78g6tg-1
X-Mimecast-MFC-AGG-ID: xS-MIULYMHqF1iAy78g6tg_1770877585
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-354c72d23dfso7837165a91.2
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 22:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770877585; x=1771482385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bPhZf11AJ6OznTneTjtivFAiVtwbcW8pDml41uWPO3Y=;
        b=KcMJan/i2qFRrjFTTkjLyFqXx65887O9ipBeL0YBPSiNlJ9Tfks3hBepEo/to72mON
         W07AnLeQ7TRayoa7GNY1apbsQESjaJ6wN9tsLF82MYsPr8vh9VQDUA+NeR98kyeSjPvs
         CfJFvuXJWHnJeTucPtEuTt/tybFC+abtD6g5pCt5N5RmzmY2HRc6oDdTuDgJZpkk+NGK
         PDaTdJAxAaDy/jNNUaPi5s406XKw0NSOJB4A3rr+j/9nm28z2xKnFgASL6VbAvXzO3WN
         +jBv+f2wgVwkfrrUQ08MQM5n4QqKOmxO4o6uKp25afilg21p+lcSWnHmFop+ew/wmZv3
         rRVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770877585; x=1771482385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bPhZf11AJ6OznTneTjtivFAiVtwbcW8pDml41uWPO3Y=;
        b=uBREKeoeNW6czQxbYd2BPossy6AHsO4z5VF+dabqs1eIUActlZ11yvb1IKac/1OHd2
         HM60XOUh59znJi6sbvlKOY3W8fHe6wK2jl5SO/BOWNYBuzhTU3718TRBMr+tseGNOPtT
         LmeZZGVVyFekH4aWz3XH6M3vhrwVkAJEkC/OxWti1xrcwSI6tlto58+j3+XxRCXiSjt6
         KRtAnmmLtopLKRjJfZoGIuxuwKwmwI1+ydqdm7I/DdYXEHu2IcPyOSwUPT7LawiHqZNR
         jOqppYRSydqH0plCdkkSsUMkHaVMEev16ztrjFJf4NRQ4TlJOINcnWz0swWjrQH7YFO/
         4PNQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8Jx5bPM4lYCscxBSnkEFp9iOnFyDUm36mauqeADmZOmxbQ21IzM7N/WtTZPCE9iG64y8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaUfeI54C2XMBs0bRbO+JWnv0IpjPcB1KBCmNW7Z+MGsTALeP1
	38XZvHlTu+wWn9vA80BwlOY7Jf50TvlmHGEBvxMaSWa4jkGaoWzcBrtk3UrkNZPeJCvQ/IfOGII
	9HJIrK7jZrH0bM4ZPK2KPftP9y3ST9GEur4nPWARvMPO/DbVsLAQA6xZnpIbhbw==
X-Gm-Gg: AZuq6aJjEkyNMii3DIiYWwaSi20XEoQqjVHJKj4yCsodOCnFzEXWF0LDZLheOxAZLe7
	sfgRbcTE8wz6tMU74sFpPik446HEGLMh5hL/DKV1ZV0MCcPplRzTnZrVIwH2szV5wThZWcL/7CY
	mkpepE1NO2Diy6CVxbOA0lDQ7ycA05gpdd0Om1dMVlsx9JEPDnVt9vCG455sYMBVrWG4mAeeWwn
	ghn//hhcPKgxIPS1Oq8sczuoaDvpgaFTZhB11NIG4DlHEX+Qz5xU2ifILcQ513u4mycwWfFcCPB
	gGT5s1MTuuwWDygGKUmp4rRXyloZbP/Bp0TMHnms2rPSzZOQFV9LSP26ZhMvW1K7fVksJDd30zZ
	2WFqjPWsFl0tRWGTm4b8ycoJya9WY2Q/s08wV2TpO1UUXvPcb5emiU6M=
X-Received: by 2002:a17:90b:3f8c:b0:354:c7f8:6d7b with SMTP id 98e67ed59e1d1-35693dbbc2cmr1055213a91.27.1770877585308;
        Wed, 11 Feb 2026 22:26:25 -0800 (PST)
X-Received: by 2002:a17:90b:3f8c:b0:354:c7f8:6d7b with SMTP id 98e67ed59e1d1-35693dbbc2cmr1055206a91.27.1770877584981;
        Wed, 11 Feb 2026 22:26:24 -0800 (PST)
Received: from rhel9-box.lan ([122.164.27.113])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3567e7d95d8sm4894122a91.2.2026.02.11.22.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 22:26:24 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v4 16/31] i386/tdx: add a pre-vmfd change notifier to reset tdx state
Date: Thu, 12 Feb 2026 11:55:00 +0530
Message-ID: <20260212062522.99565-17-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70913-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1F3E612AA2C
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


