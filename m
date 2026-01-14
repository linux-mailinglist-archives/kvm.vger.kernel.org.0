Return-Path: <kvm+bounces-67994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B9BAED1BC79
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 01:10:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4B2B63014D1A
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 00:10:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86CE42E63C;
	Wed, 14 Jan 2026 00:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YxebFtRf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6879AAD4B
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 00:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768349428; cv=none; b=pxQWg2vatGgqI7YF2xEBi3KK0skZ29Z4K4gC+Ee+xI8nzqNHeEUdg48YHcvpFqzDNeIKWL4+6lj0X6MiP5Jf7eqVKSCjY61a9ZBFe+bxFo8c6W4wYShDE3OkOvUZbUBv8LYTcdQh4i2rZewYN9qQCHw+rsSw+ti3HOyArl5kX5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768349428; c=relaxed/simple;
	bh=HYSHyt1UFqb1vjEEpSBVh072p4KJRfUnXvctEUXYFso=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M6S1TKi7OViA4K6BYM5y7voJ5h5f6D2OLOG/cCc3FbNK5+CsEWubpr8TNozJWM/oCXnZmb8kAK8Z9q645pD1eDg4GHdQmQrUaMH64HBEi9YUB++G9h6bQl8RkyCwI6nIvz6TRqb3+Qq+MLp7dCBRsO5zRPzD82PBJ79/g0fnYdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YxebFtRf; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29f2b45ecffso34986805ad.2
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 16:10:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768349426; x=1768954226; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IJlisRHwSHN1ou3xlqGqOUMcxDmsoQT/o7Z+RdX9yaM=;
        b=YxebFtRfqDAAbDafI2dSioCAacQzPwN4cK0oYk8mQ983sW3DhdWCyvRXFLb/no7PTs
         KVSU3rqLfOx15NDwgVdeuDk8iiD0tqYlgnhdEYKyDOyn4S5til8ryozvg4cudWUFeVh1
         C9ZVtWH9lxT3vdYUufi2UkjnA08Lg4MxM8JvNjxe3N8YWFrJ4YDNkrdUooB748vbo+Ox
         /RbxBNl2ld9ldUI42eohdrtPcg8pjtDYeaSPfS3Q1keTPAzrd0f8WweA+XsnoigOxLA8
         936iTno4lfCr7bCyyHzaToDietLWvpYHsUZmEC2HcKLB10GhmfcPnFgIeWP9ilugERAj
         GveQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768349426; x=1768954226;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IJlisRHwSHN1ou3xlqGqOUMcxDmsoQT/o7Z+RdX9yaM=;
        b=FMWkqHMcO9eYuCwpdNyg1JAZ+GIX+m67hbvrAn3roi3Sm6DR63E7QsNByVPdcJe5Ra
         OI198jmOOrb4mmeZw2M1Cm0uhxoZMAyFZmO0O1DLuvoKqbfkemaMMq43ytjT3tgRH0L5
         DjzSmgeglyqkTx3GgfYHfuR8Asmv0SlXNV58DExuRQBz7+lpyeVRPN6Hvuh5Uh0GKjvu
         8DCDYu3ssHGsbkml+dV0HWLNhZ7X1EtVBFrKn8/FV7Z8p1BNKTs52VlHoIB19zTN3Iaf
         HO5DVnhjQLqm83wPJw0r/I3z+TOupIOqxOg9IyRLoMBNMiu2oU5HW1db1LWGy4I0UVYh
         U+7A==
X-Forwarded-Encrypted: i=1; AJvYcCVVRKQ22/OdTk/NJE2C5eft9H7rlkRUjf2ihtFEbhLx53UOekph+4fAZ8u7GJW2PIh8u9U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwExnFWqnD5RFEbpN6Xe42+Zf2TjnHPn7iD2RrWVqIUi6P8YlzX
	ZdaMUXl7TFWrOWK9/Rz5MhnB7QgkF+5oqMqi5SlD0AuzdDYKXdOqxAYn0yhBoGNd1PJ7F6qhApb
	cTSO7pg==
X-Received: from plhn17.prod.google.com ([2002:a17:903:1111:b0:267:d862:5f13])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ec89:b0:2a0:b066:3f55
 with SMTP id d9443c01a7336-2a59bb17370mr1551305ad.10.1768349425643; Tue, 13
 Jan 2026 16:10:25 -0800 (PST)
