Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0ED929814B
	for <lists+kvm@lfdr.de>; Sun, 25 Oct 2020 11:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415109AbgJYK03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Oct 2020 06:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1414861AbgJYK02 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Oct 2020 06:26:28 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843EBC0613CE;
        Sun, 25 Oct 2020 03:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=K9kntGHFOsOEm1g+OgHWZFiKuRmTvWdOaA5xA4LyyM4=; b=ToY6/cu2DHsTZwhtPoe4SXBuAq
        UW+4v6WdANnJ7+ExOU1FaPL+2hfuamOyVZ9c8XiaETYmYTTkS6LNzbJvX9pbTBpCJe1WC94JtwGwC
        xqYLHl8/1PLX2FqjxFGh9AvWwqODtYidPhPG/chaR/B6LO2zht+POZaykj0RxZ7ZyyD8tCJZpY4ZQ
        xaKVRFtYKKVvkeiknKC5UUvFI82xS3nopTuGffavgNzsvEQ5Mzk97+il8ql97IKGndjQ/aJc90XQs
        pl69aKPPTE4QpeVXkuO/7xqpR7FjqfEh5EH3lgipCKFtX3STcOX864Z90Ygu3Okqb13HgHg0P4d7+
        1UjXsDTA==;
Received: from 54-240-197-234.amazon.com ([54.240.197.234] helo=u3832b3a9db3152.ant.amazon.com)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWdE9-0000Fl-FN; Sun, 25 Oct 2020 10:26:17 +0000
Message-ID: <a7ed5e550628083199e2747b8267c550689a368c.camel@infradead.org>
Subject: Re: [PATCH v3 17/35] x86/pci/xen: Use msi_msg shadow structs
From:   David Woodhouse <dwmw2@infradead.org>
To:     David Laight <David.Laight@ACULAB.COM>,
        "x86@kernel.org" <x86@kernel.org>
Cc:     kvm <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "maz@misterjones.org" <maz@misterjones.org>,
        Dexuan Cui <decui@microsoft.com>
Date:   Sun, 25 Oct 2020 10:26:14 +0000
In-Reply-To: <3e69326016524d97bcdea35d0765cc68@AcuMS.aculab.com>
References: <e6601ff691afb3266e365a91e8b221179daf22c2.camel@infradead.org>
         <20201024213535.443185-1-dwmw2@infradead.org>
         <20201024213535.443185-18-dwmw2@infradead.org>
         <3e69326016524d97bcdea35d0765cc68@AcuMS.aculab.com>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-S2N3L7aHbJOqt6NgSCe8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-S2N3L7aHbJOqt6NgSCe8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2020-10-25 at 09:49 +0000, David Laight wrote:
> Just looking at a random one of these patches...
>=20
> Does the compiler manage to optimise that reasonably?
> Or does it generate a lot of shifts and masks as each
> bitfield is set?
>=20
> The code generation for bitfields is often a lot worse
> that that for |=3D setting bits in a word.

Indeed, it appears to be utterly appalling. That was one of my
motivations for doing it with masks and shifts in the first place.

Because in ioapic_setup_msg_from_msi(), for example, these two are
consecutive in both source and destination:

	entry->vector			=3D msg.arch_data.vector;
	entry->delivery_mode		=3D msg.arch_data.delivery_mode;

And so are those:

	entry->ir_format		=3D msg.arch_addr_lo.dmar_format;
	entry->ir_index_0_14		=3D msg.arch_addr_lo.dmar_index_0_14;

But GCC 7.5.0 here is doing them all separately...

