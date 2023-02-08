Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1949368F8F4
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 21:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbjBHUmh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 15:42:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbjBHUmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 15:42:36 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8CD24CA9
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 12:42:34 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id m5-20020a17090a414500b00230c1a511a5so4668982pjg.0
        for <kvm@vger.kernel.org>; Wed, 08 Feb 2023 12:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bBzQfVaxxfY8R5UeaSbbJL6k9hqwUJfY978upbZU7uo=;
        b=nW6LNcYAxz01hf4BVJu43EjFEuWMnizvHRFQUgCvqb3ZZ52K6Gy2TgPtbSN96RxBr3
         5lDY6NohjO9Fd4AAYluhW+jYRXcyhz3YqswlPZdi48x8VF3DR8aP9UJIhXiAFU+DgXpR
         BXH26zaNeKTdx/UgqwLfpx/bQfmPSTgooiLOVaFrxXK7pQbHvX0gU10PVWaym5aeMQfe
         j1bLHJ7AFbI7t51zryH/GmMvBTYjjDD9SkvZ9AxbOV1H1VhFQEOcm5bEyOt25salCkc/
         rbFYUrvbmzg+/EDG8Zy+VZmu409JyzCiSb4yqn6Xbut0N/5ui3H7/SsN2VLuHzChOa4b
         k8mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bBzQfVaxxfY8R5UeaSbbJL6k9hqwUJfY978upbZU7uo=;
        b=HY81r/51NWNzXP3b4KhEZ+ljsKPp81hSE/ttJ/TD5zUZ99pPiaGV9nI7PHTY2KN6Cx
         VRKsxEei16X2RCNTvGm8JHEL16ZAy7rkg6HLEmCAx8XqJrgIPGgjfwAiJmxySjiYUutw
         rMPIQDJ1XEHKSS1KkUfUgcxe82ZHR9DXxtjZ2hptMg40hJW5F1tbWwSYDbOxZYxX34rL
         A1Sd4Jn2xv44VwkD0/VxGWyM9RArulxVp8VVp2eJX35ga3HS+HeW3rw2SpL6q1fHu7p/
         1222Cs3nKjPNIIAd1T+oBzYNPYuIqokS7NlrR52f3sR9/pjGyglSdASrOLBdMfdTVCi0
         PgdA==
X-Gm-Message-State: AO0yUKWS29PIMK5XaHq0zMhrcentkLw3k9xa51ZUBNqqHjyWVrIsBTZ0
        oLYp83F2Tf59A6N5ImXfoRNF8feQMgo=
X-Google-Smtp-Source: AK7set9m9QMkZ+IQ/fM83QrFqR8Sh6x0KpmEoJ2SepRRpRNLA/Xa5mb14ohO9tbW5Qua/5MMElroKkenIhw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c202:b0:230:ee6f:28bc with SMTP id
 e2-20020a17090ac20200b00230ee6f28bcmr129308pjt.1.1675888954038; Wed, 08 Feb
 2023 12:42:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Feb 2023 20:42:28 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230208204230.1360502-1-seanjc@google.com>
Subject: [PATCH v2 0/2] perf/x86: KVM: Disable vPMU on hybrid CPUs
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jianfeng Gao <jianfeng.gao@intel.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>
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

Disable vPMU support in KVM when running on hybrid CPUs to avoid inducing
#GPs and other issues in guests.  This is intended to be a stopgap to
prevent unwitting KVM users from shooting themselves in the foot until KVM
KVM gets proper enabling for hybrid CPUs.

Effectively squash exporting PMU capabilities from perf until it too gets
proper enabling.

v2:
 - Disable vPMU on hybrid CPUs in KVM _and_ in perf. [Like]
 - Use X86_FEATURE_HYBRID_CPU instead of is_hybrid().
 - Tweak comments/changelogs to more clearly state that there are options
   beyond pinning vCPUs (though they still need KVM support). [Like]

v1: https://lore.kernel.org/all/20230120004051.2043777-1-seanjc@google.com

Sean Christopherson (2):
  KVM: x86/pmu: Disable vPMU support on hybrid CPUs (host PMUs)
  perf/x86: Refuse to export capabilities for hybrid PMUs

 arch/x86/events/core.c | 14 ++++++++------
 arch/x86/kvm/pmu.h     | 26 +++++++++++++++++++-------
 2 files changed, 27 insertions(+), 13 deletions(-)


base-commit: 7cb79f433e75b05d1635aefaa851cfcd1cb7dc4f
-- 
2.39.1.519.gcb327c4b5f-goog

