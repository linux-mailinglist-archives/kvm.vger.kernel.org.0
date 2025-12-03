Return-Path: <kvm+bounces-65199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CFBFC9EFBA
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 13:26:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8EF5634237D
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 12:26:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 942692E6CAF;
	Wed,  3 Dec 2025 12:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VBwqJSga"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9478A2DA763;
	Wed,  3 Dec 2025 12:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764764762; cv=none; b=Q3Fhji/rz1HVp0O0rVtR5TYZ/5JjhvrVc3ZOacEh3Qp/9K/iXg9w3wIAFYpfxVsF3j3xzhPfFDe5FY1pLLrmgELtL15lOdDmyo/+p1U4f22N1/OtxFrb81JXfa6WKBOaDpK88uLwVB3SCd7YZ0ON77cy7t8FwZWparB+MZ48ZlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764764762; c=relaxed/simple;
	bh=BHMm3O/y7ZL/mWxmvWjKh4NUhUlyYdZRCqI9YZJrKco=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eyzljBAyBNM6lcsCQCXkZRZB9/hrWYtzQwxIzr+Hlv0ukm7RJ4W3IV8MqAoT/+KHQj0xZBZFl0eP1n+UdTTWkRSzC8v614c1OgdrpXqgK3QrA6WSlYMPeMNuCDkgX3fsXUs1nkwioUrKRQnxIBqGXpCtDptWGnTJzJlPapsmU88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VBwqJSga; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0x/Qn34FtKnZxs3PZXel6GfftIuQSJnSXk26lIR4MZA=; b=VBwqJSgalF29e21fmSar75duiu
	ejDFIBffEqApB4eo+SSdMsf3x1ubyqYhr0CgmmMBhTEadBmA9Ku2SRuG3HBzAkqicjolPR7tevKSR
	OToB28+ZpkibhTdzwrRPhDe2HIaHWqz1ns7FiDLUFgi11LweL0mI7hUkkpNVIKKvXFsRI9FLb/2yS
	xgxN/q5WsLWhSz8cULykjbCS6tUUcuh5oATta6QQrV663/v16gXUKE5eEMo7R1NznJrvCbe8sA2jJ
	r+KOpjW+rtK//1hH5tmaPcf4ur1fKK4ZnQ+lM3+1gvivgGujVpB0ctsz24Gah+wILKzZzeyoScCAo
	BxYh2cyg==;
Received: from [172.31.31.148] (helo=u09cd745991455d.lumleys.internal)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQl43-00000002Co5-04HE;
	Wed, 03 Dec 2025 11:30:31 +0000
Message-ID: <d3b8fd036f05e9819f654c18853ff79a255c919d.camel@infradead.org>
Subject: Re: [PATCH v3] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
From: David Woodhouse <dwmw2@infradead.org>
To: "Huang, Kai" <kai.huang@intel.com>, "seanjc@google.com"
 <seanjc@google.com>
Cc: "shaju.abraham@nutanix.com" <shaju.abraham@nutanix.com>, 
 "khushit.shah@nutanix.com" <khushit.shah@nutanix.com>, "x86@kernel.org"
 <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "stable@vger.kernel.org"
 <stable@vger.kernel.org>,  "hpa@zytor.com" <hpa@zytor.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
 "mingo@redhat.com" <mingo@redhat.com>, "dave.hansen@linux.intel.com"
 <dave.hansen@linux.intel.com>,  "pbonzini@redhat.com"
 <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Kohler, Jon" <jon@nutanix.com>, "tglx@linutronix.de" <tglx@linutronix.de>
Date: Wed, 03 Dec 2025 12:25:50 +0000
In-Reply-To: <352e189ec40fae044206b48ca6e68d77df7dced1.camel@intel.com>
References: <20251125180557.2022311-1-khushit.shah@nutanix.com>
	 <6353f43f3493b436064068e6a7f55543a2cd7ae1.camel@infradead.org>
	 <A922DCC2-4CB4-4DE8-82FA-95B502B3FCD4@nutanix.com>
	 <118998075677b696104dcbbcda8d51ab7f1ffdfd.camel@infradead.org>
	 <aS8I6T3WtM1pvPNl@google.com>
	 <68ad817529c6661085ff0524472933ba9f69fd47.camel@infradead.org>
	 <aS8Vhb66UViQmY_Q@google.com>
	 <352e189ec40fae044206b48ca6e68d77df7dced1.camel@intel.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-VzDkV0+a/szVwWKRjIXL"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html


