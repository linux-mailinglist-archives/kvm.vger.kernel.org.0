Return-Path: <kvm+bounces-41296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DAF96A65CC4
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 19:36:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76A164218A9
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42E011EB5DB;
	Mon, 17 Mar 2025 18:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uF1GTfM1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3D71E1E0D
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 18:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742236477; cv=none; b=DnkMxLh9P8/mIxROrq8i8AsHZ3Za5+nLIBlhVXAaCEM4UGgsTDGZ+GazUEzpCkvHaldjmWSq02GnveGkA6KCCORa4Usn5Kej9ciT5AkER9Rr4UTROpjcotFlShwQyUABbUob5x+WEAtAd/7nf4pWAo5UuWGUV9zd9em2QPFfSLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742236477; c=relaxed/simple;
	bh=rOapAhxsucTXmmvj3a2Zy3fKHxQeQMgYCuWijJzB6sI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QMje94E1POT0uehRbnhH8W1R/vGhqENP67HiI1ko/XFNyiUZCpVYL576pjENuQkWjgbclgEy0jH1DeeaamDgHnwjOt4tu6AnhF1+g/nCDY3Gxeu9d0oQ0xoJ/94pwFUS2uJN96kr5nCzOo/fOhrVNo5KVExiJZebLII+GzxfGwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uF1GTfM1; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22423adf751so80104195ad.2
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 11:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742236475; x=1742841275; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PfpTTedni4gUGfvRcfnvXw4xTvY7JO0pNjOjXTZ7pI8=;
        b=uF1GTfM1NcrVzSEhurpRTwLo7+z8FOTrvoguiasWQKOBDTubMmt2ughLHugBLJz2+W
         NITTXKVojBao9QRmEE6iodb9cWNByfKcqBytS4mHtwN9QS576KdJblVG3Ng5+DM8Lumv
         GllczqK7BI2rs2HsFqGwgisb4+wC1tw16oVQn/uqU+jLGqKAwh641GcEIJrwEY4g9VsA
         6pbbLxaPR9Wr2DAclcsVzTIdBev4SR6Y7pYrEmjHzRGKmC8rFSxyMdW+qvRhSgyWNUB8
         ifc+i6fnr0AWiiygb8xV3wDTPrWd7R7j9Eyd5MUZ0pSTTUovpzImFvmYZgQoMLKrMG6g
         SbvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742236475; x=1742841275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PfpTTedni4gUGfvRcfnvXw4xTvY7JO0pNjOjXTZ7pI8=;
        b=RZorkISZpw7vq2AbkSRTZBVoq+PhUFHKYqa+gvMFWuj+KWMy52gBrPFf6NCwp/0WTo
         zQOdwDhtk7h5mhpIxrV4XULVjNylhr8HIE7J8WVWcCnqd446sUynNYytiCl/t5Z5QagH
         +RtJ3J3ws7WsC/1rv3lCHMkZJH+feB880kHa6Dct1wRBd/SclIGCaHwFPaabcGX2lnCY
         mTUU903V7LBBWWfKx0XxsOWkOcDKBlDs+CknPNur/fq2mYTQA3h0tdqRXJpiQA4flUWq
         dGaos5zWJJEeF/nkYC69e63YdoSHfIK8ZGnRDcpOy5Bjy50YPsJv1THMHbzgVQ6AAz9k
         P3qA==
X-Forwarded-Encrypted: i=1; AJvYcCVWgo6wBCIbXY/+/Q1Jv74r7lfV2ww5bv2Yz2bkXz8b1OE2cT9sGCO6ty7MxyV5XPgBSnM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxH/kDfOFJf61lCEQHYWGs2wXPvO8geRaakY6TTbS5OL3oDAiHF
	EjbiBZj23rQFlbOuauQX3ZDSZDliEyozn+MQ/nGJBr44aNpIJOIEZxo94tcwYgQ=
X-Gm-Gg: ASbGncuJTsY0TmxrTIflvZcWmrBEkV/uEM8qTF8yxcXrtf6gmv2CanNrUyeLGhzhy4o
	r/y3AgQvvlLQ23d0rTQ63Ow9Qd5MPBTaSOkjfEtyBQ0XwJupbFkwhk1Q8inv+xHp2hpjexK/V10
	VX0fR+wRALLOgPhiv1H7FdFpIrDFUVJ5/Ok9e8GRs4TzzhIhepzjE6aPbQdRmYXm3na08uyzFkt
	1DYDCYYpUUO2XUpJxAqw8bGdlOHO7FY+C8/RIyX1T6vn0m9EA4aLUqOyTjB9oi+Bt+TK6zWTQnm
	++8a7dLcxtTmwNfMp3gh3aUK/MuJnFwBBUSc/sxiQ2r6
X-Google-Smtp-Source: AGHT+IHhIUK7t53+vTI188pQaTMyR7EJzQqReYcVMpj4OefpwS1cjUKc4hsfvFYLapAGzkczRRlDcg==
X-Received: by 2002:a05:6a00:2196:b0:736:a6e0:e66d with SMTP id d2e1a72fcca58-7372238f773mr15973995b3a.6.1742236475108;
        Mon, 17 Mar 2025 11:34:35 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711695a2esm8188770b3a.144.2025.03.17.11.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 11:34:34 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	xen-devel@lists.xenproject.org,
	David Hildenbrand <david@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	qemu-riscv@nongnu.org,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	manos.pitsidianakis@linaro.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	kvm@vger.kernel.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Peter Xu <peterx@redhat.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Anthony PERARD <anthony@xenproject.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 09/18] exec/ram_addr: remove dependency on cpu.h
Date: Mon, 17 Mar 2025 11:34:08 -0700
Message-Id: <20250317183417.285700-10-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250317183417.285700-1-pierrick.bouvier@linaro.org>
References: <20250317183417.285700-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Needed so compilation units including it can be common.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/ram_addr.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
index e4c28fbec9b..f5d574261a3 100644
--- a/include/exec/ram_addr.h
+++ b/include/exec/ram_addr.h
@@ -20,13 +20,14 @@
 #define RAM_ADDR_H
 
 #ifndef CONFIG_USER_ONLY
-#include "cpu.h"
 #include "system/xen.h"
 #include "system/tcg.h"
 #include "exec/cputlb.h"
 #include "exec/ramlist.h"
 #include "exec/ramblock.h"
 #include "exec/exec-all.h"
+#include "exec/memory.h"
+#include "exec/target_page.h"
 #include "qemu/rcu.h"
 
 #include "exec/hwaddr.h"
-- 
2.39.5


