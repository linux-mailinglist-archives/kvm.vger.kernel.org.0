Return-Path: <kvm+bounces-41096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B09FAA617C4
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:32:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87E95170CE0
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 17:32:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30811204683;
	Fri, 14 Mar 2025 17:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UrQKCvNp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E2C204C3B
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 17:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741973517; cv=none; b=gMlUrbO0ze9DEm0HyqGqy15ZWuFoICqyfmhgTH9pvcrQqqeQpcU7lnbBYYthGv/LXiP/1HPca/uHfbjLdFU07a3/bquITRNHJxdOwt0XiOqsLpFGWRLYsbVbYuaAWhRlTkgp0L4XUvdy5Up4JLsnGzi2eCZ85GkiSBHNAyX/sNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741973517; c=relaxed/simple;
	bh=rOapAhxsucTXmmvj3a2Zy3fKHxQeQMgYCuWijJzB6sI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=daDxszaCIxmH4LRs8lbEBevbWkfBjzWRhsCajaJxSf8M0g6vrJ9F0rXRI2dpp7rYhFjWQmhRYvFrrBt3LZ8ZOM8+iF8Z7kpbmrCcFI+OkWB1d0gpywSd97Iy1BqqF3X5xTxs8VFMNNws4auxI5WLnRjWHA07O3C2kgSvKZwLAkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UrQKCvNp; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-225df540edcso18252325ad.0
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741973515; x=1742578315; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PfpTTedni4gUGfvRcfnvXw4xTvY7JO0pNjOjXTZ7pI8=;
        b=UrQKCvNpDrw7flOUFWFb+khSrW9DUAr93CgBo/V4pUugU461oZeALuVmn0itf/khss
         EfNWytRVvfzeNqPamyLWqrAOf1TwYttdxNQcloUTU4S9jGmaPyPwwlpJZ0pp1HIq2IYH
         z5r6rZTe6qwSlod/iqeD54t719g16FTlNgVeKhILirzrdcJIneDMBwwXz7pmCzWi2Y1z
         kcBWCkYnq1+Dz6niMa5F8oX0I+HBctLJijbCPh2gCBI3PMwrc2Z4pI+WR5YB8BIeo13n
         uplfSo2BscxjwX0dDKVuxmNqqmLXBEsVuRXjvoW4+zu9W89Gu+WFEZcVxnXQTUyjF9OI
         wOIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741973515; x=1742578315;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PfpTTedni4gUGfvRcfnvXw4xTvY7JO0pNjOjXTZ7pI8=;
        b=e1P+yVRXnrrZtf2nk/Q76qA70IvhkEJ8hdRyxuLhn9ZdqN0fzxJah+a7MgONo0RgvT
         /EvdxlcwHtV8FUS1sLk7H+i0YL+TSWAhqGRzTDutXDyFsOt47VgAWbNV2+DnT6xl5DUy
         6Qa3tNfst1kryXU4uz9MDf0CcVhyDSS9AVDDZLHGe6fdxPHgPfuRWwShkRIY4K3Y5XJH
         nSkpm7GR89lZkBZwBW5BbBDNXq25qcll/L8ExarTDyXvX7fOaZG5tFl68gLJdBTetnjq
         MKknVBTea4aE68tlDj8rxc9GDQTWHTVyvkEHeJzdw9yxnvcHexiEPdBDmgVNx/uoKIDH
         9L0A==
X-Forwarded-Encrypted: i=1; AJvYcCWHpRkyBklJ5Fofw94OOUNKHhKU1snDjx4CEmadAMswWSHg9OKIsQMLtA/YjDCkEfiZOlQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+vexffLu/QPqxqN0K/fX8nLWNlY+XnYx6ViBcT4pENQFoBlA6
	l1DLGt0kEfgzdCmssS5CbRlc5zj/RExcQ0I4fHR/jdqS+MbwpKq34lk4fdiRAOY=
X-Gm-Gg: ASbGncumlId/P00v3ze1CdtiX4y6CgLEYPz4wDFyFaW6TAi8W7YXtifF1frPvUPEZ0b
	6hOmO3TjTBQJdHgNinKRLE4eAvWgbuk6WAcCHNaYUyqGr4mXtPq3gBNjy5jrENdxuDwu6Lbe6mb
	MVUNKbZI0536D3QvT4iCHm7B/O+f5tSEUcjcwO3MXb+napVzMmv9clo9Bw32BTHoM4qnU7AfP8S
	nhe0461OlvjdvFNY6PeHSkHZpwZyuwifEoonZq5qUs1aMWCr3G3D905v7sWKnlo90VqIlyDF+BE
	ydAcJsdP7B1e4o4imJCryEHaO81lfEnJu1rmnpJ7J1h+QPVuk8lJ4Q4=
X-Google-Smtp-Source: AGHT+IGj/I3RP0NPhKjXDLOwbHPd8rrkJpTvSehnV45pZ5KtPvxWJrCPU4ZqmKsKsNZoI57izw+qbw==
X-Received: by 2002:a05:6300:619c:b0:1f3:323e:3743 with SMTP id adf61e73a8af0-1f5c28650c4mr5059385637.12.1741973515400;
        Fri, 14 Mar 2025 10:31:55 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9cd03bsm2990529a12.8.2025.03.14.10.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 10:31:55 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Paul Durrant <paul@xen.org>,
	Peter Xu <peterx@redhat.com>,
	alex.bennee@linaro.org,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-riscv@nongnu.org,
	manos.pitsidianakis@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anthony PERARD <anthony@xenproject.org>,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 09/17] exec/ram_addr: remove dependency on cpu.h
Date: Fri, 14 Mar 2025 10:31:31 -0700
Message-Id: <20250314173139.2122904-10-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
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


