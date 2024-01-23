Return-Path: <kvm+bounces-6735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F09DC839209
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 16:06:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F4312910AD
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 15:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 293105FBA0;
	Tue, 23 Jan 2024 15:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="APPjlYth"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2E85F857
	for <kvm@vger.kernel.org>; Tue, 23 Jan 2024 15:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706022382; cv=none; b=jExecZ46EYTfA6D9RmlhaZZ++d131ylG8SqL9pPcnfLggmmOaYNELjYzg29O1Ps5HnJsaHggM3fhaSO5GPZu4w608VTQpgfYUm0m1j3QAa08sdR/qWpXQmLtONv+EY2wfsokDMsXl8hSe24C25sL37id7QIlpv9uNBcW+ulCqlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706022382; c=relaxed/simple;
	bh=5xmW1se/GhdehnEnMpJ6TQ4tA8vqwn2XqDHaR0p3C74=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=plar39u0svrkMrLK8G2O950FnHRmJmEj9rYh3cz5GFndGEZRwrpNHuV9vGfuz1z/tXv1qr6eOl1sc068yIaD+rfe/K1Y9iu/ZWbKtKT4weia6KfmaRdfb0TxME6Q/u4lTCLCrn6wYAYWXOEUI1m4ELBlLwIgQhNnJt66jepJQTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=APPjlYth; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=p6zx3XKP8gQoV0NN6ZXuDckmnwT8l73aJTRCCczjPU0=; b=APPjlYthkyt3tlTmLBwzCmVQev
	xTL69CGyQQBXQe5B2ZJM/L1TtN5ld3PzKIJyT2iUEi9FroA10wRcU3lgqmF4zqoRZKUvqxwsbm5+7
	6sucMdKxGv3SURclL8YqWPItPR6c9hW8lDa7RRygYjQk8LL1oek/5cDldKrlfu/1/5f4HVLnCUcWC
	Zg4XbIXhaXO6wNYtlnHmRSTw5Mfy69AAFywOOqCAfqDQIAVjSgjiKy1yTR2Aw4SHiaehhAIXw817m
	Mzj+rG1vinvE4aN6iSDOTfn3XTUhN3BpaF0muQz+61UUEoX/DxVlwmOjDEk3qnU6skzJB5ftI+x7E
	ahG3akCQ==;
