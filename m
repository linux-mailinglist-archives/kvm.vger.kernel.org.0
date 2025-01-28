Return-Path: <kvm+bounces-36778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 454A6A20BF0
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 15:22:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 993A0162C7C
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 14:22:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07B151A8F79;
	Tue, 28 Jan 2025 14:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KMNUKHYX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845CD1A9B3B
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 14:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738074153; cv=none; b=B05N1kW41OTHXK3FTNtoeWXrQ/5EPNhmKQcwNkLpOshigtzuvAEGpBnO56r1TmbPe+k7mU8qXOfUIm0TR29wpMQiq9WDz1S8lddFVALh/3Btzm1Kep1h5FDGvTrL6pqNHlan8Y2cPsHcInY1BwibP2sHN23Tf8u4AE3HirpFefU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738074153; c=relaxed/simple;
	bh=9qP2M/5pQU70znx9jB98YFuJ8vLrfb0v8LfsmSWQm3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wk1LyMePpJEmboyN9KdUVLrPWLH5mmI9gjwH97i4zQRPhvCPxWiLOTc6NGSFRnh4hb8WjUuIL4AZzr+Vs3LQ8Vy+ay7jP/8fARFNLU8YmZtf9CfLG+MHzUD4otUjaeuSGhOPdpNhIAPRgRU+Kr63f4FMCyNjQAlJB1NDy3zflTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KMNUKHYX; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4361b6f9faeso36461495e9.1
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 06:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738074150; x=1738678950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fwXtzSsp3Wrsq7TzutaYeT0jWiU8kps8I7b8yY/9nhU=;
        b=KMNUKHYXkhrlj47HVz39v4tGii7rq6/Ags6fDa+K3WrUnV3lbUyKHNAnDgAT+rk0xD
         8r4qP2ZaudcS6LhTd6rhxUKmZ3ERcRq9juZzGDcq4u4/1O54d7YKq//susknX44U4WE2
         03RsNcgkoCDF/+kJ22sHAqBAhmBPm4eZ3dtMGLf3sY12AuolSUoztMHjNlUP/sKq7EP3
         dIy4n1QuupitBosQ4tHbfIBSSsRerfyCMh6d3JB3KKIsqpm+YDtXhnNAG8xnqCa1Jgoa
         O5OgOIYoQVaRrjbysapIgdZzJpBPBEYeE7hBhYfliAe1w5wN0rS4AdNE2qkFd0F9yoQ1
         JSdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738074150; x=1738678950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fwXtzSsp3Wrsq7TzutaYeT0jWiU8kps8I7b8yY/9nhU=;
        b=fco4C6KaMBXSiloGcjvUgFplRmrENqvp6m9duZQQ9zvPbxx+VzasuPk/wT+3Ou+r8x
         bdi/WAf9zlQiuHOQ+INC1uHR2/Gt8KPjq34sipacGykWk8+ErNAjJ94nX52NwN7pMo1q
         KdDF1WaY9oSKHqKHqvT5Tob9Vbkrw/Gvjc6luHpGLuhpSCqxIGbU037KPAztMkr8Ai9u
         lDxkVdiwKCGm9KpmvR0519w1+CUW0YsqosDzbD4PZz43zr+BfD8LBmWJ+9v1+swR+ysm
         +zMDAX/6Dp2XNq/CBpaSsnsAUtle9ykpLhp4rprX21iMnkPsldvAVzAYLEhofi4c8+8x
         IloQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsjfkM9lVP+v9rIJF3S0PfYV5sgRbh50JC1qH5DtAJKGRMNIT2q5qaDekDR2DA45/UynI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy92opnlRfyNyX/dDgAMrgGxbT+RBB3XDviaOXbKuv/8O6Nlz0H
	6RrQuTObIycXhBUD3kbzs7RfRoqcCn0shL2gI3ADfTHn5kxrwWMOUt5iSRHV8g0=
