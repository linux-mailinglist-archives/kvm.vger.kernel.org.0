Return-Path: <kvm+bounces-70916-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WKRvAsFyjWk+2wAAu9opvQ
	(envelope-from <kvm+bounces-70916-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:27:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A876812A9E2
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:27:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E4D4A3020527
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 06:26:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7491299927;
	Thu, 12 Feb 2026 06:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ggfTP6iO";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="B3AJMp/D"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F8F29993E
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 06:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770877600; cv=none; b=CH3lLuuDUl95RnpfLHfyOuxprN8jzD2vs86IcgqvhezHQQ0o5SXVkGes8F3Ll/aVHHabQImtA1vUkuhmANCXfXxUxVc9w5kBNuRU8nVdAWXemobrGg0E2HzhrtJ4jcPIKzkarsYOx+ZAr+ryqxt746aqTjeN84+/OnVaUj+ECqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770877600; c=relaxed/simple;
	bh=23O8pVjgWHoWC3mZeSu+Sniei65Eb9tIswTBaM/vPso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdeALnSlanfEqyybWNQjnRRogqF7QZFjqYKtjP6lOkJwoPwe+RkmX7IkvvOla9tYgrYpVuhenp98mXngDeIrm6J0P8/Jc4oTWYuWEO7XiDUTYU/cXZ4p+hHhoDQkFTZrxxTR8vHcxtJ08xyYYrugMp6Npx2717wped+XQnuBH38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ggfTP6iO; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=B3AJMp/D; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770877597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6P5ZMHhQ1gBULl+0OpCFy+J1BWjsvb7Pt0GdIxytUuE=;
	b=ggfTP6iOnuZzER0xBHP24pug3Ya+N42AULgoUoxLw4QuGLTD0NH/L6KEwhbvQ/9ysLGopr
	5fmWf7HwhJWVH5tE+BWw1qIFl/28Ile0Qs00t0/YvYy3eLNTlikb23G/rvE/tV6aBwsna7
	/Yj2aqWs78+fZDgnpQow16Rxq9fLtqk=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-282-l_ldxrS8P7iFa_bJopIMcA-1; Thu, 12 Feb 2026 01:26:36 -0500
X-MC-Unique: l_ldxrS8P7iFa_bJopIMcA-1
X-Mimecast-MFC-AGG-ID: l_ldxrS8P7iFa_bJopIMcA_1770877595
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-34e5a9de94bso13979105a91.0
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 22:26:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770877595; x=1771482395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6P5ZMHhQ1gBULl+0OpCFy+J1BWjsvb7Pt0GdIxytUuE=;
        b=B3AJMp/DsSimf6wN63fpIZi4RvtTKpwx5A86MRQX81xvFa2Y0bs6kpM/Gk3p+jceoP
         /rcRk5vYOpmrQa7UqSzkkiO/pSs1kEIHJUkN7b/QbBcymMDl0IxYCvtIfdcrh0GG2iPr
         lKCOnZW39PAgSBDzNUaUNjItvqTMMQTxVx1LZGd5f/s9/ov/mQCAUmB7BQY5aUfTJVb/
         cPn1QHDo3nZJhEYT9bwzK2eWjNPm/TplUKd1kLnMQk/zqtDfxV6CP9Zg/m+n6qkPXXI5
         xw5TgmFR3ntUdGxJzZf7pQf+G1ROE7ed7eTD6LixKwByVpXN4ZLQS+qM8NKM6HhBVA79
         0/Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770877595; x=1771482395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6P5ZMHhQ1gBULl+0OpCFy+J1BWjsvb7Pt0GdIxytUuE=;
        b=hQZSZxlCOrIep7+KuhMhMUfs3vknuye1X7Au4lEVdJOGl2HnFAAKBmpwtzSFfvtvs7
         XE0DYdGrcLG0d0I1WwzUiTcYvhN3+Y9eeYQTpu4/wfg0PqU3p7Yr39Ze1qM5rzRnRb+o
         FtYD2jROJuqrRdkd6x07f8YVower+HpHqoC7fxg4f+5FN4tbruAg5gSaFhez85DFA3Dn
         ae716bu11p/M5921WnVP25HnuaOXj1Ye6vVdNvoG6xUbx2Qt+v8ybBfVwmFMNjO+VQL+
         oFMfR+AAys8H4dTDzNOtTDS5owPfwJL4D1HUmLFMRzMDEVlxY0g+BA1uK78HC5KksxQV
         5t4w==
X-Forwarded-Encrypted: i=1; AJvYcCVZ7h5FKjv2Uta/WneyDOhsCJwn1pWRAndH2DlshjYbt48WC42elmWYdj7EJVrkha8REOc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+GVn3lT7tin/oVQT6xjcX84rkbQlnV0Qa8suNn9K/8jgdvnsI
	Qk2ndEPKm/twaCwHaDUNdBlpTM+1kyb+lOzCW305I8ZNtho4gloYvxPku6tB+dF0RvKmov7fgyO
	pJOc+IuPLFcPOOUacPGZ7vGks0GLr/N9Lf/p2d1a4Fo8M1h/oN/uOzGr1bF7M9A==
X-Gm-Gg: AZuq6aLcM6RPdHe8WjOgkP+okuMsa4USkqkWcDC83rWW2ymJD52iuz1JndALaGV8iXF
	Bu71Gzoe+9Xzn3AleLQ9v1AGCzNtGpQIoKSMisDswmBQBRHJgfdzEdsP7peK9LYKOr1NouH5KH0
	a7wlXYXxdnYL7rxxnandrCl1DzpHMJK2DzqAZynXfLTBMC8z5rLk6yecJ6iRkXpIMRZxje2pshP
	5m2AFmpZCkKh48O4F5nsaBO/ixcBYaTjlaHdH6AcezSzRJvMzNHId15bnhBbnh6Uy2zHJ7qGsvk
	k+keoaYcuRFMdQ8AoRsL45KlxOIBXaICPbD6bfbSuTrceeImeb1Y/JtM+bX21YpUKwSyUwmtyYL
	9F6/lK80ABZG56Nov3lJX/cbYS1Z366n0LpwRtIPiPiFuMYwXZXF9YKs=
X-Received: by 2002:a17:90a:d887:b0:356:72f3:acaf with SMTP id 98e67ed59e1d1-3568f525fd2mr1628238a91.32.1770877595004;
        Wed, 11 Feb 2026 22:26:35 -0800 (PST)
X-Received: by 2002:a17:90a:d887:b0:356:72f3:acaf with SMTP id 98e67ed59e1d1-3568f525fd2mr1628229a91.32.1770877594670;
        Wed, 11 Feb 2026 22:26:34 -0800 (PST)
Received: from rhel9-box.lan ([122.164.27.113])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3567e7d95d8sm4894122a91.2.2026.02.11.22.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 22:26:34 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v4 19/31] i386/sev: free existing launch update data and kernel hashes data on init
Date: Thu, 12 Feb 2026 11:55:03 +0530
Message-ID: <20260212062522.99565-20-anisinha@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-70916-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: A876812A9E2
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


