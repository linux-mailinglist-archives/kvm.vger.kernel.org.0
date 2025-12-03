Return-Path: <kvm+bounces-65227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 158E5CA058C
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 18:20:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 275D73281CBF
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 17:06:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDDAD357A43;
	Wed,  3 Dec 2025 16:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BOygVmMn"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7851035772A
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 16:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779753; cv=none; b=gI4BxbjMaBWksrwcZ7VzuKzh/mD8I7pyN6Rwhx3/DFVlRmhfbLrTClPmP/RsXmSBPHeQRmYH2dMz6c2iZxyekODazFaicJ11rsqRpMFqTm66+1wqsqGWtTELLrpd3EtqpI/43Vi+o8B+tayRpoIUbndvYm19mQBFBQ9mlpuI2oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779753; c=relaxed/simple;
	bh=LLhpC28SXmi+NalNLofeVxm0yN/BI/eqb2ZIDUpweZg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Hjr+weG3qC9qKC96lF23unBzh5kmpUa6OSW/ndN2cpSGkAaqcoyaWA00h1EQVLYG5hruR/XoG/jUKkvU9QmdVitaeYWxnNIW5cwBwTZfKql31+HABSEpYqkelrGKoJCDwbG1ShcRn5bPgQsoa/ijTvbk6YxUp+plvyhP8XQfjyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BOygVmMn; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LLhpC28SXmi+NalNLofeVxm0yN/BI/eqb2ZIDUpweZg=; b=BOygVmMni5ZSE3IelFKh/1yfBa
	4zcLUSggjpN/c0zk81AgBgn8y7o5w6bxV4t/3InV2TD+CIcwGtMXOH1HcwMWfpDHeDW2rGMHINqty
	tJZBj3TgCPWy6LufwUULW+OOynNvEIVLIh+Kyw6R/4n6d0nQfVTGvRMYqp6XngrZ3TCL8TBdAG46w
	GP+vGoDF8CA+vpWEUTdPLAkWdRxQqDa4kuMK9+UAtYATXmZFuofC3MQx1ywgAysClApsaMUveaJ0b
	ii02F89fN+sGB0Y6s+1TAsypE3ZNovbcTUBbbh5uPhLwJKOpVJ7HlokWmdE6JCx+e1JvBlNliRPzp
	blLNZDfw==;
Received: from [172.31.31.148] (helo=u09cd745991455d.lumleys.internal)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQoxt-00000002Wq7-21I8;
	Wed, 03 Dec 2025 15:40:25 +0000
Message-ID: <a07a6edf549cfed840c9ead3db61978c951b15e4.camel@infradead.org>
Subject: Re: [RFC PATCH 0/2] KVM: pfncache: Support guest_memfd without
 direct map
From: David Woodhouse <dwmw2@infradead.org>
To: Brendan Jackman <jackmanb@google.com>, Takahiro Itazuri
 <itazur@amazon.com>,  kvm@vger.kernel.org, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov
	 <vkuznets@redhat.com>, Fuad Tabba <tabba@google.com>, David Hildenbrand
	 <david@kernel.org>, Paul Durrant <pdurrant@amazon.com>, Nikita Kalyazin
	 <kalyazin@amazon.com>, Patrick Roy <patrick.roy@campus.lmu.de>, Takahiro
 Itazuri <zulinx86@gmail.com>
Date: Wed, 03 Dec 2025 16:35:45 +0000
In-Reply-To: <DEOPHISOX8MK.2YEMZ8XKLQGMC@google.com>
References: <20251203144159.6131-1-itazur@amazon.com>
	 <DEOPHISOX8MK.2YEMZ8XKLQGMC@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-AUP9HmdhBUAZ/Cd9yatg"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html


