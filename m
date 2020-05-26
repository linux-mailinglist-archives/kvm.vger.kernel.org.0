Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B95A1E1B27
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 08:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgEZGWL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 02:22:11 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19460 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725271AbgEZGWL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 02:22:11 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eccb5860001>; Mon, 25 May 2020 23:21:58 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 25 May 2020 23:22:10 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 25 May 2020 23:22:10 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 May
 2020 06:22:10 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 26 May 2020 06:22:10 +0000
Received: from sandstorm.nvidia.com (Not Verified[10.2.58.199]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5eccb5920003>; Mon, 25 May 2020 23:22:10 -0700
From:   John Hubbard <jhubbard@nvidia.com>
To:     LKML <linux-kernel@vger.kernel.org>
CC:     Souptick Joarder <jrdr.linux@gmail.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H . Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <kvm@vger.kernel.org>
Subject: [PATCH 2/2] KVM: SVM: convert get_user_pages() --> pin_user_pages()
Date:   Mon, 25 May 2020 23:22:07 -0700
Message-ID: <20200526062207.1360225-3-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526062207.1360225-1-jhubbard@nvidia.com>
References: <20200526062207.1360225-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590474118; bh=tz89/U9nJLhJJR5Sd/v7QdEjaWAsrMmrR1p0WWS02cw=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=en5+07K3K87dvSFosQl8nq+VlAY/WLVi2X9m15JN/jOsp2TBg7wd5uBMEAq/biCpW
         ooihrLQ0OmJ1rFtObCiJJLgaqipnnZuUD8+7dXpAaNLAeamQDHPpSa1xpiRmVCDcQB
         zGwQXr6EDy9MvhQmAEEMwD/2R8amSNPQbil2PvvFyQzGeEFXVWU7F1ajUbxfEcgvNf
         S6i8MfZoTeeoaKNfhfQnjH3hnY9A1Me4seLrFIbSJRmPK8JXSUcTGhYEc5i1Fuo9lk
         wEVIRmn5nzy/IVYlArynEoHQx7BDp7yHIiBze1LR66kR3iKe2ez2rYliTbbVJQOmWz
         qsD6gzrlmqHSA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This code was using get_user_pages*(), in a "Case 2" scenario
(DMA/RDMA), using the categorization from [1]. That means that it's
time to convert the get_user_pages*() + put_page() calls to
pin_user_pages*() + unpin_user_pages() calls.

There is some helpful background in [2]: basically, this is a small
part of fixing a long-standing disconnect between pinning pages, and
file systems' use of those pages.

[1] Documentation/core-api/pin_user_pages.rst

[2] "Explicit pinning of user-space pages":
    https://lwn.net/Articles/807108/

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 arch/x86/kvm/svm/sev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9693db1af57c..a83f2e73bcbb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -349,7 +349,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, un=
signed long uaddr,
 		return NULL;
=20
 	/* Pin the user virtual address. */
-	npinned =3D get_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pa=
ges);
+	npinned =3D pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pa=
ges);
 	if (npinned !=3D npages) {
 		pr_err("SEV: Failure locking %lu pages.\n", npages);
 		goto err;
@@ -362,7 +362,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, un=
signed long uaddr,
=20
 err:
 	if (npinned > 0)
-		release_pages(pages, npinned);
+		unpin_user_pages(pages, npinned);
=20
 	kvfree(pages);
 	return NULL;
@@ -373,7 +373,7 @@ static void sev_unpin_memory(struct kvm *kvm, struct pa=
ge **pages,
 {
 	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
=20
-	release_pages(pages, npages);
+	unpin_user_pages(pages, npages);
 	kvfree(pages);
 	sev->pages_locked -=3D npages;
 }
--=20
2.26.2

