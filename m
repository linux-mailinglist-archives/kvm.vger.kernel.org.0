Return-Path: <kvm+bounces-69200-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iHmJEB9LeGn2pAEAu9opvQ
	(envelope-from <kvm+bounces-69200-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:20:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A422C9011A
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:20:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C93B1307340D
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 05:17:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BE29329C49;
	Tue, 27 Jan 2026 05:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fvfYz+Y9";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="NHBKUj/C"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DEB329387
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 05:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769491052; cv=none; b=qfxUajvXGV5CK1hLd4/eVfzXUd+4tMjrp6eU0I8P+OWmEB3QgiTa0H+JQ0vN3z8ojLQjcCrOvjcq7QBe3olr10TE67cztbi3Vv0eGwCjxc24Wxzy/DWfaEAqOSIj1swmtbd0JRgaQeyIFkDgqmYzsXRO3C6uXYoMtXAJdfQF1Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769491052; c=relaxed/simple;
	bh=mYHykGSeRol6qPb0O2RCz5WVhoAbFlEQQPuIWA8vy2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blGC5wYQhd1me/Ad/UNzfLRq2Hdtf8hjUUWQm1iEjOiI/OEPw5U26jOYioH75ae9K3df3NINzkUXdrX5iFK/nIoN6jAnvGAPUm0dFbasv3I6w0E/a4LWGOqTPiYLgJFFi/Mq4ic+ujSg9KQCKwSwz3zPDAZdmWQ39Fa03eUzYaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fvfYz+Y9; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=NHBKUj/C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769491050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bPhZf11AJ6OznTneTjtivFAiVtwbcW8pDml41uWPO3Y=;
	b=fvfYz+Y9MwdWc3x4DZJeSXEXneEIYugl14iYoiRuS1hPj0uR11Aupi/PplTtq2Luca5whE
	Jr5oBl9fn9hC+8pyH//rCvADO0tP0LjGOVz0D1eFb331OmJuJu7nq48YQ63DBtsAW49bsl
	U+DuoH96VAhZLXMfe7uRhJn8wLO0Qdw=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-68ftm4uaO2eeJnRKU8lEaA-1; Tue, 27 Jan 2026 00:17:27 -0500
X-MC-Unique: 68ftm4uaO2eeJnRKU8lEaA-1
X-Mimecast-MFC-AGG-ID: 68ftm4uaO2eeJnRKU8lEaA_1769491047
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-34c38781efcso4921074a91.2
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 21:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769491046; x=1770095846; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bPhZf11AJ6OznTneTjtivFAiVtwbcW8pDml41uWPO3Y=;
        b=NHBKUj/CUCxnTpH3gUnYxQqKDajAhOTxj6IY5mAaSEH6QPHAQT5Cr7Vv+tjKHRx39X
         D2dT7EW9+0aP1IX/xEY+DOWbXJx9Ew7AkrpgcxSu4C4Z1fBK70m7lddl5MoSUoQcNqPB
         6QKk7jZTeY2JERCpKwSgQwppSDK5tBY9Vit0H0j06rM4itw1YZuU8ahGdHM3humijvly
         FIWDramd+lMT/Mg94C5WxJP4GXH4Vf2YRWYKW0MIkNlRkud6qFZKJevJ1J1zVofO9Fwz
         93y9rBKMuVE4561iqvOrqGhcWwhnvyjJp8Aw7r+qaYboZcRVBE8r7R5HcN+yj+6adH8q
         4GgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769491046; x=1770095846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bPhZf11AJ6OznTneTjtivFAiVtwbcW8pDml41uWPO3Y=;
        b=LAqZQA7S88Mu25BYf703US7JGEpKTkfVHkzt3IscAphAouui/bP/x6FuOMFoRQJKf+
         FgQrueXTmRNc8CVEJH5j9WMFK2BpcQFaY4wd4T6yIZ6VG1CeIqmR55Fpc83+RSceRJn6
         6YFEGOq4ioCwxwPCdOTpOzAVxpBau/qUhi65VhMFHnOtpxg05m1kO70gQWTpiMpKBJMN
         fKwAmqa+XEIZSbsvwUTPTATlNlrqp1HifTcbPa9Ft00YTBxdjxZagLsPTAvLPxCt0quh
         WxSyBI/d9N+TSo72OehBHqsKp/XvkwpV6W7yJ50ypL9NRQIcGtHeOa7mZFXqPDQOntE1
         lrEw==
X-Forwarded-Encrypted: i=1; AJvYcCUtp/ftL2vmRxSusXwBiKhzyEvJ7hi/aNmNRcvLGvKiVzlS0ATI3IC50+FpsRo6hw4IIUA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwluAQPMGXaNDverYUfZE+DgMLVgARcWvJYnITdTljLzh+5k043
	L7cczDFRiK7Xqt5VER+Vx/ukfy0FAPOKst/uGhJ7OR6w/NTnG/Xq0acTHeckxuvoSXtIuupHhkf
	icZ6+CfdI2GEYHbt3IC2eGBg8Oj1Gr0Zvx9MhCtygAmZs/FoGX2KTAA==
X-Gm-Gg: AZuq6aJfcyxEEFb0A54rfbjWVhCLvoyrgAIOh/GTT7I1A3kk3NA5OXwV/Fus6SNnQ3n
	/QjF6BpNHgHXLY8KZ6CYGuEW3LLsQirjqbvJJ+71QViMzqyN1XOEMQQjGtGfrFkYNNcNXnP0Em7
	ppVFVwG2goMv0Np1M4amWjtiGWQDF9AlEow2oOIyRQz0KS128aOOpdgtxFyWULKCX2335oI5HK3
	6vt7q2GMbIP7sqIdq2bEQvxUefajO/aqkB7Jv7OVmj1cPkR5TkXHCmy8aBtuDaLW+0XwTfoKMg/
	/UEHf1d8u6b47vXfEZs18Jp0Go0iYlyW4nBH1zix19xmyNQpxVcawKR2lDc3i25pcOIevA6YmwC
	YAl3WFOYpsSyRSVCYkuKPNCxRwcv6kAsqgL7g4nDhXQ==
X-Received: by 2002:a17:90b:3a4f:b0:352:e27e:79c5 with SMTP id 98e67ed59e1d1-353feda98damr596443a91.31.1769491046555;
        Mon, 26 Jan 2026 21:17:26 -0800 (PST)
X-Received: by 2002:a17:90b:3a4f:b0:352:e27e:79c5 with SMTP id 98e67ed59e1d1-353feda98damr596430a91.31.1769491046173;
        Mon, 26 Jan 2026 21:17:26 -0800 (PST)
Received: from rhel9-box.lan ([122.163.48.79])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-353f6230d5dsm1110925a91.17.2026.01.26.21.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 21:17:25 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3 17/33] i386/tdx: add a pre-vmfd change notifier to reset tdx state
Date: Tue, 27 Jan 2026 10:45:45 +0530
Message-ID: <20260127051612.219475-18-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260127051612.219475-1-anisinha@redhat.com>
References: <20260127051612.219475-1-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69200-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A422C9011A
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


