Return-Path: <kvm+bounces-46883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 04A71ABA52D
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:30:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E34AF1C00AAD
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8D1D280332;
	Fri, 16 May 2025 21:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0mKDonTb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A4B280A2E
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 21:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747431009; cv=none; b=kAYwD3J68iMkrSaIf9jHQ7bTLQnxyKUAo5vyr6R0Roc5es/LZkpD0i8NqtjuWPRlmeA4UnQaYUe6uHOEZ7HlTVUJUYs//5QJJXnB5OPKqJzymk7oQOWOKBkT5PKr1lULsJILSgdw601AAs1n04F6qcDcqxk2hx7T6Jn0UgVr8Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747431009; c=relaxed/simple;
	bh=xaIvUFnWYSzEf61zEmzdhPL+zDmYyFmwy5vgctv1DT0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YEfW9bwbbPQihTyv17ZSDipHK5QJe7hwmRNiD+xNdOgB6MNhEBgPw2V+9cDbj6nXx3nQNt+GUjVEvbmIGEQ7EIRMi/xzM/BW5UqO7HMqPH96ibKxItHTQf/BdziigiXDZoWAtiROmz+2slIyRvd5xar/5N4aFMxi4ce2AZc/LII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0mKDonTb; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e8425926eso1525723a91.1
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747431007; x=1748035807; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lKGqoll3RbNHREN0eIRYM+wz/B1kXBEjsywi3uO05do=;
        b=0mKDonTbAUE8lWWpi9bJRNxpckz5TYKIgs5XX7KHxClCQUYqcrDYlZSZolvQ6kZ+gm
         Y00ZNWuH7IqhbGlhrsU1FzOnBcPmdBVs1SZJ/7UZJZjX+7+2qSPJP+7A23YPx27U5RQR
         ttYi8oQcDygfzuevtqaXV5t1z0bi3Wl1yF8570f/1wJpgAcAjZMBnKNbPB/9AJpa8Jhe
         lAlPDJKhRwfKqjsIVz7wyhRfisDQXk3oZiuUQQmiccPKpUPrZsxP9an71A0KeJExdrTu
         9sl2+JPIhrtMlQ9e7prc4J9lK6yNdz//m66I/awxFTKTgDh5PwMRo55TfKKvFAJJ1V2B
         Cpdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747431007; x=1748035807;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lKGqoll3RbNHREN0eIRYM+wz/B1kXBEjsywi3uO05do=;
        b=bYS24MF2slVX3EcZxzjYXjFHZLXW1/WgCN3/zS8tgPbvUcU6TF3OKJ0zHw/7T1YeSg
         HeRmT+nPqW7pH1jqiS5Kqvge9a6vTCkLImsEzhmxe2AwVcggneqlvJr5/rpAGFDqDQ5i
         Mtn5+jMkGFroyYhwip5BO4U4xvne3X7V+aqqc1OfXFAlzDNzxScjhcXDbVDVv/SmUOlx
         3w8PKB1VjcVUiIbPJ9/W4gOczSuTXBbjlweZVa2Rt4xLo9Pw7VTATzXtngToT0ASbHBJ
         uUOHeb1nZokOxTCWPHejIY4Gdr9b4XiU/b3euXjQ6LRpxybXvl6zXhnd4KThz6Kn77bF
         T/OQ==
X-Forwarded-Encrypted: i=1; AJvYcCU68Ww6hObALkh9DQtpyhBdaod0z18jg80x2tXgAt7v6v7LdIG36LSVsP55+xjl19JWq7M=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe4t/M/gr7oO8kH8WJIFR17fH2cVNHDi8yj+Efc+GUIviNsOI8
	dfqLOZ8h0uf/Xn/Ru3L9lW4wp6WrBo5fPWfnxhUfygZCwMj3YKdV4Ks0vX7UyE5wn+5SOk+lmeL
	fcBq6IQ==
X-Google-Smtp-Source: AGHT+IH1jrrId9MVi2SBTvtJJTyzh8YzXge4AbpmDoeFZoyCxndzCIEwgvXMwRA0R+s3WnDYdARhk8o3l0Y=
X-Received: from pjyd13.prod.google.com ([2002:a17:90a:dfcd:b0:30e:7f04:f467])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5746:b0:2ee:f687:6acb
 with SMTP id 98e67ed59e1d1-30e830fc346mr5582137a91.13.1747431006822; Fri, 16
 May 2025 14:30:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 14:28:27 -0700
In-Reply-To: <20250516212833.2544737-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516212833.2544737-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516212833.2544737-3-seanjc@google.com>
Subject: [PATCH v2 2/8] drm/gpu: Remove dead checks on wbinvd_on_all_cpus()'s
 return value
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, Zheyun Shen <szy0127@sjtu.edu.cn>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Kevin Loughlin <kevinloughlin@google.com>, 
	Kai Huang <kai.huang@intel.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

Remove the checks and associated pr_err() on wbinvd_on_all_cpus() failure,
as the helper has unconditionally returned 0/success since commit
caa759323c73 ("smp: Remove smp_call_function() and on_each_cpu() return
values").

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/gpu/drm/drm_cache.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_cache.c b/drivers/gpu/drm/drm_cache.c
index 7051c9c909c2..ea1d2d5d2c66 100644
--- a/drivers/gpu/drm/drm_cache.c
+++ b/drivers/gpu/drm/drm_cache.c
@@ -93,8 +93,7 @@ drm_clflush_pages(struct page *pages[], unsigned long num_pages)
 		return;
 	}
 
-	if (wbinvd_on_all_cpus())
-		pr_err("Timed out waiting for cache flush\n");
+	wbinvd_on_all_cpus();
 
 #elif defined(__powerpc__)
 	unsigned long i;
@@ -139,8 +138,7 @@ drm_clflush_sg(struct sg_table *st)
 		return;
 	}
 
-	if (wbinvd_on_all_cpus())
-		pr_err("Timed out waiting for cache flush\n");
+	wbinvd_on_all_cpus();
 #else
 	WARN_ONCE(1, "Architecture has no drm_cache.c support\n");
 #endif
@@ -172,8 +170,7 @@ drm_clflush_virt_range(void *addr, unsigned long length)
 		return;
 	}
 
-	if (wbinvd_on_all_cpus())
-		pr_err("Timed out waiting for cache flush\n");
+	wbinvd_on_all_cpus();
 #else
 	WARN_ONCE(1, "Architecture has no drm_cache.c support\n");
 #endif
-- 
2.49.0.1112.g889b7c5bd8-goog


