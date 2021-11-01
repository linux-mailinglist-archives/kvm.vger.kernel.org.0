Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9621F441524
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 09:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbhKAITK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 04:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbhKAITJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Nov 2021 04:19:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C29C061714
        for <kvm@vger.kernel.org>; Mon,  1 Nov 2021 01:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=O444bY3df2i3IXFfUdlxUpeifL8Ay/uJ2A5CLD0v9PU=; b=zFPaG6UX9i7xmkj1VOfklDEUVj
        gh0YsRisUxOPQ0go5oaWr0FxJ/i8BP/Ag/7tdfxKFdvtgRIgohlucXiW7KQExR6dLpp0WniIRJBMy
        XgG0d1TldwUwBUGjQrBPzfTq5gOBQg35eyXK+rki5OJqRB7UhaOpyzHvHMTrnVDTHvtv7D3VRbJr0
        S5TLq159KBwLNPzhj8Q4HivovhcY6unM2xV7AA7a+VACoTFHydt8IGRcS6JytKZtrUvEsDBXyRafb
        YDN0pcK2yG60BfLBJz/Rzl1XAmJGHk//ycCr4tRhoukx79B96YuEiLpXqIo3Xznsj9yq3r60ZM6FF
        BoyfrLaQ==;
Received: from [2001:8b0:10b:1::3ae] (helo=u3832b3a9db3152.ant.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mhSUR-00FdST-RI; Mon, 01 Nov 2021 08:16:24 +0000
Message-ID: <8ba4d8cf27f03eb13841ebb9039fc4ff15fa1b50.camel@infradead.org>
Subject: Re: [EXTERNAL] [PATCH] KVM: x86/xen: Fix runstate updates to be
 atomic when preempting vCPU
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raslan, KarimAllah" <karahmed@amazon.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>
Cc:     "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>
Date:   Mon, 01 Nov 2021 08:16:20 +0000
In-Reply-To: <fb6f1f4bc7d3c5c470587cb8fde5b59f1efd4b0f.camel@infradead.org>
References: <3d2a13164cbc61142b16edba85960db9a381bebe.camel@amazon.co.uk>
         <09f4468b-0916-cf2c-1cef-46970a238ce4@redhat.com>
         <a0906628f31e359deb9e9a6cdf15eb72920c5960.camel@infradead.org>
         <2e7bcafe1077d31d8af6cc0cd120a613cc070cfb.camel@infradead.org>
         <95bee081-c744-1586-d4df-0d1e04a8490f@redhat.com>
         <8950681efdae90b089fcbe65fb0f39612b33cea5.camel@infradead.org>
         <c0dd5fcd-343c-1186-0b1b-3a8ce8a797fe@redhat.com>
         <fb6f1f4bc7d3c5c470587cb8fde5b59f1efd4b0f.camel@infradead.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-wb0hfdxZuxqpI6qFyrss"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-wb0hfdxZuxqpI6qFyrss
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2021-10-31 at 08:31 +0000, David Woodhouse wrote:
> On Sun, 2021-10-31 at 07:52 +0100, Paolo Bonzini wrote:
> > On 30/10/21 09:58, David Woodhouse wrote:
> > > > Absolutely!  The fixed version of kvm_map_gfn should not do any
> > > > map/unmap, it should do it eagerly on MMU notifier operations.
> >=20
> > > Staring at this some more... what*currently*  protects a
> > > gfn_to_pfn_cache when the page tables change =E2=80=94 either because=
 userspace
> > > either mmaps something else over the same HVA, or the underlying page
> > > is just swapped out and restored?
> >=20
> > kvm_cache_gfn_to_pfn calls gfn_to_pfn_memslot, which pins the page.
>=20
> Empirically, this breaks the test case in the series I sent out last
> night, because the kernel is looking at the *wrong* shared info page
> after userspace maps a new one at that HVA...

The fun part now looks like this; if this is deemed sane I'll work up
something that fixes the steal time thing in a similar way. And maybe
turn it into a generic 'gfn_to_kva_cache'?

The full series, with the final patch showing how it gets used, is at
https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/xen-evt=
chn

=46rom a329c575aadc0b65bb7ebd97eaf9f9374508cea9 Mon Sep 17 00:00:00 2001
From: David Woodhouse <dwmw@amazon.co.uk>
Date: Sat, 30 Oct 2021 19:53:23 +0100
Subject: [PATCH 5/6] KVM: x86/xen: Maintain valid mapping of Xen shared_inf=
o
 page

In order to allow for event channel delivery, we would like to have a
kernel mapping of the shared_info page which can be accessed in atomic
context in the common case.

The gfn_to_pfn_cache only automatically handles invalidation when the
KVM memslots change; it doesn't handle a change in the userspace HVA
to host PFN mappings. So hook into the MMU notifiers to invalidate the
shared_info pointer on demand.

The shared_info can be accessed while holding the shinfo_lock, with a
slow path which takes the kvm->lock mutex to refresh the mapping.
I'd like to use RCU for the invalidation but I don't think we can
always sleep in the invalidate_range notifier. Having a true kernel
mapping of the page means that our access to it can be atomic anyway,
so holding a spinlock is OK.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  4 ++
 arch/x86/kvm/mmu/mmu.c          | 23 ++++++++++++
 arch/x86/kvm/xen.c              | 65 +++++++++++++++++++++++++++------
 include/linux/kvm_host.h        | 26 -------------
 include/linux/kvm_types.h       | 27 ++++++++++++++
 5 files changed, 107 insertions(+), 38 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 13f64654dfff..bb4868c3c06b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1017,6 +1017,10 @@ struct kvm_xen {
 	bool long_mode;
 	u8 upcall_vector;
 	gfn_t shinfo_gfn;
+	rwlock_t shinfo_lock;
+	void *shared_info;
+	struct kvm_host_map shinfo_map;
+	struct gfn_to_pfn_cache shinfo_cache;
 };
=20
 enum kvm_irqchip_mode {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0cc58901bf7a..429a4860d67a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -25,6 +25,7 @@
 #include "kvm_emulate.h"
 #include "cpuid.h"
 #include "spte.h"
+#include "xen.h"
=20
 #include <linux/kvm_host.h>
 #include <linux/types.h>
@@ -1588,6 +1589,28 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm=
_gfn_range *range)
 {
 	bool flush =3D false;
=20
+	if (static_branch_unlikely(&kvm_xen_enabled.key)) {
+		write_lock(&kvm->arch.xen.shinfo_lock);
+
+		if (kvm->arch.xen.shared_info &&
+		    kvm->arch.xen.shinfo_gfn >=3D range->start &&
+		    kvm->arch.xen.shinfo_cache.gfn < range->end) {
+			/*
+			 * If kvm_xen_shared_info_init() had *finished* mapping the
+			 * page and assigned the pointer for real, then mark the page
+			 * dirty now instead of via the eventual cache teardown.
+			 */
+			if (kvm->arch.xen.shared_info !=3D KVM_UNMAPPED_PAGE) {
+				kvm_set_pfn_dirty(kvm->arch.xen.shinfo_cache.pfn);
+				kvm->arch.xen.shinfo_cache.dirty =3D false;
+			}
+
+			kvm->arch.xen.shared_info =3D NULL;
+		}
+
+		write_unlock(&kvm->arch.xen.shinfo_lock);
+	}
+
 	if (kvm_memslots_have_rmaps(kvm))
 		flush =3D kvm_handle_gfn_range(kvm, range, kvm_unmap_rmapp);
=20
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 565da9c3853b..9d143bc7d769 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -21,18 +21,59 @@
=20
 DEFINE_STATIC_KEY_DEFERRED_FALSE(kvm_xen_enabled, HZ);
=20
-static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
+static void kvm_xen_shared_info_unmap(struct kvm *kvm)
+{
+	bool was_valid =3D false;
+
+	write_lock(&kvm->arch.xen.shinfo_lock);
+	if (kvm->arch.xen.shared_info)
+		was_valid =3D true;
+	kvm->arch.xen.shared_info =3D NULL;
+	kvm->arch.xen.shinfo_gfn =3D GPA_INVALID;
+	write_unlock(&kvm->arch.xen.shinfo_lock);
+
+	if (kvm_vcpu_mapped(&kvm->arch.xen.shinfo_map)) {
+		kvm_unmap_gfn(kvm, &kvm->arch.xen.shinfo_map,
+			      &kvm->arch.xen.shinfo_cache, was_valid, false);
+
+		/* If the MMU notifier invalidated it, the gfn_to_pfn_cache
+		 * may be invalid. Force it to notice */
+		if (!was_valid)
+			kvm->arch.xen.shinfo_cache.generation =3D -1;
+	}
+}
+
+static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn, bool updat=
e_clock)
 {
 	gpa_t gpa =3D gfn_to_gpa(gfn);
 	int wc_ofs, sec_hi_ofs;
 	int ret =3D 0;
 	int idx =3D srcu_read_lock(&kvm->srcu);
=20
-	if (kvm_is_error_hva(gfn_to_hva(kvm, gfn))) {
-		ret =3D -EFAULT;
+	kvm_xen_shared_info_unmap(kvm);
+
+	if (gfn =3D=3D GPA_INVALID)
 		goto out;
-	}
+
+	/* Let the MMU notifier know that we are in the process of mapping it */
+	write_lock(&kvm->arch.xen.shinfo_lock);
+	kvm->arch.xen.shared_info =3D KVM_UNMAPPED_PAGE;
 	kvm->arch.xen.shinfo_gfn =3D gfn;
+	write_unlock(&kvm->arch.xen.shinfo_lock);
+
+	ret =3D kvm_map_gfn(kvm, gfn, &kvm->arch.xen.shinfo_map,
+			  &kvm->arch.xen.shinfo_cache, false);
+	if (ret)
+		goto out;
+
+	write_lock(&kvm->arch.xen.shinfo_lock);
+	/* Unless the MMU notifier already invalidated it */
+	if (kvm->arch.xen.shared_info =3D=3D KVM_UNMAPPED_PAGE)
+		kvm->arch.xen.shared_info =3D kvm->arch.xen.shinfo_map.hva;
+	write_unlock(&kvm->arch.xen.shinfo_lock);
+
+	if (!update_clock)
+		goto out;
=20
 	/* Paranoia checks on the 32-bit struct layout */
 	BUILD_BUG_ON(offsetof(struct compat_shared_info, wc) !=3D 0x900);
@@ -260,15 +301,9 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_x=
en_hvm_attr *data)
 		break;
=20
 	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
-		if (data->u.shared_info.gfn =3D=3D GPA_INVALID) {
-			kvm->arch.xen.shinfo_gfn =3D GPA_INVALID;
-			r =3D 0;
-			break;
-		}
-		r =3D kvm_xen_shared_info_init(kvm, data->u.shared_info.gfn);
+		r =3D kvm_xen_shared_info_init(kvm, data->u.shared_info.gfn, true);
 		break;
=20
-
 	case KVM_XEN_ATTR_TYPE_UPCALL_VECTOR:
 		if (data->u.vector && data->u.vector < 0x10)
 			r =3D -EINVAL;
@@ -661,11 +696,17 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xe=
n_hvm_config *xhc)
=20
 void kvm_xen_init_vm(struct kvm *kvm)
 {
-	kvm->arch.xen.shinfo_gfn =3D GPA_INVALID;
+	rwlock_init(&kvm->arch.xen.shinfo_lock);
 }