--=-VzDkV0+a/szVwWKRjIXL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2025-12-03 at 00:50 +0000, Huang, Kai wrote:
>=20
> > -#define KVM_X2APIC_API_USE_32BIT_IDS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (1ULL << 0)
> > -#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK=C2=A0 (1ULL << 1)
> > +#define KVM_X2APIC_API_USE_32BIT_IDS			(_BITULL(0))
> > +#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK		(_BITULL(1))
> > +#define KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST	(_BITULL(2))
> > +#define KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST	(_BITULL(3))
>=20
> I hate to say, but wants to ask again:
>=20
> Since it's uAPI, are we expecting the two flags to have impact on in-kern=
el
> ioapic?
>=20
> I think there should no harm to make the two also apply to in-kernel ioap=
ic.
>=20
> E.g., for now we can reject KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST flag=
 for
> in-kernel ioapic.=C2=A0 In the future, we might add EOI register support =
to in-kernel
> ioapic and report supporting suppress EOI broadcast, then we can in-kerne=
l
> ioapic to honor these two flags too.

I don't think we should leave that to the unspecified 'future'. Let's
fix the kernel I/O APIC to support the directed EOI at the same time,
rather than having an interim version of KVM which supports the
broadcast suppression but *not* the explicit EOI that replaces it.

Since I happened to have the I/O APIC PDFs in my recent history for
other reasons, and implemented these extra registers for version 0x20
in another userspace VMM within living memory, I figured I could try to
help with the actual implementation (untested, below).

There is some bikeshedding to be done on precisely *how* ->version_id
should be set. Maybe we shouldn't have the ->version_id field, and
should just check kvm->arch.suppress_eoi_broadcast to see which version
to report?=20


While I'm at looking at it, I see there's an
ASSERT(ent->fields.trig_mode =3D=3D IOAPIC_LEVEL_TRIG) in the middle of
kvm_ioapic_update_eoi_one(), a few lines after it drops ioapic->lock
and then relocks it again. If it dropped the lock, doesn't that mean
the guest could have *changed* the mode in the interim, making that
ASSERT() guest-triggerable?

=3D=3D=3D=3D=3D
From: David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH] KVM: x86/ioapic: Implement support for I/O APIC version 0x=
20 with EOIR

As the weirdness with EOI broadcast suppression is being fixed in KVM,
also update the in-kernel I/O APIC to handle the directed EOI which
guests will need to use instead.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/ioapic.c | 22 +++++++++++++++++++++-
 arch/x86/kvm/ioapic.h | 18 +++++++++++-------
 2 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 2c2783296aed..e82f74a8e57e 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -49,7 +49,7 @@ static unsigned long ioapic_read_indirect(struct kvm_ioap=
ic *ioapic)
 	switch (ioapic->ioregsel) {
 	case IOAPIC_REG_VERSION:
 		result =3D ((((IOAPIC_NUM_PINS - 1) & 0xff) << 16)
-			  | (IOAPIC_VERSION_ID & 0xff));
+			  | ioapic->version_id);
 		break;
=20
 	case IOAPIC_REG_APIC_ID:
@@ -57,6 +57,10 @@ static unsigned long ioapic_read_indirect(struct kvm_ioa=
pic *ioapic)
 		result =3D ((ioapic->id & 0xf) << 24);
 		break;
