Return-Path: <kvm+bounces-58718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51449B9E1AA
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 10:45:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1BEE16AFA0
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 08:45:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8E52277026;
	Thu, 25 Sep 2025 08:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Xa2YNm5q"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6517025EF97
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 08:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758789902; cv=none; b=g0TrW9REC9YvE9gkHIp0Y1IHtGxxRAPh3hclHjW8or5g+rPEjGZFwiev7Pflyv5bhD+VP4HQ9n6EQOlcEQglSmjX+VmfR0/Sk8d5hG0d6O4OjuYQ7HigqCxW8yrtbLuwW0LfOTYEiW1euNapkyPpdL16VVwupkfymG++xUMeCbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758789902; c=relaxed/simple;
	bh=M9u8mUKPAfSDyBXsKc1oLFsIrFGjSYqd9GDM3NLoJFg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n3lUI/knXALuodJpUJK+F/ATEbFTWDfXJv81J/ZvDZHWZlNAMqmM8uzMfvUPcjuaPNjesFvq7N+HKA4iFdudE6yMh0YfHhaWoC8A2ZYkAa0UjFKoSi5nD/mnSIjh93tx100Bh0VfNbAR388eEuiaKTVhPPrbwvehxiC+tuGGIkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Xa2YNm5q; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M9u8mUKPAfSDyBXsKc1oLFsIrFGjSYqd9GDM3NLoJFg=; b=Xa2YNm5qEFdSwu7EBEEXgm74/F
	wFf4dqIbEnqbGZ1oE7lDjj+jyJaJ6b7ZDCSC1I7alkfGN8lVhMMm1f9bxneFTmXEu5fsAL27HX/0b
	puTVFJCda8zw/YwaqN+wZ+mn1JLJKZ1BlrOmbyYI3oz86/pLkHMNfM7UKeWWrbuqyvUzLdjcqGeKy
	95MZ3qN4lPH4iJdqmIEYx5C5qAfeUIuN1Axe65zR8qSxIWnN5f+YtQnZEhkOOaB4m/W/s2y1hZt6B
	lcSDfJIXnXH3Rg1557j1y0YsZCVHNxOdYwokoMzo6MeL7zskffUWpqtE9/Ro6HyaiUl5kWAoqUlKY
	liHnrzAQ==;
Received: from [172.31.31.148] (helo=u09cd745991455d.lumleys.internal)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v1hav-00000000GyT-2pV9;
	Thu, 25 Sep 2025 08:44:54 +0000
Message-ID: <acca55a49bad023fad30625fc81e19ef1c3d0ed8.camel@infradead.org>
Subject: Re: Should QEMU (accel=kvm) kvm-clock/guest_tsc stop counting
 during downtime blackout?
From: David Woodhouse <dwmw2@infradead.org>
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org
Date: Thu, 25 Sep 2025 09:44:54 +0100
In-Reply-To: <2cf13be8-cd27-4bfb-af8e-ef33286d633b@oracle.com>
References: <2d375ec3-a071-4ae3-b03a-05a823c48016@oracle.com>
	 <3d30b662b8cdb2d25d9b4c5bae98af1c45fac306.camel@infradead.org>
	 <1e9f9c64-af03-466b-8212-ce5c828aac6e@oracle.com>
	 <c1ceaa4e68b9264fc1c811c1ad0b60628d7fd9cd.camel@infradead.org>
	 <7d91b34c-36fe-44ee-8a2a-fb00eaebddd8@oracle.com>
	 <71b79d3819b5f5435b7bc7d8c451be0d276e02db.camel@infradead.org>
	 <bbadb98b-964c-4eaa-8826-441a28e08100@oracle.com>
	 <2e958c58d1d1f0107475b3d91f7a6f2a28da13de.camel@infradead.org>
	 <2cf13be8-cd27-4bfb-af8e-ef33286d633b@oracle.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-8mqoIiVtnlclBKnvEqXL"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-8mqoIiVtnlclBKnvEqXL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2025-09-24 at 13:53 -0700, Dongli Zhang wrote:
>=20
>=20
> On 9/23/25 10:47 AM, David Woodhouse wrote:
> > On Tue, 2025-09-23 at 10:25 -0700, Dongli Zhang wrote:
> > >=20
> > >=20
> > > On 9/23/25 9:26 AM, David Woodhouse wrote:
> > > > On Mon, 2025-09-22 at 12:37 -0700, Dongli Zhang wrote:
> > > > > On 9/22/25 11:16 AM, David Woodhouse wrote:
> > >=20
> > > [snip]
> > >=20
> > > > > >=20
> > > > > > >=20
> > > > > > > As demonstrated in my test, currently guest_tsc doesn't stop =
counting during
> > > > > > > blackout because of the lack of "MSR_IA32_TSC put" at
> > > > > > > kvmclock_vm_state_change(). Per my understanding, it is a bug=
 and we may need to
