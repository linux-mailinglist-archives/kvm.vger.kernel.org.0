Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4878B570FB8
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 03:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbiGLB4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 21:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiGLB4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 21:56:04 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960503E76D
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 18:56:02 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id e11-20020a17090301cb00b0016c3375abd3so4534353plh.3
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 18:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=ma3DpxT2sSfQaG/pKE2g5PTIPwl/pfsjFTL3vS5murs=;
        b=On7miwrY6VdGIDqKE36X6x+jz52HllnRn9rQj6SX1n+WNkzzuKYy+qOs0H/U+LN6Fz
         +Zs/cafLSHaei+GfbZ8Cxxt9Iu68hUqmFsGMZIk+TEOjatOt2iOmNDEBlDsWchN+mbn+
         S5kV8k5sUjy3SBxEKDllQCtbRE8swmZYpe7gBTfad2INLdMoB9hPrV3dQT9pzC5qJZ87
         vULPBYLlxGdICqjza1frOOWt32cXu3QmtWUIPniBY8IS//KKATSq0yjA7S8g9v5A7bBA
         T+iL3NqK/Mz97oKibpuvmV5v9FUFywNMfyqknHl8+arL/RKjNhEV/0YyFXo0AbMjjjj8
         cO4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=ma3DpxT2sSfQaG/pKE2g5PTIPwl/pfsjFTL3vS5murs=;
        b=55BX82mAf9NH9GooAPR/VAyvFFLIPfqqlXD/1i3J+8jhptOM7XagyCI3MsgXh05wPP
         nH0JNS9FDM/JPsuvqcO4PVnaQXmug4PNuMTvAy7BS4G0kd2T6jluRNgC0Sw43/5F4UMz
         VFksJaftuOG1XvdVyZu/rilSWmgsfhkk7cP2S68HQCn8isB9UmlkFh031/RKw+E/4ZZg
         ls4iBP751JD8SBiQQyROA7YzW2P0gK7gCNxLS7IfGTQ1y3chDKqtTURTginQbB/hJ+Vr
         sbPxl5lm+9UxpVlbRjUZWk/ZTPmncMCC18tslaXOnjl8/cK6/5rKycrRYF7VU741Hnvb
         rXOg==
X-Gm-Message-State: AJIora9z+5hqbda50GKOxbgTcojuSgs199W4B22zgS5sMfDBT4+QHIIg
        0eFpsro3J6DMXHgD/WS1Y9VSEg10yUc=
X-Google-Smtp-Source: AGRyM1t3hIM3KmVgR6JcODO/Ssu/SbRljN0Di0K/aFUIbO9/qfzDoknyyJYz+NI02Spn+IZyaOmbZK4yKcU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2654:b0:16c:5120:f379 with SMTP id
 je20-20020a170903265400b0016c5120f379mr4917394plb.3.1657590962127; Mon, 11
 Jul 2022 18:56:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 12 Jul 2022 01:55:53 +0000
Message-Id: <20220712015558.1247978-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH 0/5]  KVM: x86: Clean up rmap zap helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clean up the rmap helpers (mostly renames) to yield a more coherent set of
APIs, and to purge the irritating and inconsistent "rmapp" (p is for pointer)
nomenclature.

Patch 1 is a tangentially related fix for a benign bug.

Sean Christopherson (5):
  KVM: x86/mmu: Return a u64 (the old SPTE) from
    mmu_spte_clear_track_bits()
  KVM: x86/mmu: Rename rmap zap helpers to better show relationships
  KVM: x86/mmu: Remove underscores from __pte_list_remove()
  KVM: x86/mmu: Use innermost rmap zap helper when recycling rmaps
  KVM: x86/mmu: Drop the "p is for pointer" from rmap helpers

 arch/x86/kvm/mmu/mmu.c | 73 +++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 37 deletions(-)


base-commit: b9b71f43683ae9d76b0989249607bbe8c9eb6c5c
-- 
2.37.0.144.g8ac04bfd2-goog

