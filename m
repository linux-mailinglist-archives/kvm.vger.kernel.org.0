Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E1D29C4EF
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 19:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1823945AbgJ0SBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 14:01:00 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:48887 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1823725AbgJ0R7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 13:59:52 -0400
Received: by mail-qk1-f201.google.com with SMTP id z16so1309913qkg.15
        for <kvm@vger.kernel.org>; Tue, 27 Oct 2020 10:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=pOTcENHU6wqJJ3cPGXaUEXXcmuzILdwS9IUGREQEYLU=;
        b=AVgaJ/v4KywVIrgTz57lMlfjx3jDjDwAYJ6aYsfyb2gTP1Endgev6TCUT6NK3dVO5c
         9vlF0AfnyBKeqndCJVCcvnGjqblnfDahVldKiOBsM6O1aSUZ/wucJ21H956cTu0o5py8
         p9LWSHkquW05lQbYO61oW0VxGH3gdW+yu0gxSNcQBDt76xRUT3oChrv2fl1JL+UHtSe3
         ng2sehmakCgFytvf2alnQjipxnQC/c8QFaPsvwYwc+FlogWLd4vuiN+EDi2jo5TlTN8o
         kcyJaVBtKeNGoutAl31mvIemzV5GGS/QHTKSSRZzYJ453UY3DjQNTn/9OxFAqTn2Avfl
         xXng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pOTcENHU6wqJJ3cPGXaUEXXcmuzILdwS9IUGREQEYLU=;
        b=TeuYWuou7pzeMHBTsjdEGRfjkYQJSc9othdvwtHhAmsJM77NnVnU6TvbbxEKz2tGhm
         ekTkTcoffltiySJOwwJfkwipJOtsMOENbMnyeCE8p8TE5DEk3j7nL4Ar1fGFFdA1QVRh
         oBAvJi+vdEle6EUg06lYvKU7xp0mlM6CJECe2+jM//4HmmSp5ibe+C3roLAXGmeV/NP1
         F4DlPjr1ozy5IvnrMAAITXh0N/2IM651/yKLuxohZI9en9fV5C/X8Trmq70uEXhKkMta
         GxrGK7+Tz0q36rbOeQyIp32c3Hp5V6/h6/f2gdkSWk4cxH4NtqzvwCxRCoAoQVJ+Y6Vh
         LcKw==
X-Gm-Message-State: AOAM531hywQrFdxd28UAAy4NFGzqGspGiyTTePo4cGOMMpvBJo9U+Z3J
        u5bCUO8ZeEmefVbeHQFQX2Ic/XGAFuod
X-Google-Smtp-Source: ABdhPJxXP3MCaof8IMN7lQHYqo/fDn4xCqd6YNisdN1pPMqUmwwr3qGS47G3JTeiSwOHNBj3loLOA/XHaVDc
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a0c:e054:: with SMTP id
 y20mr3875558qvk.30.1603821589510; Tue, 27 Oct 2020 10:59:49 -0700 (PDT)
Date:   Tue, 27 Oct 2020 10:59:44 -0700
In-Reply-To: <20201027175944.1183301-1-bgardon@google.com>
Message-Id: <20201027175944.1183301-2-bgardon@google.com>
Mime-Version: 1.0
References: <20201027175944.1183301-1-bgardon@google.com>
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
Subject: [PATCH 2/2] kvm: x86/mmu: Add TDP MMU SPTE changed trace point
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an extremely verbose trace point to the TDP MMU to log all SPTE
changes, regardless of callstack / motivation. This is useful when a
complete picture of the paging structure is needed or a change cannot be
explained with the other, existing trace points.

Tested: ran the demand paging selftest on an Intel Skylake machine with
	all the trace points used by the TDP MMU enabled and observed
	them firing with expected values.

This patch can be viewed in Gerrit at:
https://linux-review.googlesource.com/c/virt/kvm/kvm/+/3813

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmutrace.h | 29 +++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c  |  2 ++
 2 files changed, 31 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index 213699b27b448..e798489b56b55 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -381,6 +381,35 @@ TRACE_EVENT(
 	)
 );
 
+TRACE_EVENT(
+	kvm_tdp_mmu_spte_changed,
+	TP_PROTO(int as_id, gfn_t gfn, int level, u64 old_spte, u64 new_spte),
+	TP_ARGS(as_id, gfn, level, old_spte, new_spte),
+
+	TP_STRUCT__entry(
+		__field(u64, gfn)
+		__field(u64, old_spte)
+		__field(u64, new_spte)
+		/* Level cannot be larger than 5 on x86, so it fits in a u8. */
+		__field(u8, level)
+		/* as_id can only be 0 or 1 x86, so it fits in a u8. */
+		__field(u8, as_id)
+	),
+
+	TP_fast_assign(
+		__entry->gfn = gfn;
+		__entry->old_spte = old_spte;
+		__entry->new_spte = new_spte;
+		__entry->level = level;
+		__entry->as_id = as_id;
+	),
+
+	TP_printk("as id %d gfn %llx level %d old_spte %llx new_spte %llx",
+		  __entry->as_id, __entry->gfn, __entry->level,
+		  __entry->old_spte, __entry->new_spte
+	)
+);
+
 #endif /* _TRACE_KVMMMU_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 047e2d966abef..5820c36ccfdca 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -241,6 +241,8 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	if (old_spte == new_spte)
 		return;
 
+	trace_kvm_tdp_mmu_spte_changed(as_id, gfn, level, old_spte, new_spte);
+
 	/*
 	 * The only times a SPTE should be changed from a non-present to
 	 * non-present state is when an MMIO entry is installed/modified/
-- 
2.29.0.rc2.309.g374f81d7ae-goog

