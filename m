Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BCF439790
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 15:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhJYNbj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 09:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbhJYNbi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Oct 2021 09:31:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82CAC061745
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 06:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2xxUGRrzPBggho+8Pxrx7ZrZ3cDn/FfBawg89XRR4aU=; b=vVMkU8JGkPV14UVB96x651ZMBE
        fW/cY1XN814uwcrAB8MnphuBmnOS3whQDMF0eDvKdf9xdOBMadvdXs2YLpZYdza8BPOIcNA+GRmH3
        zD/Z5ZLKypiBwd+IpyCgJjLjTZAGjtn16DE4zIbF1SVTCHwA3QXDuYjDtloF3DBhPtGlZxPLDmu4j
        viVGFa5W0LfXgZ+uTmy7xTxZJribXj2EyNACce6IZO4QWtMtEilMBBVFu0NBc+4LKEaPI65+Zw2xt
        xZx6DDJF4yv475kytrvzCv84Nl/m4PDaG2O3letZNSMj0m7LAvl+RyzPT/ubOyflgII+to8QamZhc
        GUrboDrQ==;
Received: from [2001:8b0:10b:1::3ae] (helo=u3832b3a9db3152.ant.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mf02D-00GXV3-5R; Mon, 25 Oct 2021 13:29:05 +0000
Message-ID: <b17a93e5ff4561e57b1238e3e7ccd0b613eb827e.camel@infradead.org>
Subject: [PATCH v2] KVM: x86/xen: Fix runstate updates to be atomic when
 preempting vCPU
From:   David Woodhouse <dwmw2@infradead.org>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "jmattson@google.com" <jmattson@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>
Date:   Mon, 25 Oct 2021 14:29:01 +0100
In-Reply-To: <3d2a13164cbc61142b16edba85960db9a381bebe.camel@amazon.co.uk>
References: <3d2a13164cbc61142b16edba85960db9a381bebe.camel@amazon.co.uk>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-4Wb8yTT8OGLmoXs9c82a"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-4Wb8yTT8OGLmoXs9c82a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Woodhouse <dwmw@amazon.co.uk>

There are circumstances whem kvm_xen_update_runstate_guest() should not
sleep because it ends up being called from __schedule() when the vCPU
is preempted:

[  222.830825]  kvm_xen_update_runstate_guest+0x24/0x100
[  222.830878]  kvm_arch_vcpu_put+0x14c/0x200
[  222.830920]  kvm_sched_out+0x30/0x40
[  222.830960]  __schedule+0x55c/0x9f0

To handle this, make it use the same trick as __kvm_xen_has_interrupt(),
of using the hva from the gfn_to_hva_cache directly. Then it can use
pagefault_disable() around the accesses and just bail out if the page
is absent (which is unlikely).

I almost switched to using a gfn_to_pfn_cache here and bailing out if
kvm_map_gfn() fails, like kvm_steal_time_set_preempted() does =E2=80=94 but=
 on
closer inspection it looks like kvm_map_gfn() will *always* fail in
atomic context for a page in IOMEM, which means it will silently fail
to make the update every single time for such guests, AFAICT. So I
didn't do it that way after all. And will probably fix that one too.

Cc: stable@vger.kernel.org
Fixes: 30b5c851af79 ("KVM: x86/xen: Add support for vCPU runstate informati=
on")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
v2: Mark the page dirty after writing to it, add stable tag.

 arch/x86/kvm/xen.c | 99 +++++++++++++++++++++++++++++++---------------
 1 file changed, 67 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 8f62baebd028..a0bd0014ec66 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -93,32 +93,57 @@ static void kvm_xen_update_runstate(struct kvm_vcpu *v,=
 int state)
 void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 {
 	struct kvm_vcpu_xen *vx =3D &v->arch.xen;
+	struct gfn_to_hva_cache *ghc =3D &vx->runstate_cache;
+	struct kvm_memslots *slots =3D kvm_memslots(v->kvm);
+	bool atomic =3D (state =3D=3D RUNSTATE_runnable);
 	uint64_t state_entry_time;
-	unsigned int offset;
+	int __user *user_state;
+	uint64_t __user *user_times;
=20
 	kvm_xen_update_runstate(v, state);
=20
 	if (!vx->runstate_set)
 		return;
=20
-	BUILD_BUG_ON(sizeof(struct compat_vcpu_runstate_info) !=3D 0x2c);
+	if (unlikely(slots->generation !=3D ghc->generation || kvm_is_error_hva(g=
hc->hva)) &&
+	    kvm_gfn_to_hva_cache_init(v->kvm, ghc, ghc->gpa, ghc->len))
+		return;
+
+	/* We made sure it fits in a single page */
+	BUG_ON(!ghc->memslot);
+
+	if (atomic)
+		pagefault_disable();
=20
-	offset =3D offsetof(struct compat_vcpu_runstate_info, state_entry_time);
-#ifdef CONFIG_X86_64
 	/*
-	 * The only difference is alignment of uint64_t in 32-bit.
-	 * So the first field 'state' is accessed directly using
-	 * offsetof() (where its offset happens to be zero), while the
-	 * remaining fields which are all uint64_t, start at 'offset'
-	 * which we tweak here by adding 4.
+	 * The only difference between 32-bit and 64-bit versions of the
+	 * runstate struct us the alignment of uint64_t in 32-bit, which
+	 * means that the 64-bit version has an additional 4 bytes of
+	 * padding after the first field 'state'.
+	 *
+	 * So we use 'int __user *user_state' to point to the state field,
+	 * and 'uint64_t __user *user_times' for runstate_entry_time. So
+	 * the actual array of time[] in each state starts at user_times[1].
 	 */
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) !=3D 0);
+	BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info, state) !=3D 0);
+	user_state =3D (int __user *)ghc->hva;
+
+	BUILD_BUG_ON(sizeof(struct compat_vcpu_runstate_info) !=3D 0x2c);
+
+	user_times =3D (uint64_t __user *)(ghc->hva +
+					 offsetof(struct compat_vcpu_runstate_info,
+						  state_entry_time));
+#ifdef CONFIG_X86_64
 	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=3D
 		     offsetof(struct compat_vcpu_runstate_info, state_entry_time) + 4);
 	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, time) !=3D
 		     offsetof(struct compat_vcpu_runstate_info, time) + 4);
