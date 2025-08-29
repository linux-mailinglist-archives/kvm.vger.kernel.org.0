Return-Path: <kvm+bounces-56263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6187DB3B7B7
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 11:50:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CECFB56644C
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 09:50:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 421D130100A;
	Fri, 29 Aug 2025 09:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CDRLag2M"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4209427AC2E;
	Fri, 29 Aug 2025 09:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756461028; cv=none; b=Vh4wq/aOndQCP1yU4Hzgmeb7vv8f5f91PHsv/UXg+Vm1ejnZZ77GNCjjpvXcxyFp9v1PHbzw50pPiaXUFl76iZHKgsUMq8NbZDif3ShSpRiakQdLQUQi81iHxXGwwpwWVqT1ttBOZGdpNjElTD2it7Dd3EYORHREP2RI5KXdz3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756461028; c=relaxed/simple;
	bh=29BwbDgmgz6IMdpON0vP04aR0JcNHEBPLWUSlJw1PpE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uWQPdYLDFx2JlV9svluzY36hoITcgzFnm5uMtrQf8fca7LXKkPy4nV5x1cNz3DBy03OVjv+7TOKhVHs/Kv9knd7jii3sDCgO6ijjfQ7jAu3K7ZigDWxR/BTz0FvBmGH+ijmc7Ohw1U1jiGFnihNj+jSEbRu7gcZcHThkTrHPsTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CDRLag2M; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JC7N+qk69eSpLSnqgVCJ2jy4Ru9DZCdThLHI5XDq//Q=; b=CDRLag2MZrVNbgw/1PnfUpUn3w
	z1lI80IO0C4wm3/4a8ZOPYqqnhk4a995LqsDixt6BwhSQ/XRs97SdQgNfAeOh24B4kcF2NRhXkMaL
	T1DrdcJQApNIa1z8HsE2++kLiG3N8aKFDzH5ZNYMW/JyBbgCYDoi/at+QyzlHUjP+LI3UQC6XwlNE
	Qr3Q92avz3pv1zvvOF+XaUuL/0TzGES+E19ZYcmxkDCd4zGCmxzuOG2SbVN1W+StIbqP0TC8SKstu
	RsAjhI7Yv2+fQJG0dfvdfRPrAdbqDNTRsohheYzq7sKWasvbGwOlWlS5Vu5d5YDA5bKhlQD2bCYhs
	VYROFtrA==;
