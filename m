Return-Path: <kvm+bounces-54446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 69D72B2167D
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 22:32:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 456C9179FE6
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 20:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F23F2E3AF5;
	Mon, 11 Aug 2025 20:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hpq0vbBW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515862E3384;
	Mon, 11 Aug 2025 20:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754944252; cv=none; b=Px8g2WKrW9keesZn+9hC199FBZ8ncVVolZawgtQdTJHUGQEUJJmk1SqQDuyVFFKrLwEgACq/xOWB9B/Rx8lS/jD7Nl53PHByVyh5pTJvjy6en2dGkM6BxJZYvSYLR2sp3Fm+r7t69RyBNruJQM14qqYgajy9gYSU48v98P+dwQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754944252; c=relaxed/simple;
	bh=/lKZBN3FQb3q5iFl0Vyryg/huT5sWdXAq9aF+2hjyPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIn2rILei+LRIs5hH50RLkd3++TYty3EEzRieTlCWEnA/4mDzmNBa6UkJ4V/qAEGiWApHK4HOUykqIbTpvTzyvr+1cavn7qIz0MI2LGrj8LSepAPOBG0Ft//R3KLwjPlmIjh1YUGW/d2heL3dtXaPp3FLIXzI0ukmi/Cc5XTdhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hpq0vbBW; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-24014cd385bso51747215ad.0;
        Mon, 11 Aug 2025 13:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754944251; x=1755549051; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ybMRZTgv3oC1ihHCLfyTiTsTTpYBFFa2wazcWgJllXU=;
        b=hpq0vbBWYVipqH07qeulIOHoEcCg+nqKXtprFS9XIwRI26n4GoiQi/D0q1o6VtehTZ
         2F5bAPHDbB+Kxe0ZL+U1KwX1zo1MIHGlVsCus2AlgevqRvf5mpZDqiumJBJ5KMn+V6VY
         7CnAKRXiI43qg87OT0bO4sQbLJXGpdbg/GoUsE+LmyYBGS7PQGWCM09qzqW5YVpoOIJ/
         /Z049WXzZ8hGGy5YQZUOko1U2FGadwJtNKZJJOtfTGjo8qEkKwOAkMJQQinqCLWSmFnb
         v9Q8HhTZKptKc1oxwpvUoyBSeQJN3DrDjMK54DU8PpUw993wFm7SGfifIikpRJ31eIIE
         vIcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754944251; x=1755549051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ybMRZTgv3oC1ihHCLfyTiTsTTpYBFFa2wazcWgJllXU=;
        b=Rdh+xJZvCOxbTr08KHLQSsBrOIakCiK8gp/1eiddFZHRT15EOy2kY2n4Y+QxNWPpMj
         eax03rZoZCIxqEd7AbatBPo2UPZX7kmin/OKFKLEL8Oz7MiwxjbnBB8y+AHPkV/IJfCA
         7eKDgHzizMBBiE/x1FsWzTnySQXWEE1iIgEejii1nBXcSuMy3i5mPIJ5ett60lpDhEhw
         LIWDNiDysWVjnGWVgJaqP6JUkAxQPLL0ESP7I0uuJl+hepmwNcp4FUu0UZ48kWyCKxcv
         AZnA4QNHhR8uXBK+YN+ahiHyEPcPkjrFAA19URwoI3JuErWDsmiYwiFQdsY4GFf0elwb
         a5rA==
X-Forwarded-Encrypted: i=1; AJvYcCW1JnH9p8ZJGxhOAtjQ61pDtyYv+1xToB4PLlDpWD48qGFxSQRfg0duQemAnC4G3Jlvp7LmF2O8Fj5dAbkT@vger.kernel.org, AJvYcCXrEh7NDxODc04P384jvnXZ1/38I+NFPrgKLZf0xlT7KDdORElTSacnM0UiFtwJlYMQV04=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyw7hrTJSnfVhyXt/wKKjKrH9n6kg5lfXYcJa2qkmbsFtkWX5lB
	wZz5MUR97LWE5cGNCOrH6Y3jiRzELd6iQGdL+4XhwwOhEIIhKBQKSJQF
X-Gm-Gg: ASbGncuuHt4IXJX8umt/RH700YLI18w/DQ/pr5YIgDMX03E7xmZWFf+Z2j9sYGRqHjQ
	vX2aHcMZTfz+xZPlApVxXfyisHjBfh3bod6MFf3r9DiF8yYQ+Jhk84xkqCzzDkiFzyX/VFb2uXq
	kX1aF9Q5njeVCp8IS6TPVnyp5uMsee8di9A2SwSUsU04nRPnEz/w8qGSYlVTIB3afXz8l5rkAoT
	yAXsqvmmhEXgmguX5Eb5yNSQuZbx1Om2gj3wGM8bWRfaUNI1EN6rYmTYLyTsRg7qpM0k7rhV1N3
	3tlOfv1ziry6Tz1+5WXksCEQY5by0MtCXIlGwxYAQJxrg/+SWqRKPblRiOqf5vKCaZyjhbb4as6
	n3lLR1YfTxAG8L2JuD8QDAn4vo5WMmBWU
X-Google-Smtp-Source: AGHT+IGaNNb+G/hwuP+rxSrVaPX35PRiiEu0YtKNQPHdXKFBiJn0xhqc87s94QtSFmbNbzjXW57LRQ==
X-Received: by 2002:a17:903:228a:b0:240:50c9:7f26 with SMTP id d9443c01a7336-242c2007606mr187282205ad.13.1754944250536;
        Mon, 11 Aug 2025 13:30:50 -0700 (PDT)
Received: from localhost ([216.228.127.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-242fea29e64sm524285ad.84.2025.08.11.13.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 13:30:50 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>,
	Zheyun Shen <szy0127@sjtu.edu.cn>
Subject: [PATCH 2/2] KVM: SVM: drop useless cpumask_test_cpu() in pre_sev_run()
Date: Mon, 11 Aug 2025 16:30:40 -0400
Message-ID: <20250811203041.61622-3-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250811203041.61622-1-yury.norov@gmail.com>
References: <20250811203041.61622-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Testing cpumask for a CPU to be cleared just before setting the exact
same CPU is useless because the end result is always the same: CPU is
set.

While there, switch CPU setter to a non-atomic version. Atomicity is
useless here because sev_writeback_caches() ends up with a plain
for_each_cpu() loop in smp_call_function_many_cond(), which is not
atomic by nature.

Fixes: 6f38f8c57464 ("KVM: SVM: Flush cache only on CPUs running SEV guest")
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 arch/x86/kvm/svm/sev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 49d7557de8bc..8170674d39c1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3498,8 +3498,7 @@ int pre_sev_run(struct vcpu_svm *svm, int cpu)
 	 * have encrypted, dirty data in the cache, and flush caches only for
 	 * CPUs that have entered the guest.
 	 */
-	if (!cpumask_test_cpu(cpu, to_kvm_sev_info(kvm)->have_run_cpus))
-		cpumask_set_cpu(cpu, to_kvm_sev_info(kvm)->have_run_cpus);
+	__cpumask_set_cpu(cpu, to_kvm_sev_info(kvm)->have_run_cpus);
 
 	/* Assign the asid allocated with this SEV guest */
 	svm->asid = asid;
-- 
2.43.0


