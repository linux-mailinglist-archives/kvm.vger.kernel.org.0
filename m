Return-Path: <kvm+bounces-18581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 109328D7552
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2024 14:26:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCD6A281E0B
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2024 12:26:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4255E3A1DC;
	Sun,  2 Jun 2024 12:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TTVCmb9p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3792A38394
	for <kvm@vger.kernel.org>; Sun,  2 Jun 2024 12:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717331171; cv=none; b=uBRXWiAfqgybl+EGt/cnfRRCjb//VlSxzQ5o4CgFtmGUzwt8QaaBMnRATPxLutXazmW1gqx+V0tosOE21a0e/L7MPLQLYkx6Uc4MoIbszNx1ZcsbS0xRpPxV99Hk9KbQwTRP7eVVhi/ywIMIS6xr2rlgUtQg9eobYPJu+7dGqWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717331171; c=relaxed/simple;
	bh=NnCCxGtfqAS6Di79imZop7ntNX5zazZtpYFYg3MrJdM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NpMRgD4iAr+YH6RZfDfO257XVGaVG15YENmDT4t+HOwWlnQ2x+hcvGSE+Rla+z4S9bP8lGr/6Wb/5tQkPn4nCV4At4bxDiAwoOlJnZR8SmoSsU8i/rYMmMNQzv6IdPPpL+epy2/uIWZAzQXDIgHTfSoFGCr5GbYdbi8q6ks4f7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TTVCmb9p; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1f661450af5so5817135ad.3
        for <kvm@vger.kernel.org>; Sun, 02 Jun 2024 05:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717331169; x=1717935969; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PJoB4HYVwuB6cyjM+/u46B3SgOikV+0V6UNV7IIxS4Y=;
        b=TTVCmb9pueJ7j9JlpBeRANpX2iJnvYRi0wlWfOLUWB4rqAo9dGjh7EArrjEOLOXWoC
         IZwl5gEZhR3/VZygv5DbV0mOmPCRGTpSPWC7K9SEo2a6HHUhFk+cUpGF9OoDlwnVy0/r
         HvAqMzgtLmUjeqc6CGkUQ+LRKJScG7rnzhJtz/KuqmLuQzNyGTViFo9MZLVHlfgH4ADk
         1hPx82hnLKUTvvNEtngPhcuKK+xWOvubVyC52MoFyY30IUt9DKcVB7p98P6od1iMNPUf
         +dvETfdGbgasO7uvcIwOumQaLDHbjEOoMjitPGT5OcAhEUScqcAjPjbr7Kif9Z7oWZzx
         yHRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717331169; x=1717935969;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PJoB4HYVwuB6cyjM+/u46B3SgOikV+0V6UNV7IIxS4Y=;
        b=S2P7PN2jE5pU+Vfsd7FHqqj/xhJCJVMkBNnVPDaErZSMw9gvBQqSXVOhJl9TlAOSpK
         PReF5TAJF2hov65ECqlGm8fWJ1A0p/In1EGRZX8aKOhjZh6+X2OFFPBvv3Uvn+wKDt+0
         O1y9uLR8pqoDqD5xzOmhjE/15hzwDDagsBljcBcIKmoYqKxZvRU8BjG1m0AR7jGHr5Sj
         W5L3GsIhX9zVLQxFfZWl6V3Rz5cH+z6rNtJ55AAeKUZr6ttTVgRVBlojSj4qd4JAslYU
         YZVa8kkwrfnMNktpUglfmX3SRSJ+8BO14sbDEVCkw4tVAfmghP1bXLcSxASlgJzevqtF
         Og1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWPEbMZsx0LExDWEVz8y7TP4f/V+0Jvcrpd8dWKGkEGYocZYU9sf3owToakQhL2fKGAaXVbOmAYwO4vaFZuEO3fLYK1
X-Gm-Message-State: AOJu0YxmEYkPPU+BDCynFGiuUVq5LwrvWcS465JGVSZMRXaRAK0LhYmC
	G/l74OmnWkJ/n2/k/k77JCMnQNgp3KLL+JNZ0+iuAwSVUwCHkMdS
X-Google-Smtp-Source: AGHT+IHCK9Rb4hzA3jSYGxYdvup1nb/7vvknM27CAp0wmMOC4Np5rCIqWbabkD9e9KFWEpZiORQZWA==
X-Received: by 2002:a17:902:dac3:b0:1f6:6c9b:b22c with SMTP id d9443c01a7336-1f66c9bb3femr13919025ad.65.1717331169321;
        Sun, 02 Jun 2024 05:26:09 -0700 (PDT)
Received: from wheely.local0.net (110-175-65-7.tpgi.com.au. [110.175.65.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6703f7673sm7834145ad.210.2024.06.02.05.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jun 2024 05:26:08 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 0/4] powerpc fix and misc docs/build/CI improvements
Date: Sun,  2 Jun 2024 22:25:54 +1000
Message-ID: <20240602122559.118345-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is some fixes and odd bits before I was going to resubmit the
remains of the powerpc series.

Patch 1 is a silly rebase bug. I thought I must have missed a warning
in the build noise, but no gcc just doesn't warn for string literal to
bool conversion.

Patch 2 is the doc fix updated according to feedback from Thomas
(main change, enumerate the other special groups).

Patch 3 is a quick hack to make build warnings more obvious. Thoughts?
Results can be seen here
https://gitlab.com/npiggin/kvm-unit-tests/-/pipelines/1314895857

Patch 4, after debugging something with CI, it doesn't seem to save the
test logs on failure. I can't drive gitlab CI very well but this seemed
to fix it.

Thanks,
Nick

Nicholas Piggin (4):
  powerpc/sprs: Fix report_kfail call
  doc: update unittests doc
  build: Make build output pretty
  gitlab-ci: Always save artifacts

 .gitlab-ci.yml          |  5 +++++
 Makefile                | 14 ++++++++++++++
 arm/Makefile.common     |  7 +++++++
 docs/unittests.txt      | 11 ++++++++---
 powerpc/Makefile.common | 11 +++++++----
 powerpc/sprs.c          |  2 +-
 riscv/Makefile          |  5 +++++
 s390x/Makefile          | 18 +++++++++++++++++-
 scripts/mkstandalone.sh |  2 +-
 x86/Makefile.common     |  5 +++++
 10 files changed, 70 insertions(+), 10 deletions(-)

-- 
2.43.0


