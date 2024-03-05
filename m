Return-Path: <kvm+bounces-11018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 85D18872469
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:35:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D66D285BA3
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 16:35:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA6E9BA41;
	Tue,  5 Mar 2024 16:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ydu1fkxV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3134D8BF7
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 16:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709656537; cv=none; b=j4A01Jyt+Osd0AYH08tdc3o58yFyn3DPy8hOW6H7uX3khEJb90h6Fj6t6bcr4k05N3d7tSYv7ASBq/HBvvvGgZjxUdT1WwVf2GqF+iCZO0Pk0mgDxGSniwoVRN1uq7/sfBXsfBxEfwPVV2D/WDUiksmtM5yi5wKos1X5eQyNEbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709656537; c=relaxed/simple;
	bh=8fCD3mFM356hHR4y4xRDKU/RTQ6W8aBHd+DS5kjFZ8Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AS1Wm/PpSsJAxIhoPtT0W/PmnNt7nQa+48YLFvqKl0rbVK576P8UEtI0xUp32SOG1sxFb7z+7doCBHScNVLGGc5Tvct7LJJvtNTQ2skS0Kt+cP/hPP88vVfWeIXWG8cYivbO24oLNj+sFj8YJfAg4zcgJCs4oXC8D8mUQ4dkWg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ydu1fkxV; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbf618042daso8888050276.0
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 08:35:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709656535; x=1710261335; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QQmbrJT9dwObj4pbI1GLJWzAoRH+/arY+5jTHTxjCY8=;
        b=ydu1fkxVFAc7z3RGL+4WyzY3aZDazHKwq4MeQAAQ2YnikxvC8koqWGnLclG81OJlWg
         Sdx8MdmXo5N/Gq5VVRO8nyYBPgkcebJjkzLfiShMwN7hCys2iculWZfw642SXjire4rg
         LztuBO7qRDCyncghmqghUWZ6CLQ8J8DoZ1qPQWIYA8PuoY+v1IOA0Y4P1ofvMMSCKB9Y
         Za821EJ1WvzYydGdynnxCkk9u3YuIbH7nBXG8w9EeFKo1hmmgTcU3eFm1VAxRDWnBJe0
         A1uRrTlXJvSRHAU+i5L0Up4Q4CF3WGZnO7uJ4WYyg6yr+3OVeMUrwCUvZHoziSjW22gu
         0pIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709656535; x=1710261335;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QQmbrJT9dwObj4pbI1GLJWzAoRH+/arY+5jTHTxjCY8=;
        b=PE11bjVox6BnPIJeNtfTRkfdcIkJzMuB2cMsMpSOqpVozxZEiGvmyZSy06MnIXpLZP
         owI+kMY/k/veMSL537pLtBQfrVW0kSr2HUTsDddnppvTnc/Ek8ESh+Es5wQ/pRBMjiFJ
         /BY4RTMwgGUsrtDalyxx1U8FiO3bPEKWULnpTu9mYDSgPuLunaXQFGUNbgFls4OeT653
         I6aoWV5iQ+qnA17lOT8c/zlAeOWz2nNhMVwmbikQcgy5cu3V+x6fESGrzdg7689b+ZsB
         s2MoWSlsln4NuAG5Bm66C7NPJt33P4ZNTFbwofVg74n8QI9HmgFExcHRNvg926SF+QDR
         BYDg==
X-Gm-Message-State: AOJu0YyMhv1Pd+XWFu0yr5XPpiYx8HCRQ7ICsG+JwqS3FBXpNaV7oAy/
	0kvxUMBTKVx/b80vqsdpySKONIQN4vm/hrjX952lowiYTHGZRXgd8RFpfu5fAOMVE7LP/JwIWmm
	OHA==
X-Google-Smtp-Source: AGHT+IHruno/sPushTJHAVm2hrfJdFuFu3KW+MjOH2NiCDASBhOf9P5HCA7/lTJp7lXCzbWJ7NzURiaR8kQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:18d3:b0:dc7:865b:22c6 with SMTP id
 ck19-20020a05690218d300b00dc7865b22c6mr485363ybb.8.1709656535232; Tue, 05 Mar
 2024 08:35:35 -0800 (PST)
Date: Tue, 5 Mar 2024 08:35:33 -0800
In-Reply-To: <20240305103506.613950-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240305103506.613950-1-kraxel@redhat.com>
Message-ID: <ZedJ1UmvaYZ4PWp6@google.com>
Subject: Re: [PATCH v2] kvm: set guest physical bits in CPUID.0x80000008
From: Sean Christopherson <seanjc@google.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

