Return-Path: <kvm+bounces-40546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EA0AA58B52
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 05:59:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50F8B3AA460
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 04:58:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F2EB1C3306;
	Mon, 10 Mar 2025 04:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dVQ/UMpU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A340481E
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 04:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741582732; cv=none; b=rXHQhYkCHZnaWpO0+TyZSUuFz2/GlIXM0+UXHMi0fFgt3bAe6WVhaT9r+3q3wdubuiCL98a4TKhUlRbsH5qWBUteOdFo6RPp/KKWvjeo2EnGxODzZHt7p2AG+1eSSXffnWpFkkd3HxAGPx7b6XqZL/pxdyquwcYmiAUhx+zF/1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741582732; c=relaxed/simple;
	bh=tF6CoZOiuHBSS8TQ1Jlh9/vKiboYfJNhFXHXwitwNLE=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=USPnT9V4G/mmhBNSbsNCUS9Vuu3ENaVw/EdAN5oa6KJl2g+Qvum5Q4w4dxSY4Y6IfDHpg21cvuOB14KMVqZMufeXgoOkqtVFmuPRDb32H4OxliCcr+JLvnSE3kjDlRExHCh32kuOUFB+Gn8VKieRFnHR96oPCrFqtGNCcuOCMzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dVQ/UMpU; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2234e4b079cso64067655ad.1
        for <kvm@vger.kernel.org>; Sun, 09 Mar 2025 21:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741582730; x=1742187530; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CyMnY8DCOyhH4sll8UBWjGQBOdpS4N2V2sRcD5CyECM=;
        b=dVQ/UMpUXWOQxfDnra9+2vQULkhxIVqAf2A4kXbkgucpk69xtAe1m2+KKC1Hb2EqfY
         aDwLG1UGANtSvSe+urFtS+laMJ8Fxe1UjPsJpNnlhRb6buhcofzkUGB9j9G9PUxU01iq
         KZAXrWUESgKGajskF5tCN151td7BGRKjQlqtHQ+L4lWnPI4xGlL4WxbaiXyQ1kGQFT2u
         VkEB8v7jk+sctb9/YBv/hNwVTqVe42+mzRhOU0GWa9wchDBKDqqUXTuu5AJA4sjIGqjM
         SVnJQMOMm+DXMyykNFEF1448ccWNaKPLzX9+wp3JyC6Y2ZC2cRlPTisNLQe4ojPj6Wgv
         JHkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741582730; x=1742187530;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CyMnY8DCOyhH4sll8UBWjGQBOdpS4N2V2sRcD5CyECM=;
        b=Iv2GVhQjqg5nNh7Y7Ecw1dyiPjPaOMVwWfCCavp3Uu5EtWqXOFNeOgLSt/ldaKK1te
         p5G18rLD7CCNuXpqApYMEeiHdfT6mLaoTmEXZQMxbX7r61x+oV+H9FC865eOsLbhdezP
         b+UciwfbJVjCi/d9Et3FF5Ue58DMY6ytnqPCufseDMwrDa4IXR3hEbhPCGJiy+kPZOwL
         sIHI3rvYMRPIhogNipsPTjpqTQYUpxTcYprkjAQAISQuQNCVn4NusF1U+DCTtRq0BIyW
         8nlxcckF0iLbvn+yIzmrT7UCPWdlGnEa8ls+rARsfjrexEPEP+EDMkaiaLAR3l7cqmLN
         otUA==
X-Forwarded-Encrypted: i=1; AJvYcCWHMeYHlf71hNOKhWnTMVqJ7O7GyTlLaICNvxqTPY2K3MpodOmGQtr4aeLXM5CslBJglew=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZepXGamcvR5ChdT2q99vvqGx/KckJSd9QMrmNvvau+EKbqD4Y
	aY8A9ADGYES812hk05kaG2bIX8GIHHcDIUd8HYP+yR2DHrY26QydiAbGkGS6bIY=
