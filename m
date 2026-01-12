Return-Path: <kvm+bounces-67744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 53269D12CC3
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:29:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A1D383081453
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 13:24:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 126BF35A92D;
	Mon, 12 Jan 2026 13:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hzjUI3uG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wp3lVGYM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C9835BDBE
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 13:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768224252; cv=none; b=Zghill0/MoJf1vi31CnWBCDL/E8Ktej4ewoKFovH2eO8ODdLOK8zPdZ+2pqu/QPzxiu2qS4QIkBHoNSEgxdbyMksCkovknswhX754yibgudk2A+MVWxYdy0+RUcA6vtCRQlqtyFG2WEft76mYYsWDVotZYke+wPiS9wmuX7VBBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768224252; c=relaxed/simple;
	bh=cej20axNyMN0e2KBhi5h0wWrn8Ko+9OJO9di8FpI7Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOeGYFCo0gyU13WejebESHhbXNY4t0wHYvedREX429EAW+ikbfKQXEq+UE73hNO1pm85gjhI7gRnC0cN/6+gDoqhphwltCjuDOU2oCR81HrWxICxTbs1uhKAXPjvXu6V3mcyd+qN64jrVZs0nwB5/rD4PH2oG2EQglJkPVnecGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hzjUI3uG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wp3lVGYM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768224250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qYAaN0FILWaSu0nPli0Usb4itaQvJcTN3FzK6m+/4vg=;
	b=hzjUI3uG2OHVhMNqaApDlNOZ2bwgzxPXH7ijxlWIQMXdv6UKZG/eOq3Tr60TV0eHBnhEBY
	aYiBKza2kO8egaqAO5YTG2Myq4m9h8fgdcqr7+n1lencNBEI/wQWtIeSGqr0YQE26k8Jv7
	1ds82ety1oAboGz3nBUI2LUTCnYh730=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-157-_gu5pXIsN3OtWDUssP4yyA-1; Mon, 12 Jan 2026 08:24:09 -0500
X-MC-Unique: _gu5pXIsN3OtWDUssP4yyA-1
X-Mimecast-MFC-AGG-ID: _gu5pXIsN3OtWDUssP4yyA_1768224248
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c552bbd1b03so933908a12.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 05:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768224248; x=1768829048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qYAaN0FILWaSu0nPli0Usb4itaQvJcTN3FzK6m+/4vg=;
        b=Wp3lVGYMnuJhVsYYRTKPBEMQcyn4mzDYSsYpxTI+YWqTDVPK7BVwCoQDrvkr8GJ3ab
         4DoBYiyPk2kAa4JR50UeWUGhwfIu3flQM4BZVnvXTk4DdtvXs0BrJ9gYdwVgjXk9DSt7
         pBjPJsMzKU6W4gIHT5VfGukDYZS7zT7Je+Bt6390j2H0W9u7W9PmT+keAp5HeAZVfnIK
         fm0iD1UBPS/zekwhbxjKlqH9GjW3QjeFkg0PmgMNXXAMoPA0TuzzQcpJLvINC1Ua5a8l
         D1y4p+oG3CxU0/yAZ6JfEuxE/uYSJjaFqoUZLGumhiS4/WiGIOuB5yXnHuZ5dchAifWX
         qzUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768224248; x=1768829048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qYAaN0FILWaSu0nPli0Usb4itaQvJcTN3FzK6m+/4vg=;
        b=gG9HT+8muyRw7pJ1OVVSopMgGDbO/5L6FcijmY4zaBa31bLHqXR9KOayymAYoi58vk
         W+OTgkYEW8IbRM/GdvSafXPnH9TTd7I8+sXEeGDl0Y43c+M1ZE7WfbsVrv49GsRIwj00
         BN8+7u6XAvOi/5PmOKkR4utb7/7K9X8rfWNxeLg3lShBrqUhIXpMnKfPhDh5pWl6bA+H
         62b52NwSZ9wxqnLI2A3DXl9nB6ijyfuHJ7lesuZb3rvQvwmUAperRpKteHMyPNcU3e7z
         xn0QBXSL3T3lTo3FLb8/Hyb8VGjhaThPQ5ASZ7D2kSaWaXfy6yqAikqhVu3N6PN+1R4l
         df1w==
