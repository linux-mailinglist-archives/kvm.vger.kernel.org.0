Return-Path: <kvm+bounces-73300-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MJwxFu/QrmlhJAIAu9opvQ
	(envelope-from <kvm+bounces-73300-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 14:53:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A83B123A15E
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 14:53:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4D90831802A8
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 13:47:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 531E239B490;
	Mon,  9 Mar 2026 13:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="k67aMYp4"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906353C3BF4;
	Mon,  9 Mar 2026 13:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773064045; cv=none; b=ic0nNk12pDxZaXzDEauR62UcmWiCjmleTyYWBmd+WUIqZ4cDHtxSuyneKEkH94HfvsdP2MELMKI8iEaxgCGNc/RMl4/CU6eD47KFemQKZmuAXmPulpW2IUzkoldYpekOqEGZz9KTpbF/DtvP+AMGjrlDwuet5P1a/CS66mihHNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773064045; c=relaxed/simple;
	bh=YQXXfggVY+IeTcpZSIJX5MQRzTFeW+34FvFT5QJN8TU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ru4E5/BJeZi7exXz2N4x4o72rcw68gOvuk5G5EEbZts/sAUdRleGJgseducG4yTaKoCbR1SyZlhj8WlzvaTM11QFGHeaLdUBzcZb9So9rRPdeC8qlu5hG9zJXN4Gm0awTTq1feKFIpDk9hFku5whMJOGDisTc9d8Ag6ZUQsUdJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=k67aMYp4; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8FE7840E019E;
	Mon,  9 Mar 2026 13:47:08 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id kh6HE491ni24; Mon,  9 Mar 2026 13:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1773064024; bh=XQOifK7RR48NWQqjsZae6VuA1MpcVk2GzyPxjDlX5hc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k67aMYp4jAXH2sAaC5Qne3YmAFo9HeVDWko6F/x5aI5MYgE997vbhMsx6plWjhDHr
	 9co5NfYZU7k/TsB3Jg+0uR1UzTLTg/nq6OP7Es4Gy9xuQwx68sD4HU74zouFgsIKB3
	 i7YLY6Ve0ot+WtjBJe6SzfSbBCSA5oRsMu37Ma+vu7X2Im3O4i53HvkebuwrYVh7sM
	 yZGHR2gnjDrM62U4DKCDRJDNYxSainwvbGWhXiKMcbVTuqSJf2SmaWqRhecWWFsrug
	 s2rGTg6qOA1soSw6wx/LOOHQI9M+Dwv3K4OQYeMjQVAG9nVpSWnaKqv/Orqnu8xzwa
	 4rQR1vYCvVLg6JAtcJBIGcUSleJyiU1zmp8RLRs50UHVvAWIvYiH1HX8vmFSG/BMUD
	 YAZ7bDl9/LdDoDRX2YY89PriLqndqr+9YjNkTwuM3gY3wy+QuwEC0loTjvLPDHIIq1
	 9JYQnHdxOIhDLU/5/9EWIUOaFLls++K894c/IMcrTzN7efnx5oEq0HKZOtMqcEW68A
	 rBweCY7dxLsbO04h56Vi8njMmwwN1L4Ynonvn19Mvvvfu9N+Cp4i+hg3hBMeDpKbUS
	 9Oqv5Z45AIsij7FewHPIBXcrEUBSm2qa4pBFiM83gBaC00PWxwm/YDbEavLoRECK9C
	 XJQtK8PrQ152fgo5QerrQ9pc=
Received: from zn.tnic (pd9530d5e.dip0.t-ipconnect.de [217.83.13.94])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id C200440E01AC;
	Mon,  9 Mar 2026 13:46:49 +0000 (UTC)
Date: Mon, 9 Mar 2026 14:46:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	thomas.lendacky@amd.com, tglx@kernel.org, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, xin@zytor.com,
	seanjc@google.com, pbonzini@redhat.com, x86@kernel.org,
	sohil.mehta@intel.com, jon.grimm@amd.com
Subject: Re: [PATCH v2 1/2] x86/cpu: Disable CR pinning during CPU bringup
Message-ID: <20260309134640.GOaa7PQJli_C9QATGB@fat_crate.local>
References: <20260226092349.803491-1-nikunj@amd.com>
 <20260226092349.803491-2-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260226092349.803491-2-nikunj@amd.com>
X-Rspamd-Queue-Id: A83B123A15E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[alien8.de,none];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73300-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[alien8.de:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bp@alien8.de,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.995];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:email,fat_crate.local:mid]
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 09:23:48AM +0000, Nikunj A Dadhania wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> == CR Pinning Background ==
> 
> Modern CPU hardening features like SMAP/SMEP are enabled by flipping
> control register (CR) bits. Attackers find these features inconvenient and
> often try to disable them.
> 
> CR-pinning is a kernel hardening feature that detects when
> security-sensitive control bits are flipped off, complains about it, then
> turns them back on. The CR-pinning checks are performed in the CR
> manipulation helpers.
> 
> X86_CR4_FRED controls FRED enabling and is pinned. There is a single,
> system-wide static key that controls CR-pinning behavior. The static key is
> enabled by the boot CPU after it has established its CR configuration.
> 
> The end result is that CR-pinning is not active while initializing the boot
> CPU but it is active while bringing up secondary CPUs.
> 
> == FRED Background ==
> 
> FRED is a new hardware entry/exit feature for the kernel. It is not on by
> default and started out as Intel-only. AMD is just adding support now.
> 
> FRED has MSRs for configuration and is enabled by the pinned X86_CR4_FRED
> bit. It should not be enabled until after MSRs are properly initialized.
> 
> == SEV Background ==
> 
> AMD SEV-ES and SEV-SNP use #VC (Virtualization Communication) exceptions to
> handle operations that require hypervisor assistance. These exceptions
> occur during various operations including MMIO access, CPUID instructions,
> and certain memory accesses.
> 
> Writes to the console can generate #VC.
> 
> == Problem ==
> 
> CR-pinning implicitly enables FRED on secondary CPUs at a different point
> than the boot CPU. This point is *before* the CPU has done an explicit
> cr4_set_bits(X86_CR4_FRED) and before the MSRs are initialized. This means
> that there is a window where no exceptions can be handled.
> 
> For SEV-ES/SNP and TDX guests, any console output during this window
> triggers #VC or #VE exceptions that result in triple faults because the
> exception handlers rely on FRED MSRs that aren't yet configured.
> 
> == Fix ==
> 
> Defer CR-pinning enforcement during secondary CPU bringup. This avoids any
> implicit CR changes during CPU bringup, ensuring that FRED is not enabled
> before it is configured and able to handle a #VC or #VE.
> 
> This also aligns boot and secondary CPU bringup.
> 
> CR-pinning is now enforced only when the CPU is online. cr4_init() is
> called during secondary CPU bringup, while the CPU is still offline, so the
> pinning logic in cr4_init() is redundant. Remove it and add WARN_ON_ONCE()
> to catch any future break of this assumption.
> 
> Note: FRED is not on by default anywhere so this is not likely to be
> causing many problems. The only reason this was noticed was that AMD
> started to enable FRED and was turning it on.
> 
> Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code")
> Reported-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> [ Nikunj: Updated SEV background section wording ]
> Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
> Cc: stable@vger.kernel.org # 6.9+
> ---
>  arch/x86/kernel/cpu/common.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)

