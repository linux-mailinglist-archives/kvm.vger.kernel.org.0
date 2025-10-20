Return-Path: <kvm+bounces-60512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A122CBF0DFB
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 13:36:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D65D83B4958
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 11:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2D982FC00B;
	Mon, 20 Oct 2025 11:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="E4a4b6cs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B3329B233
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 11:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760960141; cv=none; b=Aa4KqOKHMeipQ46ZJhLJFiNlAg5Nx9MVOiiDY+6SRrq3PS7AxBu5OhPmzMOM8VyxJ1Ujs9bArEyGZsVnauzX8L1zq8kr/QVmOqR+tasnBvdMFS73k80rc4wE1+e7Sk+G1tTqhDyWOIHU22QmzgYrVc2okAF0ttRob7akYeCPKpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760960141; c=relaxed/simple;
	bh=W1nvyZPU64yzvPcmezugYIuZjpw7kO0CXCK00I93NDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o9n0l1AknU1SJyzvDmBxnvWHtQyhG/Lehx/4VBaIVvXRN2Sx8PL4bNgn6hTdKT8h3DtYW2sch7m+pcWjkzfS60D9DMyH7Z7jxd2opq8uEG8OPCB6eWJHLHVlmgXd3eTdh1HHriPwOxdTCo+FYeJaPnJ/Lzn08yA/W6sFNLlMYp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=E4a4b6cs; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-471066cfc2aso38599445e9.0
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 04:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760960138; x=1761564938; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dJ9NGAEw6N6YXfZFK516do0M00rTnJSh3CYQjYCLSO0=;
        b=E4a4b6csiZx+5yQwQxVPXNAF2P/4Rim6m98TM6SdwFgQ58e74NezFjxbx+3E8abtiE
         A4fvEDi3bGVeUzMzIVGN98qvNgbdHr1OUnwA2Nm+Yg30mpWmNNuhN8gnfaBDp6PxWrGW
         SoOTvsNUUktex1y76pTNK0m1hp1SoUS19AdAFRURRtg3d6sAFlPSq8smSGNs26zivGnB
         5qt7dk5x8rKR4VC8WRR/RCt2pFfeqs3azbfUP7lE4QjsfR8Qcfsqc44HnO3ouDBDWcT/
         GYp/qwmt5FeK73K4XP3RwClFYLlsmDBlLiWR60XHiHOg0TPOHL2J8ELpW2N5t75Aw2KZ
         8IPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760960138; x=1761564938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dJ9NGAEw6N6YXfZFK516do0M00rTnJSh3CYQjYCLSO0=;
        b=j62YyyW7/st0GXZ+L2xV75UWErdgOjWzmdEr1IG4sqUv0KsXxmTzHo6VXJJew5n7Is
         CJWm/p2IisZRZWAUFkqjre2GfN5CTNJp0kPSz63KRm2Yt4N27pkCXdUU2eLKP+OCKFij
         dyQmC+TRxpKZEGtzOCouMrfA3OImmMhCcvvBXWQHC6ujPq6RWitEYV6xkuapkEogBDOf
         WLHcqxHRcq5lpCbJZIhtjRLUz3+R/S7b+I+5QAMTbFK72T4Z+SpGliXsd0ES3DLe9AB4
         +9jGQZ2FHcuj5k2Z0ZOYzLB2DcQBOC9tfsLTXkTEzSHj0LudcBaowYgwsa5Lw5vksR/i
         I3og==
X-Forwarded-Encrypted: i=1; AJvYcCU1b4XyOZUqASDm/pJ3JjQWMjVqBsHaXQbIpM5+WXF0KPSDD9zSTMqOPrkA98hgM4yTAb8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yztpl2hDECF149nQpcNI49R+2CkWqorpW7jxxnhvKvJ720tLM0x
	fdUuqsz6JicV7Kl4+pJC7nYNsLjCQu1m3LqTjS7mMEYWtmAMEWnWyXUZRu5WWCIPYc8=
X-Gm-Gg: ASbGncu9aKCteEWWD2vcXLj4WRi2vLrmZVkyBDK8GQNz81/uSe63ktapmlYyh2CUOPM
	489v/ZKrYYrjIQxnmQzJSXvzTtfcvfMgljyJyv1mj5c/xxIWrvkCSTJU/xGJeiH7BU16/Le1acd
	rgR/kcsVMQjf5YOinwuSx20puNkzj1c1vsT2SOkOBQieECgv0W7lQfQp4llpoP1haPhYCSMPXBb
	HZCPaewyvWLqkAMDnyOieKjyfuBmbqIHM0rx9CzgLp39GZZxsOK327S0yYZkR6QbgiD9KLkFUY+
	9vOJWlCHZVq1i5IjMNFhI677uHmKoeqAMtBsBSTAzCIHjNS/vEbnTuWq6iuwLnxmHT4YVnqKHbv
	VMSK9C9ZZdNz7h36lUYh+2TGZJ/c1O/fU3VxnUK87hZQz+HIp+4ZxmcALAQWTRAfMtjtbu7ru6c
	eczu9smb4UlMRdF18UKruOepENFUYX0KkHPDin4+jmu9FfE9KemeQPzO+Z1ViD
X-Google-Smtp-Source: AGHT+IH9aVP2HDqi6fupN4F23f6aoUioti0VFzylksj46aoAXat7G3nwhgRBvFJu1VfuUwA74SWURg==
X-Received: by 2002:a05:600c:528e:b0:471:7a:7905 with SMTP id 5b1f17b1804b1-4711791cba1mr121926425e9.34.1760960137640;
        Mon, 20 Oct 2025 04:35:37 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144b5c91sm225443755e9.11.2025.10.20.04.35.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Oct 2025 04:35:37 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Chinmay Rath <rathc@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 17/18] hw/ppc/spapr: Remove deprecated pseries-4.2 machine
Date: Mon, 20 Oct 2025 13:35:20 +0200
Message-ID: <20251020113521.81495-4-philmd@linaro.org>
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

This machine has been supported for a period of more than 6 years.
According to our versioned machine support policy (see commit
ce80c4fa6ff "docs: document special exception for machine type
deprecation & removal") it can now be removed.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/ppc/spapr.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index 30ffcbf3d2b..97211bc2ddc 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -4912,23 +4912,6 @@ static void spapr_machine_5_0_class_options(MachineClass *mc)
 
 DEFINE_SPAPR_MACHINE(5, 0);
 
-/*
- * pseries-4.2
- */
-static void spapr_machine_4_2_class_options(MachineClass *mc)
-{
-    SpaprMachineClass *smc = SPAPR_MACHINE_CLASS(mc);
-
-    spapr_machine_5_0_class_options(mc);
-    compat_props_add(mc->compat_props, hw_compat_4_2, hw_compat_4_2_len);
-    smc->default_caps.caps[SPAPR_CAP_CCF_ASSIST] = SPAPR_CAP_OFF;
-    smc->default_caps.caps[SPAPR_CAP_FWNMI] = SPAPR_CAP_OFF;
-    smc->rma_limit = 16 * GiB;
-    mc->nvdimm_supported = false;
-}
-
-DEFINE_SPAPR_MACHINE(4, 2);
-
 static void spapr_machine_register_types(void)
 {
     type_register_static(&spapr_machine_info);
-- 
2.51.0


