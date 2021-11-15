Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E91451598
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 21:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352207AbhKOUnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 15:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346076AbhKOT3w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 14:29:52 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23889C06122D
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 11:11:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FEwcl7nG8wZfBuQGev16txVAVXNCZS6hcks9/bCDEvc=; b=Ag7Dua8xK37cvLg+k6CmgwjmjQ
        Ifv+08VDlKQ+n1WQFmC1yOu/YOs4zJ2SS8LlDjoVK8Kk6ChSDp0Oe1qRdJvo4r284QCbBXPDIYZ06
        C0eUta7s+gEJmz589FFXZMF6TxBs4IZPAaaIwnWfzM3hwBNkfJ8NgOxC4gV8iI7u9RSQqR9DnxZNZ
        f+cjaRNLnU14DHjabz9+5TGnjNnSn3524DHp+G1vn1uSR2k2+3OOGVjP8d6TsvRbWJARhcoKZkWEI
        /0nVw1iP9biB+b547Wz+bzdgoQAvxZrdyRKmaNRSw8kqnul4wRR232/1WiZ/vVQh3Q2o4XHAbHYxo
        DDBvQANg==;
Received: from 54-240-197-235.amazon.com ([54.240.197.235] helo=freeip.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmhNu-00Grrw-C6; Mon, 15 Nov 2021 19:11:18 +0000
Message-ID: <2c7eee5179d67694917a5a0d10db1bce24af61bf.camel@infradead.org>
Subject: Re: [RFC PATCH 0/11] Rework gfn_to_pfn_cache
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, karahmed@amazon.com
Date:   Mon, 15 Nov 2021 19:11:14 +0000
In-Reply-To: <3a2a9a8c-db98-b770-78e2-79f5880ce4ed@redhat.com>
References: <5d4002373c3ae614cb87b72ba5b7cdc161a0cd46.camel@infradead.org>
         <4369bbef7f0c2b239da419c917f9a9f2ca6a76f1.camel@infradead.org>
         <624bc910-1bec-e6dd-b09a-f86dc6cdbef0@redhat.com>
         <0372987a52b5f43963721b517664830e7e6f1818.camel@infradead.org>
         <1f326c33-3acf-911a-d1ef-c72f0a570761@redhat.com>
         <3645b9b889dac6438394194bb5586a46b68d581f.camel@infradead.org>
         <309f61f7-72fd-06a2-84b4-97dfc3fab587@redhat.com>
         <96cef64bf7927b6a0af2173b0521032f620551e4.camel@infradead.org>
         <40d7d808-dce6-a541-18dc-b0c7f4d6586c@redhat.com>
         <2b400dbb16818da49fb599b9182788ff9896dcda.camel@infradead.org>
         <32b00203-e093-8ffc-a75b-27557b5ee6b1@redhat.com>
         <28435688bab2dc1e272acc02ce92ba9a7589074f.camel@infradead.org>
         <4c37db19-14ed-46b8-eabe-0381ba879e5c@redhat.com>
         <537fdcc6af80ba6285ae0cdecdb615face25426f.camel@infradead.org>
         <7e4b895b-8f36-69cb-10a9-0b4139b9eb79@redhat.com>
         <95fae9cf56b1a7f0a5f2b9a1934e29e924908ff2.camel@infradead.org>
         <3a2a9a8c-db98-b770-78e2-79f5880ce4ed@redhat.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-BdMm4S4Sqn65mKfyhIFo"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-BdMm4S4Sqn65mKfyhIFo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-11-15 at 19:50 +0100, Paolo Bonzini wrote:
> On 11/15/21 17:47, David Woodhouse wrote:
> > So... a user of this must check the validity after setting its mode to
> > IN_GUEST_MODE, and the invalidation must make a request and wake any
> > vCPU(s) which might be using it.
>=20
> Yes, though the check is implicit in the existing call to=20
> kvm_vcpu_exit_request(vcpu).

Right, though *handling* the request isn't (and I'm still not sure
whether to use a single new KVM_REQ_GPC_INVALIDATE or let the user of
the cache specify the req to use).

I don't really want generic code refreshing these caches even when they
aren't going to be used (e.g. vmcs02 for a vCPU that isn't even in L2
guest mode right now).

> > I moved the invalidation to the invalidate_range MMU notifier, as
> > discussed. But that's where the plan falls down a little bit because
> > IIUC, that one can't sleep at all.
>=20
> Which is a problem in the existing code, too.  It hasn't broken yet=20
> because invalidate_range() is _usually_ called with no spinlocks taken=
=20
> (the only caller that does call with a spinlock taken seems to be=20
> hugetlb_cow).
>=20
> Once the dust settles, we need to add non_block_start/end around calls=
=20
> to ops->invalidate_range.
>=20
> > I need to move it *back*  to
> > invalidate_range_start() where I had it before, if I want to let it
> > wait for vCPUs to exit. Which means... that the cache 'refresh' call
> > must wait until the mmu_notifier_count reaches zero? Am I allowed to do=
 > that, and make the "There can be only one waiter" comment in
