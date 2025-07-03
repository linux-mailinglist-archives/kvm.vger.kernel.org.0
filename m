Return-Path: <kvm+bounces-51415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E0879AF711E
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:57:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5EA1482C91
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35DD52E3AE0;
	Thu,  3 Jul 2025 10:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xPK3YXgC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24C82E3382
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540209; cv=none; b=IC0uDhIg+85VuASaPZ6TldH/4HchiQJJMt5FKzIiHwtDL3Wv3zByRXKOVGIYT9q+DxO9v0fvo85PrfHWsbHOSgtY1EaZch3HDzabajwkNHcQmP+sUsENjYO0T6TLPUoCiCYBbfYWgWYqfnnK4/efd8khJkZi9LqzR9B1cwu2WhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540209; c=relaxed/simple;
	bh=jf8eyJZNKEZj9B753BtDLKYSltI8xE9n1zH+cGpxiZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BXpcXSO/S4iKojGZ0lbF24XznuITnOveiKvWHso45096EDCNJXQjVUvtvxhUHIOop5k8D8PpEXCVvIsGKFEEWLoegD5OINc6a4o28Y6gS+VR/IpeXDtzF8mfWx+c50cvWNZ4CNxgDs1xgJROKjHQA0iPJfA4MS7I3smHXS3mwKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xPK3YXgC; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-451d41e1ad1so53373845e9.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540206; x=1752145006; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=avPL5wc3uCAbxMdjiOjEAiPWhgKLP3dI+/bwFAvHMvE=;
        b=xPK3YXgClwpTr78amlwP1L4viXBD8dUMFPOiP5p6N9d5Dr7GqPQkt/wR7MGI9d6Sma
         VYimQqSs7roc+KzG9fKCg2fS1de0F+MczLiRw/DLfmoNAi05Zg6O/OJDGaHzp0lHTMKb
         BNLYL9DJ5JpQWyUh0Iy+PhnwdTJLbQcVAIbpmP+tjMI1k1gx4cSPzzvhuE++v71gSsam
         oGw24tREozjkYkQREK3kYo6Xuv+aYf/sqF9NqkYPCqVoREGkWNH7edhXBwKLqBqqbxt2
         JoB56ERx6xkbR+b7FD0EGgCBsO7RXNrRbSzr/C+FL5lEeHJ8zH3EDhPAqM4MttQoT7LY
         jzoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540206; x=1752145006;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=avPL5wc3uCAbxMdjiOjEAiPWhgKLP3dI+/bwFAvHMvE=;
        b=YyIBGlxxBHneDDtZNIi7RKJ1PJ7BxxRPyNcU/ogo1gfhdnnELGemCP3CEEhaASq6BZ
         bgX96DJOuv/fcKWhFm/2GyvCMWmv2CiJM9mT1uH+DqMX9XKvt5F36MmtqZgWliJwpa7q
         h8BrChHt465WXh1LAAHcr3bTaucTAF1BjOOTreIpsOsOY6YlN8Bg/mQpzS5MJx/2TqRJ
         GaLCS9HFFNhH02UN3BPkVrYTe3Tkmf8o2vynsPGQ/ZNboOQEW0uc4oVdFZcwFs/RjC4t
         sdNiJVxpAIwf96BLlWyugJ6hS3a2KBmTRPnmQUpe5Eu5ivhqecX7cILbvQ4cVctEqquz
         atjQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+0NkwUX1UZ4NdCFJTmoPTkDFj06EMMBLaqDDtLHjigo7pP/uy44IYlp1vrFDxl71d+vY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIL59o019qNEyvmqGs1MMh3tq+06UkAc8qR1YLblL2WaheGQYi
	pA71X+a+S3yDr4sRYQnPKCFfF0q8gcgkI7Y2/nPyNai8OwNFQFX/YHSRoEIOkz7MZuI=
X-Gm-Gg: ASbGncshWfKZ8BQIgpVx7WFJhy5Y41XcUpasm697ehZyrOJvcMPE4vQpDVz/LmVF/w4
	3ok84eE95ie4UqO5nKF2Bb2NZQIcDqqyBWCNDJPOMNMZMNnano5NsNAJODMJ3jm3uxdcljB+BEh
	NjRRMniUsXjGJ+x3PdgWoO/wcwQHxIYDVPExMyLnChJKzIM2t7vheCY8SbdTTmIZl0RuSgos8l6
	1jjwXwAOaiUFJTSu2k7mqp7tvr4LmLF3p0fGPZHLgKD+jWp8TMXvDHBQsXYUiKY5dm1kXmCIt52
	XAFltXRJTCK+sHpAaD79yGCBERcMz5/PVRlkrd7Xqb9S0eORrR3fJGIMwNvR3aFgJPsnjnL6i6J
	2WpJ5+XLuuHY=
X-Google-Smtp-Source: AGHT+IGyPvuqIv/SGuixXi+1VvkuwA0WJu7ZVXgAGGMvrrytdxcSAu7kAXv18Jv+0lv4kiMADofGDw==
X-Received: by 2002:a05:600c:19d4:b0:442:d9fc:7de with SMTP id 5b1f17b1804b1-454ab3a90c4mr20498175e9.22.1751540205880;
        Thu, 03 Jul 2025 03:56:45 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9969a20sm23570015e9.1.2025.07.03.03.56.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:56:45 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Mads Ynddal <mads@ynddal.dk>
Subject: [PATCH v5 12/69] accel/hvf: Re-use QOM allocated state
Date: Thu,  3 Jul 2025 12:54:38 +0200
Message-ID: <20250703105540.67664-13-philmd@linaro.org>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/hvf/hvf-accel-ops.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index 6af849450e1..c256cdceffb 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -325,7 +325,7 @@ static int hvf_accel_init(AccelState *as, MachineState *ms)
 {
     int x;
     hv_return_t ret;
-    HVFState *s;
+    HVFState *s = HVF_STATE(as);
     int pa_range = 36;
     MachineClass *mc = MACHINE_GET_CLASS(ms);
 
@@ -339,8 +339,6 @@ static int hvf_accel_init(AccelState *as, MachineState *ms)
     ret = hvf_arch_vm_create(ms, (uint32_t)pa_range);
     assert_hvf_ok(ret);
 
-    s = g_new0(HVFState, 1);
-
     s->num_slots = ARRAY_SIZE(s->slots);
     for (x = 0; x < s->num_slots; ++x) {
         s->slots[x].size = 0;
-- 
2.49.0


