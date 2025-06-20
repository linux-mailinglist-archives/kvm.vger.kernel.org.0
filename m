Return-Path: <kvm+bounces-50145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B305AE21B9
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 20:00:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CE101C24A7B
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 18:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 506C32EA16F;
	Fri, 20 Jun 2025 18:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FpDJ0ppU"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C2930E830;
	Fri, 20 Jun 2025 18:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750442427; cv=none; b=ZTyJXBFUTGQfmi+B7Il9KWxEZS4iDMVVqxqiI+IxU4orzK30i1AMZLVE+VAjxyqaNrHN/+JqvUdDp6Wpac1J8UtkHxtxe+oeRPHpMBVA/8WHv6K9xr7DeG1T9+H0WDT5vHPYPmt2Y8Kpk5elRaDVx4mFtPBDHvvVuWfjZoMhvmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750442427; c=relaxed/simple;
	bh=V4BtGj5IM9fOMsL9rGEeYG0L2bnwTk/mzU1tC5NhGAw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YOgVFYskY2P/NjfX/C7SEf7FRPdiJzGXNrznWd6Hzv2nVYhuDZ/SzIBwUIsUtpOgs1SSSorceCaFibEHbStEdsD1sqTS0wF8y5xKezELuY9n9+MOmNcyrpIhpH2nDnD1OLlelWnXx6L3EeTqt6YDehImvm09h7ZG8nmkqUf3brE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FpDJ0ppU; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=V4BtGj5IM9fOMsL9rGEeYG0L2bnwTk/mzU1tC5NhGAw=; b=FpDJ0ppU2cz+Gy7OZxO+YydSmq
	4NsQe9Y22p5v6Fnl8tm3NpgRLAUsfB+z5YsNATk+Jnh65F2c4qzeS9l7XB+BDhRHiWlQvWTdgjJPH
	pSNBZEniC6s6WuWi8T5N5qM1v+KpgjiNZ6aJaMXclCbH//+Ud0DuFcr4lYSwq+eNMRkbvuJe36RGS
	moWsCTeWo2deuOQ1mC1iCLlLYScqVCwtt40ZNmQv2qnFQma7794kGicaNGyLXjObXqtiQJ1MB4SP1
	hNGaI5T8fASvuePTlRhYKk4QCu8SjvRSv1Ln3zXRq1AgsC6l7JdYq+71jamf51mph5YpkpcFQxUWn
	IdNDGoJQ==;
Received: from [2001:8b0:10b:5:92ee:a97b:9346:ea1d] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uSg2A-0000000DGwR-0nHH;
	Fri, 20 Jun 2025 18:00:14 +0000
Message-ID: <5ab7c4684b0a81a4078701518f2a9786e2b8c7fc.camel@infradead.org>
Subject: Re: [PATCH v3 02/62] KVM: arm64: WARN if unmapping vLPI fails
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>, Oliver Upton
	 <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
 Joerg Roedel <joro@8bytes.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 linux-arm-kernel@lists.infradead.org,  kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, iommu@lists.linux.dev,  linux-kernel@vger.kernel.org,
 Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins
 <joao.m.martins@oracle.com>, Francesco Lavra <francescolavra.fl@gmail.com>,
  David Matlack <dmatlack@google.com>
Date: Fri, 20 Jun 2025 19:00:12 +0100
In-Reply-To: <aFWY2LTVIxz5rfhh@google.com>
References: <20250611224604.313496-2-seanjc@google.com>
	 <20250611224604.313496-4-seanjc@google.com> <86tt4lcgs3.wl-maz@kernel.org>
	 <aErlezuoFJ8u0ue-@google.com> <aEyOcJJsys9mm_Xs@linux.dev>
	 <aFWY2LTVIxz5rfhh@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-N2ILD2/GdREWZxl5A43d"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-N2ILD2/GdREWZxl5A43d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2025-06-20 at 10:22 -0700, Sean Christopherson wrote:
> On Fri, Jun 13, 2025, Oliver Upton wrote:
> > On Thu, Jun 12, 2025 at 07:34:35AM -0700, Sean Christopherson wrote:
> > > On Thu, Jun 12, 2025, Marc Zyngier wrote:
> > > > But not having an VLPI mapping for an interrupt at the point where =
we're
> > > > tearing down the forwarding is pretty benign. IRQs *still* go where=
 they
