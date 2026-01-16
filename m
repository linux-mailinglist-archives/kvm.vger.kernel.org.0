Return-Path: <kvm+bounces-68296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B1298D2E6A0
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 10:01:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 414D630428EB
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 09:01:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ED41315D28;
	Fri, 16 Jan 2026 09:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qzeYnRk5"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CAD318135;
	Fri, 16 Jan 2026 09:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768554084; cv=none; b=FWR+6imnk4+34bLuHQdfksCcqBot2q/amWWiba6b3AkUKkjkIwh67oxFcwcwvM7/vnu7+JKMY5oZm6rmp0RjIwAcH4euiS3qcfG9WoJbo94amknrv7zyfq4wrosnTUo9C0DSX0xSrgvuKLutWg2/P+j3KrEzBmLkEEsCQLvJs/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768554084; c=relaxed/simple;
	bh=KMQEXW0swMPt+8sofLi6PEigokOE2XYoKeYqtfOfZvY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cX6ulkcz9ta5VCRNhmdgDuTH0Is+HHXQtUjnhOxRQWqB3nvaCMHtA6oW6xmqyu3CwUHLOo3VWRPkboSSuFhoPsDEZ6tCOc68lBCyPT05kQ4d5Im4mWElp8gbjB0r6RvJsABKRyeJSDHyepox+u7cVDzd02u8A9rY3cP8PROD370=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qzeYnRk5; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KMQEXW0swMPt+8sofLi6PEigokOE2XYoKeYqtfOfZvY=; b=qzeYnRk5/FITwmHJ6xK4dFnOhL
	sn1Efw7h6Xi6ol0XjUgd9/BjPQGZEOZXPzCoI2qhJVq0GG/CoY0TBRB748gMt80ulLT6tNq81NrqY
	H05kFtpTvmwd276QnFmQjiWhnYm73Q19ogTuuVYcthBnIdz3WkccT6NslDR9Tflzq2Cgzph7Cjq8x
	8SVkBoFGmyRgjaRJGwu1RWYMYwv8BL6zfiyHc+kbpxZNXLJZDwdfvEgk/I4QxBQ4bQbRxrYsMGVex
	DkqBJdtyW0QgmXfcZz+VS18KYI5A/TDXDX7N9ttE1rQbmDx40EffqHoi7uzjz1/OJZ5x3MtKQ7HW6
	RBRwbMZA==;
Received: from [172.31.31.148] (helo=u09cd745991455d.lumleys.internal)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vgfha-00000008LS8-1hFa;
	Fri, 16 Jan 2026 09:01:06 +0000
Message-ID: <cda9df77baa12272da735e739e132b2ac272cf9d.camel@infradead.org>
Subject: Re: [PATCH v5 1/3] KVM: x86: Refactor suppress EOI broadcast logic
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>, Khushit Shah
	 <khushit.shah@nutanix.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kai.huang@intel.com"
 <kai.huang@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
 "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
 "hpa@zytor.com" <hpa@zytor.com>,  "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>,  "dave.hansen@linux.intel.com"
 <dave.hansen@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
 Jon Kohler <jon@nutanix.com>, Shaju Abraham <shaju.abraham@nutanix.com>
Date: Fri, 16 Jan 2026 09:01:06 +0000
In-Reply-To: <aWbe8Iut90J0tI1Q@google.com>
References: <20251229111708.59402-1-khushit.shah@nutanix.com>
	 <20251229111708.59402-2-khushit.shah@nutanix.com>
	 <e09b6b6f623e98a2b21a1da83ff8071a0a87f021.camel@infradead.org>
	 <9CB80182-701E-4D28-A150-B3A0E774CD61@nutanix.com>
	 <aWbe8Iut90J0tI1Q@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-Nt/Fn1ePyRvNez5kxAM3"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html


--=-Nt/Fn1ePyRvNez5kxAM3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-01-13 at 16:10 -0800, Sean Christopherson wrote:
> Except that it needs to work when it's re-enabled in a few patches.=C2=A0=
 And as per
> commit c806a6ad35bf ("KVM: x86: call irq notifiers with directed EOI") an=
d
> https://bugzilla.kernel.org/show_bug.cgi?id=3D82211, allegedly KVM needs =
to notify
> listeners in this case.

But KVM *will* notify listeners, surely? When the guest issues the EOI
via the I/O APIC EOIR register.

