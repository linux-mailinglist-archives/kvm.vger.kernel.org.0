Return-Path: <kvm+bounces-41095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03E5DA617C6
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:33:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D2373B9F98
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 17:32:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A910204F7D;
	Fri, 14 Mar 2025 17:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ob2pswC2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D18204C10
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 17:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741973516; cv=none; b=TbkWEa78tlhasu1v3F/rpP7o1qDbw60kjduAw8JJ4feVriIkv/hLcLn2hLwZR8D6dVZWG58KmHyxX7Io1haZxIkFEaDtA7vbhHofAF+lQ3Rkbs7IjqyhmJqNf9A1QgYIsqH2cQCKoita+vqFaqmxxFbwXQAbLMuukL+WyhsKbSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741973516; c=relaxed/simple;
	bh=072rJgb1v8WTOR3ndNWM1YDjHaA2UGkZkEMRddxYphA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n77+LwTiKvHbMCUMulweupHlwBu/nLTAp1fhmh4xUwMqLWehGO9fBStCZS/lZDbULiPtIT03ZxGRcuNUYrbbIyoWerQO6DzRnjlYrNkRk3HuGNRFCbc2QMfovrrh2qqUDrMRcZ3w6Vkj4ENl9lu3G0KXdxKKTsxhFnhg3DQ/AF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ob2pswC2; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-225d66a4839so27410655ad.1
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741973514; x=1742578314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rp8GQC6vA5rTxSSazblnkjuLZPjrJAYUOFg9uGM493s=;
        b=Ob2pswC2yBJQ/a5tT28NTCSNyMdjS/bg/jViulL+GxKQnEie7++pxLo+uBa0FB1e99
         TkAXFsyLDGxu1eUThqJJcAyGqdNDQqc/ySAJIinBWcdGjyyE7hTvmCVGIkHtg3Lv4DSP
         22O6JXhDhBM1cr3tV1bQpB9brUYoqzTUVxg+YhsF74RnpbQrt/81/FznwOJN6WgZWx4D
         ypqOuBfzlZAgWrBV6K0yZlq8BkmxpbNoFnWW1c9o3OugUJXiCtwt1TOKNdBYy5y8Tyxb
         bA+jTJnKPc9pP4IaWjRkRDDcyo5V+GolLrGgbJsWVKP81BIp0gfc2LyeMs63eX+Cyfuh
         331A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741973514; x=1742578314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rp8GQC6vA5rTxSSazblnkjuLZPjrJAYUOFg9uGM493s=;
        b=ODzYfkGQk7D4X1opSw1Vb6xaABvXALfKBJ4WvXogvUqe8h9crLWPHm9SBKpDrFvp+h
         ueelB7LHHGI7Qv1fjdtBq/hEEi4kjz46z7Z+dhWwOD4iuINuTOe8/zW9ONfbLI+oCOfr
         RL09nD2YWlyET0BJG8sZmk21O5pWTQpoZbwTcRNyh+vr39i6mOKAgQOe2APzuwb6xJ5R
         Xx4KRf+3W2Pm4QbaZECSjaY26e67Abfbi090wGd06HHeH6TtxpyRIpvMV+ZAju40Ghig
         qd7g/IXPezQPGEzLSxVBNT3qUrzaKcxGPESWEQLxfJ1fwJ8+iuzxpCayWgMd47qZpAcF
         icPw==
X-Forwarded-Encrypted: i=1; AJvYcCURk3ZlywX87v1Wd90NLF75YQ94VpgSgzo6WtpKcZ1qibjO9PkuEbWbUowxAZa7dGDZV+Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxB1YYSE6mKof+GkgTtPbV1b6nRVXyaVNO2l1X5UDuHfQfSNq2v
	9c2MdgEefRULKv/WPnnQZlT0z/KfDPRnvYU6ly+A5cpXkkjvWXwbO2F6BUotYWQ=
X-Gm-Gg: ASbGncs16cMa/c3DpVZGqlvqSZzFWZN6td0oSZdTTgJFc3aG5ZC9yjoZdzOVIvr+pav
	+LGuhGjEbs/Re3DEwCqgrZ+44khZp1eAqOIM1UBDNvUxeBs1A15grcRsrZaeU4w752y0/v1FVEP
	V/nULYz5rMZqZvugsYYZzLOxggBjx8AtqOFY90D9LtoC0OZ6dg3Pzpz+Fh1TXucDu/o2gtLarYH
	HWBQ+2AFcFv3laQtBuzwMij7rR/UiDwkysqITtuw+Tu/3etsklsA1lk6n6yCeHw8+pPo6Ha3eKB
	a6zb5IXGIv0BVPzqxjErEuUsCj3qPAuLPJFIJzBb7uJp
X-Google-Smtp-Source: AGHT+IGePgTU4KS0V7kjk76bTSqsHMsJJFpsZKEW9Y9cBbqNQCd9EST3S+oni0XLMdUtO/XVrzydIg==
X-Received: by 2002:a05:6a20:728d:b0:1f5:9cdc:54bb with SMTP id adf61e73a8af0-1f5b07bb133mr8380424637.11.1741973514284;
        Fri, 14 Mar 2025 10:31:54 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9cd03bsm2990529a12.8.2025.03.14.10.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 10:31:53 -0700 (PDT)
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
Subject: [PATCH v5 08/17] exec/memory-internal: remove dependency on cpu.h
Date: Fri, 14 Mar 2025 10:31:30 -0700
Message-Id: <20250314173139.2122904-9-pierrick.bouvier@linaro.org>
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


