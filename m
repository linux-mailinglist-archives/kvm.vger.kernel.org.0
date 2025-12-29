Return-Path: <kvm+bounces-66774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AD22CE6909
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 12:40:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 19897300E787
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 11:40:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E520B30C370;
	Mon, 29 Dec 2025 11:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IXD/usBk"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD732D2384;
	Mon, 29 Dec 2025 11:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767008391; cv=none; b=NGhUUUIAR3MJZ3kSZWUh+eogPADHK2pixuhKNJOy6EqLbbIPSjSq0FcTQEERzMS5/ORC7kHIe8EClDxEMdPkA/GqeaOEoHkyH6HvGh3hDVdHfL5VOTUweokOG7YJzzQ6TmjPAzDvNaYp6tWQHcSgzPJVpzncKVIsyGev2dOD1qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767008391; c=relaxed/simple;
	bh=6g50UNtTBo11FWywowyNkj1pe1LPLiLuQsLk69gSORw=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=gFAn9jISdtHxpoVdlDT6x2vMPe18ml6yRLBkIiQr46vtT6tSnCVNtggqrpZ5CCyj3QHUkABjx+0JyqPH4kw+Qo/EIb+T1s4elcXnLPBx6mw3nNKRsbwEa0HkEdSaNS9PEas5N7pvXWDwC3Y/Y+lqa5F25RGc6GFhhKtMUF5ZLdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IXD/usBk; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=JRvzjUshhkGymRJmEtMpXue7RYbdi4nodibaAoUC5+Q=; b=IXD/usBk9qOShTN4daL6RvIHpl
	gsMRy7/zGHm3YxMlELerFI/IVuDtVhexyEmdrrjIGOBFMmgnqVVs010/bkz+t/5zRdJeuMd8o2YEN
	l1cM+5ugr6r5S341Y8xSpa+T5g5wOn4jNFpcbmINe1PFTZC10bkEKVMdOS9rYcCAGJkTCQ2WxC7KF
	jk9Ts7VlTuUeYOzqSDFfxYXttvaN8IXnLdmYOpu0utX1emrslqZLW9QzASgsZMCM+CBO4em/zoZuV
	lJZlvt7RAbJYYx7FrDptr7AI+0XDOXTBEORjWsoMPurpZyTvrofYsJOrzJf5+6X/jNkZPxZ2xctIx
	/1rmEmVQ==;
