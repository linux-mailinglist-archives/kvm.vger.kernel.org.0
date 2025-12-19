Return-Path: <kvm+bounces-66297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 442B9CCE659
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 04:55:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1554B30378BE
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 03:53:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D2D62BF00B;
	Fri, 19 Dec 2025 03:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cCZjaWc1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7E028750A
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 03:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766116434; cv=none; b=uCYtxFvFP9p2+B+CijJlirZWHF5ZzkAWiczqLqZCTYUTVEpLOPokVX8UyFU6yrqH9GQWvWqjcFl8Vq3T0z/9CLyaBTM6GGwDySxoZI7S0Ow3iHI2Sh0l6GIOojmLC/wq8x/QFq9Dk48dSDpZSquyZsXX2RgCwUMxnmJYH0kteBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766116434; c=relaxed/simple;
	bh=nCfhV3t3w0fDBZ86SZ2f5UYt0sbOmM5oEt/LOCV1HW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7fTOZAkrwSh/LqYR/9P/YIDobuG1iCRtE6ZaEBdjfEopSrwuBam48m8wreapWZW6GI/LjzPwNrSdg+talb8vkOJpjQtstYZuc2mp3ss8Qo3Ssc/wsfsXnVQKfuSxpMtk7ShibvJ1pt089HVbI2o7O5riWwTg5+WJShibfmT2CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cCZjaWc1; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a07f8dd9cdso14999425ad.1
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 19:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766116432; x=1766721232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PKNOibSL1/cWKHhBQtnXUGps0akL1GNIAh6E4cPLko8=;
        b=cCZjaWc1R4JwB3IAFxYJEg8sRuhJCQ6qPTuB6WDCOb47OFHUPBve4lbtnxH1GS+hqb
         HowBcqxHnw4ZLp4RO7KeGJ5BT6sVt/Td24IW6BvuekBzXu3PB5DTZGKm1Plp7Xs+Q7MY
         7o/yfgpR4lsI9TCApEMeMEUX31Vipoh1YV5UKlc+O0cKS+s1hXJB93SMQmZlojpmejyU
         GvyNUbEqvYPVVmKiXA0oXOVV1hu21qle+H+GhzGUeUfJpbI9EBCcxF7OdAXpxtcq/wj0
         VrP6oVMS21hlZ6z1yTssCT+Nbhy+D/pMXp6ZnWrgJhVenjk88+PFlFHXgq79i9UzAgzD
         BR/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766116432; x=1766721232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PKNOibSL1/cWKHhBQtnXUGps0akL1GNIAh6E4cPLko8=;
        b=ZNSkjsHgPujQUsKhPimuB5rC1VqZAfSn1f1u4jfw+tA9CpfSc7M4FDTclEKN0UpWpO
         3H7YaS6MZRMVWLrdCDtjEPUxpb8aReG9h7uKJRuuKRjb1pfkSl5F50nfuqgScBajTaz6
         OoyR8jtXf1Gl4AkYCPrlCPqJpLYvyIvXJV5XWSpxf2khtwJIDPxszy2tAkxFeUpH9h+N
         bmYhOvCJD+RuJsVzO4WcPLTLhfeW3h5jsiKUoOXWolf9K4oGHALr7PYv+uR5U/kJVrH2
         xr3C1EGbMdFMBYxYSXzfrxrWgBO6Mr3VqjWSz50dt2XDCY2MuyVCJt8N5xdfXcB7D8Wf
         4q2w==
X-Forwarded-Encrypted: i=1; AJvYcCXs3k7kOvTuZHgiOIg45fa+nr3wX19/16rVR8NYFFv5CUYjWLL0TMJR0FpdRzoDwdH4s0Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLwuwubKs6Wd/XsMGnfCyxOaspS6WJpw7gq99zxxfDKFqgwFAB
	q/ZPBBDZrVy3cReaLgM/JZmMZQrbTBu8bXDhRrOCa1EZ5KWxOkfswU4o
