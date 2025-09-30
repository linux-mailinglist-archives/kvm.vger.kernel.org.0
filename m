Return-Path: <kvm+bounces-59103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9190BBABFC5
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:21:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48A663A6040
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B01462F3636;
	Tue, 30 Sep 2025 08:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="v/yOAVSf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2FE23BF9E
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 08:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759220492; cv=none; b=LLxhVKml3ThWtifs7S00UYAoExT7KsLgr5zy3s3xJcqFkks+YY5NrkjriAAOkRDEUyPwOwb1TsMIYllBqIvqZFrIbiqPdKEJa3O0EaPLjlZlZgODJdOIyCbkwvOUYAiO6Czbj/vbXGE4PZYjhx1wP4oc4jufA/eRAX3M3GYr5sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759220492; c=relaxed/simple;
	bh=J+LSGD21bEOx4DjFn4rXH5Q6u4Arl0zdT+LQYpXXsbA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=d1c8zyAZC5WrzvJ69lleE7/jgRe50PEjhuL8xWwhML7WJhvpkywQU0W32nP+6B4am2HE8EIKSk5j2g1McBag2viJx4Cu8X8hU2qEeYHfZa7JQmoMgQmEkNHQMDncbP9FrquN5UwGAN7VDZ9gkU6pdTNL0Cv7NWDPlsM8MLcsUHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=v/yOAVSf; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-46e29d65728so37949885e9.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 01:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759220489; x=1759825289; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YvhoIhSsQDGRzJiqmuuLIQQZhU1t8TAbJtfU17YXnRc=;
        b=v/yOAVSf5bSbOH6IhQ5lmwNu/CNsk98qr3GMBzUJ6wQQddEgq2heak77bOIlLBjSaA
         w49muHTaPm+G89QFt4Yrr+0dlAPl7GmCRNgQeJTWBZOBc40tC380gulK1crlQRqfgeKl
         4qvnFKof0lhp6fgs7Y1J139ay0l8vO9pEP616fgDZVg5vMLv9LJtcIJ1FnOC/vM75OHH
         GYs2qFXChzM0oKEsdS1RK27KsGRxSaVzplxQ4HW0ckv3k+yFQ84gi4l3xq8aqyuSKD2A
         vceBnrh50cCcfGFjBKIP7GwsKxvuchrazrzVq0Xv9E9U9M/y6VcGwtiTiqxO3M3cJ8Y2
         2fMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759220489; x=1759825289;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YvhoIhSsQDGRzJiqmuuLIQQZhU1t8TAbJtfU17YXnRc=;
        b=aQf/daFT/EiMyRVGQV87+v2d0bjOYE/Ba3aF2Vw+p/K4xUg2DM8Sz1ZiHiAQ0Mffbi
         5MzA38P7kUou/Ao9LZDxA8Ym7Bpy9B65Gd4rDBGAXu2hzWZTtnSUP0l5h+BYO32v/hCv
         dzuGMef72jxtqueET0mvBrY9ZkTodnQKFYxMi1R5zGVgn6V18jncKia1VcSprh3e8vP5
         TXGq5jkS+epeiC1Rmg8YR3U6MuCFh1v0ViG/bYtTZvzVMsZCEcg0nwAhEejVbPT16XJY
         ayST2jbhpyoRNP8mqiStSRjZztjYqp0UXiAk8r0SfO9UaEievQnSnQug8zmc0sJqLLO8
         w82Q==
X-Forwarded-Encrypted: i=1; AJvYcCUOmYYkNeTsCt/bOAorOaiO6pq+Ylpl+XLOM0r9eecmiXKdIQ/KVj8QCppYgBu87u/bLbs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ3lnEc/W3q5/Fa3lOoiHkRRUL4S7B0w1zTgb4eQFHns452711
	uFS0UlC7ek/Ht+553xrFgw6qICsfi7hUY0iTrDtuwqtn6BEWJXmF7EvaB1hmPzXWAfc=
X-Gm-Gg: ASbGncspvQxYUNZleffIGKc5OJwWyUQCjoPkpKcemnEv7MT6Vzcd2q5ptYvDAbTc81X
	C3MoUR11je2NvsbBZ6X/g3ZI1XFxU04mtBvULCC7rvKQGCluTbA7IRGBQux42SXgUk7S/Sa5Lgr
	YetF5YKLb2ErkjTMopLNDM6eJ8PXGEsJK579H2H/4jrz+Dv7DvxxR/7BEXid0H7cAq4p5eZ9bOq
	9lFjpgczkOZ5mMWeNZw9Yu7z3+p2bwzHUrYxh/8Y7eODyZhLbbONKY2GItyr2rHRLmpkNf33W7W
	ctxV4V4VbEJCF+5CFbH2/0mxGlpaBvM9VotJoYnoHYaLWs0T9A0e6YMYqosLIsNOAwHtraH+Qr7
	88PhwWENbIDZAifQvkJaVv9tBkyvMVLKufZbiCGI2oSXSYtmXrEGDdcp5rS5Q7JnohTP70ZgnpF
	ZoOl5tqGl4PRcM8pmQAC53
X-Google-Smtp-Source: AGHT+IH0LOZYhQvlCCwRE6HguOW9UpuwkFMjTOLA/D/C2ktVUpzuFK1TrAy7o+BecbtxQsJYTDH8eA==
X-Received: by 2002:a05:600c:8209:b0:46e:376a:c9db with SMTP id 5b1f17b1804b1-46e376acfbbmr166369605e9.26.1759220489083;
        Tue, 30 Sep 2025 01:21:29 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab31f1dsm257244235e9.13.2025.09.30.01.21.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Sep 2025 01:21:28 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	kvm@vger.kernel.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	xen-devel@lists.xenproject.org,
	Stefano Garzarella <sgarzare@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	qemu-s390x@nongnu.org,
	Paul Durrant <paul@xen.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Jason Herne <jjherne@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 00/18] system/physmem: Remove cpu_physical_memory _is_io() and _rw()
Date: Tue, 30 Sep 2025 10:21:07 +0200
Message-ID: <20250930082126.28618-1-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Since v1:
- Removed extra 'len' arg in address_space_is_io (rth)
Since v2:
- Fixed vhost change
- Better describe cpu_physical_memory_rw() removal (thuth)

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

Philippe Mathieu-Daudé (18):
  docs/devel/loads-stores: Stop mentioning
    cpu_physical_memory_write_rom()
  system/memory: Better describe @plen argument of flatview_translate()
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

 docs/devel/loads-stores.rst            |  6 +--
 scripts/coccinelle/exec_rw_const.cocci | 22 -----------
 include/exec/cpu-common.h              | 18 +--------
 include/system/memory.h                | 16 +++++++-
 hw/core/loader.c                       |  2 +-
 hw/s390x/sclp.c                        | 14 ++++---
 hw/virtio/vhost.c                      |  7 +++-
 hw/virtio/virtio.c                     | 10 +++--
 hw/xen/xen-hvm-common.c                |  8 ++--
 system/physmem.c                       | 51 ++++++++++++++------------
 target/i386/arch_memory_mapping.c      | 10 ++---
 target/i386/kvm/xen-emu.c              |  4 +-
 target/i386/nvmm/nvmm-all.c            |  5 ++-
 target/i386/whpx/whpx-all.c            |  7 +++-
 target/s390x/mmu_helper.c              |  6 ++-
 15 files changed, 92 insertions(+), 94 deletions(-)

-- 
2.51.0


