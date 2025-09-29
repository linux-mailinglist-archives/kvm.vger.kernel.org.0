Return-Path: <kvm+bounces-59026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73B00BAA4C9
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 20:33:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BB1A16831F
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:33:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C514823B61E;
	Mon, 29 Sep 2025 18:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="M6YBaznd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D69274C14
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 18:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759170780; cv=none; b=r9MUO48WqhnW9NLKdPSi932ibreefkT3unnowX1m4j7AE+LGsapzH3K+24UR8EgcNKBdlejNlJulh5Vq4Cp1HayfvU1NtDcsUGMHqdFbr7OcP45JP82igV5kf/E4xQeEPZkd3wXJ6DRXft5rc9myFW3BZCzfRaeAp44jDnnpSLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759170780; c=relaxed/simple;
	bh=t/8GgvbXoTMO9BAeb46W0ME0/HSJs810Du1xikt+8R8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WkEw7HSd1LXbtVB5Cu93QUlCM8P+dFE9xpjnVoR1c4d9w7BX6mkSrJK/ri9Q6bc6A6uSjJf3mUoRJOCnF+FKfuklJVSNUotbwr3wPOK6PiHdOpbDOsxnO6bNTAIFzLizYqN4MMHy7j+g6N/kGM6SLig49B7GUe2pFTq7Ck8tby4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=M6YBaznd; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e491a5b96so16573845e9.2
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 11:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759170777; x=1759775577; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gjcLUmOUJAsFuFPIcikgqMGc8qGXLm4Hg2dBmXJH0DU=;
        b=M6YBazndEtPXPewtVH+8rLkBsiiICkHQEE6kVBKC/ubrHR18oXEMSsbGEO0X/Va+iM
         ZWgjXnKDAz4SL2Gs0zVfbXQCkTRtVjQLi9+mufmdQckN3qcioib9vjBCoXdHzbCQXXhc
         9mBS1dKQbm85dUUF4xWXGjL+6KSy6cdWrsV9/4SPcoj5Ch9fqlLesBKGcEPEaqkJi3p6
         aybCDOEFt2RPJnSOe9QyPuh6sHljaCh1uXR72R54FZGqjjqdbxxhLlFjGbX12T0azv9J
         aA/RXeQrKq9jOkLYIEusgld2VgAHXLcGA7UtCULUrREAX/0r3QuGKJRvbTkyzeUXGjE2
         RU7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759170777; x=1759775577;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gjcLUmOUJAsFuFPIcikgqMGc8qGXLm4Hg2dBmXJH0DU=;
        b=ezcbMwnzRqQxi3UT5+RBOxBF2CeKB0eJGKEuRK+hzT9viWR2STHKqiMJrPwpI58X4Y
         nDTmruN/ergZMTykExF0aoryQAaGhN22xvnJOz4oPEVkKqdptZPk0JX2bvF7OyM6VdMX
         2I93YLTSS0WaLvuz63gsv8gtNe0kBq/sv3aYAs+5K4WTvLqGSir9xTY2Xx/FCtM2vGD6
         GnyaWEgDpckjkqepCRUQEnR7I8ZFFMLxJpFra5QkL9DTneDhi4NUfZ6v++MTXV5NBFxo
         Pcaj2+IUl9q5xDY9pdjFZ3RVRk0zNTLgqCRTAc6sQFElZDUlFoVdgiWD7OTOTPNfE5PN
         CdPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPqBzhs51ln9/IsQQLRzD691CpsR5h9R3bajlnRQuQewFALqXlgXqprWKVxLRrDqaphAE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0bu2iakRr5ihShHHvbRXHqJL5tvlYWbCsoJLh69xjpjvgy6+D
	srGCNePCXFa1T5hTJl1UB2E6CBtKO957AtrUg1vmw2DhkhjMHCRisBZwgQd2HvoLxQU=
