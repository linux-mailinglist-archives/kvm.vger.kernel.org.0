Return-Path: <kvm+bounces-56829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 61E96B43DB7
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 15:51:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 154D217EB0D
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 13:51:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A71D2FE05D;
	Thu,  4 Sep 2025 13:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LIqZfI7S"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026902D3737;
	Thu,  4 Sep 2025 13:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756993889; cv=none; b=QlRvcDny2xCcRQfFpO8LJFz1j0It7TNn1daR0nutTDdil1QSk+QJiXM0cjX7MRCQg+H7dBxDLhEMFELcBCw0vOWk/Jdyw4X7k2vNa8FE7P1ZlH2+Ok18JdrtNcMOnAKD0zWA9j76yU+O2VyuuuEQFXzpoAMDqVrKRWNwa3oQBV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756993889; c=relaxed/simple;
	bh=Zxi7C0ATY6BymQmWMzDZHYf/g9plOrlZxzoD8NFYFSA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ly3ITy4am5igCY6VoYlFghMilm/mwI55zf+d4OjB2M2r30Uux3a+pI4AVnGhaMSkYEikZJ4+cWZsL3Y/pFgjKPPhmxSp1coGRDTpFvZauciAweFaq+CYs7F34TiiCHE9ntbOQv5d42fa5/7GfIEVhdXPZxTq0BzOeSCNONMBK9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LIqZfI7S; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Zxi7C0ATY6BymQmWMzDZHYf/g9plOrlZxzoD8NFYFSA=; b=LIqZfI7S6HUyRou7ocFksuSxLo
	gQHIcNFJzU3Fv3nm8CFCkAl24+gTyauOOJji02DKZroPFgbz5aASztx31I/oo5Q5lNBqDrvoOIvc/
	QHU4h6wtSL86quCqNM0Jtn/FhcIZKZDnoewnC7SpdK2YLU9mcq6ryHC8Qa90bEppPIThqEBDi2xVi
	NCkGPz5Aqt6waz1yWGeFCKlH1jmPvJCqrnr1iyM0LEHsUTN9+K1P6CijKL6P6Z12I6DNNrF62HBDp
	cZw/iLVU2814yXtQjJhEp27OLTv7wynbKca7nbQi9aDwUVYO0dbD284jw2uWlYcljz5hifdnMs/DF
	oV0kHo5Q==;
