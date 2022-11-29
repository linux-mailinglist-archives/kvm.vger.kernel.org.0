Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D893B63C6C9
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 18:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235940AbiK2RxJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 12:53:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234427AbiK2RxG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 12:53:06 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACEF20F73
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 09:53:05 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3c9960ad866so54301727b3.4
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 09:53:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KjsC3AuBp17FPwHJyWZC4pwjcMr3p1iEYQDmFhx4K0Y=;
        b=MB5piJwMiEZ+sPgjxcNWgiGWve4k+XFgzKh4BZenqNyjAnQYDdWhZnVWz0qdsHimku
         hqsmfhnqNOIOOgQoFn7BzZnoVfYEQzZ2x1Z1VJGjZlOUyhubB5Kp9fMDjTqapTBcNDsA
         5vKlRif4Lf66Woy7jo8BIBupYqD5FGm0TlxOQZdMFu9LAm8W3uCCB1RgyAdMD52O8Bwo
         Wl+BE+uyBLKUl/KsH7HjSL56pFFwnDtO2vBa5T46c0x99GHl3bU5mCEFwjzHGhkV9tuW
         qnUfixmcY19G9OGPTMbJ0iBKniXV2yxHbJaAQaeKD178rXgWOZyMeCLSrPyrmSMB2zBC
         pTYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KjsC3AuBp17FPwHJyWZC4pwjcMr3p1iEYQDmFhx4K0Y=;
        b=a/wVYRyvz1tuUDp+n2XE0uf6zCUnMOnzLBGlCa8QbokOUSyb5KqsrwCa2oO6/3lO0B
         AdQyvVS42lPHyPqJaxGgks1yDUAoEcakkRFjz/dSQckJoZ4kulxsosfYFz1ohQujEJT/
         RKTLN30/zHq2AxMYhiJi30gsnKLKufOKRUOiPB54Bbrcdt0xfEaIakWj6F0aE/6NAFo1
         rLuJSdIeCf1hSzfHPmHfWveEcVl/XGVM5aRMo8JTtP5c2PRUGPgD0cn6IWIrZfSqt/L1
         QOeGXSiOfzRoUMXtb0j9zLiR+rWojFCRNifNGjpNMqG/6k7Mme0tjNVUGzwuaozlcEPU
         1cug==
X-Gm-Message-State: ANoB5pkKGTmIiHwJMfYe/vP4kFWfKX26GqIfTM7fAfxIxK4IiIJQ8Oir
        78flce6NMRRkqJPzRsbUYiSlQsE6sYI=
X-Google-Smtp-Source: AA0mqf6Yp/ZGoszowG7od85IiWdfy7zque1JZgo9PZxJOxlJ5P0FB8JI0wbRDqWfDettceO2dOylKKnBfpc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:600a:0:b0:3c3:b45e:6ec2 with SMTP id
 u10-20020a81600a000000b003c3b45e6ec2mr2ywb.338.1669744384141; Tue, 29 Nov
 2022 09:53:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 29 Nov 2022 17:52:58 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221129175300.4052283-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: selftests: Fixes for access tracking perf test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix an inverted check in the access tracking perf test, and restore the
assert that there aren't too many dangling idle pages when running the
test on x86-64 bare metal.

Sean Christopherson (2):
  KVM: selftests: Fix inverted "warning" in access tracking perf test
  KVM: selftests: Restore assert for non-nested VMs in access tracking
    test

 .../selftests/kvm/access_tracking_perf_test.c | 22 ++++++++++++-------
 .../selftests/kvm/include/x86_64/processor.h  |  1 +
 2 files changed, 15 insertions(+), 8 deletions(-)


base-commit: 3e04435fe60590a1c79ec94d60e9897c3ff7d73b
-- 
2.38.1.584.g0f3c55d4c2-goog

