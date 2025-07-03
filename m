Return-Path: <kvm+bounces-51417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B2B6AF7121
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:58:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BCC407B1166
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:56:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 600A62E3AF0;
	Thu,  3 Jul 2025 10:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TdtjTjMp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7E32E2F1F
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540219; cv=none; b=VEZEpu4pdd43rygQZ0YAj8IGYCR1ABx8DloYoUAWhVGmno6sTKNFSIw23WOP2Fk4EZBQfZa7dn395pvC8lGo/22MiihKKDXT8PGFZIRVrFDy+NA7LM62/kKK/kjcXG9qcp1p9JL/q2hM73TO0nhKfjrJ6nN8xVQxTDJt1J8hEMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540219; c=relaxed/simple;
	bh=CLfQzB9bAcsiDVcbwQqJFv/GvNOSOSEM7YEhkgGL52w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=imGgx4xMSP/d4yZTYLTnSj97927SbU7LUQLW1cvMitkWCxDajsJwduzM56V5iN1Cc5vcG4GLYUutguLk/+aZNMUWAYczagBVwn0TW0Hk4wS403RPwK1w+J6GQNtNd18DNC7KXxZCSgK24xt0RF9XsL5eP3KwKlEegfKcEMJeBmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TdtjTjMp; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-451d41e1ad1so53375105e9.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540216; x=1752145016; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ig7RKTLH9UJlDQU329juJSY2hDH3DZ7PgtnDQ6yaDA4=;
        b=TdtjTjMpD/O2vNhDQkmwlXBtd/u4c1wmqoV+MwWH4niS4YrUv0gvXhDY7k8Ed9c9K2
         Qbnt/pw2dHoqfZ1vdULFfXUQap02s2xirLPdFZ+pITLNPM1ya4UR0Hrhq6TfLGaBTFfV
         GaTefAEekaTUkO+fk+QmFlM87hnIM2g/3Qxt4kg716rd4Qt3E1qy/Lt0tGwlterdFlKu
         pi1mHUinou6MFzkdVP1RtSqi3WU0QoBYa2yoM31gV+imJ6JgpVJb/v8JpL6oI0Qdpwic
         mwk+r4J4m6VCJG+/cPsy5qbRfXH59tYyDM0JAAEUDlMp1Ntc1Jis2WLA2rwDMfF6aDXh
         mnFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540216; x=1752145016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ig7RKTLH9UJlDQU329juJSY2hDH3DZ7PgtnDQ6yaDA4=;
        b=EzwpaWeqmRm9RbS42QZkpau2O95R7bAEP4UwRZAaFIQc6koTAIhoRswwbJAikeTAZZ
         y/LTS70PoIaqV96GW7pN2RRpSUEAJ9k+EFXrkmzkeGLyDwAXZp3/qoQ4mX/k+XDLcdZL
         BScAiYzw2KRCWEkZ/BoHNidlI1+D0qNH4IwioMSclLNQtNxaXSqFqulEppn228uqIEzH
         PAypR+ww96vtffe6W0uilz7/siTqIWsGXYw4RWdSZ4RDjZ3lQFeIc4zIILFlSwbwKnsg
         NxqnAgZDIBdXOci0BCohUjeE7zjIbNcHcf9426iZcdPodlLe8LJgpMXb7q6yer2dEpMH
         jRUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsJJC8beQVWsDCL2dXnuD/6DXU/M1RgEH4JjP8u+cGgqewrpUzNj+FsIVxhlzyAMe2Muc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0jqRCPP6a0aErnu3U6op6mPPehhY3qjByXZgjqacYZHSkhH2N
	jlugfx9i97l5CmsUjMP4jQ5F+wBSyIOucgTfh3ttpliF5//6lmdLnfBAA4oimBxMWA0=
X-Gm-Gg: ASbGncvQ7Ebvkd3qZMB1ml2AyzNYrxX4cJ4eSCPegJPvX12S38ovZ8V2BR/dmbGtk+z
	5fgRA12BHr676YckR6gUOtpidFIzFKEgjKLzd5je5zfZUf1fbLf/263pfZJv2Q2rpkOPF4gJDvU
	bLaiWXN9xGkJQGgErHZ603flXR2cHVDAgNIyk6p05C1CFXaY6QUQto3EzrUNtYH5IffaLFbWIG8
	NAuLePaS7axq0nLpNaGpQULsaNuwDcybYy6b6RyZpEW07knLiRVsMm5y9ouVtmldXEgBSDgS0uC
	oDsnlMEbijziIDrY68Xcl3bUm/P3GWi19PpjRYjP77siuqTS/ThvYHFQ3IT868BuPwnbvLTh+Ci
	WwqoUvidKHbs=
X-Google-Smtp-Source: AGHT+IHaj9RtQDiEeVRArxp+XRt5ldxps30/rxJJslo7khH4Q15jtcYUkXC+vICQ0L7oQrotPITPPA==
X-Received: by 2002:a05:6000:4105:b0:3a8:30b8:cb93 with SMTP id ffacd0b85a97d-3b32e8f61dcmr1884068f8f.32.1751540216212;
        Thu, 03 Jul 2025 03:56:56 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e59aaasm17990675f8f.83.2025.07.03.03.56.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:56:55 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v5 14/69] accel: Directly pass AccelState argument to AccelClass::has_memory()
Date: Thu,  3 Jul 2025 12:54:40 +0200
Message-ID: <20250703105540.67664-15-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/qemu/accel.h | 2 +-
 accel/kvm/kvm-all.c  | 4 ++--
 system/memory.c      | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index b9a9b3593d8..f327a71282c 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -46,7 +46,7 @@ typedef struct AccelClass {
 
     /* system related hooks */
     void (*setup_post)(MachineState *ms, AccelState *accel);
-    bool (*has_memory)(MachineState *ms, AddressSpace *as,
+    bool (*has_memory)(AccelState *accel, AddressSpace *as,
                        hwaddr start_addr, hwaddr size);
 
     /* gdbstub related hooks */
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 72fba12d9fa..f641de34646 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3789,10 +3789,10 @@ int kvm_get_one_reg(CPUState *cs, uint64_t id, void *target)
     return r;
 }
 
-static bool kvm_accel_has_memory(MachineState *ms, AddressSpace *as,
+static bool kvm_accel_has_memory(AccelState *accel, AddressSpace *as,
                                  hwaddr start_addr, hwaddr size)
 {
-    KVMState *kvm = KVM_STATE(ms->accelerator);
+    KVMState *kvm = KVM_STATE(accel);
     int i;
 
     for (i = 0; i < kvm->nr_as; ++i) {
diff --git a/system/memory.c b/system/memory.c
index 4f713889a8e..b072a6bef83 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -3496,7 +3496,7 @@ static void mtree_print_flatview(gpointer key, gpointer value,
         if (fvi->ac) {
             for (i = 0; i < fv_address_spaces->len; ++i) {
                 as = g_array_index(fv_address_spaces, AddressSpace*, i);
-                if (fvi->ac->has_memory(current_machine, as,
+                if (fvi->ac->has_memory(current_machine->accelerator, as,
                                         int128_get64(range->addr.start),
                                         MR_SIZE(range->addr.size) + 1)) {
                     qemu_printf(" %s", fvi->ac->name);
-- 
2.49.0