Received: from [172.31.31.139] (helo=ehlo.thunderbird.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vaBaw-00000002iZc-3OV1;
	Mon, 29 Dec 2025 11:39:28 +0000
Date: Mon, 29 Dec 2025 11:39:27 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: Khushit Shah <khushit.shah@nutanix.com>, seanjc@google.com,
 pbonzini@redhat.com, kai.huang@intel.com
CC: mingo@redhat.com, x86@kernel.org, bp@alien8.de, hpa@zytor.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 dave.hansen@linux.intel.com, tglx@linutronix.de, jon@nutanix.com,
 shaju.abraham@nutanix.com, David Woodhouse <dwmw@amazon.co.uk>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v5_2/3=5D_KVM=3A_x86/ioapic=3A_Implemen?=
 =?US-ASCII?Q?t_support_for_I/O_APIC_version_0x20_with_EOIR?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20251229111708.59402-3-khushit.shah@nutanix.com>
References: <20251229111708.59402-1-khushit.shah@nutanix.com> <20251229111708.59402-3-khushit.shah@nutanix.com>
Message-ID: <7294A61D-A794-4599-950C-9EC9B5E94B58@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

On 29 December 2025 11:17:07 GMT, Khushit Shah <khushit=2Eshah@nutanix=2Eco=
m> wrote:
>From: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>
>Introduce support for I/O APIC version 0x20, which includes the EOI
>Register (EOIR) for directed EOI=2E  The EOI register allows guests to
>perform EOIs to individual I/O APICs instead of relying on broadcast EOIs
>from the local APIC=2E
>
>When Suppress EOI Broadcast (SEOIB) capability is advertised to the guest=
,
>guests that enable it will EOI individual I/O APICs by writing to their
>EOI register instead of relying on broadcast EOIs from the LAPIC=2E  Henc=
e,
>when SEOIB is advertised (so that guests can use it if they choose), use
>I/O APIC version 0x20 to provide the EOI register=2E  This prepares for a
>userspace API that will allow explicit control of SEOIB support, providin=
g
>a consistent interface for both in-kernel and split IRQCHIP mode=2E
>
>Add a tracepoint (kvm_ioapic_directed_eoi) to track directed EOIs for
>debugging and observability=2E
>
>Signed-off-by: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>Signed-off-by: Khushit Shah <khushit=2Eshah@nutanix=2Ecom>
>---
> arch/x86/kvm/ioapic=2Ec | 31 +++++++++++++++++++++++++++++--
> arch/x86/kvm/ioapic=2Eh | 19 +++++++++++--------
> arch/x86/kvm/trace=2Eh  | 17 +++++++++++++++++
> 3 files changed, 57 insertions(+), 10 deletions(-)
>
>diff --git a/arch/x86/kvm/ioapic=2Ec b/arch/x86/kvm/ioapic=2Ec
>index 6bf8d110aece=2E=2Eeea1eb7845c4 100644
>--- a/arch/x86/kvm/ioapic=2Ec
>+++ b/arch/x86/kvm/ioapic=2Ec
>@@ -48,8 +48,11 @@ static unsigned long ioapic_read_indirect(struct kvm_i=
oapic *ioapic)
>=20
> 	switch (ioapic->ioregsel) {
> 	case IOAPIC_REG_VERSION:
>-		result =3D ((((IOAPIC_NUM_PINS - 1) & 0xff) << 16)
>-			  | (IOAPIC_VERSION_ID & 0xff));
>+		if (kvm_lapic_advertise_suppress_eoi_broadcast(ioapic->kvm))
>+			result =3D IOAPIC_VERSION_ID_EOIR;
>+		else
>+			result =3D IOAPIC_VERSION_ID;
>+		result |=3D ((IOAPIC_NUM_PINS - 1) & 0xff) << 16;

I think that wants to depend on _respect_ not _advertise_? Otherwise you'r=
e changing existing behaviour in the legacy/quirk case where the VMM neithe=
r explicitly enables not disables the feature=2E

> 		break;
>=20
> 	case IOAPIC_REG_APIC_ID:
>@@ -57,6 +60,10 @@ static unsigned long ioapic_read_indirect(struct kvm_i=
oapic *ioapic)
> 		result =3D ((ioapic->id & 0xf) << 24);
> 		break;
>=20
>+	case IOAPIC_REG_BOOT_CONFIG:
>+		result =3D 0x01; /* Processor bus */
>+		break;
>+
> 	default:
> 		{
> 			u32 redir_index =3D (ioapic->ioregsel - 0x10) >> 1;
>@@ -701,6 +708,26 @@ static int ioapic_mmio_write(struct kvm_vcpu *vcpu, =
struct kvm_io_device *this,
> 		ioapic_write_indirect(ioapic, data);
> 		break;
>=20
>+	case IOAPIC_REG_EOIR:
>+		/*
>+		 * The EOI register is supported (and version 0x20 advertised)
>+		 * when userspace explicitly enables suppress EOI broadcast=2E
>+		 */
>+		if (kvm_lapic_advertise_suppress_eoi_broadcast(vcpu->kvm)) {

I'm torn, but I suspect this one should be conditional on _respect_ too=2E=
 A guest shouldn't be trying this register unless the version register sugg=
ests that it exists anyway=2E


>+			u8 vector =3D data & 0xff;
>+			int i;
>+
>+			trace_kvm_ioapic_directed_eoi(vcpu, vector);
>+			rtc_irq_eoi(ioapic, vcpu, vector);
>+			for (i =3D 0; i < IOAPIC_NUM_PINS; i++) {
>+				union kvm_ioapic_redirect_entry *ent =3D &ioapic->redirtbl[i];
>+
>+				if (ent->fields=2Evector !=3D vector)
>+					continue;
>+				kvm_ioapic_update_eoi_one(vcpu, ioapic, ent->fields=2Etrig_mode, i);
>+			}
>+		}
>+		break;
> 	default:
> 		break;
> 	}
>diff --git a/arch/x86/kvm/ioapic=2Eh b/arch/x86/kvm/ioapic=2Eh
>index bf28dbc11ff6=2E=2Ef219577f738c 100644
>--- a/arch/x86/kvm/ioapic=2Eh
>+++ b/arch/x86/kvm/ioapic=2Eh
>@@ -11,7 +11,8 @@ struct kvm_vcpu;
>=20
> #define IOAPIC_NUM_PINS  KVM_IOAPIC_NUM_PINS
> #define MAX_NR_RESERVED_IOAPIC_PINS KVM_MAX_IRQ_ROUTES
>-#define IOAPIC_VERSION_ID 0x11	/* IOAPIC version */
>+#define IOAPIC_VERSION_ID	0x11	/* Default IOAPIC version */
>+#define IOAPIC_VERSION_ID_EOIR	0x20	/* IOAPIC version with EOIR support =
*/
> #define IOAPIC_EDGE_TRIG  0
> #define IOAPIC_LEVEL_TRIG 1
>=20
>@@ -19,13 +20,15 @@ struct kvm_vcpu;
> #define IOAPIC_MEM_LENGTH            0x100
>=20
> /* Direct registers=2E */
>-#define IOAPIC_REG_SELECT  0x00
>-#define IOAPIC_REG_WINDOW  0x10
>-
>-/* Indirect registers=2E */
>-#define IOAPIC_REG_APIC_ID 0x00	/* x86 IOAPIC only */
>-#define IOAPIC_REG_VERSION 0x01
>-#define IOAPIC_REG_ARB_ID  0x02	/* x86 IOAPIC only */
>+#define IOAPIC_REG_SELECT	0x00
>+#define IOAPIC_REG_WINDOW	0x10
>+#define IOAPIC_REG_EOIR	0x40	/* version 0x20+ only */
>+
>+/* INDIRECT registers=2E */
>+#define IOAPIC_REG_APIC_ID	0x00	/* x86 IOAPIC only */
>+#define IOAPIC_REG_VERSION	0x01
>+#define IOAPIC_REG_ARB_ID	0x02	/* x86 IOAPIC only */
>+#define IOAPIC_REG_BOOT_CONFIG	0x03	/* x86 IOAPIC only */
>=20
> /*ioapic delivery mode*/
> #define	IOAPIC_FIXED			0x0
>diff --git a/arch/x86/kvm/trace=2Eh b/arch/x86/kvm/trace=2Eh
>index e79bc9cb7162=2E=2E6902758353a9 100644
>--- a/arch/x86/kvm/trace=2Eh
>+++ b/arch/x86/kvm/trace=2Eh
>@@ -315,6 +315,23 @@ TRACE_EVENT(kvm_ioapic_delayed_eoi_inj,
> 		  (__entry->e & (1<<15)) ? "level" : "edge",
> 		  (__entry->e & (1<<16)) ? "|masked" : "")
> );
>+
>+TRACE_EVENT(kvm_ioapic_directed_eoi,
>+	    TP_PROTO(struct kvm_vcpu *vcpu, u8 vector),
>+	    TP_ARGS(vcpu, vector),
>+
>+	TP_STRUCT__entry(
>+		__field(	__u32,		apicid		)
>+		__field(	__u8,		vector		)
>+	),
>+
>+	TP_fast_assign(
>+		__entry->apicid		=3D vcpu->vcpu_id;
>+		__entry->vector		=3D vector;
>+	),
>+
>+	TP_printk("apicid %x vector %u", __entry->apicid, __entry->vector)
>+);
> #endif
>=20
> TRACE_EVENT(kvm_msi_set_irq,


