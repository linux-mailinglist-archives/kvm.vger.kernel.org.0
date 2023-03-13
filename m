Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFA6E6B71C5
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 09:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjCMI50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 04:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjCMI4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 04:56:49 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E197523642;
        Mon, 13 Mar 2023 01:53:36 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id v21so1992778ple.9;
        Mon, 13 Mar 2023 01:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678697615;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=D10KgoRJeWJa43EfRHUMcmADuIBznC9qbEV3kZk/zDk=;
        b=k+8ezgPiCd2gjMbHMWF9jFHSpKTPG3DkkcPHWt1ZYysMo7Ue1sFHMADALvMpbDZ+IX
         9pIqnTnFneAohs2S33kYWI2mzzluxHAdcXTdEaw/xyG8v3fpUE1L7bfAZgu1oq8kJqVK
         y2+yYy7gsBn1GYfpM5RvSqAXcQC/ML5l9tTqVsa5wPC3vd24HljOarIJoyFSUUN277/w
         9co2aentBstey8ImxfoiM84vvyBF05xBHsmmnO4zAUJkfo3H+lZOMDucmeWw/Zqrv1VQ
         3dlK0zz0zr/wsDiksAy9tjkNMHKDFSrPgzM4pOZpjTUXvW2gMtOa8hahH7sVfENSvYxz
         6l/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678697615;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D10KgoRJeWJa43EfRHUMcmADuIBznC9qbEV3kZk/zDk=;
        b=hLHeIDqb/AMwWXGV392elmOS9qjKQIORIrCsVw6mlljfC5ee6TMtK61DZoU0PFWq/1
         xYUQwsmXatA2eyBROXsomrUFE6CE1BuGHIsbuWpKXoMFTl0VdU8Td7SI51uRNnG06KC/
         xZNYAkz+qPFsAWzYAH8GXwAZKMp6ovcoyQTV2fMM95tXPZOCuwG53PCxrTJi1eSrfG8J
         QzwRmmJatbJs5Wznmzm5C7c0hG8jQ9ZxQ8Ud7LtdO1oHRioEpgwg/ztyrEQGUnPz9Ogf
         CeaCvbTofVF8sn0nQGJpZezuQ7f91DJnS1vH/eQS1JZjCAyH5q4e5aTFDvgChZgxuINb
         oscg==
X-Gm-Message-State: AO0yUKWRxqVSwyJw+wFS67IAuxRwgIpl7g3tHn9WJ3AutygBzoTnDHSd
        kjx9HnKDRYBD++XpYKlgOgI=
X-Google-Smtp-Source: AK7set8sZpKdZFScN7cVDMEIN026xKH5/5i7wA/BA3S846W3WLiQa2NA9e1w7nHRtXBOBiIiHVUFtQ==
X-Received: by 2002:a17:902:7106:b0:19d:1c6e:d31f with SMTP id a6-20020a170902710600b0019d1c6ed31fmr28178918pll.29.1678697615327;
        Mon, 13 Mar 2023 01:53:35 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id c6-20020a170902d48600b0019ee045a2b3sm4155059plg.308.2023.03.13.01.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 01:53:31 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] KVM: selftests: Report enable_pmu module value when test is skipped
Date:   Mon, 13 Mar 2023 16:53:09 +0800
Message-Id: <20230313085311.25327-1-likexu@tencent.com>
X-Mailer: git-send-email 2.39.2
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

Adequate info can help developers quickly distinguish whether the cause
is a code flaw or a platform limitation when a test fails or is skipped,
and this minor patch-set is doing a little work in that direction.

Previous:
https://lore.kernel.org/kvm/20230214084920.59787-1-likexu@tencent.com/

V1 -> V2 Changelog:
- Apply TEST_REQUIRE() to x86_64/vmx_pmu_caps_test as well;
- Put TEST_REQUIRE() at the very top; (Sean)

Like Xu (2):
  KVM: selftests: Add a helper to read kvm boolean module parameters
  KVM: selftests: Report enable_pmu module value when test is skipped

 tools/testing/selftests/kvm/include/kvm_util_base.h        | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c                 | 5 +++++
 tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c | 1 +
 tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c     | 1 +
 4 files changed, 8 insertions(+)


base-commit: 13738a3647368f7f600b30d241779bcd2a3ebbfd
-- 
2.39.2