KVM: x86:

On Tue, Mar 05, 2024, Gerd Hoffmann wrote:
> Set CPUID.0x80000008:EAX[23:16] to guest phys bits, i.e. the bits which
> are actually addressable.  In most cases this is identical to the host
> phys bits, but tdp restrictions (no 5-level paging) can limit this to
> 48.
>=20
> Quoting AMD APM (revision 3.35):
>=20
>   23:16 GuestPhysAddrSize Maximum guest physical address size in bits.
>                           This number applies only to guests using nested
>                           paging. When this field is zero, refer to the
>                           PhysAddrSize field for the maximum guest
>                           physical address size. See =E2=80=9CSecure Virt=
ual
>                           Machine=E2=80=9D in APM Volume 2.
>=20
> Tom Lendacky confirmed the purpose of this field is software use,
> hardware always returns zero here.
>=20
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  arch/x86/kvm/mmu.h     |  2 ++
>  arch/x86/kvm/cpuid.c   |  3 ++-
>  arch/x86/kvm/mmu/mmu.c | 15 +++++++++++++++
>  3 files changed, 19 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 60f21bb4c27b..42b5212561c8 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -100,6 +100,8 @@ static inline u8 kvm_get_shadow_phys_bits(void)
>  	return boot_cpu_data.x86_phys_bits;
>  }
> =20
> +int kvm_mmu_get_guest_phys_bits(void);
> +
>  void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 acces=
s_mask);
>  void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
>  void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index adba49afb5fe..12037f1b017e 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1240,7 +1240,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_=
array *array, u32 function)
>  		else if (!g_phys_as)

Based on the new information that GuestPhysAddrSize is software-defined, an=
d the
fact that KVM and QEMU are planning on using GuestPhysAddrSize to communica=
te
the maximum *addressable* GPA, deriving PhysAddrSize from GuestPhysAddrSize=
 is
wrong.

E.g. if KVM is running as L1 on top of a new KVM, on a CPU with MAXPHYADDR=
=3D52,
and on a CPU without 5-level TDP, then KVM (as L1) will see:

  PhysAddrSize      =3D 52
  GuestPhysAddrSize =3D 48

Propagating GuestPhysAddrSize to PhysAddrSize (which is confusingly g_phys_=
as)
will yield an L2 with

  PhysAddrSize      =3D 48=20
  GuestPhysAddrSize =3D 48

which is broken, because GPAs with bits 51:48!=3D0 are *legal*, but not add=
ressable.

>  			g_phys_as =3D phys_as;
> =20
> -		entry->eax =3D g_phys_as | (virt_as << 8);
> +		entry->eax =3D g_phys_as | (virt_as << 8)
> +			| kvm_mmu_get_guest_phys_bits() << 16;

The APM explicitly states that GuestPhysAddrSize only applies to NPT.  KVM =
should
follow suit to avoid creating unnecessary ABI, and because KVM can address =
any
legal GPA when using shadow paging.

