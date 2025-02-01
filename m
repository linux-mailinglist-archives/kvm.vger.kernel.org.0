Return-Path: <kvm+bounces-37014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D471A24602
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:51:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC9EF1676B5
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 00:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E11A49625;
	Sat,  1 Feb 2025 00:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zwRd8JYi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D701F61C
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 00:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738371057; cv=none; b=XvrrZk+RQDbN9xhcsWPb7ADEDkNNi46M3rsg0tk6/w1OoXTk5KU33A1wgIknTta6thJ5+VfBatXO9sHOl48KU9O9AR4VilshzbO1b6Ze9udYStOIeD2m9xHvgjMoYboDFAaEIUP/j6Be0IRxXRKc0orlE/vc+lrb5OjS1U3gmqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738371057; c=relaxed/simple;
	bh=Q0dVAZtcWC3kGSriq20XNsob1ps+6rdAl4KBthV0lsE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JcN96ENHlIK9wdwIHgLhH5ezeks42ZwqA9kbySAtFEtD5I1SkJMQCzU72i0lfA/Y1fqzc7KCVatG9Buod47kykepRBdelN9byJDxrJnbfOc/P8L+YVhH26n3bePYloDieKpoqw+pzbRaB/bPWWWxuavsgJfQx78XCE+UVJSGd9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zwRd8JYi; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9e38b0cfso4930400a91.0
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 16:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738371054; x=1738975854; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hoM9urIHNLcJgS4Dc2h2QR/XgwI2ycQ6Fgv8TpOxhpY=;
        b=zwRd8JYi18vRFX1iXQGiCjxldWd0x9tqHkJwq12s0oXEz+AILEj5mePMp7y1kXuomY
         TwUyfsGxptGe77MO4jSEsjaaUvaIB/YryLyXVK+Ety1N7cCfozWDdPPptwrPF7uy/WQl
         vaW7xYyklq5sZxDmhRFLXf3FEvFT5fRWfX7zcB3QH4ijkttLLUmG0w59Iy4XkFTs7m5k
         +YYDaQjTp+GpQwM6EJ9kWFzyA4HyKwGGQQGFByqn1vENYh0xhaEcrc860eDXr3WUvRkj
         8qTzrxfFv8VRxY1jJtpcjUXSnoC4AARhnedNFARMPHoaDQ5WSjX00t3+bQzTwUk7pl5H
         wvOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738371054; x=1738975854;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hoM9urIHNLcJgS4Dc2h2QR/XgwI2ycQ6Fgv8TpOxhpY=;
        b=ELyIOlBDQxRZXaIZnzDNLojMYLZuvUsUdSF4AifbAoQTt1A1zl4bKnb+Jw68zrFx2S
         GIli76hNB6yYqV1+rNe9E6Q+fYDWDEIDHyixRNQ/IHgXMH3HcZH3KGKTY7w0lT9x3GQL
         2d/c/9lp2NVrhALP6U3eWQXuKHQyLMUGLRlzYqVXs3/gUSyJr/torT+L4szmHp6ls5Ks
         ts98OankdbAl606cRpDSGyuiZowSIpnP5apWF6ojFaUpmr+pTkPOy0Jb49bWQe3VbAqj
         X6JSJ1KL09DRjDKf8nj+0mT5PLvkCCW+zYIJ2BGEsDFvCFHn6iQF3oTJS4eutR+hd184
         I4yg==
X-Forwarded-Encrypted: i=1; AJvYcCUEL2kGgqWUQrr6RrgrejzsfD26uapukzSkGoTM0ZFsoRBFtwVc4Y1vH7hhMjCHJiqKSbk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAMlyjfrK4gWdZu2f9EFT9cd5xY88e/dbVNKcR1uwt+TsrpmfE
	YmiPnLkl3Wfj9ezGTfEkpFhuADn6cm5PAFmKMBWRiJCp/7KowxzpCGitIvlfODXLYLNqvbyxd3C
	jyQ==
X-Google-Smtp-Source: AGHT+IGI421GnSBBqUYjOcLFGbdaN53zonktkZ1lI4ZcZUJ4Es2rBGDtWBpKi7KRzlsLCpJZRLs34Ghhh2c=
X-Received: from pjboh14.prod.google.com ([2002:a17:90b:3a4e:b0:2f5:63a:4513])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:51c6:b0:2ea:4c4f:bd20
 with SMTP id 98e67ed59e1d1-2f83ac86e65mr16933408a91.32.1738371053817; Fri, 31
 Jan 2025 16:50:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 16:50:48 -0800
