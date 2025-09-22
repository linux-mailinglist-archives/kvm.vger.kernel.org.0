Return-Path: <kvm+bounces-58403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E69C3B92953
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 20:16:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F1292A6749
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 18:16:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA6473164B7;
	Mon, 22 Sep 2025 18:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q9eVHc2/"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D753C2FB
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 18:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758564979; cv=none; b=AmdWfm5Oh8KNzx6D2koonPAaKfQ4PULDb9HEObLSBKD5vLmotknFKh3gF63dtRKY57rHTRRqapcZOauAjXRZ5M9cpGP6AdacCOk4ITlP4KX+HCV8WQ86bdDVZOgWWjzzvQz9DAonzlcdBSJXnCgFkxMFJgQ3c3tL47WrGXhmbUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758564979; c=relaxed/simple;
	bh=vjaSCFb4wopTZEYBFBvp7ybhvfpe7PkxfxDudRpCne0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=L9tPiAJwgw/TCUFi4GqpRTeuuLvG7Sv4zJ9RwYQjSQV5mOBnNQnxmgJr6SrgJUFppE6nrB63gxMmxKyb6Jx4jrzXS6R4CVnwfZ5b/fLIge6IN8Fe9NLjJ2sT5inP41Ib10bZnJ1leR7CBz6yE+AI4ldXF+BvOqHVBj+mKdcmeGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q9eVHc2/; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vjaSCFb4wopTZEYBFBvp7ybhvfpe7PkxfxDudRpCne0=; b=q9eVHc2/cfwKmu+Z+TqHRPKH4Z
	o9GrVkIVolqb13T9JYl6fT8yk+1fJrw5TFH5WQnCH2+JtpwTmGgO2gp22iz9KIpBryLamDxQ2G/UT
	8h/sDyFV3QObarx18zsP+txYbvLrwzga9hFSqh5NFVfjLhG3d871h5exOmr46C4MQCod12b9lV2Y9
	urfeQgBgepZxJshlrJQPRSu1XsINkJEi5PUPE3W3sGy9/LfsmmhEa1p3Ph/aVDVauExw1DeVR3NFJ
	zLfhFUjeEXJFzKC1+sgxVDImQHXI+Yezi1jrlOXHqs1Bjp32twkTE3Q1Co1u7CYn/xh6BOqRFTTMp
	V+aqUItA==;
