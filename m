Return-Path: <kvm+bounces-54445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF510B21674
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 22:31:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9F4A3AC0CC
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 20:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 078CB2E3365;
	Mon, 11 Aug 2025 20:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WcffqWt6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92BE2E2DDA;
	Mon, 11 Aug 2025 20:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754944250; cv=none; b=DNma/dp0XMLW2114FyJdLwPrmcFOaY5hjezsYOwzsDachkKONhaM5mnL5RCBOak2q+9vETSxfGK+bjQWsMqhY+QsjDGovibK9R6/AnYes5KFMvBu0oboGY3YcYRSsExpFqMsIjj1B+uS0DLowljtjcyXPnBUvDXNlL63HcOPtd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754944250; c=relaxed/simple;
	bh=wUECtlIbsLmHWWJ88W2MG6hxib5DzJLNpd5wCundfC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbCyX1HnIjddRaYhe237S+5VSxiIYeofaPULLhlPpjbpLqCu1uOMuqoN1qHg0YoSSO7acNVnClGghxk5ihP6HAIKL0S/mMOYsL/Ae01Lid36aJtdYYRu8GtNVryFOSYI/Rt77Wh6lsnzujH062uAqD0SrIA3QfTNtiGJvQPjD8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WcffqWt6; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-76bde897110so3864418b3a.3;
        Mon, 11 Aug 2025 13:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754944248; x=1755549048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3KTTJLVrbktE/WUXxY9rjC7h/JZ7lP0meBAt76ivfYo=;
        b=WcffqWt6/H9m9V3zZ1PflJNJ3sY+ePmgQhW0ZRIcV5NCqVHUtF+6mV5h1sGbiXUzqy
         YDlPtwXeKF/5FSocemfbW/4k1BiBgF1iezT03uCEJBYc6UHM2AQdrJRxmjSZ/0a8Cl8M
         0pU5LK62xc2FjYoWtNHu/Hsh4nzswGJXhaAuK8XvTkHqWgzi72s0zOS6tzECNkah+p6m
         TOmgfMyllG+4wG/DVLQf5naXBbofAvvQZZo2WaK2/BxXvFC9euMeqiIvSz4jum5yRhHl
         0yZkNjpzLnjUtO0OzKaITBzZhjbswDfSv7YUjfGccQLtJEr63H081Y7VC4zz68f7ZnBW
         oVOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754944248; x=1755549048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3KTTJLVrbktE/WUXxY9rjC7h/JZ7lP0meBAt76ivfYo=;
        b=qqz3+EtMn4gr2OX9HSwXXDud+DD4GSRs+k3Xf3VnxCKDkLJQRoDb5h7FPJ4EV01szU
         gg9xXkdUj+gO+VYuPQS+SuJqLdgC0iXoFN0LzWKmn83sUMXHJIHe3SsAX1AoIP5fJpg4
         mP3zTzl/s7QxmvIoZ+d+YoHJ0oDpSy1YPh/cumTbNh+H8Zi8LA8ZhqVwpkATKaIe3Whb
         0zoySZ2L+4nFId8AVR1xW4LZPft9C9qOUtU7NSv5Sgm46ltmsTyoNT+70mwCV/+jb6oB
         DtH6gW7fTH79/YtvyDaUi3FqGMD8yJUudMo2FM3IJ2Z9WQOtxsKAgyhJ/qJbQcHdB4wT
         zE0g==
X-Forwarded-Encrypted: i=1; AJvYcCVHEPPR7i9cu/GolS+HA+foizKqs1UJaRtFc5AnlMNU99rj+EmAi/Qjljj+xmEdtY3FAXyCwwkjNx+QarKf@vger.kernel.org, AJvYcCVybOotm17pR4FPTGHOGejmmSpJGz8e/84z8nvazaCsAz47OBGUIT8SOYLmCbBW+Fv8yTg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwN2J18RkQ9Nu/wPar4Mc8bWDZRbtbArpGZQus8+H5Wjc/KqpuX
	mIqY7DnVmgtcaHORjOznHaSG22Q06acxd7fM4JlxkIuoIB1skUXvyC9P
X-Gm-Gg: ASbGncsLT74RcLWMeSqW1BHZqL0XyyxVCslVByKohVLezQlxwMsq0LYKTeiWhCtxpis
	3YWYbdN1UW6wZzBhoh+1BSCD06ZLuTDMIBT/JuUM0jjf35fa7rK8xycEH9fyNgroDLlSPFE4Qf9
	7Qoeo/l5tGoUy3oySpp3xn8yJpLU3wh6jd+Ojwu9Ya4aSTFtoBVdlfRqgFXyAJ+twi+SExo91W7
	O6OZFqYOxKhaehlx/38GogzLG9cRsNhrxsgFCdrv2fbIjDqIqe6YLJ3t49tG9BoNsKuHVgIi8U2
	wgZb/EudAugDAm387ktzoO6+IumhHqal+mjcKGAHGqXUStrlZyGw2WgQQheSM9Oa7Ff8nDe0Wrf
	kR5sXw+Sj6FUum5KJm/IwuQ==
X-Google-Smtp-Source: AGHT+IGyqzQEcjDodcooA9KbupvrR+OL/l6BviO6gYi92pmdB6zkM3HUAlN9YIooWs68gtLhrxT5SA==
X-Received: by 2002:a17:902:ccc3:b0:240:4407:4015 with SMTP id d9443c01a7336-242c22269e4mr188657395ad.45.1754944248014;
        Mon, 11 Aug 2025 13:30:48 -0700 (PDT)
Received: from localhost ([216.228.127.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e8aa9257sm282819115ad.153.2025.08.11.13.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 13:30:47 -0700 (PDT)
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
Subject: [PATCH 1/2] KVM: SVM: don't check have_run_cpus in sev_writeback_caches()
Date: Mon, 11 Aug 2025 16:30:39 -0400
Message-ID: <20250811203041.61622-2-yury.norov@gmail.com>
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

From: Yury Norov (NVIDIA) <yury.norov@gmail.com>

Before calling wbnoinvd_on_cpus_mask(), the function checks the cpumask
for emptiness. It's useless, as the following wbnoinvd_on_cpus_mask()
ends up with smp_call_function_many_cond(), which handles empty cpumask
correctly.

While there, move function-wide comment on top of the function.

Fixes: 6f38f8c57464 ("KVM: SVM: Flush cache only on CPUs running SEV guest")
Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
---
 arch/x86/kvm/svm/sev.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2fbdebf79fbb..49d7557de8bc 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -716,15 +716,12 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
 	}
 }
 
+/*
+ * The caller is responsible for ensuring correctness if the mask
+ * can be modified, e.g. if a CPU could be doing VMRUN.
+ */
 static void sev_writeback_caches(struct kvm *kvm)
 {
-	/*
-	 * Note, the caller is responsible for ensuring correctness if the mask
-	 * can be modified, e.g. if a CPU could be doing VMRUN.
-	 */
-	if (cpumask_empty(to_kvm_sev_info(kvm)->have_run_cpus))
-		return;
-
 	/*
 	 * Ensure that all dirty guest tagged cache entries are written back
 	 * before releasing the pages back to the system for use.  CLFLUSH will
-- 
2.43.0


