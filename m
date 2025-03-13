Return-Path: <kvm+bounces-40949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08D6AA5FBF5
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:39:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 008773A3302
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:39:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6720268C5A;
	Thu, 13 Mar 2025 16:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="y8QoiTWm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C5113BAF1
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 16:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741883953; cv=none; b=mDzw44yYKezr5vY8+/x/GErdlFNH32NQ5l4zpVsgV0pvSR6L/wKQ0QWf88tzQjhNJx83Gz/u1m5v9CVRPCQqWJiE32HaWXloNDBZZnK1k4+ZaNrebEZILr/ELrM1QnVdzq8HucQ1NEmT8+A4nLmTDnqUTxEohxgftAQkzsF9Bss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741883953; c=relaxed/simple;
	bh=gMv2pM17WT7RBN3gUJsIR05Imxg7gLISWbHDSmjmW+c=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=BumZxnOY6gVH+Zy5Erp3qc2If7ZcP3H8KlEhe8GJHxJpzkz23Fd3bMRMYC4wXF8t4P7IANpz7+XBUxGmCgGb1F+m7BR3aLoTVvRiNOwSpDIzd1wunrj+cT8FZZxwRlwmcTcyqsTHWoh0fJZm/h1QdkiQBX4bZ5iblUBcWbxEvJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=y8QoiTWm; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-301302a328bso2506822a91.2
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741883951; x=1742488751; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ffKtZZCij4vskrAA+3NvWrKzzZscOxv69bTHCnUkApM=;
        b=y8QoiTWm7z0YAd9HS+M7iwp6QrO+lQzG187S2KXGo+x2u7E4NHFNBUzf/BKvbeuy0w
         7fs23QrMzuRMHB2le7kkbADSVr7xndOWBsHdonP9hFqljIlVWXtfHmedDZ0ilx3EmYGz
         ttZH65/ha6klPPKvPGYugbtpGyM9lr8Mw7QSvCTWzwosTAFSjqLq7Ma7POKEwxNVjjMy
         I09TJ1DtMuMxzM+6tTxselUme7mPStj1q4og9MRO6oqm0v6EArdOfn4nYlXPaE3DiikN
         aNDAnRy+HgbtgAvZ9rIli0lRmvwIbQ+xJ7482hCQa6YfqRqGSSAOF6vHkCrOR2RsIx1H
         kOJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741883951; x=1742488751;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ffKtZZCij4vskrAA+3NvWrKzzZscOxv69bTHCnUkApM=;
        b=S4nt2G9mb2PhIEKUN38MY96EuRqIhryKiIJDQmHue+p20CYmfkYDbACMUG7zQDiNYU
         cSKHuJLWHgil78bG3Mqc1hFwwbNmuYpc6cvig/0d+gi4D2qAvRI8CsSAwF3ub2LCrFTB
         YzlkhtTblgfff/Nsi+46s0AFvZmnSEVa1Kl40/I8Oyd1YIYo1Ro//w8m56gQf/GCNNds
         GCUEz7/L/fBSN7v83J3bYaAjbjXJyzEozZXpgoJlxarK+3oqqL4ZerNVpAZO7sdNMbSC
         5wC5+gu/KWLcQJwPrNBaOflPa4Oj9o6tvuh4YR/e/IOuuwm2vnCuYr6pRQfjdU3LtLXG
         +j5Q==
X-Forwarded-Encrypted: i=1; AJvYcCX0rsRU3Ufk9JUcTvHeI8bQIQtmjgkhxc0+3nn2TVSj4oee4Bn4gaV5auwZadAOlF7ZgTI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjoiqN4Ght3O8PH7xqFfbq+gwSrT0TErhVGhac8kiJyVVf2LhZ
	iD78suVdYgQ52JYoeSRmgn4pDMgIcVflr4u14MjdUajyI5ikavpHxr3c6C16ls8=
X-Gm-Gg: ASbGnctgQBfoheQdVVd4s7R7hG5irHGJnRB2eHY6Nv+gu/q4bMFyK+TmQEsOY5ObWkx
	N8pphcHPrnXBBCCJSuPa8tqqRaTUV5SqRKQXtxjVqrIsRY9a1VsVxp+EWgPOIrhPSYZY5xJNPAc
	D3T/5Tz+hyZNdIbhkejxz+7yUIX4hL4HcVMzVawqndmmgJ/OrWl6FzbFVAsxmjWLWcwQIvgIai/
	w0nbKcuxJVHGyjwlpn3GVCNxbhUWUbUCrLZugZMNMiPTgVQhiBsnCSkOCtC7NlJusDrUh1ZDe+l
	xzHwmLP7RwL2CZ3gXxCOsHOI6rfrUJYYHy4btLLLcXLeOGl0vM3CkEI=
X-Google-Smtp-Source: AGHT+IHILZBC4XG/VXTDGPE0LXvE+Aqy8ch+S3jq5UEPqUMQPlTTQn84Hgx+UBUoAEZm2kMt8qUx5g==
X-Received: by 2002:a17:90a:e7c1:b0:2fa:137f:5c61 with SMTP id 98e67ed59e1d1-3014e843678mr320923a91.12.1741883951572;
        Thu, 13 Mar 2025 09:39:11 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30119265938sm4020084a91.39.2025.03.13.09.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 09:39:11 -0700 (PDT)
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
Subject: [PATCH v4 00/17] make system memory API available for common code
Date: Thu, 13 Mar 2025 09:38:46 -0700
Message-Id: <20250313163903.1738581-1-pierrick.bouvier@linaro.org>
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
 hw/xen/xen_stubs.c                  | 56 ++++++++++++++++++++
 page-vary-target.c                  |  2 +-
 system/ioport.c                     |  1 -
 system/memory.c                     | 17 ++----
 target/ppc/tcg-excp_helper.c        |  1 +
 target/riscv/bitmanip_helper.c      |  2 +-
 hw/xen/meson.build                  |  3 ++
 system/meson.build                  |  6 +--
 22 files changed, 193 insertions(+), 126 deletions(-)
 create mode 100644 hw/xen/xen_stubs.c

-- 
2.39.5


