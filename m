Return-Path: <kvm+bounces-54521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D530B227A6
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 15:03:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FED81BC0A2C
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 12:56:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 076DB266595;
	Tue, 12 Aug 2025 12:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hztRoS/K"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A187E26738D;
	Tue, 12 Aug 2025 12:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755003321; cv=none; b=H6M+hD9jYnPivFaGB4iqVLtfSrXqdtK3SKCHnTJUex/HjKsoJF574LIH9HRSe4NUOxecXGnSw+xHJSvXHDcmtJWqxrBSfCCiDKAl1pZMB04vMcpqMnANVpPQfygv9MXlsRzk1hb8r3ibk0stQzXevPMF0xIFmkvznC9HI+2T2Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755003321; c=relaxed/simple;
	bh=F1m89ry/932/GXV1ZQZ8/nR59jJyQtByFH2rMV28C+U=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=f24oPTR7Y7tFtzDpUiqpq4XuLELRLtb7LGNAWuxSE/hmlp6HDwZpKdMbvvSbRPEJLwSKm5QiL/4b5faCz85284JgPVyCOM4lfdGvOcOzCrEEq1ooP98C0XFF/Abw/3SoBWJRzHBdkhylx2QIml+GjXt/BpFGn46iEpUHEefH930=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hztRoS/K; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=F1m89ry/932/GXV1ZQZ8/nR59jJyQtByFH2rMV28C+U=; b=hztRoS/KQXXT67ZnNHvz/u9Gay
	R5xl9B+lLPBwMFWqDU/UYBQq1f+Ya1hEll/QdGopTNEAXtHV91NewuHyT42xzortGpC2/aMytSRTM
	uL5GgRMfKf9iD0bSGejJhPrcZqc17vJcKKacixVP69aLMC8z9K9eDBqhLTnzwbYu9O08guVd2qOlN
	2AST9sxuXqYYRiMs+bznunuHrBtWGf79E2kVKAWbxfvVftZ5SVsK7iU6+wDCcIMTq5/ZmfVoFMNt0
	7BpPaN3Rd6ENyWCXGnbHA8DC/BKriHw9sKrOu/iLjS5w39umFl33u0b2wFFAN7qciuWu25FNEEbnh
	26aSb4HQ==;
Received: from [54.239.6.185] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uloWj-0000000GDua-4But;
	Tue, 12 Aug 2025 12:54:55 +0000
Message-ID: <e35732dfe5531e4a933cbca37f0d0b7bbaedf515.camel@infradead.org>
Subject: Re: [PATCH] KVM: x86: Synchronize APIC State with QEMU when
 irqchip=split
From: David Woodhouse <dwmw2@infradead.org>
To: hugo lee <cs.hugolee@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, 
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com,  hpa@zytor.com, x86@kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,  Yuguo Li
 <hugoolli@tencent.com>
Date: Tue, 12 Aug 2025 14:54:53 +0200
In-Reply-To: <CAAdeq_LmqKymD8J9tgEG5AXCXsJTQ1Z1XQan5nD-1qqUXv976w@mail.gmail.com>
References: <20250806081051.3533470-1-hugoolli@tencent.com>
	 <aJOc8vIkds_t3e8C@google.com>
	 <CAAdeq_+Ppuj8PxABvCT54phuXY021HxdayYyb68G3JjkQE0WQg@mail.gmail.com>
	 <aJTytueCqmZXtbUk@google.com>
	 <CAAdeq_+wLaze3TVY5To8_DhE_S9jocKn4+M9KvHp0Jg8pT99KQ@mail.gmail.com>
	 <aJobIRQ7Z4Ou1hz0@google.com>
	 <CAAdeq_KK_eChRpPUOrw3XaKXJj+abg63rYfNc4A+dTdKKN1M6A@mail.gmail.com>
	 <d3e44057beb8db40d90e838265df7f4a2752361a.camel@infradead.org>
	 <CAAdeq_LmqKymD8J9tgEG5AXCXsJTQ1Z1XQan5nD-1qqUXv976w@mail.gmail.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-Pil4kZ6r9y3vKXHIIcyk"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-Pil4kZ6r9y3vKXHIIcyk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2025-08-12 at 19:50 +0800, hugo lee wrote:
> On Tue, Aug 12, David Woodhouse <dwmw2@infradead.org> wrote:
> >=20
> > On Tue, 2025-08-12 at 18:08 +0800, hugo lee wrote:
> > >=20
> > > On some legacy bios images using guests, they may disable PIT
> > > after booting.
> >=20
> > Do you mean they may *not* disable the PIT after booting? Linux had
> > that problem for a long time, until I fixed it with
> > https://git.kernel.org/torvalds/c/70e6b7d9ae3
> >=20
>=20
> True, they disabled LINT0 and left PIT unaware.
>=20
> > > When irqchip=3Dsplit is on, qemu will keep kicking the guest and try =
to
> > > get the Big QEMU Lock.
> >=20
> > If it's the PIT, surely QEMU will keep stealing time pointlessly unless
> > we actually disable the PIT itself? Not just the IRQ delivery? Or do
> > you use this to realise that the IRQ output from the PIT isn't going
> > anywhere and thus disable the event in QEMU completely?
> >=20
>=20
> I'm using this to disable the PIT event in QEMU.
>=20
> I'm aiming to solve the desynchronization caused by
> irqchip=3Dsplit, so the VM will behave more like the
> physical one.

I suspect I'm going to hate your QEMU patch when I see it.

KVM has a callback when the IRQ is acked, which it uses to retrigger
the next interrupt in reinject mode.

Even in !reinject mode, the kvm_pit_ack_irq() callback could just as
easily be used to allow the hrtimer to stop completely until the
interrupt gets acked. Which I understand is basically what you want to
do in QEMU?

There shouldn't be any reason to special-case it on the LINT0 setup; if
the interrupt just remains pending in the PIC and is never serviced,
that should *also* mean we stop wasting steal time on it, right?

So ideally, QEMU would have the same infrastructure to 'resample' an
IRQ when it gets acked. And then it would know when the guest is
ignoring the PIT and it needn't bother to generate any more interrupts.

Except QEMU's interrupt controllers don't yet support that. So for VFIO
INTx interrupts, for example, QEMU unmaps the MMIO BARs of the device
while an interrupt is outstanding, then sends an event to the kernel's
resample irqfd when the guest touches a register therein!

I'd love to see you fix this in QEMU by hooking up that 'resample'
signal when the interrupt is acked in the interrupt controller, and
then wouldn't the kernel side of this and the special case for LINT0 be
unneeded?


--=-Pil4kZ6r9y3vKXHIIcyk
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDgxMjEyNTQ1
M1owLwYJKoZIhvcNAQkEMSIEIBzcnKpPScdZ2uQjn1fclRZX7WJHaG6sEZ0hPSbxoseUMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAfLpIKTxEQzqu
W4xOgQkTGLPemGKWDn52lyehLrBhAa8WC1WAiUPcr5JpZWj/P4vbefruKa3yfT9qGxevYKa3ZX/V
5q4WoPrHJH2m5UWtrBTg4Qn+kj0RGGH2IIUwxUk0yMUZuTNoA1bQmaV3onbXu31xPX29Olh7/KcV
WNpDAbmcrVrEULBYCH08gmvi/H9/0GgbsJk39cl+oTdJ9y+FWVEWl/wUKRR/EiPMsBcEZYuhOJO3
qTECUrvSDj0uWhoCnQT0xMk9U8WZXo8QArWFcHzweziU7wEDiGfTA8cfezcKwPXjxBWQyLr7wxjZ
LlurFsIPo8rMihNLTYxJuiJFMduWGwlrSWAmpWYi5fra0fSHzrQwL0UwZCl3PqyYLXTXGZErUc1d
6fOGjQt2BA9Vjc0q2Z5s76at20Q9OanlT36HG+FKO+JNLYYPBJmz+kUmlTt5pVixtcCeUHAZUCup
ig3/JNU+pAmNqB6+N8K0wC3weAYljjcIVM2Po8/r+kiQ/t1XokrkoqaEUyrDoXoq7DJwUY3JrQ9D
ft/J5Gf9LNzsDXvMjw77YJ9Vb6X0MfsfSdEj33ILfnMLyU3t7eigYkk4AKnrKYx9Qc6dQcBn4VRn
tO91V4dDx7meocpPr0bOSgV69IPThf/bqAOkkb6jZDMjfoElZluwuzhaw8bbS14AAAAAAAA=


--=-Pil4kZ6r9y3vKXHIIcyk--