=20
 	if (v->kvm->arch.xen.long_mode)
-		offset =3D offsetof(struct vcpu_runstate_info, state_entry_time);
+		user_times =3D (uint64_t __user *)(ghc->hva +
+						 offsetof(struct vcpu_runstate_info,
+							  state_entry_time));
 #endif
 	/*
 	 * First write the updated state_entry_time at the appropriate
@@ -132,28 +157,21 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v=
, int state)
 	BUILD_BUG_ON(sizeof(((struct compat_vcpu_runstate_info *)0)->state_entry_=
time) !=3D
 		     sizeof(state_entry_time));
=20
-	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
-					  &state_entry_time, offset,
-					  sizeof(state_entry_time)))
-		return;
+	if (__put_user(state_entry_time, user_times))
+		goto out;
 	smp_wmb();
=20
 	/*
 	 * Next, write the new runstate. This is in the *same* place
 	 * for 32-bit and 64-bit guests, asserted here for paranoia.
 	 */
-	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) !=3D
-		     offsetof(struct compat_vcpu_runstate_info, state));
 	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->state) !=3D
 		     sizeof(vx->current_runstate));
 	BUILD_BUG_ON(sizeof(((struct compat_vcpu_runstate_info *)0)->state) !=3D
 		     sizeof(vx->current_runstate));
