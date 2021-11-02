Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2EA8443333
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 17:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbhKBQmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 12:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234697AbhKBQmM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 12:42:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF671C079783
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 09:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8eBgYkCn7wG/xURWDA0F3xNxlP8F/7u4W9uCsy2IZpI=; b=jQrmNSS/ALl0tbZ29aJkt2H9XP
        jafHmznMyVz+u315rh84v+SiEd6YDZ5+iNPOImHO8CW9rmiPjpUN6v9dqEdV9vOWbCxPSwL6Ztu+A
        DpwUrgN1Rg8lX6FJrZP43XdbJwCqJHgZNZfs60UFxnMUi/e6NGXLrCNDm3SIKhhLe01ZHy0S+gS9D
        rWrTVEZMODtBi9JxGtRUcMr6E8FQNcFEqh1YdHVHQ82LUI+qjnm6GgIvONGTxdkXc8S+Ki9wINnPX
        Yu03Pc0i+tz0KAmUxLqjRWic5WS9g49BgZqS1czI7wxezX9s5McsUTOHap4pWOqRNA3B0alQMdemV
        zuJPCzmg==;
Received: from 54-240-197-239.amazon.com ([54.240.197.239] helo=freeip.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mhwoL-002JNm-M9; Tue, 02 Nov 2021 16:38:58 +0000
Message-ID: <4369bbef7f0c2b239da419c917f9a9f2ca6a76f1.camel@infradead.org>
Subject: [PATCH v2] KVM: x86: Fix recording of guest steal time / preempted
 status
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, karahmed@amazon.com
Date:   Tue, 02 Nov 2021 16:38:53 +0000
In-Reply-To: <5d4002373c3ae614cb87b72ba5b7cdc161a0cd46.camel@infradead.org>
References: <5d4002373c3ae614cb87b72ba5b7cdc161a0cd46.camel@infradead.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-GCFGxB9qxuiQDz3EgVMC"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-GCFGxB9qxuiQDz3EgVMC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Woodhouse <dwmw@amazon.co.uk>

In commit b043138246a4 ("x86/KVM: Make sure KVM_VCPU_FLUSH_TLB flag is
not missed") we switched to using a gfn_to_pfn_cache for accessing the
guest steal time structure in order to allow for an atomic xchg of the
preempted field. This has a couple of problems.

Firstly, kvm_map_gfn() doesn't work at all for IOMEM pages when the
atomic flag is set, which it is in kvm_steal_time_set_preempted(). So a
guest vCPU using an IOMEM page for its steal time would never have its
preempted field set.

Secondly, the gfn_to_pfn_cache is not invalidated in all cases where it
should have been. There are two stages to the GFN =E2=86=92 PFN conversion;
first the GFN is converted to a userspace HVA, and then that HVA is
looked up in the process page tables to find the underlying host PFN.
Correct invalidation of the latter would require being hooked up to the
MMU notifiers, but that doesn't happen =E2=80=94 so it just keeps mapping a=
nd
unmapping the *wrong* PFN after the userspace page tables change.

In the !IOMEM case at least the stale page *is* pinned all the time it's
cached, so it won't be freed and reused by anyone else while still
receiving the steal time updates. (This kind of makes a mockery of this
repeated map/unmap dance which I thought was supposed to avoid pinning
the page. AFAICT we might as well have just kept a kernel mapping of it
all the time).

But there's no point in a kernel mapping of it anyway, when in all cases
we care about, we have a perfectly serviceable userspace HVA for it. We
just need to implement the atomic xchg on the userspace address with
appropriate exception handling, which is fairly trivial.

Cc: stable@vger.kernel.org
Fixes: b043138246a4 ("x86/KVM: Make sure KVM_VCPU_FLUSH_TLB flag is not mis=
sed")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
v2: Fix asm constraints (err is an output). Rebase so that it applies clean=
ly
    before the Xen series (which changes the argument to kvm_map_gfn() that
    is removed in this patch anyway.)

=20
 arch/x86/include/asm/kvm_host.h |   2 +-
 arch/x86/kvm/x86.c              | 107 +++++++++++++++++++++++---------
 2 files changed, 78 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 13f64654dfff..750f74da9793 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -751,7 +751,7 @@ struct kvm_vcpu_arch {
 		u8 preempted;
 		u64 msr_val;
 		u64 last_steal;
-		struct gfn_to_pfn_cache cache;
+		struct gfn_to_hva_cache cache;
 	} st;
=20
 	u64 l1_tsc_offset;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bfe0de3008a6..e6905a1068ad 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3195,8 +3195,11 @@ static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu=
 *vcpu)
=20
 static void record_steal_time(struct kvm_vcpu *vcpu)
 {
-	struct kvm_host_map map;
-	struct kvm_steal_time *st;
+	struct gfn_to_hva_cache *ghc =3D &vcpu->arch.st.cache;
+	struct kvm_steal_time __user *st;
+	struct kvm_memslots *slots;
+	u64 steal;
+	u32 version;
=20
 	if (kvm_xen_msr_enabled(vcpu->kvm)) {
 		kvm_xen_runstate_set_running(vcpu);
@@ -3206,47 +3209,87 @@ static void record_steal_time(struct kvm_vcpu *vcpu=
)
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
=20
-	/* -EAGAIN is returned in atomic context so we can just return. */
-	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT,
-			&map, &vcpu->arch.st.cache, false))
+	if (WARN_ON_ONCE(current->mm !=3D vcpu->kvm->mm))
 		return;
=20
-	st =3D map.hva +
-		offset_in_page(vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS);
+	slots =3D kvm_memslots(vcpu->kvm);
+
+	if (unlikely(slots->generation !=3D ghc->generation ||
+		     kvm_is_error_hva(ghc->hva) || !ghc->memslot)) {
+		gfn_t gfn =3D vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
+
+		/* We rely on the fact that it fits in a single page. */
+		BUILD_BUG_ON((sizeof(*st) - 1) & KVM_STEAL_VALID_BITS);
+
+		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gfn, sizeof(*st)) ||
+		    kvm_is_error_hva(ghc->hva) || !ghc->memslot)
+			return;
+	}
+
+	st =3D (struct kvm_steal_time __user *)ghc->hva;
+	if (!user_access_begin(st, sizeof(*st)))
+		return;
=20
 	/*
 	 * Doing a TLB flush here, on the guest's behalf, can avoid
 	 * expensive IPIs.
 	 */
 	if (guest_pv_has(vcpu, KVM_FEATURE_PV_TLB_FLUSH)) {
-		u8 st_preempted =3D xchg(&st->preempted, 0);
+		u8 st_preempted =3D 0;
+		int err;
+
+		asm volatile("1:\t" LOCK_PREFIX "xchgb %0, %2\n"
+			     "\txor %1, %1\n"
+			     "2:\n"
+			     "\t.section .fixup,\"ax\"\n"
+			     "3:\tmovl %3, %1\n"
+			     "\tjmp\t2b\n"
+			     "\t.previous\n"
+			     _ASM_EXTABLE_UA(1b, 3b)
+			     : "=3Dr" (st_preempted),
+			       "=3Dr" (err)
+			     : "m" (st->preempted),
+			       "i" (-EFAULT),
+			       "0" (st_preempted));
+		if (err)
+			goto out;
+
+		user_access_end();
+
+		vcpu->arch.st.preempted =3D 0;
=20
 		trace_kvm_pv_tlb_flush(vcpu->vcpu_id,
 				       st_preempted & KVM_VCPU_FLUSH_TLB);
 		if (st_preempted & KVM_VCPU_FLUSH_TLB)
 			kvm_vcpu_flush_tlb_guest(vcpu);
+
+		if (!user_access_begin(st, sizeof(*st)))
+			return;
 	} else {
-		st->preempted =3D 0;
+		unsafe_put_user(0, &st->preempted, out);
+		vcpu->arch.st.preempted =3D 0;
 	}