Received: from 54-240-197-238.amazon.com ([54.240.197.238] helo=freeip.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v0l5B-0000000Clgy-3NIE;
	Mon, 22 Sep 2025 18:16:13 +0000
Message-ID: <c1ceaa4e68b9264fc1c811c1ad0b60628d7fd9cd.camel@infradead.org>
Subject: Re: Should QEMU (accel=kvm) kvm-clock/guest_tsc stop counting
 during downtime blackout?
From: David Woodhouse <dwmw2@infradead.org>
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org
Date: Mon, 22 Sep 2025 19:16:13 +0100
In-Reply-To: <1e9f9c64-af03-466b-8212-ce5c828aac6e@oracle.com>
References: <2d375ec3-a071-4ae3-b03a-05a823c48016@oracle.com>
	 <3d30b662b8cdb2d25d9b4c5bae98af1c45fac306.camel@infradead.org>
	 <1e9f9c64-af03-466b-8212-ce5c828aac6e@oracle.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-d6a1ovwCRfVpXUHmmCyS"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-d6a1ovwCRfVpXUHmmCyS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2025-09-22 at 10:31 -0700, Dongli Zhang wrote:
> Hi David,
>=20
> Thank you very much for quick reply!
>=20
> On 9/22/25 9:58 AM, David Woodhouse wrote:
> > On Mon, 2025-09-22 at 09:37 -0700, Dongli Zhang wrote:
> > > Hi,
> > >=20
> > > Would you mind helping confirm if kvm-clock/guest_tsc should stop cou=
nting
> > > elapsed time during downtime blackout?
> > >=20
> > > 1. guest_clock=3DT1, realtime=3DR1.
> > > 2. (qemu) stop
> > > 3. Wait for several seconds.
> > > 4. (qemu) cont
> > > 5. guest_clock=3DT2, realtime=3DR2.
> > >=20
> > > Should (T1 =3D=3D T2), or (R2 - R1 =3D=3D T2 - T1)?
> >=20
> > Neither.
> >=20
> > Realtime is something completely different and runs at a different rate
> > to the monotonic clock. In fact its rate compared to the monotonic
> > clock (and the TSC) is *variable* as NTP guides it.
> >=20
> > In your example of stopping and continuing on the *same* host, the
> > guest TSC *offset* from the host's TSC should remain the same.
> >=20
> > And the *precise* mathematical relationship that KVM advertises to the
> > guest as "how to turn a TSC value into nanoseconds since boot" should
> > also remain precisely the same.
>=20
> Does that mean:
>=20
> Regarding "stop/cont" scenario, both kvm-clock and guest_tsc value should=
 remain
> the same, i.e.,
>
> 1. When "stop", kvm-clock=3DK1, guest_tsc=3DT1.
> 2. Suppose many hours passed.
> 3. When "cont", guest VM should see kvm-clock=3D=3DK1 and guest_tsc=3D=3D=
T1, by
> refreshing both PVTI and tsc_offset at KVM.

Assuming a modern host where the TSC just counts sanely at a consistent
rate and never deviates....

No. The PVTI should basically *never* change. Whatever the estimated
(not NTP skewed) frequency of the TSC is believed to be, the KVM clock
PVTI should indicate that at boot, telling the guest how to convert a
TSC value into 'monotonic nanoseconds since boot'. If it ever changes,
that's a KVM bug.

It should be saved and restored in precisely its native form, using the
KVM_[GS]ET_CLOCK_GUEST I referenced before. For both live update (same
host) and live migration (different host).

The TSC should also continue to count at exactly the same rate as the
host's TSC at all times. No breaks or discontinuities due to any kind
of 'steal time'. For live update that's easy as you just apply the same
*offset*. For live migration that's where you have to accept that it
depends on clock synchronization between your source and destination
hosts, which is probably based on realtime.



>=20
> As demonstrated in my test, currently guest_tsc doesn't stop counting dur=
ing
> blackout because of the lack of "MSR_IA32_TSC put" at
> kvmclock_vm_state_change(). Per my understanding, it is a bug and we may =
need to
> fix it.
>=20
> BTW, kvmclock_vm_state_change() already utilizes KVM_SET_CLOCK to re-conf=
igure
> kvm-clock before continuing the guest VM.
>=20
> >=20
> > KVM already lets you restore the TSC correctly. To restore KVM clock
> > correctly, you want something like KVM_SET_CLOCK_GUEST from
> > https://lore.kernel.org/all/20240522001817.619072-4-dwmw2@infradead.org=
/
> >=20
> > For cross machine migration, you *do* need to use a realtime clock
> > reference as that's the best you have (make sure you use TAI not UTC
> > and don't get affected by leap seconds or smearing). Use that to
> > restore the *TSC* as well as you can to make it appear to have kept
> > running consistently. And then KVM_SET_CLOCK_GUEST just as you would on
> > the same host.
>=20
> Indeed QEMU Live Migration also relies on kvmclock_vm_state_change() to
> temporarily stop/cont the source/target VM.
>=20
> Would you mean we expect something different for live migration, i.e.,
>=20
> 1. Live Migrate a source VM to a file.
> 2. Copy the file to another server.
> 3. Wait for 1 hour.
> 4. Migrate from the file to target VM.
>=20
> Although it is equivalent to a one-hour downtime, we do need to count the
> missing one-hour, correct?

I don't look at it as counting anything. The clock keeps running even
when I'm not looking at it. If I wake up and look at it again, there is
no 'counting' how long I was asleep...


--=-d6a1ovwCRfVpXUHmmCyS
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDkyMjE4MTYx
M1owLwYJKoZIhvcNAQkEMSIEIDbYuLhBh/0cCceHkt/sn8urFin2WCIa7gcQmzFNW5oqMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAzLJmfwh9v1tJ
3oPST1gcEjHCzzFFNItq+s4RHOfxYTyKs+gGs5MfwyeRm40bgVGLp+OJg9oIypYagoJBybnnRJsN
T6A0ZiQaXBr7FNArVK2tkOzqhmGcHPf0YaQOBcQK3nbAJ8iVcEiS7dtc5tKJXHtqvFx/V8G54ZeG
XRAuVclETJtFC9cRxHArYvojIYPHgM72sLtkr6lJBXd4QSDGcM/se5fAgwEAG7YLMe7NAUsX837V
pvPBUSnSs4GIBJZoHAsGHnVBH6bIsV+Rgzf8VB4DWcNXxj6rcWr1Vha3Xalp9lvH052sNK9E0u3c
LYeknK0JVyqnbyzo4OBitxYpjvvF7+6xxV5RetPWDg7oC/SjPNSXh9EO1ON8PWFmV0G7TrcILp5R
8nO5bM+gy/na8LD2aOah1tBRg+sDbLAaul3Idgbwk8/HSyn8Qf7Vf331YipIwskrDxFgX6yOImyx
QcVYyTMl0mmW6t3WjBZT5V0f2SZMYRZPwJiIsLgXrYECiIU/U0Jy8bji877tbstpS0r6u0DHVOYN
dphYDR2fwAfA4861dt1vhgYhfFHZpsBTQifhI6KFlFYUmzVpJICABodtjk6EVd/JB3Z86OPIFzdR
a5we2NLCjWocz8NgkYy6J6vWnNctVfzmfDgemeKSn294/PXk5i2vOu3HdW4xVZwAAAAAAAA=


--=-d6a1ovwCRfVpXUHmmCyS--

