Return-Path: <kvm+bounces-65210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id ABE4CC9F32B
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 14:55:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 422C54E164B
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 13:55:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A124F2FBDE4;
	Wed,  3 Dec 2025 13:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CQK8kug9"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6496F2F83C3;
	Wed,  3 Dec 2025 13:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764770145; cv=none; b=nCnfyR+2eawUV/qx2PGK+8NuwDJ6JhtTjnZ3NxGxeyR7yRWkPjcNjsJDFReIgphk26yvJR53Aj066lW/A79TpUW7Lr5P+z8Yo5TP6NYsobO0ORrhHjpVmDjTRH9keQIN/W/2LImBRmL3/y1gvp3sNx6vndcThXNPukyMJqsj72c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764770145; c=relaxed/simple;
	bh=BjRpg10847G4SIK1SLlxVWagERU5oG2AdUt+Y25O9ME=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pJOO5v+koTrI02R2NJyylJmjkU42p0T0ziK+trrHRYpBF74IRLSuBccpMoO/fFtYiIpaM1yl/csxrvkZoQ3N+4f1tvRpvVA5P2edLtEISAvPryMvDFakqCBkD2etSXK67u3UH2HgFmsAV5b86AfUgdykiyJTHSSKKay3IcNhIQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CQK8kug9; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0xZkaNbaoF5bqnab7vb0QpLuo33Zfdpcvh76LOOgDL0=; b=CQK8kug9pfn7dfiUuCOFnDz/Ey
	fiU1v5ASuQu/YQHXb+PYwDKoS6ttB1Y35WDj/nGH15kKc+p/+YOQRFo1SG1PwxHetH1XyxU/gMxiw
	YXJ/Hp0EH5XnEX8MYpwThD8ToDFgYwZ/0FXdYE2FDc93VzOPSerQjC26kIKzpv5K34/jScTlX6JsY
	VwmaE1tCQ2DQ2CVfLhPYSY8sbStfWM9HRpRojiNZMo5KonykXbvii9clrRAe4KjDL1l5QwvXIvctO
	i4QefjJwkbkLdTr6bzts0yMzm8TbGjJPglgTVoWwKyRfbczqcSUc9t0GhuPpqQQyGEDIhmfnDW5kB
	RADgIoKg==;
Received: from [172.31.31.148] (helo=u09cd745991455d.lumleys.internal)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQmSr-00000002JgH-1fYR;
	Wed, 03 Dec 2025 13:00:13 +0000
Message-ID: <e5e180a20dd370f805a5b8070cfee1f4d5f5aa5e.camel@infradead.org>
Subject: Re: [PATCH v3] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
From: David Woodhouse <dwmw2@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Huang, Kai" <kai.huang@intel.com>, "seanjc@google.com"
 <seanjc@google.com>,  "shaju.abraham@nutanix.com"
 <shaju.abraham@nutanix.com>, "khushit.shah@nutanix.com"
 <khushit.shah@nutanix.com>, "x86@kernel.org" <x86@kernel.org>,
 "bp@alien8.de" <bp@alien8.de>, "stable@vger.kernel.org"
 <stable@vger.kernel.org>,  "hpa@zytor.com" <hpa@zytor.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
 "mingo@redhat.com" <mingo@redhat.com>, "dave.hansen@linux.intel.com"
 <dave.hansen@linux.intel.com>,  "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "Kohler, Jon" <jon@nutanix.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>
Date: Wed, 03 Dec 2025 13:55:33 +0000
In-Reply-To: <CABgObfbSWZUMS8cMvYQE9FpeWjk=Lam+A_ysQvaJqL5LQ4fYag@mail.gmail.com>
References: <20251125180557.2022311-1-khushit.shah@nutanix.com>
	 <6353f43f3493b436064068e6a7f55543a2cd7ae1.camel@infradead.org>
	 <A922DCC2-4CB4-4DE8-82FA-95B502B3FCD4@nutanix.com>
	 <118998075677b696104dcbbcda8d51ab7f1ffdfd.camel@infradead.org>
	 <aS8I6T3WtM1pvPNl@google.com>
	 <68ad817529c6661085ff0524472933ba9f69fd47.camel@infradead.org>
	 <aS8Vhb66UViQmY_Q@google.com>
	 <352e189ec40fae044206b48ca6e68d77df7dced1.camel@intel.com>
	 <d3b8fd036f05e9819f654c18853ff79a255c919d.camel@infradead.org>
	 <CABgObfa3wNsQBjAwWuBhWQbw4FuO7TGePuNzfqAYS1CzRFP6DQ@mail.gmail.com>
	 <176b8e96123231baf0f18009d27e82688eac1ead.camel@infradead.org>
	 <CABgObfbSWZUMS8cMvYQE9FpeWjk=Lam+A_ysQvaJqL5LQ4fYag@mail.gmail.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-p86za0Vi3OYeihjNxHBo"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html