Received: from [54.239.6.190] (helo=freeip.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uuAMw-00000001mCX-2WsD;
	Thu, 04 Sep 2025 13:51:19 +0000
Message-ID: <62d1231571c44b166a18181d724b32da33b38efb.camel@infradead.org>
Subject: Re: [PATCH v2 0/3] Support "generic" CPUID timing leaf as KVM guest
 and host
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paul Durrant <pdurrant@amazon.co.uk>, Fred Griffoul
 <fgriffo@amazon.co.uk>,  Colin Percival <cperciva@tarsnap.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,  Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>,  "x86@kernel.org" <x86@kernel.org>, "H.
 Peter Anvin" <hpa@zytor.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Graf (AWS),
 Alexander" <graf@amazon.de>,  Ajay Kaher <ajay.kaher@broadcom.com>, Alexey
 Makhalov <alexey.makhalov@broadcom.com>
Date: Thu, 04 Sep 2025 15:51:15 +0200
In-Reply-To: <aLmTXb6PO02idqeM@google.com>
References: <aLDo3F3KKW0MzlcH@google.com>
	 <ea0d7f43d910cee9600b254e303f468722fa355b.camel@infradead.org>
	 <54BCC060-1C9B-4BE4-8057-0161E816A9A3@amazon.co.uk>
	 <caf7b1ea18eb25e817af5ea907b2f6ea31ecc3e1.camel@infradead.org>
	 <aLIPPxLt0acZJxYF@google.com>
	 <d74ff3c1c70f815a10b8743647008bd4081e7625.camel@infradead.org>
	 <aLcuHHfxOlaF5htL@google.com>
	 <3268e953e14004d1786bf07c76ae52d98d0f8259.camel@infradead.org>
	 <aLl_MAk9AT5hRuoS@google.com>
	 <4a3be390fe559de0bd5c61d24853d88f96a6ab6a.camel@infradead.org>
	 <aLmTXb6PO02idqeM@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-p38hJC7PSPu2oUUCdDqX"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-p38hJC7PSPu2oUUCdDqX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2025-09-04 at 06:25 -0700, Sean Christopherson wrote:
> On Thu, Sep 04, 2025, David Woodhouse wrote:
> > On Thu, 2025-09-04 at 04:59 -0700, Sean Christopherson wrote:
> > >=20
> > > I thought the original problem being solved was that the _guest_ does=
n't know the
> > > effective TSC frequency?=C2=A0 Userspace can already get the effectiv=
ely TSC frequency
> > > via KVM_GET_TSC_KHZ, why do we need another uAPI to provide that?=C2=
=A0 (Honest question,
> > > I feel like I'm missing something)
> >=20
> > I believe that KVM_GET_TSC_KHZ returns what userspace *asked* for the
> > TSC frequency to be (vcpu->arch.virtual_tsc_khz), not what it actually
> > ended up being based on the measured host frequency and the available
> > scaling granularity (vcpu->hw_tsc_khz).
>=20
> Ah, I see where you're coming from.=C2=A0 Purely out of curiosity, have y=
ou done the
> math to see if slop would be a problem in practice?=C2=A0 No worries if y=
ou haven't,
> just genuinely (and lazily) curious.

It's in the single-digit MHz range generally. Probably not a problem in
practice since the TSC varies with environmental conditions *anyway*
and needs to be refined with NTP/etc.

I'm more interested in getting the scaling information exactly right
for the VMClock case, where we expose microsecond-precision time to the
guest in terms of the TSC.

> Anyways, I'm a-ok reporting that information in KVM_GET_SUPPORTED_CPUID (=
again,
> only with constant TSC and scaling).=C2=A0 Reporting the effective freque=
ncy would be
> useful for the host too, e.g. for sanity checks.=C2=A0 What I specificall=
y want to
> avoid is modifying guest CPUID at runtime.

Hm, in some cases I thought KVM had deliberately moved *to* doing CPUID
updates at runtime, so that its doesn't have to exempt the changable
leaves from the sanity checks which prevent userspace from updating
CPUID for a CPU which has already been run.

It's not just the existing Xen TSC leaf which is updated at runtime in
kvm_cpuid().

But I don't mind too much. If we give userspace a way to *know* the
effective frequency, I'm OK with requiring that userspace do so and
populate the corresponding CPUID leaves for itself, for Xen and KVM
alike. We'd need to expose the FSB frequency too, not just TSC.

I was only going with the runtime update because we are literally
already *doing* it this way in KVM.

> Hmm, the only wrinkle is that, if there is slop, KVM could report differe=
nt
> information when run on different platforms, e.g. after live migration.=
=C2=A0 But so
> long as that possibility is documented, I don't think it's truly problema=
tic.
> And it's another argument for not modifying guest CPUID directly; I'd rat=
her let
> userspace figure out whether or not they care about the divergence than s=
ilently
> change things from the guest's perspective.
>=20
> Alternatively (or in addition to), part of me wants to stealtily update
> KVM_GET_TSC_KHZ to report back the effective frequency, but I can see tha=
t being
> problematic, e.g. if a naive VMM reads KVM_GET_TSC_KHZ when saving vCPU s=
tate for
> live migration and after enough migrations, the slop ends up drastically =
skewing
> the guest's frequency.

Indeed. And I also want to tell userspace the precise *ratio* being
applied by hardware scaling, for the VMClock case where userspace
definitely knows *better* about what the host TSC frequency is at this
precise moment, and has to tell the guest what *its* TSC frequency is,
with the same precision.

--=-p38hJC7PSPu2oUUCdDqX
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDkwNDEzNTEx
NVowLwYJKoZIhvcNAQkEMSIEIJajcMxdfB7hQHc2+x8N3FhAUwetZ8T5LAIBL3wpGWiGMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAyXMFTfCVE44y
1HVF/kVqWfO1WtUQN8nZ06D3l6JhWCMVhD/YMQ8FV2WOKCrxxFZSfulZ7kr3tfX0QgJ/CK/P7Mky
uZskV7/TGM3yIQ2YaQSstiUMl2EVXBfIHvR4+OVgJDxtsJJ/mcKfNT2b71epuwHwuMAP2DuNNkpM
gPYr/M/amFC0S4qulo8CzapFxWP8YCVTvBH/J78dRST7Q2TfqmCcNC2IQ7jF0bLIT/EnADTYOmEP
8t5ObizrXfT3dppfRREBttK84luemhWhTm47FE+jU5zhf80oEMcOyrf9+2pBvqpKsR7aDXva8mwG
mi0HomFP9NPzR8ZqASrEBPVFfw4ClYBiJfrMVB3TiIYGaFEU2zkj0cJwV4mlagteJAO1E9+SMLqS
gp1FQ+9JZeP8V4Kv3f8zEmEIqxSLdfIE8jDOTM2MMEyptZn2sh6qhJkK73KuZQ6OknoxDh06dU14
hEwGPsJQmhH5AK613yXtYM9iATc0sMogKj0HVZeaCs3n0HFqqEcYIg4QcC2EMG2Ya299PHwzd1+9
xib1bcPjze7cxlDHjSJbakQcp5RmmY2LxN8Q/3aZ8zAQAFTMviVYcx9q70dGMLeU8ObpjeOuAqNV
lmcpUcNmKd8YA7W1XpGdpoSnB2SBO2xnVYVRFQ7Xg5b5+sNBXs7/cS3zr5Ans3EAAAAAAAA=


--=-p38hJC7PSPu2oUUCdDqX--