X-Gm-Gg: ASbGncsO1VsRQUPF0qAIMAxL8+42F7Mw7rhn5dfaGCkcmGt/kYCBbjkE7Fhr350mbXE
	Mxj4UutUQ6XWhgev97duHAejxjX052bSW5SSlkaA1ZT0yH8DTy7fW4XpBNTtQWAU/PS8gYRkJM+
	NzRWmpxklVA+J40M7od+LvQQBiewOYjoKDvcddmJceuvh/Hsz+cvLG90ZOde32v7E1csnbg1JI2
	Wc88GAKWFE3icoAhobixTL/33gCme+lZbmOt7fIBS+/EX/JmnQ/sVhlrhQT/uKoMwwsbQWTB3UY
	8KMBltM5c2+VWSvfFXOH88Pg34EIRn8ReflUNOvM8MFqYjNkvncwoViYMoZDxEnYCEws8wZo5Fw
	LT0I/lQhGmDJQo4AbbaRyvMkxCkTI/lnGzuZKaRrxubSoKW1qXHQE3biij+/yjAX89i748a2i
X-Google-Smtp-Source: AGHT+IGPwe4k1nSiLo3Q7fXg2P2eLKRZ1aglm2SdrtFWVXuSkGkjq+3L8RzYMElaCZp3EfcaDxFBpg==
X-Received: by 2002:a05:600c:350b:b0:46e:36fa:6b40 with SMTP id 5b1f17b1804b1-46e36fa6c4emr125120035e9.24.1759170777268;
        Mon, 29 Sep 2025 11:32:57 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e56f76b21sm21984265e9.19.2025.09.29.11.32.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 11:32:56 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: Peter Maydell <peter.maydell@linaro.org>,
	qemu-devel@nongnu.org
Cc: Stefano Stabellini <sstabellini@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	kvm@vger.kernel.org,
	Eric Farman <farman@linux.ibm.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	xen-devel@lists.xenproject.org,
	Paul Durrant <paul@xen.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Anthony PERARD <anthony@xenproject.org>,
	qemu-s390x@nongnu.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [PATCH 00/15] system/physmem: Remove cpu_physical_memory _is_io() and _rw()
Date: Mon, 29 Sep 2025 20:32:39 +0200
Message-ID: <20250929183254.85478-1-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

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

Philippe Mathieu-Daudé (15):
  docs/devel/loads-stores: Stop mentioning
    cpu_physical_memory_write_rom()
  system/memory: Factor address_space_memory_is_io() out
  target/i386/arch_memory_mapping: Use address_space_memory_is_io()
  hw/s390x/sclp: Use address_space_memory_is_io() in sclp_service_call()
  system/physmem: Remove cpu_physical_memory_is_io()
  system/physmem: Pass address space argument to
    cpu_flush_icache_range()
  target/s390x/mmu: Replace [cpu_physical_memory -> address_space]_rw()
  target/i386/whpx: Replace legacy cpu_physical_memory_rw() call
  target/i386/kvm: Replace legacy cpu_physical_memory_rw() call
  target/i386/nvmm: Inline cpu_physical_memory_rw() in nvmm_mem_callback
  hw/xen/hvm: Inline cpu_physical_memory_rw() in rw_phys_req_item()
  system/physmem: Un-inline cpu_physical_memory_read/write()
  system/physmem: Inline cpu_physical_memory_rw() and remove it
  hw/virtio/vhost: Replace legacy cpu_physical_memory_*map() calls
  hw/virtio/virtio: Replace legacy cpu_physical_memory_map() call

 docs/devel/loads-stores.rst            |  6 ++--
 scripts/coccinelle/exec_rw_const.cocci | 22 --------------
 include/exec/cpu-common.h              | 18 ++---------
 include/system/memory.h                | 12 ++++++++
 hw/core/loader.c                       |  2 +-
 hw/s390x/sclp.c                        | 14 ++++++---
 hw/virtio/vhost.c                      |  6 ++--
 hw/virtio/virtio.c                     | 10 +++---
 hw/xen/xen-hvm-common.c                |  8 +++--
 system/physmem.c                       | 42 ++++++++++++++------------
 target/i386/arch_memory_mapping.c      | 10 +++---
 target/i386/kvm/xen-emu.c              |  4 ++-
 target/i386/nvmm/nvmm-all.c            |  5 ++-
 target/i386/whpx/whpx-all.c            |  7 +++--
 target/s390x/mmu_helper.c              |  6 ++--
 15 files changed, 84 insertions(+), 88 deletions(-)

-- 
2.51.0


