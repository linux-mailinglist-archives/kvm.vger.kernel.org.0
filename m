Return-Path: <kvm+bounces-23219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 403AD947A42
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 13:09:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8A742813B3
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 11:09:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E912155733;
	Mon,  5 Aug 2024 11:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jiIr1xva"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369BE13AD11;
	Mon,  5 Aug 2024 11:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722856148; cv=none; b=nf5IwHe6JYvj5kWAF3cf/Kk9prx+t3yA4NkhYoa+ylKIGAsmu1hZh2ezU+iYlmcpoAYyjegq3gCA20YD9wBnL2iiaYg7yEXdiKUh9SHPKihawZ7VUNC+4N3TL7kn+hQ1jrBNN+HVr7dmRvFaEGbNwtSadRGuSkUSiQlfc6XTk3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722856148; c=relaxed/simple;
	bh=my48OmPGdjhVToFM5DoPSLJCMX9EaKYy+1uSFntX1ao=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=muDFPHE540jbHo8B7hxIs2bGmUPujhP3444D9tXfLhis0Yl5L7wZm6TkZ6/NL0vDc6wRr7leQC2RKyX5rQOB/RyBhp47RSWrvkWBP+9hPW+A+SO43sExADQ5M/aqIPC17N23xYZNh1j5xy3lUD5lhwp+Tzi9v73j8H8bGJ83T7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jiIr1xva; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZI0m0E0XK0e2xBtxKzqvk7+VsrSOQSQZdQttCOJRiCQ=; b=jiIr1xva8Pov7Bi8fZkJoNKEY3
	n+OmnAmB26ALs9lc9qGUJ2Pd8OiZrDKZ4TFczdIO9pbByilwenPjy0pJGWi1KfimzT8qzowgJW0b6
	hTFxG6OnN9+QSvugIW6FAClG381hsLgbahc4vGsxzuHXNefWBZKVrVXHzDTYdQUN3VM2zFba2f/Ef
	Ak9rTYDNycE1Q2vE0qThsYP6veQBYDViLSNxMtczME/3nw5mxqOhVyCDWQNC7t7ImoPLlhnBogv3l
	WH9MYEaC1u7o5kg+KUeEPcDWLL6j5mv48wlPt3t6jQzMi8EO2r016R+WmO1Pri+2GeHU5ff3E6xI5
	nCH9Qelg==;
