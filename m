Return-Path: <kvm+bounces-65838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AD14CB90FA
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:09:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 01B58309F50D
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82DEA31DDBF;
	Fri, 12 Dec 2025 15:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ekdL1IPV";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="tBhnhT/h"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAD931B11C
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765551919; cv=none; b=Nrt9wpBXc35hNgYmSd/OR5Wo5/C++h7fNcaMMFP0EYZqrzznAg4moFK571dXmMacJzBkIEWzzLi4mGnWkdbv9S2iNpVuD9+extdZC86cjDha6Wc+2uvrpQwnTHFtY38pTGAOrj2IOVhCsDMQsjIqG/ZE/0WSs00cjSkt36wk5EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765551919; c=relaxed/simple;
	bh=HLcztvr1fublLnMX4uMVEwu3MqV0arKBR33HeI5nUxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cA9uTJAROAjickd2R+SWemjVxIVWrCkMSxtrGTrv2qgzDjr0jpYGKmg19ypU6mCHsxkJ77QP/gsEgqDdqcLVJNPXT5GtmSbfbA040d4s5ttVx2gK4604aTd1p0Q7kKqQSrfw0qeNT7GxI0TfwA5NzYQn3oaiucglNTOepjn9rms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ekdL1IPV; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=tBhnhT/h; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765551916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LsdNlrFz9EGrun/Uh+cGSSljZDj/Qg580O6DUWM5YJw=;
	b=ekdL1IPVEmCZsFxus5OFDg3VqGycBH6bu8ORGDVwyv822vhCdULHbERyfbVdckqw6bzLbQ
	pTPU+EEKvOX0TOsxUAMPTHzPXdgyEPMzzfV6qId8JKh3eKkjBGrthCp2EJPoE3aSVJdncY
	DGyqy9U2fVamwmLFNb4WMMXW8A0B0Lo=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-M4QH-SibNtyWEdnH2Fr_mQ-1; Fri, 12 Dec 2025 10:05:13 -0500
X-MC-Unique: M4QH-SibNtyWEdnH2Fr_mQ-1
X-Mimecast-MFC-AGG-ID: M4QH-SibNtyWEdnH2Fr_mQ_1765551912
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-29f26fc6476so11207325ad.1
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 07:05:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765551912; x=1766156712; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LsdNlrFz9EGrun/Uh+cGSSljZDj/Qg580O6DUWM5YJw=;
        b=tBhnhT/hb0PpPXTdw1496iLp2ovWohf7Aj7/QgT7+Zxb300tJzPs4YWd44ZKg3VM4o
         HEEx9uJQ0CHmKC2DpwcwjvSqTVvHd2+dRVWlmvyWMhIRK2Y7+3eDIY7BiGyCNyDgerwC
         DDDuiXBgqz5icEyhEJmKxoiGBQjPhgIPXNZYBBlmCZo3BjhZIM/UnifTGG3IzyFw6O42
         KImnQOrzYbXjGk4ywCzBsGBnp/liiRdZrmHK+V3aarUnTvDVXCFNthpSjyGqnKBotkQ8
         r5rHtpo1reUwnfkzfU3P7q0MKFAcG6nQugS66qycOBp+K4aM6q9sgsxHOmA2JIuf8RQ/
         oX4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765551912; x=1766156712;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LsdNlrFz9EGrun/Uh+cGSSljZDj/Qg580O6DUWM5YJw=;
        b=AMz0Ga3PerGb8McsPYn+L3oatYqfFTbCPAs6wP4VF3dxX/UKVXvSzOoBej8TEQh+J1
         WMDaaROUtbbpYd3SEkaOwgg0X3HRDmM8hoQCgKPrcZ0/o9KQvP9uljOIEIbKJe0oegXe
         vnpvJKUATQgEEq/ZSJ25PQcV8PaI59pQwH/3qZJSmFloLIDYV2WyjdMtDzkPQj2Jy3Sm
         zhVi0sUV2FKBy2lcnJ71m+OiCq0QkAplsT8D4CSTjJG0PDIfUeEpRbeKA+atpCmet8H9
         p1w/t67N3zlaK7noOcgp05JuJh5guBv6qleRbj/1UbBvg1bqhmFfWEMpmvSmQ9utSVZ/
         aVxw==
X-Forwarded-Encrypted: i=1; AJvYcCWpdaMgrQ3RMiH2b1IkA/N7eIsFjrpZpokrI8QlM9NMNmqeyFcgwm55drmw3xcu7aRBEW4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5VyhgqV+xQCj98MArHWxC204t6UKrcDYtaF4cgwDxzJr66L3w
	SSC3LsTtPS5qReEmPpshc1AIia58mrGE79/Ioz4L7YlTTYyuWCC/fAoWMpvJEWZSg8ddH0mAL8G
	99aJrOop2x7DppApPpk4l+5uUCOO5ILtE4tYx6P4rbGwT7eyWDUrFkw==
