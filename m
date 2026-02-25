Return-Path: <kvm+bounces-71748-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ePB/MIFxnmlqVQQAu9opvQ
	(envelope-from <kvm+bounces-71748-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:50:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D8D31914A1
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:50:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 02AAA309E781
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 03:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6236524A078;
	Wed, 25 Feb 2026 03:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MyezWHhO";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="M4jwlKLT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5280D79CD
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 03:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991417; cv=none; b=ue0FLSe35kGWpwmN/BlqmrNNc6gRxpLXa+n2iObONCgIATmDHNg8Ya0f3LTsR9wSl22EAV2Cto9lfy0ohlYVK9z4BqUCz2Vmwt/ZiB/HZl7fVWL62TtcNxrusqiRRVAZjT2ft8nMU+3oKectB14KV1mgZ1ecu4LSIWmbvZz9K64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991417; c=relaxed/simple;
	bh=oTcjVgaqLYrAFcHEyYYKxaZLD1+4d1CHz6oLzCUPLZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/W88y9D0BUg1RClEHcmMQTE7zVxGlTMFZdN7ZI+k4bPpInjmOAr6NzqG7mDqNQUAk5oijri4dFl+MinTL2u43SH+yuYiXJl+yjRozIAhP4uKdfU32Q/MxI6zppRK0A96HqEM8rpw0Unl8LhZoNpggr6fK886Asj1xB9h1TR07Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MyezWHhO; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=M4jwlKLT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771991415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tl/hVXrG5h9KMQqt7EBB/wY/rgh04YPReYpJxV14peY=;
	b=MyezWHhO/AZHHiSenW27Fkk7XMcqrOeGaWCZn9/hCHxzjI+K4QkO8n6kFycQSU1ED9AcRo
	qkfftuV7xaMmZAvu57uADug+giTV8fGhoGpyYNGkPb7XMG3unNamLo7gdp5pvr+c9iO3Lc
	bvuZXOAy3opS5y0yf2RvOeBdeEeUceo=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-S1Zx4qmJPEGgxm2mo1doBA-1; Tue, 24 Feb 2026 22:50:13 -0500
X-MC-Unique: S1Zx4qmJPEGgxm2mo1doBA-1
X-Mimecast-MFC-AGG-ID: S1Zx4qmJPEGgxm2mo1doBA_1771991412
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-356236ae3c1so411052a91.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771991412; x=1772596212; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tl/hVXrG5h9KMQqt7EBB/wY/rgh04YPReYpJxV14peY=;
        b=M4jwlKLT7oPzWBySIh8ejq595fsMjUOJ1ywIkc/cXp77+nrFK/xKfLQbnU/G+U6zpj
         GkiXSv3N9vrlrKJAQp4o3ckD3CxAo3JRJhZhRE9XAhpS7e0UloyvGkDoFKSdCMy752qZ
         vmayY1Dk7wMP/W2a3ynN8jijV8yVslZuQDwlcEq8R6+SQSUH9p30q+JOcuiZ/kmhWnrt
         4UXkxlfcqYe0ZzuID0o1qgya2Pb+OoRk+c7a2Of+PI/IOKoc6J0d4nJoCTeeOKJWPBuI
         FPkPQeg+nX/9PevnadEHk7HSwqPR1ydmveLINLafwoWWNfWjccFrs5orqQt255pJZztj
         xjsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771991412; x=1772596212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tl/hVXrG5h9KMQqt7EBB/wY/rgh04YPReYpJxV14peY=;
        b=bKn8Qb1OUbxD2vES9ukHnZ+m3YCDavdGK4tqn9wall3z8kUv6xehqu75QfAwtNLjPO
         d320xkAZ+SFj1+mugaWS2MfDYalLweS4NzT1NsypxsHT0sQG01vShOCnlb4IJ5pKIEmS
         ytrH+xwgzeuskUwlA1zusmK3umMxE8AfYLMGabDjBHNuW4myOmfBk00g6fYp6j0+JGul
         01fdf09/Bl35KbY65YH6XDN3ahp2gmCH8dt6ZKKpzgYukj2xHpdinvoYAuuYhjrFEHeQ
         40PDl28uLCZZ2MyqVSWet7ZtTevKny9itTJc3kkd5iGNwdw4Cvf0QyE3rY2oQk2lAoeq
         Jv8g==
X-Forwarded-Encrypted: i=1; AJvYcCXAfp6RMynq/8YTGfIWrx8B2TP7RlZAF6ibymlWHbSwF83APY11aaABgJGkRz73aFtAvgc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzemG+5T3AmCyPvyltlfVJTyl+HNU1fVgiSJRnxqVzKZVuW9aRs
	GxZ2rVIoq6Bk1AXNrByLpZm7xRg91XCUyO6ftFUbon783tPXQkTcIdcZySg85W+DsPf/GBaVHue
	r410Twjn4r20hcZiHWoMKZfbY2s26f4Fn5Fir8GY7GibXxw0Ckrkk6g==
X-Gm-Gg: ATEYQzz8d4enlLAg2baErDfGsVivkPnQVJQeaxjXcSBm3NyF48h/MZF7wpxf+bWKp1P
	RiVI3UV10A9NVI3j4iGtgPxK62qLrbmR31As2XOM35cEQ3e6G9bz7OYUXLAUzRCrkm3SLQ4Rwyp
	fuvjYgWMLeuBbjZE0YlyeweF/y2N+Q1mLH3/qk17fRGNjAB/PqJSmUak5PHxP0nATwE6PURuv4R
	zFhoYRL3T4syQSLrOk+hnPw7vVjKKvxDtLmGlb0DiPnguxLit6yFTlzR8OBIRIUMx0hy7C4eokq
	LQadtePNGfIFak2B9TN6pwMlGczWnM9nEEZ4yEzFNgzT+v1TwZWITNPpQ1fK4UZ6sOPmDZbw155
	PhPMElRv5Xl2WlOnxRRmRZdW7tDAw2+GWS0gDAfjM/bq46wCVdVi4OoQ=
X-Received: by 2002:a17:90b:2801:b0:34c:ab9b:837c with SMTP id 98e67ed59e1d1-3590089e3f8mr1848668a91.0.1771991412446;
        Tue, 24 Feb 2026 19:50:12 -0800 (PST)
X-Received: by 2002:a17:90b:2801:b0:34c:ab9b:837c with SMTP id 98e67ed59e1d1-3590089e3f8mr1848645a91.0.1771991412045;
        Tue, 24 Feb 2026 19:50:12 -0800 (PST)
Received: from rhel9-box.lan ([122.176.129.56])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-359018838b2sm1186006a91.5.2026.02.24.19.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 19:50:11 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	ani@anisinha.ca,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v6 01/35] i386/kvm: avoid installing duplicate msr entries in msr_handlers
Date: Wed, 25 Feb 2026 09:19:06 +0530
Message-ID: <20260225035000.385950-2-anisinha@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-71748-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3D8D31914A1
X-Rspamd-Action: no action