Date: Tue, 13 Jan 2026 16:10:24 -0800
In-Reply-To: <9CB80182-701E-4D28-A150-B3A0E774CD61@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251229111708.59402-1-khushit.shah@nutanix.com>
 <20251229111708.59402-2-khushit.shah@nutanix.com> <e09b6b6f623e98a2b21a1da83ff8071a0a87f021.camel@infradead.org>
 <9CB80182-701E-4D28-A150-B3A0E774CD61@nutanix.com>
Message-ID: <aWbe8Iut90J0tI1Q@google.com>
Subject: Re: [PATCH v5 1/3] KVM: x86: Refactor suppress EOI broadcast logic
From: Sean Christopherson <seanjc@google.com>
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: David Woodhouse <dwmw2@infradead.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"kai.huang@intel.com" <kai.huang@intel.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	Jon Kohler <jon@nutanix.com>, Shaju Abraham <shaju.abraham@nutanix.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026, Khushit Shah wrote:
> > On 2 Jan 2026, at 9:53=E2=80=AFPM, David Woodhouse <dwmw2@infradead.org=
> wrote:
> >=20
> > On Mon, 2025-12-29 at 11:17 +0000, Khushit Shah wrote:
> >> Extract the suppress EOI broadcast (Directed EOI) logic into helper
> >> functions and move the check from kvm_ioapic_update_eoi_one() to
> >> kvm_ioapic_update_eoi() (required for a later patch). Prepare
> >> kvm_ioapic_send_eoi() to honor Suppress EOI Broadcast in split IRQCHIP
> >> mode.
> >>=20
> >> Introduce two helper functions:
> >> - kvm_lapic_advertise_suppress_eoi_broadcast(): determines whether KVM
> >>   should advertise Suppress EOI Broadcast support to the guest
> >> - kvm_lapic_respect_suppress_eoi_broadcast(): determines whether KVM s=
hould
> >>   honor the guest's request to suppress EOI broadcasts
> >>=20
> >> This refactoring prepares for I/O APIC version 0x20 support and usersp=
ace
> >> control of suppress EOI broadcast behavior.
> >>=20
> >> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> >=20
> > Looks good to me, thanks for pushing this through to completion!
> >=20
> >=20
> > Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
> >=20
> > Nit: Ideally I would would prefer to see an explicit 'no functional
> > change intended' and a reference to commit 0bcc3fb95b97a.
>=20
>=20
> I took another careful look at the refactor specifically through the
> =E2=80=9Cno functional change=E2=80=9D lens.
>=20
> The legacy behavior with the in-kernel IRQCHIP can be summarized as:
> - Suppress EOI Broadcast (SEOIB) is not advertised to the guest.
> - If the guest nevertheless enables SEOIB, it is honored (already in un-s
>   upported territory).

No, KVM will drop the attempt to enable SEOIB, because APIC_LVR won't have
APIC_LVR_DIRECTED_EOI (KVM fully controls the version info, e.g. calls
kvm_apic_set_version() even in kvm_apic_set_state() after copying user stat=
e).

	case APIC_SPIV: {
		u32 mask =3D 0x3ff;
		if (kvm_lapic_get_reg(apic, APIC_LVR) & APIC_LVR_DIRECTED_EOI)
			mask |=3D APIC_SPIV_DIRECTED_EOI;
		apic_set_spiv(apic, val & mask);
		if (!(val & APIC_SPIV_APIC_ENABLED)) {
			int i;

			for (i =3D 0; i < apic->nr_lvt_entries; i++) {
				kvm_lapic_set_reg(apic, APIC_LVTx(i),
					kvm_lapic_get_reg(apic, APIC_LVTx(i)) | APIC_LVT_MASKED);
			}
			apic_update_lvtt(apic);
			atomic_set(&apic->lapic_timer.pending, 0);

		}
		break;
	}

It _is_ possible for the virtual APIC to end up with the bit set, because K=
VM
doesn't sanitize APIC_SPIV during kvm_apic_set_state().

> - Even in that case, the legacy code still ends up calling
>   kvm_notify_acked_irq() in kvm_ioapic_update_eoi_one().
>=20
> With the refactor, kvm_notify_acked_irq() is no longer reached in this
> specific legacy scenario when the guest enables SEOIB despite it not
> being advertised. I believe this is acceptable, as the guest is relying
> on an unadvertised feature.

Except that it needs to work when it's re-enabled in a few patches.  And as=
 per
