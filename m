Return-Path: <kvm+bounces-40731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 91332A5B7D6
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 05:10:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DA00D7A8AC4
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 04:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C32E21ABBF;
	Tue, 11 Mar 2025 04:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pTbD6nMG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AFB1EB1B4
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 04:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741666150; cv=none; b=DSwmcNSBJ31qIgqsSle2Y46xmDt37MdrWMfO3SbW5nNj/1M71X2NXE6bEhyhPz3RNEh8TXXTNV16fxKgPWC9CjN4Oae+jRj0Mr0kWcRKt4HkJ/5oLTWuCj+q6wTmsQSHyskeL13rxJpGZcsfxXAw9CfImxCR6XleMMBJBh0cpsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741666150; c=relaxed/simple;
	bh=QIQStCNyWEbmJbGI98mgn/wF6l0/5wE9kpHfnd49aRg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YX7hsnpQfpGZzMxYUr2uFd4+p+OYuMHztJcpH9pNlncGoCFhHaQDJwLdtf2/tZ27+QGAep33DkH4iFfiGZvCIDivYoghwWanS6syi5pHyU502UfEtnEaYvJdp2KZw77biET4VskO5PMsvIklwNYMgg+1vjEBK8K/Q+D4kgDfkKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pTbD6nMG; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-225477548e1so45550835ad.0
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 21:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741666149; x=1742270949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lSQnGpOqRDw3w//OvJparnGxlKjvigYzwQgvxmVvIU4=;
        b=pTbD6nMGyIS8OKs4hgQROjEmkEibEl6sRSdOjTYHydneVe3+kiDaszUnoVJzGy/aRm
         Qv1Wuz92XSaMVnvAwFHVkmiCC0Nay6bTmOfwM85gjbVVhLAM2AnYV6ENiJkh3FLMMMM7
         OWH9x4PXrv6v4RlkPKzoSoL3evJVEqYxlMJyTrjuc40u+hd72Mve/g2EKSC+mwUuLV5w
         qQCmZHlCXYCRyWdPDd02yDmOrrrK9G7mC2IjwJ5qGJBlL5bP3WJe8n5BzrNObdHs1Emv
         cdbg7LpC+W4ouzeb5PFglK6+4QhslhWKG0Th1xTX1+OAeYjk26mOtX39y6DREApxTWMd
         QWug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741666149; x=1742270949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lSQnGpOqRDw3w//OvJparnGxlKjvigYzwQgvxmVvIU4=;
        b=w/xP8EtI+Fxbx1vHKf9xCXEMCLR3DS1AKs7560fmADnQqeYzBvTVM3DnpSeR8Nc/A+
         oFIQHEqoQYXdlasBnrmRkYHvlb1N/WNX/i6CR42rigbZx1jADKSGNzdQO7DtJxqTBSZ1
         Rvxv2aMRuQiNCU2OBv5m6ulmS7raNVrRa4MBQsGZ7TXs5j12PijyZMJudnPe/l3foFun
         BEpOjL8pwVgcfshh6OUWZYoql0KKFuWgrvnPz1zSm7ct5NG93To0hW6vKZvhNw1Ga5FT
         aNSrjZXxzeIFgWwIc/9x7sG+G92onyU7hSMXzjIOv9ZjuWW5E7/tAwhzi9yhvMeA4tin
         bpbA==
X-Forwarded-Encrypted: i=1; AJvYcCWe4WSscL+uAI3vCHYNHgSQD9kNoSpb76cfUQNxgrSoedmRKgZ4+bJ125YpUsO4FpTJL3Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiXD3FHdY0V79xfW7sG/hYxEBtroD7A68yPEox5rDlXiNPEP6z
	grwP9r/Uy59oYy8Sk1sOyNs+O1C6pAxUZ/mW8I5VKiuQei/mVITkh+LZAoTr1l8=
X-Gm-Gg: ASbGncv2k7yLCKCvDke1uQAtUeRz7sO9U5R8WL69bXw22K/ttpvRTv0qhaHTF4ExikW
	XSYdxAAxSI0eDgj1LMLJ9mxYIPwf0Wa/rvy66iiBOrU5/SPJJ9CfjqOtenJjmlxbYgZpVtqujkw
	XXDXGfC2fF4dmXPdxuGDxdrlEkMVrR5TXbfY58roq8ZpXxkwNeESuRMt0d5YAE2EU84QANAbNC3
	4TQ3h5Q5hlnZsrlopMZXt11DUdL27oTn8BDfPEYUU9PGnbqXYVocNgUoeNG4CZE6LLAudYGuokt
	vg8nG5mZkr8OG2j8DtTyJGvjfqx5AbYm5jmcfNUtlKUI0rXaSlf9aoA=
X-Google-Smtp-Source: AGHT+IGAtyqJ8JwUWzZUpShXBSvpRNbrwAinE/LFxHiM0RsFVnA1TPY911KWPkY4EkoTDg/0IjRi5A==
X-Received: by 2002:a05:6a00:23cb:b0:736:55ec:ea8b with SMTP id d2e1a72fcca58-736e1b3e670mr7549220b3a.24.1741666147270;
        Mon, 10 Mar 2025 21:09:07 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af28c0339cesm7324454a12.46.2025.03.10.21.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 21:09:06 -0700 (PDT)
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
Subject: [PATCH v2 09/16] exec/ram_addr: remove dependency on cpu.h
Date: Mon, 10 Mar 2025 21:08:31 -0700
Message-Id: <20250311040838.3937136-10-pierrick.bouvier@linaro.org>
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


