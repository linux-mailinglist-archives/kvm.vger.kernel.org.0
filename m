Return-Path: <kvm+bounces-36779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B33C7A20BF2
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 15:22:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A6D9188698A
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 14:22:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 157331AA1D2;
	Tue, 28 Jan 2025 14:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XYSQSlpK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879031A9B28
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 14:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738074158; cv=none; b=X8f2pjlOZDO9j/iQ6V/N1KJr8exSQ84Bb74Xl5s3joCk57EC9Z1dsayDeJoDIEYCU1xA/A3Hfmoj/e9qi+FSLevN8O4J2l0gEj0LdPYiiz345KuLzGwDARjix+8eZdiF/+cixSb0AoG4AI1OhK0eJMWRjAguxSl3pri+nDWAT0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738074158; c=relaxed/simple;
	bh=0Ue3vKaJ3drYPDwFKIjK40ldGlBOO+Z0YsClyzcq0yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mHh50xu3tJ6WCDlvyFu6fq33LlhkCuDSwHK3IozOezToh74606R4cGTb6ArwukYNKW+IXzPV+cNHWwsB5pFhqtWI800CtFveS7CuiCy8CnJPoCxHR0EWFi0MPrzBXh+wewFg6uIP6hCgkqj2JKYY4oLk4JOXluFlijW2GEk8UkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XYSQSlpK; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-385e06af753so3114147f8f.2
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 06:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738074155; x=1738678955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YRDTHlfvyOrER0eUl5RKITSLiEo3HyKeVBvSp+Og3D8=;
        b=XYSQSlpKGN1IUscoiZrAC3yzQD8wD0U6+eSv/egVxyA86D2YngaNmLx8wQ1xFOirJG
         a6D3/jEwAOAeqXSYvNY9+WO9czvyClQDBs313uZ7nbBbtE1KrSfcyf3edYYSCUnvzCX0
         OCs5NKldU3wZGSpJR9jDLm5kefNhBAhRpyrcNpi9sKziQvujYnAhpm1k1am3kv4+VED5
         ZUxqGaZ9pfhSGt/sFsxdX414N756urdReOA4kXVD2hUnpJq4fxph41sdeTgRL66za7bq
         6hMGzxufCDnw1JzaaIMJLC+GIiBVOCDeoFiCTg+c42tVCNHeAERq7ECzuumBV3JxYcXs
         Syew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738074155; x=1738678955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YRDTHlfvyOrER0eUl5RKITSLiEo3HyKeVBvSp+Og3D8=;
        b=kkg7Hnf2i/Sth00So9Z2EIZ075SOz8yWtBG0qeZI4Y6eF5qgeRC5mDil0T9VTRg7uN
         7g/uJTCwKZLY29nLw8h2ECoIGtPjQth+L2GMEwKBA24sa49y2nwS1H7PN5JuZJIDPFrZ
         agn2NBIIIWe9ErJJJhFY6GxvMN3FRBiXApKwSpuRADI2UT4I6h+CZx6+Ija/xkHpdIQK
         HkjEnnqKSd5Gbutozo13U5Coq5yZGevFmw1v+jtQSkhdk3sZVBx4/iRhScrlGqCXlrU7
         3MSK/o8ZiPYDN7IeamQHeej78LJB1yfljbBvJL6NQvlyLoAVg+O5tZWfZtWuHMuTjq00
         8Y6g==
X-Forwarded-Encrypted: i=1; AJvYcCUjgONJ6wxdyrmFu6D6coujvI/bQQ/1Y7irwh+SAwhySU9k0LV0cdiiaK87txag7nFcfpA=@vger.kernel.org
X-Gm-Message-State: AOJu0YywMT1/3H2hHFRmzDb17385B2BxVkRuLo1HVtYMNHT777c/ijIS
	L78Htc6GLcl4oSc6wxeEkL1StUOmwRm5xlvz7bHumy9qGbSw0JqyM9IytPzBNe8=
X-Gm-Gg: ASbGncvaVTTER7s+ALpDRtz6/crz4PECX/Qhn1Wo82J9xdS2aEb0qEey2Ft7AzTGOO+
	ioIes6jAnvD+6OfxmtYULcBoHbLcCV/RINffW76CC2APBL0bxKOSN3JZeKNCmXfc6AcQ3HXXhf2
	R6sn5Zv0SMISI+nryJlGmKYjh9xJEZLW1XJE39RmwikKEJGN10QQgUIxxNCvcTWiKkugzv616Zg
	oBRjDGLM6BswczND9hCr1BS4NrFMlnZE5oeTdfqOLAQ0Bx9KIb7hUYd7bVPNSwDys5P1cDC23yV
	sFgni9FJMX/6QkwNWBXFMYIu8UeUHA0of5wJaHEjWPOpWlP03pFGTTHi80soxNLR4Q==
X-Google-Smtp-Source: AGHT+IGUPaLAqP3HpLzD0IitgxG+YT9FIQ6tbXwdivHVU4DsFGAjOBMGO6K9Ad7biFURl7kv8n/Uug==
X-Received: by 2002:a5d:6c65:0:b0:38a:888c:676f with SMTP id ffacd0b85a97d-38bf565f13bmr45683211f8f.15.1738074154855;
        Tue, 28 Jan 2025 06:22:34 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1c3fedsm13952511f8f.85.2025.01.28.06.22.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Jan 2025 06:22:34 -0800 (PST)
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
Subject: [PATCH 8/9] accel/kvm: Assert vCPU is created when calling kvm_dirty_ring_reap*()
Date: Tue, 28 Jan 2025 15:21:51 +0100
Message-ID: <20250128142152.9889-9-philmd@linaro.org>
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

Previous commits made sure vCPUs are realized before accelerators
(such KVM) use them. Ensure that by asserting the vCPU is created,
no need to return.

For more context, see commit 56adee407fc ("kvm: dirty-ring: Fix race
with vcpu creation").

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/kvm/kvm-all.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index c65b790433c..cb56d120a91 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -831,13 +831,11 @@ static uint32_t kvm_dirty_ring_reap_one(KVMState *s, CPUState *cpu)
     uint32_t count = 0, fetch = cpu->kvm_fetch_index;
 
     /*
-     * It's possible that we race with vcpu creation code where the vcpu is
+     * It's not possible that we race with vcpu creation code where the vcpu is
      * put onto the vcpus list but not yet initialized the dirty ring
-     * structures.  If so, skip it.
+     * structures.
      */
-    if (!cpu->created) {
-        return 0;
-    }
+    assert(cpu->created);
 
     assert(dirty_gfns && ring_size);
     trace_kvm_dirty_ring_reap_vcpu(cpu->cpu_index);
-- 
2.47.1


