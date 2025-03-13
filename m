Return-Path: <kvm+bounces-40959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 98A1EA5FC0C
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:40:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5F25B7A79FD
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:39:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C10F926A0F9;
	Thu, 13 Mar 2025 16:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fHXQLzst"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D73F268FEF
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 16:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741883965; cv=none; b=NhTQdetZjCo69cGFyK9I+cvX+0SsuGN59Yhhmnqz66OLxDSULufJgZAMF3ytthahfeQklc/6hv7VeogivGBGJyCFyd4+rxZpNcmVNIl5+MKdBPpZroorHEoMrwzIH550eKYWdoKe9EpxH30L0vPdiZfR/6xFKiHoHTDsewibvPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741883965; c=relaxed/simple;
	bh=eZxW1HUQDLqOK64QD3ZvyFTEod5DwQVKTFd8dmVQepY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hYDmRzOcHwnL2RvHx0gz4zQOo/G1QADwjcMcq1Tw/7/WjhMj3kWojDTnzOnZThvZCA/eGarVmZ0JwpUwfkV9F0291hUB2WmNCiGIfFLhjcEwqcAYGN2m0OszD+R7Mr6fziJE3hdYi/BsImggIMZ36bj+DOoAfDOvkJ0yOgAnO5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fHXQLzst; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-22548a28d0cso35819365ad.3
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741883963; x=1742488763; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BsftdeZcZ0LsVJ43Vlgc1kB7SrUHDvnjwuIeYSteybs=;
        b=fHXQLzstdzumzZrdn9Dg2HpmiOnS1ME4cP2T/jZn3VOmE2qpPjhfLPT9dOGZyaENCC
         qdIVjiaKdiBuYnwE011t3K4Eau+vDvILX4G82F9K6o5+GdxuDrQHRvuike76hSvZ7TIN
         gJbF0WneG1fZu0rpFtiH93xiHzFZ+TvbsBwZLO8qufcDQT5ymTjcKfuCqMg4ScRpNFF5
         RqDQjYVmwEGgCDJxEK6hgk09NuPjgEi5ic2SbmErYpVXa3uD1NVn1v3UUQtNqy2J/RE3
         24h7qQmf50UB4joXC9FbhUyZPq4jeGBFlJPWFta3sTmoiEoi9RLFP04VVG1fn9epIPka
         Q2IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741883963; x=1742488763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BsftdeZcZ0LsVJ43Vlgc1kB7SrUHDvnjwuIeYSteybs=;
        b=NEYZMQz/tr69P1MGaOPxe9zKTvJy6N6A/VKr+dPc1QjaLJoYg+Z52CQfj8H2V4JY4a
         /HkYVHx5kPnXteEBaIiNXITZTdzJ7ezRMjtS6Cfgw1NsUvMe4rTvd/C9zjGVKyOaNcjC
         5F2EDc+6Em88Dd1m5/b7tQKosBUKiiUBilKxCDJ31tBLjVgIPPpIfQPlJT3o1o/mDzR5
         tS3I8jgBGkbsQISftNkMbBHqWlNZaN2nMksW+tIyLzIK+JCtIlEoKeANRanLViKXsKAU
         4Sp/KVdyfrsHES6GdSiZfncgq3/KaN0R/YKr43SgJmnyHyW8rKQ88EkxZ/LoQA6vJZ+W
         Tu9g==
X-Forwarded-Encrypted: i=1; AJvYcCUI3hf3LWz7SaXPKVX2/mxOhwU3hkt2Kt2MiAm/vEZpeMpawI/OLbLNWsorQT0OZY+JGao=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5i8QXb8OBTO5Pyjji8gBO2cXZpa/UD9UeTmWItasF0IQk+1yd
	Nta6XES4sqciX6V35MA8bAJwDvMtl59HvPyuAs6I9OsgH6hmiCHOdM45w6TJ6n0=
X-Gm-Gg: ASbGncuFBWtESJeSsGYJoxgiklZBP6Q0KQ0yPlDN3qCpS6OT/RAz8rHF6sn0SoFny6b
	Li8qnZ+9QNpftm8+o7IWc+2F5L3zhBdNqMNXBYBvYim/vKppVxsUEc3AQMuggUrgtM9+I36f2Zm
	5abjK9wEtv634qgV0Wia5B4nh2z/eRMgzacQtqO50rlIEgot3n7DYIgPBUqq9ol7gfTz7eoV+nT
	KZXPbi6d2LLedo9Y48OLXl4RrmmE412XZHoqPjdK2pDHnfotI6nAfBakR3TFuBjVco/NgpC+ecs
	fnQkYhLhxValISuXqR38A0N22wCgwqGZkv5N11DjXskTEIFZCiWrhGM=
X-Google-Smtp-Source: AGHT+IFA5iTR0M+uWE9BgHbKNSK5QhTOV/p9oDq/Jx41glVxwyMkriyoe5Nv+AlfRyMJQR/e/whMeQ==
X-Received: by 2002:a17:902:d4c8:b0:224:1074:638e with SMTP id d9443c01a7336-225dd8ec5f6mr2405345ad.52.1741883962943;
        Thu, 13 Mar 2025 09:39:22 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30119265938sm4020084a91.39.2025.03.13.09.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 09:39:22 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	xen-devel@lists.xenproject.org,
	Peter Xu <peterx@redhat.com>,
	alex.bennee@linaro.org,
	manos.pitsidianakis@linaro.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Weiwei Li <liwei1518@gmail.com>,
	qemu-riscv@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 10/17] system/kvm: make kvm_flush_coalesced_mmio_buffer() accessible for common code
Date: Thu, 13 Mar 2025 09:38:56 -0700
Message-Id: <20250313163903.1738581-11-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250313163903.1738581-1-pierrick.bouvier@linaro.org>
References: <20250313163903.1738581-1-pierrick.bouvier@linaro.org>
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