commit c806a6ad35bf ("KVM: x86: call irq notifiers with directed EOI") and
https://bugzilla.kernel.org/show_bug.cgi?id=3D82211, allegedly KVM needs to=
 notify
listeners in this case.

Given that KVM didn't actually implement Directed EOI in the in-kernel I/O =
APIC,
it's certainly debatable as to whether or not that still holds true, i.e. i=
t may
have been a misdiagnosed root cause.  But I have zero interest in finding o=
ut
the hard way, especially since the in-kernel I/O APIC is slowly being depre=
cated,
and _especially_ not in patches that will be Cc'd stable.

So while I agree it would be nice to simultaneously enable the in-kernel I/=
O APIC,
I want to prioritize landing the fix for split IRQCHIP.  And if we're cleve=
r,
enabling in-kernel I/O APIC support in the future shouldn't require any new=
 uAPI,
since we can document the limitation and not advertise
KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST in KVM_CAP_X2APIC_API when run on =
a VM
without a split IRQCHIP.  Then if support is ever added broadly, we can dro=
p the
relevant code that requires irqchip_split() and update the documentation to=
 say
that userspace need to query KVM_CAP_X2APIC_API on a VM fd to determine whe=
ther
or not the flag is supported for an in-kernel I/O APIC.

If someone has a strong need and use case for supporting Supress EOI Broadc=
ast for
an in-kernel I/O APIC, then they can have the honor of proving that things =
like
Windows and Xen play nice with KVM's implementation.  And they can do that =
on top.

Compile tested only, but this is what I'd like to go with for now (in a sin=
gle
patch, because IMO isolating the refactoring isn't a net positive without p=
atch 2/3).

--
From: Khushit Shah <khushit.shah@nutanix.com>
Date: Mon, 29 Dec 2025 11:17:06 +0000
Subject: [PATCH] KVM: x86: Add x2APIC "features" to control EOI broadcast
 suppression

Add two flags for KVM_CAP_X2APIC_API to allow userspace to control support
for Suppress EOI Broadcasts when using a split IRQCHIP (I/O APIC emulated
by userspace), which KVM completely mishandles. When x2APIC support was
first added, KVM incorrectly advertised and "enabled" Suppress EOI
Broadcast, without fully supporting the I/O APIC side of the equation,
i.e. without adding directed EOI to KVM's in-kernel I/O APIC.

That flaw was carried over to split IRQCHIP support, i.e. KVM advertised
support for Suppress EOI Broadcasts irrespective of whether or not the
userspace I/O APIC implementation supported directed EOIs. Even worse,
KVM didn't actually suppress EOI broadcasts, i.e. userspace VMMs without
support for directed EOI came to rely on the "spurious" broadcasts.

