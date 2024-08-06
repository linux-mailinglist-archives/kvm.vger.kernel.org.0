Return-Path: <kvm+bounces-23381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 128C39492E7
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 16:25:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF0B22831D7
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 14:25:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88DF918D65A;
	Tue,  6 Aug 2024 14:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TTCVNrOF"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E02D18D640;
	Tue,  6 Aug 2024 14:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722954291; cv=none; b=PXaYx+NJhJ4iUr1qjrEqWqCj9Vk3DhLYqTQcLvp//R85RaAFRfn9vC5lyu9cQD9PkvBCCUWhd4F4Maprqk1tJ69yhyy0ICvp+vt+08RjqeQbWXnbYT4DT1f05Q7XIZVQjmBTUu0519fsxbsNlaGFkF7ZdTAZEaxI4HnAX8JrdiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722954291; c=relaxed/simple;
	bh=CASEWJPCnB9/9Kgi6qzqBazvFoUJmg8/1FTExOmesVo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oyOL8IX40aE5MNKyKY2cZ05yuTf6gR7iOERfyFd15MiiCjvIN5FZG7DSD9aPYBd/aa8//IDfShdmWVA1CW9xXiUlNwQwVIvuAmR0DNITF7iCEQywEFRu4ANQ1y0A0FQgnOJzvMe6JN0bZ9afYCo592xtUGWUWGXnv84sQIY/ryg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TTCVNrOF; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CASEWJPCnB9/9Kgi6qzqBazvFoUJmg8/1FTExOmesVo=; b=TTCVNrOFPoczXE6rjSRGAKpAsR
	JMCvYLZ33tOKzoSPxwgiFz78NFoZPsc3FRljDculndhwZ4aRSKYTG1yMN7BaMlDoTWUQsq6Nma4iq
	/yQYI8ke0EyUtcIN4Zt1M5ZBQGg+TYCoUeN962Ad8z/J/Xy2NOzXE1VYO1rFi9YTKg+8USuogJGAI
	DknoKFdHVTVJR7PQnItd1WYVA4ECRc/0z4MUnuwQ3stxfx544R/4yESBuSgpWlDFEa6P6/Dg79CGp
	bQ/s/K8eeAUINF3nqUkxk2G/VHMnSTG/eQq3O1CtovEHdyU12gJth0MeVGVU2mqgaKIVqquEC79VC
	PYYLXJKw==;
