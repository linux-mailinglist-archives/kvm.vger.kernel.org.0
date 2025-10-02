Return-Path: <kvm+bounces-59417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B2234BB3560
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 10:51:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA6461887AD9
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 08:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3E8130AAB3;
	Thu,  2 Oct 2025 08:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JHbDhaAB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322522D7DFB
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 08:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759394604; cv=none; b=NHAcMF/MlD5qxDobUxVR8Y87fyGR0w+vHm4sx2d6o9ujLSyCy6MYzdKSYVluM79AAiaLGS65phTQqcdYV+OSOQbTs0JVufJYbl2efgnAIMOe8CD7CsvmEDJQELvJ2dBLB5H8GRtF97ZARSIBf95ZfdmUkuNfxmuTYMzF72HCGLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759394604; c=relaxed/simple;
	bh=e8sThqiZGZe2I32qaeReXXhxnwuuECSVCqLkuahwIBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pW0dRZNZN2JwJNDosI5saPmpYua3i/ka9LAcycu6t5Io2d3bznsW1PK9qE7kbalk5iVleTZT94eN5T1zvdxlTdF6l7uf6I6GziU7Og3i73mcuvo4C5P7SpPiYJeYHN346S8lz9YUIEEPgT2CqvwJFHWQF+pmlcsQjUC99E0uxG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JHbDhaAB; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3ee130237a8so508432f8f.0
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 01:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759394597; x=1759999397; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QAgjr5yIgrIO789GqXuRF0t/EGl13bmDgqvJGL/31ds=;
        b=JHbDhaABeaMnjLX6KC5FUIdEqs4WtRIzSJVfz3SOK5Kcy88tIpzLFNmrWgfM9tPAEj
         WlV4RbIFS6Tqi1+W79Rpfoswmb1pMNxRW8hcpovjtGh8kupGeNY1fORJAhazFe9xlwVz
         Pm39ORTFAhj3vMwhStrzfp/5z7llSUeP7ZWqrx/t/RTz2PNCguqpTp9cqtM89Gj18t/o
         Xkfsk5FBbxtRv6qEfPfc00tyso6ZM1YSIJ5RdwWxXVPU2tcEm6+tYnbMJXmGg1LWzM0I
         rW50uaUlUBoh1Xc5tn1T/s4deXBSVvYf4b1iSWqTkdNqObGpf6BaUovCNXoqDlZk8kol
         7tJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759394597; x=1759999397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QAgjr5yIgrIO789GqXuRF0t/EGl13bmDgqvJGL/31ds=;
        b=glXEln0VmXbJ+ubpqyT9B4L5xhJwaOo3cHeTNqfnu/9vTDn0NqO8K109h0NLNtU575
         yzc8blKol1Lta7UuiCrTCPcxrtFB4RYH8AwUxBE7pllkwfWqdXVAsWu3q0NdBsOZWl6A
         XKoaN9ExxDFpXyRKqBwWXMwhESA2FTCwnsrA75iwQBYdGfnE3n9C+LO4W+9AO9ycECgD
         OHopa5xooSViVhJ8t3dKptgdNAyCjez/2gLqiRgHcOOc/9IUG4q+ew2MPd4gQOm10GBC
         Xvy4bExZnZzgx0nlLQO7SoCMzPEZVAnZXf0We06QGFjmKWgtXYv8ntJq++/GUkfapixi
         HEKQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2hgsB9fNOBH6/s0hTZIY3keEQynepUkce3HShKN7SC4Yy+DohtHAqdxuYMfE1NpALQX4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8wk1trNKTaIWTOiJXYNsTh1zHiei8Os8VmiMnxhy6yvFtBxx3
	tqKfNdwEwUxkFmnsh2DQGP1h4OaUMXFT+5OjD4DOUClRC/++1Du+79grDlDGkosU5zA=
X-Gm-Gg: ASbGnctrHhTreCtYOhmvzVx4v4DmP9L6MMBs0/tX4DAgLLVSS/OpF7ZlBC9C8qzoBLK
	q2bknKWkZfNntCNEymtcNAf7JiTOJdiB9xS6rptfBWyKjqxd3wuotTcWMO7xkAtL4SRMFVTy8eg
	iNE+5/bRc7s+UKhdVuSOYwAbGhKPp4rwa0hWSboJqlrtDh0vEMIrVUtQ15LTpjFObq69cNbAL81
	x8MQHEpQGukC2SEBwNCK3y4dJrr6vbW6wlbwdTfrtWWlwvBa/tSH+ol98Yv0Z51oZ0InJHanFKN
	F3Os08YebnNiGTrvqjiH9fvOknrc7+B868uuS5+3qEsarMrqIdbfTo2hJLj9foKausxjGZHHu4r
	U2MeBw58fVfJ5jVAvbq1RXOaW4Q63nr+ovRUc29/PnWZDq373eD1hvsV2/H10rg4svvBgStxsQS
	dxYmKF72aFHmaOXVJmdknJsXVx4algmg==
