Return-Path: <kvm+bounces-71091-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eJ2jFKzPj2l7TwEAu9opvQ
	(envelope-from <kvm+bounces-71091-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:28:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B18213AA67
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:28:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 050DF30229BA
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 01:27:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77B6E2BE65B;
	Sat, 14 Feb 2026 01:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q0/uub6e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81C52C027C
	for <kvm@vger.kernel.org>; Sat, 14 Feb 2026 01:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771032451; cv=none; b=tdStC02S48ODe13EcYlwWec1eO2Vc1XCd7Q4EWTPgiJ57kAekfg0DHBrmo4XHjb/JapsMtKzd5L/5Bbme3JsrgPKHsOIpd/CUUOE2ZQMz9y/ZGWvcNEcKtM57P8xdhGZ1dggCDbJW7EsUdilqbZlrNKq6uS/7ddpydCH2y9qeYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771032451; c=relaxed/simple;
	bh=veezVVvkHI8EJ5vDQW8W/d9IuIsrwRrbe2kmw/QFdRo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oWZbrLpNIAQJ195aKcoXbKOApM5AxiE3Nu7yPFhXjf38NU9AIBGoB48HOIjRUpu6uGRAn/RRhSaxrnMoX6gpdrRrCCjjg2Prhr54uVsi4QlmtlwY1M0aJqoGGgWpPa6/85bOf1fuknEYeqQYgoad21S3qyVYJDiZyXM1IyD4j9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q0/uub6e; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2aad3f8367bso17074535ad.0
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 17:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771032445; x=1771637245; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RoaSnnMV3Xy+vejoQwjN3YFWS5VqZgJOGJUK0ulpbmA=;
        b=Q0/uub6ea121aK9cqTQIZ+qIC6cgjYlK3fWyk322qngzCp3kF0BYgNqlLovAI7VOuF
         N8LVFcj0WYZsFxawv90WLXGvnUC0/XmSG/nxpcPmE5NKMmrNSI9gMZh7f2QAWvjc4DgS
         gv0igUSRmHn/s6wPmgCbVqS4h0ujW7xlaVq50sk/5iD/pXafkr5Wjcn5O9hS/IKxJraf
         hpIAy3+CcR9jVU1ETF395ODz8lw3bJphJY/9eDFiMiBp48LIUW+lMA/nicvg8VDxDec2
         yOMqdOg09j/y0I3gbagKPmgLiqYb37brz4Cqg467MIc+gqGdl0gkuGXKahnlSbf2vO+9
         Nw6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771032445; x=1771637245;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RoaSnnMV3Xy+vejoQwjN3YFWS5VqZgJOGJUK0ulpbmA=;
        b=naRBsGYDr5BAXQCk2jEh+NoMy9Mkz6FFMD95osQ/Qw02Y6i/pBJgBY977aNJzFPc70
         8v9Ium2DxM6mQbMizHVSHoswJ4EnoaXeGpmYyYl9MBXpfno0XI+vBRrSSZXBsnwXEd3M
         1L1x1iSW6Q12Wgx7Nos+r/UGW/CEOIkgmu81M44hytknvQlKNXxMJe6TdzYLbLJHC+Ig
         Cmrx1bCzLI6fZAQZjgq0uHzExgnFLVWdXCL6e9777bpNYNteQVvdTX7eqIyX8iSw5ULm
         +jpBBFoEpVU2nGcic1I4CB1iTVGRvj6MkvsCnBuj4x4mMJZB2xXn8Lf6BDDcLuobljex
         8wrA==
X-Forwarded-Encrypted: i=1; AJvYcCXA9bE30j+Nj8FjOYdlZ4BuiKEl2OMPkGEiHa0fDqUqNCiJgZogk4MpF9+6qRBYpkZ0vpw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7LDilj/GXtxkch4TR0iO1oJF708N0H3n+hyEaDEDsJOxogX11
	haMP6JqFmbgqpO5QTrbdEkqahVRXupH/qaOBmwRCz1yLz6pktqnM0+k64idGxq9OCvYkuDkwKiH
	9+17Sew==
X-Received: from plhd16.prod.google.com ([2002:a17:903:2310:b0:2aa:d61d:b14c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:46ce:b0:2a8:fc56:a3e6
 with SMTP id d9443c01a7336-2ad174a09camr11139595ad.24.1771032445181; Fri, 13
 Feb 2026 17:27:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Feb 2026 17:26:57 -0800
In-Reply-To: <20260214012702.2368778-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260214012702.2368778-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <20260214012702.2368778-12-seanjc@google.com>
Subject: [PATCH v3 11/16] KVM: x86/tdx: Do VMXON and TDX-Module initialization
 during subsys init
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71091-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 0B18213AA67
X-Rspamd-Action: no action

Now that VMXON can be done without bouncing through KVM, do TDX-Module
initialization during subsys init (specifically before module_init() so
that it runs before KVM when both are built-in).  Aside from the obvious
benefits of separating core TDX code from KVM, this will allow tagging a
pile of TDX functions and globals as being __init and __ro_after_init.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/arch/x86/tdx.rst |  36 +------
 arch/x86/include/asm/tdx.h     |   4 -
 arch/x86/kvm/vmx/tdx.c         | 148 ++++++-----------------------
 arch/x86/virt/vmx/tdx/tdx.c    | 168 +++++++++++++++++++--------------
 arch/x86/virt/vmx/tdx/tdx.h    |   8 --
 5 files changed, 130 insertions(+), 234 deletions(-)

diff --git a/Documentation/arch/x86/tdx.rst b/Documentation/arch/x86/tdx.rst
index 61670e7df2f7..ff6b110291bc 100644
--- a/Documentation/arch/x86/tdx.rst
+++ b/Documentation/arch/x86/tdx.rst
@@ -60,44 +60,18 @@ Besides initializing the TDX module, a per-cpu initialization SEAMCALL
 must be done on one cpu before any other SEAMCALLs can be made on that
 cpu.
 
-The kernel provides two functions, tdx_enable() and tdx_cpu_enable() to
-allow the user of TDX to enable the TDX module and enable TDX on local
-cpu respectively.
-
-Making SEAMCALL requires VMXON has been done on that CPU.  Currently only
-KVM implements VMXON.  For now both tdx_enable() and tdx_cpu_enable()
-don't do VMXON internally (not trivial), but depends on the caller to
-guarantee that.
-
-To enable TDX, the caller of TDX should: 1) temporarily disable CPU
-hotplug; 2) do VMXON and tdx_enable_cpu() on all online cpus; 3) call
-tdx_enable().  For example::
-
-        cpus_read_lock();
-        on_each_cpu(vmxon_and_tdx_cpu_enable());
-        ret = tdx_enable();
-        cpus_read_unlock();
-        if (ret)
-                goto no_tdx;
-        // TDX is ready to use
-
-And the caller of TDX must guarantee the tdx_cpu_enable() has been
-successfully done on any cpu before it wants to run any other SEAMCALL.
-A typical usage is do both VMXON and tdx_cpu_enable() in CPU hotplug
-online callback, and refuse to online if tdx_cpu_enable() fails.
-
 User can consult dmesg to see whether the TDX module has been initialized.
 
 If the TDX module is initialized successfully, dmesg shows something
 like below::
 
   [..] virt/tdx: 262668 KBs allocated for PAMT