> > > > should, and we don't lose anything.
> >=20
> > The VM may not actually be getting torn down, though. The series of
> > fixes [*] we took for 6.16 addressed games that VMMs might be playing o=
n
> > irqbypass for a live VM.
> >=20
> > [*] https://lore.kernel.org/kvmarm/20250523194722.4066715-1-oliver.upto=
n@linux.dev/
> >=20
> > > All of those failure scenario seem like warnable offences when KVM th=
inks it has
> > > configured the IRQ to be forwarded to a vCPU.
> >=20
> > I tend to agree here, especially considering how horribly fragile GICv4
> > has been in some systems. I know of a couple implementations where ITS
> > command failures and/or unmapped MSIs are fatal for the entire machine.
> > Debugging them has been a genuine pain in the ass.
> >=20
> > WARN'ing when state tracking for vLPIs is out of whack would've made it
> > a little easier.
>=20
> Marc, does this look and read better?
>=20
> I'd really, really like to get this sorted out asap, as it's the only thi=
ng
> blocking the series, and I want to get the series into linux-next early n=
ext
> week, before I go OOO for ~10 days.
>=20
> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Thu, 12 Jun 2025 16:51:47 -0700
> Subject: [PATCH] KVM: arm64: WARN if unmapping a vLPI fails in any path
>=20
> When unmapping a vLPI, WARN if nullifying vCPU affinity fails, not just i=
f
> failure occurs when freeing an ITE.=C2=A0 If undoing vCPU affinity fails,=
 then
> odds are very good that vLPI state tracking has has gotten out of whack,
> i.e. that KVM and the GIC disagree on the state of an IRQ/vLPI.=C2=A0 At =
best,
> inconsistent state means there is a lurking bug/flaw somewhere.=C2=A0 At =
worst,
> the inconsistency could eventually be fatal to the host, e.g. if an ITS
> command fails because KVM's view of things doesn't match reality/hardware=
.

Btw, we finally figured out the reason some machines were just going
dark on kexec, with the new kernel being corrupted. It turns out the
GIC is still scribbling on the vLPI Pending Table even after it isn't
the vLPI Pending Table any more, and is now part of the new kernel's
text.

In my queue I have a patch to call unmap_all_vpes() =E2=88=80 kvm on kexec,
which makes the problem go away.

--=-N2ILD2/GdREWZxl5A43d
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDYyMDE4MDAx
MlowLwYJKoZIhvcNAQkEMSIEIIyFvPcwbS1Vs7ZJA4/YgpmenZ12652b2+hXdccFnroEMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAM2H61fFbhMLR
OzqkJlEp279nrOR12jsAN4XKX9ZURyFfSWmeDqzu1Szt3hNdQolYyehVXNRDEzdKbluyBel9UeOS
xYeXsMHmdQ8FZ8FWkUAWWhb8xVRFmnzYm5aPNoZ4D4L9k29I3vaTnj9lsJ7kxg8eaVqxMA8Aqp6F
011xwwibujrG838ALsJRHFYYriHKUOKe8H6SC8akGmLItSMDN0j1N9ipYzO/xSH+KJF9YBmUAi1n
LJ/BeWTRGrfDIy6PIWLWcdhKROnFyUDCiU04huCRTe+/0LGRPxWizzwQbx5ufFqDqiOUCEaQzKqH
Wd/qYXwmoiomLYzRteVZ7I5FflxS9N1osg7jjHjdmEPSKE85N6U6D86kBFTy7emwDnJe805w058E
5wthOQACVxFbcyvL7MyRj5Ad5OUAz6cn6+ykrbBI6+QzmqoYO5M2M7IWyTyAPoA2ujcDFgrUn60O
bww4VICeFJlZRmv86VjJX7jLY+e9XA0JJXfW2VVPAHgceP9gmufL4Wos8DEPJ1VbL7A3bBx1ujKh
znPvB6MBNLEQBiFl1ONFlotGsz827BbupDhiHMlbop5L9d+ib6GkChz0iKo9TTIvZmjQH50maWAK
g2uAvxO7Frfd0NVzovfpsk///+zFHxhrOhygr3OQJVtfXB7juNO38jh0YbJAsi8AAAAAAAA=


--=-N2ILD2/GdREWZxl5A43d--

