Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34713079DC
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 16:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbhA1PgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 10:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhA1Pf6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 10:35:58 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC13C061573
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 07:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bEOInGIAvNtUY7cUtNDbUYsZYTs4hAsWsUlKBQ5MJdQ=; b=JxJvxVJ3Xal41ZqtUWRlEf6Lnx
        +ldVWbRM3fCD0NXyDWvGB2ndhaslnSktMCX7/u+dQtlnQPqP/4gOwQFUCCVq4WgtvJkJU+AUoqxTs
        FaG2WpdlZb3Mb9034qgTou3zAVS4A1uB2uBYf0SP64uTFi6qoPcybufIPdaas9CqYIP9dMkIi8mCq
        jrSz6Qocw85Pwrcp8ep28WUXHHROjNlCIwWHI5+ndDUjrlbfFflO7OiVII8K5SPJfMKOFllcTzwc3
        nwAHWWIt12Vpdbj5cnozWR92675nRpaWX5/Z0kcb6Zz9dhodOE2YwZcUdIjRKPM3pU8sxRAKc3CZo
        2xR+kgQQ==;
Received: from 54-240-197-232.amazon.com ([54.240.197.232] helo=u3832b3a9db3152.ant.amazon.com)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l59KB-0000xk-PQ; Thu, 28 Jan 2021 15:35:12 +0000
Message-ID: <0f210bea8a8d800f5a36c8ac8abbcc4b0dd6c02c.camel@infradead.org>
Subject: Re: [PATCH v5 16/16] KVM: x86/xen: Add event channel interrupt
 vector upcall
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Date:   Thu, 28 Jan 2021 15:35:09 +0000
In-Reply-To: <3b66ee62-bf12-c6ab-a954-a66e5f31f109@redhat.com>
References: <20210111195725.4601-1-dwmw2@infradead.org>
         <20210111195725.4601-17-dwmw2@infradead.org>
         <3b66ee62-bf12-c6ab-a954-a66e5f31f109@redhat.com>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-ncAhpC6axlaExEbNZTWv"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-ncAhpC6axlaExEbNZTWv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-01-28 at 13:43 +0100, Paolo Bonzini wrote:
> On 11/01/21 20:57, David Woodhouse wrote:
> > From: David Woodhouse <dwmw@amazon.co.uk>
> >=20
> > It turns out that we can't handle event channels *entirely* in userspac=
e
> > by delivering them as ExtINT, because KVM is a bit picky about when it
> > accepts ExtINT interrupts from a legacy PIC. The in-kernel local APIC
> > has to have LVT0 configured in APIC_MODE_EXTINT and unmasked, which
> > isn't necessarily the case for Xen guests especially on secondary CPUs.
> >=20
> > To cope with this, add kvm_xen_get_interrupt() which checks the
> > evtchn_pending_upcall field in the Xen vcpu_info, and delivers the Xen
> > upcall vector (configured by KVM_XEN_ATTR_TYPE_UPCALL_VECTOR) if it's
> > set regardless of LAPIC LVT0 configuration. This gives us the minimum
> > support we need for completely userspace-based implementation of event
> > channels.
> >=20
> > This does mean that vcpu_enter_guest() needs to check for the
> > evtchn_pending_upcall flag being set, because it can't rely on someone
> > having set KVM_REQ_EVENT unless we were to add some way for userspace t=
o
> > do so manually.
> >=20
> > But actually, I don't quite see how that works reliably for interrupts
> > injected with KVM_INTERRUPT either. In kvm_vcpu_ioctl_interrupt() the
> > KVM_REQ_EVENT request is set once, but that'll get cleared the first ti=
me
> > through vcpu_enter_guest(). So if the first exit is for something *else=
*
> > without interrupts being enabled yet, won't the KVM_REQ_EVENT request
> > have been consumed already and just be lost?
>=20
> If the call is for something else and there is an interrupt,=20
> inject_pending_event sets *req_immediate_exit to true.  This causes an=
=20
> immediate vmexit after vmentry, and also schedules another KVM_REQ_EVENT=
=20
> processing.
>=20
> If the call is for an interrupt but you cannot process it yet (IF=3D0,=
=20
> STI/MOVSS window, etc.), inject_pending_event calls=20
> kvm_x86_ops.enable_irq_window and this will cause KVM_REQ_EVENT to be=20
> sent again.

