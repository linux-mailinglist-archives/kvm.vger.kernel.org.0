Return-Path: <kvm+bounces-40795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 966D3A5D02B
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 20:59:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF08B7A7DF0
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 19:58:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFE66264F89;
	Tue, 11 Mar 2025 19:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VQKe6e1/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC97264A89
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 19:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741723102; cv=none; b=tm/o5GNcXYWMgZVINKVTX8OQbgPX8Bo48U3pTtEnUFYaSugVhJCAsEup8NUIkewuGFSys6BWjf6pbxwWRs/TucOGfcrm9mRQrVWMby/D6PTJ3AWTdtC3jBxkYE6RUDeEaaE7OOnFFjgsxxKf1jGCQfoIcu28G2hTgSEOtJSLYXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741723102; c=relaxed/simple;
	bh=072rJgb1v8WTOR3ndNWM1YDjHaA2UGkZkEMRddxYphA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bxC83AdShzrtURXEPaYX2Fhnp8Uk6cRfgIJPnhub/WZum/IUcZl//+8MY31dKrf2gvB5GBasQCKXo1kZ0CUq0OGMiS9IgX6oMzIM8gmL49kXo1L82xc8gWvgJ1uvi6/mP2T1YrLauFYGJrfJCJj5hMagBo4bf2s4Jxa6AaA7DsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VQKe6e1/; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-224100e9a5cso113423635ad.2
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 12:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741723100; x=1742327900; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rp8GQC6vA5rTxSSazblnkjuLZPjrJAYUOFg9uGM493s=;
        b=VQKe6e1/xzAPzzsKM4rEpWhF6XTrwbC/XR+Z+DKJKBOiIjlmC+vV9r/KP7+IERqrjY
         3o70WCSW+VT5ol+riMniW5Acxf5pk04eEjKlCU2Pz8gLBPa68a1xaxVSDA6S4zQEKbni
         SrW2sUPj6TpeySQSFV/QeE/fodXGmBW0l7sQyqFGyQq77fjxuEeick6yZq/lBzngERO2
         s1s0qV+LE9reFAbiD9x1ozPTaqHMSdzN1k2KrgOZ6RtYBReHrWnMqGFYgoXzkvYaJNkc
         IUd6QxePTQHoyyXiUi3IQp1O7nbBx5sK6fxzKM6o3G5f11diXU5EXczFMZyAh4COb9Ar
         2s9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741723100; x=1742327900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rp8GQC6vA5rTxSSazblnkjuLZPjrJAYUOFg9uGM493s=;
        b=pQE7IN79lWhxq/F5pJvAShq9xtpY8GgM8lTx2ssjbwefsPLzx91DaevmKBZUJzFxqU
         AD0e9DFs0OTEgoAuLyZyO7dJQyc88GzZvBnZfrKfHNtHpViuGHhfXItw+UdH5FjeWL2Q
         wxLYQ2SEY+q4ImCFFv3UfhUwvt6eYvuafGNzXvWAP4Vestwr9fZV06+FM/ORlYEZKtJs
         HUz3ezRUs9CBTgjmIoGL3CaekwmjtuKOM9e3OMj8/t822zzlRBLo0YiUhRoJWNN0AFwV
         jpZawfUBGZQuvv8YDgBu2cmd27oWccIM8S9FSLYFbvFWDL+eCf+q8pssUaz3/KCzPW2j
         PCog==
X-Forwarded-Encrypted: i=1; AJvYcCXdK9DwTEXx0kULZ2WsaCtOymKAMrO4iHz4zZF8tXIZhslKe6L06s8ANkol584XXP89VZ4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPvznfVXADomTJDnjhgNSiFy+xpHZvT6Yc/y3d9k74nv8v1eYs
	Sm6k39UiuAlU9EagiZwLl1KI5vozzaPBmVcTCqVwYtY6HMVPuHk/SryS221EwnE=
X-Gm-Gg: ASbGncuiM2db6cNWeVWQ0yCpz72inT7WTfn9o/HAFqFaYux+MnYDNPcQuRcVUZ2zfDV
	nN8S9lt0WtYQ/cwUZRUnJ4ShnaMKFA5zOfo/jsyCkltnKWUjWXsF2iuh7OuLXfYjSRKQMELcbFg
	hYWpjqoDiGK22UJ/NgFaaN7EOk9GNzUZkl2M3Ua8dZhPwTVZaQTQryEvqwKV7+21vtghDAiQkXW
	PHowCnIQG1uIoNyW+/Uwz5hGi3OhqhmnyItlcLlThrwPWAVnW+Tj2RetvRc3gZRTposkgRw8xJz
	QimOrvOTZ12La8JcscjUB0rPyeHeLeDy8ojCyNOFKob/AIOPxvVZ6gY=
X-Google-Smtp-Source: AGHT+IEBCxz8tAPvpmfBsP3Ukq6OIHQbs/5ODtSLSGAs7fop1NjSulQH4pEJZaQn/aXi1ghSaJLALA==
X-Received: by 2002:a17:902:cccd:b0:224:256e:5e4e with SMTP id d9443c01a7336-2242889d3a7mr298318035ad.16.1741723099862;
        Tue, 11 Mar 2025 12:58:19 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736a6e5c13asm9646981b3a.157.2025.03.11.12.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 12:58:19 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Anthony PERARD <anthony@xenproject.org>,
	xen-devel@lists.xenproject.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	kvm@vger.kernel.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paul Durrant <paul@xen.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	manos.pitsidianakis@linaro.org,
	Peter Xu <peterx@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	alex.bennee@linaro.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 08/17] exec/memory-internal: remove dependency on cpu.h
Date: Tue, 11 Mar 2025 12:57:54 -0700
Message-Id: <20250311195803.4115788-9-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250311195803.4115788-1-pierrick.bouvier@linaro.org>
References: <20250311195803.4115788-1-pierrick.bouvier@linaro.org>
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
 include/exec/memory-internal.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/exec/memory-internal.h b/include/exec/memory-internal.h
index 100c1237ac2..b729f3b25ad 100644
--- a/include/exec/memory-internal.h
+++ b/include/exec/memory-internal.h
@@ -20,8 +20,6 @@
 #ifndef MEMORY_INTERNAL_H
 #define MEMORY_INTERNAL_H
 
-#include "cpu.h"
-
 #ifndef CONFIG_USER_ONLY
 static inline AddressSpaceDispatch *flatview_to_dispatch(FlatView *fv)
 {
-- 
2.39.5


