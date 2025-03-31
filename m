Return-Path: <kvm+bounces-42272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44963A7702A
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 23:31:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FE5F3AC634
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 21:31:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38A9A21D5BC;
	Mon, 31 Mar 2025 21:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FTL77fvC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f201.google.com (mail-vk1-f201.google.com [209.85.221.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C397121CA17
	for <kvm@vger.kernel.org>; Mon, 31 Mar 2025 21:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743456637; cv=none; b=RFxw4T0cHHEAXCvq369io6qL+KgSIxAp1BAf8IiCrsEWssTPcKF+/GdFBOE2gS0G9gL5pHijasgj9CeR8GcbTQupEwDhe/8zTbRCSq7u9Q3aG07XpbdVmfPHqml1ctRElhO9KSmLSsyJpcfsj6V0EboNDtM6AqxO6zpUxH5Kr5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743456637; c=relaxed/simple;
	bh=DlDaNBmiP+Lmsrd4wjzooOyHQDU6I4mrrw8YnqHQ8qs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q4euzHGSzXSiHyq+eadarjOGF7hxB0CaNRSH6kjJ4MKHMsgyFIjGZG40y/zO47s3vfzRSqGAbPIA8kq/ehtRMtTfcx4LvNAEr3hRStoWxABUdKbE+Fhj1hSGEYMYrdMsWFC9nwTKtBcrMA2IEvQyL24D/2CqbP74v0w5glyoozk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FTL77fvC; arc=none smtp.client-ip=209.85.221.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vk1-f201.google.com with SMTP id 71dfb90a1353d-523f7c7e061so3511015e0c.0
        for <kvm@vger.kernel.org>; Mon, 31 Mar 2025 14:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743456634; x=1744061434; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AMmGEtr9mP14oGMDJzQtzY0m4v3Phg9hGuUxD5cZ2iA=;
        b=FTL77fvCQVtYAynoxFLfrCKwL2TWhbtip/uZrh7MwoQwZHIe0OcufFIVKRXD8QSHH+
         MXlDo994VrUlcxIPN6ZPz+K0ozVg/bQwBhtUQ4kSXH3MZTFY0JCmGScoHbzp5nU4QJGx
         yabGCM/5+cOZTFggRExme76lJWWJ0erUuEwZJ0KqFIpc58H6gAJ1L7rSOR7YmDSzp8vm
         lK8sSJIoazEirB5k5SNdZ6CVXTh+17irrstWMJ24D7DdkC8V0hha/vP7PFY6TzSeUj8C
         +r6u11tZ2AX7dksyADFy93cxn2v2rC2k1fWRgYMw2daiYV7ZHYuEAfq9i2XRifimB369
         ofiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743456634; x=1744061434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AMmGEtr9mP14oGMDJzQtzY0m4v3Phg9hGuUxD5cZ2iA=;
        b=JTiLsSLQUcy8thpU7ANjgraffZPZA4kQyPRQ1i0yEHACLd/0wbsxs4S/SkQ5kP66oA
         oUt2O+HHNUiOxJgsec53VTfNNXOaHYRKA+6MaKkjfQ+Igeimil29E2ByrbGniWQ9bcAl
         gpvmdlX2SbqmvXSnoQcg6qrUlfHeX5ufK8SY9V+QtePEFJG/Eq78MVevnJaEpWAG0+1V
         JiX/yS73H4BoBQs8SODZipBxfUWXt5eBFtGjrqn3cHLQyLUt6mNvg244R0eK3vMEMvpX
         JWkOithh5MOrNogQ7zHRQR3yoDQ69tAbxN/AUKprY11/Fnx9YQtrx7C2yHgx4A7b293X
         kPpw==
X-Forwarded-Encrypted: i=1; AJvYcCWMhdFBFwKQOYTWtDOoc+C59KacAKXJoHr8N717UeaEDl+hiAZVwkygEilR4ZPMiyWU9/s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIJunFkOmSbdXMbi6KSv18msgAndtHd2paPKYxeDPbUd6IN2RX
	T/WnUdijrgF3a6zIC/hxRw9t8tvSgAhnd8YID7uwRsMVk75YwH7sUORS5hn3wCYlIFA+ny4hPZv
	ObPRu6GzUxqNjK1h2Sg==
X-Google-Smtp-Source: AGHT+IHgagkSKWGlDovr5gDvy/QEUbGDo/w32g+pQ7uHEVkF+t8NIV8URx2AUHB2qjSBJFbxSuIK8xNpCMDSjF+R
X-Received: from vkbes13.prod.google.com ([2002:a05:6122:1b8d:b0:523:79d3:7e63])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6122:3c8b:b0:523:7c70:bc9c with SMTP id 71dfb90a1353d-5261d3ca2b3mr7267971e0c.5.1743456634617;
 Mon, 31 Mar 2025 14:30:34 -0700 (PDT)
Date: Mon, 31 Mar 2025 21:30:24 +0000
In-Reply-To: <20250331213025.3602082-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250331213025.3602082-1-jthoughton@google.com>
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250331213025.3602082-5-jthoughton@google.com>
Subject: [PATCH v2 4/5] KVM: selftests: Build and link selftests/cgroup/lib
 into KVM selftests
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, mkoutny@suse.com, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Yu Zhao <yuzhao@google.com>, 
	James Houghton <jthoughton@google.com>, cgroups@vger.kernel.org, 
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
index f773f8f992494..c86a680f52b28 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -219,6 +219,7 @@ OVERRIDE_TARGETS = 1
 # importantly defines, i.e. overwrites, $(CC) (unless `make -e` or `make CC=`,
 # which causes the environment variable to override the makefile).
 include ../lib.mk
+include ../cgroup/lib/libcgroup.mk
 
 INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
@@ -272,7 +273,7 @@ LIBKVM_S := $(filter %.S,$(LIBKVM))
 LIBKVM_C_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_C))
 LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
 LIBKVM_STRING_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_STRING))
-LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ)
+LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ) $(LIBCGROUP_O)
 SPLIT_TEST_GEN_PROGS := $(patsubst %, $(OUTPUT)/%, $(SPLIT_TESTS))
 SPLIT_TEST_GEN_OBJ := $(patsubst %, $(OUTPUT)/$(ARCH)/%.o, $(SPLIT_TESTS))
 
-- 
2.49.0.472.ge94155a9ec-goog