-  [..] virt/tdx: module initialized
+  [..] virt/tdx: TDX-Module initialized
 
 If the TDX module failed to initialize, dmesg also shows it failed to
 initialize::
 
-  [..] virt/tdx: module initialization failed ...
+  [..] virt/tdx: TDX-Module initialization failed ...
 
 TDX Interaction to Other Kernel Components
 ------------------------------------------
@@ -129,9 +103,9 @@ CPU Hotplug
 ~~~~~~~~~~~
 
 TDX module requires the per-cpu initialization SEAMCALL must be done on
-one cpu before any other SEAMCALLs can be made on that cpu.  The kernel
-provides tdx_cpu_enable() to let the user of TDX to do it when the user
-wants to use a new cpu for TDX task.
+one cpu before any other SEAMCALLs can be made on that cpu.  The kernel,
+via the CPU hotplug framework, performs the necessary initialization when
+a CPU is first brought online.
 
 TDX doesn't support physical (ACPI) CPU hotplug.  During machine boot,
 TDX verifies all boot-time present logical CPUs are TDX compatible before
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 6b338d7f01b7..a149740b24e8 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -145,8 +145,6 @@ static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
 #define seamcall(_fn, _args)		sc_retry(__seamcall, (_fn), (_args))
 #define seamcall_ret(_fn, _args)	sc_retry(__seamcall_ret, (_fn), (_args))
 #define seamcall_saved_ret(_fn, _args)	sc_retry(__seamcall_saved_ret, (_fn), (_args))
