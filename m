Return-Path: <kvm+bounces-41305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD24BA65CD0
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 19:36:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D65A1887840
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBFFF19048F;
	Mon, 17 Mar 2025 18:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BbikHszG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36421F8ADB
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 18:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742236487; cv=none; b=U7InDEpHm2q7vJl4tShGN0gvXc0IEWF64Qyv1P7Wec7GNiiTIhEk2rwdwJy9sMdTG1BeVPvxljVdDXqFU6j3FyDWLuUNA27Zdq9ns2FX8lSJTfbZie+8ZS9pK5BFxPLIvdAHjGjNHOK4SupEpgLsNjxmJNmByZrG7rJ2wQWiwtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742236487; c=relaxed/simple;
	bh=8cc5k/dBJ8A5yXdLs7/Et5ghEBM8BXgwEWxHnVDm94A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E4o9P8PAF9cLSQIBIqffnyeOSeSiJVFx+a6qHulKwO9oLONM93AKciAdlzCL4T2JxXToKC41oufCXuOvKZTgYvh/bw/XfzeSTUq5zOYwoHVtmXBp4Ke7zEeLH4OXYxLKJmykoh104exfKJdp3PiupQvs9gSu/ZR3Xv0BhjPpxRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BbikHszG; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2260c915749so21694875ad.3
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 11:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742236485; x=1742841285; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pdsNHldr91xnqdGHk1DTLXuYnmkD/cCe/HKmA2EoKL4=;
        b=BbikHszGJNEIomx8wNzp/QJQ/yxXnubAaB5Jpn1x/f8kDsF5mF/kEgC6CTRNaNq0Bm
         6zOKJjvukF5ExzKU3AM/ChxMX3Mg1/drqISCVPItJHjY97yvuLijyvnlcvGDQUjjdtmB
         9NFWmNV9v4AiKnV9hmBEN+e1U+/dynNm1gHGdluyGv3qwwIOAbtkVKmPHnu97k/9RxZS
         1JijufkmpOl1l7TurLWjezwtNJHlj0qxJGpnvO9MDiCFDgLJxnU9x1LbOiDtn+Pxo/T6
         Efo+GhZjdGuhw4zHGXxJYZHXU+6qEft8f4tin8T4uITe2hYAMXHqKOeXwQ0ctwo59MVx
         UDNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742236485; x=1742841285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pdsNHldr91xnqdGHk1DTLXuYnmkD/cCe/HKmA2EoKL4=;
        b=Nsk9E2UlQxtnhcZj2xEg4fpInpdIjuj67MesjQNLM9vYVdJPMe30KL1BFZ+HhkiSnN
         e4IDQJZwWJ4FixW+QQXLy7a75psceEs8krrRy3b4sapIkAS9siOe1w98O72Y4E2KbwoK
         29Iob+lyLeKkCcSYLLrySQa6uy1hICZXswBRRvJ54bWdVX1sPF3PAhOWpXAlVm0uwBOa
         CLz7sy30pZZgZUBCUZ8xnt28CLyhBHighVd7D8avo0CFwxOAbHydJaf+00pwyys2nwK1
         znrX30V8X4az59/VfFPLzZJtlMWLuo/L4tItCHBdDahgxr6hUVIgL6LiabHIUCp2Dawl
         JBVg==
X-Forwarded-Encrypted: i=1; AJvYcCVFv1ICds9Faw2KmSeVMGN8jctsBEdrV7w8tmLvIlkOpVqDnHpk75yErljHoepWg0whc1w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy63NJTuLzFddc5DJalaVkvI8MwGoRFdkM1VjLrjGK1CMNXCmSW
	J38CedV1LEvmYA2XSrZGQNLpP049o9KI9MztJt4JVh6Afqbhz8WRlLplBu1mhYE=
X-Gm-Gg: ASbGncubQuABvfAfKh5iqTobw84xL2I5K6EoZzk3VtEBvPPH5H5oLtyo2Y78Gnzt0BC
	GspsShAQaDHCDqHvpxfUCH22p68sbu1I2uC6ss+OoQZLH97IFOVuXHlMmRNr6YztdDhi1HqCg9f
	FoWRT466irgMdYgqdHSqMT/60QF5RzWqrxI/TiiDaVgt2ZkgzDE0M5n5RAKLrDEReBr85vqh88j
	1LNFWKnOVXlaSDhClnC9JBkArzHriYSxTlbWD7Qv5t+jdSP+95tEjdS4pRks6t3ofw58BWACLCj
	39cW9vTOkyfj46uSUokCVcq+JTfzplLKM/Y7W+gH0api
X-Google-Smtp-Source: AGHT+IHzNNUW3sLQt1T364FsCohrjLgSsBCXmjd/XRyR5B72Si2GIa2LUJ+5Zkf6gr6cDVKPRd/CWg==
X-Received: by 2002:a05:6a00:b95:b0:736:3d7c:2368 with SMTP id d2e1a72fcca58-73722353269mr15820164b3a.7.1742236485130;
        Mon, 17 Mar 2025 11:34:45 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711695a2esm8188770b3a.144.2025.03.17.11.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 11:34:44 -0700 (PDT)
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
Subject: [PATCH v6 18/18] system/ioport: make compilation unit common
Date: Mon, 17 Mar 2025 11:34:17 -0700
Message-Id: <20250317183417.285700-19-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 system/ioport.c    | 1 -
 system/meson.build | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/system/ioport.c b/system/ioport.c
index 55c2a752396..89daae9d602 100644
--- a/system/ioport.c
+++ b/system/ioport.c
@@ -26,7 +26,6 @@
  */
 
 #include "qemu/osdep.h"
-#include "cpu.h"
 #include "exec/ioport.h"
 #include "exec/memory.h"
 #include "exec/address-spaces.h"
diff --git a/system/meson.build b/system/meson.build
index 4f44b78df31..063301c3ad0 100644
--- a/system/meson.build
+++ b/system/meson.build
@@ -1,6 +1,5 @@
 specific_ss.add(when: 'CONFIG_SYSTEM_ONLY', if_true: [files(
   'arch_init.c',
-  'ioport.c',
   'globals-target.c',
 )])
 
@@ -13,6 +12,7 @@ system_ss.add(files(
   'dirtylimit.c',
   'dma-helpers.c',
   'globals.c',
+  'ioport.c',
   'memory_mapping.c',
   'memory.c',
   'physmem.c',
-- 
2.39.5


