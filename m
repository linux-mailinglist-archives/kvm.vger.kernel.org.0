Return-Path: <kvm+bounces-52805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 46088B09687
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 23:49:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE3AD1C21BFD
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 21:49:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A4A42571B8;
	Thu, 17 Jul 2025 21:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iHZS3gQS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD75E227E9B;
	Thu, 17 Jul 2025 21:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752788872; cv=none; b=jENVSPTkg5IUL5sJctY43pRFciaZJLVhGe+kQBT6s77TiImB+udkakfF3YaBlpAsP9QkkidREJ7laga43ATp5706jyHmtCoGFyKljfVcgn10UbIjjNL4PBKBAGRQlPj0thHvBVCjFMFS0c/gDAw20Z8SPUu0A7Kox2dS3upG7+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752788872; c=relaxed/simple;
	bh=ahOiCUs+Yg+YQbOgK04CJLyH5SnWaNojDAAU7pvqq/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9kN83FmCu9eeOqhpA8p5ep9FU0AVkEH+c3bJ1s2YzfWkpF3AmUFW64rs1OVOG6efVnQIqQrLSSoAa/4Tep237lbIoHzpzSveQ9J9XkYAX66OHSvi4nKA47Ih5zZb6DhXPEjzQKOIyS+T+bmv/IB/AjLaFYhYxcNiVi5Y6NUYuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iHZS3gQS; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752788871; x=1784324871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ahOiCUs+Yg+YQbOgK04CJLyH5SnWaNojDAAU7pvqq/Y=;
  b=iHZS3gQSse89njZpb3Ubugo7VS3VuOJnc8chiJM3SEltm72Q2wWHXNGW
   JZ5VnXKiaX8ZwTf+LUQZ5UZ643XoHOBZOS6TkRGh/5d1hQq45YHeOHmxV
   ui3bJ3AD3fzFv/PXAdeJStNsZLuiw1R3rNNjkZ66Uhtj3vPzIWfQH1pXh
   DOADOxaym/mGM6/tSY5hD/3DYVDEDvqFn0POgtd3boTfL7qjwL1ceRSCf
   cVebUDMadwKQ28d5xCjqzHYre+7dXFTMbffgjLqX34nvOarOTDZnn5jlM
   v//FNxsZ/iFe553Ka1dKthNrgi5AlsFhiR/bTQhH1CrV8NTDx7gjaR16j
   w==;
X-CSE-ConnectionGUID: X/7KiMrQRGSu1wV748psWw==
X-CSE-MsgGUID: tiw1vh0+Rc2+Hf94mS7erQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="66527858"
X-IronPort-AV: E=Sophos;i="6.16,319,1744095600"; 
   d="scan'208";a="66527858"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 14:47:51 -0700
X-CSE-ConnectionGUID: Z6CfNKPmTQubgc4dCZ9uSQ==
X-CSE-MsgGUID: /3GsRR2uQCaHkWewtBKG4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,319,1744095600"; 
   d="scan'208";a="157295559"
Received: from vverma7-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.221.39])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 14:47:45 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	thomas.lendacky@amd.com
Cc: x86@kernel.org,
	kas@kernel.org,
	rick.p.edgecombe@intel.com,
	dwmw@amazon.co.uk,
	linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	dan.j.williams@intel.com,
	ashish.kalra@amd.com,
	nik.borisov@suse.com,
	chao.gao@intel.com,
	sagis@google.com,
	Farrah Chen <farrah.chen@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH v4 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX SEAMCALLs
Date: Fri, 18 Jul 2025 09:46:44 +1200
Message-ID: <a85faae420b2a52bd8a3022900ffa8351c66d1ed.1752730040.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1752730040.git.kai.huang@intel.com>
References: <cover.1752730040.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On TDX platforms, during kexec, the kernel needs to make sure there are
no dirty cachelines of TDX private memory before booting to the new
kernel to avoid silent memory corruption to the new kernel.

During kexec, the kexec-ing CPU firstly invokes native_stop_other_cpus()
to stop all remote CPUs before booting to the new kernel.  The remote
CPUs will then execute stop_this_cpu() to stop themselves.

The kernel has a percpu boolean to indicate whether the cache of a CPU
may be in incoherent state.  In stop_this_cpu(), the kernel does WBINVD
if that percpu boolean is true.

TDX turns on that percpu boolean on a CPU when the kernel does SEAMCALL.
This makes sure the caches will be flushed during kexec.

However, the native_stop_other_cpus() and stop_this_cpu() have a "race"
which is extremely rare to happen but could cause the system to hang.

Specifically, the native_stop_other_cpus() firstly sends normal reboot
IPI to remote CPUs and waits one second for them to stop.  If that times
out, native_stop_other_cpus() then sends NMIs to remote CPUs to stop
them.

The aforementioned race happens when NMIs are sent.  Doing WBINVD in
stop_this_cpu() makes each CPU take longer time to stop and increases
the chance of the race happening.

Explicitly flush cache in tdx_disable_virtualization_cpu() after which
no more TDX activity can happen on this cpu.  This moves the WBINVD to
an earlier stage than stop_this_cpus(), avoiding a possibly lengthy
operation at a time where it could cause this race.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
---

v3 -> v4:
 - Change doing wbinvd() from rebooting notifier to
   tdx_disable_virtualization_cpu() to cover the case where more
   SEAMCALL can be made after cache flush, i.e., doing kexec when
   there's TD alive.  - Chao.
 - Add check to skip wbinvd if the boolean is false. -- Chao
 - Fix typo in the comment -- Binbin.

---
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/kvm/vmx/tdx.c      | 12 ++++++++++++
 arch/x86/virt/vmx/tdx/tdx.c | 12 ++++++++++++
 3 files changed, 26 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 6865f62436ad..5f1f4e8594c0 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -221,6 +221,7 @@ u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, u64 level, u64 *ext_err1, u6
 u64 tdh_phymem_cache_wb(bool resume);
 u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
 u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page);
+void tdx_cpu_flush_cache(void);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
@@ -228,6 +229,7 @@ static inline int tdx_enable(void)  { return -ENODEV; }
 static inline u32 tdx_get_nr_guest_keyids(void) { return 0; }
 static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
 static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
+static inline void tdx_cpu_flush_cache(void) { }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLER__ */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f31ccdeb905b..478baaa1bfb5 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -444,6 +444,18 @@ void tdx_disable_virtualization_cpu(void)
 		tdx_flush_vp(&arg);
 	}
 	local_irq_restore(flags);
+
+	/*
+	 * No more TDX activity on this CPU from here.  Flush cache to
+	 * avoid having to do WBINVD in stop_this_cpu() during kexec.
+	 *
+	 * Kexec calls native_stop_other_cpus() to stop remote CPUs
+	 * before booting to new kernel, but that code has a "race"
+	 * when the normal REBOOT IPI times out and NMIs are sent to
+	 * remote CPUs to stop them.  Doing WBINVD in stop_this_cpu()
+	 * could potentially increase the possibility of the "race".
+	 */
+	tdx_cpu_flush_cache();
 }
 
 #define TDX_SEAMCALL_RETRIES 10000
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index d6ee4e5a75d2..c098a6e0382b 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1870,3 +1870,15 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
 	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
+
+void tdx_cpu_flush_cache(void)
+{
+	lockdep_assert_preemption_disabled();
+
+	if (!this_cpu_read(cache_state_incoherent))
+		return;
+
+	wbinvd();
+	this_cpu_write(cache_state_incoherent, false);
+}
+EXPORT_SYMBOL_GPL(tdx_cpu_flush_cache);
-- 
2.50.0


