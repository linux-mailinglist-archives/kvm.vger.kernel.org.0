Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F79372512F
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 02:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239992AbjFGAnS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 20:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239908AbjFGAnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 20:43:15 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB791732
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 17:43:14 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b03057588cso61848515ad.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 17:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686098594; x=1688690594;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bybaLCqc8JhYOjYuGlDyJbEWcYLH95lMWslyp/Hs2bM=;
        b=nJkBLmOj4a6aLchvs36B1oOkZHiCMfyj+WFJhicNmT3QUToiwNmFaZ4DdxDWqqjh//
         pk/OUQ0FsRd53spBKsNdM8daS7QoMHlbt1aCKFoniacZkrXxJtiVGaHI6084FpHd6Cd+
         //VLGDr3QQxwLShIfVhQo+NNLqeJYvRvhETap63v4CkUw/wa4WtNuv7tGEx7rJN3LhRh
         XdQKnGTNQSB/yrO1DA0hd7nurfw4PcnAGeWNQYC35KawB4gMRVnfnGVtcF6nHcB75DPA
         uHvmVHmK4MUpMYBjkLlPOcLKJnVOGc+9r8KGbtyfdi7NZs2FuEuj+x+FZ32MbB/gFT9J
         Rk7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686098594; x=1688690594;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bybaLCqc8JhYOjYuGlDyJbEWcYLH95lMWslyp/Hs2bM=;
        b=YPtJEjRRhe4i1zWclncgmL1kT/PFS068H6JX8yO71MTVPd3otsDq92bclDrvTpSy29
         pejB2sNjtml7eBADCEjTjxlq/kXpeEJHEkzphMEbMOneVvcJt9Bt8Q+E82uFkQ2qhhex
         HJrv/CxjqF5kt07YxiSMVsskhP2sl9Bu2a+e+stq9q4zHOQPIarAh1jIA4TSVq6pISeO
         XH0Kv2ubPHAdEu7Qtm317tjZZEG8j+fX9c2K8/Vgn+fbBo/hdxlimaUq+jtmUyTtXgtU
         CF4mL0hqxR52t0CHK6A+a/pjhtma1ceszyLT3qLhXdIPQl1cUmUFU+/1ctRTkXnrNjAO
         Nczg==
X-Gm-Message-State: AC+VfDyzzWvyxT5PJ4HunSJvzqTGuAHUlgsttl7UjmTkaE9D0SOvZ5kV
        +ylo29VVgqRTic45RjEbZceQcXlOhrU=
X-Google-Smtp-Source: ACHHUZ5icomASxlkXyL4d7DqqftAUkZdSrOTBL2+Wz+86UQDPbfBgZAGyQSkTxX3pMepA2PV/5UGH9LCVjI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:26d3:b0:1ae:7604:d65c with SMTP id
 jg19-20020a17090326d300b001ae7604d65cmr1130371plb.0.1686098593932; Tue, 06
 Jun 2023 17:43:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Jun 2023 17:43:08 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230607004311.1420507-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: x86: Snapshot host MSR_IA32_ARCH_CAPABILITIES
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chao Gao <chao.gao@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Snapshot the host's MSR_IA32_ARCH_CAPABILITIES to avoid repeated RDMSRs
at runtime, and cleanup the pseudo-cache vmx_fb_clear_ctrl_available.

Sean Christopherson (2):
  KVM: x86: Snapshot host's MSR_IA32_ARCH_CAPABILITIES
  KVM: VMX: Drop unnecessary vmx_fb_clear_ctrl_available "cache"

 arch/x86/kvm/vmx/vmx.c | 33 ++++++---------------------------
 arch/x86/kvm/x86.c     | 13 +++++++------
 arch/x86/kvm/x86.h     |  1 +
 3 files changed, 14 insertions(+), 33 deletions(-)


base-commit: 02f1b0b736606f9870595b3089d9c124f9da8be9
-- 
2.41.0.162.gfafddb0af9-goog

