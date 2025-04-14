Return-Path: <kvm+bounces-43277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B8AB2A88CCA
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 22:10:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C648417B8B9
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 20:10:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C77381EB1AE;
	Mon, 14 Apr 2025 20:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CN+Adv6X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f73.google.com (mail-ua1-f73.google.com [209.85.222.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156121DF723
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 20:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744661380; cv=none; b=Ka8gQtn05+piuakYEsdX8zQ7AS+Oiy1UMavD19bidxnwHaYRGgIjSFtj3dYCREbdUeTkVmC8+ljD3gWg9o8DDK2Yaz7WkyyoQwgzQHHFEPQJMjrhqJzGDx3Oc6CsFTidcCZ6MASSadcP61VltwhldcsgvNdbP9RXEHa3cev8E88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744661380; c=relaxed/simple;
	bh=x6q1xZ3yBUeYcvd83AJGvAMjSYwBLFzBm1ig+KWei+E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IblE3jAAa5JE8cCPLibXyS3XWCjHTb4x5rT7yfEfuRjDTr9G/TIDrClF1iwxbd2NHPtsbde2kw3+oUgM75bgHqhFVDXpJ+DzUvUcrjBvaixbchsPb3OUSEst6pbv5xgu73a/brwNugUtIWdG5APktSknAqF7Ws5Zfr1FyOqtBK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CN+Adv6X; arc=none smtp.client-ip=209.85.222.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-ua1-f73.google.com with SMTP id a1e0cc1a2514c-86d383c48ccso1322638241.3
        for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 13:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744661378; x=1745266178; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yShiSNlbRrsjewo8erMpkmzkSvjH2QZkd/vX1jbbzhI=;
        b=CN+Adv6X0n7ch09DqGrGklfsFTNcD6Rw9lFX6mr5zfSmoYKiQz85MDhD9s4uW+MEFh
         pLHhcDqh5ZIyBxyN1aB6bR5Rgnb3bL3vQBwkaguURaEFwYPdFunoLeUOo4maAx/Z8Txk
         YlFMsnM9NdwB/zyna+77mMA+Z/obH1f0f1JxgiWVldvrBNWJWwvoiwhuIQ1TrHIBPhiD
         YuY2P7voLpKW/7WF3WyhNN8QQHFYi1zyBNpXDa8LNpOA1UigS8TIquvbyyjB1jpegzqg
         yh1Q0B4DX5ZQovivLouDWNpusZz1Th/h2IhhYVv2l9Pny+V5/cIjXEjqF07Zgunueshu
         hcWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744661378; x=1745266178;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yShiSNlbRrsjewo8erMpkmzkSvjH2QZkd/vX1jbbzhI=;
        b=PiCuoK50RH8sG3GEqChtolhMNxBEzQu9ak49cLKaL34rhLLdOO81qOr55YprSfa9Au
         m+oWJcKlknHle280Rq9tqcARMqUrIYENhhnQRV+JnIguOQKfrwVlxcr0/JJYT7VOgNtO
         Fdca2jI564HQ9IxHn+CGXkXybi0ey+9N1pTC10UP8cy4X6TssAwLxjjnE3kqGTh0hjcI
         gxoar873+n1n3OH4PLZoHArABlIExgOoXdM7ngrvi5m6GE7rhtI+mlfePIGE6EzxCXqW
         uXeh6YDHTLJQpDhzkKpkA1GbFBsRF3YesB2ECiWbjthTA8AJtwppZZwNCBtabB3+xYdm
         1uaA==
X-Forwarded-Encrypted: i=1; AJvYcCWcnQ9BbXclPBBkpHkmb7bFZ1r/i52rOYhesayL7RnYdTlkhArtiKNrIJtjywIyMXM9uk8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOB7LPl9PuC+wZf4DevtJnGHSVUTajTxGeeeXLmS4uxONql3ij
	42U6QqrAm3gjYaDuqtopweOg50ppgRZchQ3WtX4R3WmCPTdE1NFK2OWg006LzrUXlWCv9Xa9RBQ
	7wiU0n72IC1rVuAs7DQ==
X-Google-Smtp-Source: AGHT+IFWx4KpMIbxFpAwRHbcSPjOf45XcTuJLvHUktQ+xHXKdwuwHIuf1RL64vv5UDAQCwn8mu36HAZXiw5xxVhZ
X-Received: from vsbia12.prod.google.com ([2002:a05:6102:4b0c:b0:4c1:8cb2:18cb])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:5247:b0:4bb:eb4a:f9f2 with SMTP id ada2fe7eead31-4c9e4eec0damr9244631137.9.1744661377900;
 Mon, 14 Apr 2025 13:09:37 -0700 (PDT)
Date: Mon, 14 Apr 2025 20:09:28 +0000
In-Reply-To: <20250414200929.3098202-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250414200929.3098202-1-jthoughton@google.com>
X-Mailer: git-send-email 2.49.0.604.gff1f9ca942-goog
Message-ID: <20250414200929.3098202-5-jthoughton@google.com>
Subject: [PATCH v3 4/5] KVM: selftests: Build and link selftests/cgroup/lib
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
2.49.0.604.gff1f9ca942-goog


