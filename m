Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EE6308BB7
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 18:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbhA2RhB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 12:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbhA2Rel (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 12:34:41 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAD7C061352
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 09:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GZP7WqtmDaeJut5IYZkaye6q6gozj5vpow0f8X3UYgs=; b=X9Cq7TbBHPYAvFixhIBytRVSeL
        yGkrPjYBZO7lyz5MgBGzVF2iveZ+02XlHIm7aYQtcvvVDUQdFA0z+ZR9HpG1KfvGi6Jcv9DgoPavg
        RdN7k9KbX6u5orRIFTgNadp1K/e/FQ0nKBhHp5slKgeTFY1WUf1KFTmYeQOgur3+7BxMghIqolWqh
        NUYr71A6kEq6RNPMXyxGBArEi4zaZ7SPauFq0/W3fxKjVD5zXgI6tBITdJqO1/z+leyN5VZ/dsjcR
        O2uLUEtc8n+eoPg7k/P/iK4NJYxEHAglPWueCPkKLCTp1oGEDdWOUOxzugV4Tsx0KyvQ0ri5hr5LV
        u5PRyF5g==;
Received: from 54-240-197-234.amazon.com ([54.240.197.234] helo=u3832b3a9db3152.ant.amazon.com)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l5Xdu-0003PK-4v; Fri, 29 Jan 2021 17:33:10 +0000
Message-ID: <529a1e82a0c83f82e0079359b0b8ba74ac670e89.camel@infradead.org>
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
Date:   Fri, 29 Jan 2021 17:33:07 +0000
In-Reply-To: <3b66ee62-bf12-c6ab-a954-a66e5f31f109@redhat.com>
References: <20210111195725.4601-1-dwmw2@infradead.org>
         <20210111195725.4601-17-dwmw2@infradead.org>
         <3b66ee62-bf12-c6ab-a954-a66e5f31f109@redhat.com>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-W3kpulG/Vue3H0EC0uLv"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-W3kpulG/Vue3H0EC0uLv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-01-28 at 13:43 +0100, Paolo Bonzini wrote:
> Independent of the answer to the above, this is really the only place=20
> where you're adding Xen code to a hot path.  Can you please use a=20
> STATIC_KEY_FALSE kvm_has_xen_vcpu (and a static inline function) to=20
> quickly return from kvm_xen_has_interrupt() if no vCPU has a shared info=
=20
> set up?

Something like this, then?

=46rom 6504c78f76efd8c60630959111bd77c28d43fca7 Mon Sep 17 00:00:00 2001
From: David Woodhouse <dwmw@amazon.co.uk>
Date: Fri, 29 Jan 2021 17:30:40 +0000
Subject: [PATCH] KVM: x86/xen: Add static branch to avoid overhead of check=
ing
 Xen upcall vector

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c |  1 +
 arch/x86/kvm/xen.c | 68 +++++++++++++++++++++++++++-------------------
 arch/x86/kvm/xen.h | 15 +++++++++-
 3 files changed, 55 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 870dea74ea94..fb2bc362efd8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10580,6 +10580,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		kvm_x86_ops.vm_destroy(kvm);
 	for (i =3D 0; i < kvm->arch.msr_filter.count; i++)
 		kfree(kvm->arch.msr_filter.ranges[i].bitmap);
+	kvm_xen_destroy(kvm);
 	kvm_pic_destroy(kvm);
 	kvm_ioapic_destroy(kvm);
 	kvm_free_vcpus(kvm);
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 3041f774493e..9b6766e5d84f 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -19,6 +19,8 @@
=20
 #include "trace.h"
=20
+DEFINE_STATIC_KEY_DEFERRED_FALSE(kvm_xen_has_vector, HZ);
+
 static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 {
 	gpa_t gpa =3D gfn_to_gpa(gfn);
@@ -176,7 +178,7 @@ void kvm_xen_setup_runstate_page(struct kvm_vcpu *v)
 	kvm_xen_update_runstate(v, RUNSTATE_running, steal_time);
 }
=20
-int kvm_xen_has_interrupt(struct kvm_vcpu *v)
+int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 {
 	u8 rc =3D 0;
=20
@@ -184,37 +186,42 @@ int kvm_xen_has_interrupt(struct kvm_vcpu *v)
 	 * If the global upcall vector (HVMIRQ_callback_vector) is set and
 	 * the vCPU's evtchn_upcall_pending flag is set, the IRQ is pending.
 	 */
-	if (v->arch.xen.vcpu_info_set && v->kvm->arch.xen.upcall_vector) {
-		struct gfn_to_hva_cache *ghc =3D &v->arch.xen.vcpu_info_cache;
-		struct kvm_memslots *slots =3D kvm_memslots(v->kvm);
-		unsigned int offset =3D offsetof(struct vcpu_info, evtchn_upcall_pending=
);
-
-		/* No need for compat handling here */
-		BUILD_BUG_ON(offsetof(struct vcpu_info, evtchn_upcall_pending) !=3D
-			     offsetof(struct compat_vcpu_info, evtchn_upcall_pending));
-		BUILD_BUG_ON(sizeof(rc) !=3D
-			     sizeof(((struct vcpu_info *)0)->evtchn_upcall_pending));
-		BUILD_BUG_ON(sizeof(rc) !=3D
-			     sizeof(((struct compat_vcpu_info *)0)->evtchn_upcall_pending));
-
-		/*
-		 * For efficiency, this mirrors the checks for using the valid
-		 * cache in kvm_read_guest_offset_cached(), but just uses
-		 * __get_user() instead. And falls back to the slow path.
-		 */
-		if (likely(slots->generation =3D=3D ghc->generation &&
-			   !kvm_is_error_hva(ghc->hva) && ghc->memslot)) {
-			/* Fast path */
-			__get_user(rc, (u8 __user *)ghc->hva + offset);
-		} else {
-			/* Slow path */
-			kvm_read_guest_offset_cached(v->kvm, ghc, &rc, offset,
-						      sizeof(rc));
-		}
+	struct gfn_to_hva_cache *ghc =3D &v->arch.xen.vcpu_info_cache;
+	struct kvm_memslots *slots =3D kvm_memslots(v->kvm);
+	unsigned int offset =3D offsetof(struct vcpu_info, evtchn_upcall_pending)=
;
+
+	/* No need for compat handling here */
+	BUILD_BUG_ON(offsetof(struct vcpu_info, evtchn_upcall_pending) !=3D
+		     offsetof(struct compat_vcpu_info, evtchn_upcall_pending));
+	BUILD_BUG_ON(sizeof(rc) !=3D
+		     sizeof(((struct vcpu_info *)0)->evtchn_upcall_pending));
+	BUILD_BUG_ON(sizeof(rc) !=3D
+		     sizeof(((struct compat_vcpu_info *)0)->evtchn_upcall_pending));
+
+	/*
+	 * For efficiency, this mirrors the checks for using the valid
+	 * cache in kvm_read_guest_offset_cached(), but just uses
+	 * __get_user() instead. And falls back to the slow path.
+	 */
+	if (likely(slots->generation =3D=3D ghc->generation &&
+		   !kvm_is_error_hva(ghc->hva) && ghc->memslot)) {
+		/* Fast path */
+		__get_user(rc, (u8 __user *)ghc->hva + offset);
+	} else {
+		/* Slow path */
+		kvm_read_guest_offset_cached(v->kvm, ghc, &rc, offset,
+					     sizeof(rc));
 	}
+
 	return rc;
 }
=20
+void kvm_xen_destroy(struct kvm *kvm)
+{
+	if (kvm->arch.xen.upcall_vector)
+		static_branch_slow_dec_deferred(&kvm_xen_has_vector);
+}
+
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 {
 	struct kvm_vcpu *v;
@@ -300,6 +307,11 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_x=
en_hvm_attr *data)
 			break;
 		}
=20
+		if (data->u.vector && !kvm->arch.xen.upcall_vector)
+			static_branch_inc(&kvm_xen_has_vector.key);
+		else if (kvm->arch.xen.upcall_vector && !data->u.vector)
+			static_branch_slow_dec_deferred(&kvm_xen_has_vector);
+
 		kvm->arch.xen.upcall_vector =3D data->u.vector;
 		r =3D 0;
 		break;
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index d64916ac4a12..d49cd8ea8da9 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -9,13 +9,16 @@
 #ifndef __ARCH_X86_KVM_XEN_H__
 #define __ARCH_X86_KVM_XEN_H__
=20
+#include <linux/jump_label_ratelimit.h>
+
 void kvm_xen_setup_runstate_page(struct kvm_vcpu *vcpu);
 void kvm_xen_runstate_set_preempted(struct kvm_vcpu *vcpu);
-int kvm_xen_has_interrupt(struct kvm_vcpu *vcpu);
+int __kvm_xen_has_interrupt(struct kvm_vcpu *vcpu);
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
 int kvm_xen_hvm_config(struct kvm_vcpu *vcpu, u64 data);
+void kvm_xen_destroy(struct kvm *kvm);
=20
 static inline bool kvm_xen_hypercall_enabled(struct kvm *kvm)
 {
@@ -23,6 +26,16 @@ static inline bool kvm_xen_hypercall_enabled(struct kvm =
*kvm)
 		KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL;
 }
=20
+extern struct static_key_false_deferred kvm_xen_has_vector;
+
+static inline int kvm_xen_has_interrupt(struct kvm_vcpu *vcpu)
+{
+	if (static_branch_unlikely(&kvm_xen_has_vector.key) &&
+	    vcpu->arch.xen.vcpu_info_set && vcpu->kvm->arch.xen.upcall_vector)
+		return __kvm_xen_has_interrupt(vcpu);
+
+	return 0;
+}
=20
 /* 32-bit compatibility definitions, also used natively in 32-bit build */
 #include <asm/pvclock-abi.h>
--=20
2.17.1


--=-W3kpulG/Vue3H0EC0uLv
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
MTI5MTczMzA3WjAvBgkqhkiG9w0BCQQxIgQgDWyCDZDXbwOjtRhWXjY4djUV4rgjV/PCWqquQgIi
O5Iwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAFtOBgWF9rfGDeXN6RW3RYys3Sy4MEKKyeseZ/WKTJ4iqAVnFUbpU8g4Jh0KMBF8
lZ1N+ZXnsCbObigLNnTzlCLNvodSZzJZHAjcH27QAzEMQ2f7nGhjL1n5Lj7g5Wq2lANWOTnMHrr9
1CN1bL49WQ2+lNZefs7DWww9HL/JnTkhz0rgjBZvdxcfeZ5nX2WkhfuE4WgeDiEhHuui9Q+bnsUC
tGM+2XvPL+yu4O0gPp+SGPHVhOSRdbnay0/jF8YdIObBagaUNa1VHKC6Ypamig8o6HKT1npIswgw
w3ATKA/cCgX835DhuYHVy5NaBt8GwapSlgIh2W1fB/qJh2ef1ZkAAAAAAAA=


--=-W3kpulG/Vue3H0EC0uLv--