-int tdx_cpu_enable(void);
-int tdx_enable(void);
 const char *tdx_dump_mce_info(struct mce *m);
 const struct tdx_sys_info *tdx_get_sysinfo(void);
 
@@ -223,8 +221,6 @@ u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
 u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page);
 #else
 static inline void tdx_init(void) { }
-static inline int tdx_cpu_enable(void) { return -ENODEV; }
-static inline int tdx_enable(void)  { return -ENODEV; }
 static inline u32 tdx_get_nr_guest_keyids(void) { return 0; }
 static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
 static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 582469118b79..0ac01c119336 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -59,7 +59,7 @@ module_param_named(tdx, enable_tdx, bool, 0444);
 #define TDX_SHARED_BIT_PWL_5 gpa_to_gfn(BIT_ULL(51))
 #define TDX_SHARED_BIT_PWL_4 gpa_to_gfn(BIT_ULL(47))
 
-static enum cpuhp_state tdx_cpuhp_state;
+static enum cpuhp_state tdx_cpuhp_state __ro_after_init;
 
 static const struct tdx_sys_info *tdx_sysinfo;
 
@@ -3294,10 +3294,7 @@ int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
 
 static int tdx_online_cpu(unsigned int cpu)
 {
-	/* Sanity check CPU is already in post-VMXON */
-	WARN_ON_ONCE(!(cr4_read_shadow() & X86_CR4_VMXE));
-
-	return tdx_cpu_enable();
+	return 0;
 }
 
 static int tdx_offline_cpu(unsigned int cpu)
@@ -3336,51 +3333,6 @@ static int tdx_offline_cpu(unsigned int cpu)
 	return -EBUSY;
 }
 
-static void __do_tdx_cleanup(void)
-{
-	/*
-	 * Once TDX module is initialized, it cannot be disabled and
-	 * re-initialized again w/o runtime update (which isn't
-	 * supported by kernel).  Only need to remove the cpuhp here.
-	 * The TDX host core code tracks TDX status and can handle
-	 * 'multiple enabling' scenario.
-	 */
-	WARN_ON_ONCE(!tdx_cpuhp_state);
-	cpuhp_remove_state_nocalls_cpuslocked(tdx_cpuhp_state);
-	tdx_cpuhp_state = 0;
-}
-
-static void __tdx_cleanup(void)
-{
-	cpus_read_lock();
-	__do_tdx_cleanup();
-	cpus_read_unlock();
-}
-
-static int __init __do_tdx_bringup(void)
-{
-	int r;
-
-	/*
-	 * TDX-specific cpuhp callback to call tdx_cpu_enable() on all
-	 * online CPUs before calling tdx_enable(), and on any new
-	 * going-online CPU to make sure it is ready for TDX guest.
-	 */
-	r = cpuhp_setup_state_cpuslocked(CPUHP_AP_ONLINE_DYN,
-					 "kvm/cpu/tdx:online",
-					 tdx_online_cpu, tdx_offline_cpu);
-	if (r < 0)
-		return r;
-
-	tdx_cpuhp_state = r;
-
-	r = tdx_enable();
-	if (r)
-		__do_tdx_cleanup();
-
-	return r;
-}
-
 static int __init __tdx_bringup(void)
 {
 	const struct tdx_sys_info_td_conf *td_conf;
@@ -3400,34 +3352,18 @@ static int __init __tdx_bringup(void)
 		}
 	}
 
-	/*
-	 * Enabling TDX requires enabling hardware virtualization first,
-	 * as making SEAMCALLs requires CPU being in post-VMXON state.
-	 */
-	r = kvm_enable_virtualization();
-	if (r)
-		return r;
-
-	cpus_read_lock();
-	r = __do_tdx_bringup();
-	cpus_read_unlock();
-
-	if (r)
-		goto tdx_bringup_err;
-
-	r = -EINVAL;
 	/* Get TDX global information for later use */
 	tdx_sysinfo = tdx_get_sysinfo();
-	if (WARN_ON_ONCE(!tdx_sysinfo))
-		goto get_sysinfo_err;
+	if (!tdx_sysinfo)
+		return -ENODEV;
 
 	/* Check TDX module and KVM capabilities */
 	if (!tdx_get_supported_attrs(&tdx_sysinfo->td_conf) ||
 	    !tdx_get_supported_xfam(&tdx_sysinfo->td_conf))
