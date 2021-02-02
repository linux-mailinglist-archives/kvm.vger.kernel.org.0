Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3530030CAD1
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239133AbhBBTBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239221AbhBBS60 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 13:58:26 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B178C061573
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:57:46 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id m21so15016007qtp.6
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=KTYEyXIgb4wI42K1yBcuqU69rlausMxtU1GwO2JJSfc=;
        b=A3SMO1A6jAqBUExSNWmRam6ysZiwsIlC52mBxT2bopExdqHIBugBrv/ileXZbdnRGF
         i8cVgOJh+zPcodoOUyleOTeF3fMbp4DaOIUDSujm6e6/7JmPxeQlrgtKDMigIhPBFzjW
         Xqiqa9WEoZ2UW+mP6GwHpblG/H2H8weZzseRVsKfn/YV7BCWl2E+gvJ1+3P7KBd7jGGp
         LnzaAVttOqPI9eBilD+UWW9acrjfAvbtPMLs/AaAe8Zff4CCewn7UMSyDnlipvlgHexG
         MDSPtzb/nEzSvA+2X8UUqlK54rdhJ9boWVXOg2MqNj8zbD0QK9BteYRh3RwsBw0UWm5Z
         60Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KTYEyXIgb4wI42K1yBcuqU69rlausMxtU1GwO2JJSfc=;
        b=bFROvdEAR+TnmHL1ZEmkWtfFqysucnsd0tm+rtikJchEbLfZfNTXsYjIAKCAcdOFVE
         roIBTAoxI7DiwWAov3hP39VB/2TMmVPknCsnvTz/jJQQlLQmSU9jKHw0gt+XCqpxHsPC
         F59zLijo2hUwwzKupmmEKvXiPWtxJDV35r3ZAStbsfLWHDJqw4/zeLYTDPDLWroaYivB
         NXNLX3Yr0fK6SbUzqOvv9hEkSTn35pka0vcOOAyd+YIyMW78xBR8n6iLnSeNszZv3S/7
         PhHsY6peYjnqFf4xSlZ1wzLTmtk38FG5pCxrTXYUYZOMADBQBjCn8XIJACKq33ShPcfg
         C38A==
X-Gm-Message-State: AOAM5326nzIEfatGeOkM5XyZq3fSIr5WbuUubWqm0qOMVJWFKUe5oo5y
        O+blmiJl3MlIylgdIjRc7IRgANzwSQV0
X-Google-Smtp-Source: ABdhPJw35iQ1myHf6nwzdvwrNMRryl3/GMsxE12DKFd8FH4ic90uHjpGrPkdi51usxmn3uQAKzCJ0aULv8k0
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9090:561:5a98:6d47])
 (user=bgardon job=sendgmr) by 2002:ad4:4f41:: with SMTP id
 eu1mr21827353qvb.34.1612292265673; Tue, 02 Feb 2021 10:57:45 -0800 (PST)
Date:   Tue,  2 Feb 2021 10:57:10 -0800
In-Reply-To: <20210202185734.1680553-1-bgardon@google.com>
Message-Id: <20210202185734.1680553-5-bgardon@google.com>
Mime-Version: 1.0
References: <20210202185734.1680553-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH v2 04/28] KVM: x86/mmu: Don't redundantly clear TDP MMU pt memory
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM MMU caches already guarantee that shadow page table memory will
be zeroed, so there is no reason to re-zero the page in the TDP MMU page
fault handler.

No functional change intended.

Reviewed-by: Peter Feiner <pfeiner@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b83a6a3ad29c..3828c0e83466 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -655,7 +655,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level);
 			list_add(&sp->link, &vcpu->kvm->arch.tdp_mmu_pages);
 			child_pt = sp->spt;
-			clear_page(child_pt);
 			new_spte = make_nonleaf_spte(child_pt,
 						     !shadow_accessed_mask);
 
-- 
2.30.0.365.g02bc693789-goog

