Return-Path: <kvm+bounces-41287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 866DBA65CA8
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 19:34:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7605A3BAB64
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:34:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 619AE19F420;
	Mon, 17 Mar 2025 18:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YBMxUCRf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D451BC07B
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 18:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742236467; cv=none; b=MKPuUfNX7fuVRTIph6z/n0PQnWT1J1MvdSzFOCqzqaEx9PoqQPkUjMCVTKWhksPXhkBL8x/ouiWQfzzuby99vh0nrS2kd7QLlGb6yuHriPN4G6J5ZAaaprMudhmgifzjXge+Bz0aqKkMd2hhmS/pt8LU86UePgQeuOmy240ruWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742236467; c=relaxed/simple;
	bh=z1PJ0a0lDYE33HTklF263axJDwUHeSFo1RT0DHJHehU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=n7hoKRYY1TGYWSgYpdTgIKt6CI+X5HXhQx2yzPlaGP9gI9bGehV2Fp5+OHExiole6X5FvWSdbA9MHqM4sC30JRyXD8R2mczpJEDug0g3IFTt+aE6WdIvBakLk0K4QWy22hh9AbTaYsSGbFkdPu7D55cITUsnaIG5/s2pfGJ9Nxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YBMxUCRf; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-224019ad9edso39846005ad.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 11:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742236465; x=1742841265; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RPbHwvloYIySCZWmnoL8Q2AUPe8llNmEPWBrsL/waLI=;
        b=YBMxUCRfCK8m5Dlh8yLjXfRY67g9/7QY1Ypd9+LVGIBMYW2vIwX1RKbpr1cFT92oq5
         Nnpx/W0QeQ+GZWzmxF52vXDpCaizpsTTgH/Vusamk9aa8Ldl3td/5c9ZEwajy4/JhK2l
         xViCer/0+sZxvrMlIzXbVSklOvt3GdiiyLcHmnG8CyE/8g51mUxnFsOX/mWvn0SNoR2x
         l0yfwkyj47OVzySmuNl5EBKrZM2vNF6HJ7OqG0xUu2TdjqjI3vxLXa28NBQFx+38iRPN
         DcoOmpaUMEAL2aVAeyZj8L5O6+hwu4Lj4f9xwXU8BJpW6u6NXUzWa2/YbW0nHA61PuFE
         nqWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742236465; x=1742841265;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RPbHwvloYIySCZWmnoL8Q2AUPe8llNmEPWBrsL/waLI=;
        b=j5iR6fKgX/63yNw2OKX1BTjwcMMObxVn4iBGfnBr03wevhK5D/0T86lNOSWQyeoE3f
         P5o8ND9SKBOsf6mdqa7R7oZGK5YJ5hqFXTYVElq9c3KqV6DPNPFGqKrs0m4N4Rm4VuD2
         XI3S9qOWOZAITwCBpfTLcHECw/Uma1cTwCtvjTncWTWZnSj7HySaCwxudtTptQVeCjp1
         Afpn6iOUpB4Z+CoTgNdRYSfDU2duNLBnaDsduzWO8zIZHQ4GP0GidG7NsTwuMhpa4mgJ
         XqLWsIPJwBmxu6i5POrw2pcUAp5UHGsDLQU0IZlF3qmmTkgM5bMciH0PIgONdTioZyWC
         Q72A==
X-Forwarded-Encrypted: i=1; AJvYcCXNHupsmeAHwbtrRYhtnpZAND46XVvqbSEuKON+ygdhx2jDvzN/mekiYNpfpGDF2hn57nI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxyegb8qwk1yaEnGXnms75C4EyXb6cZVQL0HoHxmp6YKW6F/7Md
	jhAb+adQQKHNXPx+33TR+TqbtQG56QF9eryL1parkTVFQA2minvFTM2uLT8gm0U=
X-Gm-Gg: ASbGnctITqFo+hGdNtYVesqsXIy0f/I5bkR237cbnsFeV+gvTNF77brAiOXvuOmKB5i
	3bP8QjNCHl6bXrxzXDVGnQx/DoDQqMt5Z49Du30XzvqvaQXsYzMt4uwgLfWXjmrfq86s+l8PnF3
	gNB+rByJW3RJYfTFzCI4L6Gww++yAS7mx0Y6uqtN3DqWFbAilUVZ/HPku1+EafZefZiLfVb6iCS
	bZ3fVCDjkSJuhQJ0asFNT4N1NcZXsuUuQRAz/OyFIjlMBRBcQZXSOY5rlDP4D71AqimiKS/gc5w
	xypayN3w82dtp65uc8gh7JVITxOgHF9cc03w28YC0YlM
X-Google-Smtp-Source: AGHT+IHpwrE/9GG9C2SlpcasgbLprVybd7V3qfmK368RSyHmuII8fQHqzJpX5Xu5Sns9RSpMe6xOTQ==
X-Received: by 2002:a05:6a20:6a0c:b0:1f5:8903:860f with SMTP id adf61e73a8af0-1fa4428f303mr888720637.14.1742236464910;
        Mon, 17 Mar 2025 11:34:24 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711695a2esm8188770b3a.144.2025.03.17.11.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 11:34:24 -0700 (PDT)
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
Subject: [PATCH v6 00/18] make system memory API available for common code
Date: Mon, 17 Mar 2025 11:33:59 -0700
Message-Id: <20250317183417.285700-1-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

v6:
- remove xen inline stubs from headers

Pierrick Bouvier (18):
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
  system/xen: remove inline stubs
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
 include/system/xen-mapcache.h       | 41 ---------------
 include/system/xen.h                | 21 ++------
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
 24 files changed, 191 insertions(+), 185 deletions(-)
 create mode 100644 hw/xen/xen_stubs.c

-- 
2.39.5


