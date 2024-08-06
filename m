Return-Path: <kvm+bounces-23404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 362BA9495B7
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 18:41:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E05EF28370C
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 16:41:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F3634174C;
	Tue,  6 Aug 2024 16:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Mn2P3ULj"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E63A2AE99;
	Tue,  6 Aug 2024 16:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722962464; cv=none; b=L6OYEMAXmXy54QkuJxFQ080EgcOf7Ah9CL4kRu5Uxficvm0NrOtmJCBnHUPWlIKRdrMylBttDEAXJ33sVPOEOWHRyyzHHrhhetilKt9udmmAmfxw56/KQosXYwx720yM2laWzoIM8XnZuPe88VgayFjvh0oEz2mwxdxt+edw/qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722962464; c=relaxed/simple;
	bh=7h0U3zv4x/bjHp3scR2KFQ7oAeKzjwlrm9SSGc+hHn4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oJk3Xgs+IHp9TWYz89pJ/uS1cIB6i/hjp0ziKod7myj1uLr1WJel+lo+gV5tayEMsJCzxuQ3zefyHgYeLnCNchfRJRqTlZme7eN6SC0LBiS4Olmz71IGHGYL07CjLv6ROu43qwiFyB1IlWW6E+h7HAUmOnaZs6oXJOmXWZuSTbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Mn2P3ULj; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uYRFjgYunHylqo95qhimOzNE6dkuMRV93hSqH+49pBg=; b=Mn2P3ULjULfN6kOXgeQ+gNbupN
	LsUBaCuhU9SKtqhokUrfObD08DRufpARfqv0ccQQDfh+YEo+0CkwR9CS7CAi701u5Uj/vNEOGDy7p
	ZXCFl8ranKNzHLDAf+dQPR5S4sxTdLep0gjuu8Ed8cT+5r0496lU9t6Kdhz8/SaWLOJRDXtWXAxdu
	V3xImsgUWe8GHq1WhQTQtql9Bb9Sp5NX0spS/F9Kssc/rTk5JIhe98JnCsRBtMAc4++j9YDvi8ef/
	UQ8YBqIXqx4MhWGC+HrsfXwpyMJLPBxvZxoEbz0f3o4VATKHwiWFn6KjaDSAbKBA128iUcubJ0duO
	o9M4QzXg==;
