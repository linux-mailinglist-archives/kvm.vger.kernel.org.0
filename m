Return-Path: <kvm+bounces-66916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F07CACECEC7
	for <lists+kvm@lfdr.de>; Thu, 01 Jan 2026 10:13:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 46762300B2A5
	for <lists+kvm@lfdr.de>; Thu,  1 Jan 2026 09:11:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBBF12C0281;
	Thu,  1 Jan 2026 09:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CuoQNaZl";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZWqwi8vG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F42052BEC4E
	for <kvm@vger.kernel.org>; Thu,  1 Jan 2026 09:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767258333; cv=none; b=BpSz/4KBpdj95QzQvLBFHlYGE1JnJXn0+OfB/l7w1JKlt91mbBcRHy9+h/qp+HKPKHvWHMgNlvpCwuoZ4PMjasoxZuLHt/OAijsTA+u8lPp6Bhbp3/oqzw+TC94IaRrxE492PjjyMpGV977xm600C0Y4LapNn8X2N4xcX2pDe4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767258333; c=relaxed/simple;
	bh=HIN6QlfVhZ4iSbowtVUzS1M4y8SBEv60XuhX6Cf8bms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n49DOLiU32lLszGY/SWZakpawA6g4Zz8+x96iUiQ/CN803PWJF3rNGbHBVv3emMulfYyYi7Pto+6cGfD9tLSvA0tO7k900sSCO4kMYqbIGDu3THEVBBcvYLYc32Gzt6QUqd5Fc/ID6r3g1MbLX79wmBQ/Ye5VRTZ85QZgNxd/xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CuoQNaZl; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZWqwi8vG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767258330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QTE9pNuMeO2V67xpWkcGk7SdONFO3mBmobXIG/f1Hmo=;
	b=CuoQNaZlwTSg/TTOZkCu7anejHoxk+pXAuBv/yZYOEIl73JPrM1NR/JCoWM1bb+AZAt9+D
	TCowsxtkuG9aGLTPZiZVDBx7q+7mshiv4WdOL3vj7Kjk1nTRT2esLFDQbEmtTWu3gGSR6h
	7y+fiOoO+89WS2fkneARRM9Ub/GcvyA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-352-7Vz7KqSTPsGrW4BfWWqTAg-1; Thu, 01 Jan 2026 04:05:29 -0500
X-MC-Unique: 7Vz7KqSTPsGrW4BfWWqTAg-1
X-Mimecast-MFC-AGG-ID: 7Vz7KqSTPsGrW4BfWWqTAg_1767258328
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-477a11d9e67so70253915e9.2
        for <kvm@vger.kernel.org>; Thu, 01 Jan 2026 01:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767258328; x=1767863128; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QTE9pNuMeO2V67xpWkcGk7SdONFO3mBmobXIG/f1Hmo=;
        b=ZWqwi8vGnnusemr4ekiEnYZsTDG0jX4DAFYfojl93J+SauqEpqTqLWUJBdNpFFq4Vf
         /7r2O6JaFrUSOrZFi3YnbeTtxMW0SIt2VBiNsgoB95LG2uTLPIfoo1efsNnkubCyie1S
         YPtUiMIpFvjMVB8XmHdoeMHe3LASByE+gG7GjulrW+hTWiNqwFgooIJmWQRSzSoPVRtP
         IEtR3Jd0jORx7J2JuDoZzTHQEYm6Y/WV7/3mnMJoKX+A/JcoyAMWXawlZf1kYiEGGMPX
         54IYH3nFMPMr3H4uim1cPnq99WRgY996T0hEHesTQaJWZmpngO6EeE3us7jdXdGkA3IK
         84YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767258328; x=1767863128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QTE9pNuMeO2V67xpWkcGk7SdONFO3mBmobXIG/f1Hmo=;
        b=dmnQQl3qW8+C6xQBtTZcw4WOAvRnSN5U71j8y8x8ScBTOCDtLfqavksLqGRiRsSRUh
         mSxLvBUyKqJrlmUpCdmvQU1QOJ+dpveriinETTLR8YMwYPkp4/DRnrIR4iB9H4I0zARA
         V0raAGVlDLPYvgjQd+fD7JFkkVhGBAN4wDGa0ROopLt+Acu7xvkoTyWV2owaLzSvNpmX
         TdB3ocTxHuBN6ptPgZbUBzmBJfT0An5MG0WLuytalXWqmIJahQpdc/+asmr3WqZrs8zK
         3Q5Qp3+sqvpd6/l6diwRthrVLovh2mKi/ll3i0AERVuApuq2kBsrgm4bmR/Ik91j+tCm
         jhoA==
X-Forwarded-Encrypted: i=1; AJvYcCWocBNpAkZc8g+erpv1Vd1YkJ7x7ruEcuQ+0Kj1PXaFH/oCUXhtbHLowF3XgneqntiDDSM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQEuzvBri/ZWSIEm9gOr7igls8hTVSPPsd6yZ3rmbtwOcp5MKM
	QNy9dQtefz/fFmN8pOb97CEh5hdzgsYu8Peb9C2NBX3TMln//wz74a4M0LLu7r5wNAC8Q6nXojo
	YbJgga3xT94Kq4a24R4VQy05QhBu+Chns8DrW+f9HG4/tk9ivJqnMSw==
