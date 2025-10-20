Return-Path: <kvm+bounces-60507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 494F6BF0A35
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 12:44:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64A193E787F
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 10:41:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8E2C2FBDEC;
	Mon, 20 Oct 2025 10:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OCGPJNUy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D62B2F83A5
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 10:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956761; cv=none; b=I+weBcRMIFk224+3qR95ySqJgUFAq6kNqGC6uhh+tL6EuO1b63L/EB3DEwjDMRpqu5LT1p94EjFbBc7rARfxHgYJm1oz4pM7sDTU/p1N75EBQSQmJdW2SfVcjS3sz2QYT/XMt/mLTgOJEKuHhm9whMyBqFepPPkqCfmMNU/jJRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956761; c=relaxed/simple;
	bh=MGE98yBOtzgaOz9N8YVi91vOxiDCppPSt4n9YeXoL+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iC8sIRjUQJtwpv7qOYijOo4+a/ICF3QWYIAdK/9H4PJa0B/+Pb0sOCMzYvwShqW9tAXEv6LM1ldFinXyjb6+CDTmYK43ywVkcQb5n7YPgjPEbum85OLph8xNkF8GPVnSKtu/lVwcbtvulqIJIBrrIrfK164EvELq1gWYo7TcSd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OCGPJNUy; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47114a40161so46075535e9.3
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 03:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760956758; x=1761561558; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xlOXqxMFTMw8d9zFUYVs1rlWsmgPvU0WJ3K5FcKTprA=;
        b=OCGPJNUym35QxTES1avmY/PNch30VmetayWDt5urZWlvE1jKzX2OroB5Ck9yyWDB3v
         wjgVvHbOHXX6I5bPJ2bRysV87vR52Vx0dxY/s6rdIpt7MBN6p4tyoYGNN3g37G43Coa4
         uUv2eR0sJDsVZcJVkwCDwhuBTK622Rxvr37nBgfnhkDQ7+AFxb8GddmBAnj267XswwQT
         8+IJTQszUwJMzj6TfyImtg1egaN/XmXh37veYKTWKzVTc24EmNAM14XXtkRXgBydrVaS
         pTyOeTIs2z2IFcwlbepgF4fyXJGmi2ELYRuyGf3r2ON4cFkQSN9uizoQT/OUaNY0wy5S
         7ZMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760956758; x=1761561558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xlOXqxMFTMw8d9zFUYVs1rlWsmgPvU0WJ3K5FcKTprA=;
        b=wTOedmz59EoixdSF2SMxqN/fVaxvCN/wvfTEUeLf/DKexIs2/yBRycJgWsdkEbdzKv
         qf7ZIuA14JuoOcuYTFyynLYNFPx6ODKajI4YzSMisX4xc1/O5xoxinEv+jCJELUj8V9X
         eVu9vy8TMTvvGOYNPReLoTj9902HhDJJ8Auq1DBwhAMe5Z86FddnOECk6OqThoH5lS7V
         E5AEptKTES+GvycyxA99pGtigjGzUTbZOL9rPZGEpYvyL1oxwymQc4juUn0HgnIT6qVC
         TDGu/WonYEELIcMpjJYigyZul4zBMOFeGmR6BjtF8RVUtVFAHPFITqJEggaSoI8u5Uaq
         +a/g==
X-Forwarded-Encrypted: i=1; AJvYcCVTJroBAkrgK1eZdOWJwu1Ud6mkOCd0PriiPehGB0fXdG6eHA5BGFGW3HQWMEs2yL6gLHA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJgY3llEPwzBo+AELJpWkOeS6twfQy1RXOciYVkDJY8sih92nX
	sRe8Y1A9oAPZjYLTabmSYr1at0c33yi7nN3nxzn31yubh7UjMdt1ua92Bo+NWT3cCho=
