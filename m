Return-Path: <kvm+bounces-67745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id D138BD12C4E
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:25:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2DBAB302B7EC
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 13:24:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17F935A93E;
	Mon, 12 Jan 2026 13:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EkQgP69P";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rCUynrHU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD52358D09
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 13:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768224255; cv=none; b=Yx8ECqf+9pNz7zNFMEEDBrQyOX6Qkr5VtZZbBsH40RRb08gUuXR2bPwtkHZdY+Y4ldT9RhNSb8ZqA5Te5eYcEDENHBXk3+15Wj4ne7ZNnbkpVXCB1J/JHVBy8mzxbPyptrsZWhj70NVbQN5/3us2Qmp5x8Ykht41i2gWcFx/yNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768224255; c=relaxed/simple;
	bh=s20pOj3J9YFm3qNuKVFWD9WgUFjGRP6nCM8PIZHMHbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALMzKYENCLyjLfzPlGv00HsLPPu048OQFuIu/OAhizZ81dPeC+OucvB4yQ7LXCPS20N6LYbp3TXj4Ec4lChY6clHGlAQzBFYZtPyJRfpMpUKkpnQpg26O4rKLNMJltQ8WXhRT9CB0FjTdHPW1tVM+jt/II5bv5mdihah8eAGoW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EkQgP69P; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rCUynrHU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768224252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PPSeElKfzh/NRDXE944Lw0xULTqcWEbvHtXeuMQwV5g=;
	b=EkQgP69PHYlwxxM98uTv4Yh6v1a1h+XR14Ndil3E8if4z12FSxFS6Oi/lhpxEUEV+JHhVk
	RCVeInIXDW2+ykRoN90CwH7fWttxA0c8URymAhNw3PzxmJXjoMz2PqOYClNK5DVit5jYuh
	PYQZgxFJ+YhJWUfZxh0fvyk9BPcyMSg=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-yBBtSKkdPROUOTJxd4shqQ-1; Mon, 12 Jan 2026 08:24:11 -0500
X-MC-Unique: yBBtSKkdPROUOTJxd4shqQ-1
X-Mimecast-MFC-AGG-ID: yBBtSKkdPROUOTJxd4shqQ_1768224250
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34c37b8dc4fso12168461a91.2
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 05:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768224250; x=1768829050; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PPSeElKfzh/NRDXE944Lw0xULTqcWEbvHtXeuMQwV5g=;
        b=rCUynrHUlLqdgsjOYHCWzK9SVglnaNRuQpz88HMO22TCpVAtACj19b9O7jc0MDBm7U
         cqdEsEx/mD5gHhEnvdmdg0VUfma3ZRILVp51dpgpaVkwncpbLx9liCD4SeacycWOsaBO
         mOk751Xh7ndm5LxyOErdS6vaZSOp91OWDNjuV1rui7sHW1NdnMWLts0/G/fvMDMM/uSs
         QWO78TEFWg1hiSQCgGJ9Tz8K6iFyyTfavBXtsnlPkHK5sqgNNoG1gmYyxsmIQcnG0VC1
         y+FKr8zrJApqkfU+vZv8rW/GEoLmNThScMmOGV9an7EQl/Dq+HumH+CHHUXTZcckMEh6
         SUjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768224250; x=1768829050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PPSeElKfzh/NRDXE944Lw0xULTqcWEbvHtXeuMQwV5g=;
        b=EpouhVLOh/w81zBWcmyxEYVrsKwhBih2YWJTIG1abNHlw0lgOODRa2KVLXIjb+KWGU
         r3hHz8nSf5A5BN3dZFRXiSmhOIkYP2Jy72BQhOIclZq5RKS9VNXwRc5UDNQ6hfyJUaWu
         HY5XiZCIOBSxvPLCAyepRf1cZcr/EfUb7xzc+UjyT83ou42u0QVXASIQITKJe1GdzO7s
         AQchD5I018Ek2/cjYoQB+pC56VIJ0UcYBbbhjWbsHAk+HPPsm0M0T9QzKmGeDsgqdTXh
         JhkLDR77MqJaPUGnHxvNQAaMC9CYRNj9dGY50BLhc0NeqFm+xf+PpcZccABgPoL8/KAG
         xY/g==
