Return-Path: <kvm+bounces-69203-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0J7zODxLeGkKpQEAu9opvQ
	(envelope-from <kvm+bounces-69203-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:21:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6439690148
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:21:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 421CB3081153
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 05:17:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06C42329365;
	Tue, 27 Jan 2026 05:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QOVPUB11";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jRObSBOD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94F332939B
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 05:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769491061; cv=none; b=DVIt8gQOLujDJUUS4ghXRDl4flMUlqb9ZqTP4X28SNfSREYjfa+i3gAz4VK79h1Ican8Gwf128hMLRGpYRFXgvhrv34XcHMGQVgu3NbyjdPrYL1LAkcbCFTviPn8HeflsIwr9KUVRJ6XJjYgfMCzEGfEIH+OhkmhpFOj0U1trWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769491061; c=relaxed/simple;
	bh=CwwCQBfgmsy4lULSaNzO3/8DRYgmLOKxOKf50gomfJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RbqaXJNDoaIaQqR+UI4PEvuJIgwNJD3+5FL4wzk0Ge5CQHFtCJceP9VAv3QG5y6OtyQBl2Ybj+Z4yk14iy57g9EVuqZ3gbYB12BhcdeJSrLSu+lVnJrEvw+v80dHYyBIxTZJllXIpZzdnrTE19KbCoCu3DzL/TgYeLRhgkFE2Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QOVPUB11; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jRObSBOD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769491059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0WZvtS1qnQEpVvyt8WDpPuTWCq46G5+n4cXSJcdfvKs=;
	b=QOVPUB11cOgJXa3MzZOb7BRb+2LqDEkpRhFHsRI2ZGZRytHGnwyQML9hGvol3Nl/xzYtVu
	MLkZpQbPwPgBdOCKr2b6RXtPLhdSwyZCZf5z9J67GasYmuqJ+UUvWXRuH0AxtZPVfMTW6U
	nEA2zie89w/KOvEgCiNOTIsRFKj4Gu8=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-wbW_6aVsPhSdmQp4I8UgxQ-1; Tue, 27 Jan 2026 00:17:36 -0500
X-MC-Unique: wbW_6aVsPhSdmQp4I8UgxQ-1
X-Mimecast-MFC-AGG-ID: wbW_6aVsPhSdmQp4I8UgxQ_1769491056
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c613426e8dcso8167565a12.1
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 21:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769491055; x=1770095855; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0WZvtS1qnQEpVvyt8WDpPuTWCq46G5+n4cXSJcdfvKs=;
        b=jRObSBODN+M4EA5Mwmbt/3w7+g336fda+AeKPi9sPOclxoFSrotLrwoShdleWYxNn4
         PWyFjHKw+WfeCsYEkc5IbLRt0tVqDEkWqNfVJwX1XNUcdQm4UoYMemoynwg8jd6S/2Xl
         Hdhbz9areXTaOVHpotwNBBXYmepIM82N/Pl8NjAlPN0SYYVXR3nmNkrPMBnqSajJA7p7
         dYYk6+CVFJbx6wjjbs7WboYGjPDpS5xnuQYm23S+U+rKh81KNcblp3bl0macMb5PLeJp
         5CLni80sawXezgDOPrLGbRnSRky1+ak56QZ60LoYhrjAiE7tnnAfliMIZ46eyr8Hkku+
         7HBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769491055; x=1770095855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0WZvtS1qnQEpVvyt8WDpPuTWCq46G5+n4cXSJcdfvKs=;
        b=wZz3hPNAys+oV0GMGcRZ6eUSjdT3WvlnitlMXxmbuPL53gNF97woIZz3lVvqgUsOQQ
         ortNez9UD4eW1ZuJAjWhbY5FEEM0m2QdU3wgER9sL9jhEz3kg9JXM9xExomH921GNyoM
         R9KeYvHWctrI0beROUm8Lxj2YdNDRQXhlTj0L9fxUF3GUH3+zghOfb6D2XGOfYxPgWdB
         I0U/UsWhIVdn3vtYjse4G0toZzCFJ2BUrMZPNwKrd0URwFFkp0SGZQNNBmsICB2YIBl0
         H4dKsjGeX8Je6wLfiW11tWjWj29AyoIllx8QvzhUpH9/qmRtmJOQHp+0KxmUfF+U8Mjf
         FgRw==
X-Forwarded-Encrypted: i=1; AJvYcCUEdjxyhjd9dRqrSGoXGm1L6vRYaTdSMFX8ACmdUTGLsF443OuzoNyT/HBaXTnCReOUG74=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRzE0GaAhll/5SPOjZ19k/LCZ0UFDFzcxUACm1FowxFW3g/Ke/
	sM4uQ/iB5yoqgzOmz4/havQ8lGGLwY2vs/VBtbRXtsNUDAEJ3kGNttb7Ve8B2sXT5Qwqt7IntOf
	2OlhNUzBuSjhvvsJaqt2B59y111zrf6d8ZJ61Fvs3WyMEqd8XpUFO8A==
X-Gm-Gg: AZuq6aK0xLnnKgEI7igTs002jKMDHSy+9PkTyePTyQwR8UMXlYFGyIEEJlWwCB0VlFV
	iqHkEm8uFGWY+LHID3RSGL9mL8YVgGoUnD9DJvmRSSuz983jyGpZI7Ku0VWBcvdVkmdpColTtT7
	7BT+dRKGe0faVbV6u7XEA4x8A3mrUMjhDVb+nXqmFtqTmdBX/tK0ETaC9plxFF3+Papq6xWhKYN
	CJ5ZoU5V+DAQqHrockVpdyS5IeBqcvQfQhgkCQnMbPWjXjCdS4TWTEKvm3edAiomdEsxtFmhwq0
	meGE/EW02nQoalv5C+ZXepg/Cc748dpxKYYqNrGkSHBbB0lo1B4DPufgnNy5CssJpU2APLwGhXH
	4YdGsJBdh1TFjkeWRjJAHnqgHOYyPHiq58hZKNR9eeQ==
X-Received: by 2002:a05:6a21:7a90:b0:384:f573:42bf with SMTP id adf61e73a8af0-38ec63fb1d9mr471153637.53.1769491055551;
        Mon, 26 Jan 2026 21:17:35 -0800 (PST)
X-Received: by 2002:a05:6a21:7a90:b0:384:f573:42bf with SMTP id adf61e73a8af0-38ec63fb1d9mr471146637.53.1769491055207;
        Mon, 26 Jan 2026 21:17:35 -0800 (PST)
Received: from rhel9-box.lan ([122.163.48.79])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-353f6230d5dsm1110925a91.17.2026.01.26.21.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 21:17:34 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3 20/33] i386/sev: free existing launch update data and kernel hashes data on init
Date: Tue, 27 Jan 2026 10:45:48 +0530
Message-ID: <20260127051612.219475-21-anisinha@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-69203-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 6439690148
X-Rspamd-Action: no action

If there is existing launch update data and kernel hashes data, they need to be
freed when initialization code is executed. This is important for resettable
confidential guests where the initialization happens once every reset.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/sev.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index a65a924fb3..d1dc0f3c1d 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1772,6 +1772,7 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     uint32_t ebx;
     uint32_t host_cbitpos;
     struct sev_user_data_status status = {};
+    SevLaunchUpdateData *data, *next_elm;
     SevCommonState *sev_common = SEV_COMMON(cgs);
     SevCommonStateClass *klass = SEV_COMMON_GET_CLASS(cgs);
     X86ConfidentialGuestClass *x86_klass =
@@ -1779,6 +1780,11 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 
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


