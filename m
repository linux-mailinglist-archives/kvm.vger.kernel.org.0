Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3AB9BFBD7
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbfIZXTM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:19:12 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:53441 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729000AbfIZXTL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:19:11 -0400
Received: by mail-pl1-f202.google.com with SMTP id g13so453099plq.20
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ab8tif6jeEAXLrD8vhHhma3+C4AYyNv8PtxKZt4emaM=;
        b=e53IdVL8NTngyayc4GJItm3h4ccqyNk3lgOTOg2ql9hwB79nK+cf1dzrPCf77XY+za
         aybsJMJRSkPWruhRfYT6IAOq1m7zE17wzLoOqKxyNCGERGpnlgle9lgfJgcSIkpzGqgO
         A6cXOKfAQLOSiwIJWf2zOUjiC5ArueiQ4fuucX4ek7fn3CaXY6vfwFt0BSHRH7WLZNsB
         wl/yi2Xqa5Lv9YYNeAoLOFvTuC8MPuCDj6RuSc8qTUG7og72kLKWvaO/fE0AJwafsGT7
         +/RJaVe/vJzIdkbMvP7yXM2GVDA486yG1tv+QPco5qYCd9wSJoN9Yomnet5zbbHTgvHH
         8Neg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ab8tif6jeEAXLrD8vhHhma3+C4AYyNv8PtxKZt4emaM=;
        b=ib7ybfDThjEnOqXayhvlBZo3Hqf/lolAFs+wGXURQX5l9G5CzmwkqmnWKDHrEUxwg4
         A42frEcz5fDlOFqNBsIe6nUStvqCSsEPUW2h/UdfP2MFFcn2KfVGYnRywKu+PuT+hdV1
         y1rFFD0s1l63DmM+l+YV/exP8WCrwBKKoQInmgTFCS0jQY6CkrcnOy/win4rDcDn6Y+q
         qAb/XN5aSIX37u5QlReEdtMrMLToWlMMTNNE4TvCU7B1+NiP/FId6k3PkxeVV706TXsQ
         +reNTHyv3Fb633YNEgLrFUcIGFnegtU8waY5g9wh5BLcLxdDDIXsVHl4fINSMTvm+wpr
         E9qQ==
X-Gm-Message-State: APjAAAVTMx9O8ppa/pZh+AoHx75srpyuHPDNllbgjBQaBpVa+OHnzu5N
        N2/qU2AejMfr1bUBA9/PJaSjV1zEZuRn+gihY79rMKMcTS36RuTvtYdwQzTMfgktAKTZcph2rKK
        UWohfJ5bvWrdxMPAoxcJvxOxRXMb2skE5idhUyLvWVK7ajgaviLOkMDD7oYAG
X-Google-Smtp-Source: APXvYqylVdBUNUgHe0+IWIEUyxS1qY4EPWeTmVx0dw6QaQf8R1MRboN82DojvVJi/vR/jB3boVabAeDe/sBm
X-Received: by 2002:a63:f401:: with SMTP id g1mr6224858pgi.314.1569539950737;
 Thu, 26 Sep 2019 16:19:10 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:15 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-20-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 19/28] kvm: mmu: Make address space ID a property of memslots
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

Save address space ID as a field in each memslot so that functions that
do not use rmaps (which implicitly encode the address space id) can
handle multiple address spaces correctly.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 350a3b79cc8d1..ce6b22fcb90f3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -347,6 +347,7 @@ struct kvm_memory_slot {
 	struct kvm_arch_memory_slot arch;
 	unsigned long userspace_addr;
 	u32 flags;
+	int as_id;
 	short id;
 };
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c8559a86625ce..d494044104270 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -969,6 +969,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	new.base_gfn = base_gfn;
 	new.npages = npages;
 	new.flags = mem->flags;
+	new.as_id = as_id;
 
 	if (npages) {
 		if (!old.npages)
-- 
2.23.0.444.g18eeb5a265-goog

