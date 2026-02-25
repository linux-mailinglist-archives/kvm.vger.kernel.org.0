Return-Path: <kvm+bounces-71762-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yOAeC/Nxnml0VQQAu9opvQ
	(envelope-from <kvm+bounces-71762-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:52:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D3F4B191576
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:52:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C557130FB0EC
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 03:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCA5526B2CE;
	Wed, 25 Feb 2026 03:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iReITiwX";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DX1lIv1i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A151229AAFA
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 03:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991477; cv=none; b=RZPVugVJh2rgfV/pZp8NZrM/Lj+TmPnU61XnO2T06KvU2w2T8nhrnBoWGdJn6gLnrXxExRaxxZbKNSsLHTtPU7y4asCHMAsE/qX5s6ythpriC2jcGsCFg6UBQm6TOxBFQyqdQ9bG0tQxiO3jFzvxCmB4KhgjelZ9sWqDme9omtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991477; c=relaxed/simple;
	bh=F1HF7CtknAnoolSFp4CwIG4K96u9dm8fn197DYkJjJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kb+hDNfLQQJC6WPslVcmBLajAOjtxFIa7oFqNCcdPjyIGUxU3SA2LoXPlS+H/Q1fQrHovTdXtSbdm0VLQPGAmsgFyILR2eFC5P1xjbIJI0/mmtjrLl2XeeeE7SKNT34NStN2G5u1fhVl/GJUbVSUFMrdE6q4aOl0h3z9NwzFIrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iReITiwX; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DX1lIv1i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771991474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=av9X0K8K/0DXwv9tLYeu3Bap1JDHpXgcHRbzm207TyQ=;
	b=iReITiwXHHrTbENoaXtwUMD0JRPSQzRDwJ3OE2cvQWgQJN2Gg2EAKn7lNKCynL0HSIvIEj
	kShkXpfGQt/IdDlILLbBQzlYn74sWV5jPWh0C+qIkXbNwBv24OpVWKXeev1yVFphc1Jjvm
	XRlx4k1btH/ZTzUxV7kMDXDN2l9gEO0=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-pAQBf3HLPaaL2CxM88S8bg-1; Tue, 24 Feb 2026 22:51:13 -0500
X-MC-Unique: pAQBf3HLPaaL2CxM88S8bg-1
X-Mimecast-MFC-AGG-ID: pAQBf3HLPaaL2CxM88S8bg_1771991472
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-35626b11c51so4863848a91.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771991472; x=1772596272; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=av9X0K8K/0DXwv9tLYeu3Bap1JDHpXgcHRbzm207TyQ=;
        b=DX1lIv1iqThOwvitZ7/l9UsSUg8VqitYUV0KsnanXTtXmc9142sFmh8BegbBtbLBkd
         VMQeK+SutCKdTWFGsQCZTN3OtYsICeWonrRyGcs+hIG3OU4xLQZDmhpnKtyo36q6yxsR
         V7jAScD+yH5Da5ZCWlSTIQT54UQrx6stSVqWzhlHtygMQ9I3ZID4qZ1FeWvO7Sqlc4k1
         W3fhEiGjW9IHsMTNeSIP/FQG556lsq96oDF1QDoJ4W63j/zqdG7v1ov4Kn1mUhlWjNuH
         2zHFpiWR2p8liAyjxXTffdYIZsgXp04ImZU6QEB5AH+gEgsNpgBUcevQGvRcW4dnGJ3e
         h0fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771991472; x=1772596272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=av9X0K8K/0DXwv9tLYeu3Bap1JDHpXgcHRbzm207TyQ=;
        b=wyUHL5P6yDJoIR/Bv4dVyrqcHA+TmaU68XioWPZkHIgVNpSWzjTOeMn0hxA5RXrcld
         YVD44LptHwAhijuvJZ2e7JnCx9nU/ONuIwjtCCGpUjzvV96QNtTQ70pHgS/Yr6q1H+gX
         YReEO+gakF7dGKMASPsRnzE47UEGsiBroRSFCa5ZRrwDz9tUGIbEwh77PyggHejC01g1
         iGUK4zIun/UDULdSep0aEcirNEDck1JvWdHWKGAQsdkq0e5UCGdiCvTYsQ6CV5BS6NAW
         kh/MVMogH1MgqYAPVaeYCOMIM3CDhs30QtD32M1fMXMd5pf+iOt4AHkWSgekBOhOqOU/
         GttA==
X-Forwarded-Encrypted: i=1; AJvYcCX2W4winxq7t5kBqH/waIE7XwgkPA8sZXN37/mJ80Vou6mNdurkQJXA7tT7uIrXNZAqwoY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYxrYgZcLgEhVndEShxl1BYiHIYeOyF7CV6b4sAEoXFMiBSZbm
	Hunxh5e5FIuclh/YPY3zWrf38kgroZjLCkFZ29SKH3+6fmvKzXGmvUXIjzETk7t5oOcZ7z00gae
	6mMjtagZGExImzGDDlBiCXnsCGr04JoktbmellsdVIdouAvL2HxLgmg==
X-Gm-Gg: ATEYQzzHc1nigIPTZXik2T0AjNGPVu5wtxikFGWVdC7AXxXsvtaXrFxnP13MLRcs51d
	S9xivUUOeRyWe4UVX1+36EA8qLaeE+B0SfGYRMO28QTB47p2efDUcOcC39jxPgKgBj20pHAaChc
	JtRPT+20EPfHChtpOcq2FayGYkZwT2hMkfqHkgHOeBKt4l9lf4SC+ryHNc/U+sieQfb+Y6l/Arp
	IqeKB+p3Trq068Y56SAe7u+tCO3tUuFCo3IT0dEGAYWQ6oHgkxYcIovlRjMsBi8YiKulb5Nyokw
	G/0Jy5rmlk4DMdepNIvKW0ydv76hm6Q7P5rrFgdORmPHUbs0Hr8kVaNbRvrsaGTzJD7ZZPpM/5e
	9uMPDiM/2TD/DaNI4XZNWxa6kEYprUVA/UPC/1JllE2FCUVsGZ0gBb/E=
X-Received: by 2002:a17:90b:4b11:b0:356:24c8:229d with SMTP id 98e67ed59e1d1-358ae8a48b4mr11520258a91.21.1771991472329;
        Tue, 24 Feb 2026 19:51:12 -0800 (PST)
X-Received: by 2002:a17:90b:4b11:b0:356:24c8:229d with SMTP id 98e67ed59e1d1-358ae8a48b4mr11520243a91.21.1771991471958;
        Tue, 24 Feb 2026 19:51:11 -0800 (PST)
Received: from rhel9-box.lan ([122.176.129.56])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-359018838b2sm1186006a91.5.2026.02.24.19.51.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 19:51:11 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	ani@anisinha.ca,
	Prasad Pandit <pjp@fedoraproject.org>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v6 19/35] i386/sev: add migration blockers only once
Date: Wed, 25 Feb 2026 09:19:24 +0530
Message-ID: <20260225035000.385950-20-anisinha@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-71762-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[9];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D3F4B191576
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