X-Google-Smtp-Source: AGHT+IF85XkLg0BRzQXNPalgqzyMpny7LwvkrLwLebNjcVy2x5/oJ5wUtocULaWC8zMsTAEaZEeQKw==
X-Received: by 2002:a05:6000:609:b0:3d7:2284:b20 with SMTP id ffacd0b85a97d-425577ecfe7mr4915156f8f.3.1759394597239;
        Thu, 02 Oct 2025 01:43:17 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8e9762sm2651528f8f.38.2025.10.02.01.43.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Oct 2025 01:43:16 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v4 15/17] system/physmem: Remove legacy cpu_physical_memory_rw()
Date: Thu,  2 Oct 2025 10:42:00 +0200
Message-ID: <20251002084203.63899-16-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002084203.63899-1-philmd@linaro.org>
References: <20251002084203.63899-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The legacy cpu_physical_memory_rw() method is no more used,
remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 docs/devel/loads-stores.rst            |  4 +---
 scripts/coccinelle/exec_rw_const.cocci | 10 ----------
 include/exec/cpu-common.h              |  2 --
 system/physmem.c                       |  7 -------
 4 files changed, 1 insertion(+), 22 deletions(-)

diff --git a/docs/devel/loads-stores.rst b/docs/devel/loads-stores.rst
index f9b565da57a..c906c6509ee 100644
--- a/docs/devel/loads-stores.rst
+++ b/docs/devel/loads-stores.rst
@@ -460,10 +460,8 @@ For new code they are better avoided:
 
 ``cpu_physical_memory_write``
 
-``cpu_physical_memory_rw``
-
 Regexes for git grep:
- - ``\<cpu_physical_memory_\(read\|write\|rw\)\>``
+ - ``\<cpu_physical_memory_\(read\|write\)\>``
 
 ``cpu_memory_rw_debug``
 ~~~~~~~~~~~~~~~~~~~~~~~
diff --git a/scripts/coccinelle/exec_rw_const.cocci b/scripts/coccinelle/exec_rw_const.cocci
index 35ab79e6d74..4c02c94e04e 100644
--- a/scripts/coccinelle/exec_rw_const.cocci
+++ b/scripts/coccinelle/exec_rw_const.cocci
@@ -21,13 +21,6 @@ expression E1, E2, E3, E4, E5;
 + address_space_rw(E1, E2, E3, E4, E5, true)
 |
 
-- cpu_physical_memory_rw(E1, E2, E3, 0)
-+ cpu_physical_memory_rw(E1, E2, E3, false)
-|
-- cpu_physical_memory_rw(E1, E2, E3, 1)
-+ cpu_physical_memory_rw(E1, E2, E3, true)
-|
-
 - cpu_physical_memory_map(E1, E2, 0)
 + cpu_physical_memory_map(E1, E2, false)
 |
@@ -81,9 +74,6 @@ type T;
 + address_space_write_rom(E1, E2, E3, E4, E5)
 |
 
-- cpu_physical_memory_rw(E1, (T *)(E2), E3, E4)
-+ cpu_physical_memory_rw(E1, E2, E3, E4)
-|
 - cpu_physical_memory_read(E1, (T *)(E2), E3)
 + cpu_physical_memory_read(E1, E2, E3)
 |
diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 6e8cb530f6e..910e1c2afb9 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -131,8 +131,6 @@ void cpu_address_space_init(CPUState *cpu, int asidx,
  */
 void cpu_address_space_destroy(CPUState *cpu, int asidx);
 
-void cpu_physical_memory_rw(hwaddr addr, void *buf,
-                            hwaddr len, bool is_write);
 void cpu_physical_memory_read(hwaddr addr, void *buf, hwaddr len);
 void cpu_physical_memory_write(hwaddr addr, const void *buf, hwaddr len);
 void *cpu_physical_memory_map(hwaddr addr,
diff --git a/system/physmem.c b/system/physmem.c
index 23932b63d77..0ff7349fbbf 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3181,13 +3181,6 @@ MemTxResult address_space_set(AddressSpace *as, hwaddr addr,
     return error;
 }
 
-void cpu_physical_memory_rw(hwaddr addr, void *buf,
-                            hwaddr len, bool is_write)
-{
-    address_space_rw(&address_space_memory, addr, MEMTXATTRS_UNSPECIFIED,
-                     buf, len, is_write);
-}
-
 void cpu_physical_memory_read(hwaddr addr, void *buf, hwaddr len)
 {
     address_space_read(&address_space_memory, addr,
-- 
2.51.0


