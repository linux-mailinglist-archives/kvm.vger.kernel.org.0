Return-Path: <kvm+bounces-58590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF231B97162
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 19:47:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C715C1882959
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 17:48:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5D6D283FE5;
	Tue, 23 Sep 2025 17:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D8PdYTLr"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA16D189
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 17:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758649662; cv=none; b=NBaC+0mz5w4h0hRfBhQOgLjrt0pIoEopSALWBqWMzofS3KUqkJgr/QueOPG/0lEGh3tHaDz46cSYDIRN+0lsQkxhe3dTe1P++1+Ut08kl88vF4vqD+W3RjXTZx9frACUM5Q/LA2Vr1S4wGeFYI3lajS6/jmQ2am08M4ZBHrgB7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758649662; c=relaxed/simple;
	bh=el/r33LCTx8sq3IjgLlIJQ0Sy62EXbhAmHMnx1vTPdI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Iew80Huqoq/4q+hjhV4rsU0cgUEDUQ9oHjQcPyZhUF88uxrBfzUOQY/dyYu00/gANvzyavd9TnaoB+dRx/retQFpxNLYqVODNUgqKLzB0J7z6cUFPwe1RClYYj8bvvrenr6zRbDYPayzTEsDJcudT5HRp+l7lgD6OHaxs44yzfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D8PdYTLr; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=el/r33LCTx8sq3IjgLlIJQ0Sy62EXbhAmHMnx1vTPdI=; b=D8PdYTLrY0UZVX6jWze71dhTza
	ad7a0t0wjwV3/bIf6pCrsUc3ihSpgRx45/x0NXOEP8F7PJ8s8uRJLnf8eBWGcThSU8nSDnaR2IqUW
	ogdxPVPulws6zFDfUTqboVhWEhtcZZmGah7E/7QSOFGySRUGc5f2CPzbb5VMawQxuwNUxkewzSWAe
	RNgRiDd5kDJZhJ0qdEjwGpxneBKdgst/MFuWwDpFFaRl4Nxg5Tcul/t1CYgepux0wAc7FgSGQH1Y2
	1b747PUaJSyO/TisoVFsk+sj0MO2sSOPwwIzrr8UmHxK4fIpa7PQST4jrsZlo55x4bGpzv41C/9A+
	9ub1iMnQ==;
Received: from [54.239.6.190] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v1772-0000000GSUd-0hAm;
	Tue, 23 Sep 2025 17:47:36 +0000
Message-ID: <2e958c58d1d1f0107475b3d91f7a6f2a28da13de.camel@infradead.org>
Subject: Re: Should QEMU (accel=kvm) kvm-clock/guest_tsc stop counting
 during downtime blackout?
From: David Woodhouse <dwmw2@infradead.org>
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org
Date: Tue, 23 Sep 2025 18:47:35 +0100
In-Reply-To: <bbadb98b-964c-4eaa-8826-441a28e08100@oracle.com>
References: <2d375ec3-a071-4ae3-b03a-05a823c48016@oracle.com>
	 <3d30b662b8cdb2d25d9b4c5bae98af1c45fac306.camel@infradead.org>
	 <1e9f9c64-af03-466b-8212-ce5c828aac6e@oracle.com>
	 <c1ceaa4e68b9264fc1c811c1ad0b60628d7fd9cd.camel@infradead.org>
	 <7d91b34c-36fe-44ee-8a2a-fb00eaebddd8@oracle.com>
	 <71b79d3819b5f5435b7bc7d8c451be0d276e02db.camel@infradead.org>
	 <bbadb98b-964c-4eaa-8826-441a28e08100@oracle.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-4sxJyxtKia8vBAt4pR9G"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-4sxJyxtKia8vBAt4pR9G
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2025-09-23 at 10:25 -0700, Dongli Zhang wrote:
>=20
>=20
> On 9/23/25 9:26 AM, David Woodhouse wrote:
> > On Mon, 2025-09-22 at 12:37 -0700, Dongli Zhang wrote:
> > > On 9/22/25 11:16 AM, David Woodhouse wrote:
>=20
> [snip]
>=20
> > > >=20
> > > > >=20
> > > > > As demonstrated in my test, currently guest_tsc doesn't stop coun=
ting during
> > > > > blackout because of the lack of "MSR_IA32_TSC put" at
> > > > > kvmclock_vm_state_change(). Per my understanding, it is a bug and=
 we may need to
> > > > > fix it.
> > > > >=20
> > > > > BTW, kvmclock_vm_state_change() already utilizes KVM_SET_CLOCK to=
 re-configure
> > > > > kvm-clock before continuing the guest VM.
> >=20
> > Yeah, right now it's probably just introducing errors for a stop/start
> > of the VM.
>=20
> But that help can meet the expectation?
>=20
> Thanks to KVM_GET_CLOCK and KVM_SET_CLOCK, QEMU saves the clock with
> KVM_GET_CLOCK when the VM is stopped, and restores it with KVM_SET_CLOCK =
when
> the VM is continued.

It saves the actual *value* of the clock. I would prefer to phrase that
as "it makes the clock jump backwards to the time at which the guest
was paused".

