Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5E01E1B2A
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 08:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgEZGWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 02:22:14 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13893 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725271AbgEZGWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 02:22:13 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eccb53a0001>; Mon, 25 May 2020 23:20:42 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 25 May 2020 23:22:10 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 25 May 2020 23:22:10 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 May
 2020 06:22:10 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 26 May 2020 06:22:10 +0000
Received: from sandstorm.nvidia.com (Not Verified[10.2.58.199]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5eccb5920002>; Mon, 25 May 2020 23:22:10 -0700
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
Subject: [PATCH 1/2] KVM: SVM: fix svn_pin_memory()'s use of get_user_pages_fast()
Date:   Mon, 25 May 2020 23:22:06 -0700
Message-ID: <20200526062207.1360225-2-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526062207.1360225-1-jhubbard@nvidia.com>
References: <20200526062207.1360225-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590474042; bh=AzbBhbmfNLGU9QQd3KrM41vIMJiGiViVOVN10y9DMkc=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=dpvKsqJh4h5Z2BhpqEVc3v6UcgU5o/vCA95fTXvUOxYoScXTrr9Lg4O3ueM29978W
         4BLIV+gymq+4pv+u32F3pE98YnnwMlbCBi8nUAfIBb5BQ2srnsx2E/De5o3rUbTN0r
         yqiQDfmNk//62pRKdG76kAB2cKscT0ZjPabQkHn2lxzGmQ8J9912mcvZ8Ou9ENo/j7
         X1129T1qjZClMHyuBgxwQpv9HMJ2SDURPlXWVxKX4QEsNb6f4HZRk3folnOwMTaKDY
         ncopQzo4p78OypaWdCb9t4C+hrm3gwJj9tRxpZTI5yQBMI0ECuIsdQDwuSEsJCw/BF
         sXOuL3NvR/fGg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are two problems in svn_pin_memory():

1) The return value of get_user_pages_fast() is stored in an
unsigned long, although the declared return value is of type int.
This will not cause any symptoms, but it is misleading.
Fix this by changing the type of npinned to "int".

2) The number of pages passed into get_user_pages_fast() is stored
in an unsigned long, even though get_user_pages_fast() accepts an
int. This means that it is possible to silently overflow the number
of pages.

Fix this by adding a WARN_ON_ONCE() and an early error return. The
npages variable is left as an unsigned long for convenience in
checking for overflow.

Fixes: 89c505809052 ("KVM: SVM: Add support for KVM_SEV_LAUNCH_UPDATE_DATA =
command")
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
 arch/x86/kvm/svm/sev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 89f7f3aebd31..9693db1af57c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -313,7 +313,8 @@ static struct page **sev_pin_memory(struct kvm *kvm, un=
signed long uaddr,
 				    int write)
 {
 	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
-	unsigned long npages, npinned, size;
+	unsigned long npages, size;
+	int npinned;
 	unsigned long locked, lock_limit;
 	struct page **pages;
 	unsigned long first, last;
@@ -333,6 +334,9 @@ static struct page **sev_pin_memory(struct kvm *kvm, un=
signed long uaddr,
 		return NULL;
 	}
=20
+	if (WARN_ON_ONCE(npages > INT_MAX))
+		return NULL;
+
 	/* Avoid using vmalloc for smaller buffers. */
 	size =3D npages * sizeof(struct page *);
 	if (size > PAGE_SIZE)
--=20
2.26.2