X-Forwarded-Encrypted: i=1; AJvYcCXN8XLWvc3g1sGPs3F8Dt1W7NqtdL6RN/Z71rcYZPWYPwDqRt91haMeUl4EIHwPu9+hJUk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyezfa7IR3ymwacCnsotq6nwXIleIHH4az1W1mDvqbPBnFUOg4Z
	PUvvUjJ+0X7kZ5mFXFiGrXrLZ+i2Yp/f89lknitJsSS2eF0zo1eK5SwWMNPKHMpAE9ndk1pXJj8
	lRAGcE0Wqnsznza/OHsKJyo5xKeG/WcN0xawtnpFyq6Illw+MzslqbZ9xcBkEFg==
X-Gm-Gg: AY/fxX4u0xn+U0HLlLQXEcW0eHp7jp9kCGmqtxW9M4agns0ka0RMcUe4Wx6+MlAfPAc
	i8lVwZpkQ/dpUABoTtFj2lx0EukzDvDiVlM7lSGcW39DymrEMs7q2o0BJ4nlLpp/uWMEd415lEu
	k1WZxzFrh1EIWZTrHmP+TChvn3qZIQcyk+u+eeWrehC3nzkJag2fslGeooVznDb6tfbfuEdeWnF
	dUoBkz9C1+kCWe58OpG/IrjqprWeAviE+kMYKtkV/TDxVNciogefWNpyvlzUCbSoyg/E2jadGwb
	4/+9OwpBA0u1Ph1IsOyQDBl+/uaYxCY+V7n5WxCoc34b57AfJK6eXZeN2vMSVSLbTNpsxbSPYKU
	9pDCUqArsYtWLIG5Z0yCY9sQa15QFaXBylQP67Fm0J0k=
X-Received: by 2002:a05:6a21:6da1:b0:350:3436:68de with SMTP id adf61e73a8af0-3898f9ba491mr15321617637.53.1768224247824;
        Mon, 12 Jan 2026 05:24:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGOtkQ45tyb3QTZGZrDgFq0z0H3Qt+mAbmV6EBRPgB7nC3YcwaVegyFHgedWmQohGcEWT7WNg==
X-Received: by 2002:a05:6a21:6da1:b0:350:3436:68de with SMTP id adf61e73a8af0-3898f9ba491mr15321596637.53.1768224247424;
        Mon, 12 Jan 2026 05:24:07 -0800 (PST)
Received: from rhel9-box.lan ([110.227.88.119])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c4cc05cd87asm17544771a12.15.2026.01.12.05.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:24:07 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2 16/32] i386/sev: add migration blockers only once
Date: Mon, 12 Jan 2026 18:52:29 +0530
Message-ID: <20260112132259.76855-17-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260112132259.76855-1-anisinha@redhat.com>
References: <20260112132259.76855-1-anisinha@redhat.com>
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
makes sure that the migration blockers are added only one time by adding the
migration blockers from sev instance init code which is called only once.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/sev.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index fb5a3b5d77..c260c162b1 100644
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
 
 
@@ -2764,6 +2749,11 @@ sev_common_instance_init(Object *obj)
     cgs->set_guest_policy = cgs_set_guest_policy;
 
     QTAILQ_INIT(&sev_common->launch_vmsa);
+
+    /* add migration blocker */
+    error_setg(&sev_mig_blocker,
+               "SEV: Migration is not implemented");
+    migrate_add_blocker(&sev_mig_blocker, &error_fatal);
 }
 
 /* sev guest info common to sev/sev-es/sev-snp */
-- 
2.42.0