=20
-	vcpu->arch.st.preempted =3D 0;
-
-	if (st->version & 1)
-		st->version +=3D 1;  /* first time write, random junk */
+	unsafe_get_user(version, &st->version, out);
+	if (version & 1)
+		version +=3D 1;  /* first time write, random junk */
=20
-	st->version +=3D 1;
+	version +=3D 1;
+	unsafe_put_user(version, &st->version, out);
=20
 	smp_wmb();
=20
-	st->steal +=3D current->sched_info.run_delay -
+	unsafe_get_user(steal, &st->steal, out);
+	steal +=3D current->sched_info.run_delay -
 		vcpu->arch.st.last_steal;
 	vcpu->arch.st.last_steal =3D current->sched_info.run_delay;
+	unsafe_put_user(steal, &st->steal, out);
=20
-	smp_wmb();
-
-	st->version +=3D 1;
+	version +=3D 1;
+	unsafe_put_user(version, &st->version, out);
=20
-	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, false);
+ out:
+	user_access_end();
 }
=20
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
@@ -4285,8 +4328,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int c=
pu)
=20
 static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 {
-	struct kvm_host_map map;
-	struct kvm_steal_time *st;
+	struct gfn_to_hva_cache *ghc =3D &vcpu->arch.st.cache;
+	struct kvm_steal_time __user *st;
+	struct kvm_memslots *slots;
+	static const u8 preempted =3D KVM_VCPU_PREEMPTED;
=20
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
@@ -4294,16 +4339,21 @@ static void kvm_steal_time_set_preempted(struct kvm=
_vcpu *vcpu)
 	if (vcpu->arch.st.preempted)
 		return;
=20
-	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT, &map,
-			&vcpu->arch.st.cache, true))
+	/* This happens on process exit */
+	if (unlikely(current->mm !=3D vcpu->kvm->mm))
 		return;
