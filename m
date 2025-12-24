Return-Path: <kvm+bounces-66642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E8A0CDAE38
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 01:14:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D778E308A8F7
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:13:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53B9D42A96;
	Wed, 24 Dec 2025 00:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U5F926bD";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cGlEUnta"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E83C156677
	for <kvm@vger.kernel.org>; Wed, 24 Dec 2025 00:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766535185; cv=none; b=r7UdqIwtrnhABZ4xQmC/HlG+16uwHnsO9h90OJSW1ZxPGFfZSvlVR8yGvrowUHYH8JWlznPgfegnfwMpmBqar0W1kxqAhIzXpSiBnS/P28UO0gNN4ZWIsiKIuLGs4Otwf419Bl9MiQEs25Hn5DXHGUv8I22/Yg0dRCynCHJjsoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766535185; c=relaxed/simple;
	bh=Hhr7PXcdmRfFR3kTN6U/D9XNsL/5WLUMGhSvIh4gREQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QSmw7qVUrLD9ACkpH3zUuAWR3CiGHzaQ31PI+W+9SrmKhFJFPwLw5TJxxfT2Ls0B2/dqH9ANMZKn4w9WOFgPU+lRN4Z/ybogi1U51JaoMaSvD7hw20SdbudjkX1sSUGWEFnR7SxyJpKXiLXSVGYM4ReFP3eVqi8AyWyGx5CyCs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U5F926bD; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cGlEUnta; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766535182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=II+twdH/pEyHm4MG2MWZs5S1/6s3iyRXmEkcwRND9R0=;
	b=U5F926bDc6qN3sMADP/J77pr+xprakvZbcWpY4cpei5MPK6/mGFAWkiYezOgGrGJLqw83k
	lsIaUul1i9JAPj1AP1tChXVObSTNZwlgkapyKbADdJE4EvRAIWmtqP+7lsQ7bBx4j5yLSL
	9wXJz6Y1MTHIMrmwldQjBRA8KqJtVGk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-BC1pVbzmNsCc82yi2J8hpg-1; Tue, 23 Dec 2025 19:13:01 -0500
X-MC-Unique: BC1pVbzmNsCc82yi2J8hpg-1
X-Mimecast-MFC-AGG-ID: BC1pVbzmNsCc82yi2J8hpg_1766535180
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47d3ba3a49cso5012765e9.2
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 16:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766535179; x=1767139979; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=II+twdH/pEyHm4MG2MWZs5S1/6s3iyRXmEkcwRND9R0=;
        b=cGlEUntasD6+dD55yA6HC7YrVb0oTw/8JYfV7LP2T6hb0J1lair+lVSYL9OOmh0Gw5
         e2cgClgTeHl3nTrC2dkUWLAckUL1mPxMMRGZB6P8JHRmvfCdCA8SM5WKc7iD9KSwYgEj
         uFOV4sZtHRKNtxD2kbXgBpR45Exdoo9XnnClGbaOgeGW8zBE+WF+GlF7slbKOTKNFmfD
         V+10e7ixpr19itUVk0BLTatGFnVPIjH0+/7a3qbVzLZp33a1pgl97RvG4zKjPGBLUULc
         Fq0qou1qRjF5bZqQVdC44lUqzNIaDbZoDEt0q59WTOzl8KGjQURoVv/+ceZqawZjy4/n
         UQNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766535179; x=1767139979;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=II+twdH/pEyHm4MG2MWZs5S1/6s3iyRXmEkcwRND9R0=;
        b=ocQV/WDV2aohVcncbBlz03eP83S59Mx+2lVrPvJdh/Q4i95uu/zvgCHmW8BN7LWVLA
         Vechbf/Hjs4lIvpeVX146n4lmB6mPfhBQo6gwxlIp9AjYzSEu+NJaxWXN8tns12BJFx9
         JbckQ4gKJUos5THPSLHgTjgF4Ks0cckXd8aNeUpEgNHlSbBrQKwfhurqKSZH223F0Ye2
         V8rsimF1o+f7z+NduJCwwEIOqwfJTdeE9u9PY3XqNFA41GzKY8fdas6uth/mRptDzMZL
         SSw2Bc3CxAyzIMNretqigwCaCLEpT/7EY4ZYhY9LcWi5ga0oLgCd1LfXQJe3WWZ18Kmj
         LXkg==
X-Forwarded-Encrypted: i=1; AJvYcCUG7JBwCVFYlxu3xnOb5p72M9wMhN6gw9tcS7JjI7dJ+Cnz/xMFHYrHCCo0394hg4fuKXM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCvvmoUQwfJD9qSaWdhhUzwtSu5RHwGexdkX/EAIYJ/OfLXc0C
	NckY2QjY3gGmNbvB361TxevtJsH5iAKJlNNIKL9CVwgBuAUXVxMRn4yWWXEivfsg6Z0pOKVvrOk
	WUt9OHlHk8IYZj0Wv47r5kRxkNxGK1k957v5ZeoLalDeXwNIcjHRqwi8ydRxAXQ==
