Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCE765621E
	for <lists+kvm@lfdr.de>; Mon, 26 Dec 2022 12:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbiLZLRd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Dec 2022 06:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiLZLRb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Dec 2022 06:17:31 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3EA2ADB;
        Mon, 26 Dec 2022 03:17:30 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id n4so10518727plp.1;
        Mon, 26 Dec 2022 03:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X8HUhBiPyI/T4QDHUA3S/DD5nIRw4PTVL2CRzEEcPK0=;
        b=A8iOsYiaE9agu5DVQh3YlcPYMgvRWmudS/4VFCGl92AFaI63W0pEy2TjnpMHW2qn1q
         QogZKsi+GmkObwA+wvq8jE1f+SGkzJ4C1Y2ohr0dBlY+pGlTtKz0hFGWpGul+J2xEQZe
         2wATDP9459SpZPJ0cq4D2vNotBnwWNFsdHcMkw1kY+o4QSwee72cjnvCSen7csPlwDsg
         rAv+gSZoVM7ZsQo0eskqVtjA6pCiJIf0lgwFbyyQg+3BAp4UqeL0602zAh0oXyxQ0R6M
         GuRAhpu8o0reVUTyBb9+3P2v2dryK2hdH8tJ5fOfEoDCDBHuEL9ipkrWCRU4pfu6/X5C
         V57Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X8HUhBiPyI/T4QDHUA3S/DD5nIRw4PTVL2CRzEEcPK0=;
        b=1CAr0GEB54Ty52tKKFRddrqRlXxkbcloK0mcLV1aCMwblnhNdYcjttGbcKFz5GqAQ+
         DyS1KSwSBnV2/XcWL1zExzCRgTcgqS8bLneLkcPMLgiYmKl6qpQ74HkE34b1wxXr4qeF
         fkKhZz40dmUsUlbOolGrdxQ1QWW//3JLNzi0ZyLev3SLsPtMIbFTjpUqML1L+DzL1Iaj
         A7QWzY+Yp4RfEwMkh1uRNhSZFOUmoWhJQegLayS8N3YALd0wjgxjMqNsbrekKiRwxuSj
         w50fHDopvmplDiLYK7AqIJOYQHbkHawzLPlBYhKNieLCCr8pr0qkwQSFhYGvzD4IKDDP
         sZfQ==
X-Gm-Message-State: AFqh2krq97/48AZ21sr0dNMk/1TL+vC8qCtu1mljG9CgR2dhkv9HW31t
        Czcn7Yl5Ps853HOAU0HU1Is=
X-Google-Smtp-Source: AMrXdXuKOG+m8eHmaHRd0Ov5w/fxZ0N9m2n/m6pkHZeQHuRJ1Ym8uC02NZHodMeQLH6dvvXLju+StA==
X-Received: by 2002:a17:90a:4a84:b0:212:f14b:9c3f with SMTP id f4-20020a17090a4a8400b00212f14b9c3fmr35536035pjh.25.1672053449831;
        Mon, 26 Dec 2022 03:17:29 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id dw6-20020a17090b094600b00223f495dc28sm6281490pjb.14.2022.12.26.03.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 03:17:29 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM: x86/pmu: Fix accesses to PMU MSRs in two corner cases 
Date:   Mon, 26 Dec 2022 19:17:07 +0800
Message-Id: <20221226111710.51831-1-likexu@tencent.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When PMU is disabled globally, the msr_list reported by KVM will still
expose a not minor number of PMU msrs, patch 1 is a quick fix and
stable trees will be much needed. Note, a more maintenance-friendly
approach [1] suggested by Sean is certainly in the works, but users are
now in desperate need of a pill.

The second case is where the host user space of a low version PMU can
still see the higher version PMU features from the msr_list exposed by KVM,
and subsequent read and write access failures also causes KVM regression.
Note, a more thorough clean-up move is also in the development pipeline.

Please consider adding cc: stable to the first two patches so that further
refactoring of the same issues can be focused on upstream maintenance.

[1] https://lore.kernel.org/all/20220805172945.35412-4-seanjc@google.com/

Off-topic, two more independent KVM fixes also need to be reviewed:
- https://lore.kernel.org/kvm/20221109115952.92816-1-likexu@tencent.com/
- https://lore.kernel.org/kvm/20221205122048.16023-1-likexu@tencent.com/

Like Xu (3):
  KVM: x86: Omit PMU MSRs from KVM_GET_MSR_INDEX_LIST if !enable_pmu
  KVM: x86: Ignore host accesses to higher version PMU features MSRs
  KVM: x86: Fix a typo about msrs_to_save_all[] in kvm_init_msr_list()

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 34 ++++++++++++++++++++++++++++++---
 2 files changed, 32 insertions(+), 3 deletions(-)

-- 
2.39.0

