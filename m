Return-Path: <kvm+bounces-41294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F039A65CB9
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 19:35:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64D6F7A9C9E
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D19F81E8332;
	Mon, 17 Mar 2025 18:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="INzTnpcf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754171DFE12
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 18:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742236475; cv=none; b=n/QjYbUeOcogGhAnWoUSu13GqTXEZ02bpcyjrq5BMmLO/G7GSoSG7gvDIWrYFNj7V8O0S8MlbwM73A01RyciQhwb/XcU5Oz2xpeUAj8jDcc0ZgbWFClxTB0QaptPhHYmWclZg/7bjgqtyQ9n+9Fs1FezzdM3Yu7ds53tyIzk3Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742236475; c=relaxed/simple;
	bh=aHcHDSCEQG/Lxg84jg/rjAhvQowTiiMszTRoQh+zwoY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lWInED3hVJHLYBPSOnsOJMtsfORwYd5Te0QvENusv4/L9i9x4sljRMhoXdDlD7/UGHhMbvgqyT5g6YSv++TvPh8tlpxNAWs/lqAJ8p+EuOY+9ugw9d8crI+TKXY1ksg7vOeuRxgXTbDIgDz0fCJNyjFdVXsAI0bFUAqjgn9+uyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=INzTnpcf; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-224019ad9edso39848825ad.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 11:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742236473; x=1742841273; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bYYGOsy+zcSjxVOnigwMonGaAhWbZB7W76ZyOX5Jlgc=;
        b=INzTnpcfZT6rwCfNax5BAPvP6fy05tu91p6sQ/YB8LbTPN5cvT51M9wMrb7/DUrU95
         Hz0EsLuNa9ffdCzcm7cwOPCIYBEY/DVapvcuQ0rPqUefVBAbE5tUM3/XAMuHtuKjYjr7
         YmT/zdT6HrcYJLj8AuvX/FScWq5jkLlO/0arQ0ujqSvlNtGbkCIHvjfIMNSHBLapqi8k
         81jMlOPCQ8viLTVUxvM90Y9xKsIVd1Sk3vX478j2hNyLmWn1rHkGeLTIRQyzNWrv/qgV
         2ktj2K430ZSbtnc1EWqB+VHunDtXh7vwd4U2C/1jLcy6CGxzOwufP1MUp/1LwNVJCOSQ
         G7Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742236473; x=1742841273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bYYGOsy+zcSjxVOnigwMonGaAhWbZB7W76ZyOX5Jlgc=;
        b=N1+ws2G7BIVe/qq6RqNKqAcJ942tFyUj3Y/BXr/OhNMhfo3GK1Jdg2mGiSvZ6Q0kWI
         cbrvZ95HsKi1WKPgArXCd6A2bkhiUvTq7ka3uXMtlCd3v/1MGUfKuh3NXafpm00d0dQa
         1hqrp9fwYX4H7Tx/1/4Pz5gIprgJEmqS6MCQ5v3tupi4EnBsITt9ogYoR19fL8KuwwJG
         nC2e4eukHuI5+rAnH1OYq/PX1ElyUhfispcA8wnSFY+sqy8L1LOCpzWyoMwDXSvrXo7u
         VLRDBbn+5AE+CLNELMURxCSqZCFVWW/zd5dqCQjtlFQu5/472gfvl6GKjObq0eVUEiyp
         TE/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXvSqIc6rF8CwS74TvCJfRMtv1dwMZ2N+63dlxALlRB8dkvLDowuiwvv9ovNdqOaib6zms=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0X4Q/MJow6P1mHkbAZBbia2ICvm65FCJrpe4x/DIBKDkVD+Nc
	sGDiiCLwUkKy8NOBQjMAHFWvzY5UQ+hDy0Tci54NMuYFHKzkgAXciRPIO5f8iXk=
X-Gm-Gg: ASbGncv+EdeCm+AsJGphQacxi7950QSj/fRV9xvvNmQt0ef7kd1gTH+gtpiV5npGSu0
	N0pPbx5cmlj3OhWFs/aRel6TWfkohFOR0OPUV/T20AkM7xnhkX5MzD71NqiCP7Cp7y7tDQwQwxZ
	oQXskMvNAq6TWrNEZD8qDgXivrZh6VIcIaHI8Vu6tHPAOP5Cyi9gTb8jpL+i12rGriSNlcyYtzg
	TIP3GeyXDnQRr+7BeFC/D1me4oBAb+PIAneexpQZ1z9OSJiM3wW2i2VL8CQKzW4E7JSOJv/ekkg
	Thq1Bl1+wp3d9jlEdTNy0TJHGWRlEaGNyzT2fUnWE7fm
X-Google-Smtp-Source: AGHT+IFV6DhukzDJTQhxKL2T76dlm4rDEmTDcVzAIQ6vxy9qm1/fBJU2mGtWaSFzbonBb3tr3G7FIw==
X-Received: by 2002:a05:6a20:a11b:b0:1ee:efa5:6573 with SMTP id adf61e73a8af0-1fa43cbf794mr1071010637.8.1742236472852;
        Mon, 17 Mar 2025 11:34:32 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711695a2esm8188770b3a.144.2025.03.17.11.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 11:34:32 -0700 (PDT)
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
Subject: [PATCH v6 07/18] exec/exec-all: remove dependency on cpu.h
Date: Mon, 17 Mar 2025 11:34:06 -0700
Message-Id: <20250317183417.285700-8-pierrick.bouvier@linaro.org>
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

Previous commit changed files relying transitively on it.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/exec-all.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/exec/exec-all.h b/include/exec/exec-all.h
index dd5c40f2233..19b0eda44a7 100644
--- a/include/exec/exec-all.h
+++ b/include/exec/exec-all.h
@@ -20,7 +20,6 @@
 #ifndef EXEC_ALL_H
 #define EXEC_ALL_H
 
-#include "cpu.h"
 #if defined(CONFIG_USER_ONLY)
 #include "exec/cpu_ldst.h"
 #endif
-- 
2.39.5