My SNP guest stops booting with this right:

...
[    3.134372] Memory Encryption Features active: AMD SEV SEV-ES SEV-SNP
[    3.138211] SEV: Status: SEV SEV-ES SEV-SNP 
[    3.142211] pid_max: default: 32768 minimum: 301
[    3.145350] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes, linear)
[    3.146222] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes, linear)
[    3.150613] VFS: Finished mounting rootfs on nullfs
[    3.154971] Running RCU synchronous self tests
[    3.158212] Running RCU synchronous self tests
[    3.269518] smpboot: CPU0: AMD EPYC-v4 Processor (family: 0x17, model: 0x1, stepping: 0x2)
[    3.270237] SEV: APIC: wakeup_secondary_cpu() replaced with wakeup_cpu_via_vmgexit()
[    3.274786] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
[    3.278228] ... version:                   0
[    3.282211] ... bit width:                 48
[    3.284781] ... generic counters:          6
[    3.286212] ... generic bitmap:            000000000000003f
[    3.290211] ... fixed-purpose counters:    0
[    3.294211] ... fixed-purpose bitmap:      0000000000000000
[    3.297549] ... value mask:                0000ffffffffffff
[    3.298211] ... max period:                00007fffffffffff
[    3.302211] ... global_ctrl mask:          000000000000003f
[    3.306490] signal: max sigframe size: 1776
[    3.310343] rcu: Hierarchical SRCU implementation.
[    3.313285] rcu: 	Max phase no-delay instances is 1000.
[    3.314355] Timer migration: 2 hierarchy levels; 8 children per group; 2 crossnode level
[    3.326860] smp: Bringing up secondary CPUs ...
[    3.329547] smpboot: Parallel CPU startup disabled by the platform
[    3.330627] smpboot: x86: Booting SMP configuration:

<--- HERE.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

