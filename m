Return-Path: <kvm+bounces-40557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E355FA58B63
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 06:00:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F0BC16913A
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 05:00:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 079AD1D5AC6;
	Mon, 10 Mar 2025 04:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PBK5fYfS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64911D5154
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 04:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741582745; cv=none; b=HlV05ouv/lGn4l8A+iPaudBKuwBbl+T5xJ4R97qbbwGsJc8xykZD3j2PYD2H3VThWHVsFpq5+P/ntP4ccpGg70yQzGvFwZ6/0MXV1xtOgCEgZ7JNcsgiFexbsBQMBhXTGYBkcXqkGKtD3hZwqUwYkGtwqzabCase9R4MwvOQwd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741582745; c=relaxed/simple;
	bh=ZXlx3paqgZcxGYU/yzgZ3nAXgcpELXrJJtwFKW+zuL0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JGrQYNhwvS3jhszI/pxACiXh2U/s4EgK/hes7X+ezUmQrW62O+NhNZ2D+zp7fhHmfPqQO/HMBWWNPiZPlMwVw8L+Z5s1qzOIWWga7q3UjSz3EmYHrNdd950uz01C1f7OIeR764yxbmdgaqBOPtN+4qCk+KMQrMXI22EHvExWHJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PBK5fYfS; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-225477548e1so20296085ad.0
        for <kvm@vger.kernel.org>; Sun, 09 Mar 2025 21:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741582743; x=1742187543; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bTI1e75Far6tkvgIJWf413Q47HXvE/J/3XXxjgsh6yQ=;
        b=PBK5fYfSxbYoZM4HJNMsGenctlIHur4xlisXom/J82QDIFmUn2ZVO9sZLwyxDE1vy7
         I7wIcruhzAHwQ7CiprdHa4dW6EmlDUjkvklHWqDZVL7V8OUr34OmzhG7sAOksPcCqst6
         36N9JjxKPtaQiYb7eFaw9QzhRS4AeJoBdId9M3N1is4Fa61Gllw43fWyJZczmpO6RFhn
         o9dYcmnyipH1edPWR9AuBRCAEK48oIZtEEhkQTOsetTQGtcH4rzprYNj7jm/KB1HZs0w
         oH23gdzfrMjy959XVNj6ZLxLNgv51/55sAEIdlynb9oyyeqZKyw2LU0mG7R+v+CaVE5O
         Kdvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741582743; x=1742187543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bTI1e75Far6tkvgIJWf413Q47HXvE/J/3XXxjgsh6yQ=;
        b=TjRObEt5qSstjG/L37iU0hMTDKH6A6cyt7NNoRbCV91F/ZwzNe6hvMSsI49355UtcQ
         nk0dq6Fvtf8+1F3aLLr07wAqGPtyR2kBG6VArIhCyRPkQS+g6nnvHJOGpXx2+B9TXcCa
         JwsE63MN+PHXbmcmh/pp8Wuvq0OB3d30IoEh5DX+2TiLmMboFgH5HxDb+jHDAWFWhgwN
         X80cZ1Q/+Nu1sudlDrDRnyfy1ChYPavQzQGnuJq+Nd+DO9yZ3EBWvDxLd7uhFqoAFeXy
         /MKrYa/LxGuoZk+cD/dapJFTD2nRAtkAKzsxLS44OcNgf998MSvvxhu3i9rEhM5ZQyos
         vuVg==
X-Forwarded-Encrypted: i=1; AJvYcCVwY8wuZ7eEy6RvBFkvpwG1MY6drZoOovuWCMhMe/F3k8JbnQbP1r89q7Yj92Y2JYaVUSc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyh/hZuqgKDOL3Se1+gL7/efLGSKDqFyNLC4imSt6Wurax/rkEh
	GbFmicTT8bH5y0t01e1IxWuwU/IzDTP0TrPUy7DDe6aQ/aWeCdDcJVNqZ3T4HhQ=
X-Gm-Gg: ASbGncu0LYPD3J/cKy/wgo/U2KJ2z0ZvGrPnFLPXOWvfB+LwvWj7a1bs+l4x1dbAi+2
	hmKrJVOKn3Be7LseMKg5aVpgw370afZDCgsRgbolQVUVAkfjqpE0RkF228MxKxaiq+AxK+zFNHV
	MbkxBAxzEcrlrDk86omIxgMyZoXzJZSNXrR5tHTQEe7lrqXUvyUVdG18tKgklfpshmOKOzP4J11
	osI5e0uVdJv2qkfUzaRWQXVXZsDBsLBlzO0hhgce4i49d3AHuNMPqaGmKqIMsMQNMKxHFsicfYX
	oD5K/OFHDT+ethSa4NTJ20eaz7fLWub9KLuLaQJLH1+0
X-Google-Smtp-Source: AGHT+IEJmFw/36nK1SG72X+BhxhrmIBbQ3tB+znRJTwS+V3kz822OtyZYcKaYIi+o8+TLN45WlwkAA==
X-Received: by 2002:a17:903:32c5:b0:224:3c9:19ae with SMTP id d9443c01a7336-22428c07361mr200227865ad.34.1741582743213;
        Sun, 09 Mar 2025 21:59:03 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736d2ae318csm1708308b3a.53.2025.03.09.21.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Mar 2025 21:59:02 -0700 (PDT)
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
Subject: [PATCH 11/16] system/kvm: make kvm_flush_coalesced_mmio_buffer() accessible for common code
Date: Sun,  9 Mar 2025 21:58:37 -0700
Message-Id: <20250310045842.2650784-12-pierrick.bouvier@linaro.org>
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

This function is used by system/physmem.c will be turn into common code
in next commit.

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