Received: from [2001:8b0:10b:5:24c3:c120:52d3:3ec3] (helo=u3832b3a9db3152.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1savaD-00000004BdK-0qlW;
	Mon, 05 Aug 2024 11:08:57 +0000
Message-ID: <f862cefff2ed3f4211b69d785670f41667703cf3.camel@infradead.org>
Subject: [PATCH] KVM: Move gfn_to_pfn_cache invalidation to
 invalidate_range_end hook
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  "Hussain, Mushahid" <hmushi@amazon.co.uk>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li
 <wanpengli@tencent.com>,  Jim Mattson <jmattson@google.com>, Joerg Roedel
 <joro@8bytes.org>, kvm@vger.kernel.org,  linux-kernel@vger.kernel.org,
 Mingwei Zhang <mizhang@google.com>, Maxim Levitsky <mlevitsk@redhat.com>
Date: Mon, 05 Aug 2024 12:08:56 +0100
In-Reply-To: <294c8c437c2e48b318b8c27eb7467430dfcba92b.camel@infradead.org>
References: <20220427014004.1992589-1-seanjc@google.com>
	 <20220427014004.1992589-7-seanjc@google.com>
	 <294c8c437c2e48b318b8c27eb7467430dfcba92b.camel@infradead.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-xxEVRkpemek+kcSHzsTG"
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-xxEVRkpemek+kcSHzsTG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Woodhouse <dwmw@amazon.co.uk>

The existing retry loop in hva_to_pfn_retry() is extremely pessimistic.
If there is an invalidation running concurrently, it is effectively just
a complex busy wait loop because its local mmu_notifier_retry_cache()
function will always return true.

It ends up functioning as a very unfair read/write lock. If userspace is
acting as a 'writer', performing many unrelated MM changes, then the
hva_to_pfn_retry() function acting as the 'reader' just backs off and
keep retrying for ever, not making any progress.

Solve this by introducing a separate 'validating' flag to the GPC, so
that it can be marked invalid before it's even mapped. This allows the
invalidation to be moved to the range_end hook, and the retry loop in
hva_to_pfn_retry() can be changed to loop only if its particular uHVA
has been affected.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
I note I'm deleting a big comment in kvm_main.c about doing the
invalidation before acquiring mmu_lock. But we don't hold the lock
in the range_end callback either, do we?
=20
 include/linux/kvm_types.h |  1 +
 virt/kvm/kvm_main.c       | 14 ++------
 virt/kvm/kvm_mm.h         | 12 +++----
 virt/kvm/pfncache.c       | 75 +++++++++++++++++++--------------------
 4 files changed, 45 insertions(+), 57 deletions(-)

diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 827ecc0b7e10..30ed1019cfc6 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -69,6 +69,7 @@ struct gfn_to_pfn_cache {
 	void *khva;
 	kvm_pfn_t pfn;
 	bool active;
+	bool validating;
 	bool valid;
 };
=20
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d0788d0a72cc..ffd6ab4c2a16 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -777,18 +777,6 @@ static int kvm_mmu_notifier_invalidate_range_start(str=
uct mmu_notifier *mn,
 	kvm->mn_active_invalidate_count++;
 	spin_unlock(&kvm->mn_invalidate_lock);
=20
-	/*
-	 * Invalidate pfn caches _before_ invalidating the secondary MMUs, i.e.
-	 * before acquiring mmu_lock, to avoid holding mmu_lock while acquiring
-	 * each cache's lock.  There are relatively few caches in existence at
-	 * any given time, and the caches themselves can check for hva overlap,
-	 * i.e. don't need to rely on memslot overlap checks for performance.
-	 * Because this runs without holding mmu_lock, the pfn caches must use
-	 * mn_active_invalidate_count (see above) instead of
-	 * mmu_invalidate_in_progress.
-	 */
-	gfn_to_pfn_cache_invalidate_start(kvm, range->start, range->end);
-
 	/*
 	 * If one or more memslots were found and thus zapped, notify arch code
 	 * that guest memory has been reclaimed.  This needs to be done *after*
@@ -849,6 +837,8 @@ static void kvm_mmu_notifier_invalidate_range_end(struc=
t mmu_notifier *mn,
 	wake =3D !kvm->mn_active_invalidate_count;
 	spin_unlock(&kvm->mn_invalidate_lock);
=20
+	gfn_to_pfn_cache_invalidate(kvm, range->start, range->end);
+
 	/*
 	 * There can only be one waiter, since the wait happens under
 	 * slots_lock.
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 715f19669d01..34e4e67f09f8 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -24,13 +24,13 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, b=
ool interruptible,
 		     bool *async, bool write_fault, bool *writable);
=20
 #ifdef CONFIG_HAVE_KVM_PFNCACHE
-void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
-				       unsigned long start,
-				       unsigned long end);
+void gfn_to_pfn_cache_invalidate(struct kvm *kvm,
+				 unsigned long start,
+				 unsigned long end);
 #else
-static inline void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
-						     unsigned long start,
-						     unsigned long end)
+static inline void gfn_to_pfn_cache_invalidate(struct kvm *kvm,
+					       unsigned long start,
+					       unsigned long end)
 {
 }
 #endif /* HAVE_KVM_PFNCACHE */
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index f0039efb9e1e..187b58150ef7 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -20,10 +20,14 @@
 #include "kvm_mm.h"
=20
 /*
- * MMU notifier 'invalidate_range_start' hook.
+ * MMU notifier 'invalidate_range_end' hook. The hva_to_pfn_retry() functi=
on
+ * below may look up a PFN just before it is zapped, and may be mapping it
+ * concurrently (with the GPC lock dropped). By using a separate 'validati=
ng'
+ * flag, the invalidation can occur concurrently, causing hva_to_pfn_retry=
()
+ * to drop its result and retry correctly.
  */
-void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long star=
t,
-				       unsigned long end)
+void gfn_to_pfn_cache_invalidate(struct kvm *kvm, unsigned long start,
+				 unsigned long end)
 {
 	struct gfn_to_pfn_cache *gpc;
=20
@@ -32,7 +36,7 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, u=
nsigned long start,
 		read_lock_irq(&gpc->lock);
=20
 		/* Only a single page so no need to care about length */
-		if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
+		if (gpc->validating && !is_error_noslot_pfn(gpc->pfn) &&
 		    gpc->uhva >=3D start && gpc->uhva < end) {
 			read_unlock_irq(&gpc->lock);
=20
@@ -45,9 +49,11 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, =
unsigned long start,
 			 */
=20
 			write_lock_irq(&gpc->lock);
-			if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
-			    gpc->uhva >=3D start && gpc->uhva < end)
+			if (gpc->validating && !is_error_noslot_pfn(gpc->pfn) &&
+			    gpc->uhva >=3D start && gpc->uhva < end) {
+				gpc->validating =3D false;
 				gpc->valid =3D false;
+			}
 			write_unlock_irq(&gpc->lock);
 			continue;
 		}
@@ -93,6 +99,9 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, unsigned=
 long len)
 	if (!gpc->valid)
 		return false;
