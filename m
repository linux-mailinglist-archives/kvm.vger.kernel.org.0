Return-Path: <kvm+bounces-41087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96EB6A617A7
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:31:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD0A2883A71
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 17:31:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B40520409B;
	Fri, 14 Mar 2025 17:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sbgZlo4u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF0C14375C
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 17:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741973507; cv=none; b=EXPTzBwnCo89dsOwlxHngTDce7Sbo2kdGsqtdLeJFQwmvNT+0PcFBdLr+nQ5EC0P+UCqcLk+h5KgmaRq4My5kGvAJQA8ItshED17V3Olvr/zI0TbQHzsIERPp4WotexqDfIQLgrT9Qp/ey+iDI+0Bnss+NA+GfgSN5vAYZiiNuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741973507; c=relaxed/simple;
	bh=xleHLAuVZoo9wo4MH/oAxu6Q15S9H1ajDIH16woBfDA=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=g5m+EpFGWP9LDp5knAgCRwb+cMgoaA8Ep6mPf1CoGE3li2cFddZugoq0XqxjOhvnilP86X7/0xYo809Kl06tnuzrlr5htvBrC5OrXLjQ5dCpl5W79bivOsUkCVQKSe69jJPJ/TDE5VwtYf0NAwT/WvLAVczX9IUMePn4yyWfVZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sbgZlo4u; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22438c356c8so44837965ad.1
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741973505; x=1742578305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mbx4XaRe0fsea/1JxsaLA7ueH0t1s6VZZ5QhNdIFgD0=;
        b=sbgZlo4u0wSTAhLTfBN+TPyWTU8DgxlGAQ6kWSjc+H2I5FhZ85jV+zFwJn894nE5R7
         yGalNqWInGrwxGLPthv5gxcUZe5SvyjyW2ffoE60xQo0tTV6r/azrL69GDQFwBx4trAm
         /GX7v+tYZUYY899W+XKiCyNyT6eopVeXWPAES35dJo0wbvenSQT5fwkFLGUkg1kIAe4B
         ZbaXMK6tFUxuWKFHENcTr8noIop0C87RIefr1eBUruiLa6qU1yXqtCU0Dw4AherqXtSu
         OvvhJKQm15s04032cMwV2lAa1u4nLnOJ+Dl3vzQpGX8mFHjCuQlr5/peeHb3oMPoIh2j
         lrCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741973505; x=1742578305;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mbx4XaRe0fsea/1JxsaLA7ueH0t1s6VZZ5QhNdIFgD0=;
        b=Lg1Orog8azkqY6RAYGWG7AfyBJoNg7HhE1tn0if9YHWHjwy6NAc6AiOA5ZSfgy3Smi
         QBxru2+VHyWI9T5o1ImLIWW00S9Gt7B45rNNU070mZUDGON1eQVUxooSaO9klVcwTuAI
         C3CtvzEQgXr8pCaNYhQ9DZwHb1EiUeDFMN9mweAQMM0BwQN+7KhFrSiSeJ9SndzT+CVh
         OfliI87e4BAdLDShJZ0TEVkYuiooVS5MEP+uH4N6v+0tzBmJrz8xdbagpcngkzCHgLpr
         Y9EP0TWtAPrBXT5pMS9OA33RsEO+E5E9g2nO70qIXSIxK44p8lPH7AzJsHO3ZHX7h35E
         Gj2w==
X-Forwarded-Encrypted: i=1; AJvYcCUO0yp+Lj6+Ctimxo3i4xxhCbmcunUn8/i6ZDH2gC+Crg4Yb9yfxWeGVMYbmCDCwemjpL0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNE6I0Md7uAxGGM+im6jux3mvM6JptGs9xVajA5CEixeYWhndS
	DUbxSF6PoqZJqgtiZMV7LCbNjHzq1gcUrXjwCivOBdzefSZEOvvFm+P4shtNLoA=
X-Gm-Gg: ASbGncsnNm4p3uLoiDpSmZxPSxY/dwyHNVuX1Iw+aW42eiwaAx+6cF2sA8nB/5DQhCf
	ZC4KMj0AHDqc/5Ftu7hVJ/fKXKtkxulkPru7L7KcmNRwyCydEOPRMoBDNOeUaChXm/3wGUX+RmP
	XdfBi9ewM3SvU5j4Z8FCG2BDy1NFGzkNaxIsdtQtWSi04JDzfu+miq4bJ74bysE9uO2NhfruNsr
	tqxp3aP+9QTslBUVmsdcf/cQY+56clfsEk9LPT1EVLMtaHRWJ0l3/9+qpJU6c5leopZjnsKwPQN
	+H2ssURtvpY/5g4hxyHuqlLbKQZF+kvEt6VX0qDBcmQE
