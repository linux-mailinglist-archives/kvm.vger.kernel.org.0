Return-Path: <kvm+bounces-41297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59B50A65CBB
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 19:35:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 66E487AA95D
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 343071EBFE6;
	Mon, 17 Mar 2025 18:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JvU1Xktd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B8F1EB1AD
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 18:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742236478; cv=none; b=RIRxyrj38y/JdwM+wni41L0oX1kqiUtpuGbLIefw//R+/96GMOgAy5MtBrJJerGjRhBKLBllBHnTsx1ZMqAh55SZLAArYrunXlMILt50Tspkn3JqGAf6+N3yfr40gXoFAFiCyJG6mI4pUi7npctr+x28GLCdqcFnP/NrQmd6fBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742236478; c=relaxed/simple;
	bh=eZxW1HUQDLqOK64QD3ZvyFTEod5DwQVKTFd8dmVQepY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dvkMPA2+NaquOWyLmkCKvq58svg+8/dOyuXCD03W8Pj1O6tNyEnyREZHiHiq+MWJ159XiLzuH7WVy8EznI8JK173RMh6bBLhRe3gdIv/FyZH//bmyPW2XbHcH0VeW9djCepsFioQ1AVeVXs/nYjvg9kzAxma/Wpzc6FxWt4Aoz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JvU1Xktd; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-225df540edcso61414305ad.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 11:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742236476; x=1742841276; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BsftdeZcZ0LsVJ43Vlgc1kB7SrUHDvnjwuIeYSteybs=;
        b=JvU1XktdPr825gXA9WP9zn1CeD4kjniwihek21Zh+8tc0XfBFNa8o+AMFhMZvOClaq
         Kk8R4n9hKAjOqG4yK4CJGniOoTryO0HVHlS386v7mKjPeFdM49Ft6GExHhN83Gx37j8A
         gGacbMRvfMdziSc4wTVfO4rb8cyy1upBbtC+uL9oyxPfmTPU+nxWNUf3QThOvxhtS+ii
         aEYu1tmnEgydXrnqt0gzF8cRnmFaKfrsskrJ75VM8ZhJpbUn7alshAHtB20BWapr7RIU
         U52DdW9w2sB3Hcku4oUJ0NQX4EClQvIxq7WDAXqp8alOqxKXmUOSgwOX3yUkmcwpp/sJ
         LzIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742236476; x=1742841276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BsftdeZcZ0LsVJ43Vlgc1kB7SrUHDvnjwuIeYSteybs=;
        b=CjlShHdnXL/0VAhou0n20nnJ+tunuGdfmgoh407D4fOH9D+beOUoGYaXB4jWWlDXMa
         IkZftB/FOboJkx4o4v51xbD9u5n2oSu8cj8gdcI70YjKe3xf/P6yqRNlt1jXcpaRtNrq
         OyjqBRNEGskpT6Ovl1OmZkQuU4c34EdThyU99nDBbETmag9zoxr1xDWWshorXp/xAxdp
         limTh/YOIub8BYsk2dtWXXm+QNmSoBnoSwb0EO5M5w83JfZrfSyOcXlkRMwCEhRsyq2N
         sJ/EpaIHlD8Tyie1ZRWkaPLNOSSDRUjS799ykGMyNQM+oP8t6tCQlO4luV2QcMcgi4ns
         Lfww==
X-Forwarded-Encrypted: i=1; AJvYcCXFhEfcVdngaMLITFfWWOckhJ5IqIPFOOuQfrOJUJd1drvaKn3m4l97IB4Gi74Q0vmom2o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7/0GuPI3kYwHicnK7HeN6F8p6JINWoaGdMJjl6ZQ2ur0qUcuq
	txkTP0rSIlLwhXnBTWbyx54eCYQrkizHE2kApg8XFVo2xoTMhRZjL6mB3rQv690=
X-Gm-Gg: ASbGncvo9KupDpaiCgP8FK4fCBtWVoFF1jGZUJ7JXX3u7uLPoFpD48FRTW7GsC0ZoXa
	eWFUXyT9sGIMv22brRViEsvM2Qdr7LhHqYdg1tT767yi7dHGZLQbDSb/gjGNe0ZQQey2Z9boAy7
	vEKCuwBbumfwAl4nrz2eoiJbsXhWY1koYqsrDtv81vAEXE/n0bW0Kw6YkIKFCBDGLnrEvAfr65e
	g5VW8Ox2aXpyqGyYiHjpxN74vw8njsp7lUdv5z24Nj9uv54Mw+z1iqCwRmcaeeg0hTKaqCXHPHi
	X++XLelo+LvnoMqkZHQuRJkz4aGhGHms75zAnLqh7snv
X-Google-Smtp-Source: AGHT+IFrc3E9fUAh+z3i68X6oJdtySmjNUcFSLSYjTurJl9vG25uO/0RkrUhFSmr8bwDc6/U+8pjrQ==
X-Received: by 2002:a05:6a00:3b8e:b0:736:b400:b58f with SMTP id d2e1a72fcca58-7375752916dmr715700b3a.0.1742236476193;
        Mon, 17 Mar 2025 11:34:36 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711695a2esm8188770b3a.144.2025.03.17.11.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 11:34:35 -0700 (PDT)
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
Subject: [PATCH v6 10/18] system/kvm: make kvm_flush_coalesced_mmio_buffer() accessible for common code
Date: Mon, 17 Mar 2025 11:34:09 -0700
Message-Id: <20250317183417.285700-11-pierrick.bouvier@linaro.org>
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

This function is used by system/physmem.c will be turn into common code
in next commit.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/system/kvm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/system/kvm.h b/include/system/kvm.h
index ab17c09a551..21da3b8b052 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -210,11 +210,11 @@ bool kvm_arm_supports_user_irq(void);
 int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
 int kvm_on_sigbus(int code, void *addr);
 
-#ifdef COMPILING_PER_TARGET
-#include "cpu.h"
-
 void kvm_flush_coalesced_mmio_buffer(void);
 
+#ifdef COMPILING_PER_TARGET
+#include "cpu.h"
+
 /**
  * kvm_update_guest_debug(): ensure KVM debug structures updated
  * @cs: the CPUState for this cpu
-- 
2.39.5