=20
+	/* It can never be valid unless it was once validating! */
+	WARN_ON_ONCE(!gpc->validating);
+
 	return true;
 }
=20
@@ -124,41 +133,12 @@ static void gpc_unmap(kvm_pfn_t pfn, void *khva)
 #endif
 }
=20
-static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long=
 mmu_seq)
-{
-	/*
-	 * mn_active_invalidate_count acts for all intents and purposes
-	 * like mmu_invalidate_in_progress here; but the latter cannot
-	 * be used here because the invalidation of caches in the
-	 * mmu_notifier event occurs _before_ mmu_invalidate_in_progress
-	 * is elevated.
-	 *
-	 * Note, it does not matter that mn_active_invalidate_count
-	 * is not protected by gpc->lock.  It is guaranteed to
-	 * be elevated before the mmu_notifier acquires gpc->lock, and
-	 * isn't dropped until after mmu_invalidate_seq is updated.
-	 */
-	if (kvm->mn_active_invalidate_count)
-		return true;
-
-	/*
-	 * Ensure mn_active_invalidate_count is read before
-	 * mmu_invalidate_seq.  This pairs with the smp_wmb() in
-	 * mmu_notifier_invalidate_range_end() to guarantee either the
-	 * old (non-zero) value of mn_active_invalidate_count or the
-	 * new (incremented) value of mmu_invalidate_seq is observed.
-	 */
-	smp_rmb();
-	return kvm->mmu_invalidate_seq !=3D mmu_seq;
-}
-
 static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 {
 	/* Note, the new page offset may be different than the old! */
 	void *old_khva =3D (void *)PAGE_ALIGN_DOWN((uintptr_t)gpc->khva);
 	kvm_pfn_t new_pfn =3D KVM_PFN_ERR_FAULT;
 	void *new_khva =3D NULL;
-	unsigned long mmu_seq;
=20
 	lockdep_assert_held(&gpc->refresh_lock);
=20
@@ -172,8 +152,16 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_ca=
che *gpc)
 	gpc->valid =3D false;
=20
 	do {
-		mmu_seq =3D gpc->kvm->mmu_invalidate_seq;
-		smp_rmb();
+		/*
+		 * The translation made by hva_to_pfn() below could be made
+		 * invalid as soon as it's mapped. But the uhva is already
+		 * known and that's all that gfn_to_pfn_cache_invalidate()
+		 * looks at. So set the 'validating' flag to allow the GPC
+		 * to be marked invalid from the moment the lock is dropped,
+		 * before the corresponding PFN is even found (and, more to
+		 * the point, immediately afterwards).
+		 */
+		gpc->validating =3D true;
=20
 		write_unlock_irq(&gpc->lock);
=20
@@ -224,7 +212,14 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_ca=
che *gpc)
 		 * attempting to refresh.
 		 */
 		WARN_ON_ONCE(gpc->valid);
