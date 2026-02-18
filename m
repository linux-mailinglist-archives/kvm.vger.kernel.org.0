Return-Path: <kvm+bounces-71235-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QCJaJTOmlWkQTAIAu9opvQ
	(envelope-from <kvm+bounces-71235-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:44:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1999715601C
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:44:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 53F8630401A8
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 11:43:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CCFD30DD2A;
	Wed, 18 Feb 2026 11:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N/G8DYk+";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="feU9xAX/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FA72FFDD5
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 11:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771415027; cv=none; b=MjZUiEn2cuzLxH4wnjqqwTDXK4SGlVTPnOj2gZIKxK+l4lM4/0ZOQ26jdR/gydM8HeA6rfDrcc5rfdbeE4PRYM80l5PFcRyOfm7k0vVdpK9iAa4xCgdoRS5uUF70fN4f2vD0zOSb+odjAK/XLAiBQCodvf1JgDdhulPY1sRPvik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771415027; c=relaxed/simple;
	bh=F1HF7CtknAnoolSFp4CwIG4K96u9dm8fn197DYkJjJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiElEukCUqCTpXHyygY+RW7G6c/dXAassh8JIxNZjk/WV1C+JRtmHyAQtyqVJDfH+UunoRPGV/ndSNfw7NriUF9kBiol/lsdW5k3CurPENMkq65X3Dh2X8PNZAlbV4mmDwJxhILfjw/yy0FdX/WJDSn8kaZ6kebhkIGjXAkfF8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N/G8DYk+; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=feU9xAX/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771415025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=av9X0K8K/0DXwv9tLYeu3Bap1JDHpXgcHRbzm207TyQ=;
	b=N/G8DYk+IlZDgq83edAr5LUC1UIw78lLM5hUjlftlkogsi62oU3RhhjN2NOFntZ8ywTFv0
	/uIX0BKJn1qWAyhrQU5ZZgdjf3oiDGY0O9SC6xfd6gk+kuy4ZMWjQZrwLNcTG+K5v4ASoj
	wkJqirhFzNqlhFixVERjWadRUvKv+8I=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-Ek_s2-VXPEiDxjG_Ma4V9A-1; Wed, 18 Feb 2026 06:43:42 -0500
X-MC-Unique: Ek_s2-VXPEiDxjG_Ma4V9A-1
X-Mimecast-MFC-AGG-ID: Ek_s2-VXPEiDxjG_Ma4V9A_1771415021
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2a944e6336eso304899885ad.0
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 03:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771415021; x=1772019821; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=av9X0K8K/0DXwv9tLYeu3Bap1JDHpXgcHRbzm207TyQ=;
        b=feU9xAX/FCRJXqnM9aITmbs1QMK9TZdAOHJHkIUTZKJgjBnI6tCpivaQkvB4nsra52
         QjI0JBaKRsPgP6g5c6FxcNc7ttM/XlcdFm0aXrnaz4BXNQadCWR8NSVkQytFNCa3KWZC
         qnBI0N8mAW9g47aaIMC4FnX7HW4fMrbRazxHd6x9D+PSituCJaIEj7hoKTz4UQwewjRm
         WQh+VEgP8eD2oRMJ7qvH7wZDqC7ej+7+mMenDoEKakxJpAXJM+FYyVEUIouqQUciNHpZ
         3sDQxR4m8db5ytYS02Jwg4zUYn7UMuZ57cqxbbRnWwe+R/GBS7uYVpHNqoqcps7p+fut
         NdOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771415021; x=1772019821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=av9X0K8K/0DXwv9tLYeu3Bap1JDHpXgcHRbzm207TyQ=;
        b=egErdrya0dG2+8eDTGQ54DEGPQ6arXoXvWymgGK6qeFFWAohMsWb5iqdOzQMZDhJx6
         ffNT1C/Ei+l+BCLuG4k21B5IxtEaTzpqy7FfsS/xDpLEAUzF4wGQMzpLMqfwQYeBlJI3
         /jewIV3Ja19MP4v8uH9/ouF7xPcsrgiTlheAWVYIiMjgoLDaucwsLZIOz/32g4f2n2Tz
         j+3zsHya6ZMiBlEenSLvwWxBE+hZcelYQHcDMF+qy661I23O2MUiyVEs+qJZAnEr4tsd
         2DljHtnKksgcvbKoAXi2kTxzZSfnFMI1TBNil7Btby88gwJ9GhluKtqnfkSq0KBMs0ma
         7wLw==
X-Forwarded-Encrypted: i=1; AJvYcCUVTd3TOlezresHmn4TNqCX2JXQSY9zrdkJBsS/zWJQtJCTmC749h3wQxUax0whYmDpmfM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxH3N9eD7+LSU098VQcR24DASSYyhmOBXvL1kBY1GF0Hq0AgL7E
	YEprhC7tGyPM3/il52Yvsqem/eyK92E2lFalrcNaPD+tHmO7CvSWp+DBDL/G0hsroXNLbuKkuaN
	CdI2Q5VsvCKQr0dckBUp1JF7TfFK4bwxCfHDqTnmpOaVJY5U/P1dnVQ==
X-Gm-Gg: AZuq6aJmeFomaO7Pawi6syfz1s28SpF8NyHCmJWdUXAuUeT1dZm7unOn6LpOEBNfZh3
	ubHmNwZYmaBdMXD2Tn6QLnlLw9UR+aHu6Jijm+1yoyGzjQb0TnazXomUvMevjHF9ceAFyNS7u7I
	kgVk0pOdN0k00stR3XcdAJl3FNgBF2Bp5cgNHpeVCUHTWYYaxOyYUvmaqSaYIxtQ+5zxs3hNF4s
	kDoNcbh97MGmxRawohsT1GDqa4VJhGOrVHcw5Zqo3gTMguOuP4BIuWBZpdBOBD3lnJ1J/80uqgb
	uhe/RPnIBb3m+YOb1dj+D6bucJ8TsujKu4uaj3PHZV5Tl1swDtYft08Hu4hS81/nKQE84MtSAmd
	wA0Itz4KRogxxEqXJNJwJ70V5KeWFL1UboKTotq24sSyuDI+67DXW
X-Received: by 2002:a17:903:2b05:b0:2aa:3b3:d633 with SMTP id d9443c01a7336-2ad50ff1164mr17117435ad.61.1771415021476;
        Wed, 18 Feb 2026 03:43:41 -0800 (PST)
X-Received: by 2002:a17:903:2b05:b0:2aa:3b3:d633 with SMTP id d9443c01a7336-2ad50ff1164mr17117305ad.61.1771415021124;
        Wed, 18 Feb 2026 03:43:41 -0800 (PST)
Received: from rhel9-box.lan ([117.99.83.54])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2ad1aaeab38sm127803425ad.82.2026.02.18.03.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 03:43:40 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	Prasad Pandit <pjp@fedoraproject.org>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v5 18/34] i386/sev: add migration blockers only once
Date: Wed, 18 Feb 2026 17:12:11 +0530
Message-ID: <20260218114233.266178-19-anisinha@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-71235-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,fedoraproject.org:email]
X-Rspamd-Queue-Id: 1999715601C
X-Rspamd-Action: no action

