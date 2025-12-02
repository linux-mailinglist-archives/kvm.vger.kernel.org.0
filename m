Return-Path: <kvm+bounces-65120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F106C9C073
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 16:51:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 074CF346A19
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 15:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD913322C89;
	Tue,  2 Dec 2025 15:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i5TzJDOr"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD7F30F7F3;
	Tue,  2 Dec 2025 15:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764690695; cv=none; b=CsWWCG0xuJc+WqBHC75m7lEZAztNzdatn4Fm6rRBguH/HqkxH+bUXgafmUrl5s8DLl1YjhkTKagoGxZ8mF9vq/mqTI2Kk/1EAbkPbWRcTP3okvCmItjwSIDkUF2GH27UZuEZ1b4waVSavivfNiMZst2cElZ8uiH0UboMK9FxPig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764690695; c=relaxed/simple;
	bh=Y+xm6yYMrbdfnsC+GQwhjANva6p2Tor455oEmPHnI78=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=E5FjMSnHj7mBDmCoMDUEgT4qzZQdlSe3QWxr8BeGvIG7QeRkIbn1Ns2iupD1+eXBVpVQGVMrbK+CEDTWBhb0U5T4RXDcAGea6hz+zlwYKj/Yur6NcJyVieGXgLV1Wmkj/ze5bqRpR5Q61tOHyLm4lelhKNHlocjfDTRL9KeZcVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i5TzJDOr; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Y+xm6yYMrbdfnsC+GQwhjANva6p2Tor455oEmPHnI78=; b=i5TzJDOr8krplaRoM1BctyhRiL
	W7JJ2uMuQ14gy0K7M0o/4j7CUJThWQ3pxcnYD9nsd6/p4jH+Cs+gfGV0h+ar/eEupe9AaEXL7I8zB
	+ecenOpsq09JNm4q5b6qvXjdC+skk04ndCtxxUYKw2G4bTQOkvoCwcRQWEqNWwoJnQBfcybOeAnPQ
	lxLZeIe/YGjcDf5gz+Klumu8mChs8lSieO58jwSNzz+dmV9uXeZQYJvDXWiYcy1K5thlpLny8RW8T
	jNKEi/8N7UDoPD2cQTixZkL9b1SXKLiDfqgMuvfueaHsKbF3/xOyjvj6vUUiEuOCLu2aVTE1tjtg+
	lnQHgKlA==;
Received: from [172.31.31.148] (helo=u09cd745991455d.ant.amazon.com)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQRnN-00000000aYi-0tRx;
	Tue, 02 Dec 2025 14:56:01 +0000
Message-ID: <68ad817529c6661085ff0524472933ba9f69fd47.camel@infradead.org>
Subject: Re: [PATCH v3] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Khushit Shah <khushit.shah@nutanix.com>, "pbonzini@redhat.com"
 <pbonzini@redhat.com>, "kai.huang@intel.com" <kai.huang@intel.com>, 
 "mingo@redhat.com" <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
 "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,  "dave.hansen@linux.intel.com"
 <dave.hansen@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
 Jon Kohler <jon@nutanix.com>, Shaju Abraham <shaju.abraham@nutanix.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
Date: Tue, 02 Dec 2025 15:51:21 +0000
In-Reply-To: <aS8I6T3WtM1pvPNl@google.com>
References: <20251125180557.2022311-1-khushit.shah@nutanix.com>
	 <6353f43f3493b436064068e6a7f55543a2cd7ae1.camel@infradead.org>
	 <A922DCC2-4CB4-4DE8-82FA-95B502B3FCD4@nutanix.com>
	 <118998075677b696104dcbbcda8d51ab7f1ffdfd.camel@infradead.org>
	 <aS8I6T3WtM1pvPNl@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-NvBv7oJ3LkT4+2EwtJHj"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html