> > kvm_mmu_notifier_invalidate_range_end() no longer true?
>=20
> You can also update the cache while taking the mmu_lock for read, and=20
> retry if mmu_notifier_retry_hva tells you to do so.  Looking at the=20
> scenario from commit e649b3f0188 you would have:
>=20
>        (Invalidator) kvm_mmu_notifier_invalidate_range_start()
>        (Invalidator) write_lock(mmu_lock)
>        (Invalidator) increment mmu_notifier_count
>        (Invalidator) write_unlock(mmu_lock)
>        (Invalidator) request KVM_REQ_APIC_PAGE_RELOAD
>        (KVM VCPU) vcpu_enter_guest()
>        (KVM VCPU) kvm_vcpu_reload_apic_access_page()
>     +  (KVM VCPU) read_lock(mmu_lock)
>     +  (KVM VCPU) mmu_notifier_retry_hva()
>     +  (KVM VCPU) read_unlock(mmu_lock)
>     +  (KVM VCPU) retry! (mmu_notifier_count>1)


But unless we do start using a waitq, it can just spin and spin and
spin here can't it?=20

    +  (KVM VCPU) read_lock(mmu_lock)>
    +  (KVM VCPU) mmu_notifier_retry_hva()>  =20
    +  (KVM VCPU) read_unlock(mmu_lock)>  =20
    +  (KVM VCPU) retry! (mmu_notifier_count>1)

    +  (KVM VCPU) read_lock(mmu_lock)>
    +  (KVM VCPU)
mmu_notifier_retry_hva()>  =20
    +  (KVM VCPU) read_unlock(mmu_lock)>  =20
    +  (KVM VCPU) retry! (mmu_notifier_count>1)

    +  (KVM VCPU) read_lock(mmu_lock)>
    +  (KVM VCPU)
mmu_notifier_retry_hva()>  =20
    +  (KVM VCPU) read_unlock(mmu_lock)>  =20
    +  (KVM VCPU) retry! (mmu_notifier_count>1)

>        (Invalidator) actually unmap page

    +  (KVM VCPU) read_lock(mmu_lock)>
    +  (KVM VCPU) mmu_notifier_retry_hva()>  =20
    +  (KVM VCPU) read_unlock(mmu_lock)>  =20
    +  (KVM VCPU) retry! (mmu_notifier_count>1)

    +  (KVM VCPU) read_lock(mmu_lock)>
    +  (KVM VCPU)
mmu_notifier_retry_hva()>  =20
    +  (KVM VCPU) read_unlock(mmu_lock)>  =20
    +  (KVM VCPU) retry! (mmu_notifier_count>1)

>     +  (Invalidator) kvm_mmu_notifier_invalidate_range_end()
>     +  (Invalidator) write_lock(mmu_lock)
>     +  (Invalidator) decrement mmu_notifier_count
>     +  (Invalidator) write_unlock(mmu_lock)
>     +  (KVM VCPU) vcpu_enter_guest()
>     +  (KVM VCPU) kvm_vcpu_reload_apic_access_page()
>     +  (KVM VCPU) mmu_notifier_retry_hva()
>=20
> Changing mn_memslots_update_rcuwait to a waitq (and renaming it to=20
> mn_invalidate_waitq) is of course also a possibility.

I suspect that's the answer.

I think the actual *invalidation* of the cache still lives in the
invalidate_range() callback where I have it at the moment. But making
the req to the affected vCPUs can live in invalidate_range_start(). And
then the code which *handles* that req can wait for the
mmu_notifier_count to reach zero before it proceeds. Atomic users of
the cache (like the Xen event channel code) don't have to get involved
with that.

> Also, for the small requests: since you are at it, can you add the code=
=20
> in a new file under virt/kvm/?

Hm... only if I can make hva_to_pfn() and probably a handful of other
things non-static?



--=-BdMm4S4Sqn65mKfyhIFo
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
MTE1MTkxMTE0WjAvBgkqhkiG9w0BCQQxIgQg/pI+dveYUseoEo+kdoD4JEWfRMFrYGC26z5VzPie
y44wgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAA8sKuPlM0QbVfUQoj882w3Ks8vZ3dhfjPnC7awoJq4v7ov+bEv+lDZzlO78ThBu
iGRFInNXHeUlSGEOFgYmUSmoRXUJjN3kYhzr0o1iydLJyuQ0811/n5uEyRJoYmaeytenAXtv/ifM
tkJMXIjvqrli7s80PIF9Uz9YF4ZKg1Xc1FxHDc29kJsqDJWJxzN+PZ9QnRBIBe6yk1I6rJ1knMo1
oUBV4RgI3CZzsZkwm0x7Dt7/5HshXrW92d9cSSAxhp12Sco64Gl0f8djQMVNAgN8GOqNZfqoOgI1
b3dEF7hIE+eGtSahS50Rycux3HVpssLET+Ov8YCLWEcd9iwnqhoAAAAAAAA=


--=-BdMm4S4Sqn65mKfyhIFo--

