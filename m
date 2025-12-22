Return-Path: <kvm+bounces-66523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 54BDCCD7348
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 22:33:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A73F130141D6
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 21:33:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6237E305E10;
	Mon, 22 Dec 2025 21:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BP6BVlYj";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="TLDDt5Vj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A5B26E706
	for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 21:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766439191; cv=none; b=nDXT7KD6zxQMrOUh6vDeHft7sJm1OvH4cLzQw4IW9Gocth30e5aywujqfAkFur6o+OvZKqNhTS3dk/DPdDY5B2IAD1Te4kJN2iHZ+krJT0fFPNwBbMj5bCy4FV0d3jKeNkoFAxlqgMUSc5j0TFz/Jww2jgDkfODblvRnWoLrTxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766439191; c=relaxed/simple;
	bh=uBKzy4vsA9U0uaBjrGei/fIbtOEZ7zDf8k+Qt7SkY54=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=GQra2JcgrJKbWZTT0O8EbpzDkirQgygxNhdaDUTvgcW7P7vkFrEMORHW3ZLjBiSx8C2aIwHTl4ULiLZIBCNJCzyr85gKWr8lDi0CesqgPYIrroARX5NdLaL8DwF+Mg93CkHPCT3WCikmiwqu6UlA2IZ8ZWqZnF32MD+SxmL37Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BP6BVlYj; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=TLDDt5Vj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766439188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9L0LBm88/XUniKAvABHBDueOTVArMkx1e9V9lkXx0W0=;
	b=BP6BVlYjDviI27m7sCTgr2T/qHPdEk1K4sEnSGjthTrv9osDQz53gUjm8KmNbMR66wUqHd
	rcEZacNvsxUpolPWZ5QycxDo0Air8JX2s3R5ghN45BQNHul6u1jSDOIcKURGsjAMwMKVwv
	rUs3t06MrRHIy/OAn29FkosTJ1ZOMmA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-kxtf_IokPU-LATNzbVuGsg-1; Mon, 22 Dec 2025 16:33:07 -0500
X-MC-Unique: kxtf_IokPU-LATNzbVuGsg-1
X-Mimecast-MFC-AGG-ID: kxtf_IokPU-LATNzbVuGsg_1766439186
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43009df5ab3so2468218f8f.1
        for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 13:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766439185; x=1767043985; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=9L0LBm88/XUniKAvABHBDueOTVArMkx1e9V9lkXx0W0=;
        b=TLDDt5Vj8+Xtw1N/L+D8dHFPmrERlNIXc/eIbEYWzqRHY5kmRhGBSO4hqNuzdYnpX/
         X98p52H6+K2lATXn8XrdjKDItGnBn8sNjM9Gvl9dHUftU7hIg5vQi16xJiYXuvJ7kBQJ
         Gld+oRLaOXWGJwXprTJrURHZgCV8DvptJpKNoaBQyKq/OdnKZng1TdGPNEu6+i+r4/0+
         skth8rdTDYc3DkBLyqtXehei//eCUk5yDzGacTAKsP3xFC6b4gdQijHvGbhhAz6WWFDF
         cFtaVDuhcKp/vKPazmmkdqF1A8UKiYSnWw3cadsTFWF+FUi9KOKNooldWo8e9Kp0hpls
         0kcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766439185; x=1767043985;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9L0LBm88/XUniKAvABHBDueOTVArMkx1e9V9lkXx0W0=;
        b=W3dbvRpyE96XIMrMAPb1g9LgIHq1Q3taNlo53Fgu+aOy21sonzSfWRCJDDTrtE9kkR
         5M5widmG9tfGFyrFksSUj5aYOGNfWktEC0ug+VvkQda37xVFh/32WBoZJ4J7+2Db7ooa
         norWcUDjRw4dunipfPj29lhGRradlh/iXk4A8Ks2RNjsMROfr/m6gjCRDADK4tzGtQvN
         KrprBVSX7TjUZBFx1gfWiwHGBy3q7WSRn4Zyk0okQcNv+P/VF5tpbOVLBlDVNKaC9bhO
         4BHx4H5Hx6u7YBP6va7zx1drQKV38oDbKJzdabu0jmDO/Qe9B24wZdO4Cp4Yj8MBkEIP
         ELIw==