=20
 void kvm_xen_destroy_vm(struct kvm *kvm)
 {
+	struct gfn_to_pfn_cache *cache =3D &kvm->arch.xen.shinfo_cache;
+
+	kvm_xen_shared_info_unmap(kvm);
+
+	kvm_release_pfn(cache->pfn, cache->dirty, cache);
+
 	if (kvm->arch.xen_hvm_config.msr)
 		static_branch_slow_dec_deferred(&kvm_xen_enabled);
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 749cdc77fc4e..f0012d128aa5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -251,32 +251,6 @@ enum {
 	READING_SHADOW_PAGE_TABLES,
 };
=20
-#define KVM_UNMAPPED_PAGE	((void *) 0x500 + POISON_POINTER_DELTA)
-
-struct kvm_host_map {
-	/*
-	 * Only valid if the 'pfn' is managed by the host kernel (i.e. There is
-	 * a 'struct page' for it. When using mem=3D kernel parameter some memory
-	 * can be used as guest memory but they are not managed by host
-	 * kernel).
-	 * If 'pfn' is not managed by the host kernel, this field is
-	 * initialized to KVM_UNMAPPED_PAGE.
-	 */
-	struct page *page;
-	void *hva;
-	kvm_pfn_t pfn;
-	kvm_pfn_t gfn;
-};
-
-/*
- * Used to check if the mapping is valid or not. Never use 'kvm_host_map'
- * directly to check for that.
- */
-static inline bool kvm_vcpu_mapped(struct kvm_host_map *map)
-{
-	return !!map->hva;
-}
-
 static inline bool kvm_vcpu_can_poll(ktime_t cur, ktime_t stop)
 {
 	return single_task_running() && !need_resched() && ktime_before(cur, stop=
);
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 2237abb93ccd..2092f4ca156b 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -60,6 +60,33 @@ struct gfn_to_pfn_cache {
 	bool dirty;
 };
=20
+#define KVM_UNMAPPED_PAGE	((void *) 0x500 + POISON_POINTER_DELTA)
+
+struct kvm_host_map {
+	/*
+	 * Only valid if the 'pfn' is managed by the host kernel (i.e. There is
+	 * a 'struct page' for it. When using mem=3D kernel parameter some memory
+	 * can be used as guest memory but they are not managed by host
+	 * kernel).
+	 * If 'pfn' is not managed by the host kernel, this field is
+	 * initialized to KVM_UNMAPPED_PAGE.
+	 */
+	struct page *page;
+	void *hva;
+	kvm_pfn_t pfn;
+	kvm_pfn_t gfn;
+};
+
+/*
+ * Used to check if the mapping is valid or not. Never use 'kvm_host_map'
+ * directly to check for that.
+ */
+static inline bool kvm_vcpu_mapped(struct kvm_host_map *map)
+{
+	return !!map->hva;
+}
+
+
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 /*
  * Memory caches are used to preallocate memory ahead of various MMU flows=
,
--=20
2.31.1


--=-wb0hfdxZuxqpI6qFyrss
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
MTAxMDgxNjIwWjAvBgkqhkiG9w0BCQQxIgQgUM8iTP4YASaVjicqsCWJdew18mmqeZ4uFxtf9ch3
ETEwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAKLaxJJxVtHavjL7t7BGmT4UJ46KaxHupZq/Xf4hhkFqylzAhCGFLT1N0f3AyEBA
4SNzEJFlFUVuT0fN02bNO7kx/EEWpJGUZsiXM1rq9Aod4vk9yqmfUY3lctFDQe+dbrlAVOd5I7Ho
SnRFiqZzzW11ffJdQzjgnWocTR9/Lwg85YyOipWNJxe8Ca4CHsWad+mXa4dc3FhyFdI/ig+Sb6AM
MCNBfhTvf6eVaAguMFADlfpts2s3lzvuP1apeHE/7F39zkg/2cNUgyelZQ6SFtN4OQCbi00UFWDF
yntzyt34//SWr2DZnXry77w08Cq+NH1GX2DZqLirwK6zwCTPOYkAAAAAAAA=


--=-wb0hfdxZuxqpI6qFyrss--

