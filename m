Return-Path: <kvm+bounces-66644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id CD279CDAE23
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 01:13:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C223C300A572
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FAE71A317D;
	Wed, 24 Dec 2025 00:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d721B4Pj";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mraKw6va"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7C018DB26
	for <kvm@vger.kernel.org>; Wed, 24 Dec 2025 00:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766535190; cv=none; b=qGuT6bJGARkegQiIiQDmhcruoTTfE/AeyCvh0mHWUrf8Dt1W/El/JP1C9gepGhFqJfFyqvr4p5tr2y+APUI1mF5g1MVgK4H/rNDVwwbKNGQH2jhSJa97Oj4a61nbwyCEKHwk2ICTLla+TCDAz+dTmxzuQBjEUVZYq/SMjvmGApc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766535190; c=relaxed/simple;
	bh=c9wGy9F+ZumVy4Jv5wQ/Y4sWu0FPsWAgkyF5DR5pTaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qaMm7EJofNPEkzEOuJItBFJy6VBuBO0jgRZLeTiC/MNwioJjqQpTYHhoHVOSjAPEo3E/ANBz7d6J1di3j2HKrHhfLT1/p+iaqdVojKXp2WoaRKEKd6BopnFXp5CvASl9tC9Rr2IiaPxOkB204upPKkKTZjN0HV/BJnKvSdT/DZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d721B4Pj; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mraKw6va; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766535187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZP7S2GMgajruIhbPgbnDsTvupUVzprH0sZEYwfNJjmw=;
	b=d721B4Pj+XM+vzNJImK/7IIgiWUrFq+DfXW04b9aU8fFFgbQ4Kch8AvH/8ZT6F5499TP/z
	1/QznSkHn+KQwMKxCsks5lmXLYrkpSadQA9KBmFuRq7xzdUOw0wbaD9cWJWg9R1WTegCay
	PBHyXAk3ib1HgquTWPvUqly4CaYEipE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-oon1BG_-PZqJaIBopOMxDg-1; Tue, 23 Dec 2025 19:13:05 -0500
X-MC-Unique: oon1BG_-PZqJaIBopOMxDg-1
X-Mimecast-MFC-AGG-ID: oon1BG_-PZqJaIBopOMxDg_1766535185
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47788165c97so30878715e9.0
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 16:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766535185; x=1767139985; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZP7S2GMgajruIhbPgbnDsTvupUVzprH0sZEYwfNJjmw=;
        b=mraKw6va4ADsqNiCSXbk+ibeHd68aAL/MRNisXQG+ZvCU2wM2Uc3w4Sx1ivJz/Xb08
         sMDu+Grw3pTmqgdCRSqdVew1d3CxlxZ2OC1+YD9aIoWJEJjAS4yqUjJO0xTVqmjIJ9LG
         94saEuW6EU/947QzPWS4J5x6DvnPcH4hHa2oktENgKybbjg27yoiDkK/WnCp9be4+P3N
         C31Y5jrZEtUY5p3bssPG5j5sDI6U8iHDZ1pAWForE7cTsL6EpB4bJTax4eXEV9YTSoBd
         /sW2DnHBgtjJ3FkgM1fJXvX/REcI8uCvnCYdMFiPrDsPzoFS1m3PhWlM68J+ilc0a0/r
         hLXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766535185; x=1767139985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZP7S2GMgajruIhbPgbnDsTvupUVzprH0sZEYwfNJjmw=;
        b=BIppTydhDtGkyH0AhDPdxqtz/TfLd6rBB47OkI32L2TFLsC2GD3HKBwDrbscutckOY
         Y3z6Omd62mTG2jtOOFREvXxFDQE7jks3jnhUTAWXpg8XreAmoHx69qu6yZ36w5DpdaSa
         mMslfPIqfxmE7ao6Vl0tsKkFZ88aumk4v3Si3OD00byfiPru2S+Za8yK1ja34ulBKHIP
         DP099z811OOGF5ZCvJDQb5qfY/50VX7O0giRvG4d3RtKRrlKN5aKpr2pNfCrd8MVyrVa
         xqxzvpHFHK3iibe3NRB5IAW4GnbHTncHG0jkuOV8uru8jHzkZOMwU9N2v+1UiIbQW8Yn
         gVzg==
X-Forwarded-Encrypted: i=1; AJvYcCWNo8wNbuIgZzFChwhvHPuj5l3qXKAUfbp9QFVHl5mj4jz4sqCbelhaGODqsR+nTn5tBPg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxE7AkpWmZFraT+EuMVut/8VB2KmPax/jiD6/hmjpNkbN9S2xTX
	Es11nLcSnc7mmyzCwC98SsCTVCdEwLFbrWurninz65XIb2P6QZj508KM4liTvN9yNoKq6nUWbzi
	7UxTN6AUiLa0GPCGnnqH9wsHbv/vdPDoXyUEQW5To8FLJGEyrqQaqlg==