X-Gm-Gg: ASbGncvsWW9foEx0YJm6lvrVQ4pdrFW/iYlEmc5+XTa8j8ilSTUKeGOc82HI8ndrA1y
	66xWcgHX0Uu/av6yRioqw7lO62dP4tkD4BcQAqRY6m6yg75vM0yDM2S36ZSSlMRFTy34tvacUU8
	d5JfpishA/XWXE+cCMf1d34ReeDGCHI5t5BlL49mlbgKKQcvBIVJhBqQIAahsR0q9KH+qPouAmQ
	H+lrNrLzZRAPiptrozNk23Uj+UmNT97Q85Ynp9ZWx1gX9Vf6ZiypK64kwkPP0XYMaCxTPCwKCXD
	Sic/3bG30CLNLIHEfGXoWPdxZKpb5yeZALbL1ld303Bi6O+qsTqO6t+R1tFVIW2EpA==
X-Google-Smtp-Source: AGHT+IGJgZU4Cp2hilxwmoMaixsHyforairgw/17QEoYqTReWbKeDv+qCHMAqmyxnXcqNHDKAhm1lA==
X-Received: by 2002:a05:600c:46d2:b0:434:f1bd:1e40 with SMTP id 5b1f17b1804b1-438d596d1bamr27108845e9.6.1738074149822;
        Tue, 28 Jan 2025 06:22:29 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a17d7bfsm14358242f8f.35.2025.01.28.06.22.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Jan 2025 06:22:29 -0800 (PST)
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
Subject: [RFC PATCH 7/9] cpus: Only expose REALIZED vCPUs to global &cpus_queue
Date: Tue, 28 Jan 2025 15:21:50 +0100
Message-ID: <20250128142152.9889-8-philmd@linaro.org>
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

cpu_list_add() was doing 2 distinct things:
- assign some index to vCPU
- add unrealized (thus in inconsistent state) vcpu to &cpus_queue

Code using CPU_FOREACH() macro would iterate over possibly
unrealized vCPUs, often dealt with special casing.

In order to avoid that, we move the addition of vCPU to global queue
to the DeviceWire handler, which is called just before switching the
vCPU to REALIZED state. This ensure all &cpus_queue users (like via
&first_cpu or CPU_FOREACH) get a realized vCPU in consistent state.

Similarly we remove it from the global queue at DeviceUnwire phase,
just after marking the vCPU UNREALIZED.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 cpu-common.c         | 2 --
 hw/core/cpu-common.c | 5 +++++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/cpu-common.c b/cpu-common.c
index 4248b2d727e..72ee8dc414e 100644
--- a/cpu-common.c
+++ b/cpu-common.c
@@ -91,7 +91,6 @@ void cpu_list_add(CPUState *cpu)
     } else {
         assert(!cpu_index_auto_assigned);
     }
-    QTAILQ_INSERT_TAIL_RCU(&cpus_queue, cpu, node);
     cpu_list_generation_id++;
 }
 
@@ -103,7 +102,6 @@ void cpu_list_remove(CPUState *cpu)
         return;
     }
 
-    QTAILQ_REMOVE_RCU(&cpus_queue, cpu, node);
     cpu->cpu_index = UNASSIGNED_CPU_INDEX;
     cpu_list_generation_id++;
 }
diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
index 8a02ac146f6..df7a6913603 100644
--- a/hw/core/cpu-common.c
+++ b/hw/core/cpu-common.c
@@ -218,6 +218,8 @@ static void cpu_common_wire(DeviceState *dev)
 {
     CPUState *cpu = CPU(dev);
 
+    QTAILQ_INSERT_TAIL_RCU(&cpus_queue, cpu, node);
+
     if (dev->hotplugged) {
         cpu_synchronize_post_init(cpu);
         cpu_resume(cpu);
@@ -226,6 +228,9 @@ static void cpu_common_wire(DeviceState *dev)
 
 static void cpu_common_unwire(DeviceState *dev)
 {
+    CPUState *cpu = CPU(dev);
+
+    QTAILQ_REMOVE_RCU(&cpus_queue, cpu, node);
 }
 
 static void cpu_common_unrealizefn(DeviceState *dev)
-- 
2.47.1


