Return-Path: <kvm+bounces-8662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A35D85491D
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 13:22:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21A9928F0B1
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 12:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 219791B976;
	Wed, 14 Feb 2024 12:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="fdGZ5Zsx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2791B962
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 12:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707913320; cv=none; b=NTFwJnSN3IBnMfyfww7b8PIAGHcXgzJR+oezOZDKsgTfHBQKUzAPkPS9v5HUWTzVlibsvJUwMSZjWDB18XclzCxDF1FK9gqeaxut4lm1+/+35o1wqqlXsH93o6ZPo1SXvFESWOSf8EiwoiTx/L8NEYYyadKzF7wZC4EcndZ5YYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707913320; c=relaxed/simple;
	bh=gx2vTofXebLP6JVlkEb2oQb0fWvIH2qsTnYAPuwH21U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F3LOFAsFtS3xBPfEccQMtXcg6bRRtH7rWyvzb+wVq2CtyfeK/C+plV3pnTSOqbgPucVipcogrwNV3/tsj9g4PswgpikLH2hQuhGOAaM5tYuYh4EbPprFTbn7xDVKGL3vNthK/109sRIo7yr7pPaSe8HpnRDMUZVO+tPND7nTZeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=fdGZ5Zsx; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e0a4c6c2adso2075473b3a.1
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 04:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1707913317; x=1708518117; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HozRKN9wrxi5PL0DaVXWcH0x0hBsJpBpA/05xqOENN4=;
        b=fdGZ5ZsxBXyJoAAObOgI50zqgqLcYDEeilm9G0M48ymSRbxiaNteGu2M3y+Kifefjw
         +ZJfRfKU/0ulL0NnFJUstghMySfbI6pEhrzYYkHHxVs7LXKTVU8xpsjRKsvdkRCsNwHK
         8AUzgVnk5wv1w/nUWlusrdROlYQgtwMaq6tajLB6tRrD3SOamjiRZx32jyWFxR2P8epO
         4UQxAlKorSLM8bAIvdxtj6zhAZMK4YRsGtdq0GuxkAmTNir7hJORZi8QkKlcwamI9Hmu
         Qp1FpyPXnfTXS+kNXCrD2K62Lb+TeA/3jbdrdM39eR0u72YtSAjwg1fvtT7RAPEJmWYY
         IuEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707913317; x=1708518117;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HozRKN9wrxi5PL0DaVXWcH0x0hBsJpBpA/05xqOENN4=;
        b=e7CPm2lKX2xRS234TetNkm8KjR82G9LkfGiNUGH4V36MZp8CkKlKL1TA2NfOZadD5N
         r314Lh9rt/fLnWqvGZQiZfCXoy1Ma6lQp49AtlE6vqGd4h3g0E6KAnI5Ko/S9wRLC1e2
         +L2rSN/6xOt6MLS5ft7Qn3gEUUoXKGQYBTqa+s4/X+I+CPEHnx0jQ9mYVNaMUM5mMXyI
         2huy0axFPb8KwtHHXvZQBB0y234XR4io6WeWuP0R+uOQAmreAetYziz1d0UqPCVumzmQ
         Q6MQ8BaM7v1gj/t0N8fmNId7+Mbm1S1XmS0ScA6Y1Vas2p34l/Ss9Cgrj0gw4Jyh9djm
         DEGg==
X-Forwarded-Encrypted: i=1; AJvYcCXfJq0OxHkUJxrgNx3YBomAUoqjkPo+vX14yzYheT1w5tMZBP0bqypDSFwGRbQo+8tUl9+joyOrqQyZspOVsO1jT2eB
X-Gm-Message-State: AOJu0YwX6CEGKj9p3z+sWrz4+3mArLdLQi9ARPlPMpouocrqeGWPmyeu
	7gr/MD6hC/vbtsGoImN/hAQ5Z0Gr9bdT7P2+pZcrooJEqNnn5Q1OqqDLMH/6NF8=
X-Google-Smtp-Source: AGHT+IEo4JmWJk3ub2RFwdayKe84WA+0F8fNJd+GmlJi4TdUok/qdLLvqvHeBpKGcRkn55UtAoI53A==
X-Received: by 2002:a05:6a00:1404:b0:6df:f7f3:6197 with SMTP id l4-20020a056a00140400b006dff7f36197mr2541585pfu.34.1707913317244;
        Wed, 14 Feb 2024 04:21:57 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW34+3mvXzC4qP2w5IptkW5t4OtBPxU/G7pTY1dSz+kSE4UlrtO3QKrilk0ho6dh8ikCdl0TVNayWANOJA+rtfdIUkQy0oNb4nN9ZYSF2lXnaGVv/OjkugqbKgWldV4P9JIEZ5GSf6UumzKFXR7lknkDN/oHQV1TvFuc6HTjateSwkDe26D0v0bnosHIeq9t1nagQ5L3N4gH+SMojElCEXdWqLrXjjvOWsYatcccn4q2Bud1H7IBT9FRqD7AZb6vuxEVlFjC+NI45wSRw9w8OIoMFvxbUyW+701ZLIw0Up0bcFnVo7bpSi4qZ8StJlf1Q==
Received: from anup-ubuntu-vm.localdomain ([171.76.87.178])
        by smtp.gmail.com with ESMTPSA id hq26-20020a056a00681a00b006dbdac1595esm9496060pfb.141.2024.02.14.04.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Feb 2024 04:21:56 -0800 (PST)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH 02/10] kvmtool: Fix absence of __packed definition
Date: Wed, 14 Feb 2024 17:51:33 +0530
Message-Id: <20240214122141.305126-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240214122141.305126-1-apatel@ventanamicro.com>
References: <20240214122141.305126-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The absence of __packed definition in kvm/compiler.h cause build
failer after syncing kernel headers with Linux-6.8 because the
kernel header uapi/linux/virtio_pci.h uses __packed for structures.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 include/kvm/compiler.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/kvm/compiler.h b/include/kvm/compiler.h
index 2013a83..dd8a22a 100644
--- a/include/kvm/compiler.h
+++ b/include/kvm/compiler.h
@@ -1,6 +1,8 @@
 #ifndef KVM_COMPILER_H_
 #define KVM_COMPILER_H_
 
+#include <linux/compiler.h>
+
 #ifndef __compiletime_error
 # define __compiletime_error(message)
 #endif
-- 
2.34.1


