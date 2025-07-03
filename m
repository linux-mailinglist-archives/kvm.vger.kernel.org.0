Return-Path: <kvm+bounces-51518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A4A99AF7F01
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 19:36:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A35A3ADB8C
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 17:35:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFFCD2BEC5C;
	Thu,  3 Jul 2025 17:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JdJHoQoJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334CA22CBD8
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 17:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751564156; cv=none; b=sLBspMOgj8xDE/VSC4P8WCj92Nb8DhpmP3Vv4HUHsxr2xn0nYwVdgaz88SqqUkJjGogN1oviNvXQZr1mYpVHzUFNAbK9mqsaiurJZpU/TnO+gC56M0mjt8/HtgU6N1NfiRseSk53AfoLQ0OTqIkwfceMJm15aEulIyNppzTK8wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751564156; c=relaxed/simple;
	bh=zXt8Hc01PSRDVti+ullf0XP411CdENvQr5WIExYVA/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EUMEDbDRIrACtnxo6ouLJXuLDd5B17F0CNt6iM6uRUu9hqI9xj331ORJFrTBtQt6URpy0FsAg9Xv/Tzqk4ZHCQd9W49A0CTCJA0KtoWN3HJl6hkIXqbUDLxtHjNw5Pm99xqT9od2kdQFqjuLRWx7RKqGaYUzLWdBhVSmPQh9gGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JdJHoQoJ; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-450cb2ddd46so440145e9.2
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 10:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751564152; x=1752168952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WNEz7S5Pg2QTsssvmOiqXSpVHK7X0tn5k6hlRokSPQI=;
        b=JdJHoQoJNV2Yx40zzTvwTDXSd/2ivD5vwZ1WuEgEcKXIhq0DnwS1N+6w0SlqB4RpKi
         TIIRFTPxtUP/5rrI4Rywv0Zq5zwVAfLg2JrS2fuEeNapoV66kT2D9G0vTp3kiAq4dKm1
         GdL18Q35UdWyDx9Q+SGY/go4oW2diJnbBch1EZRJ6FC/cyeJI8hruqEbWY8SNu+LrDJS
         PenWA3qeaRIAvLvbFpE3AeA/LK5GjuZbvUf2kGGoEoqredKi/JBYJ4QcUxE+Uq7At7gT
         cNcjnGP+656XV2OeS+IOjoqR92JHN2TSVfDZCIGRpYNYJT9VnbYJj1LLevd0mAXUwGZT
         JVyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751564152; x=1752168952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WNEz7S5Pg2QTsssvmOiqXSpVHK7X0tn5k6hlRokSPQI=;
        b=vKULhcDKheVzOVRQUKyCKmXDJG6YvRnQ7907oypm3oJ+5E0IKPf0bc2IXPSEuJj2C2
         bQmNyTGpAb7YhQbWkWH92bH7R5KzqltkAiwHN7m3aFD/ZE58SLmMF7VDUDAPWkkLDkhg
         QQ57BdZeVhscHK+YvDH7Pk1OAT31E4K744Dsm+7/6jfjDLuSXSRKJrzbKk28Soegfwbp
         mw8N8EejGgdt1sj6DoOSR2K3sVmneLNVS5LzdveUBnpagIPKyiclLVcK0JUbZqMjV01L
         Q3e/7MgO4vd7G4PipXlfxlRLox73TNCnbK98EFlGhNqNOhKNihoLk+FGX878KFwN1y55
         gN7w==
X-Forwarded-Encrypted: i=1; AJvYcCVWEvDG24HrC11IR4yeK8pt3ednGBRLZWQDxD+irKvNT92IuV/AQOfhctPD5ACZUFGY0Dg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0Tmbfc5z/YuoKN4ai27yI1ibc1G5h79he8ly2aWOqKuGbWBwI
	iWa5nsxm4Go/bH3GwXDvPkZbhoXwLYBH3rk2sNQhW+w91/drqKxQNlVjWdOThC0mx50=
X-Gm-Gg: ASbGnctRpYtEmAu7tX3NHjMBhRPlRvjMmi7zn+7wYgIBwJqPe/ySdtdGIz2wAisUV2v
	9LQsSe2DeDHVGQGQxDOvQtzWwL0nLOjYTD110qFCn3HBJgayrChqpG0u1ckJqlA+zXmITGKQ4Va
	Ems3i72DBZaqEexPuz1altSWsubDSkLxT5peHV8GAfBuqA1LcTCyl8lLL587BwOIC2uBUmT+CyU
	DJ/dONe3z84qd3+8anpngx3o0f1/nKpVXhM8XqOrk3CJrNpN0EBPxflar+LTMh+oR6gFgY4lPEJ
	1rlFrZpSFuST0TKiWl/g8UhcIpLqXG4qWOdyrUSWJjn3VzVgMBauJVIMKKUCh1jCSZe3KhJYMxC
	p7TzHLtKr2V/nW4cHzRP04sK7tZ+/aAuI4Rgr
X-Google-Smtp-Source: AGHT+IGG9cwkbptc5qjJh/iBIUTkTEqak4gJcRB89ikAjNxYhsBkJvLXzAiMyUL0ZnaTv+toNbITUA==
X-Received: by 2002:a05:600c:1c0d:b0:454:ac5d:3919 with SMTP id 5b1f17b1804b1-454ac5d3bbbmr36513685e9.2.1751564152351;
        Thu, 03 Jul 2025 10:35:52 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a997e367sm32048195e9.15.2025.07.03.10.35.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 10:35:51 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH v6 33/39] accel: Directly pass AccelState argument to AccelClass::has_memory()
Date: Thu,  3 Jul 2025 19:32:39 +0200
Message-ID: <20250703173248.44995-34-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703173248.44995-1-philmd@linaro.org>
References: <20250703173248.44995-1-philmd@linaro.org>
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
index b040fa104b6..44189b77daa 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -46,7 +46,7 @@ typedef struct AccelClass {
 
     /* system related hooks */
     void (*setup_post)(MachineState *ms, AccelState *accel);
-    bool (*has_memory)(MachineState *ms, AddressSpace *as,
+    bool (*has_memory)(AccelState *accel, AddressSpace *as,
                        hwaddr start_addr, hwaddr size);
     bool (*cpus_are_resettable)(AccelState *as);
 
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index a6ea2c7f614..0cd9b2f29ab 100644
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


