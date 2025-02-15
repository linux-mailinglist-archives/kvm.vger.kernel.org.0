Return-Path: <kvm+bounces-38256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D7B52A36B12
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:36:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F78116BDC4
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C785314B087;
	Sat, 15 Feb 2025 01:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hmF/hihk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB84D13DDAE
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583403; cv=none; b=i8k4ACUgx0gUrqMTHAkJ0dLz/CVf2pDublWfRjSf/ylRkhrxeH/kMIkAcJvYs5gAFbBCcwsPfRDM55cf03BJK+JNqj/U44r1Q1gWqkXSLpXpcvEWGSYcS3MDDlr51DKrGb95ormXJEGj3JZO2+rafCZBMxR5MaqThgpN2iddfFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583403; c=relaxed/simple;
	bh=sjQz7r745iC886HhwEYjCsxZJl0omSlxWsVmDARJsAE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EaZD+GoF8wCC+k3B570aF9WztLllxPZGPQamNvceqG2q8uwl0ZnErkiU0AdQ0v5aJwRplmdUnp2REQCVcKFBS6dTLSdvcHmbMtlDYEQrUbB2SXXprHo2yWWW13rcVblxzF8JNwj4ijObpVkY8JEbqmgd1tne5qKxLmwyuIMe4BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hmF/hihk; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc0bc05afdso5258125a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583401; x=1740188201; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jUeoXH6J01mYEvbEbzN7QSwXkoI7mAj/SkiqxL7lhfc=;
        b=hmF/hihkwd/EGXUUZGBaWs9HiaYQT12Vw7O9ipOBpwMJHD4U5Ij20teSFxI95V6rYe
         xPV7iarQXn+4gam05Z//C0tv+8n4VY6jgqUSc9AaPW0tII+QWbc4QzwsBW1Db7R/PzaO
         NkVjIpp3HjebEo4Jj2d53LHS+KYwTLLTDibk7sUZu+5FCVExrJ0B7IndtDltD2wwZ1s4
         4ygwypfrue0s2jpBjDEV4hMwGz/fsIqzZlBhS2dR61m33cBCPl+s18ZbJCpkrK3izWxa
         spyO6f4wmVT75L8SqxDzLiYBkjnpmPKVK6giCMusZqNR04M52Sm/QUbZwKFEpegpXmDz
         Y6Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583401; x=1740188201;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jUeoXH6J01mYEvbEbzN7QSwXkoI7mAj/SkiqxL7lhfc=;
        b=Rw/ErmpCi2zVMdnqdLfJkLh9iQ5jlbSrmw+kbi/ucDXdPCOGXO4k7PSe9sl5QkCRnR
         cbXeSeNam9QRx2bf3UXXrNVnEOJINAhXVViZhmmBYYGjJqwvNshbHOuqgGH6khCnJ0iG
         A47+IGolMQ+RVdU0i4lzj2PtHk7Z6/d7AnK1PdoKknZoAMBdcIb2bme4iC1CQKYbIIDK
         tqYSGHF9h4RiuFwmk7aPZi+8niL96nhjPcr01pG5x9FtbDf0KP570TiRV4J8/zT1wOd8
         sjcK0VFxOcrAalS+XzM4R0nrd6JQJW/MWsmKb9u2w9f/2VIxmiebZDYYNg17riBO6X85
         6xuQ==
X-Gm-Message-State: AOJu0YzfNveF3PBXu+y/oKhVz6pg1IPYHa82jyeDGrI3XYQrGAT4jXgO
	mmswdeV7Ff/vKX8PrB/7mLzP9rE02THD3p2a6fYOkNOPic3KkQuC5XjVELjU4KeEvzdU9ydxCPT
	5KA==
X-Google-Smtp-Source: AGHT+IFWzCgGaO0araLKEcWUe2cYXKfUxM96y65+ZuXnIeOg4QBjEZp0THdweqUiTfviPVRn8JOjvrOPJFU=
X-Received: from pjbsc13.prod.google.com ([2002:a17:90b:510d:b0:2fc:2f33:e07d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2789:b0:2ee:f80c:6889
 with SMTP id 98e67ed59e1d1-2fc4116bc28mr2076571a91.33.1739583401259; Fri, 14
 Feb 2025 17:36:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:36:19 -0800
In-Reply-To: <20250215013636.1214612-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013636.1214612-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013636.1214612-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v7 02/18] x86: pmu: Remove blank line and
 redundant space
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

code style changes.

Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index ce9abbe1..865dbe67 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -205,8 +205,7 @@ static noinline void __measure(pmu_counter_t *evt, uint64_t count)
 static bool verify_event(uint64_t count, struct pmu_event *e)
 {
 	// printf("%d <= %ld <= %d\n", e->min, count, e->max);
-	return count >= e->min  && count <= e->max;
-
+	return count >= e->min && count <= e->max;
 }
 
 static bool verify_counter(pmu_counter_t *cnt)
-- 
2.48.1.601.g30ceb7b040-goog


