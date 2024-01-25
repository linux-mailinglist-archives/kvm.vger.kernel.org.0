Return-Path: <kvm+bounces-6905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D87583B7CB
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:28:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4BB8BB2351E
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 820088495;
	Thu, 25 Jan 2024 03:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Iewozhje"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90776FD5
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153287; cv=none; b=Kfj0EeL5t3+moqzp1woQz05ycunAcfNkkDkn0O5nma0KgOQw/JmstjH97d6bGUWIAsSBU5Qua6sKq/K33e8t3fnfDbpHXkwO2L0pwwepydJUKB7JWiJ+SiGnMsKcMkxn+X8aUftB8IQ9thb31eaEas7S2eg7OZ9iQ2veBKfjmzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153287; c=relaxed/simple;
	bh=2mNwsjv6vluae8uBwx0X4bXjQ8lU44YLJ4VZgJtV40o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XooMykxEN2eJpyZ8yHuogy5FUvWSBXbhz3nfr+pSvejZcBz0d/tpKm0vvp5qu5qJ4JaJuUUyhGa0eB7V3KDLyJ88adgA7DxW44pUBZjYm8g+WnrhW9+LbMFYC12aIZI5OSZ9dO+IMfjRpD2vUOSaaspe9+omgdwRBvuzQAu378Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Iewozhje; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153286; x=1737689286;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2mNwsjv6vluae8uBwx0X4bXjQ8lU44YLJ4VZgJtV40o=;
  b=IewozhjedzRzUFhz8P4/fTykDHETByms4j0CHrn6kD1iHI8iWsaTDeTA
   53EriQYdLm+Y35eddaFm0OHnFtRK28iaqoFp5oEjWEXIAUlP9BMOc5k0+
   AzRttY3hQI8G6SDM09QdYrKj8K4rrRYlaUx2Bnz+ODVdS437HMUZ7YPeR
   jJbF0/HTr24ypGtSbSSgOyjc/xj+8zkIo65jm4HR0jwCXgQNoLDj0SJg8
   Sh00u/F4cLuoGJgGhk16tjiA2PSAS7H4MaHHPDbJ//8QipwI/P+yBEMzp
   K7V4Xzq+Lpdg9GbNdml1g07jsGtVJZBn4czgRFxOpK253fVJFecWJgQMU
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9427924"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9427924"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:23:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2084440"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:23:48 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v4 03/66] HostMem: Add mechanism to opt in kvm guest memfd via MachineState
Date: Wed, 24 Jan 2024 22:22:25 -0500
Message-Id: <20240125032328.2522472-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125032328.2522472-1-xiaoyao.li@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new member "guest_memfd" to memory backends. When it's set
to true, it enables RAM_GUEST_MEMFD in ram_flags, thus private kvm
guest_memfd will be allocated during RAMBlock allocation.

Memory backend's @guest_memfd is wired with @require_guest_memfd
field of MachineState. It avoid looking up the machine in phymem.c.

MachineState::require_guest_memfd is supposed to be set by any VMs
that requires KVM guest memfd as private memory, e.g., TDX VM.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v4:
 - rename "require_guest_memfd" to "guest_memfd" in struct
   HostMemoryBackend;	(David Hildenbrand)
---
 backends/hostmem-file.c  | 1 +
 backends/hostmem-memfd.c | 1 +
 backends/hostmem-ram.c   | 1 +
 backends/hostmem.c       | 1 +
 hw/core/machine.c        | 5 +++++
 include/hw/boards.h      | 2 ++
 include/sysemu/hostmem.h | 1 +
 7 files changed, 12 insertions(+)

diff --git a/backends/hostmem-file.c b/backends/hostmem-file.c
index ac3e433cbddb..3c69db794607 100644
--- a/backends/hostmem-file.c
+++ b/backends/hostmem-file.c
@@ -85,6 +85,7 @@ file_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
     ram_flags |= fb->readonly ? RAM_READONLY_FD : 0;
     ram_flags |= fb->rom == ON_OFF_AUTO_ON ? RAM_READONLY : 0;
     ram_flags |= backend->reserve ? 0 : RAM_NORESERVE;
