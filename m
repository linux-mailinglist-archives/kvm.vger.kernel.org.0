Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD2234F594
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 02:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbhCaAuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 20:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232467AbhCaAts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 20:49:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BF6C061574
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 17:49:48 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id g9so449525ybc.19
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 17:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=UCRZL7KtC6hAv8hxA1ExjdbtxqOT/SBsALkv1r7beao=;
        b=uHMg0cFT+fEKMEWK8V5K3WzXglXjI7x+kKFOaGNsIsv6Vfn2zin+T7x/d2lJP90lXT
         Bd1LehSBMHPCt+dMCElqKJ435JiFDEPP/E1af1DpZu+HvHCNlqiu/IapnYDDR0EA2TwT
         sJr6BMcANM2brzI7xSGl54UIt91ICOe4/F77wckB7rBaClqSgedxGaIQELnAa1dB+tjj
         55AViueUvUML00898EUsCCegs92b1Z+UjyBpXAOY7gA9zmxB48mrQLhBpeVUrgebJROs
         PVxtivTaY/poRr1idiyOd7KpyqVI2wMRPKjz1plIXwAZoO4ys6OKSG7sJXs0NMq91n+A
         pQ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=UCRZL7KtC6hAv8hxA1ExjdbtxqOT/SBsALkv1r7beao=;
        b=o77qG0ONT50uMZrCNQPQXeRaWbErG7jLPxs/Ndo560AC5FMeJulor5eBDb3UaLma1e
         X235/ti5fE6TOizR9dztbMVbwqTc9ClH36IV8HPGq3YqSySMBPGaCcEGLIhwUs+slkRN
         V+ikRTaNZrm6IHJCE5R4yx3NMUNVQ1BM0HQa3+04a1YZkGE+PjvmcksF89lYcVYSx+dc
         6APhKVGnX80kysO5008lZJ79QWMNx9M8dhNVDickLIK7hMqKP8MO1BaYvV84VZalC7cY
         1rmg0z1f/uSws+POCteWF7/UiBYXfujixSBQFrrlIrx6uveVyC+L6miPDs/eYtqbUwu1
         tf2Q==
X-Gm-Message-State: AOAM5336ROKFEbu3LBWcaaO8qMxfTwIsHYaPwfrWBjsQMxpRUtY7aaTv
        CHRs0JwgQh0GHkHeTu0kfSJpHt4FATA=
X-Google-Smtp-Source: ABdhPJzeaxpSyGdpS0Vl6Xq9PRSLWwR78jRGbWUD35V9+T1hq4V+hfns3QOfQm1DNxUu3k8upa50kpXs6ps=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:6c6b:5d63:9b3b:4a77])
 (user=seanjc job=sendgmr) by 2002:a05:6902:70e:: with SMTP id
 k14mr1263170ybt.286.1617151787807; Tue, 30 Mar 2021 17:49:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Mar 2021 17:49:41 -0700
In-Reply-To: <20210331004942.2444916-1-seanjc@google.com>
Message-Id: <20210331004942.2444916-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210331004942.2444916-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 1/2] KVM: x86/mmu: Remove spurious clearing of dirty bit from
 TDP MMU SPTE
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't clear the dirty bit when aging a TDP MMU SPTE (in response to a MMU
notifier event).  Prematurely clearing the dirty bit could cause spurious
PML updates if aging a page happened to coincide with dirty logging.

Note, tdp_mmu_set_spte_no_acc_track() flows into __handle_changed_spte(),
so the host PFN will be marked dirty, i.e. there is no potential for data
corruption.

Fixes: a6a0b05da9f3 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f0c99fa04ef2..724088bea4b0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -978,7 +978,6 @@ static int age_gfn_range(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 			new_spte = mark_spte_for_access_track(new_spte);
 		}
-		new_spte &= ~shadow_dirty_mask;
 
 		tdp_mmu_set_spte_no_acc_track(kvm, &iter, new_spte);
 		young = 1;
-- 
2.31.0.291.g576ba9dcdaf-goog

