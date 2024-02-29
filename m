Return-Path: <kvm+bounces-10358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1C3F86C0C2
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:38:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A1561F237AF
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 313FF446BF;
	Thu, 29 Feb 2024 06:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WVUMMorF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F8E446B4
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188676; cv=none; b=p74mXNOUhVIrvBiDXrMW/+bXEhfvhYHsGYuzBR4iaXdWa2bbN+GNhRDwdzsnv08sYHMvCqSzz5kdJnkKHe6DqQGkKks3KpsAeYSBrp0l5R/08Mb8+ADr8t3DRAFEDJbm5wCVQQCDnHToyuSvmINHvK2x7FkvkTfBlOe0R+5r/0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188676; c=relaxed/simple;
	bh=Ia2FICNfPSSHLWggN4z7qSIWJ30dKn6rUCrvq+3oMaY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Vdl3BRZSj/b9g9vkHdECU588/ZUBPUQWxKjs4yLWQ4oiSrHGe8KK9QqF5rp6AAy1ZTsbMeZZtdEYMhduCPG+Lvm0dpqU6L/Hzc4MyYzx1omcKfUYp5BaxINCDznLkEHh0d67qvvfKB5KPaE6+jghaRMybjZ3IQ7QlpzufH+oo80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WVUMMorF; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188674; x=1740724674;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ia2FICNfPSSHLWggN4z7qSIWJ30dKn6rUCrvq+3oMaY=;
  b=WVUMMorF3Tss96jxRV40VYZ83ojFpPgtp0n4W8/x+ETAuyvvsj+1tIEn
   kQDIXa7Kx9A1bfwHAPykOZ+KWUqRMSh9w77zpgRbcfq4WSrAbrcsbIorv
   P5G6wPGwG+4+dL/oK2mZ5Iza3fAhK0mQWAeq5C4yV15vKWWh0VXduKkAa
   SEleh8WyinSLji/BvCkXFvwEvjJ/Tp0A7XtgPLDe5bnVvmCIfERmkdOkh
   jj3DaGl2bqB4AU8NGo+oBBbn+Sh96lVi/j7bm2pvdBAoiXYmDhgu7JK3C
   UzKZJI2Z03zw6HVF7VmmhCUR28vnIC07nDe9VqlsqOXKFJbnH+Eva4uAQ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3802463"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3802463"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:37:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8074629"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:37:48 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	xiaoyao.li@intel.com
Subject: [PATCH v5 03/65] HostMem: Add mechanism to opt in kvm guest memfd via MachineState
Date: Thu, 29 Feb 2024 01:36:24 -0500
Message-Id: <20240229063726.610065-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240229063726.610065-1-xiaoyao.li@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
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
Reviewed-by: David Hildenbrand <david@redhat.com>
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
index 81a72ce40b78..eb9682b4a856 100644
--- a/backends/hostmem.c
+++ b/backends/hostmem.c
@@ -277,6 +277,7 @@ static void host_memory_backend_init(Object *obj)
     /* TODO: convert access to globals to compat properties */
     backend->merge = machine_mem_merge(machine);
     backend->dump = machine_dump_guest_core(machine);
+    backend->guest_memfd = machine_require_guest_memfd(machine);
     backend->reserve = true;
     backend->prealloc_threads = machine->smp.cpus;
 }
diff --git a/hw/core/machine.c b/hw/core/machine.c
index 9ac5d5389a6c..651a3d463a06 100644
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