--=-p86za0Vi3OYeihjNxHBo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2025-12-03 at 14:36 +0100, Paolo Bonzini wrote:
>=20
> > So yes, it's a guest-visible change, but only if the VMM explicitly
> > *asks* for the broadcast suppression feature to work, in which case
> > it's *necessary* anyway.
>=20
> I see what you mean and I guess you're right... "Setting X will cause
> the in-kernel IOAPIC to report version 0x20" is as obscure as it gets,
> but then so is "Setting X will break guests unless you tell in-kernel
> IOAPIC to report version 0x20".
>=20
> So this is good, but the docs need to say clearly that this should
> only be set if either full in-kernel irqchip is in use or, for split
> irqchip, if the userspace IOAPIC implements directed EOI correctly.

Updated patch below, dropping the struct change and just directly using
the helper which I *believe* is going to be called
kvm_lapic_ignore_suppress_eoi_broadcast() and have the opposite
polarity to the one I proposed upthread. Doesn't build here because of
that helper, obvs.

Still untested.

For the documentation then, how about...

Setting KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST causes KVM to
advertise and correctly implement the Directed EOI feature in the local
APIC, suppressing broadcast EOI when the feature is enabled by the
guest. Setting this flag will also cause the in-kernel I/O APIC to
advertise version 0x20 with support for the EOI register; a userspace
implementation of I/O APIC should also support the same, as some guest
operating systems do not check for that feature in the I/O APIC before
disabling the broadcast in the local APIC.=20

Setting KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST causes KVM not to
advertise the Directed EOI feature in the local APIC.

Userspace should explicitly either enable or disable the EOI broadcast
using one of the two flags above. For historical compatibility reasons,
if neither flag is set then KVM will advertise the feature but will not
actually suppress the EOI broadcast, leading to potential IRQ storms in
some guest configurations.


From: David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH] KVM: x86/ioapic: Implement support for I/O APIC version 0x=
20 with EOIR