-		goto get_sysinfo_err;
+		return -EINVAL;
 
 	if (!(tdx_sysinfo->features.tdx_features0 & MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM))
-		goto get_sysinfo_err;
+		return -EINVAL;
 
 	/*
 	 * TDX has its own limit of maximum vCPUs it can support for all
@@ -3462,34 +3398,31 @@ static int __init __tdx_bringup(void)
 	if (td_conf->max_vcpus_per_td < num_present_cpus()) {
 		pr_err("Disable TDX: MAX_VCPU_PER_TD (%u) smaller than number of logical CPUs (%u).\n",
 				td_conf->max_vcpus_per_td, num_present_cpus());
-		goto get_sysinfo_err;
+		return -EINVAL;
 	}
 
 	if (misc_cg_set_capacity(MISC_CG_RES_TDX, tdx_get_nr_guest_keyids()))
-		goto get_sysinfo_err;
+		return -EINVAL;
 
 	/*
-	 * Leave hardware virtualization enabled after TDX is enabled
-	 * successfully.  TDX CPU hotplug depends on this.
+	 * TDX-specific cpuhp callback to disallow offlining the last CPU in a
+	 * packing while KVM is running one or more TDs.  Reclaiming HKIDs
+	 * requires doing PAGE.WBINVD on every package, i.e. offlining all CPUs
+	 * of a package would prevent reclaiming the HKID.
 	 */
+	r = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "kvm/cpu/tdx:online",
+			      tdx_online_cpu, tdx_offline_cpu);
+	if (r < 0)
+		goto err_cpuhup;
+
+	tdx_cpuhp_state = r;
 	return 0;
 
-get_sysinfo_err:
-	__tdx_cleanup();
-tdx_bringup_err:
-	kvm_disable_virtualization();
+err_cpuhup:
+	misc_cg_set_capacity(MISC_CG_RES_TDX, 0);
 	return r;
 }
 
-void tdx_cleanup(void)
-{
-	if (enable_tdx) {
-		misc_cg_set_capacity(MISC_CG_RES_TDX, 0);
-		__tdx_cleanup();
-		kvm_disable_virtualization();
-	}
-}
-
 int __init tdx_bringup(void)
 {
 	int r, i;
@@ -3521,39 +3454,11 @@ int __init tdx_bringup(void)
 		goto success_disable_tdx;
 	}
 
-	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
-		pr_err("tdx: MOVDIR64B is required for TDX\n");
-		goto success_disable_tdx;
-	}
-
-	if (!cpu_feature_enabled(X86_FEATURE_SELFSNOOP)) {
-		pr_err("Self-snoop is required for TDX\n");
-		goto success_disable_tdx;
-	}
-
 	if (!cpu_feature_enabled(X86_FEATURE_TDX_HOST_PLATFORM)) {
-		pr_err("tdx: no TDX private KeyIDs available\n");
+		pr_err("TDX not supported by the host platform\n");
 		goto success_disable_tdx;
 	}
 
-	if (!enable_virt_at_load) {
-		pr_err("tdx: tdx requires kvm.enable_virt_at_load=1\n");
-		goto success_disable_tdx;
-	}
-
-	/*
-	 * Ideally KVM should probe whether TDX module has been loaded
-	 * first and then try to bring it up.  But TDX needs to use SEAMCALL
-	 * to probe whether the module is loaded (there is no CPUID or MSR
-	 * for that), and making SEAMCALL requires enabling virtualization
-	 * first, just like the rest steps of bringing up TDX module.
-	 *
-	 * So, for simplicity do everything in __tdx_bringup(); the first
-	 * SEAMCALL will return -ENODEV when the module is not loaded.  The
-	 * only complication is having to make sure that initialization
-	 * SEAMCALLs don't return TDX_SEAMCALL_VMFAILINVALID in other
-	 * cases.
-	 */
 	r = __tdx_bringup();
 	if (r) {
 		/*
@@ -3568,8 +3473,6 @@ int __init tdx_bringup(void)
 		 */
 		if (r == -ENODEV)
 			goto success_disable_tdx;
-
-		enable_tdx = 0;
 	}
 
 	return r;
@@ -3579,6 +3482,15 @@ int __init tdx_bringup(void)
 	return 0;
 }
 
