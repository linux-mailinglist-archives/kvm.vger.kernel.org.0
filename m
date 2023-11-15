Return-Path: <kvm+bounces-1731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EF5C7EBD75
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:16:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AD5B5B20C35
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 036D74C8C;
	Wed, 15 Nov 2023 07:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jWyHELvA"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E7E4683
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:16:03 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14702E9
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:16:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032562; x=1731568562;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=675d/MVn3wkxE3sp0f5OWV9Jqe7zvqxarkQwkl/J4nU=;
  b=jWyHELvAnTPb/3Lhe+oIEBtNn2I6uUqE22obKkWHMHiXXPpfGfcVbBHX
   OvSxzn8aQbK0q6AvYus/g3V9Z50OzXaX804P0wjyD6TpEjM1UOhKuqG/V
   lhQ65jYM8VmfUW4eQnCaVeve5tFx9dU12xaq4aB+EQNgN2JmbJjN1fVN3
   11YsdW72/HltsXU4cqBDU75yuLigCAymZy69mhfmwfRrxbmOx9hmxdIXX
   0hdlP4Vjgk0CcGYMw6so2our56AFsfN0uDpQRcT2vM9hhaxbIYTPs7B1l
   jkoe8iGRfGTSKNG12N/0ymmFl2HFpoKGEe35YZALeN8/XOfTYsvgRIbzE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390622109"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390622109"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:16:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714796882"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714796882"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:15:54 -0800
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
Subject: [PATCH v3 04/70] HostMem: Add mechanism to opt in kvm guest memfd via MachineState
Date: Wed, 15 Nov 2023 02:14:13 -0500
Message-Id: <20231115071519.2864957-5-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115071519.2864957-1-xiaoyao.li@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new member "require_guest_memfd" to memory backends. When it's set
to true, it enables RAM_GUEST_MEMFD in ram_flags, thus private kvm
guest_memfd will be allocated during RAMBlock allocation.

Memory backend's @require_guest_memfd is wired with @require_guest_memfd
field of MachineState. MachineState::require_guest_memfd is supposed to
be set by any VMs that requires KVM guest memfd as private memory, e.g.,
TDX VM.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
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
index 361d4a8103ef..d5ea2879f321 100644
--- a/backends/hostmem-file.c
+++ b/backends/hostmem-file.c
@@ -84,6 +84,7 @@ file_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
     ram_flags |= fb->readonly ? RAM_READONLY_FD : 0;
     ram_flags |= fb->rom == ON_OFF_AUTO_ON ? RAM_READONLY : 0;
     ram_flags |= backend->reserve ? 0 : RAM_NORESERVE;
+    ram_flags |= backend->require_guest_memfd ? RAM_GUEST_MEMFD : 0;
     ram_flags |= fb->is_pmem ? RAM_PMEM : 0;
     ram_flags |= RAM_NAMED_FILE;
     memory_region_init_ram_from_file(&backend->mr, OBJECT(backend), name,
diff --git a/backends/hostmem-memfd.c b/backends/hostmem-memfd.c
index 3fc85c3db81b..011e2311f088 100644
--- a/backends/hostmem-memfd.c
+++ b/backends/hostmem-memfd.c
@@ -55,6 +55,7 @@ memfd_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
     name = host_memory_backend_get_name(backend);
     ram_flags = backend->share ? RAM_SHARED : 0;
     ram_flags |= backend->reserve ? 0 : RAM_NORESERVE;
+    ram_flags |= backend->require_guest_memfd ? RAM_GUEST_MEMFD : 0;
     memory_region_init_ram_from_fd(&backend->mr, OBJECT(backend), name,
                                    backend->size, ram_flags, fd, 0, errp);
     g_free(name);
diff --git a/backends/hostmem-ram.c b/backends/hostmem-ram.c
index b8e55cdbd0f8..7d2e1327f8c8 100644
--- a/backends/hostmem-ram.c
+++ b/backends/hostmem-ram.c
@@ -30,6 +30,7 @@ ram_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
     name = host_memory_backend_get_name(backend);
     ram_flags = backend->share ? RAM_SHARED : 0;
     ram_flags |= backend->reserve ? 0 : RAM_NORESERVE;
+    ram_flags |= backend->require_guest_memfd ? RAM_GUEST_MEMFD : 0;
     memory_region_init_ram_flags_nomigrate(&backend->mr, OBJECT(backend), name,
                                            backend->size, ram_flags, errp);
     g_free(name);
diff --git a/backends/hostmem.c b/backends/hostmem.c
index 747e7838c031..2deb2b78bcb8 100644
--- a/backends/hostmem.c
+++ b/backends/hostmem.c
@@ -279,6 +279,7 @@ static void host_memory_backend_init(Object *obj)
     /* TODO: convert access to globals to compat properties */
     backend->merge = machine_mem_merge(machine);
     backend->dump = machine_dump_guest_core(machine);
+    backend->require_guest_memfd = machine_require_guest_memfd(machine);
     backend->reserve = true;
     backend->prealloc_threads = machine->smp.cpus;
 }
diff --git a/hw/core/machine.c b/hw/core/machine.c
index 0c1739814124..b1b0a46ea52f 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -1189,6 +1189,11 @@ bool machine_mem_merge(MachineState *machine)
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
index a7359992980a..227aded07209 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -30,6 +30,7 @@ bool machine_usb(MachineState *machine);
 int machine_phandle_start(MachineState *machine);
 bool machine_dump_guest_core(MachineState *machine);
 bool machine_mem_merge(MachineState *machine);
+bool machine_require_guest_memfd(MachineState *machine);
 HotpluggableCPUList *machine_query_hotpluggable_cpus(MachineState *machine);
 void machine_set_cpu_numa_node(MachineState *machine,
                                const CpuInstanceProperties *props,
@@ -364,6 +365,7 @@ struct MachineState {
     char *dt_compatible;
     bool dump_guest_core;
     bool mem_merge;
+    bool require_guest_memfd;
     bool usb;
     bool usb_disabled;
     char *firmware;
diff --git a/include/sysemu/hostmem.h b/include/sysemu/hostmem.h
index 39326f1d4f9c..92f7fd469639 100644
--- a/include/sysemu/hostmem.h
+++ b/include/sysemu/hostmem.h
@@ -66,6 +66,7 @@ struct HostMemoryBackend {
     uint64_t size;
     bool merge, dump, use_canonical_path;
     bool prealloc, is_mapped, share, reserve;
+    bool require_guest_memfd;
     uint32_t prealloc_threads;
     ThreadContext *prealloc_context;
     DECLARE_BITMAP(host_nodes, MAX_NODES + 1);
-- 
2.34.1


