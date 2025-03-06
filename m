Return-Path: <kvm+bounces-40218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05AAFA542EC
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 07:41:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 306D716C4C9
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 06:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB04B1C6FEC;
	Thu,  6 Mar 2025 06:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="h36ZUU3M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868031A83ED
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 06:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741243293; cv=none; b=tqkSoqlE32qmUXpDC3ZaAg9RNOyYjyVPKk4icv+evtMU9ED/ueAeqdmp9KlvjWStiCnU3HEm3JxHG12yWkNezS0x5lt80Ci8El+Ndhytp1cZivUtP2pqwQLHAA7quIdTIOPj/iKFa7iIOVseSYyKR8CluGtBPTdxH1sFVtpdHw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741243293; c=relaxed/simple;
	bh=58sm5J3uOzcH8RfGhj6BSrvBSbydxV0Kxcnmm7MOtBI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CZUCLVmxVSqJK5V26BCuckYl54KZdg5vhrjTAeKQ1OD5z6XiwOz3ghPN1SikNtEXA0o6VsMEEouQ6m4qqcsziYTAfqUbu59j8ITrAkEiYmPEVrZOczKUiKTpzgvcM1MStxvEeQFoqaXOHN93EZPpVeyMWyVzphIEkvUIszEA1hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=h36ZUU3M; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22403cbb47fso4533255ad.0
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 22:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741243291; x=1741848091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GuCnrkSUR2vP9owV0mamaIN+gV2Z3JtFzZ89seSCxZQ=;
        b=h36ZUU3MGer0KoMiCpAicgOg9EAxex1qom4NbDuj4lD0xz/7HXwcaS0MatDJR8Ub6N
         d38tCrohNCjKRg5dUeFKNOWyzhg3F6p24k/tuQxJiVcgX7SUhTa+VYplXQXT1mTALwn6
         MJM6/sFFcxDrlbrLJdFvsN8PKxBtaJsIQu206dfS/la33YFr8/GKS170MmUKKaVT4DXV
         uB5EITO2P8e1rq+BfTPN4olYF5z9InhyhNxdJrpJEz5XGsZ/RiFXnzK901KF9MbYgt6y
         fASo4sHNndDDk/cxUcIDQnSfXV/o5OF9bv9VAfxGW7RnHTywsnDVKcWJZZGHJ4dN2U9x
         odAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741243291; x=1741848091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GuCnrkSUR2vP9owV0mamaIN+gV2Z3JtFzZ89seSCxZQ=;
        b=nv9mqOjHYL0hVx8P736FpT2Eom7xIi/4/bX3RrZL2U5ESgEWyPG+Y88oeag03d0yoT
         r8t39SOqr534Fo4/y6VGtw0hn8bJZaTVjV3e/QSlwoVOq6s3n9ktmuAlArckvgH2SQLK
         RFqwurE0OysroLeqoRoTH5Cs+Buw1ELeRQkxz3615sL2fPHN52mSgYYgZypTh5/J5Vrn
         EFIuCdJpFbirA3FxdHNIr7xLWidIV8rvBZf/BiX126xDDiz1qBOx8Vnk8NwDjyXL6RSg
         cawyLX0adJguXB2ILPmdDm4xXvBFjER7QXtzmbCQg6QSIFBGrir3p+c9S1x2Rsc4ZEfC
         F8og==
X-Gm-Message-State: AOJu0YzGQPSn88XE2oBqkl4rahO2FMha1A2faB01ubH3Ymiie9YWfvUd
	4MGqqWaPKH0ciky0DIFUw1zTQm16fSHtS8StrxQAhD/FlWNuZrsiGuQFdzz9gGA=
