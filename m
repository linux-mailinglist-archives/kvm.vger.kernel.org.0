Return-Path: <kvm+bounces-65206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EA5CC9F23E
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 14:32:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 348B43A642D
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 13:32:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 272B92FB614;
	Wed,  3 Dec 2025 13:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kQ8hAGes"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8412FB0AF;
	Wed,  3 Dec 2025 13:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764768738; cv=none; b=oCWAmLdnpYrXP+C7NuFXSdNypI4JsisMklXxfHY3jFxpXtCFXjay2EB6Zp+bcInmcHIJhzPDo82qnFV/8NQSWG/34StQC8S21Ew88n1RolvIQp8W0Oo52LYerj22U75rhealLwRvuce6z8F5ScKYxWx6PbQTbactBNqGHssE+sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764768738; c=relaxed/simple;
	bh=1DcorL0TxtsQUBCXOmOPMR5UoEMWig+qSDfHjDENTRM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rYK/Pr6Hb6e09XWNo3tFfTPJTOrXM74cXSC6IuhvsgQII6I+L9p3aoWK3MeCbQV4IS87OHTRvxYF1LTYgh4KJryRQ45Ts/VRLjOkFaX+24vuQq4F2lDU7p2Wpdpamy/MP6h7pt8aAtOONTODCpSwEnrnlbmRvraonscBw/4KpfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kQ8hAGes; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1DcorL0TxtsQUBCXOmOPMR5UoEMWig+qSDfHjDENTRM=; b=kQ8hAGes04d8zCe8Lr8RLhlV8P
	wY+PRy7mO6HpMc+aQhSvjur0sGVUxcSPLl31a/NFNr7tRl+9sNplpsxD8Zkka5C9DcV3j4z4V6Vn2
	wiglb8hpMpF7PdhfGQetQLIeNpmsnFbxq+nqfHU+i/YeOXjs6Hrf3PTtScY/iJz63qgfd0BSvzxm3
	xELWcRBbhQbeFqMUFaD1J7nfNG9KLG5/uPL5qTDBrTfoFJwLnsfmskER7/JblqRsI/SswhNQ/gA1E
	kb9JqYA1tNqjeMi4iyObkOhsxtBg7ItzSMYEQBpYG9DD7Cwqki4hO1cfqon0/ML+mlFot4dICSwuc
	NwZsHtwA==;
Received: from [172.31.31.148] (helo=u09cd745991455d.lumleys.internal)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQm6B-00000002Hxk-2oNz;
	Wed, 03 Dec 2025 12:36:47 +0000
Message-ID: <176b8e96123231baf0f18009d27e82688eac1ead.camel@infradead.org>
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
Date: Wed, 03 Dec 2025 13:32:07 +0000
In-Reply-To: <CABgObfa3wNsQBjAwWuBhWQbw4FuO7TGePuNzfqAYS1CzRFP6DQ@mail.gmail.com>
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
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-/SYc44KbEM/QfwNbsn7B"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html


--=-/SYc44KbEM/QfwNbsn7B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2025-12-03 at 14:10 +0100, Paolo Bonzini wrote:
> On Wed, Dec 3, 2025 at 1:26=E2=80=AFPM David Woodhouse <dwmw2@infradead.o=
rg> wrote:
> >=20
> > On Wed, 2025-12-03 at 00:50 +0000, Huang, Kai wrote:
> > >=20
> > > > -#define KVM_X2APIC_API_USE_32BIT_IDS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (1ULL << 0)
> > > > -#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK=C2=A0 (1ULL << 1)
> > > > +#define KVM_X2APIC_API_USE_32BIT_IDS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 (_BITULL(0))
> > > > +#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (_BITULL(1))
> > > > +#define KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST=C2=A0=C2=A0 (_BIT=
ULL(2))
> > > > +#define KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST=C2=A0 (_BITULL(3=
))
> > >=20
> > > I hate to say, but wants to ask again:
> > >=20
> > > Since it's uAPI, are we expecting the two flags to have impact on in-=
kernel
> > > ioapic?
> > >=20
> > > I think there should no harm to make the two also apply to in-kernel =
ioapic.
> > >=20
> > > E.g., for now we can reject KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST =
flag for
> > > in-kernel ioapic.=C2=A0 In the future, we might add EOI register supp=
ort to in-kernel
> > > ioapic and report supporting suppress EOI broadcast, then we can in-k=
ernel
> > > ioapic to honor these two flags too.
> >=20
> > I don't think we should leave that to the unspecified 'future'. Let's
> > fix the kernel I/O APIC to support the directed EOI at the same time,
> > rather than having an interim version of KVM which supports the
> > broadcast suppression but *not* the explicit EOI that replaces it.
> >=20
> > Since I happened to have the I/O APIC PDFs in my recent history for
> > other reasons, and implemented these extra registers for version 0x20
> > in another userspace VMM within living memory, I figured I could try to
> > help with the actual implementation (untested, below).
> >=20
> > There is some bikeshedding to be done on precisely *how* ->version_id
> > should be set. Maybe we shouldn't have the ->version_id field, and
> > should just check kvm->arch.suppress_eoi_broadcast to see which version
> > to report?
>=20
> That would make it impossible to use the fixed implementation on the
> local APIC side, without changing the way the IOAPIC appears to the
> guest.