+    ram_flags |= backend->guest_memfd ? RAM_GUEST_MEMFD : 0;
     ram_flags |= fb->is_pmem ? RAM_PMEM : 0;
     ram_flags |= RAM_NAMED_FILE;
     return memory_region_init_ram_from_file(&backend->mr, OBJECT(backend), name,
diff --git a/backends/hostmem-memfd.c b/backends/hostmem-memfd.c
index 3923ea9364d5..745ead0034dc 100644
--- a/backends/hostmem-memfd.c
+++ b/backends/hostmem-memfd.c
@@ -55,6 +55,7 @@ memfd_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
     name = host_memory_backend_get_name(backend);
     ram_flags = backend->share ? RAM_SHARED : 0;
     ram_flags |= backend->reserve ? 0 : RAM_NORESERVE;
+    ram_flags |= backend->guest_memfd ? RAM_GUEST_MEMFD : 0;
     return memory_region_init_ram_from_fd(&backend->mr, OBJECT(backend), name,
                                           backend->size, ram_flags, fd, 0, errp);
 }
diff --git a/backends/hostmem-ram.c b/backends/hostmem-ram.c
index d121249f0f45..f7d81af783a5 100644
--- a/backends/hostmem-ram.c
+++ b/backends/hostmem-ram.c
@@ -30,6 +30,7 @@ ram_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
     name = host_memory_backend_get_name(backend);
     ram_flags = backend->share ? RAM_SHARED : 0;
     ram_flags |= backend->reserve ? 0 : RAM_NORESERVE;
+    ram_flags |= backend->guest_memfd ? RAM_GUEST_MEMFD : 0;
     return memory_region_init_ram_flags_nomigrate(&backend->mr, OBJECT(backend),
                                                   name, backend->size,
                                                   ram_flags, errp);
diff --git a/backends/hostmem.c b/backends/hostmem.c
index 30f69b2cb5e9..b1c39e8065e2 100644
--- a/backends/hostmem.c
+++ b/backends/hostmem.c
@@ -276,6 +276,7 @@ static void host_memory_backend_init(Object *obj)
     /* TODO: convert access to globals to compat properties */
     backend->merge = machine_mem_merge(machine);
     backend->dump = machine_dump_guest_core(machine);
+    backend->guest_memfd = machine_require_guest_memfd(machine);
     backend->reserve = true;
     backend->prealloc_threads = machine->smp.cpus;
 }
diff --git a/hw/core/machine.c b/hw/core/machine.c
index fb5afdcae4cc..514a201dc570 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -1192,6 +1192,11 @@ bool machine_mem_merge(MachineState *machine)
     return machine->mem_merge;
 }
 
+bool machine_require_guest_memfd(MachineState *machine)
+{
+    return machine->require_guest_memfd;
+}
+
 static char *cpu_slot_to_string(const CPUArchId *cpu)
 {
     GString *s = g_string_new(NULL);
diff --git a/include/hw/boards.h b/include/hw/boards.h
index bcfde8a84d10..2e6156ae96b8 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -36,6 +36,7 @@ bool machine_usb(MachineState *machine);
 int machine_phandle_start(MachineState *machine);
 bool machine_dump_guest_core(MachineState *machine);
 bool machine_mem_merge(MachineState *machine);
+bool machine_require_guest_memfd(MachineState *machine);
 HotpluggableCPUList *machine_query_hotpluggable_cpus(MachineState *machine);
 void machine_set_cpu_numa_node(MachineState *machine,
                                const CpuInstanceProperties *props,
@@ -370,6 +371,7 @@ struct MachineState {
     char *dt_compatible;
     bool dump_guest_core;
     bool mem_merge;
+    bool require_guest_memfd;
     bool usb;
     bool usb_disabled;
     char *firmware;
diff --git a/include/sysemu/hostmem.h b/include/sysemu/hostmem.h
index 0e411aaa29e1..04b884bf42a6 100644
--- a/include/sysemu/hostmem.h
+++ b/include/sysemu/hostmem.h
@@ -74,6 +74,7 @@ struct HostMemoryBackend {
     uint64_t size;
     bool merge, dump, use_canonical_path;
     bool prealloc, is_mapped, share, reserve;
+    bool guest_memfd;
     uint32_t prealloc_threads;
     ThreadContext *prealloc_context;
     DECLARE_BITMAP(host_nodes, MAX_NODES + 1);
-- 
2.34.1


