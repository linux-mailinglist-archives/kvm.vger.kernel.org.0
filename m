Return-Path: <kvm+bounces-61331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9272DC16EEF
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:23:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE4653B93F3
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 21:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31FA4350D57;
	Tue, 28 Oct 2025 21:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pllzVKH6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B32535504B
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 21:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761686465; cv=none; b=IbgieYht8GZSHmIz5VhSasNkxoAMVxwNX2eCXostXpnjt419gkp3sfypFaWLDaxnIRkggfjddO6N6pyrKVb9Y7oeglpoZneMsqUL5M7wmAr+fW7KGuP12iLkcUqZJPRq3jepRJMmkemJsD35O8clW9VVu+29NuUgthMwTbGyoSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761686465; c=relaxed/simple;
	bh=xgvBeAilvuR1wMxMA2IgvQnx8mA6bQkEXXA41ECFhcY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iHYLeIytbgoKetWlMkjZuxKh4N2qZLaMRVxQJP7OAPlawa8Mk0Iwh2qsYV1a8GXB4RkkxVmEbIMvjTOZKODxgCgnz97eo2Vlhg6U/6kTRtBX4B7deLfijLAlVwo4KGhjIlH7SzK7ZTSXHNY9aPq7P0Awr7ot5aLWooXccuKo41w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pllzVKH6; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-93e7ece2ff4so2022059939f.2
        for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 14:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761686462; x=1762291262; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Iwnkeaw5xTHA537xvr1qbvrkFbFprtxqChvd3RhJpBM=;
        b=pllzVKH6+E9xifzxMJoOSM30piruYsMfOEnGGHvTZ5eIodgIXAtD8Gy7D1vzTKFRZJ
         xURUwI0sLUxClhmVXPQCX8a5TvGgh68BPiq0yHc1E0S2JhLjXzCKX8ldwJ3DGxB595wO
         1T2rU5Odr8A2XTRCY+Z/M8B2n3CJp+Euo+KTgGwg0yTcjEgsEtKWFWgu/vI5nyW4o9wJ
         /wvgq/kKgDluSyUiBTvBdYwaOM6HkemRToDwR4BnSfpqwTAcHk43+iR72u9wE7GdgNwM
         XIBRaxOIqGbKwJ1yp/lkpBvW0aKNh9FwnfefvUO+5pfIQBD6xvZxeddC3++KmiQRqU+b
         kq9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761686462; x=1762291262;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Iwnkeaw5xTHA537xvr1qbvrkFbFprtxqChvd3RhJpBM=;
        b=tnRLhakJr/DtzLQZdxYp+/CMYUnRApFaMZzJKfP5XSWsYQeKlWSksdEQ+6qOAQFWaj
         +xhKZ+XtRRcxFqqpcrFN8QieXOvy6nYBvEjzCO92wYa4paXTriLswKs1+c/6l7udrnVM
         f8nNe0QKvkOe4p9u0+03cegp4QR2bx2ycWYHlrQRzEpWfqxb33o3wSvzhQHCyiOUtPmt
         2vg48R432vIC9aPNKkyKBvKifRBKxo4PKAaqaaJeZ8DmiqHbjKVMUACm7Y9B0ofCpET0
         GlQ/K1h1HagDStEkeI9/x1kfa5zCZo8NkLiB/kJa8REyAGgU2sOqX1ONmFsTFdeFTN6M
         L8TQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5vfotj8JoU+4atXm9eRMJc8v0Y3/vlcZxKnA6Pkbs7Gc2SpOTPHyRojnP0d20O829Z8A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRy/SSLC67lmnqk976+bwApMmt0nesyxL9ATppxA8p6gFwV4VZ
	yWvpa1AKBkq/yQsEHrY42jfdtYOAD+UFKatMkR1sy3IG9TSNlFMRtQ8JKsdPr8cGP/lXWeG0Egi
	POQ==
X-Google-Smtp-Source: AGHT+IEN3PgPSnkwVy0W1+8Dw44bu1h3INTGMoIy4zBd51QD+vZlneDPokuppUvG2xB3FVMgGelzQJssJg==
X-Received: from iobel10.prod.google.com ([2002:a05:6602:3e8a:b0:936:faee:15c])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:14ce:b0:93e:7883:89a6
 with SMTP id ca18e2360f4ac-945c98a8aa9mr141227139f.16.1761686462162; Tue, 28
 Oct 2025 14:21:02 -0700 (PDT)
Date: Tue, 28 Oct 2025 21:20:33 +0000
In-Reply-To: <20251028212052.200523-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251028212052.200523-1-sagis@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028212052.200523-8-sagis@google.com>
Subject: [PATCH v12 07/23] KVM: selftests: Add kbuild definitons
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add kbuild.h that can be used by files under tools/

Definitions are taken from the original definitions at
include/linux/kbuild.h

This is needed to expose values from c code to assembly code.

Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/include/linux/kbuild.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 tools/include/linux/kbuild.h

diff --git a/tools/include/linux/kbuild.h b/tools/include/linux/kbuild.h
new file mode 100644
index 000000000000..62e20ba9380e
--- /dev/null
+++ b/tools/include/linux/kbuild.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __TOOLS_LINUX_KBUILD_H
+#define __TOOLS_LINUX_KBUILD_H
+
+#include <stddef.h>
+
+#define DEFINE(sym, val) \
+	asm volatile("\n.ascii \"->" #sym " %0 " #val "\"" : : "i" (val))
+
+#define BLANK() asm volatile("\n.ascii \"->\"" : : )
+
+#define OFFSET(sym, str, mem) \
+	DEFINE(sym, offsetof(struct str, mem))
+
+#define COMMENT(x) \
+	asm volatile("\n.ascii \"->#" x "\"")
+
+#endif /* __TOOLS_LINUX_KBUILD_H */
-- 
2.51.1.851.g4ebd6896fd-goog


