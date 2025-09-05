Return-Path: <kvm+bounces-56870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D5EEB452CB
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 11:16:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBD88189A0B5
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 09:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DDB13164A8;
	Fri,  5 Sep 2025 09:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="a4K7IxD2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B39928313D
	for <kvm@vger.kernel.org>; Fri,  5 Sep 2025 09:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757063514; cv=none; b=oKHxgLZqvG6Z6I54h1cf1szOZzgcRID+7LyM2rEWbGBDdvd1yLF+6tbZC9tTPrF8HAOSp5SXa46m5AnrwvjbxCmlvJy5w7ykPqO1/BfDDtDB2n3zuXjYQ1mj96kj7MBf/Z1n5TRlbP/5PHEcrfj3rQk6Ce7Zp7Dx8GEg5rKAFZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757063514; c=relaxed/simple;
	bh=rwDuCmztYd+toVRjJB9A29waZRnshUnClgrpnY09UqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dTqJxPaGqltnCbXOgzVHnSq4OjdIWxLaVMB6grNVkKseOH0uVsAlt7g3wnVQS+yVW95xfbVX6Cj+KpkCuAOtwiM31TjMwTc2i3mr+2sa+m+GCoThT1qvPteO5/zoObjntwbiJcJil6vO3xE8p/9aivwTHOPO1M+l+8c8y9lAVlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=a4K7IxD2; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45b9c35bc0aso17283105e9.2
        for <kvm@vger.kernel.org>; Fri, 05 Sep 2025 02:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757063511; x=1757668311; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WehogbhCOngrfVkXJ9gjqQ8QZM8alTGTBjSwoe0C/Io=;
        b=a4K7IxD2VHGC86AB568ZolqqNU57Wq87ZckdV+qj8ieWCMAbgFMYcqmEonKFj4cPDe
         r04EwQUBzZ8JLb2jSAdsmdmSVi/siKfBVWY0mgvUEKEav7UT6RTllDf6tqCwM8ntObX1
         jNTNojQhF4FPd4wnSSE5NR5SOwAaxl1VzvdS3fLawYGBDOlAWer7ejVfi0NzBrvSI4C9
         RjHDxsW/eRknOxJeCbxNDf/XDqI695a81PG4ezVt/Pw05Cq3ttf0ERyTWl7AkNAeeQur
         9D35i3uwK7pOVG7wVMJey6OSR+So95BKv5vzJjU0SbYzhG8lbOm1QxRgTeIj92fIHQra
         +x/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757063511; x=1757668311;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WehogbhCOngrfVkXJ9gjqQ8QZM8alTGTBjSwoe0C/Io=;
        b=rIOzPJSVFzHwswap2TjZWUfcdRInnhCuiCVOENN5mjriRcYRBdgn+uvkxgpAsz1k73
         91d9Zcbgb7W7s/pIIlgDvsEa15MlvXidxq0IifE/3/J2pt7gg7pu+ctP0kiOPcHzrWFX
         DaiGxMYgiZh62Qeu/h+til8WZy9fh4b22vOYLETu7MmXe9MABEJbQNBVJa2Okjq9nNsP
         70fMCr1L11e/jJMF4t3kAurRIzdVxWK3b7LTy6/oRH6UXwsPcckYFiUXqWsZ0eszB7d6
         N32CkRBpTz7eBWEFXtvCTfvNys+Hmhrrh05D4wI8QrDHirIRTlLFafS5Zx7XX/6wooA+
         9phQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1+PLuhd2tYDBLptWVioy5C9vbANB5CblGjRqXYJNbEcOGW8UKQL0cklCfvz9uzaP+LVU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTLH3PBPH4MzAyeYfpp1By/XVptQDS59jAwZ5Pzgt2aWHQiRur
	PWAUESD5fwgukAF2LC8adZbXN3D3spGHTbyjo2UhrSGFiOe7PAUevBjos6wmEWDW9Lc=
X-Gm-Gg: ASbGncvYTsBrB/0Zyq8bv9dIBdU3Dd+bGgdVNkHEe4nBl6HZuO1Y95NZ9ggcwzOeHg6
	lPHOR2BfA5HaFZYmsbWpWmc9c7YOb5++z7ZMmPbFNNyLSnsvuRNovO2rWV2xaEpzEr9LYXraUJD
	GB0mVv6Kd1aI5DVqr7oVBQvqMhtRyc6UkXwOP6kwlCih75cGH8nDqQv9yH1qeNqXj24EBKkYvJk
	v6CXNquVI5MFRd6wyEIDQw8Sk3kJ64U6bYxkTJ0titP9zgC7lJzjIFPWf+JOr1gJ9sJglGguypJ
	phq6lofURcI6VaDy2NmXR119ZeRtkFmjo2WNf76oYt8n+XbTSVgjBefUGUJ0q2+o/oDbqkustgT
	ljBsCF3V6MA8AdHZXjZiukwTfMVM4UIrDxKAw26NGgs4a1fEuMA8JogxPStNiR3MMG23O
X-Google-Smtp-Source: AGHT+IFVCL9azlvebkaZgj+cN9WIHPQixc398V2PgiYXnFdLCE8sqr7fuSJu1LNTEfRiNNxjdHwG7Q==
X-Received: by 2002:a05:600c:4ed3:b0:45c:b549:2241 with SMTP id 5b1f17b1804b1-45cb54923d6mr69358275e9.27.1757063510653;
        Fri, 05 Sep 2025 02:11:50 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dda4f2a0dsm13296265e9.2.2025.09.05.02.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 02:11:50 -0700 (PDT)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 1/1] KVM: WQ_PERCPU added to alloc_workqueue users
Date: Fri,  5 Sep 2025 11:11:39 +0200
Message-ID: <20250905091139.110677-2-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905091139.110677-1-marco.crivellari@suse.com>
References: <20250905091139.110677-1-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently if a user enqueue a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.
This lack of consistentcy cannot be addressed without refactoring the API.

alloc_workqueue() treats all queues as per-CPU by default, while unbound
workqueues must opt-in via WQ_UNBOUND.

This default is suboptimal: most workloads benefit from unbound queues,
allowing the scheduler to place worker threads where they’re needed and
reducing noise when CPUs are isolated.

This default is suboptimal: most workloads benefit from unbound queues,
allowing the scheduler to place worker threads where they’re needed and
reducing noise when CPUs are isolated.

This patch adds a new WQ_PERCPU flag to explicitly request the use of
the per-CPU behavior. Both flags coexist for one release cycle to allow
callers to transition their calls.

Once migration is complete, WQ_UNBOUND can be removed and unbound will
become the implicit default.

With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
must now use WQ_PERCPU.

All existing users have been updated accordingly.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 virt/kvm/eventfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 11e5d1e3f12e..4f0bdd67edb2 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -662,7 +662,7 @@ bool kvm_notify_irqfd_resampler(struct kvm *kvm,
  */
 int kvm_irqfd_init(void)
 {
-	irqfd_cleanup_wq = alloc_workqueue("kvm-irqfd-cleanup", 0, 0);
+	irqfd_cleanup_wq = alloc_workqueue("kvm-irqfd-cleanup", WQ_PERCPU, 0);
 	if (!irqfd_cleanup_wq)
 		return -ENOMEM;
 
-- 
2.51.0


