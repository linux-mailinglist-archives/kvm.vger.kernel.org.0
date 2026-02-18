Return-Path: <kvm+bounces-71237-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id INboG0KmlWkQTAIAu9opvQ
	(envelope-from <kvm+bounces-71237-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:45:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 017B415603A
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:45:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7C0E23043BF3
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 11:43:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C66F30DD2A;
	Wed, 18 Feb 2026 11:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KO5sb3fh";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ADBE2coc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576D22FFDD5
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 11:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771415032; cv=none; b=aRAecPGJ4jBU0yB4lQbDveMfYXufCiRVxkjS0XAsf5XUwbsKghGs4zzTKSnh8S50BbyunrkqMmr/2ctLKbLkeLSZ1W/abSk2cbPe3pTdCgkY3HOmbl4HkU3JT1Dm2VyDFXGhuGF3CjHntf5SR33gTqF7ChwSvpbGZ6PayIQctok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771415032; c=relaxed/simple;
	bh=23O8pVjgWHoWC3mZeSu+Sniei65Eb9tIswTBaM/vPso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W836c8GL/mzwyFwaO70O5nmdolJAyaZjP0BH5srAg6cDdz4wntlfWDDkt8TDnj+y093jVlTGuD+x1OSlkxABU3QM9f06NK8OoRAsYdSWxse1XW+0dBpxDfycpF/LyvO+/eN9k2/KUa1q77j8QQCrZ2mTpaVa3QxzWLYiEtKY3fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KO5sb3fh; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ADBE2coc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771415030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6P5ZMHhQ1gBULl+0OpCFy+J1BWjsvb7Pt0GdIxytUuE=;
	b=KO5sb3fhz4Gz5DYAi7ho0Do1YbbEwe37tsCpMyS8ysq56OflO+b13ygM+IGEM0zwQJk7L9
	Q39LrIvdqLfPuyF5PpNe65QVyoG+ihhgjG96/2R8u7uDfhyikIUhrP3hjVXOYNNHdz8zbG
	JLv59ty4on4MlcdUPctjUkU2ES+GYlg=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-349-_mtfVY3SPX6H_XO2p68nXw-1; Wed, 18 Feb 2026 06:43:49 -0500
X-MC-Unique: _mtfVY3SPX6H_XO2p68nXw-1
X-Mimecast-MFC-AGG-ID: _mtfVY3SPX6H_XO2p68nXw_1771415028
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2a946c0e441so53230325ad.1
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 03:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771415028; x=1772019828; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6P5ZMHhQ1gBULl+0OpCFy+J1BWjsvb7Pt0GdIxytUuE=;
        b=ADBE2cocJsIWv7ED/iuU05PWM4P8i6S5/W+vq+w2kgxd24Owvk5DDjcmggX4hONUA9
         HET7C6SSGV2tjhY2i4kcVbbezTBWIUf/TvLZ9fPKTViRAGua6jzD2zSk3EZnngSvfqVI
         2dNbHVBN7EAkwENqi8vsDIZWvLk6P5Y6aSKWQBEC9USDyshsCP2ONYGiAlVyhGW2Lo3G
         6rLKz0r88qERN5RxsSIvZljw3H1h5jTZhBABZpzZXVlpVh1vbXAi5uxumXMFp6wxKA34
         WvPQ+5+Kgn7aKASQg5c7oyG7dg8F7DyeCfyAARun0S4C8aeI+016h3872QHgHq4mR/Ll
         2SOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771415028; x=1772019828;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6P5ZMHhQ1gBULl+0OpCFy+J1BWjsvb7Pt0GdIxytUuE=;
        b=frDnZO05tQ202xRpVBy5VbwcLkRiHXe2SpinA4RS3OqNhCmS65LLn6nrTWaqdw1cmu
         A8JdZjBQaBXVS84UgYVQNuwyaMgvmvgBHjvL+psqRni5+zaFhmZglgTk4YSri8hIBZJ3
         ccyr4xWnWPDRI5pK75rs5qQc0lpaIZEeqIvWiv+HzueAFw0MciQ3N+Zbo6v7+YUkEMeR
         IroNYAYqiJqAzlmLJytQ0hBLHbi25ya+i8dQTAcsjD5l3LalydHQl1yzAggPz4P6L5xy
         iwUj/euORwcuMnkstAvocbxyJcAngM/Mdj296CPqMu/ffnxOI9WAE6BsJv6u0H1FXl6M
         e7oQ==
X-Forwarded-Encrypted: i=1; AJvYcCVswEkrI/oXMTUzlZuc6jIvHA5Ij7ZzCMcWLR8McO7zNAxU3CwRqIpCpE74w8lQXQGKAqk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHh6vSCNikIBNx4uRFGzl21JCW0ZLleAI9l1HRX3KfTUS5Vv0n
	W0oP01Hrqd3s4PjJEVnWV8ygMJPscrnAF6ReyyDvsWXpj9F9tIk+SeaQ0AiPaS2CR8N0q6gouEW
	J3ri5BUBypH/pbmlv9B8gxBi4rAVnZMxIsGaGYVyxmS1uA3ZfIsfZAQ==
X-Gm-Gg: AZuq6aKhvftmt4wKX3A3S15mq36Uo/BZSht2i2GzddzrmlX5nhm7WuTQDq3Q/FH86Uq
	CGkXJBExeV6I3WhOqzXrLy/NLBBQ4Zo6kDzyjfo4pm+h4WsvscpNLgLrlesVYcd/Mt4N/LeKjji
	lSc9Ux5PZYkoBAO4fqYMKAqw5w0NWBXkyrj13+DfVoj82qCS1IIY/uZywseueoc++ADLhAe06B6
	9IOCOxpVwj4Eqheoc9XXrCIOH4mzzo07Z9Z70/ivoewVuDLybBIm0++As4WkLDxKClrp1ybSx2t
	uXwpkh2e2kfJ4nC8MD6xdaJMK4SGUEoV/00q1XO5m+pkK4OpHuYSYvv9PsMS5vce1/Er2zVrpRC
	rZT05nOj8biUHiWPKMlJQGD29W1UcyQA1ev0zjaFkE+AR3UD9gaw6
X-Received: by 2002:a17:903:19e3:b0:2aa:ffa0:4454 with SMTP id d9443c01a7336-2ad50f5fd5emr17898275ad.31.1771415027869;
        Wed, 18 Feb 2026 03:43:47 -0800 (PST)
X-Received: by 2002:a17:903:19e3:b0:2aa:ffa0:4454 with SMTP id d9443c01a7336-2ad50f5fd5emr17898095ad.31.1771415027447;
        Wed, 18 Feb 2026 03:43:47 -0800 (PST)
Received: from rhel9-box.lan ([117.99.83.54])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2ad1aaeab38sm127803425ad.82.2026.02.18.03.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 03:43:47 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v5 20/34] i386/sev: free existing launch update data and kernel hashes data on init
Date: Wed, 18 Feb 2026 17:12:13 +0530
Message-ID: <20260218114233.266178-21-anisinha@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-71237-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 017B415603A
X-Rspamd-Action: no action