kvm_filter_msr() does not check if an msr entry is already present in the
msr_handlers table and installs a new handler unconditionally. If the function
is called again with the same MSR, it will result in duplicate entries in the
table and multiple such calls will fill up the table needlessly. Fix that.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 9f1a4d4cbb..6d823a7991 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -6278,27 +6278,33 @@ static int kvm_install_msr_filters(KVMState *s)
 static int kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
                           QEMUWRMSRHandler *wrmsr)
 {
-    int i, ret;
+    int i, ret = 0;
 
     for (i = 0; i < ARRAY_SIZE(msr_handlers); i++) {
-        if (!msr_handlers[i].msr) {
+        if (msr_handlers[i].msr == msr) {
+            break;
+        } else if (!msr_handlers[i].msr) {
             msr_handlers[i] = (KVMMSRHandlers) {
                 .msr = msr,
                 .rdmsr = rdmsr,
                 .wrmsr = wrmsr,
             };
+            break;
+        }
+    }
 
-            ret = kvm_install_msr_filters(s);
-            if (ret) {
-                msr_handlers[i] = (KVMMSRHandlers) { };
-                return ret;
-            }
+    if (i == ARRAY_SIZE(msr_handlers)) {
+        ret = -EINVAL;
+        goto end;
+    }
 
-            return 0;
-        }
+    ret = kvm_install_msr_filters(s);
+    if (ret) {
+        msr_handlers[i] = (KVMMSRHandlers) { };
     }
 
-    return -EINVAL;
+ end:
+    return ret;
 }
 
 static int kvm_handle_rdmsr(X86CPU *cpu, struct kvm_run *run)
-- 
2.42.0


