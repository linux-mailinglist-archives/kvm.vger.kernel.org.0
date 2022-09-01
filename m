Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F975A9E06
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 19:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbiIARdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 13:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbiIARdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 13:33:02 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805C7844D3
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 10:33:01 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id m34-20020a634c62000000b0042aff6dff12so8848315pgl.14
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 10:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date;
        bh=f18Ajw2qRhO79QM4Tmsvh8gRLx7I7+YdwjvBD4a2uLE=;
        b=GZqCtMHSxtuPkgd8ls7MTpUSQYxgT0LLQKkXzaKB87J+QypiUJOGcR3ua1v0UMYRxC
         PXFec529cxMKmYlIuYqtS4cZ2sJQZe+CiHEX4GgOS9oI1l3kK95tTDzmfjo+7sDVcRMr
         /K9KXGgI9HsEv0bZ3ZKnLfub0doxC1R6dlUSmLEaGJmB4PLYKIn127Qy7pu5oCnnDeRj
         dbut+MBHMpSECo/JsBJ7bougGYCiGWhYtXL+DWmHe/ey/TsEgzHx2ZWeOZl3ysvhvq0Q
         THcwVUvfrHEd1NQQPs79WPoUbLFhZW/DGPj1Rqz0zUZ/FmDstRE+9hy3hHml0M10N9JJ
         YoLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date;
        bh=f18Ajw2qRhO79QM4Tmsvh8gRLx7I7+YdwjvBD4a2uLE=;
        b=mlCd8wobuK/zgMVmz8blNy79VB2EAJS8eqzpd7pnN9HOMHuWY+0J8yKI/qAxDWREZm
         0e/wgKg8g+8l1ts2cYeJEDhduFtLvC6X9zkZjXd2p7gvEJF6LdF+RmrnJFBvCugT8T4n
         UPblAOBjrTx4GjtmY0YV55LatkcyeiEE5iKBIUcx4kyUl9bj2qoScatvmfOM4pu8SeMH
         0iO3fi4sidIqd+R/nMCkmABOiMUGKlzYDlbGvjynkeUlhPDHi+kKxD7/oEdTlqvzkIqb
         PFIp7ntLtiCrnu/WG/JcRvHkSZtLNVJuYIUCBHteBOgXuLCsRxq7IGsWQ74bGaFiLdrm
         XBvw==
X-Gm-Message-State: ACgBeo1lmZwcbZLUMVQl6Fib1rHy9ofpd9izT3wPQaogyRrcqpPPAZdP
        ZM+02vUdof4mm9mND7LEN/PUFI+N06U=
X-Google-Smtp-Source: AA6agR5cCnUtvWVuCwmWcaYBNlIySJEyQxNE5lacLmrQFerhkSeIwMdaVmBEPoipok+cHJHaOIJKs9FEsss=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ecc6:b0:172:cc88:18df with SMTP id
 a6-20020a170902ecc600b00172cc8818dfmr32160925plh.167.1662053581009; Thu, 01
 Sep 2022 10:33:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Sep 2022 17:32:53 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220901173258.925729-1-seanjc@google.com>
Subject: [PATCH v4 0/5]  KVM: x86: Intel LBR related perf cleanups
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
        kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
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

Fix a bug where KVM incorrectly advertises PMU_CAP_LBR_FMT to userspace if
perf has disabled LBRs, e.g. because probing one or more LBR MSRs during
setup hit a #GP.

The non-KVM patches remove unnecessary stubs and unreachable error paths,
which allows for a cleaner fix for said bug (backporting is unlikely to be
necessary/requested).

v4
 - Make vmx_get_perf_capabilities() non-inline to avoid references to
   x86_perf_get_lbr() when CPU_SUP_INTEL=n. [kernel test robot]

v3:
 - https://lore.kernel.org/all/20220831000051.4015031-1-seanjc@google.com
 - Drop patches for bug #1 (already merged).
 - Drop misguided "clean up the capability check" patch. [Like]

v2:
 - https://lore.kernel.org/all/20220803192658.860033-1-seanjc@google.com
 - Add patches to fix bug #2. [Like]
 - Add a patch to clean up the capability check.
 - Tweak the changelog for the PMU refresh bug fix to call out that
   KVM should disallow changing feature MSRs after KVM_RUN. [Like]

v1: https://lore.kernel.org/all/20220727233424.2968356-1-seanjc@google.com

Sean Christopherson (5):
  perf/x86/core: Remove unnecessary stubs provided for KVM-only helpers
  perf/x86/core: Drop the unnecessary return value from
    x86_perf_get_lbr()
  KVM: VMX: Move vmx_get_perf_capabilities() definition to vmx.c
  KVM: VMX: Fold vmx_supported_debugctl() into vcpu_supported_debugctl()
  KVM: VMX: Advertise PMU LBRs if and only if perf supports LBRs

 arch/x86/events/intel/lbr.c       |  6 +---
 arch/x86/include/asm/perf_event.h | 55 ++++++++-----------------------
 arch/x86/kvm/vmx/capabilities.h   | 39 ++--------------------
 arch/x86/kvm/vmx/vmx.c            | 37 ++++++++++++++++++---
 4 files changed, 49 insertions(+), 88 deletions(-)


base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
-- 
2.37.2.789.g6183377224-goog

