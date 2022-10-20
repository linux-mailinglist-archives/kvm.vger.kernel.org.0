Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5460B6056E2
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 07:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiJTFmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 01:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJTFmO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 01:42:14 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8E1FAE6F
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 22:42:13 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id g15-20020a25af8f000000b006bcad4bf46aso18325669ybh.19
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 22:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=F1xEy2N0X8jXyctTALyEQ2NLmUaEeJbt2DbPDEOdM5U=;
        b=qtupEmU2u9RZ171OaNaBBrtCDFPwuHznyd/3vhQPoSFoPHGUbjnNyra7t2LPVYTZUU
         V4GCVvcoV1wvGWYVoohLHP+XiSJnLrNgy/Rzq0n0QLYOnAmESpGTKLnoVAMAJdHuaiID
         gvJuGJKt2/Taj6K3D62Ki5E+CaSOLLcx9KSwmUJ3TtEPuYinkpl1Frj62adRZUgO41BN
         wqE+Ox4SnxtN0qzVPM+ZkU8xrfqWxaPT3jC4KOIczdSpdX2MfYt6Ozz6+X27LykpWWBp
         CW/JOwdvtJANIJYWaljsOW9uZ/pbeE4eDZOyP9QDliMjnNFOfyYpqy6FTsrx6tQooBJu
         LOmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F1xEy2N0X8jXyctTALyEQ2NLmUaEeJbt2DbPDEOdM5U=;
        b=ZWH1aB3iu/Ndvvr4wivzIQrm1DM2+gzYBaSA7hfvITJnbTNjjcMksDtECEYowqKykb
         Wjem3u+vGCZ4N2XxoI/219isULPujxfN2TuOncTYdgGZVdEIsJAY5MQhS8T53QrzEOCA
         aycfYMp2nHV8o9YgzW2q4IF0ZgofXi9RAn9io6skdn0WccxxO+fApHQPRsOJWIPopTZR
         39IUHfWJ07RzrZicQbg/UmQCnAh1/2PguNiMSrp55yxtLFjVEUlsCpWEz/eXMO8TdJu/
         LSh2FQCVlz/yjnOO8EsZ65chybTTsXxmSNWZQzMNqfpzqdyVYw0e8Xok86e5/pYZoHO7
         LC2g==
X-Gm-Message-State: ACrzQf0fS8iOHN4AH0kaYwcXfclJO6tSNQLnndMPbV89YrNzzM71lQA0
        E4p5wFHLhaEggmk9ljjjkX9koyNoRbs=
X-Google-Smtp-Source: AMsMyM7ssFcQRUTNFhxmazkE2SsVdFrFjqptAicWealf1kK7A/U7g3JYAWktNfywh02ITvG0hf7hTwi930A=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:1c53:0:b0:354:ce32:2d82 with SMTP id
 c80-20020a811c53000000b00354ce322d82mr9755582ywc.249.1666244532954; Wed, 19
 Oct 2022 22:42:12 -0700 (PDT)
Date:   Wed, 19 Oct 2022 22:41:53 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221020054202.2119018-1-reijiw@google.com>
Subject: [PATCH v2 0/9] KVM: arm64: selftests: Test linked {break,watch}points
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
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

This series adds test cases for linked {break,watch}points to the
debug-exceptions test, and expands {break,watch}point tests to
use non-zero {break,watch}points (the current test always uses
{break,watch}point#0).

Patches 1-6 add some helpers or do minor refactoring for
preparation of adding test cases in subsequent patches.
Patches 7-8 add test cases for a linked {break,watch}point.
Patch 9 expands {break,watch}point test cases to use non-zero
{break,watch}points.

The series is based on v6.1-rc1 with the patch [1] applied.

v2:
 - Use FIELD_GET() to extract ID register fields (Oliver, Ricardo)
 - Try to make function/variable names more clear (Oliver, Ricardo)
 - Make the context number more unlikely to happen by mistake (Ricardo)
 - Remove unnecessary GUEST_SYNC for test stage tracking
 - Collect Reviewed-bys from Oliver and Ricardo (thanks!)

v1: https://lore.kernel.org/all/20220825050846.3418868-1-reijiw@google.com/

[1] https://lore.kernel.org/all/20221017195834.2295901-6-ricarkol@google.com/

Reiji Watanabe (9):
  KVM: arm64: selftests: Use FIELD_GET() to extract ID register fields
  KVM: arm64: selftests: Add write_dbg{b,w}{c,v}r helpers in
    debug-exceptions
  KVM: arm64: selftests: Remove the hard-coded {b,w}pn#0 from
    debug-exceptions
  KVM: arm64: selftests: Add helpers to enable debug exceptions
  KVM: arm64: selftests: Stop unnecessary test stage tracking of
    debug-exceptions
  KVM: arm64: selftests: Change debug_version() to take ID_AA64DFR0_EL1
  KVM: arm64: selftests: Add a test case for a linked breakpoint
  KVM: arm64: selftests: Add a test case for a linked watchpoint
  KVM: arm64: selftests: Test with every breakpoint/watchpoint

 .../selftests/kvm/aarch64/aarch32_id_regs.c   |   3 +-
 .../selftests/kvm/aarch64/debug-exceptions.c  | 311 ++++++++++++++----
 .../selftests/kvm/lib/aarch64/processor.c     |   7 +-
 3 files changed, 245 insertions(+), 76 deletions(-)


base-commit: 0ecb0791b2af9bde4389d5ee9ee2a64ddf55ea85
-- 
2.38.0.413.g74048e4d9e-goog