X-Gm-Gg: AY/fxX4MSGwLXMo25VihUayQm/dSejwtJRGiJmuS0aiqK7WzFlWCwLaD/oN5l4R19xl
	7y5YGtqPDnBq5ihgfyNjpnToq3qfPv+7gy0UOiJIaLbICrVEyEhsJMnZorzJhCReY2wEe888SXW
	1utmCPnyNHDLuJYWhvX7CJBUGNpyAPGuG6pfuh03Vou5vP1XxO2z20PnWOfbC2eISeN+XlFo6wS
	FD72ItBDKBHzXux3FR1HA9hwbBkoFskhklGt4O9jAdwAICSwKrOlVfQrOZpzNScWAI9pAmvD73D
	B0vQQO8tyumx+9UIPT8F5hVo33wNRE1RouGEnVgxGIemrNNSijKf5UIQ77+hIVUFlqJZbzJMmt4
	ShsnkFy8s4I8QIuomhWj487YUXDV01FX7KQBJgm1GBCrylGBXiZID4nnWwumRfvbD1m3Gpbl4Rr
	wmkKdxDEqXtzVMKwM=
X-Received: by 2002:a05:600c:4506:b0:477:79f8:daa8 with SMTP id 5b1f17b1804b1-47d1957da6cmr164308955e9.17.1766535184668;
        Tue, 23 Dec 2025 16:13:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEAOTNMaYX6wvIpavXVkFRAXB61rUrOXBtv+ITgW4CWC1Dw0QYGzvTLybENg3XQ7l3vGJWmlQ==
X-Received: by 2002:a05:600c:4506:b0:477:79f8:daa8 with SMTP id 5b1f17b1804b1-47d1957da6cmr164308795e9.17.1766535184278;
        Tue, 23 Dec 2025 16:13:04 -0800 (PST)
Received: from [192.168.10.48] ([151.95.145.106])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eab2a94sm30897852f8f.43.2025.12.23.16.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 16:13:02 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	x86@kernel.org
Subject: [PATCH 5/5] KVM: x86: kvm_fpu_get() is fpregs_lock_and_load()
Date: Wed, 24 Dec 2025 01:12:49 +0100
Message-ID: <20251224001249.1041934-6-pbonzini@redhat.com>
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

The only difference is the usage of switch_fpu_return() vs.
fpregs_restore_userregs().  In turn, these are only different
if there is no FPU at all, but KVM requires one.  Therefore use the
pre-made export---the code is simpler and there is no functional change.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kernel/fpu/core.c | 2 +--
 arch/x86/kvm/fpu.h         | 6 +-----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index ff17c96d290a..6571952c6ef1 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -846,7 +846,6 @@ void switch_fpu_return(void)
 
 	fpregs_restore_userregs();
 }
-EXPORT_SYMBOL_FOR_KVM(switch_fpu_return);
 
 void fpregs_lock_and_load(void)
 {
@@ -865,6 +864,7 @@ void fpregs_lock_and_load(void)
 
 	fpregs_assert_state_consistent();
 }
+EXPORT_SYMBOL_FOR_KVM(fpregs_lock_and_load);
 
 void fpu_load_guest_fpstate(struct fpu_guest *gfpu)
 {
@@ -899,7 +899,6 @@ void fpregs_assert_state_consistent(void)
 
 	WARN_ON_FPU(!fpregs_state_valid(fpu, smp_processor_id()));
 }
-EXPORT_SYMBOL_FOR_KVM(fpregs_assert_state_consistent);
 #endif
 
 void fpregs_mark_activate(void)
diff --git a/arch/x86/kvm/fpu.h b/arch/x86/kvm/fpu.h
index f898781b6a06..b6a03d8fa8af 100644
--- a/arch/x86/kvm/fpu.h
+++ b/arch/x86/kvm/fpu.h
@@ -149,11 +149,7 @@ static inline void _kvm_write_mmx_reg(int reg, const u64 *data)
 
 static inline void kvm_fpu_get(void)
 {
-	fpregs_lock();
-
-	fpregs_assert_state_consistent();
-	if (test_thread_flag(TIF_NEED_FPU_LOAD))
-		switch_fpu_return();
+	fpregs_lock_and_load();
 }
 
 static inline void kvm_fpu_put(void)
-- 
2.52.0


