Return-Path: <kvm+bounces-20422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00D7B915A70
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 01:30:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0F99282A29
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 23:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF4E71A38FA;
	Mon, 24 Jun 2024 23:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="upDGTY+V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8841B1A38E8
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 23:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719271748; cv=none; b=F8Ahw4no3f/tISimOcjys7TWr6CFLWga3LTcYALVvWjtuxNbvS+7xvB5awVJbN6vVTe1MV502iGAKEtkhkN/Z+54X5FQ+D9eropZaU0UxaNGphNWJ0QoAuX4spOS+pIWmOkVgolCz/Lzf+WkQpvHp4/Mgip7WgyoJewEp9bT39A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719271748; c=relaxed/simple;
	bh=xwftBfRu5G8w7ol9IF7MUG9BSiGvoLKlVTWAOAeO/Is=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JZ7yp8Y/r3+Sgrp0iiL/2aT1h0epAyoF2lONHJVvo6+fifRMGnALQW7ododBN2+JOOUntuzGu/UOJ/jfRjAeg5T3wZhnaVm1yvd3wcql1hAPdhjk+OFW38XBz8PQx99+2/Ts4ZjpzZpp4+SA88STsbpdo02QwLZcz/8/XkcqwsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=upDGTY+V; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1f9ae0b12f3so53575275ad.3
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 16:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719271747; x=1719876547; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y7F8R5HE+eZyxlB2ebQLwW1FMzverfSOUo2IuXKNmLY=;
        b=upDGTY+VAWxjOiGt1aN8qq/MXQcXxCGhECKCR+u/ehZUHokbQYBzXGPPb67Ib14AYJ
         WS+Icm1jnUp19BMdXpFSNeL98mC+XEUCbkDJQQdWPHozIzclQDGsE2NnJ/l/XJ+h7O1m
         BssvmwEpWtykYwfNxyQEQFmdtvyoEdRIcIsrBkQADycUJB0CmlZmdQklWhhB6zAEHG/I
         qmHXlzQINVs+7F8iOa8zPeFNnGQXynyT4+QVgszv5DndlHQ29J5RjVYvVlGrSXxJBBls
         8ZRfhzFO9fvFPh6hFHx772LXsRysy4ieIYujQB+oSWpQi4Cn3AKoENJq6O/tqt0a8G82
         yRAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719271747; x=1719876547;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y7F8R5HE+eZyxlB2ebQLwW1FMzverfSOUo2IuXKNmLY=;
        b=BzM5fu6MfhOCz43K+Xp4HQCM8bre8epyqn/OO4+gWdkBXiVcgM0XMUM/GGHHzYer5R
         pvd34ofgkG3osx9qo04tqzdeyS+c2UXw2lqUzmzPvo88yUDrZtWJxrthjQYA6CdgeFQB
         +7Gt9x85YvmaopxvyByoR/WUYlWawMVMUT2GHvwvSUjoaMtCXhWRAxeLGG9bT3kCHV1E
         LPfJHp3iA8qibmUKqH17d8TaPmE3q1hV5DFc9ej/fTWGduKUGXvdyv1jTKKLIwGg1M1P
         REzZdRN8QFerlbLo3dOnpEWU3ZPTMWkPAOkgKRIuRbFn7ynWKyCPELgOE6i7pKmNbYgE
         HOoA==
X-Forwarded-Encrypted: i=1; AJvYcCWHeQW9RcqE6D4O577+lIoY7NZjOkj9x9ICCoapixevtpdLyAVZTUn31fQ6eTzGiZjKUBCsMdYVVObHFeqBc0cAWQ+P
X-Gm-Message-State: AOJu0YwXMXieLnSRUgxwl2YmpTPqqHqQPNmWjxMWuVjyoWJSZhwFdwi+
	thbzhzzDarUcssnuRQoquEcE4JdczshHq86QARkD2icEbs+6Vq9sxOegkAn6npgq80KRdFPxmaP
	VHQ==
X-Google-Smtp-Source: AGHT+IFY6zwuM+fBRs+r7yFjUxfbkM+X5No4nRI5eUjSYyy4xzwRR2NKqiye6S+BJr7Hl1+KVMRcw6AW1Us=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a17:902:f693:b0:1f7:3763:5ff0 with SMTP id
 d9443c01a7336-1fa158d034emr7382275ad.1.1719271746792; Mon, 24 Jun 2024
 16:29:06 -0700 (PDT)
Date: Mon, 24 Jun 2024 23:26:11 +0000
In-Reply-To: <20240624232718.1154427-1-edliaw@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240624232718.1154427-1-edliaw@google.com>
X-Mailer: git-send-email 2.45.2.741.gdbec12cfda-goog
Message-ID: <20240624232718.1154427-3-edliaw@google.com>
Subject: [PATCH v6 02/13] selftests: Add -D_GNU_SOURCE= to CFLAGS in lib.mk
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
	linux-sgx@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

Centralizes the _GNU_SOURCE definition to CFLAGS in lib.mk.

This uses the form "-D_GNU_SOURCE=", which is equivalent to
"#define _GNU_SOURCE".

Otherwise using "-D_GNU_SOURCE" is equivalent to "-D_GNU_SOURCE=1" and
"#define _GNU_SOURCE 1", which is less commonly seen in source code and
would require many changes in selftests to avoid redefinition warnings.

Suggested-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Edward Liaw <edliaw@google.com>
---
 tools/testing/selftests/lib.mk | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 7b299ed5ff45..d6edcfcb5be8 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -196,6 +196,9 @@ endef
 clean: $(if $(TEST_GEN_MODS_DIR),clean_mods_dir)
 	$(CLEAN)
 
+# Build with _GNU_SOURCE by default
+CFLAGS += -D_GNU_SOURCE=
+
 # Enables to extend CFLAGS and LDFLAGS from command line, e.g.
 # make USERCFLAGS=-Werror USERLDFLAGS=-static
 CFLAGS += $(USERCFLAGS)
-- 
2.45.2.741.gdbec12cfda-goog


