Return-Path: <kvm+bounces-59057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E574BAB499
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 06:13:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E48C716ADA0
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 04:13:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 921F7248F52;
	Tue, 30 Sep 2025 04:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MrOM86OT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B97438DE1
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 04:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759205612; cv=none; b=g403WlSC25Yhv+CmI5S/jgpDzBS4qygYJRtsMYp7Nnt4Vec7iKtBIY3yzEIEQvLpa5fkwMk92AlQa1ZRjPiSej8JAfHSLuAcAu23uqYHzI2YyCw0BOzbYw9sctR2aR9wfURAUHqQoNOfRIIP26Ixj7RJfpKVDJzDS0Ehog029UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759205612; c=relaxed/simple;
	bh=a7WfnCcoLHKPLZ5XsyDD2WKS+U+fIze+UYPSGtdf/gk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DlVwB5zly0fnd87/koPou0C0TeXqRoFHXUsYNbBRJD+pVdX7pCYB5OS1eT9PzMDtIgaSoeXmIXA4K4o3xeudBAENhZtVFb5klcw6qYkdYYby79Csx4OOmjeHfha/a5U2kf7V2FbNXkvDqYXME3U5qqT0KhqaISLzI3HDlrc4qLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MrOM86OT; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-46e5980471eso3788005e9.2
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 21:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759205609; x=1759810409; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LfIkfL6gj/tPGL1om2pz6zaZ+tStdg+utOiTzyFtZrQ=;
        b=MrOM86OTe+cnAGM4kt2lEqXkSXgc1sTe8PyCJ2I64VCLI2HdjhDCQsUZGf/GH8xQzv
         4bXprUDTx41h3C3+PVTOLxUD1Kx1kZFyDXgNAjY7xzN2CmqoGXTWxEgsCBVZkYpDNZUT
         FBVZrZhBU61MqETKHWPg72n/z89Kjcus6zVV4LrE1vkG+tCcn0lY1fDIh6l9wGYpjNDE
         ut4cjCzRlHYcKTcHuff7Q2IxK80871hclxFyV6isazuVDoYh3c1W4agW5rvSMxvjrWVL
         nT7t8yEY0mnKTM47wTPfiIZgHPBaJWTaT6HLxEEQCJFXut11Y+nbKzMCrXh+qgu9+Ct9
         td9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759205609; x=1759810409;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LfIkfL6gj/tPGL1om2pz6zaZ+tStdg+utOiTzyFtZrQ=;
        b=F9EMoJfutcCVY52R9UqNeHG2yag6ltDBpx6AvIxiZHyrMB6QET1g4w33NGKaN5tpoK
         O+zbr8zY4jrQHZAfc/nWGaIBEx7wSb4YYH1IozvlrvMAXDzYG4WlqQ0Qrz/08ateyBRX
         N2OxRdimM9WggjHNhQ73geVYL94wCLncbS8awfXDwDzl21GfpmDzDhVu6iZ8WpgDrmMP
         vDxYdRJwil+KF5SBbb/4Tt2IzHfiQtXzwvfOJd6/QbtM0YfC42V+hlmtkAyHgY9r3uL6
         KorngiE+ltki7fHKrhypcYzIdHGNDG65XH8CI7GSMYrqZMqeaz91M8FVLTPyaTaCOJFH
         svbw==
X-Forwarded-Encrypted: i=1; AJvYcCVq5vAONaHZ2DBCesRmJz/VyyJ2qsrQRV9YiAAqgX5vv1yavGsXkx4taAHPenHj9b1NBBk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFaqnH/vTzLnE/XMA6276sQD3ThLIcmzOeAfH9BanWlvlx6tav
	Zug5ho6KJH2aw+i6k27RZ3bVtdcCa/ndR+AfpR8XSuP4OuCE2AjAefxIt7tnFQzegnI=
X-Gm-Gg: ASbGnctET1eFR6oE2aMQdwDrVMTOzX/xgcPa1hfPtxJlgoOGDZ6r3jwV9mdW/Jje8Mk
	YcT4aHzmwPLL9jDqiN4LzjIdKhb6lMPyzfPkqMClGxIOL5hiKEDJwO50nURRPQvFJ3l1OfydClB
	8SA55ZvzkRRsMGZkl5pfH/WQWjpeB1Il5VLrrSHTpWxSyvddFHsbshdUOhGvNvUJKDIlVsXPCk8
	Df7Hgj0XVKFlM4BiS4BC37FS4nKvAnJCq6BoJnytl27Rui3m11EH2kdk1YQsAq+GOvnNTjoUnTp
	mqlw1A3GqPpd/j2P/dIcZ7yFQDI0onc0dBPbt0w3QI/I/2flegD0lHYgDowhuvCyBu5TJfS7Tgn
	Gqkskamag93hirOur4gkQRTCFKEcERNPBQpXDOXQUbiijky53u+m6XLtKRjZibGB/E7Skzazehr
	LH1th0SsV6BTq1mSw7gmZT
X-Google-Smtp-Source: AGHT+IGJB5LpSuDvwMbeYMOlRXcgfKRnczQzMLqCO1F91RV/zBDeRDsDtJpaavO640EWA/h8XFRCSw==
X-Received: by 2002:a05:600c:608d:b0:46e:4f25:aace with SMTP id 5b1f17b1804b1-46e510d28edmr61572215e9.6.1759205608862;
        Mon, 29 Sep 2025 21:13:28 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e5707c1e7sm37549775e9.21.2025.09.29.21.13.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 21:13:28 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Jason Herne <jjherne@linux.ibm.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	xen-devel@lists.xenproject.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	Eric Farman <farman@linux.ibm.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	kvm@vger.kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 00/17] system/physmem: Remove cpu_physical_memory _is_io() and _rw()
Date: Tue, 30 Sep 2025 06:13:08 +0200
Message-ID: <20250930041326.6448-1-philmd@linaro.org>
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
  system/physmem: Inline cpu_physical_memory_rw() and remove it
  hw/virtio/vhost: Replace legacy cpu_physical_memory_*map() calls
  hw/virtio/virtio: Replace legacy cpu_physical_memory_map() call

 docs/devel/loads-stores.rst            |  6 ++--
 scripts/coccinelle/exec_rw_const.cocci | 22 ------------
 include/exec/cpu-common.h              | 18 ++--------
 include/system/memory.h                | 16 +++++++--
 hw/core/loader.c                       |  2 +-
 hw/s390x/sclp.c                        | 14 +++++---
 hw/virtio/vhost.c                      |  6 ++--
 hw/virtio/virtio.c                     | 10 +++---
 hw/xen/xen-hvm-common.c                |  8 +++--
 system/physmem.c                       | 48 ++++++++++++++------------
 target/i386/arch_memory_mapping.c      | 10 +++---
 target/i386/kvm/xen-emu.c              |  4 ++-
 target/i386/nvmm/nvmm-all.c            |  5 ++-
 target/i386/whpx/whpx-all.c            |  7 ++--
 target/s390x/mmu_helper.c              |  6 ++--
 15 files changed, 89 insertions(+), 93 deletions(-)

-- 
2.51.0