X-Gm-Gg: AY/fxX6li6wcR6a9OMXclN6IJixqptBpZZ/x6cF0L1TWu3uqVWdS9teQhQV5S0b/mZH
	rqGfcoElWhtvTk4Ki2JmsPh/J+IKpL5ivf7I3UhaSye/OotC6S+2gbfBOeIQAv7SCy/3FdZew85
	s/YZWsH/mlOmi33kUq5zq8YKf8iOJJBwFjs4HKzu5Ji7ZBopzFucgKbcwcmQw8EkrjCID+4qUT3
	ymvWaWfUDxN6ms5r/cS15mnbMtuwUHEuGK4v2/6WnImCjPomupaQUNFQu1gLCPdCNjuZ8IuSUWL
	inlVXVTFAo4MJzWyJaxQQOrSUdn8PQ+ukGWygkEjSmKT9+rz6Iz5Ii4r74mcMr7Jr2eOps1jTkR
	O9pavmvIYm+Cx8C0R/UJJohUKkRLrt9qW5RMGMkoYAR0Ad2m8VKFRsAS7fhN67ULICSOxeBJ0/I
	WTfu8xuZUkfYhNug==
X-Received: by 2002:a05:600c:468f:b0:45c:4470:271c with SMTP id 5b1f17b1804b1-47d269c7019mr429028405e9.18.1767258328309;
        Thu, 01 Jan 2026 01:05:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEBmL9IKTWaJ4XtgqdZRB2G/c+eVr1WEScolURdqAQ/qGjBC7KkISj0FN8QL1kAXg0awIdr+g==
X-Received: by 2002:a05:600c:468f:b0:45c:4470:271c with SMTP id 5b1f17b1804b1-47d269c7019mr429028105e9.18.1767258327943;
        Thu, 01 Jan 2026 01:05:27 -0800 (PST)
Received: from [192.168.10.48] ([151.61.26.160])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be27c2260sm719923195e9.15.2026.01.01.01.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jan 2026 01:05:25 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	x86@kernel.org
Subject: [PATCH 4/4] selftests: kvm: Verify TILELOADD actually #NM faults when XFD[18]=1
Date: Thu,  1 Jan 2026 10:05:16 +0100
Message-ID: <20260101090516.316883-5-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260101090516.316883-1-pbonzini@redhat.com>
References: <20260101090516.316883-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Rework the AMX test's #NM handling to use kvm_asm_safe() to verify an #NM
actually occurs.  As is, a completely missing #NM could go unnoticed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/x86/amx_test.c | 30 +++++++++++++---------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/amx_test.c b/tools/testing/selftests/kvm/x86/amx_test.c
index 00a42a592a37..371355bde54e 100644
--- a/tools/testing/selftests/kvm/x86/amx_test.c
+++ b/tools/testing/selftests/kvm/x86/amx_test.c
@@ -69,6 +69,12 @@ static inline void __tileloadd(void *tile)
 		     : : "a"(tile), "d"(0));
 }
 
+static inline int tileloadd_safe(void *tile)
+{
+	return kvm_asm_safe(".byte 0xc4,0xe2,0x7b,0x4b,0x04,0x10",
+			    "a"(tile), "d"(0));
+}
+
 static inline void __tilerelease(void)
 {
 	asm volatile(".byte 0xc4, 0xe2, 0x78, 0x49, 0xc0" ::);
@@ -142,6 +148,8 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 						    struct tile_data *tiledata,
 						    struct xstate *xstate)
 {
+	int vector;
+
 	GUEST_ASSERT(this_cpu_has(X86_FEATURE_XSAVE) &&
 		     this_cpu_has(X86_FEATURE_OSXSAVE));
 	check_xtile_info();
@@ -195,17 +203,13 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
 	set_tilecfg(amx_cfg);
 	__ldtilecfg(amx_cfg);
+
 	/* Trigger #NM exception */
-	__tileloadd(tiledata);
-	GUEST_SYNC(TEST_COMPARE_TILEDATA | TEST_SAVE_RESTORE);
+	vector = tileloadd_safe(tiledata);
+	__GUEST_ASSERT(vector == NM_VECTOR,
+		       "Wanted #NM on tileloadd with XFD[18]=1, got %s",
+		       ex_str(vector));
 
-	GUEST_DONE();
-}
-
-void guest_nm_handler(struct ex_regs *regs)
-{
-	/* Check if #NM is triggered by XFEATURE_MASK_XTILE_DATA */
-	GUEST_SYNC(TEST_SAVE_RESTORE);
 	GUEST_ASSERT(!(get_cr0() & X86_CR0_TS));
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILE_DATA);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
@@ -217,6 +221,11 @@ void guest_nm_handler(struct ex_regs *regs)
 	/* xfd=0, enable amx */
 	wrmsr(MSR_IA32_XFD, 0);
 	GUEST_SYNC(TEST_SAVE_RESTORE);
+
+	__tileloadd(tiledata);
+	GUEST_SYNC(TEST_COMPARE_TILEDATA | TEST_SAVE_RESTORE);
+
+	GUEST_DONE();
 }
 
 int main(int argc, char *argv[])
@@ -253,9 +262,6 @@ int main(int argc, char *argv[])
 
 	vcpu_regs_get(vcpu, &regs1);
 
-	/* Register #NM handler */
-	vm_install_exception_handler(vm, NM_VECTOR, guest_nm_handler);
-
 	/* amx cfg for guest_code */
 	amx_cfg = vm_vaddr_alloc_page(vm);
 	memset(addr_gva2hva(vm, amx_cfg), 0x0, getpagesize());
-- 
2.52.0