> This ensures that the clock value itself does not change between stop and=
 cont.
>=20
> However, QEMU does not adjust the TSC offset via MSR_IA32_TSC during stop=
.
>=20
> As a result, when execution resumes, the guest TSC suddenly jumps forward=
.

Oh wow, that seems really broken. If we're going to make it experience
a time warp, we should at least be *consistent*.

So a guest which uses the TSC for timekeeping should be mostly
unaffected by this and its wallclock should still be accurate. A guest
which uses the KVM clock will be hosed by it.

I think we should fix this so that the KVM clock is unaffected too.

> >=20
> > > > > >=20
> > > > > > KVM already lets you restore the TSC correctly. To restore KVM =
clock
> > > > > > correctly, you want something like KVM_SET_CLOCK_GUEST from
> > > > > > https://lore.kernel.org/all/20240522001817.619072-4-dwmw2@infra=
dead.org/
> > > > > >=20
> > > > > > For cross machine migration, you *do* need to use a realtime cl=
ock
> > > > > > reference as that's the best you have (make sure you use TAI no=
t UTC
> > > > > > and don't get affected by leap seconds or smearing). Use that t=
o
> > > > > > restore the *TSC* as well as you can to make it appear to have =
kept
> > > > > > running consistently. And then KVM_SET_CLOCK_GUEST just as you =
would on
> > > > > > the same host.
> > > > >=20
> > > > > Indeed QEMU Live Migration also relies on kvmclock_vm_state_chang=
e() to
> > > > > temporarily stop/cont the source/target VM.
> > > > >=20
> > > > > Would you mean we expect something different for live migration, =
i.e.,
> > > > >=20
> > > > > 1. Live Migrate a source VM to a file.
> > > > > 2. Copy the file to another server.
> > > > > 3. Wait for 1 hour.
> > > > > 4. Migrate from the file to target VM.
> > > > >=20
> > > > > Although it is equivalent to a one-hour downtime, we do need to c=
ount the
> > > > > missing one-hour, correct?
> > > >=20
> > > > I don't look at it as counting anything. The clock keeps running ev=
en
> > > > when I'm not looking at it. If I wake up and look at it again, ther=
e is
> > > > no 'counting' how long I was asleep...
> > > >=20
> > >=20
> > > That means:
> > >=20
> > > - stop/cont: clock/tsc stop running
> > > - savevm/loadvm: clock/tsc stop running
> >=20
> > What does "stop running" even mean here? You can never stop the clock
> > running. The only thing you can do is change its offset so that it
> > jumps back to an earlier value, when you resume a VM?
> >=20
>=20
> Yes, I meant "change its offset so that it jumps back to an earlier value=
." From
> the VM's perspective, this is equivalent to "the clock was stopped."

Yeah... let's stop doing that :)

> Could you help explain why we treat stop/cont differently from live migra=
tion?

We shouldn't. Hardware companies spent *years* learning the lesson
about clocks. That they should just keep counting. At the same rate.
Unconditionally. Even if the CPU is running slower. Or stopped. Or
whatever. Just count. Do not stop counting.

Let's not repeat the same mistakes.


--=-4sxJyxtKia8vBAt4pR9G
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDkyMzE3NDcz
NVowLwYJKoZIhvcNAQkEMSIEIPT/yN9qWpDoc23fiMumgphCig+mgGsiYUwsbRlPlgOlMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAYxekUz1b6YKp
VA2fdnHtazX/OlO3Xx9ediG5IA7SjgETHFIqi1MHyVETq5iJYx6qUfihSdMvzjoQ0wlauYr9BKk7
fALCLjis2sU2Ff8zqARqb926dGOWTqImpD0gC2ayW234RXcFtsfJGpO+l8xbJiMLxlEUoCcw5s00
h7ODrx4K8LK1B3IKUVGcbc5hijexhplYPyYZT0mP8L8DHyibU+bJ/Wd30De6KFh5eUbVHvZFtzZq
xFZ+Ip9SPw5V/f+CvpEGRouVdg7LtqEYd3XWkXL6vVaIu6E2wBL2jNZzZG3OyQF4w3WTiHZ0ZpH2
ZJyVXnnwJfq5gFfF131SCv7inb4DFQxTDasPOmIPauhCM70DgsodrcxgYgOphL7ehP9kuu1jh7OL
jwLsE79d87hHzA/FmVAssc5cG6J9zHXfuF0k2PRgGJzNzHREPSoeCVNtBdtrDAs8uaJ46vB3gGIM
F+z9kkHpkLfz2Q/ozXVzuet55U+HPI1XakG+ofQou+KB24IYFME72BpZUYMm4MxD7hvucC8IsBEC
xzkvJiWND/DjFjiZi5c6izCsSkf3/4Wc8gc2nWmnANccpXYGS59lMQ8FjAGHkXxZKgmNbElLsi4f
Ahl6p3I/MZN3OjIxVPq8Wouq2Dh/PqquthHWCJiAuAqRwKVtJgVqti8eI1sp8lwAAAAAAAA=


--=-4sxJyxtKia8vBAt4pR9G--

