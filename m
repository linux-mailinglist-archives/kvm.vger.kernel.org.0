Return-Path: <kvm+bounces-20424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E6D0915A79
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 01:31:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 096AC284F84
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 23:31:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9EBD1ABCBC;
	Mon, 24 Jun 2024 23:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FaeCaxlC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A066D1A2C3A
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 23:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719271760; cv=none; b=EGjgmzxkILxcupY75GdCUihIWqUmnaA7SpfLME+JsJsF9boRvyLTVrGjrnoTZtUZJPu3zCvOYGu/TxWcn/lCCwOI9ykFFLXx9opaxy4kCwrEbuIRitPyKwi1lI1qn/7oThmp3fmVqX6MHDBb1mjf0tsfmVweiQC9fHPE57B4b5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719271760; c=relaxed/simple;
	bh=pWNExpY/MivG68WT1LbkW1rwtOz84qP9M9G1/+5QF7s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uZS3+dSA6eQlqQhQYPxToXjeP/FOkGgeLjvxBsAI45g9KbefxSffmK/z7o3xX8pHkP3bqeJkAOtHlW3gOdaNZ+1cgTJugh0RDeH7Q9tezkTtJDofCoad4qV/0isz3eGFYd9sPm0f+g3fa68QNKddTz115w3Elg/UMsl1gmNiLbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FaeCaxlC; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-71a56a55252so4511947a12.3
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 16:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719271758; x=1719876558; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FdSDNYLWJB5rZ7zGFIgNmO8T8+rT5KpGbZz7pQfLV3k=;
        b=FaeCaxlCfye7b5YLfuZ6SbYpIxNGujeqgCBDFc5s4U/6+zOC5pLN2lon52z874yWny
         b3YsKNt+DS7jKNo3qE0oPx8cfvGA1dFA9+75IQ/KraBiQqJQn+g2WPV3uIyG+CW3i3wq
         Ag2dQOckgcpEgCotsJksqZ2oxkZEf5Gsby9jfVDqOfeW1y9prsQGAoboynpeE7BT7eUC
         38KmFZ+g2hdGpekag+3+St/zWMRof322lMbzz5KdzKVgJO2cuXmWHgUkj/jfeVSFy1xc
         slZIkZUb81Zc328fyiEfgpC538fEev3eEixo7+iDdvWzSaz5SWASsR0GwOcc4N+vHDZK
         PrIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719271758; x=1719876558;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FdSDNYLWJB5rZ7zGFIgNmO8T8+rT5KpGbZz7pQfLV3k=;
        b=IwqQC+jk0UK3a8Cyp6mbcnJ/ZtI7A/4ApAeHRLZvxP2d7TF1RnBx555LqAXZ8qcpti
         R1nPpySjHWkBJFsEVgK7iG0WfhMI3ziqdCQobZo56f8g5hRhlSJeXlCGDNQcbPqGVkFD
         Iz+7YvufEOZhzuY1mu/c8MkbB81JNqhq3tM2+IbQn9jK3TCUEx6W0RxFrdlLdiLaOvCw
         JYylmkP4mvF2t5MpsVTyUDlOJhm+Hfo1iwf22j8CrS//y8Ghji1QogHICIU7gKbd1dY8
         /CtnUxyQG3HCkXznMu7RnTxoZG4N/ODDYwRuLfE4gwL/pAHTm1v3KpGQJ3ZGrbfCHwtM
         sS7Q==
X-Forwarded-Encrypted: i=1; AJvYcCX8lRhb7Vwez768JZfuCednIIqKHvy2dM99Fan4eJNJyUrYM5P1zsiqIDYr6dT99vAmR7q7aOib2SPCpDZHfYkHjzmA
X-Gm-Message-State: AOJu0Yzo/J8rWosmJy+uglztSidQfwFmpUqX5B4zRZqskv3CkD1ycRv6
	rK9AqxF594MZfWTLd1AecMUU+Hf6UYOZjrm6EY+h6WWh7yQaVC4LkODvP2JxAJKLsUOWLHMO/3L
	8Fw==
X-Google-Smtp-Source: AGHT+IGHwhaq3SpDsE/oDwZF6fJSdoqdJu1qur3CUdYhennVxCDTZQrp6vr5HFtn29b7yImBHRAcKRn1tcs=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a63:3d43:0:b0:71a:1f6f:1d0f with SMTP id
 41be03b00d2f7-71b5c3db10amr17532a12.6.1719271757877; Mon, 24 Jun 2024
 16:29:17 -0700 (PDT)
Date: Mon, 24 Jun 2024 23:26:13 +0000
In-Reply-To: <20240624232718.1154427-1-edliaw@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240624232718.1154427-1-edliaw@google.com>
X-Mailer: git-send-email 2.45.2.741.gdbec12cfda-goog
Message-ID: <20240624232718.1154427-5-edliaw@google.com>
Subject: [PATCH v6 04/13] selftests/exec: Drop redundant -D_GNU_SOURCE CFLAGS
 in Makefile
From: Edward Liaw <edliaw@google.com>
To: linux-kselftest@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>, 
	Kees Cook <kees@kernel.org>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Darren Hart <dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>, 
	"=?UTF-8?q?Andr=C3=A9=20Almeida?=" <andrealmeid@igalia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, usama.anjum@collabora.com, seanjc@google.com, 
	kernel-team@android.com, Edward Liaw <edliaw@google.com>, linux-mm@kvack.org, 
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

-D_GNU_SOURCE= will be provided by lib.mk CFLAGS, so -D_GNU_SOURCE
should be dropped to prevent redefinition warnings.

Signed-off-by: Edward Liaw <edliaw@google.com>
---
 tools/testing/selftests/exec/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index ab67d58cfab7..ba012bc5aab9 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 CFLAGS = -Wall
 CFLAGS += -Wno-nonnull
-CFLAGS += -D_GNU_SOURCE
 
 ALIGNS := 0x1000 0x200000 0x1000000
 ALIGN_PIES        := $(patsubst %,load_address.%,$(ALIGNS))
-- 
2.45.2.741.gdbec12cfda-goog


