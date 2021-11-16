Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3EF7453907
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 18:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239272AbhKPSBF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 13:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239287AbhKPSBD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 13:01:03 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCE5C061764
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 09:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AXEE9pda+BEluzLFhFbEPB92BnJewXZsywO5iILZAKA=; b=DWovc9c2l7AaMNmPaGe1rRV9tQ
        6322wsOJxBJN6/q95x+tRLQV8V4ivyrgsjWnHhIEhO4EmExG2NcrlLp1MfRk5RXnliInsaOxIuWIU
        AGYsNz38nKXppaEDGhprIHEfYQjW9qN2GP6Q/2uqAb6g0X/Ku6UggVwjSBIhKQNhTd5TPTiv3TqQQ
        8MFQUf1fxKf1CJGtXK1JkSjCH+sugqfUhxvUH++7Lm/G2CktfiwoYXDu9hN1KSsOoNGYVGaFzXCsA
        3zneowVBVDsIooo1qVjuulmDjke4KhE+SJ1TvkfInDODS04Gv98pUqXOv2hjToOMfLcBMjh5/nvC/
        HyaSxyRg==;
Received: from [2001:8b0:10b:1:4a2a:e3ff:fe14:8625] (helo=u3832b3a9db3152.ant.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mn2iS-002VbX-OI; Tue, 16 Nov 2021 17:57:57 +0000
Message-ID: <7bcb9dafa55c283f9f9d0b841f4a53f0b6b3286d.camel@infradead.org>
Subject: Re: [RFC PATCH 0/11] Rework gfn_to_pfn_cache
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <bonzini@gnu.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, karahmed@amazon.com
Date:   Tue, 16 Nov 2021 17:57:53 +0000
In-Reply-To: <1b8af2ad-17f8-8c22-d0d5-35332e919104@gnu.org>
References: <2b400dbb16818da49fb599b9182788ff9896dcda.camel@infradead.org>
         <4c37db19-14ed-46b8-eabe-0381ba879e5c@redhat.com>
         <537fdcc6af80ba6285ae0cdecdb615face25426f.camel@infradead.org>
         <7e4b895b-8f36-69cb-10a9-0b4139b9eb79@redhat.com>
         <95fae9cf56b1a7f0a5f2b9a1934e29e924908ff2.camel@infradead.org>
         <3a2a9a8c-db98-b770-78e2-79f5880ce4ed@redhat.com>
         <2c7eee5179d67694917a5a0d10db1bce24af61bf.camel@infradead.org>
         <537a1d4e-9168-cd4a-cd2f-cddfd8733b05@redhat.com>
         <YZLmapmzs7sLpu/L@google.com>
         <57d599584ace8ab410b9b14569f434028e2cf642.camel@infradead.org>
         <94bb55e117287e07ba74de2034800da5ba4398d2.camel@infradead.org>
         <04bf7e8b-d0d7-0eb6-4d15-bfe4999f42f8@redhat.com>
         <19bf769ef623e0392016975b12133d9a3be210b3.camel@infradead.org>
         <ad0648ac-b72a-1692-c608-b37109b3d250@redhat.com>
         <126b7fcbfa78988b0fceb35f86588bd3d5aae837.camel@infradead.org>
         <02cdb0b0-c7b0-34c5-63c1-aec0e0b14cf7@redhat.com>
         <9733f477bada4cc311078be529b7118f1dec25bb.camel@infradead.org>
         <1b8af2ad-17f8-8c22-d0d5-35332e919104@gnu.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-G3NDLl7d5+np80R8r6Yn"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-G3NDLl7d5+np80R8r6Yn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-11-16 at 18:42 +0100, Paolo Bonzini wrote:
> On 11/16/21 17:06, David Woodhouse wrote:
> > On Tue, 2021-11-16 at 16:49 +0100, Paolo Bonzini wrote:
> > > On 11/16/21 16:09, David Woodhouse wrote:
> > > > On Tue, 2021-11-16 at 15:57 +0100, Paolo Bonzini wrote:
> > > > > This should not be needed, should it?  As long as the gfn-to-pfn
> > > > > cache's vcpu field is handled properly, the request will just cau=
se
> > > > > the vCPU not to enter.
> > > >=20
> > > > If the MMU mappings never change, the request never happens. But th=
e
> > > > memslots *can* change, so it does need to be revalidated each time
> > > > through I think?
> > >=20
> > > That needs to be done on KVM_SET_USER_MEMORY_REGION, using the same
> > > request (or even the same list walking code) as the MMU notifiers.
> >=20
> > Hm....  kvm_arch_memslots_updated() is already kicking every vCPU after
> > the update, and although that was asynchronous it was actually OK
> > because unlike in the MMU notifier case, that page wasn't actually
> > going away =E2=80=94 and if that HVA *did* subsequently go away, our HV=
A-based
> > notifier check would still catch that and kill it synchronously.
>=20
> Right, so it only needs to change the kvm_vcpu_kick into a=20
> kvm_make_all_cpus_request without KVM_WAIT.

Yeah, I think that works.

> > > > Hm, in my head that was never going to *change* for a given gpc; it
> > > > *belongs* to that vCPU for ever (and was even part of vmx->nested. =
for
> > > > that vCPU, to replace e.g. vmx->nested.pi_desc_map).
> > >=20
> > > Ah okay, I thought it would be set in nested vmentry and cleared in
> > > nested vmexit.
> >=20
> > I don't think it needs to be proactively cleared; we just don't
> > *refresh* it until we need it again.
>=20
> True, but if it's cleared the vCPU won't be kicked, which is nice.

The vCPU will only be kicked once when it becomes invalid anyway. It's
a trade-off. Either we leave it valid for next time that L2 vCPU is
entered, or we actively clear it. Not sure I lose much sleep either
way?

> > If we *know* the GPA and size haven't changed, and if we know that
> > gpc->valid becoming false would have been handled differently, then we
> > could optimise that whole thing away quite effectively to a single
> > check on ->generations?
>=20
> I wonder if we need a per-gpc memslot generation...  Can it be global?

Theoretically, maybe. It's kind of mathematically equivalent to the
highest value of each gpc memslot. And any gpc which *isn't* at that
maximum is by definition invalid.

But I'm not sure I see how to implement it without actively going and
clearing the 'valid' bit on all GPCs when it gets bumped... which was
your previous suggestion if basically running the same code as in the
MMU notifier?




> > This one actually compiles. Not sure we have any test cases that will
> > actually exercise it though, do we?
>=20
> I'll try to spend some time writing testcases.
>=20
> > +		read_lock(&gpc->lock);
> > +		if (!kvm_gfn_to_pfn_cache_check(vcpu->kvm, gpc, gpc->gpa, PAGE_SIZE)=
) {
> > +			read_unlock(&gpc->lock);
> >   			goto mmio_needed;
> > +		}
> > +
> > +		vapic_page =3D gpc->khva;
>=20
> If we know this gpc is of the synchronous kind, I think we can skip the=
=20
> read_lock/read_unlock here?!?

Er... this one was OUTSIDE_GUEST_MODE and is the atomic kind, which
means it needs to hold the lock for the duration of the access in order
to prevent (preemption and) racing with the invalidate?

It's the IN_GUEST_MODE one (in my check_guest_maps()) where we might
get away without the lock, perhaps?

>=20
> >   		__kvm_apic_update_irr(vmx->nested.pi_desc->pir,
> >   			vapic_page, &max_irr);
> > @@ -3749,6 +3783,7 @@ static int vmx_complete_nested_posted_interrupt(s=
truct kvm_vcpu *vcpu)
> >   			status |=3D (u8)max_irr;
> >   			vmcs_write16(GUEST_INTR_STATUS, status);
> >   		}
> > +		read_unlock(&gpc->lock);
> >   	}
> >  =20