00000000000011e0 <ioapic_setup_msg_from_msi>:
{
    11e0:       53                      push   %rbx
    11e1:       48 89 f3                mov    %rsi,%rbx
    11e4:       48 83 ec 18             sub    $0x18,%rsp
        irq_chip_compose_msi_msg(irq_data, &msg);
    11e8:       48 89 e6                mov    %rsp,%rsi
{
    11eb:       65 48 8b 04 25 28 00    mov    %gs:0x28,%rax
    11f2:       00 00=20
    11f4:       48 89 44 24 10          mov    %rax,0x10(%rsp)
    11f9:       31 c0                   xor    %eax,%eax
        irq_chip_compose_msi_msg(irq_data, &msg);
    11fb:       e8 00 00 00 00          callq  1200 <ioapic_setup_msg_from_=
msi+0x20>
        entry->vector                   =3D msg.arch_data.vector;
    1200:       0f b6 44 24 08          movzbl 0x8(%rsp),%eax
        entry->delivery_mode            =3D msg.arch_data.delivery_mode;
    1205:       0f b6 53 01             movzbl 0x1(%rbx),%edx
    1209:       0f b6 74 24 09          movzbl 0x9(%rsp),%esi
        entry->vector                   =3D msg.arch_data.vector;
    120e:       88 03                   mov    %al,(%rbx)
        entry->dest_mode_logical        =3D msg.arch_addr_lo.dest_mode_logi=
cal;
    1210:       0f b6 04 24             movzbl (%rsp),%eax
        entry->delivery_mode            =3D msg.arch_data.delivery_mode;
    1214:       83 e2 f0                and    $0xfffffff0,%edx
    1217:       83 e6 07                and    $0x7,%esi
        entry->dest_mode_logical        =3D msg.arch_addr_lo.dest_mode_logi=
cal;
    121a:       09 f2                   or     %esi,%edx
    121c:       8d 0c 00                lea    (%rax,%rax,1),%ecx
        entry->ir_format                =3D msg.arch_addr_lo.dmar_format;
    121f:       c0 e8 04                shr    $0x4,%al
        entry->dest_mode_logical        =3D msg.arch_addr_lo.dest_mode_logi=
cal;
    1222:       83 e1 08                and    $0x8,%ecx
    1225:       09 ca                   or     %ecx,%edx
    1227:       88 53 01                mov    %dl,0x1(%rbx)
        entry->ir_format                =3D msg.arch_addr_lo.dmar_format;
    122a:       89 c2                   mov    %eax,%edx
        entry->ir_index_0_14            =3D msg.arch_addr_lo.dmar_index_0_1=
4;
    122c:       8b 04 24                mov    (%rsp),%eax
    122f:       83 e2 01                and    $0x1,%edx
    1232:       c1 e8 05                shr    $0x5,%eax
    1235:       66 25 ff 7f             and    $0x7fff,%ax
    1239:       8d 0c 00                lea    (%rax,%rax,1),%ecx
    123c:       66 c1 e8 07             shr    $0x7,%ax
    1240:       88 43 07                mov    %al,0x7(%rbx)
    1243:       09 ca                   or     %ecx,%edx
}
    1245:       48 8b 44 24 10          mov    0x10(%rsp),%rax
    124a:       65 48 33 04 25 28 00    xor    %gs:0x28,%rax
    1251:       00 00=20
        entry->ir_index_0_14            =3D msg.arch_addr_lo.dmar_index_0_1=
4;
    1253:       88 53 06                mov    %dl,0x6(%rbx)
}
    1256:       75 06                   jne    125e <ioapic_setup_msg_from_=
msi+0x7e>
    1258:       48 83 c4 18             add    $0x18,%rsp
    125c:       5b                      pop    %rbx
    125d:       c3                      retq  =20
    125e:       e8 00 00 00 00          callq  1263 <ioapic_setup_msg_from_=
msi+0x83>
    1263:       0f 1f 00                nopl   (%rax)
    1266:       66 2e 0f 1f 84 00 00    nopw   %cs:0x0(%rax,%rax,1)
    126d:       00 00 00=20


Still, this isn't really a fast path so I'm content to file the GCC PR
for the really *obvious* misses and let it take its course.

--=-S2N3L7aHbJOqt6NgSCe8
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
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
ZQMEAgEFAKCCAe0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAx
MDI1MTAyNjE0WjAvBgkqhkiG9w0BCQQxIgQg+09+/xhI9tS0kNJQtzy576TCIg+gxikOGIbWO+P2
Iwgwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAATPVDUXVr73s4/+6vExqr+R9PGw6Wa+uVWlmvHANzPMJlqglqTQVvCarfeumbig
YictF6bpeGqDavOsLSJbpo8Y0wnXi8IBF47oW7C9+a/qUHOeMEO8YXvbJ2l0wkBD9FsDZcvRMFKo
ymRcFYiyjBB594cI7e+r1vKv6sUNiT4rWaKpME+/iszz+XGi9pTTsDZS+cFNvh5Eeq3UlpCTbC6v
tHRZlAl3qDmO6c6KC5BzGttlwxl8j/EqyOOTzlbNr9WR72UErsxU5XVfXmzyccM3GNI6wjWHRH1i
GJ9GYzFBcDxn/2QiTO7O1ecfV+TkukSPOYFOs4oczZqMcnECtPYAAAAAAAA=


--=-S2N3L7aHbJOqt6NgSCe8--