-	} while (mmu_notifier_retry_cache(gpc->kvm, mmu_seq));
+
+		/*
+		 * Since gfn_to_pfn_cache_invalidate() is called from the
+		 * kvm_mmu_notifier_invalidate_range_end() callback, it can
+		 * invalidate the GPC the moment after hva_to_pfn() returned
+		 * a valid PFN. If that happens, retry.
+		 */
+	} while (!gpc->validating);
=20
 	gpc->valid =3D true;
 	gpc->pfn =3D new_pfn;
@@ -339,6 +334,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *g=
pc, gpa_t gpa, unsigned l
 	 */
 	if (ret) {
 		gpc->valid =3D false;
+		gpc->validating =3D false;
 		gpc->pfn =3D KVM_PFN_ERR_FAULT;
 		gpc->khva =3D NULL;
 	}
@@ -383,7 +379,7 @@ void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct =
kvm *kvm)
 	gpc->pfn =3D KVM_PFN_ERR_FAULT;
 	gpc->gpa =3D INVALID_GPA;
 	gpc->uhva =3D KVM_HVA_ERR_BAD;
-	gpc->active =3D gpc->valid =3D false;
+	gpc->active =3D gpc->valid =3D gpc->validating =3D false;
 }
=20
 static int __kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, uns=
igned long uhva,
@@ -453,6 +449,7 @@ void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 		write_lock_irq(&gpc->lock);
 		gpc->active =3D false;
 		gpc->valid =3D false;
