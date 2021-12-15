Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5FD475BAE
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 16:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243869AbhLOPQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 10:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242637AbhLOPQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 10:16:47 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C00AC061574;
        Wed, 15 Dec 2021 07:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=B4tpyQga7SH+7JGSMwW7fY4N3Vkn2z/AXyXu7q+/GAg=; b=d2NhVMFQtnUHLgOY/a42pNO4zb
        jZP0ORdf1Xj0s9Glneacaa8TV/kjMf56Lu0mXSswtnnT12AKLh0n4NS287cCdgiQMc3ROlfLSPlo/
        u/0Uy759pFo1hEUu5bhK83WECfAjU86QOcIrUOjbdxLxspvc4JK4EinB2FM+zaf/nIR4P1nGp/EAX
        uFVB6BD3NM3fZkQUlLxblvdKPN08v+WMsHAuMzVTD9H+VHveVEpKHqpdpXam3ABlsu1Mfq8UI4rs7
        1xKw0mlTrSq4IM66F1gSnQz+/QsstTW8yOOyFvn4PEY1xO1UpB/xFfx8Ubjh+7Qib6ko08hXrqj+z
        ihHVFhoQ==;
Received: from [2001:8b0:10b:1::3ae] (helo=u3832b3a9db3152.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxW15-001K2L-0I; Wed, 15 Dec 2021 15:16:27 +0000
Message-ID: <fed94af87bdfa94287b98a5e681cf374aecffa9d.camel@infradead.org>
Subject: Re: [PATCH v2 3/7] cpu/hotplug: Add dynamic parallel bringup states
 before CPUHP_BRINGUP_CPU
From:   David Woodhouse <dwmw2@infradead.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com
Date:   Wed, 15 Dec 2021 15:16:22 +0000
In-Reply-To: <YbnNLkXTOtFiDMpc@FVFF77S0Q05N>
References: <20211214123250.88230-1-dwmw2@infradead.org>
         <20211214123250.88230-4-dwmw2@infradead.org>
         <YbipFmlKSf1UuisZ@FVFF77S0Q05N>
         <d48f836d202d3b76b2a6cbaaf3d57f0c8077d986.camel@infradead.org>
         <YbnNLkXTOtFiDMpc@FVFF77S0Q05N>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-VjU8phqa4WulPKIa+BnH"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-VjU8phqa4WulPKIa+BnH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-12-15 at 11:10 +0000, Mark Rutland wrote:
> On Tue, Dec 14, 2021 at 08:32:29PM +0000, David Woodhouse wrote:
> > On Tue, 2021-12-14 at 14:24 +0000, Mark Rutland wrote:
> > > On Tue, Dec 14, 2021 at 12:32:46PM +0000, David Woodhouse wrote:
> > > > From: David Woodhouse <
> > > > dwmw@amazon.co.uk
> > > >=20
> > > >=20
> > > > If the platform registers these states, bring all CPUs to each regi=
stered
> > > > state in turn, before the final bringup to CPUHP_BRINGUP_CPU. This =
allows
> > > > the architecture to parallelise the slow asynchronous tasks like se=
nding
> > > > INIT/SIPI and waiting for the AP to come to life.
> > > >=20
> > > > There is a subtlety here: even with an empty CPUHP_BP_PARALLEL_DYN =
step,
> > > > this means that *all* CPUs are brought through the prepare states a=
nd to
> > > > CPUHP_BP_PREPARE_DYN before any of them are taken to CPUHP_BRINGUP_=
CPU
> > > > and then are allowed to run for themselves to CPUHP_ONLINE.
> > > >=20
> > > > So any combination of prepare/start calls which depend on A-B order=
ing
> > > > for each CPU in turn, such as the X2APIC code which used to allocat=
e a
> > > > cluster mask 'just in case' and store it in a global variable in th=
e
> > > > prep stage, then potentially consume that preallocated structure fr=
om
> > > > the AP and set the global pointer to NULL to be reallocated in
> > > > CPUHP_X2APIC_PREPARE for the next CPU... would explode horribly.
> > > >=20
> > > > We believe that X2APIC was the only such case, for x86. But this is=
 why
> > > > it remains an architecture opt-in. For now.
> > >=20
> > > It might be worth elaborating with a non-x86 example, e.g.
> > >=20
> > > >  We believe that X2APIC was the only such case, for x86. Other arch=
itectures
> > > >  have similar requirements with global variables used during bringu=
p (e.g.
> > > >  `secondary_data` on arm/arm64), so architectures must opt-in for n=
ow.
> > >=20
> > > ... so that we have a specific example of how unconditionally enablin=
g this for
> > > all architectures would definitely break things today.
> >=20
> > I do not have such an example, and I do not know that it would
> > definitely break things to turn it on for all architectures today.
> >=20
> > The x2apic one is an example of why it *might* break random
> > architectures and thus why it needs to be an architecture opt-in.
>=20
> Ah; I had thought we did the `secondary_data` setup in a PREPARE step, an=
d
> hence it was a comparable example, but I was mistaken. Sorry for the nois=
e!
>=20

Right, that's entirely within your __cpu_up(). You can stare at
Thomas's patch for inspiration on how to cope with that one.

In arch/arm64/kernel/smp.c you have a comment saying

 * as from 2.5, kernels no longer have an init_tasks structure
 * so we need some other way of telling a new secondary core
 * where to place its SVC stack

In x86, the idle task pointer is in the per_cpu data. The real mode
bringup now starts with the CPU's APICID (which it can get from CPUID),
looks that up in the cpuid_to_apicid[] array to find the CPU#, then
finds its own per_cpu data, and gets everything else it needs
(including the initial stack) from there.

> > > FWIW, that's something I would like to cleanup for arm64 for general
> > > robustness, and if that would make it possible for us to have paralle=
l bringup
> > > in future that would be a nice bonus.
> >=20
> > Yes. But although I lay the groundwork here, the arch can't *actually*
> > do parallel bringup without some arch-specific work, so auditing the
> > pre-bringup states is the easy part. :)
>=20
> Sure; that was trying to be a combination of:
>=20
> * This looks nice, I'd like to use this (eventually) on arm64.
>=20
> * I'm aware of some arm64-specific groundwork we need to do before arm64 =
can
>   use this.
>=20
> So I think we're agreed. :)