As the weirdness with EOI broadcast suppression is being fixed in KVM,
also update the in-kernel I/O APIC to handle the directed EOI which
guests will need to use instead, when broadcast EOI suppression is
fully enabled.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/ioapic.c | 30 ++++++++++++++++++++++++++++--
 arch/x86/kvm/ioapic.h | 20 ++++++++++++--------
 2 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 2c2783296aed..0ed84b02c521 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -48,8 +48,11 @@ static unsigned long ioapic_read_indirect(struct kvm_ioa=
pic *ioapic)
=20
 	switch (ioapic->ioregsel) {
 	case IOAPIC_REG_VERSION:
-		result =3D ((((IOAPIC_NUM_PINS - 1) & 0xff) << 16)
-			  | (IOAPIC_VERSION_ID & 0xff));
+		if (kvm_lapic_ignore_suppress_eoi_broadcast(ioapic->kvm))
+			result =3D IOAPIC_VERSION_ID;
+		else
+			result =3D IOAPIC_VERSION_ID_EOIR;
+		result |=3D ((IOAPIC_NUM_PINS - 1) & 0xff) << 16;
 		break;
=20
 	case IOAPIC_REG_APIC_ID:
@@ -57,6 +60,10 @@ static unsigned long ioapic_read_indirect(struct kvm_ioa=
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
@@ -695,6 +702,25 @@ static int ioapic_mmio_write(struct kvm_vcpu *vcpu, st=
ruct kvm_io_device *this,
 		ioapic_write_indirect(ioapic, data);
 		break;
=20
+	case IOAPIC_REG_EOIR:
+		/*
+		 * The EOIR register is supported (and version 0x20 advertised)
+		 * when userspace explicitly enables broadcast EOI supression.
+		 */
+		if (!kvm_lapic_ignore_suppress_eoi_broadcast(vcpu->kvm)) {
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
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index bf28dbc11ff6..59d877f5f27b 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -11,7 +11,8 @@ struct kvm_vcpu;
=20
 #define IOAPIC_NUM_PINS  KVM_IOAPIC_NUM_PINS
 #define MAX_NR_RESERVED_IOAPIC_PINS KVM_MAX_IRQ_ROUTES
-#define IOAPIC_VERSION_ID 0x11	/* IOAPIC version */
+#define IOAPIC_VERSION_ID	0x11	/* Default IOAPIC version */
+#define IOAPIC_VERSION_ID_EOIR	0x20	/* IOAPIC version with EOIR support */
 #define IOAPIC_EDGE_TRIG  0
 #define IOAPIC_LEVEL_TRIG 1
=20
@@ -19,13 +20,16 @@ struct kvm_vcpu;
 #define IOAPIC_MEM_LENGTH            0x100
=20
 /* Direct registers. */
-#define IOAPIC_REG_SELECT  0x00
-#define IOAPIC_REG_WINDOW  0x10
-
-/* Indirect registers. */
-#define IOAPIC_REG_APIC_ID 0x00	/* x86 IOAPIC only */
-#define IOAPIC_REG_VERSION 0x01
-#define IOAPIC_REG_ARB_ID  0x02	/* x86 IOAPIC only */
+#define IOAPIC_REG_SELECT	0x00
+#define IOAPIC_REG_WINDOW	0x10
+#define IOAPIC_REG_IRQPA	0x20
+#define IOAPIC_REG_EOIR		0x40	/* version 0x20+ only */
+
+/* INDIRECT registers. */
+#define IOAPIC_REG_APIC_ID	0x00	/* x86 IOAPIC only */
+#define IOAPIC_REG_VERSION	0x01
+#define IOAPIC_REG_ARB_ID	0x02	/* x86 IOAPIC only */
+#define IOAPIC_REG_BOOT_CONFIG	0x03	/* x86 IOAPIC only */
=20
 /*ioapic delivery mode*/
 #define	IOAPIC_FIXED			0x0
--=20
2.43.0



--=-p86za0Vi3OYeihjNxHBo
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MTIwMzEzNTUz
M1owLwYJKoZIhvcNAQkEMSIEIL0z/7OBxyBO91rfdrgAAwGs8qrUmH2+hMM2tnQsctknMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAZCykmQR/prN+
niqnwv3PA0wd70Ii755mbcIOjkCY5p/kXnHnVLQmgnf/7S6fgGFgZdNEKpBhn27SHtvr8PNACjsw
NL/+iZG+Lcc8uc96JeLsqGD2JJDtYxiF18jir4Ppg441RfYlGT0EYb99PS/8qm61XiSK4fjvSgZL
oBJtWs6z1qfwNQheUJ5PujwGICBbcdc6n2fg3bSp3iPE5Z7TT9xKeMc3INan0yfzvMGCa0NoAzBQ
lkgMGb0qWLybC2L7mJhQ89+sGux40SP+Ky3jryJTPgWo+AsN+yA7TcmHM0YTy+RJaM4ISgEMEPGP
joyeZVbY+XF26l11ZvTu6jZ5+HXTD/SvRqvTIRAxXKwjju6TVR8MRtPFfGIs7resz5ycKDJ/5enG
+vJWPNfbs4FV7phKAf6gdFS0alFwY8cRkwbC8QOGipiU3brcuCReGQ/hgXZWxMY9Y8W0Y1BQ1y4c
ZiOkbSiQbFBWnxMvVd+rNBrQWEMy8WHg143DaMqGGJHOMUnfJWzbM/25hdXWgKsgb+0OTzuvPKPn
j9IZ/VQ6AeI9yxMKW/ADcA7nxt3MhF/8Xl8XrlTw641DISz7IhiR1DFffqDBJGItp572hLIOj6yT
h7pTC1KF6PqOo9GHbuMW4kdr2GCxhRxTDTRGOHnBeZq/g4HiwKNdWKXrf7+pxKUAAAAAAAA=


--=-p86za0Vi3OYeihjNxHBo--

