Return-Path: <kvm+bounces-57191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8420DB512BA
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 11:39:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7AAD1562FD0
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 09:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97E503148C0;
	Wed, 10 Sep 2025 09:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l+/n/fc1"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BADD3148A1;
	Wed, 10 Sep 2025 09:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757497151; cv=none; b=n54zh7S1lliFpKpw+F0Q4xqz8zSScZcpg5TKszAqkAQ3Uad2Po9H5vkCamNygiT1NWwqzYHmdAhkWb6vh7QQKonp2S6aQ4FfJuOtrvKagPVQPqF4oSoLU32kZnT+LHy6vZQm1/qLaeje8ejLI3XiDb3B4FwGnq3wAs9tFUqno74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757497151; c=relaxed/simple;
	bh=F0hzqbKYzZ1FOBOhCdSWYTUeBbEmjSoAQE0V6lQDKVM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HCm/eoyDR4eEKY9XszuP3A+CtaLDfZrK1DruC5c8LZZ7b0zj/SsM8Ql2YcD/SOlNuA/Hl5XPJq8NrxDhzElfnPKXmuc8pszICjgvEkLs6cv2uO3GYqbsPmEnHqwRPwWmxCkkMuOlVg86LE4Mq8R0QO7ve6rm8auRFQxq+OwsgLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=l+/n/fc1; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=F0hzqbKYzZ1FOBOhCdSWYTUeBbEmjSoAQE0V6lQDKVM=; b=l+/n/fc1OUqigTJV5jGZqICZtN
	1nFwm6G2DY+wZrFrryg/zO6gh1kGp/C9eTqVZ+dYldOwi65SmXMEqxHEx3zKaByDKe2jIhhapyTEr
	M+H60u9TxZiLucwJw5ub6Brpw1WHig9VD/ea8i44ZfCDd63Sfw1/46bQP/FAkF6ZfIrnhBo0EJqll
	IgWXCeTaCeyQ7JD2VcNMw3yNgeu/F+JdgCexLGqj+Ux6HqCqYBJHqUV9vEM3ijcpBQpUTmwTu6Mfm
	05TdwB3dwHPf77eHQaIbYUEOk4fy+BeDugvmI0EPYg2hBWHa0ZOtV18FlDUUg2SdD2UCdl9RDzwh6
	Gouy/W6Q==;
