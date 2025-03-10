Return-Path: <kvm+bounces-40554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A816BA58B5A
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 05:59:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 22CAC7A448B
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 04:58:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D9151C3BE0;
	Mon, 10 Mar 2025 04:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wCSr9kqw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE951CB337
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 04:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741582741; cv=none; b=GP02rm9WJV+/U3X3Nc7RmxTv97+rN//+88h/11eQko8M5xSOms1J1WTRAJSo3x9cjAsqXZJaQdyJuBLDePDvmDjOSOOaAMF7teXKmMU3zcgLE50TqfhI7eqaqEeaBKa+/En3vAwmaz+HP6GVLJgva/573eJdAUcQKwjAL3GYacY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741582741; c=relaxed/simple;
	bh=zb9oJzuMhuECChWGG74rp5f7LMy/8l0GIXuIkrWua8Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rvoGPjkQtzUWXQSFsgXbDpqrBy1qx9II47EXTvrM7oYDW8a8x+aWuBKLmRwTpw+0I/eBJjBfvULfVvoGBzxMNeVXyVaRY9xzt+/DPyKs4t3Aeqf5o+HOsCzA8fAMU5SYpS55LoBM1GEpdwdOpPpI85WTMINqq0eMXx8azDNnBS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wCSr9kqw; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22438c356c8so34966725ad.1
        for <kvm@vger.kernel.org>; Sun, 09 Mar 2025 21:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741582739; x=1742187539; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nnRQREfY8a8hSo7O5I1BTgAG3l8eG/Rc3wUh1Oiddgs=;
        b=wCSr9kqwPknrzRxmpVqCuv0oC12J740XdkpzF9ttXdFKxxtPWhEq0s966AofzXy54k
         uVBHhWRcGzBLvNnsk3FpJyqO5By/U9Pbmjt9F9yu8hj9MwcORMGVVAVReO9Xm9b+LzDO
         m9fSZzexpdacHnKqE0eC8UFT1PzFzQpLOPqhwmZg9XauwyDoveBRkcJwu4XFTRHl3EaZ
         NGfgYxtQUa9vAx0uWaGP7aQoYKPduX+nAIqc1fUM1J2yO+GBHAYNwpdjUoIo3/DrBdd9
         FaovXFsNAWKofkBD/VvTVRocxCUbux7EG7wWluZNG2amXVP90hQ26QoOIFyFJ2ZE32H1
         QlJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741582739; x=1742187539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nnRQREfY8a8hSo7O5I1BTgAG3l8eG/Rc3wUh1Oiddgs=;
        b=EIsNQI38kqLWrgBmzUBfYhuKBM60wGp/MjJheM0N2s1V+wxu569d4QTkDfE3XkvzGu
         sZYl/TjGMYdPYxRIZ5q+t1ikF1q0WbZOkkbBWVoVSMbVSTKiIgmHQuC0pU+5VkklI5K6
         GGHmGpDVkcNAcE0CmRvUj+rKVZDNtRuh7Da7sljoHWbNoiyorLj129VyE63N+cvWmFSO
         Q8Yuj3dTvVH4cS7KcvpYQZIBlTeSvIINMwEc4eveI0/SNEh4dTQF44GRZzFCZSWicdMF
         DQmNqotgyR0e7CAZSAW/huVY3U8vd1lZ074ByIWz5fgvLFPWBPc2D21t2rSm3ihgfl3/
         d5kw==
X-Forwarded-Encrypted: i=1; AJvYcCV70qGE3jF6P4ywoNomW6Yto4eFA3MreXWx9OCiEOGIXmu208EpcXsRRwR0KUWJ2Npv1WA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiGgJXshkiycZRVbIbxcOyTlcRtDIBQY6tF4/rFOp1goRcflDi
	nuRrhP0lAyMrnVzPEM/iTJPQZcILVPUrgtAD5UhibuVcJbu0iKGRSf7kP6rrV2Z7qYEO5Ff2tZS
	gFHc=
X-Gm-Gg: ASbGncuT8KWJ1unGFtdvjheKPutT+2fSp/MqjpY00OBYllqzpObI0U8tFAgB1xwF27/
	OKf4rYFgdhrxMXz5cTW/kUN0KsKc7FlmswOM3l81L0ASU5QM3yMVfopWmtB3FxoC17RdYAYfmR8
	fgWKj95vG3B8/rcpmcWwKEeAVZpwPIQgO1dehaWRUnzpDveLiopGQzJ2TwsIazv8l4aKFsnaaxe
	wsbLlMwMAsvmbkSsbJeUkeSq59Mi4JOi0VgBmceJESwJ7r/WYWhjTXEocJqe59clXHiPC8oFi57
	kjBA2KNCJvEJK4M0h4167vi0ebScDxsePcscdZoKCGP/
X-Google-Smtp-Source: AGHT+IHAsq4Y63EYcwwuW/i7zg2X2liiOFC3cUgAGGWfi3nL4Ogmzyt5TH8VxxgwmAwHkd5TSMj4Zg==
X-Received: by 2002:a05:6a00:3e29:b0:736:5ee3:64d5 with SMTP id d2e1a72fcca58-736aaaed79amr16963023b3a.23.1741582739550;
        Sun, 09 Mar 2025 21:58:59 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736d2ae318csm1708308b3a.53.2025.03.09.21.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Mar 2025 21:58:59 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	kvm@vger.kernel.org,
	Peter Xu <peterx@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	manos.pitsidianakis@linaro.org,
	qemu-riscv@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 08/16] exec/exec-all: remove dependency on cpu.h
Date: Sun,  9 Mar 2025 21:58:34 -0700
Message-Id: <20250310045842.2650784-9-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
References: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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