I just realised that the mark_page_dirty() on invalidation and when the
the irqfd workqueue refreshes the gpc might fall foul of the same
dirty_ring problem that I belatedly just spotted with the Xen shinfo
clock write. I'll fix it up to *always* require a vcpu (to be
associated with the writes), and reinstate the guest_uses_pa flag since
that can no longer in implicit in (vcpu!=3DNULL).

I may leave the actual task of fixing nesting to you, if that's OK, as
long as we consider the new gfn_to_pfn_cache sufficient to address the
problem? I think it's mostly down to how we *use* it now, rather than
the fundamental design of cache itself?

--=-G3NDLl7d5+np80R8r6Yn
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCECow
ggUcMIIEBKADAgECAhEA4rtJSHkq7AnpxKUY8ZlYZjANBgkqhkiG9w0BAQsFADCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwHhcNMTkwMTAyMDAwMDAwWhcNMjIwMTAxMjM1
OTU5WjAkMSIwIAYJKoZIhvcNAQkBFhNkd213MkBpbmZyYWRlYWQub3JnMIIBIjANBgkqhkiG9w0B
AQEFAAOCAQ8AMIIBCgKCAQEAsv3wObLTCbUA7GJqKj9vHGf+Fa+tpkO+ZRVve9EpNsMsfXhvFpb8
RgL8vD+L133wK6csYoDU7zKiAo92FMUWaY1Hy6HqvVr9oevfTV3xhB5rQO1RHJoAfkvhy+wpjo7Q
cXuzkOpibq2YurVStHAiGqAOMGMXhcVGqPuGhcVcVzVUjsvEzAV9Po9K2rpZ52FE4rDkpDK1pBK+
uOAyOkgIg/cD8Kugav5tyapydeWMZRJQH1vMQ6OVT24CyAn2yXm2NgTQMS1mpzStP2ioPtTnszIQ
Ih7ASVzhV6csHb8Yrkx8mgllOyrt9Y2kWRRJFm/FPRNEurOeNV6lnYAXOymVJwIDAQABo4IB0zCC
Ac8wHwYDVR0jBBgwFoAUgq9sjPjF/pZhfOgfPStxSF7Ei8AwHQYDVR0OBBYEFLfuNf820LvaT4AK
xrGK3EKx1DE7MA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUF
BwMEBggrBgEFBQcDAjBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEDBTArMCkGCCsGAQUFBwIBFh1o
dHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3Js
LmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWls
Q0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0dHA6Ly9jcnQuY29tb2RvY2Eu
Y29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwJAYI
KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAeBgNVHREEFzAVgRNkd213MkBpbmZy
YWRlYWQub3JnMA0GCSqGSIb3DQEBCwUAA4IBAQALbSykFusvvVkSIWttcEeifOGGKs7Wx2f5f45b
nv2ghcxK5URjUvCnJhg+soxOMoQLG6+nbhzzb2rLTdRVGbvjZH0fOOzq0LShq0EXsqnJbbuwJhK+
PnBtqX5O23PMHutP1l88AtVN+Rb72oSvnD+dK6708JqqUx2MAFLMevrhJRXLjKb2Mm+/8XBpEw+B
7DisN4TMlLB/d55WnT9UPNHmQ+3KFL7QrTO8hYExkU849g58Dn3Nw3oCbMUgny81ocrLlB2Z5fFG
Qu1AdNiBA+kg/UxzyJZpFbKfCITd5yX49bOriL692aMVDyqUvh8fP+T99PqorH4cIJP6OxSTdxKM
MIIFHDCCBASgAwIBAgIRAOK7SUh5KuwJ6cSlGPGZWGYwDQYJKoZIhvcNAQELBQAwgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTE5MDEwMjAwMDAwMFoXDTIyMDEwMTIz
NTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBALL98Dmy0wm1AOxiaio/bxxn/hWvraZDvmUVb3vRKTbDLH14bxaW
/EYC/Lw/i9d98CunLGKA1O8yogKPdhTFFmmNR8uh6r1a/aHr301d8YQea0DtURyaAH5L4cvsKY6O
0HF7s5DqYm6tmLq1UrRwIhqgDjBjF4XFRqj7hoXFXFc1VI7LxMwFfT6PStq6WedhROKw5KQytaQS
vrjgMjpICIP3A/CroGr+bcmqcnXljGUSUB9bzEOjlU9uAsgJ9sl5tjYE0DEtZqc0rT9oqD7U57My
ECIewElc4VenLB2/GK5MfJoJZTsq7fWNpFkUSRZvxT0TRLqznjVepZ2AFzsplScCAwEAAaOCAdMw
ggHPMB8GA1UdIwQYMBaAFIKvbIz4xf6WYXzoHz0rcUhexIvAMB0GA1UdDgQWBBS37jX/NtC72k+A
CsaxitxCsdQxOzAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAdBgNVHSUEFjAUBggrBgEF
BQcDBAYIKwYBBQUHAwIwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAwUwKzApBggrBgEFBQcCARYd
aHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwWgYDVR0fBFMwUTBPoE2gS4ZJaHR0cDovL2Ny
bC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFp
bENBLmNybDCBiwYIKwYBBQUHAQEEfzB9MFUGCCsGAQUFBzAChklodHRwOi8vY3J0LmNvbW9kb2Nh
LmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3J0MCQG
CCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAC20spBbrL71ZEiFrbXBHonzhhirO1sdn+X+O
W579oIXMSuVEY1LwpyYYPrKMTjKECxuvp24c829qy03UVRm742R9Hzjs6tC0oatBF7KpyW27sCYS
vj5wbal+TttzzB7rT9ZfPALVTfkW+9qEr5w/nSuu9PCaqlMdjABSzHr64SUVy4ym9jJvv/FwaRMP
gew4rDeEzJSwf3eeVp0/VDzR5kPtyhS+0K0zvIWBMZFPOPYOfA59zcN6AmzFIJ8vNaHKy5QdmeXx
RkLtQHTYgQPpIP1Mc8iWaRWynwiE3ecl+PWzq4i+vdmjFQ8qlL4fHz/k/fT6qKx+HCCT+jsUk3cS
jDCCBeYwggPOoAMCAQICEGqb4Tg7/ytrnwHV2binUlYwDQYJKoZIhvcNAQEMBQAwgYUxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRp
b24gQXV0aG9yaXR5MB4XDTEzMDExMDAwMDAwMFoXDTI4MDEwOTIzNTk1OVowgZcxCzAJBgNVBAYT
AkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNV
BAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAvrOeV6wodnVAFsc4A5jTxhh2IVDzJXkLTLWg0X06WD6cpzEup/Y0dtmEatrQPTRI5Or1u6zf
+bGBSyD9aH95dDSmeny1nxdlYCeXIoymMv6pQHJGNcIDpFDIMypVpVSRsivlJTRENf+RKwrB6vcf
WlP8dSsE3Rfywq09N0ZfxcBa39V0wsGtkGWC+eQKiz4pBZYKjrc5NOpG9qrxpZxyb4o4yNNwTqza
aPpGRqXB7IMjtf7tTmU2jqPMLxFNe1VXj9XB1rHvbRikw8lBoNoSWY66nJN/VCJv5ym6Q0mdCbDK
CMPybTjoNCQuelc0IAaO4nLUXk0BOSxSxt8kCvsUtQIDAQABo4IBPDCCATgwHwYDVR0jBBgwFoAU
u69+Aj36pvE8hI6t7jiY7NkyMtQwHQYDVR0OBBYEFIKvbIz4xf6WYXzoHz0rcUhexIvAMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMBEGA1UdIAQKMAgwBgYEVR0gADBMBgNVHR8E
RTBDMEGgP6A9hjtodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9u
QXV0aG9yaXR5LmNybDBxBggrBgEFBQcBAQRlMGMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9jcnQuY29t
b2RvY2EuY29tL0NPTU9ET1JTQUFkZFRydXN0Q0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2Nz
cC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQADggIBAHhcsoEoNE887l9Wzp+XVuyPomsX9vP2
SQgG1NgvNc3fQP7TcePo7EIMERoh42awGGsma65u/ITse2hKZHzT0CBxhuhb6txM1n/y78e/4ZOs
0j8CGpfb+SJA3GaBQ+394k+z3ZByWPQedXLL1OdK8aRINTsjk/H5Ns77zwbjOKkDamxlpZ4TKSDM
KVmU/PUWNMKSTvtlenlxBhh7ETrN543j/Q6qqgCWgWuMAXijnRglp9fyadqGOncjZjaaSOGTTFB+
E2pvOUtY+hPebuPtTbq7vODqzCM6ryEhNhzf+enm0zlpXK7q332nXttNtjv7VFNYG+I31gnMrwfH
M5tdhYF/8v5UY5g2xANPECTQdu9vWPoqNSGDt87b3gXb1AiGGaI06vzgkejL580ul+9hz9D0S0U4
jkhJiA7EuTecP/CFtR72uYRBcunwwH3fciPjviDDAI9SnC/2aPY8ydehzuZutLbZdRJ5PDEJM/1t
yZR2niOYihZ+FCbtf3D9mB12D4ln9icgc7CwaxpNSCPt8i/GqK2HsOgkL3VYnwtx7cJUmpvVdZ4o
gnzgXtgtdk3ShrtOS1iAN2ZBXFiRmjVzmehoMof06r1xub+85hFQzVxZx5/bRaTKTlL8YXLI8nAb
R9HWdFqzcOoB/hxfEyIQpx9/s81rgzdEZOofSlZHynoSMYIDyjCCA8YCAQEwga0wgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA4rtJSHkq7AnpxKUY8ZlYZjANBglghkgB
ZQMEAgEFAKCCAe0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjEx
MTE2MTc1NzUzWjAvBgkqhkiG9w0BCQQxIgQgYewX9vjwFZeJtyfip8iOYD8aHjqNH8Nx8pLxbt8p
xm4wgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAB8Gl6QoFxdE/20LIF9etZNc/L/opFkKqKzEhuzg4XCrXXB3ojXQZansKQWkmX/e
AiICe7yxZJJ8p9S9avRpqWXajJiu2yb10hmmP9LrQroO/g4IJSqftzoEs6TTgFO6hmDdKfRpJ99I
u9fO2u44QjIwA4i9JUomx/3f7njBfsQ03ud59346F3Lcgp93DFkXvaqgys9IrbuQmnu+hRtv1vPj
qEjz2Fpre6lkf5fHdxwcGbo4Zvd2cIJniEilpI8Y3BW4JcPDSRse+NBIDUxQd/ghaWnJhqbe6VHe
iQnugcKUm8WCosAMzMh9InDjuwfHyevC5VGfcVhnrkAqZgvQ5b0AAAAAAAA=


--=-G3NDLl7d5+np80R8r6Yn--

