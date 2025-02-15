Return-Path: <kvm+bounces-38255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DF7BA36B15
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:37:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEB263B243D
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B66B1442F2;
	Sat, 15 Feb 2025 01:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y9zA2j6O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1382638DE3
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583401; cv=none; b=XP1ugilMenDpYvk78H/PWO6YiqiMFAdVtg9V6qoj1LHFlZ5XrdKtQbM4cI9BA04ujQxvQXq7KmVvMBgwH4P7tfip5OxEuZTb5qidj2VTzkckYGzh40wEM0Lu3zCED37gF1hA7QFogMbSfoiAB+neTdPO6z42YFA5F2lVjWmZeAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583401; c=relaxed/simple;
	bh=gC55Rn0QCScvbLdX9GUMbAZaL3gXRtlxoZ6aHYyAUYU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MWfU/uhdY6PDhEM8NgPNyYJCflHk0GVzfoapkhVK3XJR1i1EtNPnmerwuMyn9wVVmMCTIBuU5SiqrHZdzfryt3bbhH/0Owv6yJObjbAxB5sxpr5lJBjzSNav9yWKIiEisx4gvF5EL5I3hNRSVWw5ZIGKOeuTZtT9YRUdDYX+uqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y9zA2j6O; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa514fa6c7so6360816a91.3
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583399; x=1740188199; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ArY4hGYgC1pxKO2UIP9bmr5ON9KNT/VwgyhK+65WX6w=;
        b=Y9zA2j6O40WooGoY5teiicV4UhEEgejN20Hh5qilDFMRPqIZOIEkpFfsd8HcOnaqBf
         NGWS9Prh4Kri+yByV4+q/QHs2IVfiUdwcL/s0FGqoJxAacIhFkI8FJEQJxqDRAHmvLKu
         XYMwjobxfgCYJmNudc3BfkkVXru99WCIYzLFjcwZTKGyiq/Z3ICxCb+5klWLAgB8aRtC
         XtzmL2eFOrtNGjfLaVIU9ceSb2Kxttnkai3s2GXNBDJhpvvmFNspKX2ZTVVcGBth07pS
         DmUx2n37ucJa5QiNpS+u2qwu7FwEPjSMfYOVNx4q03hlvCMGMmo+YNtynYvXCgQrL0XA
         IQzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583399; x=1740188199;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ArY4hGYgC1pxKO2UIP9bmr5ON9KNT/VwgyhK+65WX6w=;
        b=Yd0rBa8mZnhaPBGxYaP4jOfyubwdN1+GixrXMJgpFBm7ROWGiY4msxhT3rVLnW7oJ6
         9hhmXEjukqvb0HJw29XPI6Zanxu7PrfJA1RYktdJSxiOdSCfgP8WOLnGN4ucCAuXz+cz
         hQWFiUcoJuOqoi15rqSKOgmsKaj3kv50qejvAF8dBC+KeGl3psuv7e3VZI828zowsiAx
         WJ8wDfDDTP2zyCDXba++5ybQpa2Yzy9ZEI//o03ojUsjX/REPfucNtoQUJTYwOPZ8ybJ
         17pxzoqWnOUg+wJ4dh2NTdcr5hxRze1g17kk/XxVF2YLVpx3tB9ykTIebrLeZUFv1ypB
         Ir6g==
X-Gm-Message-State: AOJu0Yx+CSHY0Mpp5d54mLtpRVllPXMkcFMqeQkRhGiHw3eFWIsUNn8R
	qFTN3UIILYAjQM0SV+nQt5f87XU3eoW/xgMtbUg2MPVAzbCyrcCALqSzRlFVliEybfrpuUL+sj8
	6Ew==
X-Google-Smtp-Source: AGHT+IFoaWfBBnKGIVP1BaHnGQ98kUXJrVdhtWU+JyElpIpEys10qlRGXsOQKNPI9GkQ3+W+G5IuPWoBugE=
X-Received: from pjf8.prod.google.com ([2002:a17:90b:3f08:b0:2fa:284f:adae])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e4f:b0:2fa:13e9:8cb0
 with SMTP id 98e67ed59e1d1-2fc41153fe0mr1705785a91.31.1739583399444; Fri, 14
 Feb 2025 17:36:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:36:18 -0800
In-Reply-To: <20250215013636.1214612-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013636.1214612-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013636.1214612-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v7 01/18] x86: pmu: Remove duplicate code in pmu_init()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Xiong Zhang <xiong.y.zhang@intel.com>

There are totally same code in pmu_init() helper, remove the duplicate
code.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/pmu.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index 0f2afd65..d06e9455 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -16,11 +16,6 @@ void pmu_init(void)
 			pmu.fixed_counter_width = (cpuid_10.d >> 5) & 0xff;
 		}
 
-		if (pmu.version > 1) {
-			pmu.nr_fixed_counters = cpuid_10.d & 0x1f;
-			pmu.fixed_counter_width = (cpuid_10.d >> 5) & 0xff;
-		}
-
 		pmu.nr_gp_counters = (cpuid_10.a >> 8) & 0xff;
 		pmu.gp_counter_width = (cpuid_10.a >> 16) & 0xff;
 		pmu.gp_counter_mask_length = (cpuid_10.a >> 24) & 0xff;
-- 
2.48.1.601.g30ceb7b040-goog


