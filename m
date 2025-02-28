Return-Path: <kvm+bounces-39722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 32DC3A49845
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 12:24:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08AB23B52FD
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 11:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6598A2620E8;
	Fri, 28 Feb 2025 11:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RUajs/vt"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49495849C;
	Fri, 28 Feb 2025 11:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740741841; cv=none; b=umf6R+Da+FcK+MzDKnQh7FXWL4qt9B7bdmM5IaneoQOO7OeJhLK5vZda8hyspeYvo3h0NKnlPBgAAD1FykJ6LJWQhLKI7/NLUmeKn6ME/3UbFMde0xns25+8UXs+Bd9Vv1tGzIQTOEb+wzFulFMFPc+0P0BMmR5cBui9WaSPlTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740741841; c=relaxed/simple;
	bh=hcBMVObYlSy4kfKgZ2QaFVxthR2uOFOjZ0tAFJ/Ueuw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Mn2zdTxZCH8L+2/AYvXyUvfv51KxjL9jSYL/zI6hCo1/5JkQljTq11Czaj8mltPtsi/DGlCtKgREUI1nEyMD1eT25suY7J3olxu19AMh7GpHCY2z3ZFljQs2Bi2BHazZzxDWyRhUldCSr31Ae1Z5qfIPT9bWX+aMLsaDdNYFMvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RUajs/vt; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hcBMVObYlSy4kfKgZ2QaFVxthR2uOFOjZ0tAFJ/Ueuw=; b=RUajs/vt2biYqM9UDHxwh9xDbF
	iewMUZ54B9iYKsjFjSECIrcOSHa/86TB1yUlcxyB4PIX2/X64AjUZcg9/LMPtn4T0DlMriBYHjpOG
	CecVudmlW7pi4Cydal5gh513Rm8NbDXC61p0ux3Bw8zjGhi96zwxtbvKwbfHxqOO6CcfzSDtrB3jO
	lv9+eAHIoJIzhWvkIBfQIYjn2Zmo0KtW3eLt9fxglEjpigqpkS4ZoynsNDMMoA66a5syTwKWj+sxC
	9GKAM0smKhawtYJ3+e5PsZsZ77TvWoKqZluDFU8oEzo696NxXxoq30iiAuWGNCDtG6hz8vwybrizJ
	wrRAiIDw==;
