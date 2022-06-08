Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6367544020
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 01:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235081AbiFHXux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 19:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235046AbiFHXuw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 19:50:52 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F9A6462
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 16:52:42 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2f7dbceab08so187224617b3.10
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 16:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=oeQFqldPf0y0tMg0w28ZEd6MHTObpuk5IkbQ3sQWiYI=;
        b=PFAMFxuAc8SRmd647LF6GBwqu9/jCzphs2QpMDxsR+hsUoXP5GjBHQZ6VKVECzVIwy
         FMpPUGnIZ3C0GAjyC0VHO5t7EXyoScWAgdQjskqpSPRYGCYVeylDcg5y0hQxKKngGNnx
         pTDpSrYgPD50lToZY6bWtd4pAFuMr8n/IfgHpLwBNOjFI1/If0NlPXhcJNkAQd7LXjMm
         gicm2TmnoVM8bR3H62EqJ2zrlI3v9+Pe1iWhjHTOeFapfPU6IfiiPGFHsymD4q8Y0Wkm
         xGPMgX9kPWG7p4DJMCtQXOJ+mQ4Wxdh1nxYzIsvQdchf93g8ZMnySW9Wyz6bTt3lOMRj
         zVBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=oeQFqldPf0y0tMg0w28ZEd6MHTObpuk5IkbQ3sQWiYI=;
        b=dgfZZWBog7FuiRX/PRpr3DzepnUep//9kHJLMI5iu52Eu0zEXKl9l4mMHLnPV418lN
         0OLrKaRofDmZcWlzoIEU54HrQiBt7JxyzhgMVrA7E+OEV9yADxtbSeZ7p7MLQQ1rs+Zx
         HiO9+hGhexIMSL0PAP8doTo4iN2oJCEZiGqO/ohsyIlTERLJxdt6VU4bPNBGVJ+WpLC4
         +bnT/84TSsMJAALHm0LmhyQIiQ0Cay3+h1aoxTumrvoRYbCXOefe7qxm8CnB7CWbkaiL
         v0SWLvtL1YVX9W4N63PRfXpKZD7rW1crzAgffi1V8U4ZOLmqgMUdQO3YovhR661ttgrz
         yEHw==
X-Gm-Message-State: AOAM532GbtgFV/cCNepGalaUCcXNS4kI1JSdCbE+TMS5NvroZ771KVxP
        uJDYOOllPx72ICJhh5NOESb2G99rJtc=
X-Google-Smtp-Source: ABdhPJxtNYJ3X+ArqqDuI6Bv2ei92rTb/Vfd95m/zmlBL05Y5gsxgmcC2emvz9NxtcClGSa4SwuT1zRqC1M=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:b94:0:b0:663:e6e7:c5 with SMTP id
 142-20020a250b94000000b00663e6e700c5mr9373524ybl.85.1654732361353; Wed, 08
 Jun 2022 16:52:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Jun 2022 23:52:28 +0000
Message-Id: <20220608235238.3881916-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [kvm-unit-tests PATCH 00/10] x86: nVMX: Add VMXON #UD test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
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

Add a testcase to verify VMXON #UDs when attempted with an incompatible
CR0 or CR4.

Patches 1-10 are cleanups to make implementing that relatively simple test
less painful.

Sean Christopherson (10):
  x86: Use BIT() to define architectural bits
  x86: Replace spaces with tables in processor.h
  x86: Use "safe" terminology instead of "checking"
  x86: Use "safe" helpers to implement unsafe CRs accessors
  x86: Provide result of RDMSR from "safe" variant
  nVMX: Check the results of VMXON/VMXOFF in feature control test
  nVMX: Check result of VMXON in INIT/SIPI tests
  nVMX: Wrap VMXON in ASM_TRY(), a.k.a. in exception fixup
  nVMX: Simplify test_vmxon() by returning directly on failure
  nVMX: Add subtest to verify VMXON succeeds/#UDs on good/bad CR0/CR4

 lib/x86/desc.c      |   8 -
 lib/x86/desc.h      |   1 -
 lib/x86/processor.h | 403 +++++++++++++++++++++++++-------------------
 x86/access.c        |   8 +-
 x86/la57.c          |   2 +-
 x86/msr.c           |   5 +-
 x86/pcid.c          |  28 ++-
 x86/rdpru.c         |   4 +-
 x86/vmx.c           | 141 +++++++++++++---
 x86/vmx.h           |  31 +++-
 x86/vmx_tests.c     |  12 +-
 x86/xsave.c         |  31 ++--
 12 files changed, 411 insertions(+), 263 deletions(-)


base-commit: 2eed0bf1096077144cc3a0dd9974689487f9511a
-- 
2.36.1.255.ge46751e96f-goog