> > > > > > > fix it.
> > > > > > >=20
> > > > > > > BTW, kvmclock_vm_state_change() already utilizes KVM_SET_CLOC=
K to re-configure
> > > > > > > kvm-clock before continuing the guest VM.
> > > >=20
> > > > Yeah, right now it's probably just introducing errors for a stop/st=
art
> > > > of the VM.
> > >=20
> > > But that help can meet the expectation?
> > >=20
> > > Thanks to KVM_GET_CLOCK and KVM_SET_CLOCK, QEMU saves the clock with
> > > KVM_GET_CLOCK when the VM is stopped, and restores it with KVM_SET_CL=
OCK when
> > > the VM is continued.
> >=20
> > It saves the actual *value* of the clock. I would prefer to phrase that
> > as "it makes the clock jump backwards to the time at which the guest
> > was paused".
> >=20
> > > This ensures that the clock value itself does not change between stop=
 and cont.
> > >=20
> > > However, QEMU does not adjust the TSC offset via MSR_IA32_TSC during =
stop.
> > >=20
> > > As a result, when execution resumes, the guest TSC suddenly jumps for=
ward.
> >=20
> > Oh wow, that seems really broken. If we're going to make it experience
> > a time warp, we should at least be *consistent*.
> >=20
> > So a guest which uses the TSC for timekeeping should be mostly
> > unaffected by this and its wallclock should still be accurate. A guest
> > which uses the KVM clock will be hosed by it.
> >=20
> > I think we should fix this so that the KVM clock is unaffected too.
>=20
> From my understanding of your reply, the kvm-clock/tsc should always be a=
djusted
> whenever a QEMU VM is paused and then resumed (i.e. via stop/cont).

I think I agree, except I still hate the way you use the word
'adjusted'.

If I look at my clock, and then go to sleep for a while and look at the
clock again, nobody *adjusts* it. It just keeps running.

That's the effect we should always strive for, and that's how we should
think about it and talk about it.

It's difficult to talk about clocks because what does it mean for a
clock to be "unchanged"? Does it mean that it should return the same
time value? Or that it should continue to count consistently? I would
argue that we should *always* use language which assumes the latter.

Turning to physics for a clumsy analogy, it's about the frame of
reference. We're all on a moving train. I look at you in the seat
opposite me, I go to sleep for a while, and I wake up and you're still
there. Nobody has "adjusted" your position to accommodate for the
movement of the train while I was asleep.




> This applies to:
>=20
> - stop / cont
> - savevm / loadvm
> - live migration
> - cpr
>=20
> It is a bug if the clock jumps backwards to the time at which the guest w=
as paused.
>=20
> The time elapsed while the VM is paused should always be accounted for an=
d
> reflected in kvm-clock/tsc once the VM resumes.

In particular, in *all* but the live migration case, there should be
basically nothing to do. No addition, no subtraction. Only restoring
the *existing* relationships, precisely as they were before. That is
the TSC *offset* value, and the precise TSC=E2=86=92kvmclock parameters, al=
l
bitwise *exactly* the same as before.

And the only thing that changes on live migration is that you have to
set the TSC offset such that the guest sees the values it *would* have
seen on the original host at any given moment in time... and doesn't
know it was kidnapped and moved onto a different train while it was
sleeping...?


--=-8mqoIiVtnlclBKnvEqXL
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDkyNTA4NDQ1
NFowLwYJKoZIhvcNAQkEMSIEIEKtBt2X7UCgQuU8khW2B0XXnqZusCQvQhqrCuvG5Wv6MGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAkSKgPrDt3Uho
J3/C7bjVoW37s7hzTsnU3137pGib5qXp3tqadOlFQESr9IUnKu0pQKmN09gtiVOBkx2JPYz5d9PA
RXokQ6GycM1ZlgqrOtO9usiJUP3K9RR8aryHBxEtKGiXrkIzwHf3D6H/RoXj5pGXClwntkBUM1l6
3yKXj9pqApzEwURTmFn/sJsnPuwnR9BPi/T4qK22ML3OIrdfizlpzICOAS7HPLISNY+QEw2g+cQJ
ojp07dRwx/Uf+hTxLXVMJZxV2TIufiRHeQKRPj3CWBUKT7rG8XGp/I1Ht7SeQwnm8ZM5A4dnhtEj
rL771DudAckdJwGt0aS/iVRdfFQCEls8T/49rnMOuIzhuPOmFgHuC0qoDOaivjWkVJZ7GCP40y79
Vson2bZ1OVU9NRbu8MimpDbVPvfTIkMybnZujLqSKHvWNXBBC1LneTdcb6QaIkSXR8JfpIp+gPw4
k8kdGDnLqEdjprN/7v4CCtl5feRYAVN2cRzSQf+RjxicPY9kghgotq1kaTd7SblVBk7TGhu/I4qR
MXeE2MUESeva/XH0CowUt1+CPQ4+lk3Aak+3fBWUfsBGMcc3UFnrLyvFMf4KBMoqo1NTQu/tv2La
OYO+v0EYfNjX/etc/NS9BDY8ItZeszZral69MRXJYDYUqmg5/Gy9z4zl+A1dTgkAAAAAAAA=


--=-8mqoIiVtnlclBKnvEqXL--