In-Reply-To: <20250201005048.657470-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201005048.657470-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201005048.657470-3-seanjc@google.com>
Subject: [PATCH 2/2] x86/kvm: Override low memory above TOLUD to WB when MTRRs
 are forced WB
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Dionna Glaze <dionnaglaze@google.com>, 
	Peter Gonda <pgonda@google.com>, "=?UTF-8?q?J=C3=BCrgen=20Gro=C3=9F?=" <jgross@suse.com>, 
	Kirill Shutemov <kirill.shutemov@linux.intel.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Binbin Wu <binbin.wu@intel.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

When running as an SNP or TDX guest under KVM, treat the legacy PCI hole,
i.e. memory between Top of Lower Usable DRAM and 4GiB, as an untracked PAT
range to workaround issues with mapping legacy devices when MTRRs are
forced to WB.

In most KVM-based setups, legacy devices such as the HPET and TPM are
enumerated via ACPI.  For unknown reasons, ACPI auto-maps such devices as
WB, whereas the dedicated device drivers map memory as WC or UC.  In normal
setups, the entire mess "works" as firmware configures the PCI hole (and
other device memory) to be UC in the MTRRs.  As a result, the ACPI mappings
end up UC, which is compatible with the drivers' requested WC/UC-.

With WB MTRRs, the ACPI mappings get their requested WB.  If acpi_init()
runs before the corresponding device driver is probed, ACPI's WB mapping
will "win", and result in the driver's ioremap() failing because the
existing WB mapping isn't compatible with the requested WC/UC-.

E.g. when a TPM is emulated by the hypervisor (ignoring the security
implications of relying on what is allegedly an untrusted entity to store
measurements), the TPM driver will request UC and fail:

  [  1.730459] ioremap error for 0xfed40000-0xfed45000, requested 0x2, got =
0x0
  [  1.732780] tpm_tis MSFT0101:00: probe with driver tpm_tis failed with e=
rror -12

Note, the '0x2' and '0x0' values refer to "enum page_cache_mode", not x86's
memtypes (which frustratingly are an almost pure inversion; 2 =3D=3D WB, 0 =
=3D=3D UC).

The above trace is from a Google-VMM based VM, but the same behavior
happens with a QEMU based VM.  E.g. tracing mapping requests for HPET under
QEMU yields:

   Mapping HPET, req_type =3D 0
   WARNING: CPU: 5 PID: 1 at arch/x86/mm/pat/memtype.c:528 memtype_reserve+=
0x22f/0x3f0
   Call Trace:
    <TASK>
    __ioremap_caller.constprop.0+0xd6/0x330
    acpi_os_map_iomem+0x195/0x1b0
    acpi_ex_system_memory_space_handler+0x11c/0x2f0
    acpi_ev_address_space_dispatch+0x168/0x3b0
    acpi_ex_access_region+0xd7/0x280
    acpi_ex_field_datum_io+0x73/0x210
    acpi_ex_extract_from_field+0x267/0x2a0
    acpi_ex_read_data_from_field+0x8e/0x220
    acpi_ex_resolve_node_to_value+0xe2/0x2b0
    acpi_ds_evaluate_name_path+0xa9/0x100
    acpi_ds_exec_end_op+0x21f/0x4c0
    acpi_ps_parse_loop+0xf4/0x670
    acpi_ps_parse_aml+0x17b/0x3d0
    acpi_ps_execute_method+0x137/0x260
    acpi_ns_evaluate+0x1f0/0x2d0
    acpi_evaluate_object+0x13d/0x2e0
    acpi_evaluate_integer+0x50/0xe0
    acpi_bus_get_status+0x7b/0x140
    acpi_add_single_object+0x3f8/0x750
    acpi_bus_check_add+0xb2/0x340
    acpi_ns_walk_namespace+0xfe/0x200
    acpi_walk_namespace+0xbb/0xe0
    acpi_bus_scan+0x1b5/0x1d0
    acpi_scan_init+0xd5/0x290
    acpi_init+0x1fc/0x520
    do_one_initcall+0x41/0x1d0
    kernel_init_freeable+0x164/0x260
    kernel_init+0x16/0x1a0
    ret_from_fork+0x2d/0x50
    ret_from_fork_asm+0x11/0x20
   ---[ end trace 0000000000000000 ]---

The only reason this doesn't cause problems for HPET is because HPET gets
special treatment via x86_init.timers.timer_init(), and so gets a chance
to create its UC- mapping before acpi_init() clobbers things.  Disabling
the early call to hpet_time_init() yields the same behavior for HPET:

  [  0.318264] ioremap error for 0xfed00000-0xfed01000, requested 0x2, got =