KVM "fixed" the in-kernel I/O APIC implementation by completely disabling
support for Suppress EOI Broadcasts in commit 0bcc3fb95b97 ("KVM: lapic:
stop advertising DIRECTED_EOI when in-kernel IOAPIC is in use"), but
didn't do anything to remedy userspace I/O APIC implementations.

KVM's bogus handling of Suppress EOI Broadcast is problematic when the
guest relies on interrupts being masked in the I/O APIC until well after
the initial local APIC EOI. E.g. Windows with Credential Guard enabled
handles interrupts in the following order:
  1. Interrupt for L2 arrives.
  2. L1 APIC EOIs the interrupt.
  3. L1 resumes L2 and injects the interrupt.
  4. L2 EOIs after servicing.
  5. L1 performs the I/O APIC EOI.

Because KVM EOIs the I/O APIC at step #2, the guest can get an interrupt
storm, e.g. if the IRQ line is still asserted and userspace reacts to the
EOI by re-injecting the IRQ, because the guest doesn't de-assert the line
until step #4, and doesn't expect the interrupt to be re-enabled until
step #5.

Unfortunately, simply "fixing" the bug isn't an option, as KVM has no way
of knowing if the userspace I/O APIC supports directed EOIs, i.e.
suppressing EOI broadcasts would result in interrupts being stuck masked
in the userspace I/O APIC due to step #5 being ignored by userspace. And
fully disabling support for Suppress EOI Broadcast is also undesirable, as
picking up the fix would require a guest reboot, *and* more importantly
would change the virtual CPU model exposed to the guest without any buy-in
from userspace.

Add KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST and
KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST flags to allow userspace to
explicitly enable or disable support for Suppress EOI Broadcasts. This
gives userspace control over the virtual CPU model exposed to the guest,
as KVM should never have enabled support for Suppress EOI Broadcast without
userspace opt-in. Not setting either flag will result in legacy quirky
behavior for backward compatibility.

Disallow fully enabling SUPPRESS_EOI_BROADCAST when using an in-kernel
I/O APIC, as KVM's history/support is just as tragic.  E.g. it's not clear
that commit c806a6ad35bf ("KVM: x86: call irq notifiers with directed EOI")
was entirely correct, i.e. it may have simply papered over the lack of
Directed EOI emulation in the I/O APIC.

Note, Suppress EOI Broadcasts is defined only in Intel's SDM, not in AMD's
APM. But the bit is writable on some AMD CPUs, e.g. Turin, and KVM's ABI
is to support Directed EOI (KVM's name) irrespective of guest CPU vendor.

Fixes: 7543a635aa09 ("KVM: x86: Add KVM exit for IOAPIC EOIs")
Closes: https://lore.kernel.org/kvm/7D497EF1-607D-4D37-98E7-DAF95F099342@nu=
tanix.com
Cc: stable@vger.kernel.org
Suggested-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst  | 28 +++++++++++-
 arch/x86/include/asm/kvm_host.h |  7 +++
 arch/x86/include/uapi/asm/kvm.h |  6 ++-
 arch/x86/kvm/ioapic.c           |  2 +-
 arch/x86/kvm/lapic.c            | 76 +++++++++++++++++++++++++++++----
 arch/x86/kvm/lapic.h            |  2 +
 arch/x86/kvm/x86.c              | 21 ++++++++-
 7 files changed, 127 insertions(+), 15 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rs=
t
index 01a3abef8abb..f1f1d2e5dc7c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7835,8 +7835,10 @@ Will return -EBUSY if a VCPU has already been create=
d.
=20
 Valid feature flags in args[0] are::
=20
-  #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
-  #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
+  #define KVM_X2APIC_API_USE_32BIT_IDS                          (1ULL << 0=
)
+  #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK                (1ULL << 1=
)
+  #define KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST              (1ULL << 2=
)
+  #define KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST             (1ULL << 3=
)
=20
 Enabling KVM_X2APIC_API_USE_32BIT_IDS changes the behavior of
 KVM_SET_GSI_ROUTING, KVM_SIGNAL_MSI, KVM_SET_LAPIC, and KVM_GET_LAPIC,
@@ -7849,6 +7851,28 @@ as a broadcast even in x2APIC mode in order to suppo=
rt physical x2APIC
 without interrupt remapping.  This is undesirable in logical mode,
 where 0xff represents CPUs 0-7 in cluster 0.
=20
+Setting KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST instructs KVM to enable
+Suppress EOI Broadcasts.  KVM will advertise support for Suppress EOI
+Broadcast to the guest and suppress LAPIC EOI broadcasts when the guest
+sets the Suppress EOI Broadcast bit in the SPIV register.  This flag is
+supported only when using a split IRQCHIP.
+
+Setting KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST disables support for
+Suppress EOI Broadcasts entirely, i.e. instructs KVM to NOT advertise
+support to the guest.
+
+Modern VMMs should either enable KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST
+or KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST.  If not, legacy quirky
+behavior will be used by KVM: in split IRQCHIP mode, KVM will advertise
+support for Suppress EOI Broadcasts but not actually suppress EOI
+broadcasts; for in-kernel IRQCHIP mode, KVM will not advertise support for
+Suppress EOI Broadcasts.
+
+Setting both KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST and
+KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST will fail with an EINVAL error,
+as will setting KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST without a split
+IRCHIP.
+
 7.8 KVM_CAP_S390_USER_INSTR0
 ----------------------------
=20
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index ecd4019b84b7..125bd9a4b807 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1238,6 +1238,12 @@ enum kvm_irqchip_mode {
 	KVM_IRQCHIP_SPLIT,        /* created with KVM_CAP_SPLIT_IRQCHIP */
 };
