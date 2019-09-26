Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2A8BFBC6
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbfIZXSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:18:39 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:33586 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728929AbfIZXSi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:18:38 -0400
Received: by mail-pf1-f202.google.com with SMTP id z4so512666pfn.0
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eNTPd+DTCd3OebIMAQPAzFyuA2Zn5iBi3EOKt04jDxU=;
        b=YCq6sGeYsBo0Fs5pjpNrSPiXOqpiSKi6WQqPcN0vHF6UirDvcO/HYn0NJ3EFRIt30p
         70y3QvbvZAuojow+ZxeJ6b0Sgh4TBwBKzliiMxVdBWWp3jT3PUKrCd+NbeiwZnQc92Ii
         8yoszQAjrwweAD+O4kZIj1r44Gxj7wWBXaAdfX2jgA5lRY31NMowhdNrk/MttNVtgL7A
         2W6M48RdFFziw3m4Q3Ln1zgk0LCkLutCmrUoqI6XD49nS08H5xjZ+bejpBUtNJ1tTc20
         a6ntVpu908FjJ4hUyDumnJjVzzInPYiimcs1CdNWFPu6bdGJx9gSs+TiBKWHixe8JlCv
         dNVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eNTPd+DTCd3OebIMAQPAzFyuA2Zn5iBi3EOKt04jDxU=;
        b=UG3u1mejHxy98tEj/JyPfUFxHmWtsJjJTn//5c7rLCw+64BAwySdqMPutOfsgnxxIb
         4tqrpKJPSI6AaT1WcrJ/KITnDYhta72eKznV9mvprOkt06+VgdIhU74aPulTgfPJywBi
         LFIAnXbLpN4ipZDou/4rlw3iwzjdr9p3nKqrS6+6eats5ziR1TPgRSoInQ2xRHgXepZM
         LT7D2HcbSyboRR7UGwmvfKmOWcwANS7r8cL4ZYjfkBXzzVNvaHnoqO8wgTQqNZZZJpcO
         hh/fbRyItZpnSyn29rraLuE8uwu0qTJ011V2sWMuDNipoypjgoOrGimZAP3EazbP8Wnf
         Y0Iw==
X-Gm-Message-State: APjAAAWuZtzUcSDGPXpkgSv+Yxe83UdysJXxtGmt2gP66UzQq3Ksxj0J
        0b5TNXrg5ZLOXoFz+tiDLRSkggBhsKwuP6OOVj2Rg8ilt91LU0UzMJMmFGXoIDUqz9OmmVvKcFc
        PYhg2Qc9VhfeDRXhIzHsisNDEeoN7uRm4ITtApGaciZUQ7E7JUfzVEfIywjBb
X-Google-Smtp-Source: APXvYqxvO5MrPDXceVx9VzMqc0dmKVX6z29ss/HOncVR1XzdETw0B8MMoJ6xsI6HupVbEUGjymKn5P96iP/c
X-Received: by 2002:a63:79c4:: with SMTP id u187mr6039593pgc.152.1569539917219;
 Thu, 26 Sep 2019 16:18:37 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:00 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-5-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 04/28] kvm: mmu: Update the lpages stat atomically
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to pave the way for more concurrent MMU operations, updates to
VM-global stats need to be done atomically. Change updates to the lpages
stat to be atomic in preparation for the introduction of parallel page
fault handling.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1ecd6d51c0ee0..56587655aecb9 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1532,7 +1532,7 @@ static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
 		WARN_ON(page_header(__pa(sptep))->role.level ==
 			PT_PAGE_TABLE_LEVEL);
 		drop_spte(kvm, sptep);
-		--kvm->stat.lpages;
+		xadd(&kvm->stat.lpages, -1);
 		return true;
 	}
 
@@ -2676,7 +2676,7 @@ static bool mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 		if (is_last_spte(pte, sp->role.level)) {
 			drop_spte(kvm, spte);
 			if (is_large_pte(pte))
-				--kvm->stat.lpages;
+				xadd(&kvm->stat.lpages, -1);
 		} else {
 			child = page_header(pte & PT64_BASE_ADDR_MASK);
 			drop_parent_pte(child, spte);
@@ -3134,7 +3134,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep, unsigned pte_access,
 	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
 	trace_kvm_mmu_set_spte(level, gfn, sptep);
 	if (!was_rmapped && is_large_pte(*sptep))
-		++vcpu->kvm->stat.lpages;
+		xadd(&vcpu->kvm->stat.lpages, 1);
 
 	if (is_shadow_present_pte(*sptep)) {
 		if (!was_rmapped) {
-- 
2.23.0.444.g18eeb5a265-goog

