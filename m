Return-Path: <kvm+bounces-71763-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oL9eI/pxnml0VQQAu9opvQ
	(envelope-from <kvm+bounces-71763-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:52:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 37F7B19158D
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:52:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D913430FE1DC
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 03:51:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99DE01DE894;
	Wed, 25 Feb 2026 03:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CC59T1L5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fL7fof4e"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2EA1DB34C
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 03:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991480; cv=none; b=dKEA3tp9OBJvjZ42tZyxJ2dyHrKVokUbSxxFw3qtPrINyk8YSdavKiVsDajNBeSekkzF9/iwxJ6rPjqoNDHzijK8I/Dk2kQD/5f0MrHMbRaSjGEEagrMbZVE0wWE2vHrwmiDe/Hczc13QWXaUNNCJc9iacPqcePC3uFhQ9udAX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991480; c=relaxed/simple;
	bh=oyuneKzvdez0/AzYtX0YpwFHbqcpf5Ank1kplg3Akrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZZvmmXhlfQSDBsmBM1VqCtOzylH1r4ZXuaEXVDGaFJJkd00zFiA9kzKTFkxxjN0pLFbPUWkgjfvu53GPHH8vGYbdEZKht1DHys96Tb6pKCDYEFJMnwUcagMeQNJY8z6+SWgAAqcBRov9AOr0bh1RnLznqA92UdNs+zK9RCLVEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CC59T1L5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fL7fof4e; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771991479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N2v6djobNSdTdF+YCpvzDQ17kkQi5jILZoPxzgDYLR8=;
	b=CC59T1L5KncXP9Chj8bwDPmR4hwA2HMZtL1UdSCQK9w178TjHoVT/SdXuzmT7jN7y3A+YB
	qA6c9+9G8YN4puUrfxxcPKlxWNSPyFHVxQThW7/3ln1/8FqSZ/gA3OdZkHpFKojjloG2Jg
	I4fss1GMEz+gCDWWD5z/x510PoXxct0=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-0-ac8GxJO8SQJlCbelCCGg-1; Tue, 24 Feb 2026 22:51:17 -0500
X-MC-Unique: 0-ac8GxJO8SQJlCbelCCGg-1
X-Mimecast-MFC-AGG-ID: 0-ac8GxJO8SQJlCbelCCGg_1771991476
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-354c7a38429so310462a91.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771991476; x=1772596276; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N2v6djobNSdTdF+YCpvzDQ17kkQi5jILZoPxzgDYLR8=;
        b=fL7fof4eZWnzNEUB2FHsSJlwv5Yifdd7amqEOCge0wXtAHJoBtFh8nxqF+t5CfqMaK
         DwTfj7/o3X++A/q4BkJQq+go4WH26NTbmLGZl4nddbXK4q2IRmAUJrn9CJw6cyXs7jHv
         C1I9uqs4+IMH4REsXnNlbU5UcAP+CKduHcvqJZU5VmZ75wEnNUrJOnL17AhsMhN9CniE
         mrvQRhOkMUVfEu1SStSzOkCHITf8uaObjFNg+SHw7rORIk1IqDQLNkW/ZlDIKffl5Pz3
         uavSiLfzh3am7q5ouWga83p4bnQj/2tnwfMFmKVC1ZFNSHTNq7vx5x9bMceB87oz8F+o
         jClw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771991476; x=1772596276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N2v6djobNSdTdF+YCpvzDQ17kkQi5jILZoPxzgDYLR8=;
        b=WvTFnDMYSUs6Jl2YKyN3V4Eqz1QrLLu51SLDOyXRzGFKdEc0lByJQKuIOvceX8DTWV
         N+5YUQC/Etap91pfWVJOmwKyx2vaaR4prxfrEytLip4WgeLrp6QKghLpLpb9Nvq8ECjY
         H2ep4IsKiNGSgc8PvfFaVqEMvny1aijxI9k65111Y+E5o8iTNZ0/ukaSD+MXa3XBckc1
         3AlHQP6lqoXNfFyGn9PuPNkT3GhbykKFkyGVp81RfBuvwEKsdaFBuCDfvKinjsmITxbc
         uIt1YjP6DFQEcy30TZTpKX0r5SyNPZGtsDmnrBvzr3qAA/Gwqx78q/hYCU+iu6v5vQM5
         mTbA==
X-Forwarded-Encrypted: i=1; AJvYcCUgCwzXQeeAfOpHIWrLcwvXsSn3nel/1mYsdvvAapDxRu8RzLM9E8nK8wH0l/CIaELj5Ds=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbMSEnZA8lICBVcUoo8Irj7HE5MtbCB3IQuhWMejNpecTXqpBa
	n5Cuv2NC017iBHlqJo0j1K7Z65d9ZVO28J/GvRrYKqfiHy7QQE7fgnvHPKyYe0rHPRLsii//YM/
	iTphnLwc7cMYj+CP0ngomIumzhbI7fOgL37edgPGaOjRGV95DktjXiQ==
X-Gm-Gg: ATEYQzz3fTvcRIw7LOZLySd00axFGwyUBjSRuicshWY/ZpksOGQCWUdWnq90jHY53Uk
	4MnKwkmCMlyr3qEucH+uDjB6ZIs1+RNtsnMjW2/jYpq1tIDnaqBuSrzdCnMmpJ0LuUKKstvZlum
	Girm40wfUutvlEJqhOn/7Xac4Tp3M/SSPvgKryIB4547KxsPxmf6cLsbq4s9IYFLTwe3Ssz9hIN
	8O+xPttxmu27pZGlE38heGbEQ7Ej/YYO9g+g7NYJ6ByFolQVghWAonW6hoXv+brvX5eyW6ObmTx
	TxZkFIYUxKSTNjvBUhNq8JAyEBEVeJ5/cn1ohdoPA4AfixozctO2edbAIQkCjKznrNWyeqJ2s+9
	NF4qat5OjQ+MA+zy5+XkCn/dVaj+OKIyA5puXL46Lgf+x6GCKESz7FnI=
X-Received: by 2002:a17:90b:2547:b0:34a:be93:72ee with SMTP id 98e67ed59e1d1-35903824bd2mr1989217a91.8.1771991475895;
        Tue, 24 Feb 2026 19:51:15 -0800 (PST)
X-Received: by 2002:a17:90b:2547:b0:34a:be93:72ee with SMTP id 98e67ed59e1d1-35903824bd2mr1989193a91.8.1771991475466;
        Tue, 24 Feb 2026 19:51:15 -0800 (PST)
Received: from rhel9-box.lan ([122.176.129.56])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-359018838b2sm1186006a91.5.2026.02.24.19.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 19:51:15 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	ani@anisinha.ca,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v6 20/35] i386/sev: add notifiers only once
Date: Wed, 25 Feb 2026 09:19:25 +0530
Message-ID: <20260225035000.385950-21-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71763-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 37F7B19158D
X-Rspamd-Action: no action

