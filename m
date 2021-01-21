Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B49C2FE96C
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 12:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730047AbhAUL5l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 06:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730547AbhAUL50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 06:57:26 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5805FC061575
        for <kvm@vger.kernel.org>; Thu, 21 Jan 2021 03:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vnNlHU/DwLqyssXE2JRJrC1Mp8T9L2H4Mh9a8jTMNUU=; b=KpmVeLGT5dsGo/Yrn6kysQwZVB
        5Jx8gLhpnDe1gEGTiUvH3GSWwfqp3telYrvjdlNW+j/m414rx9uO+oukKWrV3y2HA7b4KGbWMBt3k
        Xnwxw0JQcmTghinDaP8osunWHm88m3NQMpQy4VG79+pxsmUqmZ3l+BWtXeXZhRDutyNdqudI6xSyI
        JzRUO+w8aUZZQ0BbULOiG8jHa+RlAXdJkuaVzabq45c+GNoPqzJWRHlFwqBQvdmUVd83GoyErJ1E6
        L4VdZKa3aGQk0/lcL/qShy91v1qzyEvkkZYrgmjGhee6mBL8rXr/5MfM0qY1cMKi3Q7L5jaYEuAqE
        GTxjc5vg==;
Received: from 54-240-197-236.amazon.com ([54.240.197.236] helo=freeip.amazon.com)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l2YZm-0006uR-BP; Thu, 21 Jan 2021 11:56:35 +0000
Message-ID: <4df34bfb46e5c545dea3517fc6475f56ef2cb358.camel@infradead.org>
Subject: [PATCH v5 17/16] KVM: x86/xen: Fix initialisation of gfn caches for
 Xen shared pages
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Date:   Thu, 21 Jan 2021 11:56:30 +0000
In-Reply-To: <20210111195725.4601-1-dwmw2@infradead.org>
References: <20210111195725.4601-1-dwmw2@infradead.org>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-/q5ajtz+Cjb1iuWE8c4J"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-/q5ajtz+Cjb1iuWE8c4J
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Woodhouse <dwmw@amazon.co.uk>

When kvm_gfn_to_hva_cache_init() is used to cache the address of the
guest pages which KVM needs to access, it uses kvm_memslots(). For
which an RCU read lock is required. Add that around the whole of
the kvm_xen_hvm_set_attr() function.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
This should fix the RCU warning reported by the 'kernel test robot'.

Paolo, please let me know if you're prefer to fold this in to the
original patch or whether it's OK as a 17th patch in the series.

I've pushed this on top for now, at
 https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/xenpv

 arch/x86/kvm/xen.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 4bc9da9fcfb8..3041f774493e 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -219,11 +219,14 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_=
xen_hvm_attr *data)
 {
 	struct kvm_vcpu *v;
 	int r =3D -ENOENT;
+	int idx =3D srcu_read_lock(&kvm->srcu);
=20
 	switch (data->type) {
 	case KVM_XEN_ATTR_TYPE_LONG_MODE:
-		if (!IS_ENABLED(CONFIG_64BIT) && data->u.long_mode)
-			return -EINVAL;
+		if (!IS_ENABLED(CONFIG_64BIT) && data->u.long_mode) {
+			r =3D -EINVAL;
+			break;
+		}
=20
 		kvm->arch.xen.long_mode =3D !!data->u.long_mode;
 		r =3D 0;
@@ -235,8 +238,11 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_x=
en_hvm_attr *data)
=20
 	case KVM_XEN_ATTR_TYPE_VCPU_INFO:
 		v =3D kvm_get_vcpu_by_id(kvm, data->u.vcpu_attr.vcpu_id);
-		if (!v)
-			return -EINVAL;
+		if (!v) {
+			r =3D -EINVAL;
+			break;
+		}
+
 		/* No compat necessary here. */
 		BUILD_BUG_ON(sizeof(struct vcpu_info) !=3D
 			     sizeof(struct compat_vcpu_info));
@@ -247,7 +253,7 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xe=
n_hvm_attr *data)
 					      data->u.vcpu_attr.gpa,
 					      sizeof(struct vcpu_info));
 		if (r)
-			return r;
+			break;
=20
 		v->arch.xen.vcpu_info_set =3D true;
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
@@ -255,14 +261,16 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_=
xen_hvm_attr *data)
=20
 	case KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO:
 		v =3D kvm_get_vcpu_by_id(kvm, data->u.vcpu_attr.vcpu_id);
-		if (!v)
-			return -EINVAL;
+		if (!v) {
+			r =3D -EINVAL;
+			break;
+		}
=20
 		r =3D kvm_gfn_to_hva_cache_init(kvm, &v->arch.xen.vcpu_time_info_cache,
 					      data->u.vcpu_attr.gpa,
 					      sizeof(struct pvclock_vcpu_time_info));
 		if (r)
-			return r;
+			break;
=20
 		v->arch.xen.vcpu_time_info_set =3D true;
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
@@ -270,14 +278,16 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_=
xen_hvm_attr *data)
=20
 	case KVM_XEN_ATTR_TYPE_VCPU_RUNSTATE:
 		v =3D kvm_get_vcpu_by_id(kvm, data->u.vcpu_attr.vcpu_id);
-		if (!v)
-			return -EINVAL;
+		if (!v) {
+			r =3D -EINVAL;
+			break;
+		}
=20
 		r =3D kvm_gfn_to_hva_cache_init(kvm, &v->arch.xen.runstate_cache,
 					      data->u.vcpu_attr.gpa,
 					      sizeof(struct vcpu_runstate_info));
 		if (r)
-			return r;
+			break;
=20
 		v->arch.xen.runstate_set =3D true;
 		v->arch.xen.current_runstate =3D RUNSTATE_blocked;
@@ -285,8 +295,10 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_x=
en_hvm_attr *data)
 		break;
=20
 	case KVM_XEN_ATTR_TYPE_UPCALL_VECTOR:
-		if (data->u.vector < 0x10)
-			return -EINVAL;
+		if (data->u.vector < 0x10) {
+			r =3D -EINVAL;
+			break;
+		}
=20
 		kvm->arch.xen.upcall_vector =3D data->u.vector;
 		r =3D 0;
@@ -296,6 +308,7 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xe=
n_hvm_attr *data)
 		break;
 	}
=20
+	srcu_read_unlock(&kvm->srcu, idx);
 	return r;
 }
=20
--=20
2.17.1


--=-/q5ajtz+Cjb1iuWE8c4J
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
MTIxMTE1NjMwWjAvBgkqhkiG9w0BCQQxIgQgJunKmWEavgmli/ZxaIC+g2rFV50JnBg51tadF+0H
ijUwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAFhQpR7Y+u4/luTxnySan69m8C60jg33J+fkAcldLQXeO6JAM4gKu/wJRzKmnNy4
2rruIlVjqsQOztjHQQo0iP8/h2eAYLn2fX2z1KVbdm72fLc38IgzhEUpapny9K9fm1nw8Llss/wG
Me+qJrv2B3BgNTNVoZPsdffiNsKw1NUnu/mqAgXA/1B50FwkwAKrnwd+SJWbdF+YNNchtRDj0whu
EHHIPCg+YANMo6ovFJ1CcWYX7LVzdRzIHTbXw3X1JcHz+bpHa9mNjx8xZyDyvhIaQgv3IDscAopr
DAipCVpzwfuHtPcVf1bBCc2wXHPV+Y8Lk/rrH6G0ussEysdKtwAAAAAAAAA=


--=-/q5ajtz+Cjb1iuWE8c4J--

