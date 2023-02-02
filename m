Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0BC7688659
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbjBBS2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232156AbjBBS2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:28:16 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE3215CA0
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:28:15 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id s4-20020a056a00194400b0058d9b9fecb6so1363134pfk.1
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=68l7Ca3pftQohWSSywgHUbTYrISqbCJiWjSISNH3A/g=;
        b=EMXPzaTxaxT9UedHi545O+WFewb41vhprDn/JgWd0GuGuUVJf5bJ/x9JMOgYr/DaUo
         GbRid8cxpf9fdXPEp33jBiP2VbnEyzckcdCFs7ozLk3ZyQfN8gRLTpYGA1paFQLWnOvY
         VCC3muI5+X/9OTSPo8pmYE1G3+g+77IGW8s5dN8ACqGG1y1m3K87eLAWbR4LTwMeY60n
         R2GY+cV9cHHulDNM/vtauKXntnFTmlx9V/URQHJrZFL1dBB3JkanU+9ruEO0KMEnqz0I
         6XgC/3Dv3SMD6uxplAxGSCDFMj73TutdCu0MOt4JuHMmUS9zI4MflVOwcaDl/7JL2sy9
         cyAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=68l7Ca3pftQohWSSywgHUbTYrISqbCJiWjSISNH3A/g=;
        b=BIid0aHhEYhzjDc+By1NWahcb/dh1mnBo6S7g7qz6K6Tyzoj2N+f7VJUG2G1MU503q
         S0tlX2zKGir7Eu3U0KTXeYIEzK1MOWrGSeiMUTT4rejrLMozpDJfuz0cvsyEqgiIpeko
         uVFpbb+qqpPmYV5DsAUaFrogVlF4WMtDDtHTft4/ZRDO1VH9VNy6tgKCFOrMU6UJIOrq
         ft/19XhV9KrQGExFuwOvYtCVsI63QjRXQqWJRtol/oCU4rJSHpUWO1CyMhNv9o9OSiE5
         P76siL5nBDuaQNZd9SHyHV4Yxn04+l/aK5uDo9qsynzGMUfxJg4wsUhymjPDgBgBzJ6B
         jJqg==
X-Gm-Message-State: AO0yUKX35wjovIPFOyfyTEzhogFSdFOgtuxwFVIjYFxQREgcdtbSVb2+
        XaMiOWWPwwVp13MCUiBqtQKa73GOAbJZ
X-Google-Smtp-Source: AK7set+tq80lCPirC/Q7fZiaHWWA0G4qZtd25vxjs6e6KXDvK/8v0jvJmn3Hi/zasYd/8TK7vU5rUlgciAHI
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:903:120e:b0:196:44d4:244b with SMTP id
 l14-20020a170903120e00b0019644d4244bmr1762579plh.8.1675362494885; Thu, 02 Feb
 2023 10:28:14 -0800 (PST)
Date:   Thu,  2 Feb 2023 18:27:50 +0000
In-Reply-To: <20230202182809.1929122-1-bgardon@google.com>
Mime-Version: 1.0
References: <20230202182809.1929122-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230202182809.1929122-3-bgardon@google.com>
Subject: [PATCH 02/21] KVM: x86/mmu: Replace comment with an actual lockdep
 assertion on mmu_lock
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Assert that mmu_lock is held for write in __walk_slot_rmaps() instead of
hoping the function comment will magically prevent introducing bugs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 09a0a2cc76bae..2ea8e58f83256 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5805,7 +5805,6 @@ typedef bool (*slot_rmaps_handler) (struct kvm *kvm,
 				    struct kvm_rmap_head *rmap_head,
 				    const struct kvm_memory_slot *slot);
 
-/* The caller should hold mmu-lock before calling this function. */
 static __always_inline bool __walk_slot_rmaps(struct kvm *kvm,
 					      const struct kvm_memory_slot *slot,
 					      slot_rmaps_handler fn,
@@ -5815,6 +5814,8 @@ static __always_inline bool __walk_slot_rmaps(struct kvm *kvm,
 {
 	struct slot_rmap_walk_iterator iterator;
 
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
 	for_each_slot_rmap_range(slot, start_level, end_level, start_gfn,
 			end_gfn, &iterator) {
 		if (iterator.rmap)
-- 
2.39.1.519.gcb327c4b5f-goog

