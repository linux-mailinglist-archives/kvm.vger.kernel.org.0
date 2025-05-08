Return-Path: <kvm+bounces-45972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 614BDAB032D
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 20:48:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 943241C435DB
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 18:48:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6342428A3E4;
	Thu,  8 May 2025 18:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="axpBAd6j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com [209.85.219.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EDB28851A
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 18:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746730018; cv=none; b=Aels+ilcd5QjwlJWdRiG1umF1//QbFzTMAdhC8Ef10H2K+9BO8SKwwY/9bz9L0M842L4x9MOm7rOA3U02ou124/h+dlx1RmV3ncMqAJSZwbhhhnJ6pUVOOkDtEg7r3BddOQAIQ3hC7SAro5jS+pWDK0zBu3BA9hj6OxxVJtmUUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746730018; c=relaxed/simple;
	bh=XxmjuqNyUSH40nAiJniXWQhl/jBhBznduv5cxq5yeKs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jZGG9+Dy1tqIWHeff44e7GK3j6BYXrNAFypRpj5nsbTdexb2S89PZVUuMnLerk5ajJl68uj67u9jGu5sALq5M2kRGt/xtYfNPNPZCWKWBZefro47lMksjq4hN/Ls4sJNDFx0lbEMM1T5TQ6JVXLIh8NZwF/phABnonR3/ujXjuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=axpBAd6j; arc=none smtp.client-ip=209.85.219.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-qv1-f73.google.com with SMTP id 6a1803df08f44-6f2b4ab462cso14514796d6.3
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 11:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746730015; x=1747334815; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uONc7WAgpVw3vuoHf0vvNHDupNr/S8j5Mtg90jyXV1Y=;
        b=axpBAd6jCM2ZSzMe6E2Ygn7EDSYK+zQ6TViyr7A9GuxcWttA5hYoXeDMh4ZfFx+phV
         v0hOUiEmDDtILH8HOViCQenUO60EoNY8PQRwZRviAyhEZIl7uMnlR8bTL/SAPgxXc5LG
         B6zCQNHIlFvmivpeP/Ikr2UeRfamCLqdc+WRPREI0rBHDIkYmzNSNyLe4oEYcfMzdPe0
         2r/smUugwpIJRnqokef15gGKBqHSjYh3vbO2nTsdkpdqguXH006kyNRmQkhtZCMFfV5G
         bNQkB0wSZgUUB+h+LQdNlzTXAMJ0/hSZr+ji2Eyp4EnrQzrb7HtMEga1HOh0KQqLVBYf
         iamg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746730015; x=1747334815;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uONc7WAgpVw3vuoHf0vvNHDupNr/S8j5Mtg90jyXV1Y=;
        b=UhnlXdoEE0rG6ODa4Kj6+eoa4eS1WxC2257qF8L5RawloIhA+KkI9I//kwdsFSM+C8
         /A9EvD0OPN4I//xGkCiUhMWaw8R5wIPp5eKFRBld7eMmB+OUB0HULhtG6CqmSmYTTwlO
         OGQPo7dTvP01eVuXDNeiZrIaIb3tVEQkBzQxkoXDcMNYveD8II3MWb7qoM8+lU7IJIYp
         SsiOlPOyxVtHsgmFjOZiFLwMvNu0L8oyaGbhKg9QjBf0brbrkMltnXArk0enU7U0zzYd
         +j6gd47mKNk0hUCI64z5vmDUPcDGOu4piKZSVVoxW+sd9QZl5LgcHprJoAPciZJNuOLl
         yHcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQV8P2dtjGilImZz/lY2G9/B/0p3gqb7SLIAOZCeYDueNOe7ZNP+ulIrzW/2KS81OWVU4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyaui+TEAYgZaEq3WNPmRoWB91eL2ktMaWO35OREItL7bgyBwhZ
	XkXZo2HG0q2tGJE8KnaoXTIVPEpIZ9g9ykgFS0oBGSyK4dXeMReuzAqsKbTO5XjSUzthjtdhKBh
	aCnvB6eZmpxbE2L7o6A==
X-Google-Smtp-Source: AGHT+IHCSF3WPWtWHvI8KIBlSC7FdHqt0IH8/ghvMwVjrKFTrdvoF62AI1U/UII2RXUtP23ELsj30SazWDnfhkbF
X-Received: from qvblr6.prod.google.com ([2002:a05:6214:5bc6:b0:6f2:b7f7:aeaf])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:ad4:45ac:0:b0:6f5:3f55:343c with SMTP id 6a1803df08f44-6f6e480e25bmr4365056d6.32.1746730015502;
 Thu, 08 May 2025 11:46:55 -0700 (PDT)
Date: Thu,  8 May 2025 18:46:47 +0000
In-Reply-To: <20250508184649.2576210-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250508184649.2576210-1-jthoughton@google.com>
X-Mailer: git-send-email 2.49.0.1015.ga840276032-goog
Message-ID: <20250508184649.2576210-7-jthoughton@google.com>
Subject: [PATCH v4 6/7] KVM: selftests: Build and link selftests/cgroup/lib
 into KVM selftests
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, mkoutny@suse.com, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Yu Zhao <yuzhao@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

libcgroup.o is built separately from KVM selftests and cgroup selftests,
so different compiler flags used by the different selftests will not
conflict with each other.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index f62b0a5aba35a..bea746878bcaa 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -204,6 +204,7 @@ OVERRIDE_TARGETS = 1
 # importantly defines, i.e. overwrites, $(CC) (unless `make -e` or `make CC=`,
 # which causes the environment variable to override the makefile).
 include ../lib.mk
+include ../cgroup/lib/libcgroup.mk
 
 INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
@@ -257,7 +258,7 @@ LIBKVM_S := $(filter %.S,$(LIBKVM))
 LIBKVM_C_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_C))
 LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
 LIBKVM_STRING_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_STRING))
-LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ)
+LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ) $(LIBCGROUP_O)
 SPLIT_TEST_GEN_PROGS := $(patsubst %, $(OUTPUT)/%, $(SPLIT_TESTS))
 SPLIT_TEST_GEN_OBJ := $(patsubst %, $(OUTPUT)/$(ARCH)/%.o, $(SPLIT_TESTS))
 
-- 
2.49.0.1015.ga840276032-goog


