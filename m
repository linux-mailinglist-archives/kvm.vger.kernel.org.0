Return-Path: <kvm+bounces-55869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 795A8B37EDA
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 11:30:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BD2B36700E
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 09:30:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01235287516;
	Wed, 27 Aug 2025 09:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oYlnTQjO"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A957A17A2E1;
	Wed, 27 Aug 2025 09:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756287037; cv=none; b=q4Aj2CmyWL+Ys43gu77yEFLGWNY65PR1NGi3qpNKcQIHm8NkjV4z8T0LsKZoMTn3vu8fTqO9cLka4QINAIfxNU1nFuo1z63Kb6sUTIrWj+Vnw2e7pSNyNYLiCUx8GjFmTbw0SoklUz+I2ThfGccSCL0AYwo2xqNbXoEGBVUdtxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756287037; c=relaxed/simple;
	bh=Ozxt1DUtnntTuQmp+vTRzOM+mQMEl1bfu+5vRxfUlis=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iKTRmD2P39jZjzjCBcxR1Ui/58A3oURXUGuRzYkHlY2K9ufQXDrvPH8k2VIXsGTsYUI32g9ZFhYJWcJIWKzkK68CHN8lO6yHwn2LRH00qvVAvXHFjSoNd5ejyYkm3qQy532eixUlzii3YVHN3S6WCayNhfK7WfQwq7wMMkwupIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oYlnTQjO; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ozxt1DUtnntTuQmp+vTRzOM+mQMEl1bfu+5vRxfUlis=; b=oYlnTQjO0soWYQDqmcP7oMq6BL
	/cm9scLW8WsCjYI0Wjmgh0O2rGvDHiyL1XctZar8616VGKA049JCIFQJbwakK6vexw9iVe8piXqda
	ZVm6Sn6bkuKEzkM8asP1zRKOQirWDtBn8rUAxpGq5BWC6a+vEeoVkubxBEhhjMet58b7ETwrFyQGs
	q7Rw/SDkj2y42+nBHLO/A69DdiPPIN+Ey7RUXiVSGAJjmR+5uyslclLRF6bb/Zo4EvysfO2r7ZogH
	Ulwey/eTmpYR2nRsxMzYSd9vVbW7mSdFeYAKalOvq2GjMZQymBddq+rg/eVqUVpqYK2yvMfLcK4EP
	WKNAecQQ==;
Received: from 54-240-197-239.amazon.com ([54.240.197.239] helo=freeip.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1urCTs-00000002AGe-3kMX;
	Wed, 27 Aug 2025 09:30:13 +0000
Message-ID: <e6dd6de527d2eb92f4a2b4df0be593e2cf7a44d3.camel@infradead.org>
Subject: Re: [PATCH v2 0/3] Support "generic" CPUID timing leaf as KVM guest
 and host
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>, Colin Percival
	 <cperciva@tarsnap.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>,  Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,  x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,  graf@amazon.de, Ajay
 Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov
 <alexey.makhalov@broadcom.com>
Date: Wed, 27 Aug 2025 10:30:12 +0100
In-Reply-To: <aK4LamiDBhKb-Nm_@google.com>
References: <20250816101308.2594298-1-dwmw2@infradead.org>
	 <aKdIvHOKCQ14JlbM@google.com>
	 <933dc95ead067cf1b362f7b8c3ce9a72e31658d2.camel@infradead.org>
	 <aKdzH2b8ShTVeWhx@google.com>
	 <6783241f1bfadad8429f66c82a2f8810a74285a0.camel@infradead.org>
	 <aKeGBkv6ZjwM6V9T@google.com>
	 <fdcc635f13ddf5c6c2ce3d5376965c81ce4c1b70.camel@infradead.org>
	 <01000198cf7ec03e-dfc78632-42ee-480b-8b51-3446fbb555d1-000000@email.amazonses.com>
	 <aK4LamiDBhKb-Nm_@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-KxpmHU48OW8U1zXCQtDM"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-KxpmHU48OW8U1zXCQtDM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2025-08-26 at 12:30 -0700, Sean Christopherson wrote:
> On Fri, Aug 22, 2025, Colin Percival wrote:
> > On 8/21/25 14:10, David Woodhouse wrote:
> > > On Thu, 2025-08-21 at 13:48 -0700, Sean Christopherson wrote:
> > > > > I think I'm a lot happier with the explicit CPUID leaf exposed by=
 the
> > > > > hypervisor.
> > > >=20
> > > > Why?=C2=A0 If the hypervisor is ultimately the one defining the sta=
te, why does it
> > > > matter which CPUID leaf its in?
> > > [...]
> > >=20
> > > If you tell me that 0x15 is *never* wrong when seen by a KVM guest, a=
nd
> > > that it's OK to extend the hardware CPUID support up to 0x15 even on
> > > older CPUs and there'll never be any adverse consequences from weird
> > > assumptions in guest operating systems if we do the latter... well, f=
or
> > > a start, I won't believe you. And even if I do, I won't think it's
> > > worth the risk. Just use a hypervisor leaf :)
>=20
> But for CoCo VMs (TDX in particular), using a hypervisor leaf is objectiv=
ely worse,
> because the hypervisor leaf is emulated by the untrusted world, whereas C=
PUID.0x15
> is emulated by the trusted world (TDX-Module).
>=20
> If the issue is one of trust, what if we carve out a KVM_FEATURE_xxx bit =
that
> userspace can set to pinky swear it isn't broken?
>=20
> > FreeBSD developer here.=C2=A0 I'm with David on this, we'll consult the=
 0x15/0x16
