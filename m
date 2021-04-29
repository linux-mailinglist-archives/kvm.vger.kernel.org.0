Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7738336EAD1
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 14:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237279AbhD2Mrk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 08:47:40 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:40277 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237050AbhD2Mrj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 08:47:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1619700413; x=1651236413;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HOS0BVs2Yph8gEQGh2vvpwgdubvvvKzjdHeFOkb2D/I=;
  b=A31/jhxs1DOOGYEGgYL6aI6N74XMUYSMxdgJYoA9uNHjU7tpjDT4p/gg
   Jb45SIsM9CpnfeA39rC0HPw/rF6odQmwmNO2e5JEtF97YFj66QhnlB7HS
   iv8foRs/ICGTnr+haC0KfqE9RrShC3aYkxzJRefQS7S3/1gpwwKrcPO0O
   M=;
X-IronPort-AV: E=Sophos;i="5.82,259,1613433600"; 
   d="scan'208";a="104730971"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 29 Apr 2021 12:46:52 +0000
Received: from EX13D49EUA003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 8AB4C2805E6;
        Thu, 29 Apr 2021 12:46:51 +0000 (UTC)
Received: from EX13D09EUA004.ant.amazon.com (10.43.165.157) by
 EX13D49EUA003.ant.amazon.com (10.43.165.222) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 29 Apr 2021 12:46:50 +0000
Received: from EX13D09EUA004.ant.amazon.com ([10.43.165.157]) by
 EX13D09EUA004.ant.amazon.com ([10.43.165.157]) with mapi id 15.00.1497.015;
 Thu, 29 Apr 2021 12:46:50 +0000
From:   "Shahin, Md Shahadat Hossain" <shahinmd@amazon.de>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Szczepanek, Bartosz" <bsz@amazon.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "bgardon@google.com" <bgardon@google.com>
Subject: Subject: [RFC PATCH] kvm/x86: Fix 'lpages' kvm stat for TDM MMU
Thread-Topic: Subject: [RFC PATCH] kvm/x86: Fix 'lpages' kvm stat for TDM MMU
Thread-Index: AQHXPPVj2bcPJ2lBOUWRavYwOTNimg==
Date:   Thu, 29 Apr 2021 12:46:50 +0000
Message-ID: <1619700409955.15104@amazon.de>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.160.81]
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
 arch/x86/kvm/mmu/tdp_mmu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 34207b874886..1e2a3cb33568 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -425,6 +425,12 @@ static void __handle_changed_spte(struct kvm *kvm, int=
 as_id, gfn_t gfn,
 =

 	if (old_spte =3D=3D new_spte)
 		return;
+	=

+	if (is_large_pte(old_spte))
+		--kvm->stat.lpages;
+	=

+	if (is_large_pte(new_spte))
+		++kvm->stat.lpages;
 =

 	trace_kvm_tdp_mmu_spte_changed(as_id, gfn, level, old_spte, new_spte);
 =

-- =

2.17.1



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