>  		entry->ecx &=3D ~(GENMASK(31, 16) | GENMASK(11, 8));
>  		entry->edx =3D 0;
>  		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 2d6cdeab1f8a..8bebb3e96c8a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5267,6 +5267,21 @@ static inline int kvm_mmu_get_tdp_level(struct kvm=
_vcpu *vcpu)
>  	return max_tdp_level;
>  }
> =20
> +/*
> + * return the actually addressable guest phys bits, which might be
> + * less than host phys bits due to tdp restrictions.
> + */
> +int kvm_mmu_get_guest_phys_bits(void)
> +{
> +	if (tdp_enabled && shadow_phys_bits > 48) {
> +		if (tdp_root_level && tdp_root_level !=3D PT64_ROOT_5LEVEL)
> +			return 48;
> +		if (max_tdp_level !=3D PT64_ROOT_5LEVEL)
> +			return 48;

I would prefer to not use shadow_phys_bits to cap the reported CPUID.0x8000=
_0008,
so that the logic isn't spread across the CPUID code and the MMU.  I don't =
love
that the two have duplicate logic, but there's no great way to handle that =
since
the MMU needs to be able to determine the effective host MAXPHYADDR even if
CPUID.0x8000_0008 is unsupported.

I'm thinking this, maybe spread across two patches: one to undo KVM's usage=
 of
GuestPhysAddrSize, and a second to then set GuestPhysAddrSize for userspace=
?

---
 arch/x86/kvm/cpuid.c   | 38 ++++++++++++++++++++++++++++----------
 arch/x86/kvm/mmu.h     |  2 ++
 arch/x86/kvm/mmu/mmu.c |  5 +++++
 3 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index adba49afb5fe..ae03e69d7fb9 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1221,9 +1221,18 @@ static inline int __do_cpuid_func(struct kvm_cpuid_a=
rray *array, u32 function)
 		entry->eax =3D entry->ebx =3D entry->ecx =3D 0;
 		break;
 	case 0x80000008: {
-		unsigned g_phys_as =3D (entry->eax >> 16) & 0xff;
-		unsigned virt_as =3D max((entry->eax >> 8) & 0xff, 48U);
-		unsigned phys_as =3D entry->eax & 0xff;
+		unsigned int virt_as =3D max((entry->eax >> 8) & 0xff, 48U);
+
+		/*
+		 * KVM's ABI is to report the effective MAXPHYADDR for the guest
+		 * in PhysAddrSize (phys_as), and the maximum *addressable* GPA
+		 * in GuestPhysAddrSize (g_phys_as).  GuestPhysAddrSize is valid
+		 * if and only if TDP is enabled, in which case the max GPA that
+		 * can be addressed by KVM may be less than the max GPA that can
+		 * be legally generated by the guest, e.g. if MAXPHYADDR>48 but
+		 * the CPU doesn't support 5-level TDP.
+		 */
+		unsigned int phys_as, g_phys_as;
=20
 		/*
 		 * If TDP (NPT) is disabled use the adjusted host MAXPHYADDR as
@@ -1231,16 +1240,25 @@ static inline int __do_cpuid_func(struct kvm_cpuid_=
array *array, u32 function)
 		 * reductions in MAXPHYADDR for memory encryption affect shadow
 		 * paging, too.
 		 *
-		 * If TDP is enabled but an explicit guest MAXPHYADDR is not
-		 * provided, use the raw bare metal MAXPHYADDR as reductions to
-		 * the HPAs do not affect GPAs.
+		 * If TDP is enabled, the effective guest MAXPHYADDR is the same
+		 * as the raw bare metal MAXPHYADDR, as reductions to HPAs don't
+		 * affect GPAs.  The max addressable GPA is the same as the max
+		 * effective GPA, except that it's capped at 48 bits if 5-level
+		 * TDP isn't supported (hardware processes bits 51:48 only when
+		 * walking the fifth level page table).
 		 */
-		if (!tdp_enabled)
-			g_phys_as =3D boot_cpu_data.x86_phys_bits;
-		else if (!g_phys_as)
+		if (!tdp_enabled) {
+			phys_as =3D boot_cpu_data.x86_phys_bits;
+			g_phys_as =3D 0;
+		} else {
+			phys_as =3D entry->eax & 0xff;
 			g_phys_as =3D phys_as;
=20
-		entry->eax =3D g_phys_as | (virt_as << 8);
+			if (kvm_mmu_get_max_tdp_level() < 5)
+				g_phys_as =3D min(g_phys_as, 48);
+		}
+
+		entry->eax =3D phys_as | (virt_as << 8) | (g_phys_as << 16);
 		entry->ecx &=3D ~(GENMASK(31, 16) | GENMASK(11, 8));
 		entry->edx =3D 0;
 		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 60f21bb4c27b..b410a227c601 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -100,6 +100,8 @@ static inline u8 kvm_get_shadow_phys_bits(void)
 	return boot_cpu_data.x86_phys_bits;
 }
=20
+u8 kvm_mmu_get_max_tdp_level(void);
+
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_=
mask);
 void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
 void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2d6cdeab1f8a..ffd32400fd8c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5267,6 +5267,11 @@ static inline int kvm_mmu_get_tdp_level(struct kvm_v=
cpu *vcpu)
 	return max_tdp_level;
 }
=20
+u8 kvm_mmu_get_max_tdp_level(void)
+{
+	return tdp_root_level ? tdp_root_level : max_tdp_level;
+}
+
 static union kvm_mmu_page_role
 kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 				union kvm_cpu_role cpu_role)

base-commit: c0372e747726ce18a5fba8cdc71891bd795148f6
--=20