sev_launch_finish() and sev_snp_launch_finish() could be called multiple times
when the confidential guest is being reset/rebooted. The migration
blockers should not be added multiple times, once per invocation. This change
makes sure that the migration blockers are added only one time by adding the
migration blockers to the vm state change handler when the vm transitions to
the running state. Subsequent reboots do not change the state of the vm.

Reviewed-by: Prasad Pandit <pjp@fedoraproject.org>
Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/sev.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 66e38ca32e..260d8ef88b 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1421,11 +1421,6 @@ sev_launch_finish(SevCommonState *sev_common)
     }
 
     sev_set_guest_state(sev_common, SEV_STATE_RUNNING);
-
-    /* add migration blocker */
-    error_setg(&sev_mig_blocker,
-               "SEV: Migration is not implemented");
-    migrate_add_blocker(&sev_mig_blocker, &error_fatal);
 }
 
 static int snp_launch_update_data(uint64_t gpa, void *hva, size_t len,
@@ -1608,7 +1603,6 @@ static void
 sev_snp_launch_finish(SevCommonState *sev_common)
 {
     int ret, error;
-    Error *local_err = NULL;
     OvmfSevMetadata *metadata;
     SevLaunchUpdateData *data;
     SevSnpGuestState *sev_snp = SEV_SNP_GUEST(sev_common);
@@ -1655,15 +1649,6 @@ sev_snp_launch_finish(SevCommonState *sev_common)
 
     kvm_mark_guest_state_protected();
     sev_set_guest_state(sev_common, SEV_STATE_RUNNING);
-
-    /* add migration blocker */
-    error_setg(&sev_mig_blocker,
-               "SEV-SNP: Migration is not implemented");
-    ret = migrate_add_blocker(&sev_mig_blocker, &local_err);
-    if (local_err) {
-        error_report_err(local_err);
-        exit(1);
-    }
 }
 
 
@@ -1676,6 +1661,11 @@ sev_vm_state_change(void *opaque, bool running, RunState state)
     if (running) {
         if (!sev_check_state(sev_common, SEV_STATE_RUNNING)) {
             klass->launch_finish(sev_common);
+
+            /* add migration blocker */
+            error_setg(&sev_mig_blocker,
+                       "SEV: Migration is not implemented");
+            migrate_add_blocker(&sev_mig_blocker, &error_fatal);
         }
     }
 }
-- 
2.42.0


