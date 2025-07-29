Return-Path: <kvm+bounces-53632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EDADBB14C29
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 12:29:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C781168D87
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 10:29:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE70128A72F;
	Tue, 29 Jul 2025 10:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X/wEgvia"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58A228A1D6;
	Tue, 29 Jul 2025 10:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753784933; cv=none; b=nnEaiys+5p4Y4qWBV5AcZg2BF8CSeUkyN56MvOf122ay2if8tIoHWKemdUXONE1+XA8JocIzEXjDctiQsfYg0vqMBH6/S428dqzUC4I1APsX68y5bHlgwunucsQjLI8m3zoYQzVeCi9R4sZXQwY/jgZ0mmjbeWd9Y/h5EVzMmio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753784933; c=relaxed/simple;
	bh=a1SNTB3HV/Vkobm2cpRVdmqRXLm1fwnmhOsOUHtpies=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oFjoU4rW5bggtFL672phwJMwC5nxorsl6rjSwwJYFCUGmin+XlHkD6MhfpPV470eAPjU9cHYgyeq6QRsI6BP7WT2B2XGEd5R/H145KCxLJIZxSQcDtrH41hkvJyoHc2b75tIdvmIHNFC8PVfhfVKLQDesdgsBshGuyNSMzELvvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=X/wEgvia; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=a1SNTB3HV/Vkobm2cpRVdmqRXLm1fwnmhOsOUHtpies=; b=X/wEgviad7X8B4WGaQQbexYBrc
	b1nGIL2gA4D9I5hs5dtqSIA7AcPfjogKDHJBwQV2e406Tfl4YOGC2R/Qsw5+HJ8ludPBkG/YLf5Rn
	V9PvEEJN7FgrTkJkju7u3+R/W+IP2TWQitC+ucMDfRn9WScDVs4V1N3BGSUWnaVDWAkzpG3B6fU28
	3HUIFz11Jtxn/E8jZS6q1J1tQZkxom8KjLbFdH2pMO48R1mm/nVltyEG3+Yt/7Jp83xXzTrKsWMLn
	tUhC+wq9Oi0Bdm6UQxoNTW8j5GhvLhAV91RZufcfanE0kvJlPsJKXdtdWX5hS8tqNYvvoatQS2k1M
	7vC2OAow==;