I'd love to have at least one more architecture come along for the ride
as I do the next step. After this series, the largest chunk of time
seems to be spent waiting for each AP as they transition to
CPUHP_AP_ONLINE_IDLE and then all the way to CPUHP_ONLINE.

So I'm going to look at making bringup_nonboot_cpus() prod *all* the
APs to move to CPUHP_AP_ONLINE_IDLE without waiting for them to get
there. Then do another pass waiting for that and prodding them to move
to CPUHP_ONLINE. And then do a final pass of waiting for them to have
got *there*.


> > +     int n =3D setup_max_cpus - num_online_cpus();
> > +
> > +     /* =E2=88=80 parallel pre-bringup state, bring N CPUs to it */
>=20
> I see you have a fancy maths keyboard. ;)

Nah, standard UK layout keyboard. I just happen to remember U+2200 as
it's *right* at the beginning of the mathematical symbols block and is
fairly easy to type ;)

> It might be worth using a few more words here for clarity, e.g.
>=20
>        /*
>         * Bring all nonboot CPUs through each pre-bringup state in turn
>         */

But it isn't *all* nonboot CPUs; it really is only up to N of them.

--=-VjU8phqa4WulPKIa+BnH
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
MjE1MTUxNjIyWjAvBgkqhkiG9w0BCQQxIgQgudemqi8NlL9ncPFHrItct2sMSBqwRr247/pXtEEs
PJwwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAILt+OFkVqqc7rDtVMu4ABuQ4mAsW6GttclLHjUB1B832BLSbdaes6I7sGSNdVp6
KIPREAsqme0l1T1nZ5s6yYiLhtXchSyGfn/ZuHSfs09N5V3RTR/zUuRSJ5doerqzZYTxnrPLnuPm
MBApA9fk5rgxanu8Z5yuSxSSi5E6ijQfKTUt2Yi45h+ntasJt7GezzYfqmxOsOpGEdec7gxHjiYX
39dVW/GyjGvmZCpwVb4BjA+HaHcAZIiw56fhDpT3tkZZvuBor1fcO/8pm1d1gJx+vlG6gIPiFHRn
nIHVhcPQXeUn3cBOTpdNnv35CL+0Ik0+c/Leiv5OHsWZ/OZMi9UAAAAAAAA=


--=-VjU8phqa4WulPKIa+BnH--

