Return-Path: <kvm+bounces-59402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C641BB34E5
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 10:48:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB86B18884DE
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 08:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65F1B2FF666;
	Thu,  2 Oct 2025 08:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SKPQGNSu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC35C2FE581
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 08:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759394528; cv=none; b=m89de5cYzRoNtLRCoxhYgGSX23x7QJjv1QJ0k/F9My3YIlj3GGLEPMBFkFLH2N8rQ0dtZIbWO0kWYN3DhDamRGBOhlIxiw9vbudFJtTQd3LkPkRK1Yyxh3t04caqzt2Z1uZ5fkWUBjDt8zOPhhBDKJymeZ2M42Rl2JD+O5uMYqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759394528; c=relaxed/simple;
	bh=4Y6c+95Ei2G5WhoUr8knOfGDGUpdqSSYiQsOdsekwxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SQkD0+1BPDqd7fvCPL6vX7SuVViDF57MzzxmfxDt2pxjEDQ+uE7CbUcz9b1SZnwK5wFj7hLHczLr2O8LeGF9PKm0NquTAHnZYLB7a6h3LyisHLzG85b9noc7Mu3+v7vBSJy6Pk3pGqqpw/LqPGTNqJRXUVEsmdXjxg57ZiV5dbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SKPQGNSu; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3ee13baf2e1so467364f8f.3
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 01:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759394525; x=1759999325; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NTegPe0Bb/he6v221vBe7onQOEmqDcWQ9UUafnugHrk=;
        b=SKPQGNSuSnKg6Etyv77MBvU1thd/eig7XajSwtILCTCXKSgk7NgCxjIvhDKkyinP3h
         5PsFp8jv7nWCPCKxKDPkLjdSYZEsAGvhPvzdpAfcVhIWxH15wDHe5aHG8y9U3uEYGhAO
         KUQIbphpoZjXiv+rLJCWlPS89xCYsB0ttDXe1NzhSdiqtBFKjVCZ/XKW7+0K3eUE31lw
         5qUrh4GPLshmhs1tKsSlz8fXfDmhC+CleroGtQBg6FS5S90dWDwll9yjJot5OybIUXyL
         7MjUXbj5B5DpSATB+kJsGI5g0KpXCilouYBHx7sLH3M/uyvjOb/zAggAW4UqmnG4ExxO
         hXHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759394525; x=1759999325;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NTegPe0Bb/he6v221vBe7onQOEmqDcWQ9UUafnugHrk=;
        b=Bdm1eFWItP398mCkObasD/E3mFzOqcnOhMqITecjf7SP8HJE6N6wOOI/QdveMMPhEv
         Nz1l4crc3zo6AY9YcSNv54Q0kGXqYa8iwvCJ56x8nUKft/c5KKLrts52PVYZXvZCSPv+
         yNVeNksxdznbghdBtfUaIdiA9wRCwtdkJPe7IZ6ptS0kgrhMc8yofaJHdloJA/337u2I
         Z858dZ/jBdaokekgbqc/WekQxHhk+AQG385HHjCPJcJbkstm5ufj0Qsy/7M2fYyor6ay
         I5yX6FRU0pTnOhXAlZMb3Uynsex/7LLcfIBhWD7B7OnQ3WyVdudwoP5JXaD5YeA2MjGm
         ATVA==
X-Forwarded-Encrypted: i=1; AJvYcCUWGuJ6cW5hfwNg5Dgh8WyylXKXG/hTTlNwR+XcwxImq92fFINWWxZXhM7ksAhlMO6dy8Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfYz+2wEJfrDPgKTCu8Boq2mbUVkvtxbH98kJ/0j+33NFcpefI
	+5XQKp7BxPYGPTpYJOtyIVVhBdz56vn7Vez7BDfWd+c9cy34Qs7c68sVV1bR5ulmQYYsK3Gkp7G
	0LpKBwCxDSQ==
X-Gm-Gg: ASbGnctC05GptacK3h9p6c1pM9Bv74hDL57MaD5FUja5P5qcCYVIqEOf19CUWEAiEIz
	UZWmLI/zu8VHdV4fLZuhbBpAqUhWEiPGavCL8tEP1Ptnk5425qsvMyjQp43I0ws406SIYqjuScE
	TFvpNKeaR1Vnp2jfx4SWaP1oSzYAEADAq0e9QofAnrYo7czM6+NMZPwBfqjY5/gC4nPVw3vbPRb
	oMNzvnT81Oix7FQdM58FOuFsH7qXa4ZoWf58qDMTkTWS6XqiV4xsksF1fKhmZCeoIyU1D6vE/5/
	+eXgGXkkzNQDnsiVJ8OGVK4eyPrgpl0K89jSRMV3L8M6NIA6axVQ1Q17xYTmfhb/QcYk2zJxKkv
	cwnEiIizb02YIwvTonmiY4/gzEccFwGXSs+zeM0BR/+TU5aD6W/V+Txer/GfUx2NVkqI/tFU9VG
	0dOOySMrfVc3IHmsIYeqLh9POAqSqaoQ==