+		gpc->validating =3D false;
=20
 		/*
 		 * Leave the GPA =3D> uHVA cache intact, it's protected by the
--=20
2.44.0



--=-xxEVRkpemek+kcSHzsTG
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCEkQw
ggYQMIID+KADAgECAhBNlCwQ1DvglAnFgS06KwZPMA0GCSqGSIb3DQEBDAUAMIGIMQswCQYDVQQG
EwJVUzETMBEGA1UECBMKTmV3IEplcnNleTEUMBIGA1UEBxMLSmVyc2V5IENpdHkxHjAcBgNVBAoT
FVRoZSBVU0VSVFJVU1QgTmV0d29yazEuMCwGA1UEAxMlVVNFUlRydXN0IFJTQSBDZXJ0aWZpY2F0
aW9uIEF1dGhvcml0eTAeFw0xODExMDIwMDAwMDBaFw0zMDEyMzEyMzU5NTlaMIGWMQswCQYDVQQG
EwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYD
VQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAyjztlApB/975Rrno1jvm2pK/KxBOqhq8gr2+JhwpKirSzZxQgT9tlC7zl6hn1fXjSo5MqXUf
ItMltrMaXqcESJuK8dtK56NCSrq4iDKaKq9NxOXFmqXX2zN8HHGjQ2b2Xv0v1L5Nk1MQPKA19xeW
QcpGEGFUUd0kN+oHox+L9aV1rjfNiCj3bJk6kJaOPabPi2503nn/ITX5e8WfPnGw4VuZ79Khj1YB
rf24k5Ee1sLTHsLtpiK9OjG4iQRBdq6Z/TlVx/hGAez5h36bBJMxqdHLpdwIUkTqT8se3ed0PewD
ch/8kHPo5fZl5u1B0ecpq/sDN/5sCG52Ds+QU5O5EwIDAQABo4IBZDCCAWAwHwYDVR0jBBgwFoAU
U3m/WqorSs9UgOHYm8Cd8rIDZsswHQYDVR0OBBYEFAnA8vwL2pTbX/4r36iZQs/J4K0AMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEF
BQcDBDARBgNVHSAECjAIMAYGBFUdIAAwUAYDVR0fBEkwRzBFoEOgQYY/aHR0cDovL2NybC51c2Vy
dHJ1c3QuY29tL1VTRVJUcnVzdFJTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHYGCCsGAQUF
BwEBBGowaDA/BggrBgEFBQcwAoYzaHR0cDovL2NydC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJT
QUFkZFRydXN0Q0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0G
CSqGSIb3DQEBDAUAA4ICAQBBRHUAqznCFfXejpVtMnFojADdF9d6HBA4kMjjsb0XMZHztuOCtKF+
xswhh2GqkW5JQrM8zVlU+A2VP72Ky2nlRA1GwmIPgou74TZ/XTarHG8zdMSgaDrkVYzz1g3nIVO9
IHk96VwsacIvBF8JfqIs+8aWH2PfSUrNxP6Ys7U0sZYx4rXD6+cqFq/ZW5BUfClN/rhk2ddQXyn7
kkmka2RQb9d90nmNHdgKrwfQ49mQ2hWQNDkJJIXwKjYA6VUR/fZUFeCUisdDe/0ABLTI+jheXUV1
eoYV7lNwNBKpeHdNuO6Aacb533JlfeUHxvBz9OfYWUiXu09sMAviM11Q0DuMZ5760CdO2VnpsXP4
KxaYIhvqPqUMWqRdWyn7crItNkZeroXaecG03i3mM7dkiPaCkgocBg0EBYsbZDZ8bsG3a08LwEsL
1Ygz3SBsyECa0waq4hOf/Z85F2w2ZpXfP+w8q4ifwO90SGZZV+HR/Jh6rEaVPDRF/CEGVqR1hiuQ
OZ1YL5ezMTX0ZSLwrymUE0pwi/KDaiYB15uswgeIAcA6JzPFf9pLkAFFWs1QNyN++niFhsM47qod
x/PL+5jR87myx5uYdBEQkkDc+lKB1Wct6ucXqm2EmsaQ0M95QjTmy+rDWjkDYdw3Ms6mSWE3Bn7i
5ZgtwCLXgAIe5W8mybM2JzCCBhQwggT8oAMCAQICEQDGvhmWZ0DEAx0oURL6O6l+MA0GCSqGSIb3
DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYD
VQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28g
UlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTIyMDEwNzAw
MDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9y
ZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3GpC2bomUqk+91wLYBzDMcCj5C9m6
oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZHh7htyAkWYVoFsFPrwHounto8xTsy
SSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT9YgcBqKCo65pTFmOnR/VVbjJk4K2
xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNjP+qDrh0db7PAjO1D4d5ftfrsf+kd
RR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy2U+eITZ5LLE5s45mX2oPFknWqxBo
bQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3BgBEmfsYWlBXO8rVXfvPgLs32VdV
NZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/7auNVRmPB3v5SWEsH8xi4Bez2V9U
KxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmdlFYhAflWKQ03Ufiu8t3iBE3VJbc2
5oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9aelIl6vtbhMA+l0nfrsORMa4kobqQ5
C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMBAAGjggHMMIIByDAfBgNVHSMEGDAW
gBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeDMcimo0oz8o1R1Nver3ZVpSkwDgYD
VR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMC
MEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYBBQUHAgEWF2h0dHBzOi8vc2VjdGln
by5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwuc2VjdGlnby5jb20vU2VjdGln
b1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcmwwgYoGCCsGAQUFBwEB
BH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdvLmNvbS9TZWN0aWdvUlNBQ2xpZW50
QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAjBggrBgEFBQcwAYYXaHR0cDovL29j
c3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5mcmFkZWFkLm9yZzANBgkqhkiG9w0B
AQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQvQ/fzPXmtR9t54rpmI2TfyvcKgOXp
qa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvIlSPrzIB4Z2wyIGQpaPLlYflrrVFK
v9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9ChWFfgSXvrWDZspnU3Gjw/rMHrGnql
Htlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0whpBtXdyDjzBtQTaZJ7zTT/vlehc/
tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9IzCCBhQwggT8oAMCAQICEQDGvhmW
Z0DEAx0oURL6O6l+MA0GCSqGSIb3DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3Jl
YXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0
ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJl
IEVtYWlsIENBMB4XDTIyMDEwNzAwMDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJ
ARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3
GpC2bomUqk+91wLYBzDMcCj5C9m6oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZH
h7htyAkWYVoFsFPrwHounto8xTsySSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT
9YgcBqKCo65pTFmOnR/VVbjJk4K2xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNj
P+qDrh0db7PAjO1D4d5ftfrsf+kdRR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy
2U+eITZ5LLE5s45mX2oPFknWqxBobQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3
BgBEmfsYWlBXO8rVXfvPgLs32VdVNZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/
7auNVRmPB3v5SWEsH8xi4Bez2V9UKxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmd
lFYhAflWKQ03Ufiu8t3iBE3VJbc25oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9ae
lIl6vtbhMA+l0nfrsORMa4kobqQ5C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMB
AAGjggHMMIIByDAfBgNVHSMEGDAWgBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeD
Mcimo0oz8o1R1Nver3ZVpSkwDgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYw
FAYIKwYBBQUHAwQGCCsGAQUFBwMCMEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYB
BQUHAgEWF2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9j
cmwuc2VjdGlnby5jb20vU2VjdGlnb1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1h
aWxDQS5jcmwwgYoGCCsGAQUFBwEBBH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdv
LmNvbS9TZWN0aWdvUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAj
BggrBgEFBQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQv
Q/fzPXmtR9t54rpmI2TfyvcKgOXpqa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvI
lSPrzIB4Z2wyIGQpaPLlYflrrVFKv9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9Ch
WFfgSXvrWDZspnU3Gjw/rMHrGnqlHtlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0w
hpBtXdyDjzBtQTaZJ7zTT/vlehc/tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9
IzGCBMcwggTDAgEBMIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVz
dGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMT
NVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA
xr4ZlmdAxAMdKFES+jupfjANBglghkgBZQMEAgEFAKCCAeswGAYJKoZIhvcNAQkDMQsGCSqGSIb3
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjQwODA1MTEwODU2WjAvBgkqhkiG9w0BCQQxIgQgI8DUC769
aXauht8E3JkI8IkoJp1yAT4h6McIISwd6xowgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgACEURudDkAuBgakyH7WLdZD46Ed5fvWWhK
BJ0HeJ/vlTKal1vmZ3UyeclpG6ooI4yfwk8ZbN6wtYmvlFc775IOCITLy5gGTxFIt5rS99QK2dCe
IsesS0gS7DAHN2FYwRbYvszoBBPcvSyIIDSEkdX7CNaV+JmJJf63nknDKLeU9/L14NuoqjTmmNRv
zzHD06lBOKT70ETnhwQ3T82+3iYujbpmT6e9Imbdko9aTdv2mQUClOYL+f6NwlJsdzx3ZX5u3xvt
5m+UixlOkRMno1RCQhNIIuxTJTdlYP82DuihyS+bA0qJnQa4Yj4aqCg4aJCSnBtV6vi88b0BAXda
+hdT1v86wqxVck2NzwG7IksJimHa65x9iRzYr6antRz1VgZYfiNzXJPUTSBkWLR5v7FYgsiHeDyI
5slZ/Zi1/ii+8eu8Z5xHtca3nYdYrWG8JQPN7r3AYNZ6RVoQj1M6S6J6GICqRS+g7gPCWKGuYbKx
FgsGN0M0StzCpDRQ3JrmSWizjkoDJI45dn/K5I8iswfkCWEo4fxb6GlonSkMj8EbsH9Vs9GGZRMj
lio3F+NwAuamxyoRCHTSsXX/3n9HGqsTvNJoihSxwM9j9ugku2xkhGhDJiGC8RpTF5HzcNGuj5ER
3k6Wze8WUdBbo55MeqG+5NT+Tf+WdhHrbyAmXsSy0QAAAAAAAA==


--=-xxEVRkpemek+kcSHzsTG--