Received: from [2001:8b0:10b:5:95e1:bb50:f4dd:70b1] (helo=u3832b3a9db3152.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sbNEw-00000005yYK-1HPm;
	Tue, 06 Aug 2024 16:40:50 +0000
Message-ID: <d806ed85d2487a7798769de39c5b3f33c2f93b54.camel@infradead.org>
Subject: Re: [PATCH] KVM: Move gfn_to_pfn_cache invalidation to
 invalidate_range_end hook
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Mushahid Hussain
 <hmushi@amazon.co.uk>,  Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li
 <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>,  Joerg Roedel
 <joro@8bytes.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mingwei Zhang <mizhang@google.com>, Maxim Levitsky <mlevitsk@redhat.com>
Date: Tue, 06 Aug 2024 17:40:49 +0100
In-Reply-To: <ZrJIA6t8S9Ucjqzn@google.com>
References: <20220427014004.1992589-1-seanjc@google.com>
	 <20220427014004.1992589-7-seanjc@google.com>
	 <294c8c437c2e48b318b8c27eb7467430dfcba92b.camel@infradead.org>
	 <f862cefff2ed3f4211b69d785670f41667703cf3.camel@infradead.org>
	 <ZrFyM8rJZYjfFawx@google.com>
	 <dd6ca54cfd23dba0d3cba7c1ceefea1fdfcdecbe.camel@infradead.org>
	 <ZrItHce2GqAWoN0o@google.com>
	 <a21a90c76af446951956b4423b1f87beb91cb660.camel@infradead.org>
	 <ZrJIA6t8S9Ucjqzn@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-NldtdWfVdBR7STqnMUdL"
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-NldtdWfVdBR7STqnMUdL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2024-08-06 at 08:57 -0700, Sean Christopherson wrote:
> The last one is key: the pages have already been freed when invalidate_ra=
nge_end()
> is called, and so unmapping at that time would be too late.

OK, thanks.

> The obvious downside is what you've run into, where the start+end approac=
h forces
> KVM to wait for all in-flight invalidations to go away.=C2=A0 But again, =
in practice
> the rudimentary range tracking suffices for all known use cases.

Makes sense.

> I suspect you're trying to solve a problem that doesn't exist in practice=
.
> hva_to_pfn_retry() already has a cond_resched(), so getting stuck for a l=
ong
> duration isn't fatal, just suboptimal.=C2=A0 And similar to the range-bas=
ed tracking,
> _if_ there's a problem in practice, then it also affects guest page fault=
s.=C2=A0 KVM
> simply resumes the vCPU and keeps re-faulting until the in-flight invalid=
ation(s)
> has gone away.

Yeah. When it's looping on actual page faults it's easy to pretend it
isn't a busy-loop :)

Making it wait is fairly simple; it would be easy to just make it
cond_resched() instead though. Here's what I have so far (incremental).

https://git.infradead.org/?p=3Dusers/dwmw2/linux.git;a=3Dcommitdiff;h=3Dpfn=
cache-2

I need to revive the torture test you had at the end of your earlier series=
.

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 689e8be873a7..9b5261e11802 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -770,6 +770,9 @@ struct kvm {
 	/* For management / invalidation of gfn_to_pfn_caches */
 	spinlock_t gpc_lock;
 	struct list_head gpc_list;
+	u64 mmu_gpc_invalidate_range_start;
+	u64 mmu_gpc_invalidate_range_end;
+	wait_queue_head_t gpc_invalidate_wq;
=20
 	/*
 	 * created_vcpus is protected by kvm->lock, and is incremented
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ffd6ab4c2a16..a243f9f8a9c0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -775,6 +775,24 @@ static int kvm_mmu_notifier_invalidate_range_start(str=
uct mmu_notifier *mn,
 	 */
 	spin_lock(&kvm->mn_invalidate_lock);
 	kvm->mn_active_invalidate_count++;
+	if (likely(kvm->mn_active_invalidate_count =3D=3D 1) {
+		kvm->mmu_gpc_invalidate_range_start =3D range->start;
+		kvm->mmu_gpc_invalidate_range_end =3D range->end;
+	} else {
+		/*
+		 * Fully tracking multiple concurrent ranges has diminishing
+		 * returns. Keep things simple and just find the minimal range
+		 * which includes the current and new ranges. As there won't be
+		 * enough information to subtract a range after its invalidate
+		 * completes, any ranges invalidated concurrently will
+		 * accumulate and persist until all outstanding invalidates
+		 * complete.
+		 */
+		kvm->mmu_gpc_invalidate_range_start =3D
+			min(kvm->mmu_gpc_invalidate_range_start, range->start);
+		kvm->mmu_gpc_invalidate_range_end =3D
+			max(kvm->mmu_gpc_invalidate_range_end, range->end);
+	}
 	spin_unlock(&kvm->mn_invalidate_lock);
=20
 	/*
@@ -830,21 +848,27 @@ static void kvm_mmu_notifier_invalidate_range_end(str=
uct mmu_notifier *mn,
=20
 	__kvm_handle_hva_range(kvm, &hva_range);
=20
+	gfn_to_pfn_cache_invalidate(kvm, range->start, range->end);
+
 	/* Pairs with the increment in range_start(). */
 	spin_lock(&kvm->mn_invalidate_lock);
 	if (!WARN_ON_ONCE(!kvm->mn_active_invalidate_count))
 		--kvm->mn_active_invalidate_count;
 	wake =3D !kvm->mn_active_invalidate_count;
+	if (wake) {
+		kvm->mmu_gpc_invalidate_range_start =3D KVM_HVA_ERR_BAD;
+		kvm->mmu_gpc_invalidate_range_end =3D KVM_HVA_ERR_BAD;
+	}
 	spin_unlock(&kvm->mn_invalidate_lock);
=20
-	gfn_to_pfn_cache_invalidate(kvm, range->start, range->end);
-
 	/*
 	 * There can only be one waiter, since the wait happens under
 	 * slots_lock.
 	 */
-	if (wake)
+	if (wake) {
+		wake_up(&kvm->gpc_invalidate_wq);
 		rcuwait_wake_up(&kvm->mn_memslots_update_rcuwait);
+	}
 }
=20
 static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
@@ -1154,7 +1178,9 @@ static struct kvm *kvm_create_vm(unsigned long type, =
const char *fdname)
=20
 	INIT_LIST_HEAD(&kvm->gpc_list);
 	spin_lock_init(&kvm->gpc_lock);
-
+	init_waitqueue_head(&kvm->gpc_invalidate_wq);
+	kvm->mmu_gpc_invalidate_range_start =3D KVM_HVA_ERR_BAD;
+	kvm->mmu_gpc_invalidate_range_end =3D KVM_HVA_ERR_BAD;
 	INIT_LIST_HEAD(&kvm->devices);
 	kvm->max_vcpus =3D KVM_MAX_VCPUS;
=20
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 187b58150ef7..dad32ef5ac87 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -133,6 +133,39 @@ static void gpc_unmap(kvm_pfn_t pfn, void *khva)
 #endif
 }
=20
+static bool gpc_invalidations_pending(struct gfn_to_pfn_cache *gpc)
+{
+	/*
+	 * No need for locking on GPC here because these fields are protected
+	 * by gpc->refresh_lock.
+	 */
+	return unlikely(gpc->kvm->mn_active_invalidate_count) &&
+		(gpc->kvm->mmu_gpc_invalidate_range_start <=3D gpc->uhva) &&
+		(gpc->kvm->mmu_gpc_invalidate_range_end > gpc->uhva);
+}
+
+static void gpc_wait_for_invalidations(struct gfn_to_pfn_cache *gpc)
+{
+	spin_lock(&gpc->kvm->mn_invalidate_lock);
+	if (gpc_invalidations_pending(gpc)) {
+		DECLARE_WAITQUEUE(wait, current);
+
+		for (;;) {
+			prepare_to_wait(&gpc->kvm->gpc_invalidate_wq, &wait,
+					TASK_UNINTERRUPTIBLE);
+
+			if (!gpc_invalidations_pending(gpc))
+				break;
+
+			spin_unlock(&gpc->kvm->mn_invalidate_lock);
+			schedule();
+			spin_lock(&gpc->kvm->mn_invalidate_lock);
+		}
+		finish_wait(&gpc->kvm->gpc_invalidate_wq, &wait);
+	}
+	spin_unlock(&gpc->kvm->mn_invalidate_lock);
+}
+
 static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 {
 	/* Note, the new page offset may be different than the old! */
@@ -205,6 +238,15 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_ca=
che *gpc)
 			goto out_error;
 		}