The various notifiers that are used needs to be installed only once not on
every initialization. This includes the vm state change notifier and others.
This change uses 'cgs->ready' flag to install the notifiers only one time,
the first time.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/sev.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 260d8ef88b..647f4bf63d 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1920,8 +1920,9 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         return -1;
     }
 
-    qemu_add_vm_change_state_handler(sev_vm_state_change, sev_common);
-
+    if (!cgs->ready) {
+        qemu_add_vm_change_state_handler(sev_vm_state_change, sev_common);
+    }
     cgs->ready = true;
 
     return 0;
@@ -1943,22 +1944,23 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         return -1;
     }
 
-    /*
-     * SEV uses these notifiers to register/pin pages prior to guest use,
-     * but SNP relies on guest_memfd for private pages, which has its
-     * own internal mechanisms for registering/pinning private memory.
-     */
-    ram_block_notifier_add(&sev_ram_notifier);
-
-    /*
-     * The machine done notify event is used for SEV guests to get the
-     * measurement of the encrypted images. When SEV-SNP is enabled, the
-     * measurement is part of the guest attestation process where it can
-     * be collected without any reliance on the VMM. So skip registering
-     * the notifier for SNP in favor of using guest attestation instead.
-     */
-    qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
+    if (!cgs->ready) {
+        /*
+         * SEV uses these notifiers to register/pin pages prior to guest use,
+         * but SNP relies on guest_memfd for private pages, which has its
+         * own internal mechanisms for registering/pinning private memory.
+         */
+        ram_block_notifier_add(&sev_ram_notifier);
 
+        /*
+         * The machine done notify event is used for SEV guests to get the
+         * measurement of the encrypted images. When SEV-SNP is enabled, the
+         * measurement is part of the guest attestation process where it can
+         * be collected without any reliance on the VMM. So skip registering
+         * the notifier for SNP in favor of using guest attestation instead.
+         */
+        qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
+    }
     return 0;
 }
 
-- 
2.42.0


