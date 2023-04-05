Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC75B6D8917
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 22:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbjDEUvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 16:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbjDEUvn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 16:51:43 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE77CD
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 13:51:41 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id u18-20020a170902e5d200b001a1d70ea3b6so21390897plf.6
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 13:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680727901;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jqB9tNXInQPUGocv6xxZotKbnEtT5xrZSCOQBZfdn6Y=;
        b=eiXsmlSkELaIyXX75kVjKNcfilJenW0GnBy4DP+2JHDmywCbQomyY9junLvOxLcH3R
         aZ1uL2B8R8r0leemBdpsXgqE1cT4OIH0NUY0M+SivVfHhP0IKbnmNp2a3TvTrmH6hb0R
         6Yk9h3ApaaAO9+T4aB5PhU+Ua1AUT4ECjKrXBTyNA1ZQ+4LtIgtKY+tqRZkTEW8Mjh+1
         vICFxzmz06NM5KW+bd6gLDFDPmc7t8cU31BUV14PmmwdNBckDJACPZ7uAEpDsJSEiQhl
         0AUFpelRbgNdNKdi28fKpWjciVaAkkqc4+2sPLp40yKYfuqYVPz6OFq0ve2PWuULMYOM
         PnyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680727901;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jqB9tNXInQPUGocv6xxZotKbnEtT5xrZSCOQBZfdn6Y=;
        b=uonKtLby3BCZIKG0kOnOSqW28in/9YRKyZby81oS3AHkPHrTZFfPVmpiiv5U4EcMuA
         CaNIT3JyJ4TzbAUrnB4KKb+G5A/JiCQvmeEIVnqkoDSs5BWR9YxhyuwmMWOI0TFqLtue
         CWujFRTAIn9pHPaKdRIoCp+ArTMZp6MtXCkq0iC03/Z4ewarT/APdEL7g1fBSFv1cwNg
         nu0sTper7I9jqPizJyszK/EgW20MOsZ4Nu1wsG4LgrWwQ4o3ZOnNVuKnogNVIPHzHlT+
         5GazLFZOyX3EJy+PAPQZ41aPw4uIkXzG0JkemJ5c5wOwXQi3cbEOTulx3kyntxNoEJ6B
         QWjw==
X-Gm-Message-State: AAQBX9d4RLzlYDn4DsVqu8xr1Em3WI/9qG8nkHpEnYcV3yJhO6V34xtM
        vJFAh2hZRH3AeVDCnxjtujscXrFWK3k=
X-Google-Smtp-Source: AKy350ZPZEGcSRDQAol0tVEC6WYWPA0hquvCEuDBTvjY/FkU++/MBz4+9MS00d/BOJpj3XzHZcxD0IF8+OY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:549:b0:237:3d0c:8d2e with SMTP id
 h9-20020a17090a054900b002373d0c8d2emr2660508pjf.2.1680727901192; Wed, 05 Apr
 2023 13:51:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Apr 2023 13:51:36 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405205138.525310-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 0/2] nSVM: vNMI testcase
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Santosh Shukla <santosh.shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Santosh's vNMI test, plus a prep patch to dedup a pile of copy+paste code
in the SVM test for handling fatal errors in the guest.

Santosh, can you check that I didn't break anything in the vNMI test?  I
don't have access to the necessary hardware.

Thanks!

Santosh Shukla (1):
  x86: nSVM: Add support for VNMI test

Sean Christopherson (1):
  nSVM: Add helper to report fatal errors in guest

 lib/x86/processor.h |   1 +
 x86/svm.c           |   5 ++
 x86/svm.h           |   8 ++
 x86/svm_tests.c     | 205 ++++++++++++++++++++++++++------------------
 4 files changed, 134 insertions(+), 85 deletions(-)


base-commit: 723a5703848d91f7aea8bc01d12fe8b1a6fc2391
-- 
2.40.0.348.gf938b09366-goog

