Return-Path: <kvm+bounces-62473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C6AFCC44D5C
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 04:33:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A4EB44E61F1
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 03:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D5692882A1;
	Mon, 10 Nov 2025 03:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z8dnngHt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E1D287508
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 03:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762745572; cv=none; b=N1UNJGyH6R6oJS47ivPQFZoSuDTI+nONE2+7+AQDRih2lGcj0+UFE/KcWpi1Zbh5SkCqeEKUZmjbUorUJFzSLQL4k79U4sBRLaF00/lAiDhq2V2yydlUjS3QPDWdJcuR+XvbRVGUiE8XDtaoRpY9uPlv14dV4yM5no8sWnU+zBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762745572; c=relaxed/simple;
	bh=/Sbi2RsDbKFxh18qy4P7m0nH9/yJnCUGEiCikFyDTJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKoQKqE9sJIII8QeDPSL7gdc8KvRkuOkHdme3soeiOJqgqKsh70Zi8tDiOk0Bel814MZ+YL9zisx6yGFez11PBQrXKC0XvW5xRTkZ7iCKcqqK3Ao8V0ODDZIKgGpsf6vYlE3zIyGlLJswC5lbwIRPK7agitOyJOoGaYY8xOQMEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z8dnngHt; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-29599f08202so32695795ad.3
        for <kvm@vger.kernel.org>; Sun, 09 Nov 2025 19:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762745570; x=1763350370; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mJ2T78O7RQhMqXnI5opkr+3j7nLw8GADo232iLhnq+M=;
        b=Z8dnngHt/b5aMUY9WnaF+GYgDuxVtosMTTkzSJ+9CRgjsgwtAjHtJ56ZJDVfM7Pb01
         X2FPrOqHu+midWrOugGwvT3a2VcHqXSNi+YWkYmiAGgrAUKnDO9UqCrNb3sYViOlYGju
         KPuj/1p6cSUp+Z8AOxC1DyJXV4UJsj0+Ur+lxtmbV/mjEtMk8iOd+ZBCR1px9als/aao
         F0RjxJh7oerqXtNS8wGyQXTeRqLPBJsYZmbHahE/n4u8AGK7+uY/GpHz4eilqihvOAdC
         KNGtYwkonic8LMn45PTiBVhyrVYMbXKxqY7xn4p3FhJNDs8eJ56f1nFq7VipI5sDn10E
         gK3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762745570; x=1763350370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mJ2T78O7RQhMqXnI5opkr+3j7nLw8GADo232iLhnq+M=;
        b=rIvQjaoL4Ti6INNCYoPjMopx1/Lp6a5w1vjPsO1G1fCjiyQ/g8x4XvDzA/LE+7e0jZ
         Ug+JQFtX3QcsXz1874BU13pxeLXofy4FXa7FUV2cAV+b0MfGz1wPyaL8wMVdXsk3VMlZ
         dSbCU1pe8PJHzWzrhTtb4Oe87Qc+X6QlU4Jfw/GGJh/R2BRz0ANwnFdA4sv7cXmQDx3/
         6MkJ/2uRmUoI3PhubE60I6H15TVwls35MOF68drlQ7QOwMZKBKw5roPeuY368OqznyQc
         vmypjqGekz1YXwj0LJAgbetx84DWRv4ASUeUc74kovx+qG43CfZSAtGYmlLclvPLl64V
         WwxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXB/tEndk2BoSQT6nEC3V6NN8jw0irvpUA9hUj+QVGn4SBDz1RFQn9N1Bv1dMOoYdLbl4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/CFa/fMBUEC0Im3c5li+Cu9DT2AfhU7nMCihU7O4mm3tyXyO9
	zyB6zfQGmnfeXlD4JXLmQUQNi831gd403G3WwBG0aJr5BU6xplBcNXcv
X-Gm-Gg: ASbGncsamKB50w9w/kSdFgnEBvT1bn7JK2FkK6lHBDpfaAyf2V4/tXZECu/tifsz4+2
	/zc8uGMi5c4ZWiDVD0iKRXFXy/YK+utFkq3LZWvM54d+ejkxhDgGw/mmgosURiPBgyF0FIfqi1c
	xVV/G7VRSCcBN/wJgdw/d63NDAr6j0hMOFGyRLBRcrMWtu8ZT/8Qk0OzyZcnqdM/NTJxwLu7E/9
	hjy2r7dwF7Nh16EMIOzaAlq7LUKAvWSuGA0BHnrW1FNDy7iHuyTbGvusPRtzNpjkxMDvwc4kppS
	gmSL6gKLZ+Mx23O52crOwHYMkTa9k07ZQ9EUxUy+eLj1aMjvuFCyFxZP8/r/jpFZkjg3XcXtOYb
	STAMJbKo11Q8b1aDkvCiwje76ARQwoQlN8ENCfBmh3zAalnizBsj25VAgsvS02ksFIdo+SwmgJe
	ePilALgUcZ