Received: from 54-240-197-232.amazon.com ([54.240.197.232] helo=freeip.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ughZC-0000000B59l-2sVB;
	Tue, 29 Jul 2025 10:28:19 +0000
Message-ID: <1b955b6b9b49a7f03fae12d9b13b027822749527.camel@infradead.org>
Subject: Re: [PATCH] KVM: x86: Use gfn_to_pfn_cache for steal_time
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Carsten Stollmaier <stollmc@amazon.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>,  nh-open-source@amazon.com, Peter Xu <peterx@redhat.com>,
 Sebastian Biemueller <sbiemue@amazon.de>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org,  Matthew Wilcox <willy@infradead.org>, Andrew
 Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>
Date: Tue, 29 Jul 2025 11:28:18 +0100
In-Reply-To: <b69ed9d08eb86a346a1d092575abe99512fa875a.camel@infradead.org>
References: <20240802114402.96669-1-stollmc@amazon.com>
	 <b40f244f50ce3a14d637fd1769a9b3f709b0842e.camel@infradead.org>
	 <Zr_tRjKgPtk-uHjq@google.com>
	 <b69ed9d08eb86a346a1d092575abe99512fa875a.camel@infradead.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-63LQhDGVG/7VLT4oj6Vn"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-63LQhDGVG/7VLT4oj6Vn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2024-08-20 at 11:11 +0100, David Woodhouse wrote:
> On Fri, 2024-08-16 at 17:22 -0700, Sean Christopherson wrote:
> > On Fri, Aug 02, 2024, David Woodhouse wrote:
> > > On Fri, 2024-08-02 at 11:44 +0000, Carsten Stollmaier wrote:
> > > > On vcpu_run, before entering the guest, the update of the steal tim=
e
> > > > information causes a page-fault if the page is not present. In our
> > > > scenario, this gets handled by do_user_addr_fault and successively
> > > > handle_userfault since we have the region registered to that.
> > > >=20
> > > > handle_userfault uses TASK_INTERRUPTIBLE, so it is interruptible by
> > > > signals. do_user_addr_fault then busy-retries it if the pending sig=
nal
> > > > is non-fatal. This leads to contention of the mmap_lock.
> > >=20
> > > The busy-loop causes so much contention on mmap_lock that post-copy
> > > live migration fails to make progress, and is leading to failures. Ye=
s?
> > >=20
> > > > This patch replaces the use of gfn_to_hva_cache with gfn_to_pfn_cac=
he,
> > > > as gfn_to_pfn_cache ensures page presence for the memory access,
> > > > preventing the contention of the mmap_lock.
> > > >=20
> > > > Signed-off-by: Carsten Stollmaier <stollmc@amazon.com>
> > >=20
> > > Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
> > >=20
> > > I think this makes sense on its own, as it addresses the specific cas=
e
> > > where KVM is *likely* to be touching a userfaulted (guest) page. And =
it
> > > allows us to ditch yet another explicit asm exception handler.
> >=20
> > At the cost of using a gpc, which has its own complexities.
> >=20
> > But I don't understand why steal_time is special.=C2=A0 If the issue is=
 essentially
> > with handle_userfault(), can't this happen on any KVM uaccess?
>=20
> Theoretically, yes. The steal time is only special in that it happens
> so *often*, every time the vCPU is scheduled in.
>=20
> We should *also* address the general case, perhaps making by
> interruptible user access functions as discussed. But this solves the
> immediate issue which is being observed, *and* lets us ditch the last
> explicit asm exception handling in kvm/x86.c which is why I think it's
> worth doing anyway, even if there's an upcoming fix for the general
> case.

Gentle reader, there was *not* an upcoming fix for the general case,
and this is still an issue in real-world use cases... or would be, if
we hadn't been using Carsten's patch ever since he came up with it.

I still quite like the idea of interruptible user access, but nobody
seemed that excited by it, and as noted I think we should move steal
time to a GPC *anyway*.


--=-63LQhDGVG/7VLT4oj6Vn
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDcyOTEwMjgx
OFowLwYJKoZIhvcNAQkEMSIEIKjVqsM9uadD0MYiLX4KvDYXXQVpugd5AOrhRDAUOYd3MGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIALFPQDwMFBidX
ChiuxAIv4VUhKRzoeBslU5xImz+9CyABS5pzv4j7AOuy3O4N8AXOEdlGDgNNWXc/bk2kR1z2iysW
aCs/F5Tq8peoMCvCqYSKiizqjyZOl8nFZHJi/nt81+g2JcQaPye+bvsC6VsBxCXyv7snAEQf6/aK
1+uyQD5/hePlFHqRr8ljR3+TOh2GaroJuO39+pZ5See/M5a+pyJP/eo1xppwEBS1JtoyfPHY4Edz
51QYN0vmO4+GrvnUQ6KFNFzSC+cUzQr4qgS/7K5TOb8pei4ZYfmzd8ehFiGoZ4Rp6yRYDgWZTDl/
ihnPt1A27OmvIOoKEXqg4VHM9n4QFw9m58x64AvPbevJPdeZxIXYwdfHqQ2wSsB3irGfcn2UlzAt
PlUVE0T7n9plpzz/dlRaPTYeIsZsmfM+IcY2ObYkqjBG4jvdJWlWnnBgN2dqF7qmE3Q+tOcL0NHF
ca3PzKLyZWMPW5RqaqfIsdyHx/DduSm68FiSc5YdmrtQVF7VLydDAi6H4CJWdM5ZCpm4JiAY6x7g
RTtnyAsAmqjEYmw/QHeqqls8U7JATx4ll9eRwm1xbghOtBRs1Xo/FSqvBVMhHxllLG74ogrJdIXr
UEgI6TQEAZ475iJ2d1Ab+bgVR6FnEOL7YvuhQf07yl9g8p2DM5inNW5AeDDQ77cAAAAAAAA=


--=-63LQhDGVG/7VLT4oj6Vn--

