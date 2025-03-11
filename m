Return-Path: <kvm+bounces-40722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6C57A5B7BB
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 05:09:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DE053B095E
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 04:09:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2D301EBA03;
	Tue, 11 Mar 2025 04:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XysFm+Io"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365061DEFC6
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 04:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741666140; cv=none; b=grXBtYHmCDztgmJzRtaXiWB4uIEJni2ofWcOpR2Axftl96uDfpxsqdfYtasgbLnEmoNgNJM4PxSEvnvXx4ffCrMDdCumptcGjnGdzwajiHcUQvxm7iFA4Y3KFHSalKMns0dxfGPgrWjq4OvSNsurjs/IwRgf6hZWXn5TvViPtXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741666140; c=relaxed/simple;
	bh=eqgrewx6aZ1up7RoZ5eSnZ5cn+qAAXiEq5mctl1WOEc=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=lIfRxufvof1j4QHmmQiLk2QC7i1a0cwYyiOwfB/MvBfuqjDLLNbZazYalqs0S4R6t2G7MHWpON1HUmCUjbG/UZStpAsalzngH3DDJaCSEq36ska0EqAAcX6hLSXF4i6KgO7aoXMskA55HTIfgiOJycVv0wSy7PmY9bR3aqR1+d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XysFm+Io; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2fee05829edso9839706a91.3
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 21:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741666137; x=1742270937; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fGerXdOtIw0WsOiLQfJLVuAEuZhGly95KD3uNgEzFEA=;
        b=XysFm+IoYY9qcLa6XbT0Ote8BFtbpj7ls2SJix9bHYDtSBO4JdALMGESHLuVflYXjC
         n9+jvHThL3GEea3r86JOZTTCjgINKnkP8D8umPs1dSN1ooWWCGUUeRODewK0ZXAFir2R
         QY1NU2kakK3je8rwNkL9cvLX0LgzbDfaE5mYdSR7uFo7SzPj1BIRjlEN3PrZ1WHa1ewR
         +z/K80iWbO5qDcBeKxolBr2zWepZ/PcEeU2+IIn3PNs7839moSm45e3w/4AvnFLyyOfO
         /Xh4So34PepGOcY/kc1KiLPaMQBDhT5Tsmr0ksVi2fupBRMk4JXeJcnp9EfL0hOJ7fvf
         u17g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741666137; x=1742270937;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fGerXdOtIw0WsOiLQfJLVuAEuZhGly95KD3uNgEzFEA=;
        b=gmQ+pQ5EZcyZwVxqJZaCOEFTtWgzR2yKaCtD4gBk5YDTx7oPmt8Z2g4Wrwv+/w2lL4
         MTZj21e2BvVI0+tfyPDJi2JRtls+H9S0fHFyJI/ajPoxF40v8anBGgu2AAVLv9qTezgF
         snrGEBgOUE+TR8ldrExiOu/6GunxNtVOX1YdSJhBZ4mx4tyxBoMk1CWFt6uo753CMN63
         0EBDgMV5WxbLKjcEojPeSA7QwQCXTeHvm0np5QnjRoHVgnizdcoIkC3NTDp0iuCdVbFI
         M1pjMzT8yUxhKueule+6OLULIMvdvqvCMRSvu1IOwVOYqvAM9cloXr7AUr2yBvBoEYZI
         hUNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWHDtKATNL0516IU5GIQgxLQF6TWWKOEDI41dTAY6Oyfqb2Nq1vDyaW7oQZlWc2MMhrEc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgL/OjtmglKeZAWA0XkAIIF7B3kY62lOiBDALm4enAq0q+7CXx
	D2z9Vsfavuz1y6y43tVOtIzvncP6q4GHl5oDkg3IVSz1OyndBYouqu0qy7dBmpY=
X-Gm-Gg: ASbGncvRSveLxZ7DnSwaEOQxm9kQZfMSmoa6BU+Vo92peGnKooo+WlooZ8JV+DP+Upa
	cwjsf672kAgFRVxy8GD7ACv2hr2kvS8OTSNfU96i4RzcJZlSszMdx93LMuB1Qw1cvJ9nRnfd/z4
	Fr1TgnLy/5qRxUJBo18chNZNS7Hi9TDnLckTNAQn+pFnAQkgDRyL4iDdzFuuX1KtNCo76QVGQJ5
	5AaPu6sKz1eK3Iw8getljAPxYj1RFM4CqdLkFS4nfoNl9ZazQcM5ZxqLGsoiXD4MHzDEb5PuvMx
	y10Xl5e5FfJ7FaZrwzgqsuwUAsNloHRChpH8p87LJRlO
X-Google-Smtp-Source: AGHT+IGXMO59GO84wcQfdotD1ICTUfqb/mJe9bhBOPtOn//E28HwyLyMnn+hwaJcsHLDf6vigaP+aw==
X-Received: by 2002:a05:6a21:730e:b0:1f5:64fd:68ea with SMTP id adf61e73a8af0-1f564fd6a98mr15013110637.4.1741666137431;
        Mon, 10 Mar 2025 21:08:57 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af28c0339cesm7324454a12.46.2025.03.10.21.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 21:08:57 -0700 (PDT)
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
Subject: [PATCH v2 00/16] make system memory API available for common code
Date: Mon, 10 Mar 2025 21:08:22 -0700
Message-Id: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
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

Pierrick Bouvier (16):
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
  system/memory: make compilation unit common
  system/ioport: make compilation unit common

 include/exec/cpu-all.h              | 66 -----------------------
 include/exec/exec-all.h             |  1 -
 include/exec/memory-internal.h      |  2 -
 include/exec/memory.h               | 34 +++++++-----
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
 target/riscv/bitmanip_helper.c      |  2 +-
 hw/xen/meson.build                  |  3 ++
 system/meson.build                  |  6 +--
 21 files changed, 184 insertions(+), 119 deletions(-)
 create mode 100644 hw/xen/xen_stubs.c

-- 
2.39.5


