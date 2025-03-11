Return-Path: <kvm+bounces-40728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD79BA5B7D3
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 05:09:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2941E173A2C
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 04:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 124EB1EF38D;
	Tue, 11 Mar 2025 04:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qXpnRrrW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27811E9B1A
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 04:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741666147; cv=none; b=gYsfI0n3X7GOFAWclCPVQzTzKqemaEYv1cHEbLxWeScsuuUay5gV9H5eaEeVxy/rY0/jPyUTOmneeFFw+gP/CB1h8ER52dzF1vKbdEt80r7Kc9YnucdBCUcxp27kd/Ek8omD04pqS/ENR/3cWgrnIyLBfUIXWRd5qWzxFJlx4pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741666147; c=relaxed/simple;
	bh=ow7d7sNoJUkhrGjcKBXehdPsLoswkA7O6GVkimqOLU8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cgyg9aRVI0zFzE3LYx94HO7pzkdcCzc3EzZkT2GMoGyTgK5z/f14+D3/zImOlX2xkM2k+yv4JnsI75+UipSnlGo7EcxnFEujoIJ7SYBZ3pgkbNKNNBQHudJ1dv7mIUYYCG4FSKNxNU4Ad8CxhvqS4eHZazuOF42+elZo12HMnIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qXpnRrrW; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2239c066347so87017795ad.2
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 21:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741666145; x=1742270945; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JJTMw6tkQg2gyyv9VopXfGbD8re6/gGFQNon8Npv7Ak=;
        b=qXpnRrrW5JUaQAK+uZIplarjc1eCafuqZc+OmzDxFfZwh01wtaptMGm+Zvt3lSMw6Q
         Zr0/tLcDWFALUBmZbwGu9jFgqfi9s/wLOYDKAcaJXBTXBEqT7qXTwwrCV4hDM5vQZUwi
         GtiGCpX9Nd6di73SvDZlIBDQXqbt+kgjkgMy7Ebpmme1ksLfaCdsYj0wGEyIsu+7+s9F
         hDyEI2yM7rCUF53ze6RG2X/e2B4ZIM3F+8fXoPqSHnIUqk6BdoGdgD2BGBhq7UP8Qh1e
         eeIWsG0yc/j6HQzTo65rC65Kh7HYTvh2+QwjotkIdsfzELfcQBpRhC9ovWEDkVRo4sRJ
         +tmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741666145; x=1742270945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JJTMw6tkQg2gyyv9VopXfGbD8re6/gGFQNon8Npv7Ak=;
        b=SHcCc60NMwPMy0X1kh/xDzs7MweISYnGtrmMlJLvhyn4ktOZPh8AuQrSTEk0iKrqjx
         avXVoaZgkvFGZwR5wU4owjuVxNxycpeCFm2AiIWw+kiruZIxNayJGpg3PGG90xd+tdJu
         4c6YsPWw4vclFmQyHk9Bgd2Nmdkt9ftAOZ3mQjjNb/7ZIpYZBvJl+rb6YCjM8T/2h/aZ
         oLwyrvr9CB8rwSKXSumy6AAVqKohMRUrrmMYgfbZsRho21zBgiSw9D/M4RzxlgUcre+z
         QT1LtSMHC8Yfovo4FIlxny66JK2cNpVPskFomh2dimLOQ3mpH32kqu2rHgbyyzb5uJ6+
         maxQ==
X-Forwarded-Encrypted: i=1; AJvYcCVX8AFOS/55/RhW3M3cObswVNGhhAHLG7X6ZVbjsCaiXQlYmh9vaRvb24K0/6CSeYk3iSI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3h0Z5Jp2Sn2sizIJsHfEKMp7XmGot5eEB2zwzdDrf0AYzw9P/
	rjHJ8yeREluBYZ4IgLsqcaMsUtRl9QQVAzmqWCMZaRHYxZNa41g9FuzKxaHldwo=
X-Gm-Gg: ASbGncv1CufeP0oympjdPSKep6c4glcRmecyOt7aHcn/8MndkviXbS5gNiPUU8/YNMR
	96NHCjvZ6BRyOrjS/vyUm5akRsjGnwJDip2hxZiC/x9Kf7qnc5nklmocc5MBcA8y8UM9KKTl5lk
	tVm81SLZnlUuJKOslcRPK2HudRulcvH4Z3jJeGmTl7pBFqkFOJE3Q86uMxCPpQ3u4kgx38pCixb
	hINiObWC7hVC1vRzo3tOMVVhwfMFepGpn1KuZDSyJ/BZUISUBykLQ+bnP3JzP/yUSh25qMeiuTu
	0UlolGWpCEw398zM+T437Y5bwNZXdbKOcFtQBNcGLSpzrt3GyGnVsmE=
X-Google-Smtp-Source: AGHT+IEZQz4PbmDcJ14zbyjAyAYIBXfqlvYCPkEDTZUS00hzo0yd+SRkwBCunP0Y6iJa+tBGNAcErA==
X-Received: by 2002:a05:6a20:2d2c:b0:1f5:8221:d68c with SMTP id adf61e73a8af0-1f58221fee5mr8742647637.3.1741666145118;
        Mon, 10 Mar 2025 21:09:05 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af28c0339cesm7324454a12.46.2025.03.10.21.09.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 21:09:04 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	xen-devel@lists.xenproject.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	qemu-riscv@nongnu.org,
	manos.pitsidianakis@linaro.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 07/16] exec/exec-all: remove dependency on cpu.h
Date: Mon, 10 Mar 2025 21:08:29 -0700
Message-Id: <20250311040838.3937136-8-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
References: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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