X-Forwarded-Encrypted: i=1; AJvYcCWSpMlbdkkDPzrIE1M4TPgwF9E+vgBz2nkr4phzC90g9TuU9PqLUW99wUrlLOeHa1mBmQQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxoOIXGNpeE1yeVYTX3npMUXdIPUNez8d1Id2tH9sWyUj2s8lM
	T6kJn7ee6Z4FENe1tt8hv6RsWMfwqtkjWtlVgTVa0kvE1t6Pce0KgI6wU8L0jdrEc2CbZYDySB2
	OAfY1tjEuW6muPu/uYMaWeoqF4/sN/2nf27tsS0xv/9UFi5Aj2+nMUSQq3L5HMA==
X-Gm-Gg: AY/fxX7CusCMbdJ7Ip5F3hnUZwYgd9IHWTdnIjTf6Xt0vftnWVtw4nqGU8TVdE1HC9r
	PkQbnbc4QDO59QgSjYp39wFF1Oi7MKOE7Mv5aYymvA5HkG7gkuky5qr1xeMf9YmjkyYaQvhBVEj
	4EdJ2B4MIDMgLxBy3+Y1L1BNXOZmDaQmhEY4+pw+egOzfQl7df5sIgjhhnbEi+zYU6Pw3NVRBV9
	bb5/DynTS0zIxZoh3sQAZP+/I8Hfxt6JUEVWfLjk/ywxDeX3UOGAUAK9w4wD6E1OPnxXWXTz4Hz
	qmqynD5YJlre7NNenT/UO1aVRtKqR+AeWfiGHb4yBsHu499H4dS4uEgnrf/qmCfYRuYJlBqc8W0
	G2cFj5i6N+HUJEZ4dbfC1EqNZc5ELOHjdFxNDh2ADvwHQ9aG7ysxlizndiVt/DCh3NyZHBD0ozJ
	D/5oj3qwcxrnCUfHM=
X-Received: by 2002:a05:600c:8b70:b0:477:a02d:397a with SMTP id 5b1f17b1804b1-47d1953b94cmr101835205e9.2.1766439185594;
        Mon, 22 Dec 2025 13:33:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHfT5nY9wBu0XYtQZ1gIvPIYMH0nkSaLQbaZKrB2tQMIc3Kq3TQPkVEof6ionxFVhwY1rKEFg==
X-Received: by 2002:a05:600c:8b70:b0:477:a02d:397a with SMTP id 5b1f17b1804b1-47d1953b94cmr101835175e9.2.1766439185218;
        Mon, 22 Dec 2025 13:33:05 -0800 (PST)
Received: from [192.168.10.48] ([151.95.145.106])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be272eaf8sm260129355e9.5.2025.12.22.13.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 13:33:04 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH] KVM: x86: kvm_fpu_get() is fpregs_lock_and_load()
Date: Mon, 22 Dec 2025 22:33:03 +0100
Message-ID: <20251222213303.842810-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The only difference is usage of switch_fpu_return() vs.
fpregs_restore_userregs().  In turn, these are only different
if there is no FPU at all, but KVM requires one.  Therefore use the
pre-made export---the code is simpler and there is no functional change.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kernel/fpu/core.c | 2 +-
 arch/x86/kvm/fpu.h         | 6 +-----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 3ab27fb86618..8ded41b023a2 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -858,7 +858,6 @@ void switch_fpu_return(void)
 
 	fpregs_restore_userregs();
 }
-EXPORT_SYMBOL_FOR_KVM(switch_fpu_return);
 
 void fpregs_lock_and_load(void)
 {
@@ -877,6 +876,7 @@ void fpregs_lock_and_load(void)
 
 	fpregs_assert_state_consistent();
 }
+EXPORT_SYMBOL_FOR_KVM(fpregs_lock_and_load);
 
 #ifdef CONFIG_X86_DEBUG_FPU
 /*
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