> > CPUID leaves if we don't have anything better, but I'm not going to tru=
st
> > those nearly as much as the 0x40000010 leaf.
> >=20
> > Also, the 0x40000010 leaf provides the lapic frequency, which AFAIK is =
not
> > exposed in any other way.
>=20
> On Intel CPUs, CPUID.0x15 defines the APIC timer frequency:
>=20
> =C2=A0 The APIC timer frequency will be the processor=E2=80=99s bus clock=
 or core crystal clock
> =C2=A0 frequency (when TSC/core crystal clock ratio is enumerated in CPUI=
D leaf 0x15)
> =C2=A0 divided by the value specified in the divide configuration registe=
r.
>=20
> Thanks to TDX (again), that is also now KVM's ABI.

And AMD's Secure TSC provides it in a GUEST_TSC_FREQ MSR, I believe.

For the non-CoCo cases, I do think we'd need at least that 'I pinky
swear that CPUID 0x15 is telling the truth' bit =E2=80=94 because right now=
, on
today's hypervisors, I believe it might not be correct. So a guest
can't trust it without that bit.

But I'm also concerned about the side-effects of advertising to guests
that everything up to 0x15 is present, on older and AMD CPUs. And I
just don't see the point in that 'pinky swear' bit, when there's an
*existing* hypervisor leaf which just gives the information directly,
which is implemented in QEMU and EC2, as well as various guests.


--=-KxpmHU48OW8U1zXCQtDM
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDgyNzA5MzAx
MlowLwYJKoZIhvcNAQkEMSIEIMNN7Gb5waeOWIxe8DpLNJI5z/9HplfRDvJUtNgGeojuMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAYSuKRPxw/OE0
nSR6z6tppwc8cs7PcKRkmMoIXGv+2vqVqQqFzdc1Ozsf1FvglTK6/XS0ERxoMDmWC3vDlp0G8cK1
Fc2QNdZHKp1vy0+DS3nQy1DSs0SXKUlxvcNZcmzf1ZNVzmJqTedA8ghqnZTwgxIf2vSA7UKvClUM
JcKGINQOyMr9FxTEEzAlk2+/q+M+e1rWjwsrgFORChwRQkFh/By5vJQMOrGilmAATAYtZACGLa32
53tLfQXYnY7embLPJ5+aVbFQrlxij0Hpsia3HBto8Tf2IMjxWAQVEGx2X8J2MNrtDC5+U76A/FkC
G5/5d3Bp3P/N0P5hUon3ZPNqzMQhPbnUASCqmNaSgOfiD9RUkUpOn79f1KgsFzPpcoX4NhQW1wXb
u4a1bQnUl+Dl5ebrqATXTJASF1QT1pbj4D66hnNxbYu/BC1lSX2kJVxA6C+jmS9Ll45tsDqMaXbF
BpWsb+aTUgaG7RVhV41u7SIHvdI3IXuE4XRBcjl/Hsya5BTGQyDJpIXwQMd9x0B/9K1hvPRMuu32
K6ZxqVg9SvNvQWIGiqxhkjALgCPk/HObIFv7nNeE0N/i5Ei38X6h020b2NNQ/0R3+u08HU88+L+1
JSDg2ycd66LqsZR7fo4KQJ9TX2dBopegvUteWnrIng1e3unOS2MdQqa+uMgroWgAAAAAAAA=


--=-KxpmHU48OW8U1zXCQtDM--

