Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE87E19BA5F
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 04:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733308AbgDBCgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 22:36:45 -0400
Received: from ozlabs.org ([203.11.71.1]:42495 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727135AbgDBCgp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 22:36:45 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48t6dh5T7Wz9sQt;
        Thu,  2 Apr 2020 13:36:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1585795001;
        bh=gvH+b1yhEEXi4hltTGU/dEz55S7XWG8/Z8nwvw29J6k=;
        h=Date:From:To:Cc:Subject:From;
        b=qP5YLDMi5e9RXEU/t6f9G9TVheuDFnomV9xxTQQcBowK32uTfPJu8lcLRqd2KKdkX
         sFju3AKcIE8dsbf8FhrloqwDy/4HV7y73ngTmlJLH0Eut2D7ZKCyf7ptt0opm4Nzqs
         6wYcJQ8eW8kVySShQjpr3bw2C50c4jfKd3D83rvyhXjrU5OYHyGK4nlE8/1QOs3HNy
         M8eBLH3mh1T6dMs6dXe4Andd8m3n5ejr5rM9Aaex50nAZn4zed320InZbShS+Qqp5P
         pi/MidFcupZUhmjTlLYLMlzEepmEjG9adkrEHdMy7OkqOYOzIRCqygm9EZHYniyLeH
         OAJL9LepOtepA==
Date:   Thu, 2 Apr 2020 13:36:37 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Haiwei Li <lihaiwei.kernel@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: linux-next: manual merge of the kvm tree with Linus' tree
Message-ID: <20200402133637.296e70a9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Zh.g8kRmfO3B2E/BrGXIkPA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/Zh.g8kRmfO3B2E/BrGXIkPA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/kvm/svm/svm.c

between commits:

  aaca21007ba1 ("KVM: SVM: Fix the svm vmexit code for WRMSR")
  2da1ed62d55c ("KVM: SVM: document KVM_MEM_ENCRYPT_OP, let userspace detec=
t if SEV is available")
  2e2409afe5f0 ("KVM: SVM: Issue WBINVD after deactivating an SEV guest")

from Linus' tree and commits:

  83a2c705f002 ("kVM SVM: Move SVM related files to own sub-directory")
  41f08f0506c0 ("KVM: SVM: Move SEV code to separate file")

(at least)

from the kvm tree.

Its a bit of a pain this code movement appearing during the merge
window.  Is it really intended for v5.7?

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 621a36702636..2be5bbae3a40 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -34,6 +34,7 @@
 #include <asm/kvm_para.h>
 #include <asm/irq_remapping.h>
 #include <asm/spec-ctrl.h>
+#include <asm/cpu_device_id.h>
=20
 #include <asm/virtext.h>
 #include "trace.h"
@@ -47,7 +48,7 @@ MODULE_LICENSE("GPL");
=20
 #ifdef MODULE
 static const struct x86_cpu_id svm_cpu_id[] =3D {
-	X86_FEATURE_MATCH(X86_FEATURE_SVM),
+	X86_MATCH_FEATURE(X86_FEATURE_SVM, NULL),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, svm_cpu_id);
@@ -3715,7 +3716,8 @@ static void svm_handle_exit_irqoff(struct kvm_vcpu *v=
cpu,
 	enum exit_fastpath_completion *exit_fastpath)
 {
 	if (!is_guest_mode(vcpu) &&
-		to_svm(vcpu)->vmcb->control.exit_code =3D=3D EXIT_REASON_MSR_WRITE)
+	    to_svm(vcpu)->vmcb->control.exit_code =3D=3D SVM_EXIT_MSR &&
+	    to_svm(vcpu)->vmcb->control.exit_info_1)
 		*exit_fastpath =3D handle_fastpath_set_msr_irqoff(vcpu);
 }

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3ef57dee48cc..0e3fc311d7da 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -920,6 +920,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	if (!svm_sev_enabled())
 		return -ENOTTY;
=20
+	if (!argp)
+		return 0;
+
 	if (copy_from_user(&sev_cmd, argp, sizeof(struct kvm_sev_cmd)))
 		return -EFAULT;
=20
@@ -1030,14 +1033,6 @@ find_enc_region(struct kvm *kvm, struct kvm_enc_regi=
on *range)
 static void __unregister_enc_region_locked(struct kvm *kvm,
 					   struct enc_region *region)
 {
-	/*
-	 * The guest may change the memory encryption attribute from C=3D0 -> C=
=3D1
-	 * or vice versa for this memory range. Lets make sure caches are
-	 * flushed to ensure that guest data gets written into memory with
-	 * correct C-bit.
-	 */
-	sev_clflush_pages(region->pages, region->npages);
-
 	sev_unpin_memory(kvm, region->pages, region->npages);
 	list_del(&region->list);
 	kfree(region);
@@ -1062,6 +1057,13 @@ int svm_unregister_enc_region(struct kvm *kvm,
 		goto failed;
 	}
=20
+	/*
+	 * Ensure that all guest tagged cache entries are flushed before
+	 * releasing the pages back to the system for use. CLFLUSH will
+	 * not do this, so issue a WBINVD.
+	 */
+	wbinvd_on_all_cpus();
+
 	__unregister_enc_region_locked(kvm, region);
=20
 	mutex_unlock(&kvm->lock);
@@ -1083,6 +1085,13 @@ void sev_vm_destroy(struct kvm *kvm)
=20
 	mutex_lock(&kvm->lock);
=20
+	/*
+	 * Ensure that all guest tagged cache entries are flushed before
+	 * releasing the pages back to the system for use. CLFLUSH will
+	 * not do this, so issue a WBINVD.
+	 */
+	wbinvd_on_all_cpus();
+
 	/*
 	 * if userspace was terminated before unregistering the memory regions
 	 * then lets unpin all the registered memory.
--=20
2.25.0

--=20
Cheers,
Stephen Rothwell

--Sig_/Zh.g8kRmfO3B2E/BrGXIkPA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6FT7UACgkQAVBC80lX
0GyLAAf+M/wSnhBJJWiRoQcmYUv3MRToPG4Wbec0MoGFqarlSDVhbxzDmBUKlAcn
ElEjHRnatpeQsxHSNNZkx799gujfiJIkuK2U+8H55GFr7JNQJ6YJbECTnZl4GhYS
538easezADtVPK9QQ28AbO8XOQLK2UVfp0gFVrtWFfXvSeffpahY0Yt4egnNrUFZ
onig9umewuZK28hQ8UPWDjGah9JWdnQayYCaeW5u+EVj1unJkK56ajtpsE5MQ9i5
rCMEHMgrUZzGPTHQwit5kTpO44T9sK2yuVJ5NaqdRXegJt9AEEyhdutbh39DNoWO
3+8N+GpQyfAjidGMT/LVG4ob2kP1/w==
=ikCJ
-----END PGP SIGNATURE-----

--Sig_/Zh.g8kRmfO3B2E/BrGXIkPA--