=20
+	case IOAPIC_REG_BOOT_CONFIG:
+		result =3D 0x01; /* Processor bus */
+		break;
+
 	default:
 		{
 			u32 redir_index =3D (ioapic->ioregsel - 0x10) >> 1;
@@ -695,6 +699,21 @@ static int ioapic_mmio_write(struct kvm_vcpu *vcpu, st=
ruct kvm_io_device *this,
 		ioapic_write_indirect(ioapic, data);
 		break;
=20
+	case IOAPIC_REG_EOIR:
+		if (ioapic->version_id >=3D 0x20) {
+			u8 vector =3D data & 0xff;
+			int i;
+
+			rtc_irq_eoi(ioapic, vcpu, vector);
+			for (i =3D 0; i < IOAPIC_NUM_PINS; i++) {
+				union kvm_ioapic_redirect_entry *ent =3D &ioapic->redirtbl[i];
+
+				if (ent->fields.vector !=3D vector)
+					continue;
+				kvm_ioapic_update_eoi_one(vcpu, ioapic, ent->fields.trig_mode, i);
+			}
+		}
+		break;
 	default:
 		break;
 	}
@@ -734,6 +753,7 @@ int kvm_ioapic_init(struct kvm *kvm)
 	spin_lock_init(&ioapic->lock);
 	INIT_DELAYED_WORK(&ioapic->eoi_inject, kvm_ioapic_eoi_inject_work);
 	INIT_HLIST_HEAD(&ioapic->mask_notifier_list);
+	ioapic->version_id =3D IOAPIC_VERSION_ID;
 	kvm->arch.vioapic =3D ioapic;
 	kvm_ioapic_reset(ioapic);
 	kvm_iodevice_init(&ioapic->dev, &ioapic_mmio_ops);
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index bf28dbc11ff6..c8e44d726fbe 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -19,13 +19,16 @@ struct kvm_vcpu;
 #define IOAPIC_MEM_LENGTH            0x100
=20
 /* Direct registers. */
-#define IOAPIC_REG_SELECT  0x00
-#define IOAPIC_REG_WINDOW  0x10
+#define IOAPIC_REG_SELECT	0x00
+#define IOAPIC_REG_WINDOW	0x10
+#define IOAPIC_REG_IRQPA	0x20
+#define IOAPIC_REG_EOIR		0x40
=20
-/* Indirect registers. */
-#define IOAPIC_REG_APIC_ID 0x00	/* x86 IOAPIC only */
-#define IOAPIC_REG_VERSION 0x01
-#define IOAPIC_REG_ARB_ID  0x02	/* x86 IOAPIC only */
+/* INDIRECT registers. */
+#define IOAPIC_REG_APIC_ID	0x00	/* x86 IOAPIC only */
+#define IOAPIC_REG_VERSION	0x01
+#define IOAPIC_REG_ARB_ID	0x02	/* x86 IOAPIC only */
+#define IOAPIC_REG_BOOT_CONFIG	0x03	/* x86 IOAPIC only */
=20
 /*ioapic delivery mode*/
 #define	IOAPIC_FIXED			0x0
@@ -76,7 +79,8 @@ struct kvm_ioapic {
 	u32 ioregsel;
 	u32 id;
 	u32 irr;
-	u32 pad;
+	u8 version_id;
+	u8 pad[3];
 	union kvm_ioapic_redirect_entry redirtbl[IOAPIC_NUM_PINS];
 	unsigned long irq_states[IOAPIC_NUM_PINS];
 	struct kvm_io_device dev;
--=20
2.43.0



--=-VzDkV0+a/szVwWKRjIXL
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MTIwMzEyMjU1
MFowLwYJKoZIhvcNAQkEMSIEIDrO7jcRiA+v37/zgF/zzxsfREDwAERs8rzEpmK9whCgMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAF7sEGmNNrOug
agRXHxXV8F/myrUePNIMAK24G7AfmJQ0bPR3qEqUm/SELyfnRzJs4WmflvQXbfjWlfSqMiWIQ0H+
ZxUle0x42kG48hn9c+wIuiwRoY9rr0ZyLdTq47rYpUV2HxcH+4QP284SneeqMuLcpqTqJPi/scSO
4YQapJrlUk67dLh8+O3IdSCTpalKd6/nXwDm3OpTTHlo6CYJsEySJDtWVsTZMttJhVt4xwrLsGSw
NwRn1LB50P3YhoUQ7fbC3iWePIZE8dHhR1EfvtZJZiNCPsR1j/JpllpPT4Bsi3sT9CLgfGbD/+L0
kQ6POvIHjS+yzslAi93SzMIXBcKBprC8gpFElk4AvqPyNddEUHZgCI+Mee23I8ha6KrMamKW7MKX
JIxYpbrQRg5E82bD2tbzs3BHhFoXwwwG1ncsYhI46RsknTVdmGWZt+1vlFTFDLL2iOtQKr3Yu3i2
ZfmQd3AZvNU8139h1zGjx+HwrHXwRHun1TCG4VpBYGDwvO0QTUfmZFOXS06vTDyx4EI7Xvi7JjxS
QRMk9M9pdE70hfFOJmzW+EprfgqL1JUq8WAD26mQyUsZD9g8Vf0gimCl6d8tThz6NREofrUnnP/d
zFsdeglEIlpl5+lsfLltM8e80jrb+vjcEBhTT1+3Juodc28hT1ClpBBVSzgHN1cAAAAAAAA=


--=-VzDkV0+a/szVwWKRjIXL--