Received: from 54-240-197-239.amazon.com ([54.240.197.239] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1urvkA-00000009OwM-0UcQ;
	Fri, 29 Aug 2025 09:50:02 +0000
Message-ID: <ea0d7f43d910cee9600b254e303f468722fa355b.camel@infradead.org>
Subject: Re: [PATCH v2 0/3] Support "generic" CPUID timing leaf as KVM guest
 and host
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>, Paul Durrant
 <pdurrant@amazon.com>,  "Griffoul, Fred" <fgriffo@amazon.com>
Cc: Colin Percival <cperciva@tarsnap.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, graf@amazon.de, Ajay
 Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov
 <alexey.makhalov@broadcom.com>
Date: Fri, 29 Aug 2025 10:50:01 +0100
In-Reply-To: <aLDo3F3KKW0MzlcH@google.com>
References: <20250816101308.2594298-1-dwmw2@infradead.org>
	 <aKdIvHOKCQ14JlbM@google.com>
	 <933dc95ead067cf1b362f7b8c3ce9a72e31658d2.camel@infradead.org>
	 <aKdzH2b8ShTVeWhx@google.com>
	 <6783241f1bfadad8429f66c82a2f8810a74285a0.camel@infradead.org>
	 <aKeGBkv6ZjwM6V9T@google.com>
	 <fdcc635f13ddf5c6c2ce3d5376965c81ce4c1b70.camel@infradead.org>
	 <01000198cf7ec03e-dfc78632-42ee-480b-8b51-3446fbb555d1-000000@email.amazonses.com>
	 <aK4LamiDBhKb-Nm_@google.com>
	 <e6dd6de527d2eb92f4a2b4df0be593e2cf7a44d3.camel@infradead.org>
	 <aLDo3F3KKW0MzlcH@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-lKFlpOAc4HaLSopic2Hi"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-lKFlpOAc4HaLSopic2Hi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2025-08-28 at 16:40 -0700, Sean Christopherson wrote:
> On Wed, Aug 27, 2025, David Woodhouse wrote:
> > when there's an *existing* hypervisor leaf which just gives the informa=
tion
> > directly, which is implemented in QEMU and EC2, as well as various gues=
ts.
>=20
> Can we just have the VMM do the work then?=C2=A0 I.e. carve out the bit a=
nd the
> leaf in KVM's ABI, but leave it to the VMM to fill in?=C2=A0 I'd strongly=
 prefer not
> to hook kvm_cpuid(), as I don't like overriding userspace's CPUID entries=
, and
> I especially don't like that hooking kvm_cpuid() means the value can chan=
ge
> throughout the lifetime of the VM, at least in theory, but in practice wi=
ll only
> ever be checked by the guest during early boot.

The problem is that VMM doesn't know what TSC frequency the guest
actually gets. VMM only knows what it *asked* for, not what KVM
actually ended up configuring =E2=80=94 which depends on the capabilities o=
f
the hardware and the host's idea of what its actual TSC frequency is.

Hence https://git.kernel.org/torvalds/c/f422f853af036 in which we
allowed KVM to populate the value in the Xen TSC info CPUID leaves. I
was just following that precedent.

I am not *entirely* averse to ripping that out, and doing things
differently. We would have to:

 =E2=80=A2 Declare that exposing the TSC frequency to guests via CPUID is
   nonsense on crappy old hardware where it actually varies at runtime
   anyway. Partly because the guest will only check it at boot, and
   partly because that TSC has to be advertised as unreliable anyway.

 =E2=80=A2 Add a new API for the VMM to extract the actual effective freque=
ncy,
   only on 'sane' hosts.

 =E2=80=A2 Declare that we don't care that it's strictly an ABI change, and
   VMMs which used to just populate the leaf and let KVM fill it in
   for Xen guests now *have* to use the new API.

I'm actually OK with that, even the last one, because I've just noticed
that KVM is updating the *wrong* Xen leaf. 0x40000x03/2 EAX is supposed
to be the *host* TSC frequency, and the guest frequency is supposed to
be in 0x40000x03/0 ECX. And Linux as a Xen guest doesn't even use it
anyway, AFAICT.

Paul, it was your code originally; are you happy with removing it?


As we look at a new API for exposing the precise TSC scaling, I'd like
to make sure it works for VMClock (for which I am still working on
writing up proper documentation but in the meantime=20
https://gitlab.com/qemu-project/qemu/-/commit/3634039b93cc5 serves as a
decent reference). In short, VMClock allows the hypervisor to provide a
pvclock-style clock with microsecond accuracy to its guests, solving
the problems of
 =E2=80=A2 All guests using external precision clocks to repeat the *same* =
work
   of calibrating the *same* underlying oscillator
 =E2=80=A2 ...badly, experiencing imprecision due to steal time as they do =
so.
 =E2=80=A2 Live migration completely disrupting the clock and causing actua=
l
   data corruption, where precision timestamps are required for e.g.
   distributed database coherency.

In its initial implementation, the VMClock in QEMU (and EC2) only
resolves the last issue, by advertising a 'disruption' on live
migration so that the guest can know that its clock is hosed until it
manages to resync.

Now I'm trying to plumb in the actual clock information from the host,
so that migrated guests can have precision time from the moment they
arrive on the new host. There are two major use cases to consider...

1. Dedicated hosting setups will calibrate the host TSC *directly*
   against the external clock, and maybe feed it into the host kernel's
   adjtimex() almost as an afterthought. So userspace will be able to
   produce a system-wide VMClock data structure which can then be
   advertised to each guest with the appropriate TSC offset and scaling
   factor.

   For this I think we want the *actual* scaling factor to be exposed
   by KVM to userspace, not just the resulting estimated frequency.
   Unless we allow userspace just to provide the host's view and let
   KVM apply the offset/scale. Which maybe doesn't make as much sense
   in *this* setup but we might end up wanting that anyway for...

2. More traditional hosts just running Chrony/ntpd to feed the host's
   CLOCK_REALTIME with adjtimex(). For this case, there is probably
   more of an argument for letting the kernel generate the vmclock
   data =E2=80=94 KVM already has the gtod notifier which is invoked every =
time
   the apparent frequency changes, and userspace has none of what it
   needs.

So... if we need KVM to be able to apply the per-VM scaling/offset
because we're going to do it all in-kernel in that second case, then we
might as well let KVM apply the per-VM scaling/offset even in the
dedicated hosting case. And then the API we use for the original CPUID
problem only needs to expose the actual effective frequency.

But if we want userspace to do more for itself, we'd need to expose the
scaling factors directly. I think...




--=-lKFlpOAc4HaLSopic2Hi
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDgyOTA5NTAw
MVowLwYJKoZIhvcNAQkEMSIEINIKH+fUgILJiDapZwG4tkYCWpEulUO4VqfcaMzQKyGlMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIALx1Dwkpzx760
eCB3fssGhNQ6uKkNJRUsZDA+5w6ExBy3DfQbYpJtfE/QPxHByOxlWRq023wittTq48U6dmEJuVjJ
mz4+6DfDsOicOEyZ1bkFRn/IA3gRSckamKg6Y5a5/O9L6A8vmjjWeuJ6pNjg0n+H/NwNBho8Q+N7
TZjKznYvsgBSeWtxQsqRlrMHkcvNHcjFYk3B8pgDHF0XAFfJhd9YIvavouu556IEP+qB5J1jzyvT
LKrz2zluJwA6lIt/wru6/cnhyUdi9TPXT4XxftvEPeyOQ7v9Koyd+OAjIBzHl8ldaNIlHqItIGiq
/TmTFUS4fGlX4iwCc2zJ+pS7oAeOiSou4Xp7BThxwvPKZswTZ0h1gLN9twEgYzSyaIatM7pvP/Km
ZS+VOYKVuq+d6KmbsvbAaAHaX9YHgjF75j5jl1d0zjaWHuRXDitpLrBjbDFatXgimWs2fl8WcmPp
jqhOYHtBtgb3xRM3LhxAP2x4sikmeRs8OwDr37bCQ5iBAMF0Xqpp6CQc5oMddeuDdG+eIxGTEdLs
YZOTabz9gStA0w42Ge7imFDLYdkRoMJyNp41QbQQ06+Fsf37r/hmKG/+7kCTuBbJGcl2dCXwVq2n
QKLcBMT13huAuqe9vIUN06uEt+RLBGrF2+6vyf/2QfEVRcbF7dRHLsNgdXqdb5IAAAAAAAA=


--=-lKFlpOAc4HaLSopic2Hi--