=20
+		/*
+		 * Avoid populating a GPC with a user address which is already
+		 * being invalidated, if the invalidate_range_start() notifier
+		 * has already been called. The actual invalidation happens in
+		 * the invalidate_range_end() callback, so wait until there are
+		 * no active invalidations (for the relevant HVA).
+		 */
+		gpc_wait_for_invalidations(gpc);
+
 		write_lock_irq(&gpc->lock);
=20
 		/*


--=-NldtdWfVdBR7STqnMUdL
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjQwODA2MTY0MDQ5WjAvBgkqhkiG9w0BCQQxIgQgk+an4RWH
/7EL93HdAn5iGQ23YWORWAwGQtsLg9BgPU0wgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgAVnrUxfSR5vKIR7+N1VLmKNYZJB9OQBatT
lZTFNyj4hlUP//dvLHzGBtlanGQjmG3lcWMymkMdSmvYEJrirTeKwjpRzRiSXcV0j8UPo/XqmZvw
4jIgbhiHuXcIvtzN4hYqpcZIngR4SJaRbcbI4RyFOGnS5DQYYDHKjAgFZ2XdrHxULAB8Bo+2PNFa
g/Ye8w6OvRodHltiomLErMYtI8X4sBBIUDTJZk3XwOIoi6X77vAIVfIwvwbq1dOIf8v2OsIzbsXL
r5qjsCsULaMczi6Cax4kijIlqB+YucVAtDTlcaIHD/jy0KvWjgu+S3t5tuaKuSTYPFNx9hw/7ndZ
u0MmM6GPMqjIxRSVBykx1xtkXHA1FjBFRxANNh2UYTpug42OwAjFAthdQhzLpyI6bftrHYTFZvRI
8ibuRICzRXUi4h+0tfS90oaNlEFSv/eoIqO7i2pDmoyN0TDu8VXvheU9VQrrZMWYjgxyUqaYODQl
9ZCY9IRZsO+R52aYdPMjg5knJ27ieHDbehdACB5L8kMxe02XWPgvMhmIM4iRPrXeNxwi1NREBOJV
zfgwgUo6EUMA97HyLZHPMsbNxQ1U4gHlhTisdkPZWIoum+kOwn5Zoo2yNXBSAeyjf/L9Wp3HIO5V
EMF+DHZbTLs5f7S/sxFIc3PJwr4hPL7/8hxfiS5zRwAAAAAAAA==


--=-NldtdWfVdBR7STqnMUdL--

