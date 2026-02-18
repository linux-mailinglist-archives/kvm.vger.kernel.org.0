Return-Path: <kvm+bounces-71236-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8N2QAPqllWkQTAIAu9opvQ
	(envelope-from <kvm+bounces-71236-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:43:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9583C155F9B
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:43:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 040E930234D4
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 11:43:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C247F30DD2A;
	Wed, 18 Feb 2026 11:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z95RQpQA";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JDFKxOaC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4BA30DEAD
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 11:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771415030; cv=none; b=ElQvMOSo6djXEknh1lo81+Wd1StdqHbeIu90/JefZqmIkl7QIzqEXRxNglYEoKGQROmMo6nW0mh/iHDh+kLzOdGxeYXbj4EEp/+oHKv4yYp+xCV9XS77+wIEMb/79aJNRuT2PQ/mKAEzpSGiFMUrWOnSMIW3J6SkVkoqf/uiaqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771415030; c=relaxed/simple;
	bh=oyuneKzvdez0/AzYtX0YpwFHbqcpf5Ank1kplg3Akrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEcBQWZ4eQV0EHLrvleCFXJgkhN6xEFYe7JFsBrweGqBpw5nA9CLFDEX9fxv0sOcVakLIAqf7rmsr0ARnK051Rlj/PNn+WrZQDphoHc9h+2WugS7sWvXX5AFHJDWgp1jI9y2Gkvszygw7vOt0TUkk2szR0qs0xDV7HOOcD4zzGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z95RQpQA; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JDFKxOaC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771415027;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N2v6djobNSdTdF+YCpvzDQ17kkQi5jILZoPxzgDYLR8=;
	b=Z95RQpQANmq9iiY3HFqObwjo+N+nbdSIlmfzoQt9WulDKvt1V3nakK8/6s83TS60baJKuq
	Ho5V8iEvwoygpjBMaEfgcJguDT5UqmsMzxfy4wDLGrAIUvxqSfn2ebgLeXh4zSFAjGnMhx
	pEUnHeqWSGzJqeWopS4oysEc4KAS3XI=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-IOFUmZngOfmJOy4tdyTShw-1; Wed, 18 Feb 2026 06:43:45 -0500
X-MC-Unique: IOFUmZngOfmJOy4tdyTShw-1
X-Mimecast-MFC-AGG-ID: IOFUmZngOfmJOy4tdyTShw_1771415025
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2a784b2234dso290974645ad.1
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 03:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771415024; x=1772019824; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N2v6djobNSdTdF+YCpvzDQ17kkQi5jILZoPxzgDYLR8=;
        b=JDFKxOaC349YEmQhVS0DutsBPsnCQxwS/UxcMAtOXxR52cCQUry5zJNTsKMvQZ3ogd
         RvEMLg9HOiyzx1Lm7WdL6ZuUMvTZPutLvsjltsL+x5HcE0XvNnbiZsnXn09oWQU2QJ8A
         w9Sy+7M833bnmOXc49MBtR3mnPKwXGWYW/PwkA3wsRs34q+GLFjLrg608syl6wDzW437
         8lDQdvZcy22jG8eec4yhA5c/M6x31O37a+pE/PW/jd5fNJ4JUQedxxEBNKalrzlDdStl
         1cG8AXLpcDC6aY2/9X8e6wvOZQNqpiDwU9CGDxTbJUVb3iM5CXIcjEBcSReKuR0jf8Ix
         gJ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771415024; x=1772019824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N2v6djobNSdTdF+YCpvzDQ17kkQi5jILZoPxzgDYLR8=;
        b=h8x+1JmXu/73mWbAyOweIW3C4SpgHg41S+ZCEICmSTkcSMGS8Ox4u7jOQ2gBhq1aWe
         YoZC/OyUj3f4FceWqm8kF7jzbIKpmKERxqzmprMwvMa6nIUTre49Fs3NVxZ5G6JvpavG
         wNhTJ5T+bIx/GlxPT6WfXx3DMuOv7/6VgJ4B/KV3GaI0goOU9G7UuNCE4PyWDf90Y5tX
         50MgZn0IQ1H4PPLcOuiyse2ROReE8p2DZvYz8mKV/yfalKLrbhjkXZ0KEza2zGWbLUCb
         acES/NncDSa0mZxHVBx+UIczeBBTVyTlT8G6E0qvQlMHdf9dN9DnEZdCdilHCs/8PmYF
         tFjA==
X-Forwarded-Encrypted: i=1; AJvYcCUuOIKcvomtH5inWLN+JbXkfhFE9gmKm1V4eHiVE9dukLqw70ur3SpLmJakLy8CW9c2jzw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjIHZnEr6yFbKtVXPcJRNGRHiXrbMwTrzaocfKudaMPw6ZlRt5
	QWHSJl2wy7xl/pLTRmZuyPd20MO+5QNxzY599HA5a39Ai41c+4rq6yIXLpMejQA56FmkjRc7wtA
	6ZE8xsn6Aq4rGnPDIwaJIpNYvQ7WmTS9SgP0n89QqLvMjjeKJ9qq/uA==
X-Gm-Gg: AZuq6aK/UH2B8cyXSAEaASOM8UDAW/rY6+LUDvO7x72PqP/h0UJUgkivM5ly2CtInD1
	1tCeozyHOW/EheHm0uSf1FbC2oKXR3yq79qVvZY0hjHEywsjN4Xt9CG3KeD4ySA509ZzxE92glI
	5qOT/L/LdzNaHPY2zEKtM3XddbPUkxn+7NjLbJnZev/snm8OEIQ7lQl76TdH83zcqgHgg7+lu9i
	xl/agFsZDKsvjeHhI/Z0E+WSN93NU0s6QyTc9KcPOKNCRkVfbm4AmQ9qDkekV3l1rgjFxo9NbYw
	LLdWYzdFMLtVqBCAjxIm73+Q0k5fsPoBulEbMk1B++EgkWps0S35ZT+0g7fKhVmzf5uqh+O8n5D
	CxTxgdeZe+0c7abBmTjK+kq+o8492n12Mom51N1HaKCTKnwRQmaM1
X-Received: by 2002:a17:902:ccca:b0:295:9b73:b15c with SMTP id d9443c01a7336-2ad50f4c562mr14531495ad.42.1771415024604;
        Wed, 18 Feb 2026 03:43:44 -0800 (PST)
X-Received: by 2002:a17:902:ccca:b0:295:9b73:b15c with SMTP id d9443c01a7336-2ad50f4c562mr14531355ad.42.1771415024293;
        Wed, 18 Feb 2026 03:43:44 -0800 (PST)
Received: from rhel9-box.lan ([117.99.83.54])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2ad1aaeab38sm127803425ad.82.2026.02.18.03.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 03:43:44 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v5 19/34] i386/sev: add notifiers only once
Date: Wed, 18 Feb 2026 17:12:12 +0530
Message-ID: <20260218114233.266178-20-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71236-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9583C155F9B
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


