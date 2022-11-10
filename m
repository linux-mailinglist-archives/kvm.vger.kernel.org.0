Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16484623877
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 01:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbiKJA5S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 19:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbiKJA5J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 19:57:09 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA219205CF
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 16:57:08 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id n1-20020a170902f60100b00179c0a5c51fso244195plg.7
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 16:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eUq0vFA8ndY9d6ONKF6p5o14/szo67j4mO31X1fzXhQ=;
        b=ISnjkw4UhuHmVKuUmoCNvGEqjV3MQKsrd9zzkNWNwK8a5nTV5bjg+MAfo5L3xdGRlH
         I0bzMV0ysYNJajwQ0GqoVKfcBtI3elSbtl+H99V23yzRL4DL16WsVVSKaCaB4IznNo71
         5JIfdPkB5N0lAq/MAzTD1wvFA5xFsZoasy3Bf1EJshqmdFWP+IBW5krsZlRwypozTO8Q
         30XcaOD5aQh+PopTn9CMmqzy+ML1WhKHi2ZS9JzEkl1BLzwu/MWAmLGQBh4/WwqlPMuj
         IRkiKYYSWwd8xRcApXG60iCqKce2bCZN5qmzIjAkGyes06ExYOFbWEJpqGE5cENTJW64
         64Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eUq0vFA8ndY9d6ONKF6p5o14/szo67j4mO31X1fzXhQ=;
        b=qVa5XnpyeKlPRyUo9HrqT/gLejhjYURA9ewJpepIb7pVjq/lju/k8WobpTgo/RwXYz
         CWULpmISXuDIrbqq+YtIb3Dfaobr0BUPpdA2PgvejZyIBaPYLLhguTzidWlQ7IkuAADN
         NMZ20+CvCsCG/qapwZdpMT1WdVkKUXdxtzanbOIZFrBcyJxAJs2aKeTYC4FXPnbRIqE7
         SW51i13bdzg9E64PA7m8x49jO9+GkVMfNRy1SFagSsBVh94tW1Ng78fjmR99AFI9hchX
         N4cI6p7Lu006+0+6rYNaSjzEjE2s9xWWHLTFRcPOzMNXQbe40mcKdS6vDqu6wvgCTqCh
         DPYA==
X-Gm-Message-State: ACrzQf1tT6MrkGEAzmGWOn7dW3MrWq7pzN1gd03fDPbyOUevABnrDgvC
        aReQrsCEW8B/UhNV09xXi7RMIIW4EDY=
X-Google-Smtp-Source: AMsMyM69pqxrJF/SLakpGezFAlKg1pWH1oDKq/6oavYLLCQJLbq60mbR5Ufk/J/JEHcclX2miXFSWxZ1eis=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8549:0:b0:56c:ba99:7951 with SMTP id
 y9-20020aa78549000000b0056cba997951mr63536349pfn.83.1668041828368; Wed, 09
 Nov 2022 16:57:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 10 Nov 2022 00:57:04 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221110005706.1064832-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: nVMX: Fix another case where KVM overrides VMX MSRs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>
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

Fix another case where KVM overrides the VMX MSRs (well, just the one MSR)
during KVM_SET_CPUID.  Similar to somewhat recent reverts

  8805875aa473 ("Revert "KVM: nVMX: Do not expose MPX VMX controls when guest MPX disabled"")
  9389d5774aca ("Revert "KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL VM-{Entry,Exit} control"")

undo misguided KVM behavior where KVM overrides allowed-1 settings in the
secondary execution controls in response to changes to the guest's CPUID
model.  To avoid breaking userspace that doesn't take ownership of the
VMX MSRs, go hands off if and only if userpace sets the MSR in question

Sean Christopherson (2):
  KVM: nVMX: Don't muck with allowed sec exec controls on CPUID changes
  KVM: selftests: Test KVM's handling of VMX's sec exec MSR on
    KVM_SET_CPUID

 arch/x86/kvm/vmx/capabilities.h               |  1 +
 arch/x86/kvm/vmx/nested.c                     |  3 +
 arch/x86/kvm/vmx/vmx.c                        |  2 +-
 .../selftests/kvm/include/x86_64/processor.h  |  1 +
 .../selftests/kvm/include/x86_64/vmx.h        |  4 +-
 .../selftests/kvm/x86_64/vmx_msrs_test.c      | 92 +++++++++++++++++++
 6 files changed, 100 insertions(+), 3 deletions(-)


base-commit: d663b8a285986072428a6a145e5994bc275df994
-- 
2.38.1.431.g37b22c650d-goog

