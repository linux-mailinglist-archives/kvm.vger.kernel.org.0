Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C70A46D8B2F
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 01:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbjDEXqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 19:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233686AbjDEXqE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 19:46:04 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CC37685
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 16:45:59 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id c2-20020a170903234200b001a0aecba4e1so21867792plh.16
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 16:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680738359;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C3FiFSj2DW7QCcfEdHRl2FpbvkGFlMTLZXLRiPlpQOA=;
        b=kzWXb206+DPAGRlHNfajqdPAu56I4sQ/oSzZna3XW7CCIrbaRTz1FJ1k/xjq+NB5Bo
         399kCrZ2lNU26W3rApcqaM6JIjh8I4K47bNacsDM2bSQvC4SHSWlSRB88/PdnJfCF94p
         8blR3NdNXER1b/kBMmE0phFKwhFQDCSzQHoEP5o5Jz6xSxFvVuTMjq97m7b6GSnKhDw+
         LXOhZ3dj5ycdHzUcFFB6G6BPh0vuocE+1fxPtd3BmXi8GjGZDi4Jv3izx2paVkt5LHAa
         wbBMqakvOf4Ie1hb6cD0fTYIe4RevYB66RaIz3W//0RXGqm3PgjlcbE4qrYeNnCE5Q8B
         Yv7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680738359;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C3FiFSj2DW7QCcfEdHRl2FpbvkGFlMTLZXLRiPlpQOA=;
        b=8A/eb6yFksYvcCLM0IgVjCeChUWDp7omAInGFgzejj1z/I3f7/3b155TAHWuy3RvqA
         5WA1Mxf2416VzWDEsk5kOxaRSXDSxiLquko2uRdY8WHr7xqY8Dsqrd9ToQjD/axv3Wxp
         JQC/Xad/1Dt+FbevGvaPC1zBr1E3FiQJrevyE/5BjUUEiWh+KDhfEf4WE4SlcFauDxBb
         CDXt3509kH3mzQWryQeRdGxljRLmIXKs86zmTcciiIfcE1pPKZiq4421srNpFfdHL6if
         kUupe47m+TQWl4jfsY+zr8/5pvIPzuoth9SYgURVMzV1FZSPJA5MeJ7+goXhRPumnOcu
         MPbQ==
X-Gm-Message-State: AAQBX9d5cQBCEX6snHBeuG0SiKF+EEtwHTLBfy9N2f3ewU5VBX2Jru53
        YnNbkvBdVwktzW1dgmyTe+q2c7MZQhc=
X-Google-Smtp-Source: AKy350YKp2UCp0PHFbv2II78OIaWEueDMkGj0ycSIg/7gnLZ9lAUo9whG2vghjeYUv45/S5Jn0WA18C2s+o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d201:b0:240:d8d8:12c4 with SMTP id
 o1-20020a17090ad20100b00240d8d812c4mr2810027pju.3.1680738359091; Wed, 05 Apr
 2023 16:45:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Apr 2023 16:45:54 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405234556.696927-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: VMX: Fixes for faults on ENCLS emulation
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Binbin Wu <binbin.wu@linux.intel.com>,
        Kai Huang <kai.huang@intel.com>
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

Found-by-inspection (when reviewing Binbin's patch) fixes for incorrect
emulation of faults when KVMintercepts and emulates (sort of) ENCLS.

Very much compile tested only.  Ideally, someone with SGX hardware can
confirm that these patches are correct, e.g. my assessment that KVM needs
to manually check CR0.PG is based purely of SDM pseudocode.

Sean Christopherson (2):
  KVM: VMX: Inject #GP on ENCLS if vCPU has paging disabled (CR0.PG==0)
  KVM: VMX: Inject #GP, not #UD, if SGX2 ENCLS leafs are unsupported

 arch/x86/kvm/vmx/sgx.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)


base-commit: 27d6845d258b67f4eb3debe062b7dacc67e0c393
-- 
2.40.0.348.gf938b09366-goog