=20
-	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
-					  &vx->current_runstate,
-					  offsetof(struct vcpu_runstate_info, state),
-					  sizeof(vx->current_runstate)))
-		return;
+	if (__put_user(vx->current_runstate, user_state))
+		goto out;
=20
 	/*
 	 * Write the actual runstate times immediately after the
@@ -168,24 +186,23 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v=
, int state)
 	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->time) !=3D
 		     sizeof(vx->runstate_times));
=20
-	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
-					  &vx->runstate_times[0],
-					  offset + sizeof(u64),
-					  sizeof(vx->runstate_times)))
-		return;
-
+	if (__copy_to_user(user_times + 1, vx->runstate_times, sizeof(vx->runstat=
e_times)))
+		goto out;
 	smp_wmb();
=20
 	/*
 	 * Finally, clear the XEN_RUNSTATE_UPDATE bit in the guest's
 	 * runstate_entry_time field.
 	 */
-
 	state_entry_time &=3D ~XEN_RUNSTATE_UPDATE;
-	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
-					  &state_entry_time, offset,
-					  sizeof(state_entry_time)))
-		return;
+	__put_user(state_entry_time, user_times);
+	smp_wmb();
+
+ out:
+	mark_page_dirty_in_slot(v->kvm, ghc->memslot, ghc->gpa >> PAGE_SHIFT);
+
+	if (atomic)
+		pagefault_enable();
 }
=20
 int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
@@ -337,6 +354,12 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struc=
t kvm_xen_vcpu_attr *data)
 			break;
 		}
=20
+		/* It must fit within a single page */
+		if ((data->u.gpa & ~PAGE_MASK) + sizeof(struct vcpu_info) > PAGE_SIZE) {
+			r =3D -EINVAL;
+			break;
+		}
+
 		r =3D kvm_gfn_to_hva_cache_init(vcpu->kvm,
 					      &vcpu->arch.xen.vcpu_info_cache,
 					      data->u.gpa,
@@ -354,6 +377,12 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struc=
t kvm_xen_vcpu_attr *data)
 			break;
 		}
=20
+		/* It must fit within a single page */
+		if ((data->u.gpa & ~PAGE_MASK) + sizeof(struct pvclock_vcpu_time_info) >=
 PAGE_SIZE) {
+			r =3D -EINVAL;
+			break;
+		}
+
 		r =3D kvm_gfn_to_hva_cache_init(vcpu->kvm,
 					      &vcpu->arch.xen.vcpu_time_info_cache,
 					      data->u.gpa,
@@ -375,6 +404,12 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struc=
t kvm_xen_vcpu_attr *data)
 			break;
 		}
=20
+		/* It must fit within a single page */
+		if ((data->u.gpa & ~PAGE_MASK) + sizeof(struct vcpu_runstate_info) > PAG=
E_SIZE) {
+			r =3D -EINVAL;
+			break;
+		}
+
 		r =3D kvm_gfn_to_hva_cache_init(vcpu->kvm,
 					      &vcpu->arch.xen.runstate_cache,
 					      data->u.gpa,
--=20
2.25.1


--=-4Wb8yTT8OGLmoXs9c82a
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
MDI1MTMyOTAxWjAvBgkqhkiG9w0BCQQxIgQgFAPFHVSXnRUf86YIfRfceRLcVNAHmSrhLSEgIBse
Wt4wgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAK/bpQ4UkNHetfKaCTu+rtcXAJzCLdH9UoXplnYwn+QXRpepNyrvHZ1Wbk77z1J4
DPLQTGGukW3nByv77E5VQs2Gx3n/lfjPYwxz6R/ZtshecW6TIBfLM8Ck61XaC2OkRTl384W0rxY3
XmP4zCL+bjg7ofjm0Q1SYQRnHzAuPGYiKXFqPPPtvaq1AnhHhpc4qGZgbwgfhDPx24/pp0O780uJ
jD/VBdMjdD6EjT6NLw1KAGKx/n8UAZVFja+YlM83txUywkRUPw1Al8x5Jq6M3S67EniTywnl9sjI
XVq9UmsbnTAcDCTfVGzOQ7ZBUk3n4FI8JMKvZp+SZ4grvwJjHC4AAAAAAAA=


--=-4Wb8yTT8OGLmoXs9c82a--