--=-NvBv7oJ3LkT4+2EwtJHj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2025-12-02 at 07:42 -0800, Sean Christopherson wrote:
> On Tue, Dec 02, 2025, David Woodhouse wrote:
> > On Tue, 2025-12-02 at 12:58 +0000, Khushit Shah wrote:
> > > Thanks for the review!
> > >=20
> > > > On 2 Dec 2025, at 2:43=E2=80=AFPM, David Woodhouse <dwmw2@infradead=
.org> wrote:
> > > >=20
> > > > Firstly, excellent work debugging and diagnosing that!
> > > >=20
> > > > On Tue, 2025-11-25 at 18:05 +0000, Khushit Shah wrote:
> > > > >=20
> > > > > --- a/Documentation/virt/kvm/api.rst
> > > > > +++ b/Documentation/virt/kvm/api.rst
> > > > > @@ -7800,8 +7800,10 @@ Will return -EBUSY if a VCPU has already b=
een created.
> > > > > =C2=A0
> > > > > =C2=A0Valid feature flags in args[0] are::
> > > > > =C2=A0
> > > > > -=C2=A0 #define KVM_X2APIC_API_USE_32BIT_IDS=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (1ULL << 0)
> > > > > -=C2=A0 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK=C2=A0 (1UL=
L << 1)
> > > > > +=C2=A0 #define KVM_X2APIC_API_USE_32BIT_IDS=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 (1ULL << 0)
> > > > > +=C2=A0 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (1ULL << 1)
> > > > > +=C2=A0 #define KVM_X2APIC_API_DISABLE_IGNORE_SUPPRESS_EOI_BROADC=
AST_QUIRK (1ULL << 2)
> > > > > +=C2=A0 #define KVM_X2APIC_API_DISABLE_SUPPRESS_EOI_BROADCAST=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 (1ULL << 3)
> > > > >=20
> > > >=20
> > > > I kind of hate these names. This part right here is what we leave
> > > > behind for future generations, to understand the weird behaviour of
> > > > KVM. To have "IGNORE" "SUPPRESS" "QUIRK" all in the same flag, quit=
e
> > > > apart from the length of the token, makes my brain hurt.
>=20
> ...
>=20
> > > > Could we perhaps call them 'ENABLE_SUPPRESS_EOI_BROADCAST' and
> > > > 'DISABLE_SUPPRESS_EOI_BROADCAST', with a note saying that modern VM=
Ms
> > > > should always explicitly enable one or the other, because for
> > > > historical reasons KVM only *pretends* to support it by default but=
 it
> > > > doesn't actually work correctly?
>=20
> I don't disagree on the names being painful, but ENABLE_SUPPRESS_EOI_BROA=
DCAST
> vs. DISABLE_SUPPRESS_EOI_BROADCAST won't work, and is even more confusing=
 IMO.

I dunno, KVM never actually *did* suppress the EOI broadcast anyway,
did it? This fix really *does* enable it =E2=80=94 as opposed to just
pretending to?

I was thinking along the lines of ...


Setting KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST causes KVM to
advertise and correctly implement the Directed EOI feature in the local
APIC, suppressing broadcast EOI when the feature is enabled by the
guest.

Setting KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST causes KVM not to
advertise the Directed EOI feature in the local APIC.

Userspace should explicitly either enable or disable the EOI broadcast
using one of the two flags above. For historical compatibility reasons,
if neither flag is set then KVM will advertise the feature but will not
actually suppress the EOI broadcast, leading to potential IRQ storms in
some guest configurations.

--=-NvBv7oJ3LkT4+2EwtJHj
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MTIwMjE1NTEy
MVowLwYJKoZIhvcNAQkEMSIEILXPtpPWnKec2VjNP5ZypOPfj9uHNZjTXoyHkrRvtDqQMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIALD6p76R6sJsm
FQ3VP3ZjCdehUjk4hzyKMiiVwwf0s0XlJEw8G/nux+dVBs15vBc/gFXFz8XqMsPFGO0pqitjLYpR
b/xFjOAQLHO4eB7rPMDavFNevoNbN96WReeFI6hQ5gMj6dScz4CNCMlizXXXSVGKbSfx6zcmebfw
0tFciXJp2viD1eQwiawlZ5J/rK2h+Iq/kPR76wmdIA8xxg6GUNvg4ytCfxJr8W6+gzPAYe+y5aBv
iyr5ZEj80rxTW8JZ8jW7YkTvEZ7U4JXn4o5NR6ZMJYfgRz3ASXqao3eF0jjZKG2K5rFWZ/lt+Piz
63pVKR+5EOUnbCNvTA1KYCFKaVx4q4p4oAk6AKnSwiHJYz/Q4S7peBbiZjgmNUZA0u1x+27L3795
W3CNnAYml9tUaFi/ntCo8nIMAuANx+Mtn8+l0CIBstCyzHP8mNmjky7aYsJkVl4/pCJHQImv9Dhr
XFE9Qhqy05i+jFH61/BMGGrPbYecpX3LC2w0cRS1eXVdo4faeZ+wtCw4smYwuzyjiqcA26ov3BrQ
lc8b/rMQcq513YPxpOxPSpUu4j+bdmGD/+DQ6OZhJIr1Q4xbiJpL6k5eosRNsxIn90hahhR/XUlc
Lwhl6hfD27AL0lkAZ20SuGBD4NsUDzs51J8WWC338Kxs+xyx8fvrhOCzKky198kAAAAAAAA=


--=-NvBv7oJ3LkT4+2EwtJHj--