=20
+enum kvm_suppress_eoi_broadcast_mode {
+	KVM_SUPPRESS_EOI_BROADCAST_QUIRKED, /* Legacy behavior */
+	KVM_SUPPRESS_EOI_BROADCAST_ENABLED, /* Enable Suppress EOI broadcast */
+	KVM_SUPPRESS_EOI_BROADCAST_DISABLED /* Disable Suppress EOI broadcast */
+};
+
 struct kvm_x86_msr_filter {
 	u8 count;
 	bool default_allow:1;
@@ -1487,6 +1493,7 @@ struct kvm_arch {
=20
 	bool x2apic_format;
 	bool x2apic_broadcast_quirk_disabled;
+	enum kvm_suppress_eoi_broadcast_mode suppress_eoi_broadcast_mode;
=20
 	bool has_mapped_host_mmio;
 	bool guest_can_read_msr_platform_info;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kv=
m.h
index 7ceff6583652..1b0ad5440b99 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -914,8 +914,10 @@ struct kvm_sev_snp_launch_finish {
 	__u64 pad1[4];
 };
=20
-#define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
-#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
+#define KVM_X2APIC_API_USE_32BIT_IDS (_BITULL(0))
+#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK (_BITULL(1))
+#define KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST (_BITULL(2))
+#define KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST (_BITULL(3))
=20
 struct kvm_hyperv_eventfd {
 	__u32 conn_id;
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 9a99d01b111c..a38a8e2ac70b 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -555,7 +555,7 @@ static void kvm_ioapic_update_eoi_one(struct kvm_vcpu *=
vcpu,
 	spin_lock(&ioapic->lock);
=20
 	if (trigger_mode !=3D IOAPIC_LEVEL_TRIG ||
-	    kvm_lapic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI)
+	    kvm_lapic_suppress_eoi_broadcast(apic))
 		return;
=20
 	ent->fields.remote_irr =3D 0;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 78c39341b2a5..c175a021e1a9 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -105,6 +105,63 @@ bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int v=
ector)
 		apic_test_vector(vector, apic->regs + APIC_IRR);
 }
=20
+static bool kvm_lapic_advertise_suppress_eoi_broadcast(struct kvm *kvm)
+{
+	switch (kvm->arch.suppress_eoi_broadcast_mode) {
+	case KVM_SUPPRESS_EOI_BROADCAST_ENABLED:
+		return true;
+	case KVM_SUPPRESS_EOI_BROADCAST_DISABLED:
+		return false;
+	case KVM_SUPPRESS_EOI_BROADCAST_QUIRKED:
+		/*
+		 * The default in-kernel I/O APIC emulates the 82093AA and does not
+		 * implement an EOI register. Some guests (e.g. Windows with the
+		 * Hyper-V role enabled) disable LAPIC EOI broadcast without
+		 * checking the I/O APIC version, which can cause level-triggered
+		 * interrupts to never be EOI'd.
+		 *
+		 * To avoid this, KVM doesn't advertise Suppress EOI Broadcast
+		 * support when using the default in-kernel I/O APIC.
+		 *
+		 * Historically, in split IRQCHIP mode, KVM always advertised
+		 * Suppress EOI Broadcast support but did not actually suppress
+		 * EOIs, resulting in quirky behavior.
+		 */
+		return !ioapic_in_kernel(kvm);
+	default:
+		WARN_ON_ONCE(1);
+		return false;
+	}
+}
+
+bool kvm_lapic_suppress_eoi_broadcast(struct kvm_lapic *apic)
+{
+	struct kvm *kvm =3D apic->vcpu->kvm;
+
+	if (!(kvm_lapic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI))
+		return false;
+
+	switch (kvm->arch.suppress_eoi_broadcast_mode) {
+	case KVM_SUPPRESS_EOI_BROADCAST_ENABLED:
+		return true;
+	case KVM_SUPPRESS_EOI_BROADCAST_DISABLED:
+		return false;
+	case KVM_SUPPRESS_EOI_BROADCAST_QUIRKED:
+		/*
+		 * Historically, in split IRQCHIP mode, KVM ignored the suppress
+		 * EOI broadcast bit set by the guest and broadcasts EOIs to the
+		 * userspace I/O APIC. For In-kernel I/O APIC, the support itself
+		 * is not advertised, can only be enabled KVM_SET_APIC_STATE, and
+		 * and KVM's I/O APIC doesn't emulate Directed EOIs; but if the
+		 * feature is enabled, it is respected (with odd behavior).
+		 */
+		return ioapic_in_kernel(kvm);
+	default:
+		WARN_ON_ONCE(1);
+		return false;
+	}
+}
+
 __read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_has_noapic_vcpu);