X-Google-Smtp-Source: AGHT+IH8IURFUXv0dHkJ6ZHGGTBAvnY0vbnOOUIKPpXB78BdN5c4T+GwBYMwLuqJLnGxvgOdporgtA==
X-Received: by 2002:a17:903:f8c:b0:26c:2e56:ec27 with SMTP id d9443c01a7336-297e5627d67mr89334695ad.19.1762745570152;
        Sun, 09 Nov 2025 19:32:50 -0800 (PST)
Received: from wanpengli.. ([124.93.80.37])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-ba900fa571esm10913877a12.26.2025.11.09.19.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Nov 2025 19:32:49 -0800 (PST)
From: Wanpeng Li <kernellwp@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 03/10] sched/fair: Add cgroup LCA finder for hierarchical yield
Date: Mon, 10 Nov 2025 11:32:24 +0800
Message-ID: <20251110033232.12538-4-kernellwp@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110033232.12538-1-kernellwp@gmail.com>
References: <20251110033232.12538-1-kernellwp@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wanpeng Li <wanpengli@tencent.com>

From: Wanpeng Li <wanpengli@tencent.com>

Implement yield_deboost_find_lca() to locate the lowest common ancestor
(LCA) in the cgroup hierarchy for EEVDF-aware yield operations.

The LCA represents the appropriate hierarchy level where vruntime
adjustments should be applied to ensure fairness is maintained across
cgroup boundaries. This is critical for virtualization workloads where
vCPUs may be organized in nested cgroups.

For CONFIG_FAIR_GROUP_SCHED, walk up both entity hierarchies by
aligning depths, then ascend together until a common cfs_rq is found.
For flat hierarchy, verify both entities share the same cfs_rq.
Validate that meaningful contention exists (nr_queued > 1) and ensure
the yielding entity has non-zero slice for safe penalty calculation.

The function operates under rq->lock protection. This static helper
will be integrated in subsequent patches.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 kernel/sched/fair.c | 60 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a7dc21c2dbdb..740c002b8f1c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9058,6 +9058,66 @@ static bool __maybe_unused yield_deboost_validate_tasks(struct rq *rq, struct ta
 	return true;
 }
 
+/*
+ * Find the lowest common ancestor (LCA) in the cgroup hierarchy for EEVDF.
+ * We walk up both entity hierarchies under rq->lock protection.
+ * Task migration requires task_rq_lock, ensuring parent chains remain stable.
+ * We locate the first common cfs_rq where both entities coexist, representing
+ * the appropriate level for vruntime adjustments and EEVDF field updates
+ * (deadline, vlag) to maintain scheduler consistency.
+ */
+static bool __maybe_unused yield_deboost_find_lca(struct sched_entity *se_y, struct sched_entity *se_t,
+				    struct sched_entity **se_y_lca_out,
+				    struct sched_entity **se_t_lca_out,
+				    struct cfs_rq **cfs_rq_common_out)
+{
+	struct sched_entity *se_y_lca, *se_t_lca;
+	struct cfs_rq *cfs_rq_common;
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	se_t_lca = se_t;
+	se_y_lca = se_y;
+
+	while (se_t_lca && se_y_lca && se_t_lca->depth != se_y_lca->depth) {
+		if (se_t_lca->depth > se_y_lca->depth)
+			se_t_lca = se_t_lca->parent;
+		else
+			se_y_lca = se_y_lca->parent;
+	}
+
+	while (se_t_lca && se_y_lca) {
+		if (cfs_rq_of(se_t_lca) == cfs_rq_of(se_y_lca)) {
+			cfs_rq_common = cfs_rq_of(se_t_lca);
+			goto found_lca;
+		}
+		se_t_lca = se_t_lca->parent;
+		se_y_lca = se_y_lca->parent;
+	}
+	return false;
+#else
+	if (cfs_rq_of(se_y) != cfs_rq_of(se_t))
+		return false;
+	cfs_rq_common = cfs_rq_of(se_y);
+	se_y_lca = se_y;
+	se_t_lca = se_t;
+#endif
+
+found_lca:
+	if (!se_y_lca || !se_t_lca)
+		return false;
+
+	if (cfs_rq_common->nr_queued <= 1)
+		return false;
+
+	if (!se_y_lca->slice)
+		return false;
+
+	*se_y_lca_out = se_y_lca;
+	*se_t_lca_out = se_t_lca;
+	*cfs_rq_common_out = cfs_rq_common;
+	return true;
+}
+
 /*
  * sched_yield() is very simple
  */
-- 
2.43.0