+void tdx_cleanup(void)
+{
+	if (!enable_tdx)
+		return;
+
+	misc_cg_set_capacity(MISC_CG_RES_TDX, 0);
+	cpuhp_remove_state(tdx_cpuhp_state);
+}
+
 void __init tdx_hardware_setup(void)
 {
 	KVM_SANITY_CHECK_VM_STRUCT_SIZE(kvm_tdx);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index dfd82fac0498..feea8dd6920d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -28,6 +28,7 @@
 #include <linux/log2.h>
 #include <linux/acpi.h>
 #include <linux/suspend.h>
+#include <linux/syscore_ops.h>
 #include <linux/idr.h>
 #include <linux/kvm_types.h>
 #include <asm/page.h>
@@ -39,6 +40,7 @@
 #include <asm/cpu_device_id.h>
 #include <asm/processor.h>
 #include <asm/mce.h>
+#include <asm/virt.h>
 #include "tdx.h"
 
 static u32 tdx_global_keyid __ro_after_init;
@@ -51,13 +53,11 @@ static DEFINE_PER_CPU(bool, tdx_lp_initialized);
 
 static struct tdmr_info_list tdx_tdmr_list;
 
-static enum tdx_module_status_t tdx_module_status;
-static DEFINE_MUTEX(tdx_module_lock);
-
 /* All TDX-usable memory regions.  Protected by mem_hotplug_lock. */
 static LIST_HEAD(tdx_memlist);
 
 static struct tdx_sys_info tdx_sysinfo;
+static bool tdx_module_initialized;
 
 typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
 
@@ -142,22 +142,15 @@ static int try_init_module_global(void)
 }
 
 /**
- * tdx_cpu_enable - Enable TDX on local cpu
- *
- * Do one-time TDX module per-cpu initialization SEAMCALL (and TDX module
- * global initialization SEAMCALL if not done) on local cpu to make this
- * cpu be ready to run any other SEAMCALLs.
- *
- * Return 0 on success, otherwise errors.
+ * Enable VMXON and then do one-time TDX module per-cpu initialization SEAMCALL
+ * (and TDX module global initialization SEAMCALL if not done) on local cpu to
+ * make this cpu be ready to run any other SEAMCALLs.
  */
-int tdx_cpu_enable(void)
+static int tdx_cpu_enable(void)
 {
 	struct tdx_module_args args = {};
 	int ret;
 
-	if (!boot_cpu_has(X86_FEATURE_TDX_HOST_PLATFORM))
-		return -ENODEV;
-
 	if (__this_cpu_read(tdx_lp_initialized))
 		return 0;
 
@@ -178,7 +171,58 @@ int tdx_cpu_enable(void)
 
 	return 0;
 }