X-Gm-Gg: ASbGncsMTcO/kZRUBLimwnh4Mz68lHFFFuvHtFFrKPYNta9qLwPCAvHn7DrUB4toRTc
	Mkei00FjxYjx6WWTlFWoe6mDd0skDJMtmK6CLm9Zqe8wy+GQwL1mJj62BtkdDtc3nhjDRqZ123j
	1rMVlHFz2CAacQuOhaS28dO3Bp6yIHPKgibW3kl7wIGBb3d5Mbo4EAn83asPheWDJtfnQjOp/R2
	tNB7voJ6vnb3d9RXnJuA1xZjiKT8d70ysVwhOmFISmy9pWn9r9HAC8TuzbZ448pm3PDiPqYzswU
	hENHO348JwvzRGl2utHacEwkZZ3yAP4IoHCNCQdSSN89
X-Google-Smtp-Source: AGHT+IHmSsM1kkDcmTxoFOVsBQF1tnSFXKKhw9nMkZpecN08X8sctJUMqzo/rUf0aG8IqTUlNfwwtA==
X-Received: by 2002:a17:902:f606:b0:223:f9a4:3f99 with SMTP id d9443c01a7336-223f9a457a2mr79524075ad.29.1741243290828;
        Wed, 05 Mar 2025 22:41:30 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410a91cffsm4769355ad.174.2025.03.05.22.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 22:41:30 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	philmd@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	pierrick.bouvier@linaro.org,
	manos.pitsidianakis@linaro.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	richard.henderson@linaro.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	alex.bennee@linaro.org
Subject: [PATCH 5/7] hw/hyperv/syndbg: common compilation unit
Date: Wed,  5 Mar 2025 22:41:16 -0800
Message-Id: <20250306064118.3879213-6-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
References: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace TARGET_PAGE.* by runtime calls

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/hyperv/syndbg.c    | 7 ++++---
 hw/hyperv/meson.build | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/hw/hyperv/syndbg.c b/hw/hyperv/syndbg.c
index d3e39170772..f9382202ed3 100644
--- a/hw/hyperv/syndbg.c
+++ b/hw/hyperv/syndbg.c
@@ -14,7 +14,7 @@
 #include "migration/vmstate.h"
 #include "hw/qdev-properties.h"
 #include "hw/loader.h"
-#include "cpu.h"
+#include "exec/target_page.h"
 #include "hw/hyperv/hyperv.h"
 #include "hw/hyperv/vmbus-bridge.h"
 #include "hw/hyperv/hyperv-proto.h"
@@ -188,7 +188,8 @@ static uint16_t handle_recv_msg(HvSynDbg *syndbg, uint64_t outgpa,
                                 uint64_t timeout, uint32_t *retrieved_count)
 {
     uint16_t ret;
-    uint8_t data_buf[TARGET_PAGE_SIZE - UDP_PKT_HEADER_SIZE];
+    const size_t buf_size = qemu_target_page_size() - UDP_PKT_HEADER_SIZE;
+    uint8_t *data_buf = g_alloca(buf_size);
     hwaddr out_len;
     void *out_data;
     ssize_t recv_byte_count;
@@ -201,7 +202,7 @@ static uint16_t handle_recv_msg(HvSynDbg *syndbg, uint64_t outgpa,
         recv_byte_count = 0;
     } else {
         recv_byte_count = recv(syndbg->socket, data_buf,
-                               MIN(sizeof(data_buf), count), MSG_WAITALL);
+                               MIN(buf_size, count), MSG_WAITALL);
         if (recv_byte_count == -1) {
             return HV_STATUS_INVALID_PARAMETER;
         }
diff --git a/hw/hyperv/meson.build b/hw/hyperv/meson.build
index c855fdcf04c..a9f2045a9af 100644
--- a/hw/hyperv/meson.build
+++ b/hw/hyperv/meson.build
@@ -1,6 +1,6 @@
 specific_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'))
 specific_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
 system_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
-specific_ss.add(when: 'CONFIG_SYNDBG', if_true: files('syndbg.c'))
+system_ss.add(when: 'CONFIG_SYNDBG', if_true: files('syndbg.c'))
 specific_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'))
 system_ss.add(when: 'CONFIG_HV_BALLOON', if_false: files('hv-balloon-stub.c'))
-- 
2.39.5