Ah, OK. I see it now; thanks.

> How do you inject the interrupt from userspace?=20

The VMM injects the interrupt purely by setting ->evtchn_upcall_pending
in the vcpu_info. That is actually also a Xen guest ABI =E2=80=94 guests ca=
n
retrigger the vector purely by setting ->evtchn_upcall_pending in their
own vcpu_info and doing anything which triggers a vmexit.

Xen checks it and potentially injects the vector, each time it enters
the guest =E2=80=94 just as I've done it here in vcpu_enter_guest().

> IIRC evtchn_upcall_pending is written by the hypervisor upon receiving=
=20
> a hypercall, so wouldn't you need the "dom0" to invoke a KVM_INTERRUPT=
=20
> ioctl (e.g. with irq =3D=3D 256)?  That KVM_INTERRUPT will set KVM_REQ_EV=
ENT.

Well, right now that would return -EINVAL, so you're suggesting we add
a special case code path to kvm_vcpu_ioctl_interrupt which just sets
KVM_REQ_EVENT without calling kvm_queue_interrupt(), in the case where
irq->irq =3D=3D KVM_NR_INTERRUPTS?

Then we require that the userspace VMM make that ioctl not only when
it's set ->evtchn_upcall_pending for itself, but *also* poll for the
guest having done so?

In fact, not only the VMM would have to do that polling, but we'd
probably also have to do it on any hypercalls we accelerate in the
kernel (as we're planning to do for IPIs, etc.)

So it has to live in the kernel anyway in *some* form.

So requiring KVM_REQ_EVENT to be set manually probably ends up being
more complex than just checking it directly in vcpu_enter_guest() as I
have done here.

Even before the static key improvement you suggest below, it's a fairly
lightweight check in the common case. If the vcpu_info is set and the
memslots didn't change, it's a single dereference of a userspace
pointer which will rarely fault and need any handling.

> If you want to write a testcase without having to write all the=20
> interrupt stuff in the selftests framework, you could set an IDT that=20
> has room only for 128 vectors and use interrupt 128 as the upcall=20
> vector.  Then successful delivery of the vector will cause a triple fault=
.

Yeah, my testing of this part so far consists of actually booting Xen
guests =E2=80=94 delivery of event channel vectors was the final thing we
needed to make them actually work. I'm planning to come back and work
out how to do a more comprehensive self-test once I do the in-kernel
IPI acceleration and polling support.

I really think I'll have to come up with something better than "I can
make it crash" for those more complex tests, so I haven't bothered with
doing that as an interim step for the basic vector delivery.

> Independent of the answer to the above, this is really the only place=20
> where you're adding Xen code to a hot path.  Can you please use a=20
> STATIC_KEY_FALSE kvm_has_xen_vcpu (and a static inline function) to=20
> quickly return from kvm_xen_has_interrupt() if no vCPU has a shared info=
=20
> set up?

Ack. I'll do that.

--=-ncAhpC6axlaExEbNZTWv
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
ZQMEAgEFAKCCAe0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjEw
MTI4MTUzNTA5WjAvBgkqhkiG9w0BCQQxIgQgQinSBNBJKHjH2o9NafP13WkKBpDIqLMvqCIbtyz0
3wwwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAJQXY/VdCTTN6YhlZact4q1f6rf/oGY54l+lAM/upJdBoht06T73r/RqIgNmqL3O
JBK+fyA/HJhImTowVpI/hXPxwe/nohAiUSSm4yAsoGCliDwITv7clODsaI6qGE/c79SNWUPzBgpU
FzgUOhSdvAApgBQWas45k995Lon7RPe6/FD4RSFM3Lomfju1ikZD9ZN5htTnG/XxhaB23nLNI+mN
5O7z3rNYIqAAAj7npVp7B1IiGni0daB6AwddxzlchAGEa20/qAH93saARCojcLO+0tlpnwS4ZalD
/+ld9iPc9b/Ex5buz7I88fhdIP9HcLcyHYXuQ7+RJxNgB588wOwAAAAAAAA=


--=-ncAhpC6axlaExEbNZTWv--