-EXPORT_SYMBOL_FOR_KVM(tdx_cpu_enable);
+
+static int tdx_online_cpu(unsigned int cpu)
+{
+	int ret;
+
+	ret = x86_virt_get_ref(X86_FEATURE_VMX);
+	if (ret)
+		return ret;
+
+	ret = tdx_cpu_enable();
+	if (ret)
+		x86_virt_put_ref(X86_FEATURE_VMX);
+
+	return ret;
+}
+
+static int tdx_offline_cpu(unsigned int cpu)
+{
+	x86_virt_put_ref(X86_FEATURE_VMX);
+	return 0;
+}
+
+static void tdx_shutdown_cpu(void *ign)
+{
+	x86_virt_put_ref(X86_FEATURE_VMX);
+}
+
+static void tdx_shutdown(void *ign)
+{
+	on_each_cpu(tdx_shutdown_cpu, NULL, 1);
+}
+
+static int tdx_suspend(void *ign)
+{
+	x86_virt_put_ref(X86_FEATURE_VMX);
+	return 0;
+}
+
+static void tdx_resume(void *ign)
+{
+	WARN_ON_ONCE(x86_virt_get_ref(X86_FEATURE_VMX));
+}
+
+static const struct syscore_ops tdx_syscore_ops = {
+	.suspend = tdx_suspend,
+	.resume = tdx_resume,
+	.shutdown = tdx_shutdown,
+};
+
+static struct syscore tdx_syscore = {
+	.ops = &tdx_syscore_ops,
+};
 
 /*
  * Add a memory region as a TDX memory block.  The caller must make sure
@@ -1153,67 +1197,50 @@ static int init_tdx_module(void)
 	goto out_put_tdxmem;
 }
 
-static int __tdx_enable(void)
+static int tdx_enable(void)
 {
+	enum cpuhp_state state;
 	int ret;
 
+	if (!cpu_feature_enabled(X86_FEATURE_TDX_HOST_PLATFORM)) {
+		pr_err("TDX not supported by the host platform\n");
+		return -ENODEV;
+	}
+
+	if (!cpu_feature_enabled(X86_FEATURE_XSAVE)) {
+		pr_err("XSAVE is required for TDX\n");
+		return -EINVAL;
+	}
+
+	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
+		pr_err("MOVDIR64B is required for TDX\n");
+		return -EINVAL;
+	}
+
+	if (!cpu_feature_enabled(X86_FEATURE_SELFSNOOP)) {
+		pr_err("Self-snoop is required for TDX\n");
+		return -ENODEV;
+	}
+
+	state = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "virt/tdx:online",
+				  tdx_online_cpu, tdx_offline_cpu);
+	if (state < 0)
+		return state;
+
 	ret = init_tdx_module();
 	if (ret) {
-		pr_err("module initialization failed (%d)\n", ret);
-		tdx_module_status = TDX_MODULE_ERROR;
+		pr_err("TDX-Module initialization failed (%d)\n", ret);
+		cpuhp_remove_state(state);
 		return ret;
 	}
 
-	pr_info("module initialized\n");
-	tdx_module_status = TDX_MODULE_INITIALIZED;
+	register_syscore(&tdx_syscore);
 
+	tdx_module_initialized = true;
+	pr_info("TDX-Module initialized\n");
 	return 0;
 }
-
-/**
- * tdx_enable - Enable TDX module to make it ready to run TDX guests
- *
- * This function assumes the caller has: 1) held read lock of CPU hotplug
- * lock to prevent any new cpu from becoming online; 2) done both VMXON
- * and tdx_cpu_enable() on all online cpus.
- *
- * This function requires there's at least one online cpu for each CPU
- * package to succeed.
- *
- * This function can be called in parallel by multiple callers.
- *
- * Return 0 if TDX is enabled successfully, otherwise error.
- */
-int tdx_enable(void)
-{
-	int ret;
-
-	if (!boot_cpu_has(X86_FEATURE_TDX_HOST_PLATFORM))
-		return -ENODEV;
-
-	lockdep_assert_cpus_held();
-
-	mutex_lock(&tdx_module_lock);
-
-	switch (tdx_module_status) {
-	case TDX_MODULE_UNINITIALIZED:
-		ret = __tdx_enable();
-		break;
-	case TDX_MODULE_INITIALIZED:
-		/* Already initialized, great, tell the caller. */
-		ret = 0;
-		break;
-	default:
-		/* Failed to initialize in the previous attempts */
-		ret = -EINVAL;
-		break;
-	}
-
-	mutex_unlock(&tdx_module_lock);
-
-	return ret;
-}
-EXPORT_SYMBOL_FOR_KVM(tdx_enable);
+subsys_initcall(tdx_enable);
 
 static bool is_pamt_page(unsigned long phys)
 {
@@ -1464,15 +1491,10 @@ void __init tdx_init(void)
 
 const struct tdx_sys_info *tdx_get_sysinfo(void)
 {
-	const struct tdx_sys_info *p = NULL;
+	if (!tdx_module_initialized)
+		return NULL;
 
-	/* Make sure all fields in @tdx_sysinfo have been populated */
-	mutex_lock(&tdx_module_lock);
-	if (tdx_module_status == TDX_MODULE_INITIALIZED)
-		p = (const struct tdx_sys_info *)&tdx_sysinfo;
-	mutex_unlock(&tdx_module_lock);
-
-	return p;
+	return (const struct tdx_sys_info *)&tdx_sysinfo;
 }
 EXPORT_SYMBOL_FOR_KVM(tdx_get_sysinfo);
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 82bb82be8567..dde219c823b4 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -91,14 +91,6 @@ struct tdmr_info {
  * Do not put any hardware-defined TDX structure representations below
  * this comment!
  */
-
-/* Kernel defined TDX module status during module initialization. */
-enum tdx_module_status_t {
-	TDX_MODULE_UNINITIALIZED,
-	TDX_MODULE_INITIALIZED,
-	TDX_MODULE_ERROR
-};
-
 struct tdx_memblock {
 	struct list_head list;
 	unsigned long start_pfn;
-- 
2.53.0.310.g728cabbaf7-goog


