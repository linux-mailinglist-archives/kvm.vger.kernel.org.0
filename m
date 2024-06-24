Return-Path: <kvm+bounces-20430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E170915A9A
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 01:34:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF33D288C22
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 23:33:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 877E31BA87A;
	Mon, 24 Jun 2024 23:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WcazQxU0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7467C1B9ACC
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 23:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719271793; cv=none; b=FXuLiXOhGp8ZAZ292Mj2qCLF2nGC6ke7kcuN3c4rPWaxtOXWNOKx2VRP2YCoVdyAK3M+fBnqzd7cAaYx8+Iw3greYHumGLbQ7bwBWo8ytUiFB2UbN/HiTJXWJoOjyd2NZqZDWU9Zp7Muf4J64uPCCFnElcua42IAepYzsXf0Z3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719271793; c=relaxed/simple;
	bh=zjwLmup1M2qfYddBQWwqHOLkKVhU9xZCCBONsOyNtQo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rWkiSfbMtPD+kBuEtXXWtI03M5M9BadG9hTchkLm+aYc/4XzSsNYpUPK46z+XvQIb1CWQI4hGldNlX3roO0r9Z5jMN+EQe4R/z7CMhBPVwBQ5yMLWYtadcKpmhZPTz7XF4Y62TFlKP9MFq/oJGqObzzQwWFNlHmW3VxLNd2Rtlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WcazQxU0; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1f9ec9aae70so38598095ad.0
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 16:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719271792; x=1719876592; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=diaj5tFwwNQVaMCQX5T2JTz4mfzyRWuO7s480xW0M7E=;
        b=WcazQxU04XQfOtJQUiCxu4cjEtNueaIZyEVV0zgReea7GvZv6iR7oSBKjpMcagoYUy
         oatWcjj8GL8Ybm6pflFjQGrvoLDC4710bXh0YRvg5sa86NoZ/H/YE0EVutyz1bcMftMk
         YoCZQUKG+7CdwMoC5i+83sSqecYXaHUUjuF+g8lVOLH6faq+fW+9ejqIP5t9az4hOdQA
         REPYGokWUvzELv30l9cJJzYUvbennfdCuQ+5n2kzp+TnrNzGhA+2pQqtGNx3WPXLsldh
         9Zau5hPS69enRL0fL43aEkuohXFGQCOr2eyFGvGzU71eGTRyGW4ARClYS10QK3oUPWGO
         9xDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719271792; x=1719876592;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=diaj5tFwwNQVaMCQX5T2JTz4mfzyRWuO7s480xW0M7E=;
        b=PGG3UT4SWF+QFu6uMNrjPpmWh7m8SDlaYOl9xZV1d9ZGdimQoQbazu3tjrNC6ZQYv5
         kq1HloqtgdHK4kdIX45on4OXqI6V1+MAVcak6C9xz5ZN/RsI3YnOjV0Aha7fPyj69l0I
         +NTRUUALcAy+Fx5jtJChwXc2oblD2QpH1ci2nMTczrlPSxSIK8+xi2ndTOGLYF6uhctl
         dLYTxKXvAK10/9E/ALEHBtE9KpsZVpzP8bEPZ0AynGz+vm8WrYfWwGHJQTHHlTeX4NB/
         3ZlT8lWwFH5GGm9HRWLSxxorBt5l8RYJ1IiWQJDQbSFkirD+pqv9i8Vz5jS8qAQZ6CwZ
         K4Ww==
X-Forwarded-Encrypted: i=1; AJvYcCUOvvuVVm4dTnEPtr5KyWJnCVsOAuFW43fcUiGhip+04PcrUFwmvzLkT2kNK43qu4NFeXf7EmKR9opt+7iIybt71utK
X-Gm-Message-State: AOJu0Yxy3tmtCumT9dOdlgvOYUHzqxJPZkyQz/zbiK1gzAHDLvGcZoGr
	kKx7FjmfrvaCi8h/Xq7004TIVOJ4lis/GBXjQdbE2Tie8XtStMNlaolu1acpVuXHpE6/sUjMOFY
	2Mw==
X-Google-Smtp-Source: AGHT+IFAHsy2vEbD08I44y0v3BWNlocV2o4z95Fg4teVzqZkoUDKjX2v6KqYVtDHhi51zA7DQs3radXmbQo=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a17:902:ea08:b0:1f7:3bb3:abe2 with SMTP id
 d9443c01a7336-1fa15938adfmr8753425ad.12.1719271791633; Mon, 24 Jun 2024
 16:29:51 -0700 (PDT)
Date: Mon, 24 Jun 2024 23:26:19 +0000
In-Reply-To: <20240624232718.1154427-1-edliaw@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240624232718.1154427-1-edliaw@google.com>
X-Mailer: git-send-email 2.45.2.741.gdbec12cfda-goog
Message-ID: <20240624232718.1154427-11-edliaw@google.com>
Subject: [PATCH v6 10/13] selftests/resctrl: Drop redundant -D_GNU_SOURCE
 CFLAGS in Makefile
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
 tools/testing/selftests/resctrl/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/resctrl/Makefile b/tools/testing/selftests/resctrl/Makefile
index 021863f86053..f408bd6bfc3d 100644
--- a/tools/testing/selftests/resctrl/Makefile
+++ b/tools/testing/selftests/resctrl/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS = -g -Wall -O2 -D_FORTIFY_SOURCE=2 -D_GNU_SOURCE
+CFLAGS = -g -Wall -O2 -D_FORTIFY_SOURCE=2
 CFLAGS += $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS := resctrl_tests
-- 
2.45.2.741.gdbec12cfda-goog


