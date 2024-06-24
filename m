Return-Path: <kvm+bounces-20423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 544C0915A77
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 01:30:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85E4F1C2100B
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 23:30:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 556A01A8C35;
	Mon, 24 Jun 2024 23:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NkPjPOLD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBB41A2C29
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 23:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719271755; cv=none; b=SeanSldPF3yWVHbVutqlTpZerS+JqvttyxKHx6Ft96Xpp0oBzrHXBMAq+mIPhZiLPAveN315kmXiU9Oj7S2xnHt+LQbt0oqV6Mz6M2PoDcIxXsyYwyvFieTp/70wX+/zDbq/3Cw+1LXhotem62pPke9b9ftt0DtSLAsGuRFLiDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719271755; c=relaxed/simple;
	bh=atlaXfghS4B3aXHldxOAsjMJ0B5nS66NiP0mFQbDOQI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qJZ0kDX60/8fGcjCJnA+lMPRuLf8795T4Zx20I4YaYWJ2OyWS+JLc1H7EKOMQMOUdstO5g6vkkpdvJakLltB9mFGNlXEB1xG7lJj3C1mgg5jXokRUAI1tcsXf7ov/iT1deNZ9m1WIO4cNpiGU4plhWBrwtvYQY6lJZ31mQPNfck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NkPjPOLD; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0322e5d0daso452403276.0
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 16:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719271752; x=1719876552; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KYsd9Rb/6WE30YP2UPtx0BT+t/C3MbQ4dWAZpecv6Gw=;
        b=NkPjPOLD46sdjSqt3yUq6mlho/lQLQaFvf/DYTSQugRJfZ0qjX+bRxttL0svC/xPq7
         CmR4Ukj4jnidxzufN2k1nPTLTmBSyp4fUieMhopfJlzNhjilcScRL5AsVz6YDk1WC3ol
         74gfILUNnF/HKfs2U969Sx8K9TJdq5VrpTmO+CCpxCVN2wWONqNZGBAPvwEYtXK91Zzr
         2BVNU15HpBTd4KhsI5dXj+ZGCdoqy1r9yZq+Is7EuGH/MxiiTzkyb56Jec3xgjef0JUS
         Tg6ET13IIE1Rbe7fdbhOurpolpB7hdqOUdimvkuD+l+5BmQ+/ZEhImfjhNym1yjmtE7m
         UUnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719271752; x=1719876552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KYsd9Rb/6WE30YP2UPtx0BT+t/C3MbQ4dWAZpecv6Gw=;
        b=IUlfoXKIdnVPdxU/WT6sprBRSi7e7xhTf7b9RILdjHwJMi67XZ6qwhYPgyrDAFpS9c
         Pc8xkRnTx5rINSrmKQeLBobM4ahKHY7SUK3FER1TARYNSoAJKf1NqAJg2UysXN5Yv0pr
         OLmLgJcqNvHVQaorc47eU4Bl8qlxvjpJnJ1HQF7yclfgibkKj3H+jSPEay0M31zwAlzs
         4J2RsrbUZcF9gWbJhUfrtC73IMNL/gPXKX5uxsQXAq1ZPD7Pz4sIwja8wAigI5oRLX/+
         7HOCqcNX8xq9Um4iU91VBjKwpDEIE9amFV1X29NZsPDy5ELYUm87MDYgM88y2PO2QQnn
         GfHw==
X-Forwarded-Encrypted: i=1; AJvYcCWvshyVXi441m2yw/5bGNz9MDGNdZkCuZ1rwqqmG6ur47mVfHyetDJ8MRpZJq1jgJ7Ukyh188wjIUZT19dXJfhv8KSI
X-Gm-Message-State: AOJu0Yw7/RTcRS+I8gFYRdsZjwZlbDOle2lhua1zTv5ZyPUT+GYKKXiO
	77OqBVQ96HnrLubWOe8B4dtETXvFmZ9IzCwVhrAGUqlLwFqugBOEASS8JIUc02JnfZVd6y6NElB
	JMA==
X-Google-Smtp-Source: AGHT+IEFOOflQzV3wFuvM2R/hnljfPuosO3Jiw9JP4M4awREYhPcttpeymh3r0w5dseA0yzpFfUKTbd9tHI=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a25:aa0f:0:b0:e02:7c5f:e0d5 with SMTP id
 3f1490d57ef6-e02fa00e04amr59299276.4.1719271752514; Mon, 24 Jun 2024 16:29:12
 -0700 (PDT)
Date: Mon, 24 Jun 2024 23:26:12 +0000
In-Reply-To: <20240624232718.1154427-1-edliaw@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240624232718.1154427-1-edliaw@google.com>
X-Mailer: git-send-email 2.45.2.741.gdbec12cfda-goog
Message-ID: <20240624232718.1154427-4-edliaw@google.com>
Subject: [PATCH v6 03/13] selftests/net: Append to lib.mk CFLAGS in Makefile
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

Instead of overwriting the CFLAGS imported from lib.mk, append instead
instead.  Also drop -D_GNU_SOURCE from CFLAGS to prevent redefinition
warning.

Signed-off-by: Edward Liaw <edliaw@google.com>
---
 tools/testing/selftests/net/Makefile        | 2 +-
 tools/testing/selftests/net/tcp_ao/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index bc3925200637..8eaffd7a641c 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for net selftests
 
-CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g
+CFLAGS +=  -Wall -Wl,--no-as-needed -O2 -g
 CFLAGS += -I../../../../usr/include/ $(KHDR_INCLUDES)
 # Additional include paths needed by kselftest.h
 CFLAGS += -I../
diff --git a/tools/testing/selftests/net/tcp_ao/Makefile b/tools/testing/selftests/net/tcp_ao/Makefile
index 522d991e310e..bd88b90b902b 100644
--- a/tools/testing/selftests/net/tcp_ao/Makefile
+++ b/tools/testing/selftests/net/tcp_ao/Makefile
@@ -26,7 +26,7 @@ LIB	:= $(LIBDIR)/libaotst.a
 LDLIBS	+= $(LIB) -pthread
 LIBDEPS	:= lib/aolib.h Makefile
 
-CFLAGS	:= -Wall -O2 -g -D_GNU_SOURCE -fno-strict-aliasing
+CFLAGS	+= -Wall -O2 -g -fno-strict-aliasing
 CFLAGS	+= $(KHDR_INCLUDES)
 CFLAGS	+= -iquote ./lib/ -I ../../../../include/
 
-- 
2.45.2.741.gdbec12cfda-goog