X-Gm-Gg: AY/fxX6GX69W2PNHVJS+kQ/7ZrZP6qMur/DGrwCkscnFe7fv3Izm5W78kDOfzsJ15ly
	7oBpms7HDirdObCR0tkeqtG86NU+ExbI7couxkwtRcuAiTcP/DRNnmpIQ6/w3tEC+bspL/VBJJx
	5pDpRHpivVle/1Vden7c/8agn0pD8mvdtp9eRzWtuZmeARFdJVwm0P1y4jPyoVQJt77Fj4zQLQo
	yBdqN36r4YS3LSLLTNlVHFGCc/a9pClJo9m2RffQD9NPSFyUOLyC+YCfYqcDd1vuWEZ/a4HgfZo
	7n6akK7eGn991ZrCShy9frtrj+m6cqRfgzwPqEztXuDsNMWbiUW8YwXbvvhDZIM1L/QIj5UNSmO
	7hzAGlniA76NdCCg4vatOHziOHRg/jCYlH+vKYXsykgiSsXgDkYL/amTjtu2+WZuvyvQzs09rAJ
	wSkm4oUcsuSg==
X-Google-Smtp-Source: AGHT+IEJYyJNSB3Ukzqrx3Oaw5wAgD+IMqeB5MdBvVM8lj03fHxXJGocNZ4Q2zrJZ+PSFeJR4jFMuQ==
X-Received: by 2002:a17:903:2348:b0:2a1:2b5f:d16b with SMTP id d9443c01a7336-2a2f28367e7mr12961555ad.31.1766116431728;
        Thu, 18 Dec 2025 19:53:51 -0800 (PST)
Received: from wanpengli.. ([175.170.92.22])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2a2f3d4d36esm7368135ad.63.2025.12.18.19.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 19:53:51 -0800 (PST)
From: Wanpeng Li <kernellwp@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH v2 3/9] sched/fair: Add cgroup LCA finder for hierarchical yield
Date: Fri, 19 Dec 2025 11:53:27 +0800
Message-ID: <20251219035334.39790-4-kernellwp@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251219035334.39790-1-kernellwp@gmail.com>
References: <20251219035334.39790-1-kernellwp@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wanpeng Li <wanpengli@tencent.com>

Implement yield_deboost_find_lca() to locate the lowest common ancestor
(LCA) in the cgroup hierarchy for EEVDF-aware yield operations.

The LCA represents the appropriate hierarchy level where vruntime
adjustments should be applied to ensure fairness is maintained across
cgroup boundaries. This is critical for virtualization workloads where
vCPUs may be organized in nested cgroups.

Key aspects:
- For CONFIG_FAIR_GROUP_SCHED: Walk up both entity hierarchies by
  aligning depths, then ascending together until common cfs_rq found
- For flat hierarchy: Simply verify both entities share the same cfs_rq
- Validate that meaningful contention exists (h_nr_queued > 1)
- Ensure yielding entity has non-zero slice for safe penalty calculation

Function operates under rq->lock protection. Static helper integrated
in subsequent patches.

v1 -> v2:
- Change nr_queued to h_nr_queued for accurate hierarchical task
  counting that includes tasks in child cgroups
- Improve comments to clarify the LCA algorithm

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 kernel/sched/fair.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2f327882bf4d..39dbdd222687 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9102,6 +9102,36 @@ yield_deboost_validate_tasks(struct rq *rq, struct task_struct *p_target)
 	return p_yielding;
 }
 
+/*
+ * Find the lowest common ancestor (LCA) in the cgroup hierarchy.
+ * Uses find_matching_se() to locate sibling entities at the same level,
+ * then returns their common cfs_rq for vruntime adjustments.
+ *
+ * Returns true if a valid LCA with meaningful contention (h_nr_queued > 1)
+ * is found, storing the LCA entities and common cfs_rq in output parameters.
+ */
+static bool __maybe_unused
+yield_deboost_find_lca(struct sched_entity *se_y, struct sched_entity *se_t,
+		       struct sched_entity **se_y_lca_out,
+		       struct sched_entity **se_t_lca_out,
+		       struct cfs_rq **cfs_rq_out)
+{
+	struct sched_entity *se_y_lca = se_y;
+	struct sched_entity *se_t_lca = se_t;
+	struct cfs_rq *cfs_rq;
+
+	find_matching_se(&se_y_lca, &se_t_lca);
+
+	cfs_rq = cfs_rq_of(se_y_lca);
+	if (cfs_rq->h_nr_queued <= 1)
+		return false;
+
+	*se_y_lca_out = se_y_lca;
+	*se_t_lca_out = se_t_lca;
+	*cfs_rq_out = cfs_rq;
+	return true;
+}
+
 /*
  * sched_yield() is very simple
  */
-- 
2.43.0


