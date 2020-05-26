Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5048B1E1B29
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 08:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbgEZGWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 02:22:14 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13895 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728138AbgEZGWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 02:22:13 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eccb53a0000>; Mon, 25 May 2020 23:20:42 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 25 May 2020 23:22:10 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 25 May 2020 23:22:10 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 May
 2020 06:22:10 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 26 May 2020 06:22:10 +0000
Received: from sandstorm.nvidia.com (Not Verified[10.2.58.199]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5eccb5920000>; Mon, 25 May 2020 23:22:10 -0700
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
Subject: [PATCH 0/2] KVM: SVM: convert get_user_pages() --> pin_user_pages(), bug fixes
Date:   Mon, 25 May 2020 23:22:05 -0700
Message-ID: <20200526062207.1360225-1-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590474042; bh=xyHCUTas3F16ZK+n98+gQf/X3rsWdl0q0EXVHn6zcqQ=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         MIME-Version:X-NVConfidentiality:Content-Transfer-Encoding:
         Content-Type;
        b=ey7+nu0R2FPsgmiBmHjb7F5Y0ADHbPJ0yum97UBILsXbjXAtn3kOVKjSj1QKjVnQm
         iQXdYCvx0qaJZMEFGKZahaThMMdnDvoi6FGdpvhkLJCRheWBG1apBurFlPNiNnCKLM
         wz8F5ThCruyg7jUyt+7loyRsDSmanTCg3FWFjg/nebLBDK7jP6oIIkBJAFm8czFw8R
         IEbOP4U79X767fLsRqt1lJ3/9zlzV7i1G7spOHS9QkTfDsfkEjuouu35pZxYx03obh
         u3YgPJ1iyu2URs8jIBpx57ojeauDJfPbINW/655wqs/ISdDx1fkppwOom9ADXqy5J3
         UKwU1YIayHCOA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This is just for the SEV (Secure Encrypted Virtualization) part of KVM.
It converts the get_user_pages_fast() call, after fixing a couple of
small bugs in the vicinity.

Note that I have only compile-tested these two patches, so any run-time
testing coverage would be greatly appreciated.

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


John Hubbard (2):
  KVM: SVM: fix svn_pin_memory()'s use of get_user_pages_fast()
  KVM: SVM: convert get_user_pages() --> pin_user_pages()

 arch/x86/kvm/svm/sev.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)


base-commit: 9cb1fd0efd195590b828b9b865421ad345a4a145
--=20
2.26.2

