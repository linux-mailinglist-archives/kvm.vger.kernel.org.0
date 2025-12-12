Return-Path: <kvm+bounces-65841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 13065CB9109
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:10:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 07B8130DE363
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33CF2322B89;
	Fri, 12 Dec 2025 15:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gAV5sMRW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mTeFVznq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28E131ED7A
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765551933; cv=none; b=Z5BJy1lqbELuawfEycDV424xVnqCvsskH/zl+B1OSbtmHmZt+O20XWAa8aE7Yv+ipNCqi4ir/oVNjbEx/W4JID+kAkx2/NI1tJ0tOV393Mk1GQM3dsqbVo+xG0Uf3GQHLhiGgzawc1xKHlKlhOX/4xHuws4060EILVc+0dIrFBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765551933; c=relaxed/simple;
	bh=JpOndMl1nVqtGcDzAwy07wvwLYnsKBelFhFEc0mYE00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQSddlpbpt38Ry/8YuIHC2SsWQM3gF/wIchs1Su3ZlNnZYHWXtN6FF/WciChobWNYdNOymJ8/1hrmoruYh5I5P0+8NcoVwShh4Dc8IydT42kNlhbtYehs0qlcmi4d4UmcSJn9BOhDKawO+jueGzQ0vE6tVQyBwPw77TBkOaEES0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gAV5sMRW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mTeFVznq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765551922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AD5TvnPmaG2p4oioPCNypqz8ubpMGn5del8Os1RElwg=;
	b=gAV5sMRWKK+6Zl6mA5Pqadxt92q5LWr6vNsHLpXXvJjXcvZfArhbytN9fst3Ttw8e0lInu
	e4+fJ9SYeVp8pnOnFJ4u5wLd8V+gqK0kp2/Bk2APBOXhvOfAa+K+NHIKDrQvNhwiTBdOMS
	kjJ/1in07IJ82V7kgwvfMBbrFRIRT98=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-244-WyMxyMEwODCfll9ZdAQ7-g-1; Fri, 12 Dec 2025 10:05:21 -0500
X-MC-Unique: WyMxyMEwODCfll9ZdAQ7-g-1
X-Mimecast-MFC-AGG-ID: WyMxyMEwODCfll9ZdAQ7-g_1765551920
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-29f29ae883bso7079255ad.3
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 07:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765551920; x=1766156720; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AD5TvnPmaG2p4oioPCNypqz8ubpMGn5del8Os1RElwg=;
        b=mTeFVznq2Bg3Oz6tPVOy1REQ+h5QgB+2iaFrY7pgyetMd3Hk3BjQaJDp+pbD/yb8ML
         6r95X/kPfpVr6feEZ0UOJ5FpawtORe0vfJbld1YAX5nLrf5EVl/RFzWl/k1FLLkyBin8
         t+TZII0mDzxgn6TH1C//0weJFFJp8uLYATs4J3h5w1G57uCxwC6zfPNlN0iVhEsenhwS
         XEn1/foFvtgWBwSrXnkXa1fO2p0SN8+S7TDyhhlJC22zN+nWLNLXE+gDpp0mYI5wpffa
         hyH8N9fsxKcDb1zP81tf6ZvCVxHNDLhydo9KTW2PeMyzwgE4fUqE4S4T7VL7lR8PM0po
         CmZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765551920; x=1766156720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AD5TvnPmaG2p4oioPCNypqz8ubpMGn5del8Os1RElwg=;
        b=XvxbzE3swb4Df9EvHlpomC4Dj144nCc7MDQQs32kA0WnQEHmJjbSK9B9EiU2Zx7n+A
         T0sgI/See3WU/yS0XNxqjoefGXeiLAQUESVzotGZfPcxHOZoo4lptiT8lPVxJ5AOL+m5
         47lIul8eW4fPd5arYEnuG1W0BgK4S/gWOWRjPJu8gf/AHUWMfuR/ALmwPhXg2ZRHDeb9
         8bTy0hJO+0is7bRCu7AXkNl4ZEY1IVRK7sdNMk6Nb1HTCOJqRUEu2nngzUNQy9yISemi
         lCPY09L1av8fd2Pm2yeKA434wvTaTX802C8yK0jzBoDjbEi5OmaCwa/NQT+pJR6FI4ZN
         AY/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXxrUnTWR1k7tZBc2dG8BXzS17vejmuz/F9ngrDYS37yPyVexa9//FTEcO7Jgrh6/k/phU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzq1j6yE6e/kddwe8XgADLeY7YBpF9N9jPp48stxnccx7raZ4kK
	hmt6CfpAmpC3aIJ8w7q40Kj4zVWYK08CeutZCms6wFxnfn6NeF9A3rxDDmYAilqt3dMjdiz7fEM
	mORfi9P9P/K+PcY5z0rTEM3vYbBR8LHNw3DDfB5VMGVNhl4K8oY4LnBSXf8Q9zg==
