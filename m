Return-Path: <kvm+bounces-40787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 38909A5D016
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 20:58:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7624E7A772D
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 19:57:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0BA32641CA;
	Tue, 11 Mar 2025 19:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FGreWhSc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F133215F49
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 19:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741723093; cv=none; b=gGkffaZQ/l2viVL+36+zqUgES+J2gSbpILZa6HMY+HDNpVzWC0PVD+y36JciWLllLmI9xcxreTc+nHqxki6+0vUnHlY3P4xhUwX5V7p9Hb21HBoN6bT5jpwIEA6KeGYnlHl9uwkjCZZ1ZFdNADv7HmTDGeGGij2llUdihpCRhWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741723093; c=relaxed/simple;
	bh=BpLPcziAyGuSwnTvgx4UceEsgG05PTQppmEQEPOqF08=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=kBrfgdyA1y5tUuiVEA9i+qG0WDBgbzq9G04ZVB3X6EIONaWukMDCPGdp1gWfRfdHnUnifoH2svnodll4TgHzjxFUzJj5z0iLHqRL94GVLQsWC+TChFQ/UeAc+dhXfEDsQ9ILJbmCf/4LHgvLAo1CbjZCjjRmZac8g0d2bnNQ9V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FGreWhSc; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-225477548e1so64744745ad.0
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 12:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741723091; x=1742327891; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BJxldrM9ls/rNwHOkfKDTsLlkFzxI4z634GC5RzciYk=;
        b=FGreWhSc0wzYzoRLkRwpuFVEU9taJwNBwO4G3jLI9lplERS1Jiu9pAkfPxxI5f4ax4
         QeBg8tkgxUYItkzhdpOazint4vRFEYJQkYzPfGaRdrOawy8eSsTLTOIK1eBgriEQX6jB
         MVWT3Nr2z6/cUS/LzdAJif9sLmLyfdkzQMoHlnpUE22G5E+bj5kMKDA1UFwCtkyAmuch
         6Y2giQqxqJje29gTPQgw3Fhg5kfxpME5VR+QokuOWex6qrAsWtg/kIkPGlvk4Js5kUFU
         3q90WexfLgAVEXSfQYk8AS8kLnBjUxellc1ZYS0t3kwOsXBijkzPTFzcn7IDy1uTDSGy
         duhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741723091; x=1742327891;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BJxldrM9ls/rNwHOkfKDTsLlkFzxI4z634GC5RzciYk=;
        b=FAhuYSPC88xHG7PHEPt6/D/THCFkJiXeDmHRO+7fF//p7VKAe00BqY3gnki447fwSU
         g19nYnlcF8fDxGqO7voOjb9UReJvBc8Jz+veWjTUVCOdrIYs1voKwgJ5LWZPDXzxpwd4
         VfGKmAGm0BZFhdkMGOsz7qf+CvqTCQIgowNdfQGlklFrGhh7DaLD37E0yiptmNZrtrRc
         VF5IcpReJfQqEC9zTssXHYoCT4eyiFg/omQjZdF3547HbdEsc1iIVoqyOjuR8FHs7cms
         1hkgoSeNoMZrcOm2ID60fd6FE0M3wLWu8n79NJ6Jtw6P8wKXTD/EGRpjD35YsgCdx7qp
         ghTQ==
X-Forwarded-Encrypted: i=1; AJvYcCVl7IwForamLYaNiqtPiQ4up7yCRXVVjjIdqU2Ve/zLqtsN3FWUcqop4WGHPFTmOwDiS6M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0TiJkoUhTIFaCTo6Pnesc/wV65HAOWMF/tlBEg4JAFTjQmJ2/
	v4Z6I95nCgOGY4WZAg9h6jKyh6aBLlsEbRVot+556KkXcdoFjRnGwbc3lyeruzg=
X-Gm-Gg: ASbGncvpEZaAld4anjANswrRFa3VFtGbsPqlZ2YQvYexZgIvRhdo4/h5Eh3zxMwFYRl
	cs9yBhJCMAVuQPZGDjYTCY+iFmB+0jlipGZB+SZwuhMhPieKGIALCaap8C4drh29Eis95yWeGs6
	B5zr+08STdAwyQEKOam1EWIyEHaY2tFs1Ovhk96XUlBLbpmGkICvLS14juo9EAk1n0qGbWKEhWh
	HbWt6dvAn0vr7C3gFebNffWvuo39uNQf1rMBett+dYddw5V+En3tdnizlnHey8VCMG//gtVLxNC
	3WCSHz2TuzOIxHDoM9E9YyitRiZ2foFRWeii/Pt0kcem
X-Google-Smtp-Source: AGHT+IHOrb1ktHbDIJg0LAeBD9OfAq2o4wANofPbWEj8d4iUXmKit5ZY6qUoI1jOxUcgyXZ2QfV68A==
X-Received: by 2002:a17:903:32ce:b0:223:39ae:a98 with SMTP id d9443c01a7336-22428a98102mr318619255ad.22.1741723090697;
        Tue, 11 Mar 2025 12:58:10 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736a6e5c13asm9646981b3a.157.2025.03.11.12.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 12:58:10 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Anthony PERARD <anthony@xenproject.org>,
	xen-devel@lists.xenproject.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	kvm@vger.kernel.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paul Durrant <paul@xen.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	manos.pitsidianakis@linaro.org,
	Peter Xu <peterx@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	alex.bennee@linaro.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 00/17] make system memory API available for common code
Date: Tue, 11 Mar 2025 12:57:46 -0700
Message-Id: <20250311195803.4115788-1-pierrick.bouvier@linaro.org>
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
 target/riscv/bitmanip_helper.c      |  2 +-
 hw/xen/meson.build                  |  3 ++
 system/meson.build                  |  6 +--
 21 files changed, 192 insertions(+), 126 deletions(-)
 create mode 100644 hw/xen/xen_stubs.c

-- 
2.39.5


