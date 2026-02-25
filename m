Return-Path: <kvm+bounces-71764-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SEFyGMNxnmlqVQQAu9opvQ
	(envelope-from <kvm+bounces-71764-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:51:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1147A191526
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:51:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4FA72306B9D9
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 03:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E84612641FC;
	Wed, 25 Feb 2026 03:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ecaiOKLG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="KjMbS2lH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B9B79CD
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 03:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991486; cv=none; b=CvTsdLAR5tQd8Upp0nb/n2Z3s59Irif63s4En6Xf1Mh9BGP8VVLLt2NZ4Iy+YG6OstMg+EL0brgpgxxC7DHQ8AtzdzxZ98fysUy9nYH04eSDFDX/7uGQY24E/cus8Je2HFMYuR6tHJFMAaSC6PTUhk9petDtuQYGhArHh/ZfAio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991486; c=relaxed/simple;
	bh=23O8pVjgWHoWC3mZeSu+Sniei65Eb9tIswTBaM/vPso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bP/YijlbrRjyvgNUvNZKqEBsZttCiB8dgBZ93qygDPj1NIuaZlKqhKltJyop9TzecyIiKP09JyHM5d9blYV9v+et6M4OhaJv82m+Gk/qqQPVu4zmuSPXrlTMdExEq3WA4gjUNoBnGzvPJlItFRaKgGWHLXfYMzGCaCjGYV1mG1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ecaiOKLG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=KjMbS2lH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771991484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6P5ZMHhQ1gBULl+0OpCFy+J1BWjsvb7Pt0GdIxytUuE=;
	b=ecaiOKLGGafv9oxjgz11pAkhVzZ1epabI5UFUGSxlPr/hjF2e4qBoLhwmvQHPBhUGzoPJU
	VjmSXQ2K1ryWlrW6yB9m5A4D7KmG9GquMZGUAWY4CNDvg2DNCNVmhzM2dDqLSGF6kQweLJ
	++m4T8uNIczSqantLbupi1tthQPO83k=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-496-jJOjcD2VNI2uCRs6V6ISqw-1; Tue, 24 Feb 2026 22:51:20 -0500
X-MC-Unique: jJOjcD2VNI2uCRs6V6ISqw-1
X-Mimecast-MFC-AGG-ID: jJOjcD2VNI2uCRs6V6ISqw_1771991479
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-358f058973fso1013108a91.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771991479; x=1772596279; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6P5ZMHhQ1gBULl+0OpCFy+J1BWjsvb7Pt0GdIxytUuE=;
        b=KjMbS2lHKBCb6PyAyaIKxVLlZGVIYAx4RY9uGkFtt7KVyJPs8UK1D97ORKhWmSQqLm
         19H+KOdehMAf8WdNJIPn0AvD5hM+NaB+jFV3lYsHg658qNY80wTQzeE00kKXUgf1n+oG
         TQvJSEg9hofTC9w2+iRSvSZU5MstX3uvu20iyR546jh4vNIqCk70urphihhOWTOXUM9s
         owKeHO7y/hrHTJoHL3feXJSn4NY17qB8f19l0jNIelcWymAbhSi7G9EBGeEMNbg0MZl+
         1lDXP/xFXbBJRY+1mIr15CwP1r6BhvBfMmyr9fh1aKzGu8UYuMxff6MohAmSw9t65rti
         h66w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771991479; x=1772596279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6P5ZMHhQ1gBULl+0OpCFy+J1BWjsvb7Pt0GdIxytUuE=;
        b=uUf1cQ6wUOR73+4eev7ZA3njDjAXpKjHe8Gi+WoRgtsiKIWRlCWlE9DmprUs53Vq2j
         jWFs6r/YxQaEyriPawrofVP93XpRXg/Rl6MRXVVGsxNCF8PbraMeOotfUET65mTnGa62
         PL1OKlW5KTLhKryItFHNMj/N0XJFvTEVp3yObcgjgPo+Ye+yrmYZxwx6LP7DTjBFjh6Y
         H0Ka96U0zIuUnzJqRtK3PpXEJA0MDVYoM5HH7vCcsrTx+IGZoz8IsTEACnT3zedRxeSl
         0CqrZeRjX2DBGf6vo+RnrtmSh6AkT/sVQ2DR4vVjyUm4L94wgNglGU5wgknqC9mP7+DR
         druw==
X-Forwarded-Encrypted: i=1; AJvYcCU5km9QZLS561xvqkR3HSsrBRqd6VtYbcU6h10EfLqSVsZ1BKBlawo+3o/Nuvz4oz9DKAo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkFH9woxLsSuep2U6DvVpFLshXmMxjyD6N/vAoBnekJ1tJnUEq
	nHVPhvm1LaQqzGlvMvLMN9m367cWW/rBx7D4VyH2GQ1Zk5mZmmvjNZYxVGVXFPXggZ1wTNo1DwR
	s4EuxQ0mZnTUrIE3nEydIuTTw3apJNJWYQARlJoSsNgn/KCe/tTu+5g==
X-Gm-Gg: ATEYQzzY69x5Fen5gsYCYz3bNv6rEyuKTAI8VFqJVy30HajfoaCRSWJrDRNam1qlfIX
	I+3V3dsZeoriCGiWgSq7qWNnL0DMj76O77PP/2nQomsQSz8JBG/Onhp95oBKmnr+2YkLJian0Q5
	c3A1fym9BkObpfC1Ek66FGFU+Wjna8kaHK0qx02ac2HAlgsP5tJwj3c1Rhf+fkvefVXk7K2phJo
	vk+2UDDp8DYLoTujUVSmKb0ml7fsPAem92G8mc23EfoVNlnpha7CnKsgUyXggkAd81dFaLYNc6a
	fP6UFNiBYjgCklTa8shQf5K8paR3qGWt69kRwgRgNP2RSjqfVcn4XfzGrPo29en2ayf6GH0wbwD
	94GUmvlkm9+FJIOrRglT7JuxyEYKafsjiHANpHfOc5eFtQ6LjO3BI7lo=
X-Received: by 2002:a17:90b:3d47:b0:340:4abf:391d with SMTP id 98e67ed59e1d1-358ae8a45f5mr12833949a91.16.1771991479403;
        Tue, 24 Feb 2026 19:51:19 -0800 (PST)
X-Received: by 2002:a17:90b:3d47:b0:340:4abf:391d with SMTP id 98e67ed59e1d1-358ae8a45f5mr12833928a91.16.1771991478969;
        Tue, 24 Feb 2026 19:51:18 -0800 (PST)
Received: from rhel9-box.lan ([122.176.129.56])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-359018838b2sm1186006a91.5.2026.02.24.19.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 19:51:18 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	ani@anisinha.ca,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v6 21/35] i386/sev: free existing launch update data and kernel hashes data on init
Date: Wed, 25 Feb 2026 09:19:26 +0530
Message-ID: <20260225035000.385950-22-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71764-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1147A191526
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