If there is existing launch update data and kernel hashes data, they need to be
freed when initialization code is executed. This is important for resettable
confidential guests where the initialization happens once every reset.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/sev.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 647f4bf63d..b3893e431c 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1773,6 +1773,7 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     uint32_t ebx;
     uint32_t host_cbitpos;
     struct sev_user_data_status status = {};
+    SevLaunchUpdateData *data, *next_elm;
     SevCommonState *sev_common = SEV_COMMON(cgs);
     SevCommonStateClass *klass = SEV_COMMON_GET_CLASS(cgs);
     X86ConfidentialGuestClass *x86_klass =
@@ -1780,6 +1781,11 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 
     sev_common->state = SEV_STATE_UNINIT;
 
+    /* free existing launch update data if any */
+    QTAILQ_FOREACH_SAFE(data, &launch_update, next, next_elm) {
+        g_free(data);
+    }
+
     host_cpuid(0x8000001F, 0, NULL, &ebx, NULL, NULL);
     host_cbitpos = ebx & 0x3f;
 
@@ -1968,6 +1974,8 @@ static int sev_snp_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
     MachineState *ms = MACHINE(qdev_get_machine());
     X86MachineState *x86ms = X86_MACHINE(ms);
+    SevCommonState *sev_common = SEV_COMMON(cgs);
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(sev_common);
 
     if (x86ms->smm == ON_OFF_AUTO_AUTO) {
         x86ms->smm = ON_OFF_AUTO_OFF;
@@ -1976,6 +1984,10 @@ static int sev_snp_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         return -1;
     }
 
+    /* free existing kernel hashes data if any */
+    g_free(sev_snp_guest->kernel_hashes_data);
+    sev_snp_guest->kernel_hashes_data = NULL;
+
     return 0;
 }
 
-- 
2.42.0


