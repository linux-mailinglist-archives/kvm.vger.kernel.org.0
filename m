Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0A2659A7C
	for <lists+kvm@lfdr.de>; Fri, 30 Dec 2022 17:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbiL3QZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Dec 2022 11:25:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiL3QY7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Dec 2022 11:24:59 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB7B63FC
        for <kvm@vger.kernel.org>; Fri, 30 Dec 2022 08:24:58 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id b13-20020a056a000a8d00b0057348c50123so10800205pfl.18
        for <kvm@vger.kernel.org>; Fri, 30 Dec 2022 08:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yGl00PQDzQ4sUWDu+Sl7/fyGSCtmdRMefDPlVjy7OPQ=;
        b=MuqXQ6YpXr3tlEs8GAExmQ8V/X+lR0PX67qDg/xrxqnQQvFjSsotze09lQm9PaqEg6
         jPGqqB36av6nwhAI6Ganj9aziXSJg2GLS5Z73fTT7EwTXhJMNLmFyTu15xFayVqkKZxl
         D0MrKov00nw/kIbiEWw8p8/c83jvkvVULpxswMVPML9Rj59Chdo8M75xnfzsS2wZooCz
         iDnCTwliWrQSfPnc80Yaiy5QUTpHNis6x7I2SMzt89D6Ue6y+0r59Hg6Su5zTXh1MblN
         YPQB98HwGJATTdAbsxNZocu9z5A017HwDxzanmSy6jtIwBALlOPIuWXMhuVBGYHAM89N
         GgAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yGl00PQDzQ4sUWDu+Sl7/fyGSCtmdRMefDPlVjy7OPQ=;
        b=hRMVbp9SuaV9Vz5RBZsxvDemZtVI4Z71W1WZW+wkhsSBBMgv4hhFnhTmfDTFBfB90N
         8/hCGSL1MVI9Fn3eYB0+qcZu3IvtJ7hcNXY76LY5joiERE5gZVNQoBCJELSEUv9HLodk
         fXi7uxH6RxAwkRisuhqABCN5nndiRw5mwzfLy4yI4UxXdsshqToM6x2Twr18XsrFI57Y
         i/5bjYolt7TK7GLNgHsUAOrg5CFq3Qk2fQJ2QvKBXnaLWOCucwt60tDeK5X6cX6eNBy/
         e7h4UpddOQhDOB9zeEivOEnK8zUuMObZOCQdtgW0ejEXdW/sdyRRCwjke/cZUTcLsUvt
         ruFw==
X-Gm-Message-State: AFqh2krcHmOmNQJwGveA9TR7Ro5y6ftqaQAp70yxYWxfTYu7P/pWb9d4
        j0WW3+JTNEfUD7NYe3pJnR+PNMzV5kAUpz4yQojkSX5PlUh2UOxJWzwoierQIQTju8x+TOzBEvw
        t644msl+ueTF3cuiAEQqFPX/nurcvqgDyhCp5T4niFQZHBuNTkC1mDPQHLThvx7ARB5Fi
X-Google-Smtp-Source: AMrXdXtQY7zu2kISpW/5UEACqHgOuRVTSllgez5hK3ivt353i/hTYwidz58ZMr7gjeQgiYMN4U16Tp4A0OYW+fUn
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:b7c1:b0:192:5838:afb3 with SMTP
 id v1-20020a170902b7c100b001925838afb3mr1435452plz.13.1672417498345; Fri, 30
 Dec 2022 08:24:58 -0800 (PST)
Date:   Fri, 30 Dec 2022 16:24:36 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221230162442.3781098-1-aaronlewis@google.com>
Subject: [PATCH v2 0/6] Clean up the supported xfeatures
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

Make sure the supported xfeatures, i.e. EDX:EAX of CPUID.(EAX=0DH,ECX=0),
for MPX, AVX-512, and AMX are in a valid state and follow the rules
outlined in the SDM vol 1, section 13.3 ENABLING THE XSAVE FEATURE SET
AND XSAVE-ENABLED FEATURES.  While those rules apply to the enabled
xfeatures, i.e. XCR0, use them to set the supported xfeatures.  That way
if they are used by userspace or a guest to set the enabled xfeatures,
they won't cause a #GP.  

A test is then added to verify the supported xfeatures are in this
sanitied state.

Aaron Lewis (6):
  KVM: x86: Clear all MPX xfeatures if they are not all set
  KVM: x86: Clear all AVX-512 xfeatures if they are not all set
  KVM: x86: Clear all AMX xfeatures if they are not all set
  KVM: selftests: Hoist XGETBV and XSETBV to make them more accessible
  KVM: selftests: Add XFEATURE flags to common code
  KVM: selftests: Add XCR0 Test

 arch/x86/kvm/cpuid.c                          |  19 +++
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |  35 +++++
 tools/testing/selftests/kvm/x86_64/amx_test.c |  46 ++-----
 .../selftests/kvm/x86_64/xcr0_cpuid_test.c    | 121 ++++++++++++++++++
 5 files changed, 187 insertions(+), 35 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c

-- 
2.39.0.314.g84b9a713c41-goog

