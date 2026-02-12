Return-Path: <kvm+bounces-70914-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KH6wMKZyjWk+2wAAu9opvQ
	(envelope-from <kvm+bounces-70914-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:26:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AA2112A993
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:26:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DDBDF302C0BF
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 06:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5019293C44;
	Thu, 12 Feb 2026 06:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gCF7EGxC";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="o+yzbUFJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8EA1F5834
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 06:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770877594; cv=none; b=WNoteQBr/BqQoEVsPxOrwk4HdFNQWl5pbIghKwkdlgmAvJi3TVAX18EjozbwpvsZz2yyS05DuGTuq6CIO8S13MnccrA4al84zL6cseWbO80U4RPPKfOUsLb97pUIbGKCiP8Jg0SXOVzrhG/dRgNslCI00gCp+dFEMJLXSWWJOak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770877594; c=relaxed/simple;
	bh=Qfww8xskWGY0l2yqfbl5ZM+NU0v6CV1mwUKI/6ckX2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPv+8VELHzUH7/teE5LBtaO7v3PiY7z9gH9DdBwcnHCO7AV1ucaLK2JaY5RVmGKYSzG3mE1TtoMjJHNvOmq7vzy1K6hplfApsbeRxBU6K4ssA+wNO+6pM6iolgbhR9Bd0XqA8DA6iL0XMVBPNkOHWMvTk8sf060kWLKCS9K7JBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gCF7EGxC; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=o+yzbUFJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770877591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8zpSCPimmyA0e0qP7Kcivb9yeJXq4znZSTQUpfrxyiE=;
	b=gCF7EGxC13Ru6MIzuuVXXo6QQjk+2VsS+lRBfRsnYiGHyc1w9mkTHjRodeh+rDdDvJrnEs
	YpNmxlfVNBt10VbSseGcjpzpuXd9kzy6KKonXtjdDwQkAYTrebKGO0a6jeWp8CiFoo93hM
	Bns4NDPyEWj7uGgqV0lM+n+hyGuq3Hk=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-LP9cvuThNPOBtF0HJb-ILg-1; Thu, 12 Feb 2026 01:26:29 -0500
X-MC-Unique: LP9cvuThNPOBtF0HJb-ILg-1
X-Mimecast-MFC-AGG-ID: LP9cvuThNPOBtF0HJb-ILg_1770877588
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-353c9d644b0so4402665a91.2
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 22:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770877588; x=1771482388; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8zpSCPimmyA0e0qP7Kcivb9yeJXq4znZSTQUpfrxyiE=;
        b=o+yzbUFJHxRi1jlA7Hytg0QWeDxCoZv69qS831QZPpkG78dBAWehP17WNg4upPjwH3
         WP8hz54gWJNfynEryxtdFlyuZPZjEmh3qZPcxkz9QoPxwO92DagAjOMkt11a6ycMn80C
         BRfBtxYo/NsKzGeAih4JH3Z4GhxfWA9s+xT7Bm2lxEiQD50wMF90aUfi2O/4Fzyh5Dmv
         FRSMxPZOVk9etg97ZgoaQEwjRLKHrUY5qgSmjEWGaMFo0HR4LSlIY59pZG03BHsArJDl
         kYpXzx2f2V8gqfhKKZ7rktqTe/GJrGqREdGoYXmVMRqBth7LQ9HzCg07c1Wser/aky5T
         BYyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770877588; x=1771482388;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8zpSCPimmyA0e0qP7Kcivb9yeJXq4znZSTQUpfrxyiE=;
        b=Z9l+8czobdAELe0zPKajFrX1uxoSQ58kfygCqmgmkjNSWs0v+5Ofv2gQWs12xsOoYE
         4JNXObp58KALf/y+4jwP6FEH58vKLMvDZQ7j3m2JihDrBWTY+R52NyxIk/ZmEJMRRBpT
         cGFal5jzNaP7ZVlV0vOlF0rErXUpRiieYq8Tqt9eaf7+2Qj3ByYg98Z93YYZhBcjxeIs
         WyltMtqD2JuVpcdrSmiUQUrXYIChiavB90BxjmnxVxaCqz0R4LNOo302ZcV9+dekRGj3
         0zKXKLKG90NbA+et92ICtrTJG3MZVCaAXxOGd2r6EsYP2iH1Hm9Gb9g6LzWM10qpSxhQ
         s3Eg==
X-Forwarded-Encrypted: i=1; AJvYcCV4n74BtU6YlzDA9RsMmjANo9K0qDZTjMe9FQ+KYu9q3ItS4Tr7lqYis1Bf+TYVUWspHdE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpR9PokQ1mJXWnCnCvFrj9NzINo1TC5rEfedHvDwPaBs8bjz1/
	iCRkuNdjvx0J6I/jI3Fgt0enkSJUVbWaPd/sFg4bUCTImn/94zP0BsYFXDSafnsifk46grAA/qm
	DpsyXa66zoPmjRbbC3JtONHsfbopPVycHW6shammsm5NRbVi7TWC+Bg==
X-Gm-Gg: AZuq6aLOfbcYWuB/Jgv8UWajCTIAqGZGrpdCS+NH5S7pSRkBKvoYiNkg3Y4pHolZA4b
	z/6szDEySSUsLyuHXnfDCzkXhddkQBcWtvJHjdTmxbxUMLCWbPdwDt97kJh2kz4lmU/K6B0wP8p
	S8zUy5wa7L2ZNOuw8qxXg/QH+pnFTbiB9QdOyxJ2eTSwB6zcIzb7YtsfC39+d3d59/w9oIv/f/N
	SyF/9/fjAiY+4cx7lx7cUFP8sICUVv64xEY+Kw6oCT28i/XUHyWyklPmwULmdGI3U9M8c/KXx+k
	sPBhjhCoUAqWSGxKntx928WB3jRtRyB3i4tXT10isuk+l4siJ0PekCPhjv2NEPm7iINvpQqlv/i
	f4OCQhLI622nWNuToFjp09kExtYXrLuw95xTOgZqZ5XfbW2mHx8KcNfc=
X-Received: by 2002:a17:90b:3503:b0:352:c995:808a with SMTP id 98e67ed59e1d1-3568f327382mr1457958a91.14.1770877588513;
        Wed, 11 Feb 2026 22:26:28 -0800 (PST)
X-Received: by 2002:a17:90b:3503:b0:352:c995:808a with SMTP id 98e67ed59e1d1-3568f327382mr1457945a91.14.1770877588157;
        Wed, 11 Feb 2026 22:26:28 -0800 (PST)
Received: from rhel9-box.lan ([122.164.27.113])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3567e7d95d8sm4894122a91.2.2026.02.11.22.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 22:26:27 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v4 17/31] i386/sev: add migration blockers only once
Date: Thu, 12 Feb 2026 11:55:01 +0530
Message-ID: <20260212062522.99565-18-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70914-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6AA2112A993
X-Rspamd-Action: no action

sev_launch_finish() and sev_snp_launch_finish() could be called multiple times
when the confidential guest is being reset/rebooted. The migration
blockers should not be added multiple times, once per invocation. This change
makes sure that the migration blockers are added only one time by adding the
migration blockers to the vm state change handler when the vm transitions to
the running state. Subsequent reboots do not change the state of the vm.

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


