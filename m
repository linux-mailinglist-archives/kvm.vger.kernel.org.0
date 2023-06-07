Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F88725151
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 03:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240392AbjFGBCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 21:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239885AbjFGBCK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 21:02:10 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F87124
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 18:02:09 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-258aad18260so68401a91.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 18:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686099729; x=1688691729;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MIT3ff/KRX9uYGBg0xAZEe1w0qcnxFqLspYh4nHLJtE=;
        b=5t8nBOdGj7l5n6Ly6kznD+x2R1G3ZUMw9J6OmtqcHV8YIb6fUMt6+Icsl4GPzP10N6
         GlwkEdJuCWORZop/+mmvD0SDMustOKgsvi2K3RUoaYlCMRgKuZNeJRNmndiyMcOq1Ogn
         wqVGW9n7fvdKv0tCTMb7Ac2heW5PXb6YrnHES3ChMzL1WPA/izL/ybSYPdHMfue7QR+C
         0DlUZpy+jrEoKOdM/23zntC4y4EA45wY5gVylZJAKT0qklyFHtiGh3AXSC3JbOMm4jhH
         Mfs/WtTEJj8io7i5r5lreR9jMNWgKMoqW/LM9XUYZwAGMsUoinc/yMqbUfFcEPxCmSK1
         H5kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686099729; x=1688691729;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MIT3ff/KRX9uYGBg0xAZEe1w0qcnxFqLspYh4nHLJtE=;
        b=H5hoOkbubmB27YsovJwNPoI/3B8hKuuIdM8k1j8w4B5ezRiskzlPjKcVJVkRBNITqp
         8Xyop5kyqTAmw8lFlq6NxbmNPE6M/Y6R7JSubtUQJABCPq0ElHWx36gpqhXFDEv4hkJ5
         GuQonzkoLyO8vH9k+hej/voMcXg+vZcgZp6o3m/SVvYoQr8Hxs/7A0b6wDtOQ8xyAeUK
         yDrAI+0jtmLlUu+zuf0MOBmfy7ur754n0hS08rING19HfNJcCH4HeWogoA1o7AV+ad0x
         K6czh89jovoOMNz5RhCwBiwAXqpIYUZTABo0ySQHYJjtY66hV8tBYR8cPll8viXpVGZG
         6zTQ==
X-Gm-Message-State: AC+VfDyrXAzLDRNCZhB8rVghBhcgOq7NOcZJIM1VLsvtbkTFc2vrSnB8
        D0SLY8a64s1zL/QxZiIe7JDem9TXOcQ=
X-Google-Smtp-Source: ACHHUZ4vcTop5qPJw/gOdcUR+2zqezwDhzCdEsDvsQmkgqL69MAIjoPt5M5KBjauPRGBToV8wNSPoj/iGBU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e2cb:b0:256:bc5e:7d76 with SMTP id
 fr11-20020a17090ae2cb00b00256bc5e7d76mr2994074pjb.3.1686099729200; Tue, 06
 Jun 2023 18:02:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Jun 2023 18:02:02 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230607010206.1425277-1-seanjc@google.com>
Subject: [PATCH 0/4] KVM: x86/pmu: Clean up arch/hw event handling
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Like Xu <like.xu.linux@gmail.com>
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

Clean up KVM's handling of arch/hw events, and the related fixed counter
usage.  KVM has far too many open coded magic numbers, and kludgy code
that stems from the magic numbers.

Sean Christopherson (4):
  KVM: x86/pmu: Use enums instead of hardcoded magic for arch event
    indices
  KVM: x86/pmu: Simplify intel_hw_event_available()
  KVM: x86/pmu: Require nr fixed_pmc_events to match nr max fixed
    counters
  KVM: x86/pmu: Move .hw_event_available() check out of PMC filter
    helper

 arch/x86/kvm/pmu.c           |  4 +-
 arch/x86/kvm/vmx/pmu_intel.c | 81 ++++++++++++++++++++++++------------
 2 files changed, 56 insertions(+), 29 deletions(-)


base-commit: 31b4fc3bc64aadd660c5bfa5178c86a7ba61e0f7
-- 
2.41.0.162.gfafddb0af9-goog

