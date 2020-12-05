Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798A22CFB0E
	for <lists+kvm@lfdr.de>; Sat,  5 Dec 2020 11:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729176AbgLEKun (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Dec 2020 05:50:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729287AbgLEKtR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Dec 2020 05:49:17 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CBAC0613D1
        for <kvm@vger.kernel.org>; Sat,  5 Dec 2020 02:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eECd5mkLsgdqXNLzMqvy/bzvnMJZC8fr7NUxnjkS4S0=; b=kIvjiOGNGC6Gqd30hgkQtSpCep
        W8v6R27SB1Pg4QqP0bGAaeim2e6pG17iMUbDIeYpsgj6kcbfyoLRdNddtV8neh5t1KFtKnRsPhjPf
        aunKG6lY1v7oNbH2T5DdG4g0O52+bDBILg3SvCHscgPJKhPqYlbj2Vgg6WP0SYuG4i1PBuDz1ZjHN
        05X83PQO2A6WdkKhxTLWmltRs0GqyWxAH3cTZhJUQmuXFxxyitPeCU4zbxQi07W+BkUfCkuO0k7zp
        rYX7encwHTVfV3xUjGhq+7cxRnIAFAQtOWJA9bmRdCpngtFvDhWD8CoLa2znI6VuOm8IToYwzc+gR
        11UHjfow==;
Received: from dyn-227.woodhou.se ([90.155.92.227] helo=u3832b3a9db3152.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1klV7B-0005y6-Li; Sat, 05 Dec 2020 10:48:34 +0000
Message-ID: <b127a74fbb45ee016eaa3e90cde89d849142584c.camel@infradead.org>
Subject: Re: [PATCH 00/15] KVM: Add Xen hypercall and shared info pages
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Sat, 05 Dec 2020 10:48:30 +0000
In-Reply-To: <20201204011848.2967588-1-dwmw2@infradead.org>
References: <20201204011848.2967588-1-dwmw2@infradead.org>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-tI3bZjrwefhwqaj0Tz5g"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-tI3bZjrwefhwqaj0Tz5g
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-12-04 at 01:18 +0000, David Woodhouse wrote:
> Reviving the first section (so far) of a patch set that Joao posted as=
=20
> RFC last year:
>=20
> https://lore.kernel.org/kvm/20190220201609.28290-1-joao.m.martins@oracle.=
com/
>=20
> This adds basic hypercall interception support, and adds support for
> timekeeping and runstate-related shared info regions.
>=20
> I've updated and reworked the original a bit, including:
>  =E2=80=A2 Support for 32-bit guests
>  =E2=80=A2 64-bit second support in wallclock
>  =E2=80=A2 Time counters for runnable/blocked states in runstate support
>  =E2=80=A2 Self-tests
>  =E2=80=A2 Fixed Viridian coexistence
>  =E2=80=A2 No new KVM_CAP_XEN_xxx, just more bits returned by KVM_CAP_XEN=
_HVM
>=20
> I'm about to do the event channel support, but this part stands alone
> and should be sufficient to get a fully functional Xen HVM guest running.

I also realise I forgot to include the RCU read-critical sections
around using the pointers that might get invalidated. (This is the
model I think can we use for the KVM pvclock and other pages that we
currently pin too, FWIW.)

That looks a bit like this. Unless there's any other useful and
relevant feedback I'll post a V2 of the series over the weekend or on
Monday.

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index e49e59f93828..4aa776c1ad57 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -86,19 +86,21 @@ static void *xen_vcpu_info(struct kvm_vcpu *v)
 {
 	struct kvm_vcpu_xen *vcpu_xen =3D vcpu_to_xen_vcpu(v);
 	struct kvm_xen *kvm =3D &v->kvm->arch.xen;
-	unsigned int offset =3D 0;
-	void *hva =3D NULL;
+	void *hva;
=20
-	if (vcpu_xen->vcpu_info)
-		return vcpu_xen->vcpu_info;
+	hva =3D READ_ONCE(vcpu_xen->vcpu_info);
+	if (hva)
+		return hva;
=20
-	if (kvm->shinfo && v->vcpu_id < MAX_VIRT_CPUS) {
-		hva =3D kvm->shinfo;
-		offset +=3D offsetof(struct shared_info, vcpu_info);
-		offset +=3D v->vcpu_id * sizeof(struct vcpu_info);
+	if (v->vcpu_id < MAX_VIRT_CPUS)
+		hva =3D READ_ONCE(kvm->shinfo);
+
+	if (hva) {
+		hva +=3D offsetof(struct shared_info, vcpu_info);
+		hva +=3D v->vcpu_id * sizeof(struct vcpu_info);
 	}
=20
-	return hva + offset;
+	return hva;
 }
=20
 static void kvm_xen_update_vcpu_time(struct kvm_vcpu *v,
@@ -139,6 +141,7 @@ static void kvm_xen_update_runstate(struct kvm_vcpu *vc=
pu, int state, u64 steal_
 	struct compat_vcpu_runstate_info *runstate;
 	u32 *runstate_state;
 	u64 now, delta;
+	int idx;
=20
 	BUILD_BUG_ON(sizeof(struct compat_vcpu_runstate_info) !=3D 0x2c);
 	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) !=3D
@@ -146,7 +149,8 @@ static void kvm_xen_update_runstate(struct kvm_vcpu *vc=
pu, int state, u64 steal_
 	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->state) !=3D
 		     sizeof(((struct compat_vcpu_runstate_info *)0)->state));
=20
-	runstate =3D vcpu_xen->runstate;
+	idx =3D srcu_read_lock(&vcpu->kvm->srcu);
+	runstate =3D READ_ONCE(vcpu_xen->runstate);
 	runstate_state =3D &runstate->state;
=20
 #ifdef CONFIG_64BIT
@@ -185,6 +189,8 @@ static void kvm_xen_update_runstate(struct kvm_vcpu *vc=
pu, int state, u64 steal_
=20
 	runstate->state_entry_time &=3D ~XEN_RUNSTATE_UPDATE;
 	smp_wmb();
+
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 }
=20
 void kvm_xen_runstate_set_preempted(struct kvm_vcpu *vcpu)
@@ -228,7 +234,9 @@ void kvm_xen_setup_runstate_page(struct kvm_vcpu *vcpu)
 void kvm_xen_setup_pvclock_page(struct kvm_vcpu *v)
 {
 	struct kvm_vcpu_xen *vcpu_xen =3D vcpu_to_xen_vcpu(v);
-	struct vcpu_info *vcpu_info =3D xen_vcpu_info(v);
+	struct vcpu_info *vcpu_info;
+	struct pvclock_vcpu_time_info *pv_info;
+	int idx;
=20
 	BUILD_BUG_ON(offsetof(struct shared_info, vcpu_info) !=3D 0);
 	BUILD_BUG_ON(offsetof(struct compat_shared_info, vcpu_info) !=3D 0);
@@ -236,12 +244,17 @@ void kvm_xen_setup_pvclock_page(struct kvm_vcpu *v)
 	BUILD_BUG_ON(offsetof(struct vcpu_info, time) !=3D
 		     offsetof(struct compat_vcpu_info, time));
=20
+	idx =3D srcu_read_lock(&v->kvm->srcu);
+	vcpu_info =3D xen_vcpu_info(v);
 	if (likely(vcpu_info))
 		kvm_xen_update_vcpu_time(v, &vcpu_info->time);
=20
 	/* Update secondary pvclock region if registered */
-	if (vcpu_xen->pv_time)
-		kvm_xen_update_vcpu_time(v, vcpu_xen->pv_time);
+	pv_info =3D READ_ONCE(vcpu_xen->pv_time);
+	if (pv_info)
+		kvm_xen_update_vcpu_time(v, pv_info);
+
+	srcu_read_unlock(&v->kvm->srcu, idx);
 }
=20
 static int vcpu_attr_loc(struct kvm_vcpu *vcpu, u16 type,


--=-tI3bZjrwefhwqaj0Tz5g
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
MjA1MTA0ODMwWjAvBgkqhkiG9w0BCQQxIgQgWvG1aUvjcyXtfJuLfIKhSERsc4tN+LFnuG7LIDl4
tTIwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAEKKAeYnvd+q9hI6wZwQDgPBiCr/L0V0TKtmUDos9zoPu3nZ/VFxmaWGTQQJAqhZ
otZEPwxs3CjF9xP4uCb4DbcxNj4EmaPFSIgmh+rOEXjKX2t8sJHFV2kCC79nPtVa/ivKBC0N+nn5
kp5oPitZb5/05ccqf6oZutBy+zcR6xwcFPwrFEopgQHMndmisdcnUQhIN9tHlSthmViTrUy2kt+g
cDzYbKi8Ov4GIv+i36vRBC03Wmv9EEL0iM3aartVhrApR5lvUH/GXd2W28cmJ2visqzFZc0QeIfs
iuAxprtq9A6HXVH3VCi0iJ/CZWVkuEcxvQTz4sc5lQaddetOdiMAAAAAAAA=


--=-tI3bZjrwefhwqaj0Tz5g--