Received: from [2001:8b0:10b:5:95e1:bb50:f4dd:70b1] (helo=u3832b3a9db3152.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sbL75-00000005pVu-1Zgj;
	Tue, 06 Aug 2024 14:24:35 +0000
Message-ID: <a21a90c76af446951956b4423b1f87beb91cb660.camel@infradead.org>
Subject: Re: [PATCH] KVM: Move gfn_to_pfn_cache invalidation to
 invalidate_range_end hook
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Mushahid Hussain
 <hmushi@amazon.co.uk>,  Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li
 <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>,  Joerg Roedel
 <joro@8bytes.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mingwei Zhang <mizhang@google.com>, Maxim Levitsky <mlevitsk@redhat.com>
Date: Tue, 06 Aug 2024 15:24:34 +0100
In-Reply-To: <ZrItHce2GqAWoN0o@google.com>
References: <20220427014004.1992589-1-seanjc@google.com>
	 <20220427014004.1992589-7-seanjc@google.com>
	 <294c8c437c2e48b318b8c27eb7467430dfcba92b.camel@infradead.org>
	 <f862cefff2ed3f4211b69d785670f41667703cf3.camel@infradead.org>
	 <ZrFyM8rJZYjfFawx@google.com>
	 <dd6ca54cfd23dba0d3cba7c1ceefea1fdfcdecbe.camel@infradead.org>
	 <ZrItHce2GqAWoN0o@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-f74vOK5w5TP62dPjZu3l"
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-f74vOK5w5TP62dPjZu3l
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2024-08-06 at 07:03 -0700, Sean Christopherson wrote:
> On Tue, Aug 06, 2024, David Woodhouse wrote:
> > On Mon, 2024-08-05 at 17:45 -0700, Sean Christopherson wrote:
> > > On Mon, Aug 05, 2024, David Woodhouse wrote:
> > > > From: David Woodhouse <dwmw@amazon.co.uk>
> > > Servicing guest pages faults has the same problem, which is why
> > > mmu_invalidate_retry_gfn() was added.=C2=A0 Supporting hva-only GPCs =
made our lives a
> > > little harder, but not horrifically so (there are ordering difference=
s regardless).
> > >=20
> > > Woefully incomplete, but I think this is the gist of what you want:
> >=20
> > Hm, maybe. It does mean that migration occurring all through memory
> > (indeed, just one at top and bottom of guest memory space) would
> > perturb GPCs which remain present.
>=20
> If that happens with a real world VMM, and it's not a blatant VMM goof, t=
hen we
> can fix KVM.=C2=A0 The stage-2 page fault path hammers the mmu_notifier r=
etry logic
> far more than GPCs, so if a range-based check is inadequate for some use =
case,
> then we definitely need to fix both.
>=20
> In short, I don't see any reason to invent something different for GPCs.
>=20
> > > > @@ -849,6 +837,8 @@ static void kvm_mmu_notifier_invalidate_range_e=
nd(struct mmu_notifier *mn,
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0wake =3D !kvm->mn_a=
ctive_invalidate_count;
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spin_unlock(&kvm->m=
n_invalidate_lock);
> > > > =C2=A0
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0gfn_to_pfn_cache_invalid=
ate(kvm, range->start, range->end);
> > >=20
> > > We can't do this.=C2=A0 The contract with mmu_notifiers is that secon=
dary MMUs must
> > > unmap the hva before returning from invalidate_range_start(), and mus=
t not create
> > > new mappings until invalidate_range_end().

Looking at that assertion harder... where is that rule written? It
seems counter-intuitive to me; that isn't how TLBs work. Another CPU
can populate a TLB entry right up to the moment the PTE is actually
*changed* in the page tables, and then the CPU which is
modifying/zapping the PTE needs to perform a remote TLB flush. That
remote TLB flush is analogous to the invalidate_range_end() call,
surely?

I'm fairly sure that's how it works for PASID support too; nothing
prevents the IOMMU+device from populating an IOTLB entry until the PTE
is actually changed in the process page tables.

So why can't we do the same for the GPC?

> > But in the context of the GPC, it is only "mapped" when the ->valid bit=
 is set.=20
> >=20
> > Even the invalidation callback just clears the valid bit, and that
> > means nobody is allowed to dereference the ->khva any more. It doesn't
> > matter that the underlying (stale) PFN is still kmapped.
> >=20
> > Can we not apply the same logic to the hva_to_pfn_retry() loop? Yes, it
> > might kmap a page that gets removed, but it's not actually created a
> > new mapping if it hasn't set the ->valid bit.
> >=20
> > I don't think this version quite meets the constraints, and I might
> > need to hook *both* the start and end notifiers, and might not like it
> > once I get there. But I'll have a go...
>=20
> I'm pretty sure you're going to need the range-based retry logic.=C2=A0 K=
VM can't
> safely set gpc->valid until mn_active_invalidate_count reaches zero, so i=
f a GPC
> refresh comes along after mn_active_invalidate_count has been elevated, i=
t won't
> be able to set gpc->valid until the MADV_DONTNEED storm goes away.=C2=A0 =
Without
> range-based tracking, there's no way to know if a previous invalidation w=
as
> relevant to the GPC.

If it is indeed the case that KVM can't just behave like a normal TLB,
so it and can't set gpc->valid until mn_active_invalidate_count reaches
zero, it still only needs to *wait* (or spin, maybe). It certainly
doesn't need to keep looping and remapping the same PFN over and over
again, as it does at the moment.

When mn_active_invalidate_count does reach zero, either the young GPC
will have been invalidated by clearing the (to be renamed) ->validating
flag, or it won't have been. If it *has* been invalidated, that's when
hva_to_pfn_retry() needs to go one more time round its full loop.

So it just needs to wait until any pending (relevant) invalidations
have completed, *then* check and potentially loop once more.

And yes, making that *wait* range-based does make some sense, I
suppose. It becomes "wait for gpc->uhva not to be within the range of
kvm->mmu_gpc_invalidate_range_{start,end}."

Except... that range can never shrink *except* when
mn_active_invalidate_count becomes zero, can it? So if we do end up
waiting, the wake condition is *still* just that the count has become
zero. There's already a wakeup in that case, on kvm-
>mn_memslots_update_rcuwait. Can I wait on that?

--=-f74vOK5w5TP62dPjZu3l
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjQwODA2MTQyNDM0WjAvBgkqhkiG9w0BCQQxIgQgUr8+VNqc
E6xy0tBO4tj6BTig3+3sW10OymRb/cleLeUwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgAEGzp8HzDVxQYObUQPgr9Vaf0Hwg8dUSA9
a91XSPhK/SltmwQs2OqUhBWFxW9IHIeG4nJdhTs6fVQndR/i/BUOztpoUMx4CHME1uw9S2vx8HKk
gxSVFVvakLieqsQs5HZbgudb/Q91fhhwbRAm6f1sMSJxfKR5eVvUEaebBUSuibF6f7mLDrJygHQE
Ypo9o/nIHH1Z/HnVBghGLq2lTn3MQCjn6AIigv619QTxVEwCZ/HoqPhTUEf8QdrMVH3oGGNxSXmP
h9rIr7hzMWRg/+BtYb+vNQU9uWi4bYTLe6psY1g12ZXrKDAGcwVbOcR9mdNeHaY2Ji3DZBUd1uX7
eGLfqT4ekOd80MnfvZeAIGcPl3JOBmmUrvUV5TJCM66CrPp08XxSoRHAl8R2BGL8OBmZKOiGwvW0
EN88sRNpJTmHAmo+wkYIQFX3v7kB6J1vZzRblrwF4okXieWRcxL8g3vO1+G8Rkukwng9we5Y8a2K
Vz723YxPlb29TG5fk0vwlNH9+QIWdEUM96JtETjkioMKtPoL2vcXUk56ITfuqLEkx6f2Y0Ermxta
4KphpEIItcH8045WWHqzYexh0W+AiqizrHrzAoc/H2w3cgPqPD6U/9urkzjJvhCZ4uiJ7xpTRmBe
+xp0AHOEuK+2khAt8OAT3FWnB7KQsQK9HKY/CX/j3gAAAAAAAA==


--=-f74vOK5w5TP62dPjZu3l--

