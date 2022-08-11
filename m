Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89AC95906B0
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 21:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235525AbiHKSwR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 14:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235963AbiHKSwQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 14:52:16 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BC59DFB8
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 11:52:14 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id c20-20020a6566d4000000b0041c325bd8ffso6802299pgw.4
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 11:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=PSMiDApMm9EJDwLSG0ujDeBYqk+k1GboNMnR6a9XYaU=;
        b=Z5yseo85kwVp4yp2VAQbZNNu4ewswLmT49gXoWDeE7tse+gvglBEe2hRUVE8dlS5y3
         pLkwV4JUOMAcQuTQcR2inLc0Mm+a1kYV70zLXAwALtOLUz/rvKaZahDeQqnQaZN5FvNw
         +4cJVa/HE/M7doCUx+zzhkI5iAITROzd0uZcmO6Ila4Hcu8FbNHxYf3+xbXP+e2G97Kf
         HxR68s4RykHvUoNs/0ItUusfi1rsyy4IsZdS1usEFLc5v18Etmp8gQYX7EIGpEoUOTOo
         aIHfFo24VTCKv/lI1dpeC0lxCz64fhC+RmYYg1++iG80Qg010bCevdaCF0cIm5CdMYDS
         FXsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=PSMiDApMm9EJDwLSG0ujDeBYqk+k1GboNMnR6a9XYaU=;
        b=Mi09pIW69R2tj2ggg37NzBAKp58Q3T4U1ec7v0VhMNXFOl30mYqju1e6jy1DFtNxXT
         NWwQeckWFG1/u1EakJEuWBa2MBX7YGG8neaftwbkg/RX03uo28JlypDFHhhy/1BtKLhM
         fbbrDluzt0xlOA2NuhPLU54Mqtlx0Gfu7RMpvytNmd0Dag2jPgEjaJR0feM5/MOeO7fO
         DwuD5xO39ceQAkCxPxO4ci2pqbOVp9+P9KGytvr5jVJwB7uJx6qo4bm1IseyYAC/oMjP
         YcL1oFPQCRuB1Q2ZIstR6PeBFimXRb+6VwRL5Bc7iVdNC8EzBYjJygqMzM8/+lcF4f47
         jSJA==
X-Gm-Message-State: ACgBeo0qqLZqfckG2XaB5pEPzdBdlvUnosGfP0g9hFmcJpHQ0xN3I4C9
        1Bwz8irHOswC2a5sPJtR8dXexZH2CC6Kcehu82Orhf5iCEF2P8Qit5+79Etxzl4HDJgGWf7OhJG
        BUqvAj13qcLJxnLZhMEg/qG2LD+6q380psSVfoI4jWQ3+Y3Hh3CKGZlurR2hvNqw=
X-Google-Smtp-Source: AA6agR7cZjXJZ8N3M8FiN5R564eJNdzhrfbZUp0GkJIZHcrS3I5L++nZc/8L5kAWnrziyVDaGhY/dMnv3r2PJg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:f7c6:b0:16d:c795:d43e with SMTP
 id h6-20020a170902f7c600b0016dc795d43emr481372plw.162.1660243934081; Thu, 11
 Aug 2022 11:52:14 -0700 (PDT)
Date:   Thu, 11 Aug 2022 11:52:06 -0700
Message-Id: <20220811185210.234711-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [kvm-unit-tests PATCH v4 0/4] arm: pmu: Fixes for bare metal
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     maz@kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com,
        Ricardo Koller <ricarkol@google.com>
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

There are some tests that fail when running on bare metal (including a
passthrough prototype).  There are three issues with the tests.  The
first one is that there are some missing isb()'s between enabling event
counting and the actual counting. This wasn't an issue on KVM as
trapping on registers served as context synchronization events. The
second issue is that some tests assume that registers reset to 0.  And
finally, the third issue is that overflowing the low counter of a
chained event sets the overflow flag in PMVOS and some tests fail by
checking for it not being set.

Addressed all comments from the previous version:
https://lore.kernel.org/kvmarm/YvPsBKGbHHQP+0oS@google.com/T/#mb077998e2eb9fb3e15930b3412fd7ba2fb4103ca
- add pmu_reset() for 32-bit arm [Andrew]
- collect r-b from Alexandru

Thanks!
Ricardo

Ricardo Koller (4):
  arm: pmu: Add missing isb()'s after sys register writing
  arm: pmu: Add reset_pmu() for 32-bit arm
  arm: pmu: Reset the pmu registers before starting some tests
  arm: pmu: Check for overflow in the low counter in chained counters
    tests

 arm/pmu.c | 72 ++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 55 insertions(+), 17 deletions(-)

-- 
2.37.1.559.g78731f0fdb-goog