X-Gm-Gg: AY/fxX4xeMiqY415dYVzDTd3npPMQ5UJHmLE683sO1P7ZJKxNM9jCDAcmzWMpI1ozNo
	dRuNoyO/0xnzdXJu8aMNrT3DA8XRSpPNgm+++jZQBAH3uDeI3JcetT2SsFaC3n4GRr/1siUZQuM
	o76Poi8mDsP0tsSAGmRgkiIh51AdK69gw3PRlYoBWiZeL3ByAXoqtpAmgu2K/LBrvHNPQRNepMu
	gIdcfeF9ZDC2kKStxFbviU+uT8AR7wb8gbBcM5cEYQl4s0QVNstNTMSvu15nrwMzI4zZyyTl7CD
	e5hY8oMlqy4lbVeNZ11F94Xk+LEJC2ptOOWPWa0ypAVBdorTxHkvVvhRXb2StmGMoE1JC+rFj8b
	x2XGEdYF5acCbl9Yw/ChPHMzyomNcfQyyj+fB60pZOBp/0gFlIqiUTYjR4O3FtxWn2KosfeZY7h
	HISgoUDK/BqgbCcbY=
X-Received: by 2002:a05:600c:4fd4:b0:477:a219:cdb7 with SMTP id 5b1f17b1804b1-47d194cc59emr145265235e9.0.1766535179468;
        Tue, 23 Dec 2025 16:12:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH+OTzAeyC5yD8A9kSSl7IDV7BRHd2VCz2+9zTgZoj/J4FaHajoxMrs8M/feG65zxctkl3yXQ==
X-Received: by 2002:a05:600c:4fd4:b0:477:a219:cdb7 with SMTP id 5b1f17b1804b1-47d194cc59emr145265165e9.0.1766535179148;
        Tue, 23 Dec 2025 16:12:59 -0800 (PST)
Received: from [192.168.10.48] ([151.95.145.106])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eab33f5sm30942577f8f.41.2025.12.23.16.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 16:12:57 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	x86@kernel.org
Subject: [PATCH 3/5] selftests: kvm: renumber some sync points in amx_test
Date: Wed, 24 Dec 2025 01:12:47 +0100
Message-ID: <20251224001249.1041934-4-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251224001249.1041934-1-pbonzini@redhat.com>
References: <20251224001249.1041934-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make room for the next test; separated for ease of review.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/x86/amx_test.c | 26 ++++++++++++----------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/amx_test.c b/tools/testing/selftests/kvm/x86/amx_test.c
index f4ce5a185a7d..dd980cdac5df 100644
--- a/tools/testing/selftests/kvm/x86/amx_test.c
+++ b/tools/testing/selftests/kvm/x86/amx_test.c
@@ -144,7 +144,7 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 	__tileloadd(tiledata);
 	GUEST_SYNC(4);
 	__tilerelease();
-	GUEST_SYNC(5);
+	GUEST_SYNC(10);
 	/*
 	 * After XSAVEC, XTILEDATA is cleared in the xstate_bv but is set in
 	 * the xcomp_bv.
@@ -154,6 +154,8 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 	GUEST_ASSERT(!(xstate->header.xstate_bv & XFEATURE_MASK_XTILE_DATA));
 	GUEST_ASSERT(xstate->header.xcomp_bv & XFEATURE_MASK_XTILE_DATA);
 
+	/* #NM test */
+
 	/* xfd=0x40000, disable amx tiledata */
 	wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILE_DATA);
 
@@ -166,13 +168,13 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 	GUEST_ASSERT(!(xstate->header.xstate_bv & XFEATURE_MASK_XTILE_DATA));
 	GUEST_ASSERT((xstate->header.xcomp_bv & XFEATURE_MASK_XTILE_DATA));
 
-	GUEST_SYNC(6);
+	GUEST_SYNC(11);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
 	set_tilecfg(amx_cfg);
 	__ldtilecfg(amx_cfg);
 	/* Trigger #NM exception */
 	__tileloadd(tiledata);
-	GUEST_SYNC(10);
+	GUEST_SYNC(15);
 
 	GUEST_DONE();
 }
@@ -180,18 +182,18 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 void guest_nm_handler(struct ex_regs *regs)
 {
 	/* Check if #NM is triggered by XFEATURE_MASK_XTILE_DATA */
-	GUEST_SYNC(7);
+	GUEST_SYNC(12);
 	GUEST_ASSERT(!(get_cr0() & X86_CR0_TS));
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILE_DATA);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
-	GUEST_SYNC(8);
+	GUEST_SYNC(13);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILE_DATA);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
 	/* Clear xfd_err */
 	wrmsr(MSR_IA32_XFD_ERR, 0);
 	/* xfd=0, enable amx */
 	wrmsr(MSR_IA32_XFD, 0);
-	GUEST_SYNC(9);
+	GUEST_SYNC(14);
 }
 
 int main(int argc, char *argv[])
@@ -257,14 +259,14 @@ int main(int argc, char *argv[])
 			case 1:
 			case 2:
 			case 3:
-			case 5:
-			case 6:
-			case 7:
-			case 8:
+			case 10:
+			case 11:
+			case 12:
+			case 13:
 				fprintf(stderr, "GUEST_SYNC(%ld)\n", uc.args[1]);
 				break;
 			case 4:
-			case 10:
+			case 15:
 				fprintf(stderr,
 				"GUEST_SYNC(%ld), check save/restore status\n", uc.args[1]);
 
@@ -280,7 +282,7 @@ int main(int argc, char *argv[])
 				TEST_ASSERT(ret == 0, "memcmp failed, ret=%d", ret);
 				kvm_x86_state_cleanup(state);
 				break;
-			case 9:
+			case 14:
 				fprintf(stderr,
 				"GUEST_SYNC(%ld), #NM exception and enable amx\n", uc.args[1]);
 				break;
-- 
2.52.0


