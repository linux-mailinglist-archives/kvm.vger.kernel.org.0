Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD1947E962
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350774AbhLWWYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350554AbhLWWYC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:24:02 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64EDDC06175F
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:02 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id y2-20020a17090a1f4200b001b103d6b6d0so6408082pjy.1
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=BNCCSYnc3JAlm7sEigQj1irsmiDBhrB62HCDCGqzwM4=;
        b=hsx3AHY9e9KGs5P9Y/6uTZVutXLJXF3CgK88i4NdUo3gvWGHAaH/hzMV99ToAe8QNh
         yh8fX6SyxC12fB88YAwO7kI032Jxfa3v6wrr/20tiI0G5ZTkBxI5gW15jV1Zhe58uCKU
         5RZ6gBAO1oksMgd5g0+eF/Eu3NQ5gNj/BE9/GGs9fAct3ToiAprcvH90xNW7o0nNzTuz
         vPi+xQVbNURRJL/SM40i++TwCmFGkFyUeEcHJngaIdf9XWBJWs3LlgKLmCZdcpRBLzuC
         VZyL1E1m/JZ3MTBSITppI5+IHIb/04xt62Xx3BwYUs/MLhjQ/ozRh8weHP29er8X78xs
         7oWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=BNCCSYnc3JAlm7sEigQj1irsmiDBhrB62HCDCGqzwM4=;
        b=PGG1EIrypSwROXqohOa5+ySmHrTUh3RsX3JFPolBOe+U7niKsZXeI7LQg6OG8hS2S0
         gbIM2UKZLmP99ulPIIdrldhzSaLKK67iGVzz88HGfid/FdseWwOFVo0/IC1BOiSWyupF
         cWbBYHJ8v3GxVT/54NOvJN5F3jwJ2sUCdoHZMyFxS5UlasXGQYb0kfbJBU1x76cMmZ1S
         k4fOnhyczF7lkiVUWm/gjCfZVEOjHubcevPn9uK3ndGnaQry55a0KnNRIbTsmMMJNt6c
         M2t2kQ3Q56CmKeVHh3rcCB9qLjdWC3dub9L5QH3OVPNVXL3zYD2X9sp4uZWF6wqoo2v2
         DDHg==
X-Gm-Message-State: AOAM530OUcQU/w/uFtljt4Jj0Edz1tTxt1Iz2gT11KwFKa5bDOhTMa9l
        Wz9qSm+xYtnxHJNu92kUznGmSJsBNXc=
X-Google-Smtp-Source: ABdhPJyrIjNroCeHcGoLme72TYYoLeEFX8HuM7VJuuvDeTFICp/qElBwDUte+nFyADv0mybL0LB72crz4rk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:e91:: with SMTP id
 fv17mr4976856pjb.217.1640298241971; Thu, 23 Dec 2021 14:24:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:23:01 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-14-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 13/30] KVM: x86/mmu: Drop RCU after processing each root in
 MMU notifier hooks
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop RCU protection after processing each root when handling MMU notifier
hooks that aren't the "unmap" path, i.e. aren't zapping.  Temporarily
drop RCU to let RCU do its thing between roots, and to make it clear that
there's no special behavior that relies on holding RCU across all roots.

Currently, the RCU protection is completely superficial, it's necessary
only to make rcu_dereference() of SPTE pointers happy.  A future patch
will rely on holding RCU as a proxy for vCPUs in the guest, e.g. to
ensure shadow pages aren't freed before all vCPUs do a TLB flush (or
rather, acknowledge the need for a flush), but in that case RCU needs to
be held until the flush is complete if and only if the flush is needed
because a shadow page may have been removed.  And except for the "unmap"
path, MMU notifier events cannot remove SPs (don't toggle PRESENT bit,
and can't change the PFN for a SP).

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6c51548d89b1..47424e22a681 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1071,18 +1071,19 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 	struct tdp_iter iter;
 	bool ret = false;
 
-	rcu_read_lock();
-
 	/*
 	 * Don't support rescheduling, none of the MMU notifiers that funnel
 	 * into this helper allow blocking; it'd be dead, wasteful code.
 	 */
 	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
+		rcu_read_lock();
+
 		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
 			ret |= handler(kvm, &iter, range);
+
+		rcu_read_unlock();
 	}
 
-	rcu_read_unlock();
 
 	return ret;
 }
-- 
2.34.1.448.ga2b2bfdf31-goog

