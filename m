Return-Path: <kvm+bounces-69202-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aBFvHDFLeGn2pAEAu9opvQ
	(envelope-from <kvm+bounces-69202-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:20:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D926790129
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:20:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C6B0C307C952
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 05:17:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B828329387;
	Tue, 27 Jan 2026 05:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dp/nYSdT";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nSHVcdrs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B9F15B971
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 05:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769491058; cv=none; b=R6iC/fkdXw3y5rasWPMQ7KMTLNqmTWiTNfkRnfKW6wHt53LBLp/+mv+LCcQiPHIu4ZJuTxErJZnK/2lmsjFpfu9pr1YBadaxla4kDIEtzUQ70c1OmV8A5Plz0hL2h651UDmcMYZyeFgxlPp/yWPcoLo1G5vMu5ByfDITmIbwUus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769491058; c=relaxed/simple;
	bh=MMPQOtueYyfYAi9/YwX1kbumpTMHJ9Frd2WB8qYubdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXUDeQ1CJT00VFCU4SLUU7sRIpjbP359qaxkSuajYjxlKzzTWJhtUqHyLYrPUtBfy1hkYQVWuIbphJA8xoR4kHgLyAuvz52nN/8TFy2ZHFs36E1uZzeQxlq6qPgZwmEQYldy8hu+AJImBDJcvJ+K2FU8O99JW/DRrKEKmEI1URI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dp/nYSdT; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nSHVcdrs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769491056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IsqW2ttd3J7072Zyk2vnpxdf7DB+tWB3Z4Y7tUzOjnk=;
	b=dp/nYSdTZYlgV+GZ+dTmeQ+tlHf3iknMzfCq4zonaVbcOJpN6C/gBO+d7FNxZOkh+4CMb9
	t6QvfWjQaSfSOmHAs5O1ntFE96XCcUSoepgxdov/iATGDvPUR9GbiJUgiD3+CvqNZchmpi
	2CeQHSrbFKUAe34v9FXV65S6U6kNhWE=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-VJ382GGzMSqIuWTcp0bxuQ-1; Tue, 27 Jan 2026 00:17:33 -0500
X-MC-Unique: VJ382GGzMSqIuWTcp0bxuQ-1
X-Mimecast-MFC-AGG-ID: VJ382GGzMSqIuWTcp0bxuQ_1769491053
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-34c2f670a06so5171792a91.3
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 21:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769491052; x=1770095852; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IsqW2ttd3J7072Zyk2vnpxdf7DB+tWB3Z4Y7tUzOjnk=;
        b=nSHVcdrspdpXMAc2nIiXll/4y/mxDHZoTgFfwt2I2siaukyCCp0amvh30TDoYgpRA+
         8A0KwI9oQuTwt2aIAja05tPseY0lGBN+a/QCiKITk+2wAGoqzbNkTgAZNd5uLfEQR+Bv
         tMhZZMpRaEY77JzdWkImVqQ4/xPvGT+NRu5/DX9Pi+eENjP17CTrVzaGaykmkujUByRV
         Rc2tY+1IuVwCUvtDWRLft92dgS8AaOsR7v+WpIxAtre9yTEoGn4yAwBj0nt8nn45T7JI
         x+s2260CbYczwWPGscoSA8BI2RRbPcJKWaokhQvvK1I5R4VUbPd7Gl+mXLLMx78H73oW
         9nbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769491052; x=1770095852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IsqW2ttd3J7072Zyk2vnpxdf7DB+tWB3Z4Y7tUzOjnk=;
        b=BYr8zigmzuGho6VQRTB39QBWFGXT+XqaXaM4ne2PiE5jerMyD3XyC4QyrhPo6+lhGp
         ikArO/CvRztr7Dg8Ix01T6gn1fvITVYKjYk6yINbnus1DRLD+2retDvJMWK764/4ojkc
         /PxtW58WQSHaBChWPQAptBzO8/Qfu4M0O2sBa/M9ADCtP5K8K3Rc4pp8C0yqY9IkELhl
         gaY1J1YNZ4YsewnvdWojUo7yWpklf8DIcbZePOHQRPHs11Nhhp8eJ8nxMgov3/pisUj6
         zMF9JXdSqHHC+V4yQgeyPUc/5/Np1xNDoEYeI41m1UHY4LBmXl6JKlXbb3mBg+r4jKaS
         9h3Q==
X-Forwarded-Encrypted: i=1; AJvYcCU75ysdj3VZQ4A74TALlZU0KALJrEHYRpUG42hR4GkYtpdDvQx48UjXTrryy+jjNeSv5h4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzl38jRwLN3arC0YX3YbAvW3Kup2JyhtiIkwEtvSlT4A/zEFMvP
	Hq2v7Nnbog4On/U8vKpHVeELXhP41Fz1OW9AZzGInWCK0XL1Cr+MRSUZRDHESwV19jTqfNdh1Mf
	uIJXI/D3Gmw5H4JtoM/AjGQqP7Fhdrc0czeQqg4EciT/jftdnrB/QHQ==
X-Gm-Gg: AZuq6aKeK0sdjPUtzN+R8NyhhfYCF3xN1y64lWYatnxEqNnlqhGrTqhYzThRveU9qkb
	tIbpzF+/Vt7YQCbzej49kkCkwZ8X5Ezs6jQGPNUAd3tFfnvzhwcKPXnoGsIyuN0jmBjmcQmqHlX
	TF+xq/m2TrCdYFsEbLGXWffP9MDWQSCUKipo0cwcenSWZmQeJbY0zVTiQvr9f6e8PBeEqc4RSS7
	ArIDPRY9Prcigkp7KtebSEYjujRTIIyCDg2M9FA42F6IS6DaPCVmQ4c09Y93WROWGv6kDkCfFcg
	UN0kN7i0Nj0+DVihr51U90Gmn0fjCj1sgKMQi4FPAbSqttj6tvaXk+JdJpIuopytIUEaNRhER3K
	/tZFUgq+O8a5vRrmwtnKpp4CtUajqKJbrHt4FVYhzzQ==
X-Received: by 2002:a17:90b:57d0:b0:321:9366:5865 with SMTP id 98e67ed59e1d1-353feda367cmr685550a91.33.1769491052474;
        Mon, 26 Jan 2026 21:17:32 -0800 (PST)
X-Received: by 2002:a17:90b:57d0:b0:321:9366:5865 with SMTP id 98e67ed59e1d1-353feda367cmr685537a91.33.1769491052087;
        Mon, 26 Jan 2026 21:17:32 -0800 (PST)
Received: from rhel9-box.lan ([122.163.48.79])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-353f6230d5dsm1110925a91.17.2026.01.26.21.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 21:17:31 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3 19/33] i386/sev: add notifiers only once
Date: Tue, 27 Jan 2026 10:45:47 +0530
Message-ID: <20260127051612.219475-20-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69202-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D926790129
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
index 5524e7142d..a65a924fb3 100644
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


