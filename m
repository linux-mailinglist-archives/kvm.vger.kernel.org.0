Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9106A4E7CEE
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 01:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiCYXdN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 19:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234184AbiCYXdM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 19:33:12 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7645B5BE6E
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 16:31:37 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id z9-20020a637e09000000b003836f42edfbso4497030pgc.22
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 16:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=tufvfSWY9raGchFT5U16B+276W1zCmg9SmAHZU5wbiw=;
        b=N/UpJetG7UvnLv5mjrU30pNxid1gU4YuB1Gc/dgyjrWfdK0yd1BMJz/6dNfGVOesfZ
         1CB+MkpgDFZRHv30a+hEaOoHzmwezOAhvIErUbvqAL2PT3yYt9a+Yk/6wnyFkNPD2lN1
         +cLq7WQWOcRDryxlcJCl+c74a5sV6/ROhZMxC95olnAYgIJgUD3KgHT9FnRExzv86bw/
         CUJAyATvgsAuKfb4Lo+CwHo5jAS34ai2puFi4uhueHAiNZ5UlWeuB4Al3yjhloqvATzE
         n1W+FfXl21UU89mpQN9C+jat86toWKW4CnnPNDCrf94Dl2QfjwgwL2pwEtXHyUW/MoCW
         FRYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=tufvfSWY9raGchFT5U16B+276W1zCmg9SmAHZU5wbiw=;
        b=lstpD7Q30KXDABO+VBn33GiwmBvcOMLa/QM7TzW/XSgQfeUTnkGR9jubBuvqeMd34e
         eRhMhJDFTYDAZeJ2cN92Ib4pD6H65M/k87h/iCT6duk/+LXTGKUYFCHnPnB+7Lzk/y/u
         xPxFFJsKT2GC9x5APQuRKhoJjaMRs8Sp1LbTAI33Ht2qW4j+mKVy2Tpn3KS9gpAoSYw8
         TRFCNdmi5GuWiiD88E03dFubLM1YtgAXg0YDCD+m2WRSirzyOlWDP5pD0jBi+B4d2m0s
         SAxKovGLShxb0XJCCSqYwq13SITenI6c750/Nd5e4nbOt1BdN/EjD2Z4i/u4XEm88U5s
         scAg==
X-Gm-Message-State: AOAM533mP8e/+3vVWAGpeZOv2iJh6RYs4NU7Z52K6xhlhU5kvRre5NCF
        Ti5bhXk/kWWPa9KJDAtGs/Pg54s/gYOp
X-Google-Smtp-Source: ABdhPJwE4ynaVAE6qX71B3LxHXvN/vp8KeBJUKGFzeitehZG7IowP2jsXS2GcxnMV5DTIgVTQRRwAYi96BoV
X-Received: from vipinsh.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:36b0])
 (user=vipinsh job=sendgmr) by 2002:a05:6a00:1a89:b0:4fa:b21d:2cd with SMTP id
 e9-20020a056a001a8900b004fab21d02cdmr12363942pfv.62.1648251096929; Fri, 25
 Mar 2022 16:31:36 -0700 (PDT)
Date:   Fri, 25 Mar 2022 23:31:25 +0000
Message-Id: <20220325233125.413634-1-vipinsh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH] KVM: x86/mmu: Speed up slot_rmap_walk_next for sparsely
 populated rmaps
From:   Vipin Sharma <vipinsh@google.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Avoid calling handlers on empty rmap entries and skip to the next non
empty rmap entry.

Empty rmap entries are noop in handlers.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Change-Id: I8abf0f4d82a2aae4c5d58b80bcc17ffc30785ffc
---
 arch/x86/kvm/mmu/mmu.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 51671cb34fb6..f296340803ba 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1499,11 +1499,14 @@ static bool slot_rmap_walk_okay(struct slot_rmap_walk_iterator *iterator)
 	return !!iterator->rmap;
 }
 
-static void slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
+static noinline void
+slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
 {
-	if (++iterator->rmap <= iterator->end_rmap) {
+	while (++iterator->rmap <= iterator->end_rmap) {
 		iterator->gfn += (1UL << KVM_HPAGE_GFN_SHIFT(iterator->level));
-		return;
+
+		if (iterator->rmap->val)
+			return;
 	}
 
 	if (++iterator->level > iterator->end_level) {

base-commit: c9b8fecddb5bb4b67e351bbaeaa648a6f7456912
-- 
2.35.1.1021.g381101b075-goog

