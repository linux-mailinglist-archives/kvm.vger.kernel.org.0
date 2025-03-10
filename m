Return-Path: <kvm+bounces-40556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 00FF3A58B5E
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 06:00:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F0D516912A
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 04:59:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDE011C3C1C;
	Mon, 10 Mar 2025 04:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vZIjh1Be"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECDD1CF284
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 04:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741582744; cv=none; b=WBmJ+fkQjRO9XCLk5VFx/HnM2QYEN0NHOV9ebz+jO0lh7fNzQmunpYYRLnfWDw90aE0AVgMwVc9MpDRHa2cKgr8vTOo5GkJOzesw7StxeA3Dce/cFllcGGQcrPgIF8SoEr2ArM9xfvIBdJYuYUWbP5Il2ZBmVQysRf5OhqicJ0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741582744; c=relaxed/simple;
	bh=b3rEPrQgLRgTib5sQ2WJI8zvKOaN9PriF2H0JHg3XvM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VqC9vdIM8+1B3kuOjGszj9fVvzitrcv1QUeBaMWKWNAkizc+7xwtQwKo5bN+VfZG0UTRslwUKbibNVt1RUI8wNlTg+t+9oD5vJ9zOAu3o4lQjO9LvBKq05MEMc9G6yevFd3HOPwe1bbQ6QeOCIof6BtMa4fcgJdj5iyvnwkXLWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vZIjh1Be; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2243803b776so52191085ad.0
        for <kvm@vger.kernel.org>; Sun, 09 Mar 2025 21:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741582742; x=1742187542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pcOq/B0qkF7oBYEuLqTVXYwaTmG9K1DoxB38gebkidU=;
        b=vZIjh1BeCac/CpGkX3hkmkeLVMe/u1QoIbrmwZ2XhvePj/IVHeEtjpP+urKsRT3hrA
         oYO7JTY/ZZY8xGvjtMv0XcW44CCOifutLCNYpDngIaR7RihFwfct0X+bmcchulpsWzqk
         CYEfNmTIr3eY8/ygIVgbMIUf2kmDjMg/0EGfodtanzAU+KRYWjZ2z705imptPVLynBEC
         f1OBgjHXJYspgsPaWjf0rE/s4szCGyn62FpnIheC8BsdVt3zPi5nT5SkG2a9Uo4oDYjM
         oRIV+9kqjcRVyupMpjh0FzeJ1PWGCkAErEsvZKjH30QGGmAfHe/UrpihmG609SGOPFU9
         gefA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741582742; x=1742187542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pcOq/B0qkF7oBYEuLqTVXYwaTmG9K1DoxB38gebkidU=;
        b=O5BN59viWfIzolHD73aZ7ubW7eTtwrHWZ5A00sj2MLdiXUawbn150aWSzHfpO8xqmk
         MzpSx4EQAiwliT6tnHS9qbGRVtiaMT/tCkAo7ZJG0cCSbLWEvVxUzhlj0sr27vglL60f
         FGkxcih0bnOC+Z15f5TNou7HTdT0AAABnNPmfidCcBy4qxypRBsTUw1wkKyABhJdgmZU
         dIKV3BSUf0rXEErjqchYZPpF+jiZjgnclAPk914jFFazpx89/xmryNlEYz2wNAoh9Hs4
         uZ5KKG798un1Ff5PrFtsO2L/CnoJ2p0jPJymsWdtb1gk5JpzALG4bgJojcXME/yCtj6X
         XP+A==
X-Forwarded-Encrypted: i=1; AJvYcCUZ0W6PWSyitEuGUb/KT+eB9aD3bea/fAS4iT6amnKRvfSB036jOWIM7biE+1dqfBDT7Mw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy4FZwK3OzGfZKlB0bizyRv1jP95yc1tvTh5nAO6w882AxJTNf
	IcVPX6DPyZ7IC4MJVDV7SaUhklA+MXhbOVvjHaRu8nm5/KSCcx3M9Y+kGKXlapk=
X-Gm-Gg: ASbGncvZJkAHLqW9kg/3b8zyqdu0HuFm3wyZrwXgsLqNYvol2J4H3PKaviNr/8dCmwQ
	vH0KReE1QxvWDPdx9T8EUY/i9RUkF6O7XM1be2UPAmVGzdQ6I33SKkrDDn1QK6IYFCk2teDa00K
	JaeUTGYOGuI5t9iy8twRTIC5SYUbDFTDj6vZi5LwMwopAU1/+rFbtIJ+Bi1QSZpB5jDfgkqB8k/
	HvhEVxSHcHX8o+PH3rvHE/ee32/g59NR549rD15OpzGvQE2q76Qq6iua81Uc/BthhEaec4qbfG4
	O68320tfp5vUa8zJq+grnNHm85K0ZPlpdRAfCdjB5epl
X-Google-Smtp-Source: AGHT+IEEpEpujiC2fwj7VGkMO+uHTookE/oxRvy3WzoSDUTK3dbiUUraMl3feFU8Mr38LhiryglRJw==
X-Received: by 2002:a05:6a21:8dc2:b0:1ee:c1b2:76d4 with SMTP id adf61e73a8af0-1f544f67b54mr22292031637.40.1741582742058;
        Sun, 09 Mar 2025 21:59:02 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736d2ae318csm1708308b3a.53.2025.03.09.21.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Mar 2025 21:59:01 -0700 (PDT)
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
Subject: [PATCH 10/16] exec/ram_addr: remove dependency on cpu.h
Date: Sun,  9 Mar 2025 21:58:36 -0700
Message-Id: <20250310045842.2650784-11-pierrick.bouvier@linaro.org>
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
 include/exec/ram_addr.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
index 3d8df4edf15..7c011fadd11 100644
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