=20
@@ -554,15 +611,9 @@ void kvm_apic_set_version(struct kvm_vcpu *vcpu)
=20
 	v =3D APIC_VERSION | ((apic->nr_lvt_entries - 1) << 16);
=20
-	/*
-	 * KVM emulates 82093AA datasheet (with in-kernel IOAPIC implementation)
-	 * which doesn't have EOI register; Some buggy OSes (e.g. Windows with
-	 * Hyper-V role) disable EOI broadcast in lapic not checking for IOAPIC
-	 * version first and level-triggered interrupts never get EOIed in
-	 * IOAPIC.
-	 */
+
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_X2APIC) &&
-	    !ioapic_in_kernel(vcpu->kvm))
+	    kvm_lapic_advertise_suppress_eoi_broadcast(vcpu->kvm))
 		v |=3D APIC_LVR_DIRECTED_EOI;
 	kvm_lapic_set_reg(apic, APIC_LVR, v);
 }
@@ -1517,6 +1568,15 @@ static void kvm_ioapic_send_eoi(struct kvm_lapic *ap=
ic, int vector)
=20
 	/* Request a KVM exit to inform the userspace IOAPIC. */
 	if (irqchip_split(apic->vcpu->kvm)) {
+		/*
+		 * Don't exit to userspace if the guest has enabled Directed
+		 * EOI, a.k.a. Suppress EOI Broadcasts, in which case the local
+		 * APIC doesn't broadcast EOIs (the guest must EOI the target
+		 * I/O APIC(s) directly).
+		 */
+		if (kvm_lapic_suppress_eoi_broadcast(apic))
+			return;
+
 		apic->vcpu->arch.pending_ioapic_eoi =3D vector;
 		kvm_make_request(KVM_REQ_IOAPIC_EOI_EXIT, apic->vcpu);
 		return;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 71c80fa020e0..cf8aed8c95ea 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -239,6 +239,8 @@ static inline int kvm_lapic_latched_init(struct kvm_vcp=
u *vcpu)
=20
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
=20
+bool kvm_lapic_suppress_eoi_broadcast(struct kvm_lapic *apic);
+
 void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
=20
 void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3d4e07f9cff5..82d893d262fa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -121,8 +121,10 @@ static u64 __read_mostly efer_reserved_bits =3D ~((u64=
)EFER_SCE);
=20
 #define KVM_CAP_PMU_VALID_MASK KVM_PMU_CAP_DISABLE
=20
-#define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | \
-                                    KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK=
)
+#define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | 		\
+				    KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK |	\
+				    KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST |	\
+				    KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST)
=20
 static void update_cr8_intercept(struct kvm_vcpu *vcpu);
 static void process_nmi(struct kvm_vcpu *vcpu);
@@ -4943,6 +4945,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, lon=
g ext)
 		break;
 	case KVM_CAP_X2APIC_API:
 		r =3D KVM_X2APIC_API_VALID_FLAGS;
+		if (kvm && !irqchip_split(kvm))
+			r &=3D ~KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST;
 		break;
 	case KVM_CAP_NESTED_STATE:
 		r =3D kvm_x86_ops.nested_ops->get_state ?
@@ -6751,11 +6755,24 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (cap->args[0] & ~KVM_X2APIC_API_VALID_FLAGS)
 			break;
=20
+		if ((cap->args[0] & KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST) &&
+		    (cap->args[0] & KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST))
+			break;
+
+		if ((cap->args[0] & KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST) &&
+		    !irqchip_split(kvm))
+			break;
+
 		if (cap->args[0] & KVM_X2APIC_API_USE_32BIT_IDS)
 			kvm->arch.x2apic_format =3D true;
 		if (cap->args[0] & KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
 			kvm->arch.x2apic_broadcast_quirk_disabled =3D true;
=20
+		if (cap->args[0] & KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST)
+			kvm->arch.suppress_eoi_broadcast_mode =3D KVM_SUPPRESS_EOI_BROADCAST_EN=
ABLED;
+		if (cap->args[0] & KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST)
+			kvm->arch.suppress_eoi_broadcast_mode =3D KVM_SUPPRESS_EOI_BROADCAST_DI=
SABLED;
+
 		r =3D 0;
 		break;
 	case KVM_CAP_X86_DISABLE_EXITS:

base-commit: f62b64b970570c92fe22503b0cdc65be7ce7fc7c
--