X-Gm-Gg: AY/fxX7TFkY7Vu4EALJ9BwkSBh/M7uZwqen85M+Dgd2U4Jzx6lCsgj4ei07azv84mRC
	5rgGqhbuwdznuNonl3hrSHMsjV0twAKf/2Uf9IsjAvtM+C8TTzFBlkyViLMB/DOvnzw625ERltm
	ZiLfLaRHyh7HTzlXUOe1Mlr98/R1dufEXV25nRruL1NQDHQr47TOPsY8qzk3F21achyWmMbajrT
	B2+mkH3s/AWiDDoMaJ1X31TRb5OxEYh1IoENIObx56/Cm6qXIP21OaZmEHdVblOtzqBvgYLmUmb
	asVhcqzrqnIQalQXMxrZWUs7cURvgsSZ8YZXZ88QiavCOtS7WZcVNJ+gOf1g4C8KjfN/q1A+n2z
	yClo49x9SUCb7xipK+RWaGr/7vyXB26y7UcRGl30u9m8=
X-Received: by 2002:a17:903:37ce:b0:295:195:23b6 with SMTP id d9443c01a7336-29f26eff462mr21754415ad.55.1765551919594;
        Fri, 12 Dec 2025 07:05:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFtEEFZPyNKKCDsh5aLQtzNZu0DfrwfLsiOJl4sm0R3t6SN2FzDZ5y63d85tglByziYc9oKwA==
X-Received: by 2002:a17:903:37ce:b0:295:195:23b6 with SMTP id d9443c01a7336-29f26eff462mr21753995ad.55.1765551919077;
        Fri, 12 Dec 2025 07:05:19 -0800 (PST)
Received: from rhel9-box.lan ([122.172.173.62])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29ee9d38ad1sm57046655ad.29.2025.12.12.07.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 07:05:18 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Cc: vkuznets@redhat.com,
	kraxel@redhat.com,
	qemu-devel@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH v1 17/28] i386/sev: free existing launch update data and kernel hashes data on init
Date: Fri, 12 Dec 2025 20:33:45 +0530
Message-ID: <20251212150359.548787-18-anisinha@redhat.com>
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

If there is existing launch update data and kernel hashes data, they need to be
freed when initialization code is executed. This is important for resettable
confidential guests where the initialization happens once every reset.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/sev.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 1212acfaa1..83b9bfb2ae 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1791,6 +1791,7 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     uint32_t host_cbitpos;
     static bool notifiers_added;
     struct sev_user_data_status status = {};
+    SevLaunchUpdateData *data, *next_elm;
     SevCommonState *sev_common = SEV_COMMON(cgs);
     SevCommonStateClass *klass = SEV_COMMON_GET_CLASS(cgs);
     X86ConfidentialGuestClass *x86_klass =
@@ -1798,6 +1799,11 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 
     sev_common->state = SEV_STATE_UNINIT;
 
+    /* free existing launch update data if any */
+    QTAILQ_FOREACH_SAFE(data, &launch_update, next, next_elm) {
+        g_free(data);
+    }
+
     host_cpuid(0x8000001F, 0, NULL, &ebx, NULL, NULL);
     host_cbitpos = ebx & 0x3f;
 
@@ -1989,6 +1995,8 @@ static int sev_snp_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
     MachineState *ms = MACHINE(qdev_get_machine());
     X86MachineState *x86ms = X86_MACHINE(ms);
+    SevCommonState *sev_common = SEV_COMMON(cgs);
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(sev_common);
 
     if (x86ms->smm == ON_OFF_AUTO_AUTO) {
         x86ms->smm = ON_OFF_AUTO_OFF;
@@ -1997,6 +2005,10 @@ static int sev_snp_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
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