Received: from 54-240-197-236.amazon.com ([54.240.197.236] helo=freeip.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwHI9-00000006aCB-00j2;
	Wed, 10 Sep 2025 09:39:05 +0000
Message-ID: <dcc29d43904f4d26fea25dbdf8a86a2bae1087a9.camel@infradead.org>
Subject: Re: [BUG] [KVM/VMX] Level triggered interrupts mishandled on
 Windows w/ nested virt(Credential Guard) when using split irqchip
From: David Woodhouse <dwmw2@infradead.org>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, Khushit Shah
	 <khushit.shah@nutanix.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	 <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
 "linux-kernel@vger.kernel.org"
	 <linux-kernel@vger.kernel.org>, Shaju Abraham <shaju.abraham@nutanix.com>
Date: Wed, 10 Sep 2025 10:39:03 +0100
In-Reply-To: <87ms72g0zk.fsf@redhat.com>
References: <7D497EF1-607D-4D37-98E7-DAF95F099342@nutanix.com>
	 <87a535fh5g.fsf@redhat.com>
	 <D373804C-B758-48F9-8178-393034AF12DD@nutanix.com>
	 <87wm69dvbu.fsf@redhat.com>
	 <376ABCC7-CF9A-4E29-9CC7-0E3BEE082119@nutanix.com>
	 <87ms72g0zk.fsf@redhat.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-m42kkFnwE69/VuJqghtc"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-m42kkFnwE69/VuJqghtc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2025-09-10 at 10:34 +0200, Vitaly Kuznetsov wrote:
> Khushit Shah <khushit.shah@nutanix.com> writes:
>=20
> > > On 8 Sep 2025, at 5:12=E2=80=AFPM, Vitaly Kuznetsov <vkuznets@redhat.=
com> wrote:
> > >=20
>=20
> ...
>=20
> > > Also, I've just recalled I fixed (well, 'workarounded') an issue
> > > similar
> > > to yours a while ago in QEMU:
> > >=20
> > > commit 958a01dab8e02fc49f4fd619fad8c82a1108afdb
> > > Author: Vitaly Kuznetsov <vkuznets@redhat.com>
> > > Date:=C2=A0=C2=A0 Tue Apr 2 10:02:15 2019 +0200
> > >=20
> > > =C2=A0=C2=A0 ioapic: allow buggy guests mishandling level-triggered
> > > interrupts to make progress
> > >=20
> > > maybe something has changed and it doesn't work anymore?
> >=20
> > This is really interesting, we are facing a very similar issue, but
> > the interrupt storm only occurs when using split-irqchip.=20
> > Using kernel-irqchip, we do not even see consecutive level
> > triggered interrupts of the same vector. From the logs it is=20
> > clear that somehow with kernel-irqchip, L1 passes the interrupt to
> > L2 to service, but with split-irqchip, L1 EOI=E2=80=99s without=20
> > servicing the interrupt. As it is working properly on kernel-
> > irqchip, we can=E2=80=99t really point it as an Hyper-V issue. AFAIK,=
=20
> > kernel-irqchip setting should be transparent to the guest, can you
> > think of anything that can change this?
>=20
> The problem I've fixed back then was also only visible with split
> irqchip. The reason was:
>=20
> """
> in-kernel IOAPIC implementation has commit 184564efae4d ("kvm:
> ioapic: conditionally delay
> irq delivery duringeoi broadcast")
> """
>=20
> so even though the guest cannot really distinguish between in-kernel
> and
> split irqchips, the small differences in implementation can make a
> big
> difference in the observed behavior. In case we re-assert improperly
> handled level-triggered interrupt too fast, the guest is not able to
> make much progress but if we let it execute for even the tiniest
> fraction of time, then the forward progress happens.=20
>=20
> I don't exactly know what happens in this particular case but I'd
> suggest you try to atrificially delay re-asserting level triggered
> interrupts and see what happens.

We know that QEMU reasserts INTx interrupts too soon anyway.

The in-kernel irqchip will trigger the VFIO resamplefd when the
interrupt is EOI'd in the I/O APIC. as $DEITY intended.

QEMU, on the other hand, will unmap the device BARs when the interrupt
happens and intercept subsequent access, triggering the VFIO resamplefd
as soon as the next access happens =E2=80=94 even before it's EOI'd.

Could that be making a difference here?

I guess, in theory, "too soon" probably shouldn't matter if it's all
handled correctly elsewhere =E2=80=94 it should get masked again in the
hardware and the pending status tracked correctly until it's
redelivered to the guest(s). But it's probably worth testing, given
that's one of the big behavioural differences between kernel and
userspace I/O APIC?

It's somewhat non-trivial to fix it 'properly' across all of QEMU's
interrupt controllers and IRQ abstractions, but hacking something up
which does the right thing just for this x86 platform and I/O APIC and
avoids the current MMIO-unmapping abomination might be worth a test?

--=-m42kkFnwE69/VuJqghtc
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDkxMDA5Mzkw
M1owLwYJKoZIhvcNAQkEMSIEIHBVDBb/DAZtk5Hrx4Jd9XTGuaAAH0szK9wVucDII+qXMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAbmAX2Zr66NwP
yg9HQgxRgBFup9MsKB1opiT9NbOUAQMMtB3YvzMoQpK0hOF92rSGDm+XQnLI/YlXjZdWlyZIiwlz
Ldyhrb1CK9bj1X2dABj2VfgNfMa5HXMoYS/hYOBIQ57nh6sruMrGdgWLL5c+kHv+BsZNCaPcYoxx
P8J+HEg2yIDfvCpK6HF6GRIJZS53Cn19RnvXiFtCYcE0ZZIUT3PrR5klhL0TJ3d56VdAlepKH7re
xYKfcuOLr/Cm4LXdjaYQifng1PmmJOvdkaxIOwg+yadpK2dj73EilueFNIdh6shWeeX1D8aYKsNU
OreH8VI9kn4pZcbq4lIkyuZGD0OUkt7chzgxeY4cFoicKzmUuMrbi5XV4XRkKwJWnXgbPGNRrt5T
p8f0aIW7LN2nuCg/23SFN2Nge2eetQ+gAbvd9vz9nQmE0yQMmVOpjR6zuHTxLlnlAK8/wIl3QW6V
FqSuHNUcMKys7oytLZHm6I630NGmTWfm6FTAJiWh0GleSWssXT/zvybTDZNXIffCzl1LTlAERzfU
kzkVVPF2rbJsQcsz2xCNYUtt/vS/WSgUj7XxKjt54qBQXa/PIged3H1vCUdkxxnob5VKw1ubQOjx
n0k8wDRGUmuzK5AH8wxSy0516a3DlOyrdiHJrq204U/ns89+NI8to2IVoK8ck90AAAAAAAA=


--=-m42kkFnwE69/VuJqghtc--