Received: from [2001:8b0:10b:5:1721:4c6e:400a:4c1e] (helo=u3832b3a9db3152.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rSILt-00000003VEz-00Xb;
	Tue, 23 Jan 2024 15:06:14 +0000
Message-ID: <6dc0e9d1f5db41a053b734b29403ad48c288dea3.camel@infradead.org>
Subject: Re: [PATCH] KVM: pfncache: rework __kvm_gpc_refresh() to fix
 locking issues
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	 <pbonzini@redhat.com>, Paul Durrant <pdurrant@amazon.co.uk>
Date: Tue, 23 Jan 2024 15:06:13 +0000
In-Reply-To: <Zaf7yCYt8XFuMhAd@google.com>
References: <9a82db197449bdb97ee889d2f3cdd7998abd9692.camel@amazon.co.uk>
	 <Zaf7yCYt8XFuMhAd@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-GOEy2hzp0CDVnJ81yMe1"
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-GOEy2hzp0CDVnJ81yMe1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2024-01-17 at 08:09 -0800, Sean Christopherson wrote:
>=20
> NAK, at least as a bug fix.

OK. Not a bug fix.

>=20
> The contract with the gfn_to_pfn_cache, or rather the lack thereof,
> is all kinds of screwed up.

Well yes, that's my point. How's this for a reworked commit message
which doesn't claim it's a bug fix....


    KVM: pfncache: clean up and simplify locking mess
   =20
    The locking on the gfn_to_pfn_cache is... interesting. And awful.
   =20
    There is a rwlock in ->lock which readers take to ensure protection
    against concurrent changes. But __kvm_gpc_refresh() makes assumptions
    that certain fields will not change even while it drops the write lock
    and performs MM operations to revalidate the target PFN and kernel
    mapping.
   =20
    Commit 93984f19e7bc ("KVM: Fully serialize gfn=3D>pfn cache refresh via
    mutex") partly addressed that =E2=80=94 not by fixing it, but by adding=
 a new
    mutex, ->refresh_lock. This prevented concurrent __kvm_gpc_refresh()
    calls on a given gfn_to_pfn_cache, but is still only a partial solution=
.
   =20
    There is still a theoretical race where __kvm_gpc_refresh() runs in
    parallel with kvm_gpc_deactivate(). While __kvm_gpc_refresh() has
    dropped the write lock, kvm_gpc_deactivate() clears the ->active flag
    and unmaps ->khva. Then __kvm_gpc_refresh() determines that the previou=
s
    ->pfn and ->khva are still valid, and reinstalls those values into the
    structure. This leaves the gfn_to_pfn_cache with the ->valid bit set,
    but ->active clear. And a ->khva which looks like a reasonable kernel
    address but is actually unmapped.
   =20
    All it takes is a subsequent reactivation to cause that ->khva to be
    dereferenced. This would theoretically cause an oops which would look
    something like this:
   =20
    [1724749.564994] BUG: unable to handle page fault for address: ffffaa35=
40ace0e0
    [1724749.565039] RIP: 0010:__kvm_xen_has_interrupt+0x8b/0xb0
   =20
    I say "theoretically" because theoretically, that oops that was seen in
    production cannot happen. The code which uses the gfn_to_pfn_cache is
    supposed to have its *own* locking, to further paper over the fact that
    the gfn_to_pfn_cache's own papering-over (->refresh_lock) of its own
    rwlock abuse is not sufficient.
   =20
    For the Xen vcpu_info that external lock is the vcpu->mutex, and for th=
e
    shared info it's kvm->arch.xen.xen_lock. Those locks ought to protect
    the gfn_to_pfn_cache against concurrent deactivation vs. refresh in all
    but the cases where the vcpu or kvm object is being *destroyed*, in
    which case the subsequent reactivation should never happen.
   =20
    Theoretically.
   =20
    Nevertheless, this locking abuse is awful and should be fixed, even if
    no clear explanation can be found for how the oops happened. So...
   =20
    Clean up the semantics of hva_to_pfn_retry() so that it no longer does
    any locking gymnastics because it no longer operates on the gpc object
    at all. It is now called with a uhva and simply returns the
    corresponding pfn (pinned), and a mapped khva for it.
   =20
    Its caller __kvm_gpc_refresh() now sets gpc->uhva and clears gpc->valid
    before dropping ->lock, calling hva_to_pfn_retry() and retaking ->lock
    for write.
   =20
    If hva_to_pfn_retry() fails, *or* if the ->uhva or ->active fields in
    the gpc changed while the lock was dropped, the new mapping is discarde=
d
    and the gpc is not modified. On success with an unchanged gpc, the new
    mapping is installed and the current ->pfn and ->uhva are taken into th=
e
    local old_pfn and old_khva variables to be unmapped once the locks are
    all released.
   =20
    This simplification means that ->refresh_lock is no longer needed for
    correctness, but it does still provide a minor optimisation because it
    will prevent two concurrent __kvm_gpc_refresh() calls from mapping a
    given PFN, only for one of them to lose the race and discard its
    mapping.
   =20
    The optimisation in hva_to_pfn_retry() where it attempts to use the old
    mapping if the pfn doesn't change is dropped, since it makes the pinnin=
g
    more complex. It's a pointless optimisation anyway, since the odds of
    the pfn ending up the same when the uhva has changed (i.e. the odds of
    the two userspace addresses both pointing to the same underlying
    physical page) are negligible,
   =20
    The 'hva_changed' local variable in __kvm_gpc_refresh() is also removed=
,
    since it's simpler just to clear gpc->valid if the uhva changed.
    Likewise the unmap_old variable is dropped because it's just as easy to
    check the old_pfn variable for KVM_PFN_ERR_FAULT.
   =20
    Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
    Reviewed-by: Paul Durrant <pdurrant@amazon.com>




--=-GOEy2hzp0CDVnJ81yMe1
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCEkQw
ggYQMIID+KADAgECAhBNlCwQ1DvglAnFgS06KwZPMA0GCSqGSIb3DQEBDAUAMIGIMQswCQYDVQQG
EwJVUzETMBEGA1UECBMKTmV3IEplcnNleTEUMBIGA1UEBxMLSmVyc2V5IENpdHkxHjAcBgNVBAoT
FVRoZSBVU0VSVFJVU1QgTmV0d29yazEuMCwGA1UEAxMlVVNFUlRydXN0IFJTQSBDZXJ0aWZpY2F0
aW9uIEF1dGhvcml0eTAeFw0xODExMDIwMDAwMDBaFw0zMDEyMzEyMzU5NTlaMIGWMQswCQYDVQQG
EwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYD
VQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAyjztlApB/975Rrno1jvm2pK/KxBOqhq8gr2+JhwpKirSzZxQgT9tlC7zl6hn1fXjSo5MqXUf
ItMltrMaXqcESJuK8dtK56NCSrq4iDKaKq9NxOXFmqXX2zN8HHGjQ2b2Xv0v1L5Nk1MQPKA19xeW
QcpGEGFUUd0kN+oHox+L9aV1rjfNiCj3bJk6kJaOPabPi2503nn/ITX5e8WfPnGw4VuZ79Khj1YB
rf24k5Ee1sLTHsLtpiK9OjG4iQRBdq6Z/TlVx/hGAez5h36bBJMxqdHLpdwIUkTqT8se3ed0PewD
ch/8kHPo5fZl5u1B0ecpq/sDN/5sCG52Ds+QU5O5EwIDAQABo4IBZDCCAWAwHwYDVR0jBBgwFoAU
U3m/WqorSs9UgOHYm8Cd8rIDZsswHQYDVR0OBBYEFAnA8vwL2pTbX/4r36iZQs/J4K0AMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEF
BQcDBDARBgNVHSAECjAIMAYGBFUdIAAwUAYDVR0fBEkwRzBFoEOgQYY/aHR0cDovL2NybC51c2Vy
dHJ1c3QuY29tL1VTRVJUcnVzdFJTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHYGCCsGAQUF
BwEBBGowaDA/BggrBgEFBQcwAoYzaHR0cDovL2NydC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJT
QUFkZFRydXN0Q0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0G
CSqGSIb3DQEBDAUAA4ICAQBBRHUAqznCFfXejpVtMnFojADdF9d6HBA4kMjjsb0XMZHztuOCtKF+
xswhh2GqkW5JQrM8zVlU+A2VP72Ky2nlRA1GwmIPgou74TZ/XTarHG8zdMSgaDrkVYzz1g3nIVO9
IHk96VwsacIvBF8JfqIs+8aWH2PfSUrNxP6Ys7U0sZYx4rXD6+cqFq/ZW5BUfClN/rhk2ddQXyn7
kkmka2RQb9d90nmNHdgKrwfQ49mQ2hWQNDkJJIXwKjYA6VUR/fZUFeCUisdDe/0ABLTI+jheXUV1
eoYV7lNwNBKpeHdNuO6Aacb533JlfeUHxvBz9OfYWUiXu09sMAviM11Q0DuMZ5760CdO2VnpsXP4
KxaYIhvqPqUMWqRdWyn7crItNkZeroXaecG03i3mM7dkiPaCkgocBg0EBYsbZDZ8bsG3a08LwEsL
1Ygz3SBsyECa0waq4hOf/Z85F2w2ZpXfP+w8q4ifwO90SGZZV+HR/Jh6rEaVPDRF/CEGVqR1hiuQ
OZ1YL5ezMTX0ZSLwrymUE0pwi/KDaiYB15uswgeIAcA6JzPFf9pLkAFFWs1QNyN++niFhsM47qod
x/PL+5jR87myx5uYdBEQkkDc+lKB1Wct6ucXqm2EmsaQ0M95QjTmy+rDWjkDYdw3Ms6mSWE3Bn7i
5ZgtwCLXgAIe5W8mybM2JzCCBhQwggT8oAMCAQICEQDGvhmWZ0DEAx0oURL6O6l+MA0GCSqGSIb3
DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYD
VQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28g
UlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTIyMDEwNzAw
MDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9y
ZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3GpC2bomUqk+91wLYBzDMcCj5C9m6
oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZHh7htyAkWYVoFsFPrwHounto8xTsy
SSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT9YgcBqKCo65pTFmOnR/VVbjJk4K2
xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNjP+qDrh0db7PAjO1D4d5ftfrsf+kd
RR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy2U+eITZ5LLE5s45mX2oPFknWqxBo
bQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3BgBEmfsYWlBXO8rVXfvPgLs32VdV
NZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/7auNVRmPB3v5SWEsH8xi4Bez2V9U
KxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmdlFYhAflWKQ03Ufiu8t3iBE3VJbc2
5oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9aelIl6vtbhMA+l0nfrsORMa4kobqQ5
C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMBAAGjggHMMIIByDAfBgNVHSMEGDAW
gBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeDMcimo0oz8o1R1Nver3ZVpSkwDgYD
VR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMC
MEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYBBQUHAgEWF2h0dHBzOi8vc2VjdGln
by5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwuc2VjdGlnby5jb20vU2VjdGln
b1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcmwwgYoGCCsGAQUFBwEB
BH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdvLmNvbS9TZWN0aWdvUlNBQ2xpZW50
QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAjBggrBgEFBQcwAYYXaHR0cDovL29j
c3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5mcmFkZWFkLm9yZzANBgkqhkiG9w0B
AQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQvQ/fzPXmtR9t54rpmI2TfyvcKgOXp
qa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvIlSPrzIB4Z2wyIGQpaPLlYflrrVFK
v9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9ChWFfgSXvrWDZspnU3Gjw/rMHrGnql
Htlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0whpBtXdyDjzBtQTaZJ7zTT/vlehc/
tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9IzCCBhQwggT8oAMCAQICEQDGvhmW
Z0DEAx0oURL6O6l+MA0GCSqGSIb3DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3Jl
YXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0
ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJl
IEVtYWlsIENBMB4XDTIyMDEwNzAwMDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJ
ARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3
GpC2bomUqk+91wLYBzDMcCj5C9m6oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZH
h7htyAkWYVoFsFPrwHounto8xTsySSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT
9YgcBqKCo65pTFmOnR/VVbjJk4K2xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNj
P+qDrh0db7PAjO1D4d5ftfrsf+kdRR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy
2U+eITZ5LLE5s45mX2oPFknWqxBobQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3
BgBEmfsYWlBXO8rVXfvPgLs32VdVNZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/
7auNVRmPB3v5SWEsH8xi4Bez2V9UKxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmd
lFYhAflWKQ03Ufiu8t3iBE3VJbc25oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9ae
lIl6vtbhMA+l0nfrsORMa4kobqQ5C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMB
AAGjggHMMIIByDAfBgNVHSMEGDAWgBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeD
Mcimo0oz8o1R1Nver3ZVpSkwDgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYw
FAYIKwYBBQUHAwQGCCsGAQUFBwMCMEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYB
BQUHAgEWF2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9j
cmwuc2VjdGlnby5jb20vU2VjdGlnb1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1h
aWxDQS5jcmwwgYoGCCsGAQUFBwEBBH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdv
LmNvbS9TZWN0aWdvUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAj
BggrBgEFBQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQv
Q/fzPXmtR9t54rpmI2TfyvcKgOXpqa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvI
lSPrzIB4Z2wyIGQpaPLlYflrrVFKv9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9Ch
WFfgSXvrWDZspnU3Gjw/rMHrGnqlHtlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0w
hpBtXdyDjzBtQTaZJ7zTT/vlehc/tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9
IzGCBMcwggTDAgEBMIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVz
dGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMT
NVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA
xr4ZlmdAxAMdKFES+jupfjANBglghkgBZQMEAgEFAKCCAeswGAYJKoZIhvcNAQkDMQsGCSqGSIb3
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjQwMTIzMTUwNjEzWjAvBgkqhkiG9w0BCQQxIgQg0J0gSAHR
Bv0S15xni2GjjGS7NH8WoQVUCzNXIoTnxTEwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgBK0DEE3P5GeSF459WQMRc97+iJNQCbU7wd
JZ879Dkn9oSrKL9KlZvTgQ3/VSLP/yIyUI/Zav8cqHjNUPU4sj3BtV4YO7M3dF4VPf59zQ5raT4Q
2Z4CLGV4i36IbCdwcAOfG73ETfOWFLm4C+FIyOcHTxbeb5eg7AToKWAkDdud8Fgx80oysLG9ESeu
dfifd5YFQpuHeUODy5Oy8n8tI627Pi05q/QinnoVwJqbfVmOzGX1R8+ipP2mohIO2jIH7+DY1VCz
MVt+OsWrFGByTGInAImicJQXM6s78PJ3+Eg/Yz9HrszBLzYxsbuWyWEct4wafW/octSMtuQOxWhS
QX03F5+1dj2zgOiRhD+OZ7whUBEKGP8kkGih9b0r52JieXrX8oQtCiIVHOEkQORN9BQN+Luy1uj9
zioDpCoprtMgpruD7sSW2RT30PPU5UepBfNh/UqFm+n9XlX8WNyZrft7mdSa4MDVFzUm+03T2YBI
od59yR6EYgtiiX+RWzWiDcjLp1TJi8XM/z8cwBGrqPLIk/cUwBRUKfZ9bSvsvmUNj08Nuo9POdWy
adaTUKJUr9IF9umJW9r4Z3JqieZYREBhk0mNihm6rpKRg4jGp6/fxwyh8UglfOMi2nC0mJdu9DGI
cvkF0xt8fDdJEOm4tTGDmfAf6L6QjGHiJnbDlRaRqgAAAAAAAA==


--=-GOEy2hzp0CDVnJ81yMe1--

