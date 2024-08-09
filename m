Return-Path: <kvm+bounces-23781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 533CB94D78F
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:45:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85F801C2278E
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:45:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4CA016DC1D;
	Fri,  9 Aug 2024 19:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4NU4x8JE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8610A16D4F5
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723232630; cv=none; b=r5SZdmUbbWpRsI5TFK6jPKye5WOva8vFZvh2sJVPR29wzVbf46UQIpZrbDhvHT4NHc0UB2YrvZ0jbilO2B26U+7/VJfRSQRANXLqnSZPBH9txfEs5IrjmtIKi+zI2lrc0LhDRK4Qva6COdLH4gnhhjvphAfDb2DXPYs9kMUdMIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723232630; c=relaxed/simple;
	bh=LVFq/UF8yA/HGcn66G7X9qPCu7tUDBlRE4IGgs3dGtA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=abkEfyapnOwTL2UZ9ecf2p51u+US9Vsxq8iBvkq0EElKc2mpfIOY22pXTPcyPFWJymsEwXBEs53+AxHKfWQciKGJcLnljkWprfcV+PHoc3ujt4jzvQCL2gz17oJMti2B7pvUxD6hs7xDAkwMzq84k/CPnofLd4XI0BUMNd4/cx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4NU4x8JE; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fd5fe96cfeso24956335ad.0
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723232629; x=1723837429; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SWkGT60Gokzaw7JUaOakLjtXVj6aQ6BddU74vUMlOq4=;
        b=4NU4x8JERO+C70hLXuiNZ493SWVQUvaPJSy0P/sZKZUWmW+DkZeJWFA/nX7Axu2bxF
         F6KJs7VmmEJUAwxuJavd4YOQii+X7qWhRew3ld0Xewk/0NUlXi/8snlu1UI2SgbVneOz
         6ezwWRyJjGuDw4Tn7wR+q9FgaHAiOtP5UxW72NWDIfr//rLW6QA4Q+NjOUbmq9NQrgC6
         dHSePuhHidAyoeNkAxw1wybz/fA/Q+zJoUGQeqNX/nYkgGm+acNKooqQAegVc4e1zTy4
         LOH60kpWare2laFB7anvkw++H3Y1AX+sYhIVUA68QGxPOpoWGdTOKYQ5q/KgDtv7nr0d
         0M2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723232629; x=1723837429;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SWkGT60Gokzaw7JUaOakLjtXVj6aQ6BddU74vUMlOq4=;
        b=Te7BZn9DNq9oiLFU3issrgtvU+VpSrNMctZRAdM3kkJCF3A/YeD+DseLOBfxPz9NqN
         CANiZX2RwStX2F/rHJbUp+LgCXEPaREeYhllvWBik4h6aGdG0AY71KeqlDBb1XQytsPP
         0bnbe9q2KIlY4mcdW4FJ2aaOLHpoOA+3fjmssHWe74KaGgSerea0Y7uPgVhZP+9DLD++
         FREYG2mdxjDraKSd1TuVBRG105cGa7PK0SJYEl4/MhJd389jduXXZi6v4SAt2AhI9xj5
         xy/A6q87wwYQM5wRm3W93OolF9aNHx2UbQlD8/9QXRsjrP4qcVErDp4ahXHuTe/X//d6
         9hWA==
X-Gm-Message-State: AOJu0Yz782JV8TcLJwYLkrImp195qFwu9r/yQuGZQADpV5YoBE5LBB9z
	Q0qUfL9780yHKFbcjCL+ChfgH+a1Dg+zptao91rkbOfmUd9uZ22N8d/kx5TkjyocjRaMO8uKJ4I
	COQ==
X-Google-Smtp-Source: AGHT+IFmZCXNvXRh9QF9VYGRkhlcjb88/DI8HKkyVC2+5y45yUvR2nURAEut79pR9l0FdvfAx89nEJfuzPI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d482:b0:200:62bb:e22c with SMTP id
 d9443c01a7336-200ae5d8874mr822625ad.12.1723232628645; Fri, 09 Aug 2024
 12:43:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:43:17 -0700
In-Reply-To: <20240809194335.1726916-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809194335.1726916-6-seanjc@google.com>
Subject: [PATCH 05/22] KVM: selftests: Enable mmu_stress_test on arm64
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Enable the mmu_stress_test on arm64.  The intent was to enable the test
across all architectures when it was first added, but a few goofs made it
unrunnable on !x86.  Now that those goofs are fixed, at least for arm64,
enable the test.

Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index cc25f19b62da..4198df29503f 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -174,6 +174,7 @@ TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_aarch64 += kvm_page_table_test
 TEST_GEN_PROGS_aarch64 += memslot_modification_stress_test
 TEST_GEN_PROGS_aarch64 += memslot_perf_test
+TEST_GEN_PROGS_aarch64 += mmu_stress_test
 TEST_GEN_PROGS_aarch64 += rseq_test
 TEST_GEN_PROGS_aarch64 += set_memory_region_test
 TEST_GEN_PROGS_aarch64 += steal_time
-- 
2.46.0.76.ge559c4bf1a-goog


