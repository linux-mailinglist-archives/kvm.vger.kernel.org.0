Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C984E639E73
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 01:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiK1AUv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Nov 2022 19:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiK1AUt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Nov 2022 19:20:49 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA181054C
        for <kvm@vger.kernel.org>; Sun, 27 Nov 2022 16:20:48 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id x16-20020a63b210000000b0045f5c1e18d0so5325012pge.0
        for <kvm@vger.kernel.org>; Sun, 27 Nov 2022 16:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WvNYBelSnIf0VChXykzjQ8Z5WjHWX9zbrtehXal28fs=;
        b=hnJpx1oVZ0606Ea9/83PpQ/kO3jp3p+nRq9GYAAF7HJkRGu9q9LvZL6qj4aVl3EaK/
         lrg3zWVIh2VUr2GnmGXu0wjIHSBu5D8RmBxG8CQBdkDgIbdXmZIMeqhAzHYnxOko8qp4
         vbzH/PGWFvR9PXbXON65fWRqPzCW4Je72AByk+ZNfX5CKvC+O6wtKrURWRjXe79SowgZ
         Qv8k8cZUGxOomazfO5A9/yQT6CgB1l9Bb29NDx3OFUox00BwUmGdTTKTM43GPCNGQyGr
         KPsy0LAMK4YDsz5tlwHeD5mDwbyH5946iE9+xnDb9i2lgU4q0/kLH3WPWnk6oTPEpPLy
         q+AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WvNYBelSnIf0VChXykzjQ8Z5WjHWX9zbrtehXal28fs=;
        b=GNvlWTiBkGTiS/L0q9HpmVj1ji+X9g5Hl0EP1LewIxAiTGHp8sFfCUw98/9KNrqaBO
         lTM5KNR1HuLR+p1vKd5GpjQh1lsHRWBrPszUFb0MBtS58i6D9zJtuw884s8dkD0tRcFK
         n3Kb2/Gwt6HEZGq9uTOUuGqvIq0RV8vJ+p8aQ6hrIkRse1B3cbvUx6tX4FcE/UqCBkqk
         7e/ppPWtuE878JDrVni0UrJPCIZKEutJxcHkFcMLhyZix3/kEkPJZXM8OHdU4znxpt5H
         Hmtk4bUm0W6uwm7CqHDKJ2EE+4XUY3sj0w8XPs99D51FPHgiy0P3z0RVEIl1N6Dh3hQq
         UH5g==
X-Gm-Message-State: ANoB5plWEu6QR55L16PAkuDyBXBoaA145RQenSrzVCD/lDx+3XWFIVWs
        JNFCUnFeX4j8YNoWzKiFsNJM4cm3h7H4
X-Google-Smtp-Source: AA0mqf4SC9dhTYPD7Pd2N36q73+7qicKcuvfm2OEAyIsNTV0nBWL79K4b4zIK4RfDCqkSzNHJaeQlgGYf46V
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:90a:c298:b0:218:a32f:9612 with SMTP id
 f24-20020a17090ac29800b00218a32f9612mr39996138pjt.155.1669594847743; Sun, 27
 Nov 2022 16:20:47 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon, 28 Nov 2022 00:20:41 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221128002043.1555543-1-mizhang@google.com>
Subject: [RFC PATCH v3 0/2] Deprecate BUG() in pte_list_remove() in shadow mmu
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Nagareddy Reddy <nspreddy@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>
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

Deprecate BUG() in pte_list_remove() in shadow mmu to avoid crashing a
physical machine. There are several reasons and motivations to do so:

MMU bug is difficult to discover due to various racing conditions and
corner cases and thus it extremely hard to debug. The situation gets much
worse when it triggers the shutdown of a host. Host machine crash might
eliminates everything including the potential clues for debugging.

From cloud computing service perspective, BUG() or BUG_ON() is probably no
longer appropriate as the host reliability is top priority. Crashing the
physical machine is almost never a good option as it eliminates innocent
VMs and cause service outage in a larger scope. Even worse, if attacker can
reliably triggers this code by diverting the control flow or corrupting the
memory, then this becomes vm-of-death attack. This is a huge attack vector
to cloud providers, as the death of one single host machine is not the end
of the story. Without manual interferences, a failed cloud job may be
dispatched to other hosts and continue host crashes until all of them are
dead.

For the above reason, we propose the replacement of BUG() in
pte_list_remove() with KVM_BUG() to crash just the VM itself.


v2 -> v3:
 - plumb @kvm all the way to pte_list_remove() [seanjc, pbonzini]

v1 -> v2:
 - compile test the code.
 - fill KVM_BUG() with kvm_get_running_vcpu()->kvm
rfc v2:
 - https://lore.kernel.org/all/20221124003505.424617-1-mizhang@google.com/

rfc v1:
 - https://lore.kernel.org/all/20221123231206.274392-1-mizhang@google.com/


Mingwei Zhang (2):
  KVM: x86/mmu: plumb struct kvm all the way to pte_list_remove()
  KVM: x86/mmu: replace BUG() with KVM_BUG() in shadow mmu

 arch/x86/kvm/mmu/mmu.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

-- 
2.38.1.584.g0f3c55d4c2-goog