X-Gm-Gg: ASbGnctnF3YFJoo6fVhEIEzIdBrLnlW4CbRUXY/LCRwz5prneLuRAOny0s/3jFhgQn3
	UF2Bk/AXiRLXPp+ay6Hq+vpyMABqMeuxSkeqnv+0hUZFAicge3vdjyYlXePHVXOiqE7c+SEE+hF
	wDfihVKrjkw3PECkxPtzIkMC+QDofXB6wzjquutqhj3wOP4UEyZn1xXmLsbey99YDfBzwi3v11e
	dIR1bgyqlAvTa7kzTt1fRWlnLYObnlh4kL9CAsA0gu6Q7ViCFCXPa0d/JXxNLAhgD29Qfhn/sWI
	zKDspLcm8D0aCHn0Rfyak91Gdx8LWEp1/D87uqLeU5/RhFopRlYkkE7QQuCoejLXY4nYdnBqAap
	pLMXPac2ycOQ5J5TAh2nIBY6Ho96+qVkd41nMj5eS8sLneusgWiAPR+s5TvVWARAxmElxtRG/YR
	kjNl5mOlr5zXhi6aPwiUL3IF0yuOWdJcXuSNo1rtfxA1w6EYaqAg==
X-Google-Smtp-Source: AGHT+IF7+wUXYpVOjbp8GEPbCSzKhAI9puJAqL3LxJxPnhBl2+aekWdgyEWYzqWjmfgaFsRcy3QGxQ==
X-Received: by 2002:a05:600c:4ec9:b0:471:15c1:45b9 with SMTP id 5b1f17b1804b1-471179133b2mr99816415e9.29.1760956758432;
        Mon, 20 Oct 2025 03:39:18 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5a1056sm14700438f8f.2.2025.10.20.03.39.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Oct 2025 03:39:17 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	qemu-ppc@nongnu.org,
	kvm@vger.kernel.org,
	Chinmay Rath <rathc@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 12/18] hw/ppc/spapr: Remove SpaprMachineClass::pre_4_1_migration field
Date: Mon, 20 Oct 2025 12:38:08 +0200
Message-ID: <20251020103815.78415-13-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251020103815.78415-1-philmd@linaro.org>
References: <20251020103815.78415-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The SpaprMachineClass::pre_4_1_migration field was only used by the
pseries-4.0 machine, which got removed. Remove it as now unused.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/ppc/spapr.h | 1 -
 hw/ppc/spapr_caps.c    | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index 1db67784de8..4c1acd7af5e 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -143,7 +143,6 @@ struct SpaprMachineClass {
     MachineClass parent_class;
 
     /*< public >*/
-    bool pre_4_1_migration; /* don't migrate hpt-max-page-size */
     bool linux_pci_probe;
     bool smp_threads_vsmt; /* set VSMT to smp_threads by default */
     hwaddr rma_limit;          /* clamp the RMA to this size */
diff --git a/hw/ppc/spapr_caps.c b/hw/ppc/spapr_caps.c
index 0f94c192fd4..f3620b1d9bd 100644
--- a/hw/ppc/spapr_caps.c
+++ b/hw/ppc/spapr_caps.c
@@ -336,11 +336,6 @@ static void cap_hpt_maxpagesize_apply(SpaprMachineState *spapr,
     spapr_check_pagesize(spapr, qemu_minrampagesize(), errp);
 }
 
-static bool cap_hpt_maxpagesize_migrate_needed(void *opaque)
-{
-    return !SPAPR_MACHINE_GET_CLASS(opaque)->pre_4_1_migration;
-}
-
 static bool spapr_pagesize_cb(void *opaque, uint32_t seg_pshift,
                               uint32_t pshift)
 {
@@ -793,7 +788,6 @@ SpaprCapabilityInfo capability_table[SPAPR_CAP_NUM] = {
         .type = "int",
         .apply = cap_hpt_maxpagesize_apply,
         .cpu_apply = cap_hpt_maxpagesize_cpu_apply,
-        .migrate_needed = cap_hpt_maxpagesize_migrate_needed,
     },
     [SPAPR_CAP_NESTED_KVM_HV] = {
         .name = "nested-hv",
-- 
2.51.0