X-Forwarded-Encrypted: i=1; AJvYcCX3UDwR3Dzrc54k2MHD37fABIUrBEDIuywGNXCXL4aRalD3knfLoG5yr9dGVWd/2ESpiRI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOLtLozhWnrSFe73y2QPxq7gu1EVW9TkTk8ekAxZxZwXK6Eq8z
	5TmPiT6tDHbEmmHIxhE+ESiZ6X+FkxT2TkJVA4vdS6qvZhzku5keHNu1EaNg+rTm+YCsMnMgsA7
	W2vbNK+uZlw4hFsH812mHJdZK/hUq0ybHg8ihovdVlmIlUfZh0SYudA==
X-Gm-Gg: AY/fxX4TupFuv+rda8HZEtsz2QNdTyJg5XauQdkv810a1xQF17+3nenw9oy4hhRkJ+R
	p4dX1HDhn3jf5d1VaLjIuo02yZNyb1eoM1UxShVXcE6E2SsuUk9qqPbO5RHdxV6dsgzUp0DfVIY
	CdHvoam2DRpoyMJ1YOROyZs0KDi27IC+i7sV2djlv76iF466jopJ9kGwoDAbSGJZFtNdrMWYugK
	Dp+gUQR6KSXBPsvePst6RhpLyvez7ZkL9BNbc8FxdLfzzjGfERD0cVotK9Qe4tD67vg8jWhZIWr
	NuDXuyVEacBIoJ7cgv1raiz/qITgYqj+bljwsCaYBnmg/ek87zS1NC0KpDJodl9IiQeHmxdDPHr
	900bi02TY6VNzSmLkwJkxVHRZ5m2OQE8b7TOYfztZk8Q=
X-Received: by 2002:a05:6a20:2594:b0:364:37d:cc63 with SMTP id adf61e73a8af0-3898f9bc4dbmr15772912637.56.1768224250421;
        Mon, 12 Jan 2026 05:24:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEHSc15yFGfVcbI1IGjoSw9rY0EaQDSSheDs5+T0rgDFRDspsmetxS02pKHWpV8ityc5hwTUg==
X-Received: by 2002:a05:6a20:2594:b0:364:37d:cc63 with SMTP id adf61e73a8af0-3898f9bc4dbmr15772894637.56.1768224250042;
        Mon, 12 Jan 2026 05:24:10 -0800 (PST)
Received: from rhel9-box.lan ([110.227.88.119])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c4cc05cd87asm17544771a12.15.2026.01.12.05.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:24:09 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2 17/32] i386/sev: add notifiers only once
Date: Mon, 12 Jan 2026 18:52:30 +0530
Message-ID: <20260112132259.76855-18-anisinha@redhat.com>
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

The vm state change notifier needs to be added only once and not every time
upon sev state initialization. This is important when the SEV guest can be
reset and the initialization needs to happen once per every reset. Therefore,
move addition of vm state change notifier to sev_common_instance_init() as its
called only once.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/sev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index c260c162b1..cb2213a32a 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1917,8 +1917,6 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         return -1;
     }
 
-    qemu_add_vm_change_state_handler(sev_vm_state_change, sev_common);
-
     cgs->ready = true;
 
     return 0;
@@ -2754,6 +2752,8 @@ sev_common_instance_init(Object *obj)
     error_setg(&sev_mig_blocker,
                "SEV: Migration is not implemented");
     migrate_add_blocker(&sev_mig_blocker, &error_fatal);
+
+    qemu_add_vm_change_state_handler(sev_vm_state_change, sev_common);
 }
 
 /* sev guest info common to sev/sev-es/sev-snp */
-- 
2.42.0