X-Gm-Gg: AY/fxX4/sRXXl0vdr7Un+06NLePoGbO3Hh0FMx5gtvalqLZS8o/Hto+nXlz05FDkMjk
	O2c7vqVyf4GHEzM3m4szOmPhOxtxsiQfL0SEkJMagRtaTOj26Pbt6KRfdHqUw2Dg6/YQ7aoAyeb
	p8xS+ANvX6V3hlQJK2LCuekyLiRDFNuLfSPzHv2fjCsroZxNg6ra7uRggh+Ze8s5xgOIgjDlldl
	9QW2N4ITae8X2U9MXsd7Iqi42PA+lx6hE4RSkSvr8Oj6biQ45pZduktEWMj4L3Smst33MyR2yzM
	DKFfcEJLP3mKYVHY3f9ul/elVq3TRPcP2miNB4AYKEBEAx1wqTMFSncxfNP2VIB9Qu0qTMVqWy8
	+18piKQVK4TkTptIInlgvr5UYt6UwSQRYXTwr+m6vYwA=
X-Received: by 2002:a17:902:ebc2:b0:262:9c4:5470 with SMTP id d9443c01a7336-29f2404b199mr28726285ad.28.1765551911996;
        Fri, 12 Dec 2025 07:05:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEkoxBLlDC0IBA4TUcGuzRYGD7mbavLzDucIBkcmhvL5++uimoBU2V3fxAkUHD3REawLNk6eg==
X-Received: by 2002:a17:902:ebc2:b0:262:9c4:5470 with SMTP id d9443c01a7336-29f2404b199mr28725795ad.28.1765551911481;
        Fri, 12 Dec 2025 07:05:11 -0800 (PST)
Received: from rhel9-box.lan ([122.172.173.62])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29ee9d38ad1sm57046655ad.29.2025.12.12.07.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 07:05:11 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: vkuznets@redhat.com,
	kraxel@redhat.com,
	qemu-devel@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH v1 15/28] i386/sev: add migration blockers only once
Date: Fri, 12 Dec 2025 20:33:43 +0530
Message-ID: <20251212150359.548787-16-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20251212150359.548787-1-anisinha@redhat.com>
References: <20251212150359.548787-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sev_launch_finish() and sev_snp_launch_finish() could be called multiple times
if the confidential guest is capable of being reset/rebooted. The migration
blockers should not be added multiple times, once per invocation. This change
makes sure that the migration blockers are added only one time and not every
time upon invocvation of launch_finish() calls.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/sev.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index fd2dada013..9a3f488b24 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1409,6 +1409,7 @@ static void
 sev_launch_finish(SevCommonState *sev_common)
 {
     int ret, error;
+    static bool added_migration_blocker;
 
     trace_kvm_sev_launch_finish();
     ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_LAUNCH_FINISH, 0,
@@ -1421,10 +1422,13 @@ sev_launch_finish(SevCommonState *sev_common)
 
     sev_set_guest_state(sev_common, SEV_STATE_RUNNING);
 
-    /* add migration blocker */
-    error_setg(&sev_mig_blocker,
-               "SEV: Migration is not implemented");
-    migrate_add_blocker(&sev_mig_blocker, &error_fatal);
+    if (!added_migration_blocker) {
+        /* add migration blocker */
+        error_setg(&sev_mig_blocker,
+                   "SEV: Migration is not implemented");
+        migrate_add_blocker(&sev_mig_blocker, &error_fatal);
+        added_migration_blocker = true;
+    }
 }
 
 static int snp_launch_update_data(uint64_t gpa, void *hva, size_t len,
@@ -1608,6 +1612,7 @@ sev_snp_launch_finish(SevCommonState *sev_common)
 {
     int ret, error;
     Error *local_err = NULL;
+    static bool added_migration_blocker;
     OvmfSevMetadata *metadata;
     SevLaunchUpdateData *data;
     SevSnpGuestState *sev_snp = SEV_SNP_GUEST(sev_common);
@@ -1655,13 +1660,16 @@ sev_snp_launch_finish(SevCommonState *sev_common)
     kvm_mark_guest_state_protected();
     sev_set_guest_state(sev_common, SEV_STATE_RUNNING);
 
-    /* add migration blocker */
-    error_setg(&sev_mig_blocker,
-               "SEV-SNP: Migration is not implemented");
-    ret = migrate_add_blocker(&sev_mig_blocker, &local_err);
-    if (local_err) {
-        error_report_err(local_err);
-        exit(1);
+    if (!added_migration_blocker) {
+        /* add migration blocker */
+        error_setg(&sev_mig_blocker,
+                   "SEV-SNP: Migration is not implemented");
+        ret = migrate_add_blocker(&sev_mig_blocker, &local_err);
+        if (local_err) {
+            error_report_err(local_err);
+            exit(1);
+        }
+        added_migration_blocker = true;
     }
 }
 
-- 
2.42.0