X-Google-Smtp-Source: AGHT+IG45qOt2dgsJDV7nujhL0kdPo+5GKsExuYeufblXdBnsz6vqmVVLVscbpfExXfMyu2MvPKFvA==
X-Received: by 2002:a05:6a00:a1f:b0:732:5164:3cc with SMTP id d2e1a72fcca58-737223e7399mr3832223b3a.19.1741973504748;
        Fri, 14 Mar 2025 10:31:44 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9cd03bsm2990529a12.8.2025.03.14.10.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 10:31:44 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Paul Durrant <paul@xen.org>,
	Peter Xu <peterx@redhat.com>,
	alex.bennee@linaro.org,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-riscv@nongnu.org,
	manos.pitsidianakis@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anthony PERARD <anthony@xenproject.org>,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 00/17] make system memory API available for common code
Date: Fri, 14 Mar 2025 10:31:22 -0700
Message-Id: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
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

The first 5 patches remove dependency of memory API to cpu headers and remove
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

v2:
- reorder first commits (tswap change first, so memory cached functions can use it)
- move st/ld*_p functions to tswap instead of bswap
- add define for target_words_bigendian when COMPILING_PER_TARGET, equals to
  TARGET_BIG_ENDIAN (avoid overhead in target code)
- rewrite devend_memop
- remove useless exec-all.h in concerned patch
- extract devend_big_endian function to reuse in system/memory.c
- rewrite changes to system/memory.c

v3:
- move devend functions to memory_internal.h
- completed description for commits removing cpu.h dependency

v4:
- rebase on top of master
  * missing include in 'codebase: prepare to remove cpu.h from exec/exec-all.h'
  * meson build conflict

v5:
- remove extra xen stub xen_invalidate_map_cache()
- edit xen stubs commit message

Pierrick Bouvier (17):
  exec/tswap: target code can use TARGET_BIG_ENDIAN instead of
    target_words_bigendian()
  exec/tswap: implement {ld,st}.*_p as functions instead of macros
  exec/memory_ldst: extract memory_ldst declarations from cpu-all.h
  exec/memory_ldst_phys: extract memory_ldst_phys declarations from
    cpu-all.h
  exec/memory.h: make devend_memop "target defines" agnostic
  codebase: prepare to remove cpu.h from exec/exec-all.h
  exec/exec-all: remove dependency on cpu.h
  exec/memory-internal: remove dependency on cpu.h
  exec/ram_addr: remove dependency on cpu.h
  system/kvm: make kvm_flush_coalesced_mmio_buffer() accessible for
    common code
  exec/ram_addr: call xen_hvm_modified_memory only if xen is enabled
  hw/xen: add stubs for various functions
  system/physmem: compilation unit is now common to all targets
  include/exec/memory: extract devend_big_endian from devend_memop
  include/exec/memory: move devend functions to memory-internal.h
  system/memory: make compilation unit common
  system/ioport: make compilation unit common

 include/exec/cpu-all.h              | 66 -----------------------
 include/exec/exec-all.h             |  1 -
 include/exec/memory-internal.h      | 21 +++++++-
 include/exec/memory.h               | 30 ++++-------
 include/exec/ram_addr.h             | 11 ++--
 include/exec/tswap.h                | 81 +++++++++++++++++++++++++++--
 include/system/kvm.h                |  6 +--
 include/tcg/tcg-op.h                |  1 +
 target/ppc/helper_regs.h            |  2 +
 include/exec/memory_ldst.h.inc      |  4 --
 include/exec/memory_ldst_phys.h.inc |  5 +-
 cpu-target.c                        |  1 +
 hw/ppc/spapr_nested.c               |  1 +
 hw/sh4/sh7750.c                     |  1 +
 hw/xen/xen_stubs.c                  | 51 ++++++++++++++++++
 page-vary-target.c                  |  2 +-
 system/ioport.c                     |  1 -
 system/memory.c                     | 17 ++----
 target/ppc/tcg-excp_helper.c        |  1 +
 target/riscv/bitmanip_helper.c      |  2 +-
 hw/xen/meson.build                  |  3 ++
 system/meson.build                  |  6 +--
 22 files changed, 188 insertions(+), 126 deletions(-)
 create mode 100644 hw/xen/xen_stubs.c

-- 
2.39.5