Yes, but remember that "the fixed implementation on the local APIC
side" means precisely that it's fixed to *not* broadcast the EOI. Which
means you absolutely *need* to have an I/O APIC capable of receiving
the explicit directed EOI, or the EOI will never happen at all.

Which is why it probably makes sense to drop the 'version_id' field
from the struct where I'd added it, and just make the code report a
hard-coded version based on suppress_eoi_broadcast being enabled:
=20
(kvm->arch.suppress_eoi_broadcast =3D=3D KVM_SUPPRESS_EOI_ENABLED) ? 0x20: =
0x11

So yes, it's a guest-visible change, but only if the VMM explicitly
*asks* for the broadcast suppression feature to work, in which case
it's *necessary* anyway.


> There are no parameters that you can use in KVM_CREATE_IRQCHIP,
> unfortunately, and no checks that (for example) kvm_irqchip.pad or
> kvm_ioapic_state.pad are zero.
>=20
> The best possibility that I can think of, is to model it like KVM_CAP_XSA=
VE2
>=20
> 1) Add a capability KVM_CAP_IRQCHIP2 (x86 only)
>=20
> 2) If reported, kvm_irqchip.pad becomes "flags" (a set of flag bits)
> and kvm_ioapic_state.pad becomes version_id when returned from
> KVM_GET_IRQCHIP. Using an anonymous union allows adding the synonyms.
>=20
> 3) On top of this, KVM_SET_IRQCHIP2 is added which checks that
> kvm_irqchip.flags is zero and that kvm_ioapic_state.version_id is
> either 0x11 or 0x20.
>=20
> 4) Leave the default to 0x11 for backwards compatibility.
>=20
> The alternative is to add KVM_ENABLE_CAP(KVM_CAP_IRQCHIP2) but I
> dislike adding another stateful API.

Yeah. Just gate it on the existing (well, nascent)
KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST flag.

--=-/SYc44KbEM/QfwNbsn7B
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MTIwMzEzMzIw
N1owLwYJKoZIhvcNAQkEMSIEIJNPZueGuDsI1JSxWLcULZMpLmL+iD/piVMx3eEyYRD9MGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIA2MgpKRsvTg8h
rlbHGZpDmsfjv1a4ZSdyfH+y2cWZAJpVwtiLJ7s3W2v6NF3XRcqJ8DBHTXMGyyxue4lxRT9DjF8I
oJAy5IUR35BKOk3R/C305e5rA39NiKqolJ39DfF4T5FhcrH7DHQnmteI/3NHcmZ40Axi6Pj6OwTo
PF6f+bQ9PtM3woQlXnh5cL7+dTeKNnLvwkkbW49kSP/56DmntLY8gexRu9fPYBEhYpx/EMgp2pho
hKfborJ76XejN1m6G7edO1P1XdlLq8GQZMdHpQt/3O4QRV/tq9YUTHhuoVTtg3WkasyV9IpELun2
cCgD2sxWqwFj1nG0Hxg34mMqT1MKKZcOvuARb0TVE6pf37hHouF6NXAINWE64fZVqIqz5kcVFSaA
TSg6fCuRVihq6UqQ8EqINCGakdUXce+dsSTmgopgx3BLdUPrWUxUMkGatTLexTMGAa4DAJ+Uxlx/
LyAUFecO/O6ee8TjtMBtDwbq0XdAx6R7sejp6Iq/3wiSMqP9fq3xjQwBvH49LVy6ZPya3PV9ZbsW
wbhEf498aAjp+mNp7Ia6gQSbUNyYjCOBnlgBXaqz+AYsRELuWJdE3w3ot9ohGrDlWWuy5JdxvIIB
yDzP8bX66+x1fP93ECCDGAaY1hTwllyctnY/5yUN2tvs+B8zWHWlqqlkhTU0GdwAAAAAAAA=


--=-/SYc44KbEM/QfwNbsn7B--