X-Gm-Gg: ASbGncseT3Pzt/DjiO6AgyMLTqLfC1sFwN0xLUQYIQ9jmOnKqRcbA/nMrvxy+o7/L86
	TpaMXtyu7UQdBOw5pyXHRRAwG3O3N1zLCPJR+4DO1T2AwxSBKqz72tdKbv7iIX4SJEt+cIWf+Ic
	vVBBg2SNbnG1YiDnu810BTE3+xbOvPc2uoCuq8LxHPWUz0Qf1dsnXx3OR+XaOPbm2abL91AxK6Z
	r3bIWrF9+9dhJH58V7ZBvaaJlA+WWhYyNgH5kIKx+WMPnmN4Vm2OgPfuXRJZzA1rRb7M4vDUklA
	riZAWowkEEMPlqEgxwEcpH94FkM9lN3KTWmGON/mN86PQZLo7WbjUQE=
X-Google-Smtp-Source: AGHT+IFBRE9vcuWy/8QGIVJH+CegCd8ZXFRntWgx7wfqbQL9hdyzkh8MEMl2t2vqfLHGN0wEW9B3Eg==
X-Received: by 2002:a05:6a00:b4e:b0:736:57cb:f2b6 with SMTP id d2e1a72fcca58-736aaa1acf0mr17943212b3a.12.1741582729877;
        Sun, 09 Mar 2025 21:58:49 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736d2ae318csm1708308b3a.53.2025.03.09.21.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Mar 2025 21:58:49 -0700 (PDT)
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
Subject: [PATCH 00/16] make system memory API available for common code
Date: Sun,  9 Mar 2025 21:58:26 -0700
Message-Id: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The main goal of this series is to be able to call any memory ld/st function
from code that is *not* target dependent. As a positive side effect, we can
turn related system compilation units into common code.

The first 6 patches remove dependency of memory API to cpu headers and remove
dependency to target specific code. This could be a series on its own, but it's
great to be able to turn system memory compilation units into common code to
make sure it can't regress, and prove it achieves the desired result.

The next patches remove more dependencies on cpu headers (exec-all,
memory-internal, ram_addr).
Then, we add access to a needed function from kvm, some xen stubs, and we
finally can turn our compilation units into common code.

Every commit was tested to build correctly for all targets (on windows, linux,
macos), and the series was fully tested by running all tests we have (linux,
x86_64 host).

Pierrick Bouvier (16):
  exec/memory_ldst: extract memory_ldst declarations from cpu-all.h
  exec/memory_ldst_phys: extract memory_ldst_phys declarations from
    cpu-all.h
  include: move target_words_bigendian() from tswap to bswap
  exec/memory.h: make devend_memop target agnostic
  qemu/bswap: implement {ld,st}.*_p as functions
  exec/cpu-all.h: we can now remove ld/st macros
  codebase: prepare to remove cpu.h from exec/exec-all.h
  exec/exec-all: remove dependency on cpu.h
  exec/memory-internal: remove dependency on cpu.h
  exec/ram_addr: remove dependency on cpu.h
  system/kvm: make kvm_flush_coalesced_mmio_buffer() accessible for
    common code
  exec/ram_addr: call xen_hvm_modified_memory only if xen is enabled
  hw/xen: add stubs for various functions
  system/physmem: compilation unit is now common to all targets
  system/memory: make compilation unit common
  system/ioport: make compilation unit common

 include/exec/cpu-all.h              | 52 ------------------
 include/exec/exec-all.h             |  1 -
 include/exec/memory-internal.h      |  2 -
 include/exec/memory.h               | 48 ++++++++++++++---
 include/exec/ram_addr.h             | 11 ++--
 include/exec/tswap.h                | 11 ----
 include/qemu/bswap.h                | 82 +++++++++++++++++++++++++++++
 include/system/kvm.h                |  6 +--
 include/tcg/tcg-op.h                |  1 +
 target/ppc/helper_regs.h            |  2 +
 include/exec/memory_ldst.h.inc      | 13 ++---
 include/exec/memory_ldst_phys.h.inc |  5 +-
 hw/ppc/spapr_nested.c               |  1 +
 hw/sh4/sh7750.c                     |  1 +
 hw/xen/xen_stubs.c                  | 56 ++++++++++++++++++++
 page-vary-target.c                  |  3 +-
 system/ioport.c                     |  1 -
 system/memory.c                     | 22 +++++---
 target/riscv/bitmanip_helper.c      |  1 +
 hw/xen/meson.build                  |  3 ++
 system/meson.build                  |  6 +--
 21 files changed, 225 insertions(+), 103 deletions(-)
 create mode 100644 hw/xen/xen_stubs.c

-- 
2.39.5