For that commit to have made any difference, Xen *has* to have been
buggy, enabling directed EOI in the local APIC despite the I/O APIC not
having the required support. Thus interrupts never got EOI'd at all,
and sure, the notifiers didn't get called.

> Given that KVM didn't actually implement Directed EOI in the in-kernel I/=
O APIC,
> it's certainly debatable as to whether or not that still holds true, i.e.=
 it may
> have been a misdiagnosed root cause.=C2=A0 But I have zero interest in fi=
nding out
> the hard way, especially since the in-kernel I/O APIC is slowly being dep=
recated,
> and _especially_ not in patches that will be Cc'd stable.

Isn't that *exactly* the issue we knew we were resolving properly by
implementing the EOIR in the I/O APIC?

We should test, sure. But I don't think the existence of that commit
should make us throw our hands up in the air and be too scared of just
fixing it properly.

> So while I agree it would be nice to simultaneously enable the in-kernel =
I/O APIC,
> I want to prioritize landing the fix for split IRQCHIP.=C2=A0 And if we'r=
e clever,
> enabling in-kernel I/O APIC support in the future shouldn't require any n=
ew uAPI,
> since we can document the limitation and not advertise
> KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST in KVM_CAP_X2APIC_API when run o=
n a VM
> without a split IRQCHIP.=C2=A0 Then if support is ever added broadly, we =
can drop the
> relevant code that requires irqchip_split() and update the documentation =
to say
> that userspace need to query KVM_CAP_X2APIC_API on a VM fd to determine w=
hether
> or not the flag is supported for an in-kernel I/O APIC.
>=20
> If someone has a strong need and use case for supporting Supress EOI Broa=
dcast for
> an in-kernel I/O APIC, then they can have the honor of proving that thing=
s like
> Windows and Xen play nice with KVM's implementation.=C2=A0 And they can d=
o that on top.
>=20
> Compile tested only, but this is what I'd like to go with for now (in a s=
ingle
> patch, because IMO isolating the refactoring isn't a net positive without=
 patch 2/3).

I dislike this. It's just another wart. And it looks like userspace can
still check the cap and set KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST,
and *then* add the in-kernel I/O APIC afterwards?

If you're concerned about what to backport to stable, then arguably
it's *only* KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST which should be
backported, as that's the bug, and _ENABLE_ is a new feature?



--=-Nt/Fn1ePyRvNez5kxAM3
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDExNjA5MDEw
NlowLwYJKoZIhvcNAQkEMSIEIONvyxJISWllnUt1uLuoTMt1UJRq37iKCz8gXG+3n5XLMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAVtqGe4lRK58l
UNT9qcbMDw4QHZLPThJiIheFasKOC69Nejrv8JDvMAeTaN24wNi8GB7YcNjmcp9/RIPnWBDxtPQK
YppxM6TYIYiq4L/OCuMTYWtXR9Wpyx1EOAYn5wGuGcQYOtqNqMQ45FfWeubsvaMadOsvrZ75aZBc
Y+YN4Ywzrpw4R5prfrEL6O5KyGDhkikFCMX2AZRNiv0sttswThTqYxsULpZsPygmK6/DtuvLi+w+
w8HZYn553a+WY5g8dOD305PW1LqI43le3ONL1xbeFl8tMwu/Q2/xRKfGHTJa42qT4K3GBK3PogNp
sTmAqDXIJbcTfWBXCuQbWfCZ0p6yk96vBcHE1gG7ukzHLevPFQ6AkgS+qmwQyEdveqo4ovsvPzjy
ybZstzAv9ayOGMLnZqzMyeWMQ8JF0LrKnvbt95CEUf6bGgAGxHmfSmtXSEuDN741oUEx5Qb4Scrl
vkBrNyVeOy0/JFCBMiu7P0lX8NYkiyvY9Ia2xIew82b6WoHhdJ5WhJYa+ff5Obl4bwsXBx+fhpov
iZ5sTbv8mbIATnTeFOkMpCnCQZqdQ29/aMwzoJnvHxgnDETN4xHY2g/+AggN2W3/RUIqHFI2KF6T
pyH/EeHx9kpUB49g7cwOnvcMVTKGwaA/itm1FN8XoK1MJ6EVoYSLCbPGobbEI/cAAAAAAAA=


--=-Nt/Fn1ePyRvNez5kxAM3--