X-Google-Smtp-Source: AGHT+IG73iHN+13Rh40JFYt36cqDPiR27XBT7Y9OfRVKOo6LBiQqBv7ff1ie3ldwhto5T24zRQdzaQ==
X-Received: by 2002:a05:6000:240e:b0:3eb:5e99:cbbc with SMTP id ffacd0b85a97d-425577ecad9mr3404901f8f.9.1759394524821;
        Thu, 02 Oct 2025 01:42:04 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8ab8b0sm2683613f8f.18.2025.10.02.01.42.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Oct 2025 01:42:04 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v4 00/17] system/physmem: Remove cpu_physical_memory _is_io() and _rw()
Date: Thu,  2 Oct 2025 10:41:45 +0200
Message-ID: <20251002084203.63899-1-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

(Series fully reviewed)

Since v3:
- Do not describe flatview_translate()'s plen argument
- Use cpu->as instead of cpu_get_address_space(idx=0)
Since v2:
- Fixed vhost change
- Better describe cpu_physical_memory_rw() removal (thuth)
Since v1:
- Removed extra 'len' arg in address_space_is_io (rth)

---

The cpu_physical_memory API is legacy (see commit b7ecba0f6f6):

  ``cpu_physical_memory_*``
  ~~~~~~~~~~~~~~~~~~~~~~~~~

  These are convenience functions which are identical to
  ``address_space_*`` but operate specifically on the system address space,
  always pass a ``MEMTXATTRS_UNSPECIFIED`` set of memory attributes and
  ignore whether the memory transaction succeeded or failed.
  For new code they are better avoided:
  ...

This series removes:
  - cpu_physical_memory_is_io()
  - cpu_physical_memory_rw()
and start converting some
  - cpu_physical_memory_map()
  - cpu_physical_memory_unmap()
calls.

Based-on: <20250922192940.2908002-1-richard.henderson@linaro.org>
          "system/memory: Split address_space_write_rom_internal"

Philippe Mathieu-Daudé (17):
  docs/devel/loads-stores: Stop mentioning
    cpu_physical_memory_write_rom()
  system/memory: Factor address_space_is_io() out
  target/i386/arch_memory_mapping: Use address_space_memory_is_io()
  hw/s390x/sclp: Use address_space_memory_is_io() in sclp_service_call()
  system/physmem: Remove cpu_physical_memory_is_io()
  system/physmem: Pass address space argument to
    cpu_flush_icache_range()
  hw/s390x/sclp: Replace [cpu_physical_memory -> address_space]_r/w()
  target/s390x/mmu: Replace [cpu_physical_memory -> address_space]_rw()
  target/i386/whpx: Replace legacy cpu_physical_memory_rw() call
  target/i386/kvm: Replace legacy cpu_physical_memory_rw() call
  target/i386/nvmm: Inline cpu_physical_memory_rw() in nvmm_mem_callback
  hw/xen/hvm: Inline cpu_physical_memory_rw() in rw_phys_req_item()
  system/physmem: Un-inline cpu_physical_memory_read/write()
  system/physmem: Avoid cpu_physical_memory_rw when is_write is constant
  system/physmem: Remove legacy cpu_physical_memory_rw()
  hw/virtio/vhost: Replace legacy cpu_physical_memory_*map() calls
  hw/virtio/virtio: Replace legacy cpu_physical_memory_map() call

 docs/devel/loads-stores.rst            |  6 ++--
 scripts/coccinelle/exec_rw_const.cocci | 22 --------------
 include/exec/cpu-common.h              | 18 ++---------
 include/system/memory.h                | 11 +++++++
 hw/core/loader.c                       |  2 +-
 hw/s390x/sclp.c                        | 14 ++++++---
 hw/virtio/vhost.c                      |  7 +++--
 hw/virtio/virtio.c                     | 10 +++---
 hw/xen/xen-hvm-common.c                |  8 +++--
 system/physmem.c                       | 42 ++++++++++++++------------
 target/i386/arch_memory_mapping.c      | 10 +++---
 target/i386/kvm/xen-emu.c              |  4 ++-
 target/i386/nvmm/nvmm-all.c            |  5 ++-
 target/i386/whpx/whpx-all.c            |  7 +++--
 target/s390x/mmu_helper.c              |  7 +++--
 15 files changed, 85 insertions(+), 88 deletions(-)

-- 
2.51.0