=20
-	st =3D map.hva +
-		offset_in_page(vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS);
+	slots =3D kvm_memslots(vcpu->kvm);
=20
-	st->preempted =3D vcpu->arch.st.preempted =3D KVM_VCPU_PREEMPTED;
+	if (unlikely(slots->generation !=3D ghc->generation ||
+		     kvm_is_error_hva(ghc->hva) || !ghc->memslot))
+		return;
=20
-	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, true);
+	st =3D (struct kvm_steal_time __user *)ghc->hva;
+	BUILD_BUG_ON(sizeof(st->preempted) !=3D sizeof(preempted));
+
+	if (!copy_to_user_nofault(&st->preempted, &preempted, sizeof(preempted)))
+		vcpu->arch.st.preempted =3D KVM_VCPU_PREEMPTED;
 }
=20
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
@@ -10817,11 +10867,8 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcp=
u)
=20
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	struct gfn_to_pfn_cache *cache =3D &vcpu->arch.st.cache;
 	int idx;
=20
-	kvm_release_pfn(cache->pfn, cache->dirty, cache);
-
 	kvmclock_reset(vcpu);
=20
 	static_call(kvm_x86_vcpu_free)(vcpu);
--=20
2.25.1


--=-GCFGxB9qxuiQDz3EgVMC
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
MTAyMTYzODU0WjAvBgkqhkiG9w0BCQQxIgQg8chsVmygWj9j/sPymEGXv7qExE38lHQ0S9l3Tx56
62Mwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAFQO6SAax4BsFCwswPkuTsDJKMdhJzi/o6xIE2iQEPtGr2dIxLOSZ0kqcjxYEKsw
Ll08nFj8mgGmgAJGtV8NCPfisNuZ7JOtFzS7toatjcUNTdObAssR43ldrWc1XqrFqkzWDhIJQfuU
FBjz9OZzF/7aj5xBFGF6899deObY+vfltkECBewHJv5eidt1MjaLw9HIl+ci+imTjpy8QAo24WI6
myzv0Z7l7OrLaPZpmWjI7bXuHdgMdXNsntVDFIdDHUXE7m4WIeyfTQ+uym/7ZnupUqkUrR4derjo
gIyVdvCfBj6MJdXts0oYTCSx6PSyamRkAlwakjUKGrnpgbbPpGcAAAAAAAA=


--=-GCFGxB9qxuiQDz3EgVMC--

