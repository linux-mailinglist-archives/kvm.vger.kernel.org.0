Return-Path: <kvm+bounces-36773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B6416A20BED
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 15:22:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B81A3A4430
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 14:22:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EDB81A4F1B;
	Tue, 28 Jan 2025 14:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bFQPFoJu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE429BE40
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 14:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738074128; cv=none; b=apgt7CodI4b2flEjWcYx3+QzEcibtHdTVuEVzbeGRRPWFDkpuXd2NnE4GCz0ZcriDMegS2H+VRNV1wL24Cu0iyU+LYa+gqejXD9hMtgucdzpsNII5lJ65VE1leUhueFPlY6IMVOeNuG7XA97LRmydYVQ0y4vJ02AgqVzgwnsWQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738074128; c=relaxed/simple;
	bh=38cU2OHlhFZBCnfDkum4Mf8z9x9rVetsPagi6nQhdMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bhmC+INVD/hx3GKkgwLxKWTIH/rgF2AGRksc5d6bTyezy+a31sdSCvmKvorSN1KCMVfI1Mu+3w8IlapzsqGTLMRiHsT8gzZ0djzn/VcIpk4zY4tvcOJnd6982yDqB/wMdyCIntqJCnhsF95bo0W6V4hHZlrryySILXej9zJlJek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bFQPFoJu; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-38637614567so2782487f8f.3
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 06:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738074125; x=1738678925; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=seznNsDAaQBVSpbp55D/hE//Nvg+4oVvDGjyXY54BGQ=;
        b=bFQPFoJuCB9v70JQ+N8iPZ/6Mtr2eYMEm3f7l136cJOeaMiAS4wP+2ReZKG7IGilCP
         ZiNWjwsW+NBAmtMTRzviUu0yQYP0x4HYUQgyifHDBMEA1Q2L+saw2hTAV8Ncvhbc6fK0
         2L4f+5mAvP09TBKSkhmadG8V0OPgVj+Rx0+0YIHYNqsuVRnwnhM8niioXZk5qG94Pnkw
         5yKTzZrNCdhLmG6n4OVMoHATtDb2B8gjDFqNZh19TEl/ilbu6QijCKJWhyNLVAD31o8M
         uDP7a/T+UenSNJixjtVLHEn36x2XZi+TzHKJJNHtGF3D9Vsgu8iewRoveuNGDxoA1D7z
         hYVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738074125; x=1738678925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=seznNsDAaQBVSpbp55D/hE//Nvg+4oVvDGjyXY54BGQ=;
        b=OJGb+alt2kOM8HfzWRMF65MtQ3Tekpg+A62vM4nxgY+O5p7pMCzvnBgKpWcwdzOEY2
         03tbVRfnqOlrBN528x/mPAdcWgnYgrcp6q8tHkvBcAphADFwskJUrDHNBed8Vnx9vd7v
         OCVeHX2mS7rehv3vtFICa34REGw63MUBEXaaQp1HNJLhuT5PJOZFD8VDDn8ZDChk4/Vd
         xCZ/FGbYn614q6SrrGjnk8RUuBzZj1y125DuIv96Tn+X120MPqTAhlkCapvmrCqTgtct
         V1kzjwd8sE6+uGo//gTlBzrC9tlpadIotbmoaPC3oxj07/yAgZukrEEB0BPfiGHZJvgM
         0/Bg==
X-Forwarded-Encrypted: i=1; AJvYcCWb/NTyiHp9vXYXUXf0frSt/863Yu0E/H+LlIxRMpBYZkB/gnatjAAIGaK6kVe1QO8T5sQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8niXXY5cn3+/rqZI97ULqm8p9Qew2ZFsGgytItVv87rKytnuD
	2PnQ8bj1WsWHm0fsPXSGft4HBAkXwFn5vTH9jpZdXU0XxyMhNsPvzkrJNRcyIJI=
X-Gm-Gg: ASbGncvc0WcI8sOKcv6S2my9mVjsqGfLtF3j7VYRObrE6PvsLPkacrsTGw47ZrJLWHG
	ESiKNVLnMYtJAqib+D3QPZ8c1pT1gITgmi4oK3UvPMBfvw99QH9rVfT1AkvtpbMPc6hpQJQl8G4
	OB1pqayke7yUYwxtoZLGiEjr0aG/nOB/6ptyEBhrTx9I7pwFlgQNmXHD+tu7mWDDgIuXrrECF8Y
	ZStJypwJgIpS7Pwjr+8bk5Sa0eIMukJbD2majOJTf4/l+MjOREyeRmjEPU4XWoyXE7kIssOCEkG
	ZAfHCWJA3x7UaKSCsp4qlPBHllhTffJYCQm8NVo484BFwYtZX3OmYpCA8zCD1hhU8Q==
X-Google-Smtp-Source: AGHT+IE++a185aCVAwGW9af+PNdrfc3K4O3/zeNI4/CnMV32fBXiZN0yIo7Y1YMI+EEIUBCDGyE+Pg==
X-Received: by 2002:a5d:6d86:0:b0:385:df6b:7ef6 with SMTP id ffacd0b85a97d-38bf57c94a2mr50508168f8f.51.1738074124946;
        Tue, 28 Jan 2025 06:22:04 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd5732edsm169125225e9.36.2025.01.28.06.22.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Jan 2025 06:22:03 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [RFC PATCH 2/9] accel/tcg: Invalidate TB jump cache with global vCPU queue locked
Date: Tue, 28 Jan 2025 15:21:45 +0100
Message-ID: <20250128142152.9889-3-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250128142152.9889-1-philmd@linaro.org>
References: <20250128142152.9889-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Invalidate TB with global vCPU queue locked.

See commit 4731f89b3b9 ("cpu: free cpu->tb_jmp_cache with RCU"):

    Fixes the appended use-after-free. The root cause is that
    during tb invalidation we use CPU_FOREACH, and therefore
    to safely free a vCPU we must wait for an RCU grace period
    to elapse.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/tcg/tb-maint.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/accel/tcg/tb-maint.c b/accel/tcg/tb-maint.c
index 3f1bebf6ab5..64471af439d 100644
--- a/accel/tcg/tb-maint.c
+++ b/accel/tcg/tb-maint.c
@@ -891,6 +891,8 @@ static void tb_jmp_cache_inval_tb(TranslationBlock *tb)
     } else {
         uint32_t h = tb_jmp_cache_hash_func(tb->pc);
 
+        QEMU_LOCK_GUARD(&qemu_cpu_list_lock);
+
         CPU_FOREACH(cpu) {
             CPUJumpCache *jc = cpu->tb_jmp_cache;
 
-- 
2.47.1