--=-AUP9HmdhBUAZ/Cd9yatg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2025-12-03 at 16:01 +0000, Brendan Jackman wrote:
> On Wed Dec 3, 2025 at 2:41 PM UTC, Takahiro Itazuri wrote:
> > [ based on kvm/next with [1] ]
> >=20
> > Recent work on guest_memfd [1] is introducing support for removing gues=
t
> > memory from the kernel direct map (Note that this work has not yet been
> > merged, which is why this patch series is labelled RFC). The feature is
> > useful for non-CoCo VMs to prevent the host kernel from accidentally or
> > speculatively accessing guest memory as a general safety improvement.
> > Pages for guest_memfd created with GUEST_MEMFD_FLAG_NO_DIRECT_MAP have
> > their direct-map PTEs explicitly disabled, and thus cannot rely on the
> > direct map.
> >=20
> > This breaks the features that use gfn_to_pfn_cache, including kvm-clock=
.
> > gfn_to_pfn_cache caches the pfn and kernel host virtual address (khva)
> > for a given gfn so that KVM can repeatedly access the corresponding
> > guest page.=C2=A0 The cached khva may later be dereferenced from atomic
> > contexts in some cases.=C2=A0 Such contexts cannot tolerate sleep or pa=
ge
> > faults, and therefore cannot use the userspace mapping (uhva), as those
> > mappings may fault at any time.=C2=A0 As a result, gfn_to_pfn_cache req=
uires
> > a stable, fault-free kernel virtual address for the backing pages,
> > independent of the userspace mapping.
> >=20
> > This small patch series enables gfn_to_pfn_cache to work correctly when
> > a memslot is backed by guest_memfd with GUEST_MEMFD_FLAG_NO_DIRECT_MAP.
> > The first patch teaches gfn_to_pfn_cache to obtain pfn for guest_memfd-
> > backed memslots via kvm_gmem_get_pfn() instead of GUP (hva_to_pfn()).
> > The second patch makes gfn_to_pfn_cache use vmap()/vunmap() to create a
> > fault-free kernel address for such pages.=C2=A0 We believe that establi=
shing
> > such mapping for paravirtual guest/host communication is acceptable as
> > such pages do not contain sensitive data.
> >=20
> > Another considered idea was to use memremap() instead of vmap(), since
> > gpc_map() already falls back to memremap() if pfn_valid() is false.
> > However, vmap() was chosen for the following reason.=C2=A0 memremap() w=
ith
> > MEMREMAP_WB first attempts to use the direct map via try_ram_remap(),
> > and then falls back to arch_memremap_wb(), which explicitly refuses to
> > map system RAM.=C2=A0 It would be possible to relax this restriction, b=
ut the
> > side effects are unclear because memremap() is widely used throughout
> > the kernel.=C2=A0 Changing memremap() to support system RAM without the
> > direct map solely for gfn_to_pfn_cache feels disproportionate.=C2=A0 If
> > additional users appear that need to map system RAM without the direct
> > map, revisiting and generalizing memremap() might make sense.=C2=A0 For=
 now,
> > vmap()/vunmap() provides a contained and predictable solution.
> >=20
> > A possible approach in the future is to use the "ephmap" (or proclocal)
> > proposed in [2], but it is not yet clear when that work will be merged.
>=20
> (Nobody knows how to pronounce "ephmap" aloud and when you do know how
> to say it, it sounds like you are sayhing "fmap" which is very
> confusing. So next time I post it I plan to call it "mermap" instead:
> EPHemeral -> epheMERal).
>=20
> Apologies for my ignorance of the context here, I may be missing
> insights that are obvious, but with that caveat...
>=20
> The point of the mermap (formerly "ephmap") is to be able to efficiently
> map on demand then immediately unmap without the cost of a TLB
> shootdown. Is there any reason we'd need to do that here? If we can get
> away with a stable vmapping then that seems superior to the mermap
> anyway.
>=20
> Putting it in an mm-local region would be nice (you say there shouldn't
> be sensitive data in there, but I guess there's still some potential for
> risk? Bounding that to the VMM process seems like a good idea to me)
> but that seems nonblocking, could easily be added later. Also note it
> doesn't depend on mermap, we could just have an mm-local region of the
> vmalloc area. Mermap requires mm-local but not the other-way around.

Right. It's really the mm-local part which we might want to support in
the gfn_to_pfn_cache, not ephmap/mermap per se.

As things stand, we're taking guest pages which were taken out of the
global directmap for a *reason*... and mapping them right back in
globally. Making the new mapping of those pages mm-local where possible
is going to be very desirable.

--=-AUP9HmdhBUAZ/Cd9yatg
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MTIwMzE2MzU0
NVowLwYJKoZIhvcNAQkEMSIEIGyNwuCzyMBew0epWkgGZEIOSwK4BhTuHc4RGeP1tt+XMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAm5+Wxdu4WQNt
B7oomDzCrnwtt8Ijojg2KwDjNFzPuoScOLDo/PO1QRXCFQoK8X3xREK6OykCAKqnfj8IrzD93cJ2
Wer+NOAADzt0ksheJl58bVHxwC6Xd4pybEBpkrtByfr8KBIaAt8HZCOR+lU8vdStD+W6NezusNWm
b4rd+hqVohUSDzzGu69yNHEbUE33qyfw5ulYmMe/4zn3SkjfB0+2NYkdi98uPDMyqbv1WqW3/J/m
jE5CimAhkIeIQZssHm1b1k07fQRb1hLEhL6qRfoPuKbrVOKaYuO/8HdkbXRgW/QvD78jRRhXX2J0
OZh5TzzFm1bgoOh1lRPNW8LVgMRNaNxssjr6ThUctO5PZlmendfAFeK7H6nb7bBq9RJNjkotSXFW
lS3Qeq2blFEqPmUHsWXB4d90lFtQWR9550/2YDyUnzkib1j/UINSHNOhOXCQ04yiT1qQo6TSPXUx
A8HU/7jBVlsJiwV9xuApWZr7OztaR5mb5a8CZO2hmxiMEdxpovEVupjx9LWMiiTujZde2AKeQJLu
TaXo+wA0VWd4A+jmqtSunO3jmeaoP6iesZ2UXsztf/RNoxNjumfcJJNspQySGVZI0ecLVnTZwrcM
xrE7U0ZYc5SALKbFb38M4dwMj/4QXfYoHl+nxsYQmX1/sza18aFNqI3ZWG9xdXoAAAAAAAA=


--=-AUP9HmdhBUAZ/Cd9yatg--