Received: from 54-240-197-236.amazon.com ([54.240.197.236] helo=freeip.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnyT1-00000001lhq-0SHy;
	Fri, 28 Feb 2025 11:23:43 +0000
Message-ID: <5bdb92ab83269b49ad8fbbe8f54df01f6b98ea8f.camel@infradead.org>
Subject: Re: [PATCH v2 00/38] x86: Try to wrangle PV clocks vs. TSC
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Juergen Gross <jgross@suse.com>,  "K. Y. Srinivasan"
 <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu
 <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Ajay Kaher
 <ajay.kaher@broadcom.com>, Jan Kiszka <jan.kiszka@siemens.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Daniel
 Lezcano <daniel.lezcano@linaro.org>, John Stultz <jstultz@google.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-hyperv@vger.kernel.org, xen-devel@lists.xenproject.org, Tom Lendacky
	 <thomas.lendacky@amd.com>, Nikunj A Dadhania <nikunj@amd.com>
Date: Fri, 28 Feb 2025 11:23:41 +0000
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
References: <20250227021855.3257188-1-seanjc@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-ch88MIQEh5lgQIw/7rP6"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-ch88MIQEh5lgQIw/7rP6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2025-02-26 at 18:18 -0800, Sean Christopherson wrote:
> This... snowballed a bit.
>=20
> The bulk of the changes are in kvmclock and TSC, but pretty much every
> hypervisor's guest-side code gets touched at some point.=C2=A0 I am reaon=
sably
> confident in the correctness of the KVM changes.=C2=A0 For all other hype=
rvisors,
> assume it's completely broken until proven otherwise.
>
> Note, I deliberately omitted:
>=20
> =C2=A0 Alexey Makhalov <alexey.amakhalov@broadcom.com>
> =C2=A0 jailhouse-dev@googlegroups.com
>=20
> from the To/Cc, as those emails bounced on the last version, and I have z=
ero
> desire to get 38*2 emails telling me an email couldn't be delivered.
>=20
> The primary goal of this series is (or at least was, when I started) to
> fix flaws with SNP and TDX guests where a PV clock provided by the untrus=
ted
> hypervisor is used instead of the secure/trusted TSC that is controlled b=
y
> trusted firmware.
>=20
> The secondary goal is to draft off of the SNP and TDX changes to slightly
> modernize running under KVM.=C2=A0 Currently, KVM guests will use TSC for
> clocksource, but not sched_clock.=C2=A0 And they ignore Intel's CPUID-bas=
ed TSC
> and CPU frequency enumeration, even when using the TSC instead of kvmcloc=
k.
> And if the host provides the core crystal frequency in CPUID.0x15, then K=
VM
> guests can use that for the APIC timer period instead of manually calibra=
ting
> the frequency.
>=20
> Lots more background on the SNP/TDX motiviation:
> https://lore.kernel.org/all/20250106124633.1418972-13-nikunj@amd.com

Looks good; thanks for tackling this.

I think there are still some things from my older series at
https://lore.kernel.org/all/20240522001817.619072-1-dwmw2@infradead.org/
which this doesn't address. Specifically, the accuracy and consistency
of what KVM advertises to the guest as the KVM clock. And as the Xen
clock, more to the point =E2=80=94 because guests generally *know* that the=
 KVM
clock is awful, but expect better of the Xen clock.

With a sane and consistent TSC, the mul/shift factors that KVM presents
to the guest in the kvmclock structure should basically *never* change.
Not even on live update (or live migration between hosts with the same
host TSC frequency).=20

Take live update as the simple case: serializing the QEMU state and
restarting it immediately, just to update QEMU with the guest
experiencing only a few milliseconds of steal time.

The guest TSC has a fixed arithmetic relationship to the host TSC. That
should *not* change across the live update; not by a single count.=20
I don't believe the KVM APIs allow userspace to get that right, which
is resolved by the KVM_VCPU_TSC_SCALE ioctl in patch 7 of that series:
https://lore.kernel.org/all/20240522001817.619072-8-dwmw2@infradead.org/

And then the KVM clock should have a fixed arithmetic relationship to
the guest TSC, which should *also* not change. Not even over live
migration =E2=80=94 userspace should ensure the guest TSC is as accurate as
possible given NTP synchronisation between the hosts, and then the KVM
clock remains a fixed function of the guest TSC (at least, if the guest
TSC is the same frequency on source and destination). The existing KVM
API doesn't allow userspace to get *that* right either, which is
addressed by Jack's patch 3 of the series:
https://lore.kernel.org/all/20240522001817.619072-4-dwmw2@infradead.org/

The rest of the series is mostly fixing a bunch of places where KVM
gratuitously recalculates the KVM clock that it advertises to the
guest, and the fact that it does so *badly* in some cases, with a loss
of precision that causes errors in the guest. You may already have
addressed some of those; I'll go over my series and see what still
applies on top of yours.

>=20
> v2:
> =C2=A0- Add struct to hold the TSC CPUID output. [Boris]
> =C2=A0- Don't pointlessly inline the TSC CPUID helpers. [Boris]
> =C2=A0- Fix a variable goof in a helper, hopefully for real this time. [D=
an]
> =C2=A0- Collect reviews. [Nikunj]
> =C2=A0- Override the sched_clock save/restore hooks if and only if a PV c=
lock
> =C2=A0=C2=A0 is successfully registered.
> =C2=A0- During resome, restore clocksources before reading persistent tim=
e.
> =C2=A0- Clean up more warts created by kvmclock.
> =C2=A0- Fix more bugs in kvmclock's suspend/resume handling.
> =C2=A0- Try to harden kvmclock against future bugs.
>=20
> v1: https://lore.kernel.org/all/20250201021718.699411-1-seanjc@google.com
>=20
> Sean Christopherson (38):
> =C2=A0 x86/tsc: Add a standalone helpers for getting TSC info from CPUID.=
0x15
> =C2=A0 x86/tsc: Add standalone helper for getting CPU frequency from CPUI=
D
> =C2=A0 x86/tsc: Add helper to register CPU and TSC freq calibration routi=
nes
> =C2=A0 x86/sev: Mark TSC as reliable when configuring Secure TSC
> =C2=A0 x86/sev: Move check for SNP Secure TSC support to tsc_early_init()
> =C2=A0 x86/tdx: Override PV calibration routines with CPUID-based calibra=
tion
> =C2=A0 x86/acrn: Mark TSC frequency as known when using ACRN for calibrat=
ion
> =C2=A0 clocksource: hyper-v: Register sched_clock save/restore iff it's
> =C2=A0=C2=A0=C2=A0 necessary
> =C2=A0 clocksource: hyper-v: Drop wrappers to sched_clock save/restore
> =C2=A0=C2=A0=C2=A0 helpers
> =C2=A0 clocksource: hyper-v: Don't save/restore TSC offset when using HV
> =C2=A0=C2=A0=C2=A0 sched_clock
> =C2=A0 x86/kvmclock: Setup kvmclock for secondary CPUs iff CONFIG_SMP=3Dy
> =C2=A0 x86/kvm: Don't disable kvmclock on BSP in syscore_suspend()
> =C2=A0 x86/paravirt: Move handling of unstable PV clocks into
> =C2=A0=C2=A0=C2=A0 paravirt_set_sched_clock()
> =C2=A0 x86/kvmclock: Move sched_clock save/restore helpers up in kvmclock=
.c
> =C2=A0 x86/xen/time: Nullify x86_platform's sched_clock save/restore hook=
s
> =C2=A0 x86/vmware: Nullify save/restore hooks when using VMware's sched_c=
lock
> =C2=A0 x86/tsc: WARN if TSC sched_clock save/restore used with PV sched_c=
lock
> =C2=A0 x86/paravirt: Pass sched_clock save/restore helpers during
> =C2=A0=C2=A0=C2=A0 registration
> =C2=A0 x86/kvmclock: Move kvm_sched_clock_init() down in kvmclock.c
> =C2=A0 x86/xen/time: Mark xen_setup_vsyscall_time_info() as __init
> =C2=A0 x86/pvclock: Mark setup helpers and related various as
> =C2=A0=C2=A0=C2=A0 __init/__ro_after_init
> =C2=A0 x86/pvclock: WARN if pvclock's valid_flags are overwritten
> =C2=A0 x86/kvmclock: Refactor handling of PVCLOCK_TSC_STABLE_BIT during
> =C2=A0=C2=A0=C2=A0 kvmclock_init()
> =C2=A0 timekeeping: Resume clocksources before reading persistent clock
> =C2=A0 x86/kvmclock: Hook clocksource.suspend/resume when kvmclock isn't
> =C2=A0=C2=A0=C2=A0 sched_clock
> =C2=A0 x86/kvmclock: WARN if wall clock is read while kvmclock is suspend=
ed
> =C2=A0 x86/kvmclock: Enable kvmclock on APs during onlining if kvmclock i=
sn't
> =C2=A0=C2=A0=C2=A0 sched_clock
> =C2=A0 x86/paravirt: Mark __paravirt_set_sched_clock() as __init
> =C2=A0 x86/paravirt: Plumb a return code into __paravirt_set_sched_clock(=
)
> =C2=A0 x86/paravirt: Don't use a PV sched_clock in CoCo guests with trust=
ed
> =C2=A0=C2=A0=C2=A0 TSC
> =C2=A0 x86/tsc: Pass KNOWN_FREQ and RELIABLE as params to registration
> =C2=A0 x86/tsc: Rejects attempts to override TSC calibration with lesser
> =C2=A0=C2=A0=C2=A0 routine
> =C2=A0 x86/kvmclock: Mark TSC as reliable when it's constant and nonstop
> =C2=A0 x86/kvmclock: Get CPU base frequency from CPUID when it's availabl=
e
> =C2=A0 x86/kvmclock: Get TSC frequency from CPUID when its available
> =C2=A0 x86/kvmclock: Stuff local APIC bus period when core crystal freq c=
omes
> =C2=A0=C2=A0=C2=A0 from CPUID
> =C2=A0 x86/kvmclock: Use TSC for sched_clock if it's constant and non-sto=
p
> =C2=A0 x86/paravirt: kvmclock: Setup kvmclock early iff it's sched_clock
>=20
> =C2=A0arch/x86/coco/sev/core.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 9 +-
> =C2=A0arch/x86/coco/tdx/tdx.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 27 ++-
> =C2=A0arch/x86/include/asm/kvm_para.h=C2=A0=C2=A0=C2=A0 |=C2=A0 10 +-
> =C2=A0arch/x86/include/asm/paravirt.h=C2=A0=C2=A0=C2=A0 |=C2=A0 16 +-
> =C2=A0arch/x86/include/asm/tdx.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0=C2=A0 2 +
> =C2=A0arch/x86/include/asm/tsc.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0 20 +++
> =C2=A0arch/x86/include/asm/x86_init.h=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 2 -
> =C2=A0arch/x86/kernel/cpu/acrn.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0=C2=A0 5 +-
> =C2=A0arch/x86/kernel/cpu/mshyperv.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 69 +=
-------
> =C2=A0arch/x86/kernel/cpu/vmware.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 11 +-
> =C2=A0arch/x86/kernel/jailhouse.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0=C2=A0 6 +-
> =C2=A0arch/x86/kernel/kvm.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 39 +++--
> =C2=A0arch/x86/kernel/kvmclock.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 | 260 +++++++++++++++++++++--------
> =C2=A0arch/x86/kernel/paravirt.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0 35 +++-
> =C2=A0arch/x86/kernel/pvclock.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0 9 +-
> =C2=A0arch/x86/kernel/smpboot.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +-
> =C2=A0arch/x86/kernel/tsc.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 141 ++++++++++++----
> =C2=A0arch/x86/kernel/x86_init.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0=C2=A0 1 -
> =C2=A0arch/x86/mm/mem_encrypt_amd.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=
=C2=A0 3 -
> =C2=A0arch/x86/xen/time.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 13 +-
> =C2=A0drivers/clocksource/hyperv_timer.c |=C2=A0 38 +++--
> =C2=A0include/clocksource/hyperv_timer.h |=C2=A0=C2=A0 2 -
> =C2=A0kernel/time/timekeeping.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0 9 +-
> =C2=A023 files changed, 487 insertions(+), 242 deletions(-)
>=20
>=20
> base-commit: a64dcfb451e254085a7daee5fe51bf22959d52d3


--=-ch88MIQEh5lgQIw/7rP6
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCD9Aw
ggSOMIIDdqADAgECAhAOmiw0ECVD4cWj5DqVrT9PMA0GCSqGSIb3DQEBCwUAMGUxCzAJBgNVBAYT
AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAi
BgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0yNDAxMzAwMDAwMDBaFw0zMTEx
MDkyMzU5NTlaMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYDVQQDExdWZXJv
a2V5IFNlY3VyZSBFbWFpbCBHMjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMjvgLKj
jfhCFqxYyRiW8g3cNFAvltDbK5AzcOaR7yVzVGadr4YcCVxjKrEJOgi7WEOH8rUgCNB5cTD8N/Et
GfZI+LGqSv0YtNa54T9D1AWJy08ZKkWvfGGIXN9UFAPMJ6OLLH/UUEgFa+7KlrEvMUupDFGnnR06
aDJAwtycb8yXtILj+TvfhLFhafxroXrflspavejQkEiHjNjtHnwbZ+o43g0/yxjwnarGI3kgcak7
nnI9/8Lqpq79tLHYwLajotwLiGTB71AGN5xK+tzB+D4eN9lXayrjcszgbOv2ZCgzExQUAIt98mre
8EggKs9mwtEuKAhYBIP/0K6WsoMnQCcCAwEAAaOCAVwwggFYMBIGA1UdEwEB/wQIMAYBAf8CAQAw
HQYDVR0OBBYEFIlICOogTndrhuWByNfhjWSEf/xwMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6en
IZ3zbcgPMA4GA1UdDwEB/wQEAwIBhjAdBgNVHSUEFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIweQYI
KwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYB
BQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RD
QS5jcnQwRQYDVR0fBD4wPDA6oDigNoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0
QXNzdXJlZElEUm9vdENBLmNybDARBgNVHSAECjAIMAYGBFUdIAAwDQYJKoZIhvcNAQELBQADggEB
ACiagCqvNVxOfSd0uYfJMiZsOEBXAKIR/kpqRp2YCfrP4Tz7fJogYN4fxNAw7iy/bPZcvpVCfe/H
/CCcp3alXL0I8M/rnEnRlv8ItY4MEF+2T/MkdXI3u1vHy3ua8SxBM8eT9LBQokHZxGUX51cE0kwa
uEOZ+PonVIOnMjuLp29kcNOVnzf8DGKiek+cT51FvGRjV6LbaxXOm2P47/aiaXrDD5O0RF5SiPo6
xD1/ClkCETyyEAE5LRJlXtx288R598koyFcwCSXijeVcRvBB1cNOLEbg7RMSw1AGq14fNe2cH1HG
W7xyduY/ydQt6gv5r21mDOQ5SaZSWC/ZRfLDuEYwggWbMIIEg6ADAgECAhAH5JEPagNRXYDiRPdl
c1vgMA0GCSqGSIb3DQEBCwUAMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYD
VQQDExdWZXJva2V5IFNlY3VyZSBFbWFpbCBHMjAeFw0yNDEyMzAwMDAwMDBaFw0yODAxMDQyMzU5
NTlaMB4xHDAaBgNVBAMME2R3bXcyQGluZnJhZGVhZC5vcmcwggIiMA0GCSqGSIb3DQEBAQUAA4IC
DwAwggIKAoICAQDali7HveR1thexYXx/W7oMk/3Wpyppl62zJ8+RmTQH4yZeYAS/SRV6zmfXlXaZ
sNOE6emg8WXLRS6BA70liot+u0O0oPnIvnx+CsMH0PD4tCKSCsdp+XphIJ2zkC9S7/yHDYnqegqt
w4smkqUqf0WX/ggH1Dckh0vHlpoS1OoxqUg+ocU6WCsnuz5q5rzFsHxhD1qGpgFdZEk2/c//ZvUN
i12vPWipk8TcJwHw9zoZ/ZrVNybpMCC0THsJ/UEVyuyszPtNYeYZAhOJ41vav1RhZJzYan4a1gU0
kKBPQklcpQEhq48woEu15isvwWh9/+5jjh0L+YNaN0I//nHSp6U9COUG9Z0cvnO8FM6PTqsnSbcc
0j+GchwOHRC7aP2t5v2stVx3KbptaYEzi4MQHxm/0+HQpMEVLLUiizJqS4PWPU6zfQTOMZ9uLQRR
ci+c5xhtMEBszlQDOvEQcyEG+hc++fH47K+MmZz21bFNfoBxLP6bjR6xtPXtREF5lLXxp+CJ6KKS
blPKeVRg/UtyJHeFKAZXO8Zeco7TZUMVHmK0ZZ1EpnZbnAhKE19Z+FJrQPQrlR0gO3lBzuyPPArV
hvWxjlO7S4DmaEhLzarWi/ze7EGwWSuI2eEa/8zU0INUsGI4ywe7vepQz7IqaAovAX0d+f1YjbmC
VsAwjhLmveFjNwIDAQABo4IBsDCCAawwHwYDVR0jBBgwFoAUiUgI6iBOd2uG5YHI1+GNZIR//HAw
HQYDVR0OBBYEFFxiGptwbOfWOtMk5loHw7uqWUOnMDAGA1UdEQQpMCeBE2R3bXcyQGluZnJhZGVh
ZC5vcmeBEGRhdmlkQHdvb2Rob3Uuc2UwFAYDVR0gBA0wCzAJBgdngQwBBQEBMA4GA1UdDwEB/wQE
AwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwewYDVR0fBHQwcjA3oDWgM4YxaHR0
cDovL2NybDMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDA3oDWgM4YxaHR0
cDovL2NybDQuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDB2BggrBgEFBQcB
AQRqMGgwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBABggrBgEFBQcwAoY0
aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNydDANBgkq
hkiG9w0BAQsFAAOCAQEAQXc4FPiPLRnTDvmOABEzkIumojfZAe5SlnuQoeFUfi+LsWCKiB8Uextv
iBAvboKhLuN6eG/NC6WOzOCppn4mkQxRkOdLNThwMHW0d19jrZFEKtEG/epZ/hw/DdScTuZ2m7im
8ppItAT6GXD3aPhXkXnJpC/zTs85uNSQR64cEcBFjjoQDuSsTeJ5DAWf8EMyhMuD8pcbqx5kRvyt
JPsWBQzv1Dsdv2LDPLNd/JUKhHSgr7nbUr4+aAP2PHTXGcEBh8lTeYea9p4d5k969pe0OHYMV5aL
xERqTagmSetuIwolkAuBCzA9vulg8Y49Nz2zrpUGfKGOD0FMqenYxdJHgDCCBZswggSDoAMCAQIC
EAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQELBQAwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoT
B1Zlcm9rZXkxIDAeBgNVBAMTF1Zlcm9rZXkgU2VjdXJlIEVtYWlsIEcyMB4XDTI0MTIzMDAwMDAw
MFoXDTI4MDEwNDIzNTk1OVowHjEcMBoGA1UEAwwTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJ
KoZIhvcNAQEBBQADggIPADCCAgoCggIBANqWLse95HW2F7FhfH9bugyT/danKmmXrbMnz5GZNAfj
Jl5gBL9JFXrOZ9eVdpmw04Tp6aDxZctFLoEDvSWKi367Q7Sg+ci+fH4KwwfQ8Pi0IpIKx2n5emEg
nbOQL1Lv/IcNiep6Cq3DiyaSpSp/RZf+CAfUNySHS8eWmhLU6jGpSD6hxTpYKye7PmrmvMWwfGEP
WoamAV1kSTb9z/9m9Q2LXa89aKmTxNwnAfD3Ohn9mtU3JukwILRMewn9QRXK7KzM+01h5hkCE4nj
W9q/VGFknNhqfhrWBTSQoE9CSVylASGrjzCgS7XmKy/BaH3/7mOOHQv5g1o3Qj/+cdKnpT0I5Qb1
nRy+c7wUzo9OqydJtxzSP4ZyHA4dELto/a3m/ay1XHcpum1pgTOLgxAfGb/T4dCkwRUstSKLMmpL
g9Y9TrN9BM4xn24tBFFyL5znGG0wQGzOVAM68RBzIQb6Fz758fjsr4yZnPbVsU1+gHEs/puNHrG0
9e1EQXmUtfGn4InoopJuU8p5VGD9S3Ikd4UoBlc7xl5yjtNlQxUeYrRlnUSmdlucCEoTX1n4UmtA
9CuVHSA7eUHO7I88CtWG9bGOU7tLgOZoSEvNqtaL/N7sQbBZK4jZ4Rr/zNTQg1SwYjjLB7u96lDP
sipoCi8BfR35/ViNuYJWwDCOEua94WM3AgMBAAGjggGwMIIBrDAfBgNVHSMEGDAWgBSJSAjqIE53
a4blgcjX4Y1khH/8cDAdBgNVHQ4EFgQUXGIam3Bs59Y60yTmWgfDu6pZQ6cwMAYDVR0RBCkwJ4ET
ZHdtdzJAaW5mcmFkZWFkLm9yZ4EQZGF2aWRAd29vZGhvdS5zZTAUBgNVHSAEDTALMAkGB2eBDAEF
AQEwDgYDVR0PAQH/BAQDAgXgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDB7BgNVHR8E
dDByMDegNaAzhjFodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMDegNaAzhjFodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMHYGCCsGAQUFBwEBBGowaDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29t
MEAGCCsGAQUFBzAChjRodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVt
YWlsRzIuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQBBdzgU+I8tGdMO+Y4AETOQi6aiN9kB7lKWe5Ch
4VR+L4uxYIqIHxR7G2+IEC9ugqEu43p4b80LpY7M4KmmfiaRDFGQ50s1OHAwdbR3X2OtkUQq0Qb9
6ln+HD8N1JxO5nabuKbymki0BPoZcPdo+FeRecmkL/NOzzm41JBHrhwRwEWOOhAO5KxN4nkMBZ/w
QzKEy4PylxurHmRG/K0k+xYFDO/UOx2/YsM8s138lQqEdKCvudtSvj5oA/Y8dNcZwQGHyVN5h5r2
nh3mT3r2l7Q4dgxXlovERGpNqCZJ624jCiWQC4ELMD2+6WDxjj03PbOulQZ8oY4PQUyp6djF0keA
MYIDuzCCA7cCAQEwVTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMX
VmVyb2tleSBTZWN1cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJYIZIAWUDBAIBBQCg
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDIyODExMjM0
MVowLwYJKoZIhvcNAQkEMSIEIC87su9K4r1SHa0OCjQ93LVFcaBIMsBzKpdc4Y+aPnTtMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAtMxKM6vArHv+
VzkUciMZsLpHjtBsO5HOnXVqn+0zHjutEe2agOoND+ynd55zhNJ7WQwbA4LlhNjoA5NR/X0ztW/7
1QevQMkw+SnTi65myjMRVsY8BezMKPgurV2tsLt7TOs7vfrXvkIPIq/PW6wVPu0ZsIEBcbscR57H
KSyiGNXkt1NiHkU+inVbUDh7U/CN6Gskoe7SukAhxWC+/cCVOynel/v6E3BLj1tb2Ay2DnZsNxnn
80L84EAt2JAOyWb573/SOX47jM4WOoIhmu1wpYs9O9gMnGZCQ+j2qi4JWdG5UjwwlTtHWTdn+nBe
+ISy2GfEp8kkZPlcq5yChbx3enBQ6DGe3dmY+ibzGofimh8CklecShvr2LCjt5RJXzEzs1ECQuth
i9K489RVn4Ynm2cdGEwpF4rTv+AQuA34N7c6Yl2JID6gtZMM6SbHxB2gJtXsj55epstkUc214kli
3L3FLGw4pJxYBbKS0Gky8oYFO/IlYBTp+68sFLF7JE+V3JBiTLH3zrWGXJc2szi5jRXDeDoK/+Eh
AE1ZyNOAD4rztAb3ahZZWUwzU4Gqo6Fv5Xl5rpLvFW0ir/DF0JSglvdNEaDhtjGvDivCSx2p3ss9
zhMKFjy0V3elkOSN7HRqDL7Sm0dLujdZ94ndVsZJWTZmJ3S4T+DySz+1oPtUleAAAAAAAAA=


--=-ch88MIQEh5lgQIw/7rP6--