0x0

Hack around the mess by forcing such mappings to WB, as the memory type is
irrevelant.  Even in a theoretical setup where such devices are passed
through by the host, i.e. point at real MMIO memory, it is KVM's (as the
hypervisor) responsibility to force the memory to be WC/UC, e.g. via EPT
memtype under TDX or real hardware MTRRs under SNP.  Not doing so cannot
work, and the hypervisor is highly motivated to do the right thing as
letting the guest access hardware MMIO with WB would likely result in a
variety of fatal #MCs.

Limit the hack to the legacy PCI hole on the off chance that there are
use cases that want to map virtual devices with WC/UC.  E.g. in theory, it
would be possible to expose hardware GPU buffers to an SNP or TDX guest.
Extending the hack, e.g. if there are use cases for memory above 4GiB that
are affected by ACPI, is far easier than debugging memory corruption if a
driver requests WC/UC and silently gets WB.

Double down on forcing everything to WB, e.g. instead of fixing the CR0.CD
issue and reverting to a "normal" model, as OVMF has also been taught to
ignore MTRRs when running as a TDX guest:

  3a3b12cbda ("UefiCpuPkg/MtrrLib: MtrrLibIsMtrrSupported always return FAL=
SE in TD-Guest")
  071d2cfab8 ("OvmfPkg/Sec: Skip setup MTRR early in TD-Guest")

And running with firmware that doesn't program MTRRs would likely put the
kernel back into the conundrum of ACPI mapping devices WB, with drivers
wanting WC/UC-.

Fixes: 8e690b817e38 ("x86/kvm: Override default caching mode for SEV-SNP an=
d TDX")
Cc: stable@vger.kernel.org
Cc: Dionna Glaze <dionnaglaze@google.com>
Cc: Peter Gonda <pgonda@google.com>
Cc: J=C3=BCrgen Gro=C3=9F <jgross@suse.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Binbin Wu <binbin.wu@intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/kvm.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 7a422a6c5983..7ae294fe99c3 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -931,6 +931,23 @@ static void kvm_sev_hc_page_enc_status(unsigned long p=
fn, int npages, bool enc)
 			   KVM_MAP_GPA_RANGE_ENC_STAT(enc) | KVM_MAP_GPA_RANGE_PAGE_SZ_4K);
 }
=20
+static u64 kvm_tolud __ro_after_init;
+
+static bool kvm_is_forced_wb_range(u64 start, u64 end)
+{
+	/*
+	 * In addition to the standard ISA override, force all low memory above
+	 * TOLUD to WB so that legacy devices are mapped with WB when running
+	 * as an SNP or TDX guest.  The memtype itself is completely irrevelant
+	 * as the devices are emulated, the override^Whack is needed purely to
+	 * avoid failures due to ACPI mapping device memory as WB in advance of
+	 * device drivers requesting WC or UC.  In a system with MTRRs, ACPI's
+	 * mappings get forced to UC via MTRRs (programmed sanely by firmware).
+	 */
+	return is_ISA_range(start, end) ||
+	       (start >=3D kvm_tolud && end <=3D SZ_4G);
+}
+
 static void __init kvm_init_platform(void)
 {
 	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) &&
@@ -982,8 +999,18 @@ static void __init kvm_init_platform(void)
 	kvmclock_init();
 	x86_platform.apic_post_init =3D kvm_apic_init;
=20
-	/* Set WB as the default cache mode for SEV-SNP and TDX */
-	guest_force_mtrr_state(NULL, 0, MTRR_TYPE_WRBACK);
+	/*
+	 * Set WB as the default cache mode for SEV-SNP and TDX.  MTRRs may be
+	 * enumerated as supported, but neither the TDX-Module (Secure EPT) nor
+	 * KVM (normal EPT for TDX, virtual MTRRs for NPT) actually virtualizes
+	 * MTRR memory types.  If MTRRs are forced to writeback, register KVM's
+	 * range-based WB override to handle cases where device drivers try to
+	 * map an emulated device's memory as WC, and fail because it's all WB.
+	 */
+	if (guest_force_mtrr_state(NULL, 0, MTRR_TYPE_WRBACK)) {
+		kvm_tolud =3D (e820__end_of_low_ram_pfn() << PAGE_SHIFT);
+		x86_platform.is_untracked_pat_range =3D kvm_is_forced_wb_range;
+	}
 }
=20
 #if defined(CONFIG_AMD_MEM_ENCRYPT)
--=20
2.48.1.362.g079036d154-goog


