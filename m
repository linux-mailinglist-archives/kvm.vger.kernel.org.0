Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7E936F9A1
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 13:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhD3Lxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 07:53:32 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:58215 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhD3Lxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 07:53:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1619783564; x=1651319564;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Dtx/M6xk+T/uqMTyekx1GTapviS8Xmbt6xkcI97Wv+c=;
  b=rnShq6/TRzXYXseTCKcSqbIzVCNOrTKuNduQnXbXy4Ql+DgVLKloNM2p
   pytkcoQy/DJtBrHQhqFq/PRRCDQVJWU4cl4fB630CXyBdmYKvzgh43GLF
   m76vGtOw7wRtDs2vflUptnIUoMy4bl2yewrbZKcI+UuwtllJMo9X9JW0R
   g=;
X-IronPort-AV: E=Sophos;i="5.82,262,1613433600"; 
   d="scan'208";a="930352322"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1a-af6a10df.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 30 Apr 2021 11:52:34 +0000
Received: from EX13D49EUA004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-af6a10df.us-east-1.amazon.com (Postfix) with ESMTPS id 107F0A1FB1;
        Fri, 30 Apr 2021 11:52:32 +0000 (UTC)
Received: from EX13D09EUA004.ant.amazon.com (10.43.165.157) by
 EX13D49EUA004.ant.amazon.com (10.43.165.250) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 30 Apr 2021 11:52:31 +0000
Received: from EX13D09EUA004.ant.amazon.com ([10.43.165.157]) by
 EX13D09EUA004.ant.amazon.com ([10.43.165.157]) with mapi id 15.00.1497.015;
 Fri, 30 Apr 2021 11:52:31 +0000
From:   "Shahin, Md Shahadat Hossain" <shahinmd@amazon.de>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Szczepanek, Bartosz" <bsz@amazon.de>,
        "seanjc@google.com" <seanjc@google.com>,
        "bgardon@google.com" <bgardon@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: [PATCH v2] kvm/x86: Fix 'lpages' kvm stat for TDM MMU
Thread-Topic: [PATCH v2] kvm/x86: Fix 'lpages' kvm stat for TDM MMU
Thread-Index: AQHXPbWN7k8o6AHTZ0CvACgVIr8ztw==
Date:   Fri, 30 Apr 2021 11:52:31 +0000
Message-ID: <1619783551459.35424@amazon.de>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.162.28]
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Large pages not being created properly may result in increased memory
access time. The 'lpages' kvm stat used to keep track of the current
number of large pages in the system, but with TDP MMU enabled the stat
is not showing the correct number.

This patch extends the lpages counter to cover the TDP case.

Signed-off-by: Md Shahadat Hossain Shahin <shahinmd@amazon.de>
Cc: Bartosz Szczepanek <bsz@amazon.de>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bc1283ed4db6..f89a140b8dea 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -240,6 +240,13 @@ static void __handle_changed_spte(struct kvm *kvm, int=
 as_id, gfn_t gfn,
 	if (old_spte =3D=3D new_spte)
 		return;
 =

+	if (is_large_pte(old_spte) !=3D is_large_pte(new_spte)) {
+		if (is_large_pte(old_spte))
+			atomic64_sub(1, (atomic64_t*)&kvm->stat.lpages);
+		else
+			atomic64_add(1, (atomic64_t*)&kvm->stat.lpages);
+	}
+
 	/*
 	 * The only times a SPTE should be changed from a non-present to
 	 * non-present state is when an MMIO entry is installed/modified/
-- =

2.17.1



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



