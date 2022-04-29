Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B34513FF1
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 03:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353701AbiD2BHj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 21:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353678AbiD2BHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 21:07:35 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62549BC864
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 18:04:19 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id z5-20020a170902ccc500b0015716eaec65so3482080ple.14
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 18:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=/1wb0EUJMAOVjEcNcUn77zKNCe+7w/+d1xa9d1eIEYw=;
        b=sjl1W+oS3wTgYKVlkQFCV2ylujEI4H1j269rgfGJ12THGn5+Rvk4vLClgn0o7czy4s
         j01ESF7enfH8zDQBtCV+mxjNVBkkm+rLKvUHMXNm9oJyGUk3H2RZu3HiFCx5EFp28ohW
         0GPYxySnIUaTAcFsEi50p2wnwAF9EDayimNf0f+O0R1gtwiBZSMlKo7rGI09N93tZ/ww
         bz77QOUjQQF2JCU5rLECAdd3GK4qGHZsdTzhLJc0jO0qi8nDrrvwGXul5qHfPzKD8uLK
         +A1OKQqF5JBS6WrOyqqFvpzN9EeyGxRpls3oqRbg2MbE1l1ENz8RD7XOVds3FVF0wb2T
         O0XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=/1wb0EUJMAOVjEcNcUn77zKNCe+7w/+d1xa9d1eIEYw=;
        b=yIPzpQ3z5UlrlB99FXq75ByhRBH05iYihVLS8LQJm3iOTpCr14Z6KcpHYnSonaTkeZ
         XDUayhV20y3tfwkzm/p6E+CGVf0gaamEm3vL5stRtGWDbMPbMmBdM86Y6CXQz+SOSBiF
         lZj0X8R3jkeZbYRBzPRV8HFVNqEG5Q111gWSTFMlGuvzOTSvKsf/bWACDz4Y1llTm83O
         9IIeKXUwv1n6HUEoteuAX/QQroekbaBjI1hwjYyPaXQGEDy6ryyvFlIvki64VKL4/c0A
         AvfVXa+ldidYCP0Z93dHLgzAT4VUz6+AvQj3R4Q+UT/04tGZTYPMgs+z6AKkMRJAiBQ/
         +Quw==
X-Gm-Message-State: AOAM532jV9Ac9E9hk73aiCd188t0g9V+DAWv+ESyOf+YIvqpg4kxwlDC
        neZo06ux9cG4YKHfRue9TbGZf2CVT+8=
X-Google-Smtp-Source: ABdhPJwbWXQVHFF1qK8TuOCj10tHHD5fJztnTGKmSRlsECbDASEEZkNbM4JFFFCD6hU3qDT7mQgxB3wI198=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2391:b0:50a:3ea9:e84d with SMTP id
 f17-20020a056a00239100b0050a3ea9e84dmr37688617pfc.21.1651194258843; Thu, 28
 Apr 2022 18:04:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 29 Apr 2022 01:04:06 +0000
Message-Id: <20220429010416.2788472-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 00/10] KVM: Clean up 'struct page' / pfn helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Clean up KVM's struct page / pfn helpers to reduce the number of
pfn_to_page() and page_to_pfn() conversions.  E.g. kvm_release_pfn_dirty()
makes 6 (if I counted right) calls to pfn_to_page() when releasing a dirty
pfn that backed by a vanilla struct page.  That is easily trimmed down to
a single call.

And perhaps more importantly, rename and refactor kvm_is_reserved_pfn() to
try and better reflect what it actually queries, which at this point is
effectively whether or not the pfn is backed by a refcounted page.

Sean Christopherson (10):
  KVM: Do not zero initialize 'pfn' in hva_to_pfn()
  KVM: Drop bogus "pfn != 0" guard from kvm_release_pfn()
  KVM: Don't set Accessed/Dirty bits for ZERO_PAGE
  KVM: Avoid pfn_to_page() and vice versa when releasing pages
  KVM: nVMX: Use kvm_vcpu_map() to get/pin vmcs12's APIC-access page
  KVM: Don't WARN if kvm_pfn_to_page() encounters a "reserved" pfn
  KVM: Remove kvm_vcpu_gfn_to_page() and kvm_vcpu_gpa_to_page()
  KVM: Take a 'struct page', not a pfn in kvm_is_zone_device_page()
  KVM: Rename/refactor kvm_is_reserved_pfn() to
    kvm_pfn_to_refcounted_page()
  KVM: x86/mmu: Shove refcounted page dependency into
    host_pfn_mapping_level()

 arch/x86/kvm/mmu/mmu.c     |  26 +++++--
 arch/x86/kvm/mmu/tdp_mmu.c |   3 +-
 arch/x86/kvm/vmx/nested.c  |  39 ++++-------
 arch/x86/kvm/vmx/vmx.h     |   2 +-
 include/linux/kvm_host.h   |  12 +---
 virt/kvm/kvm_main.c        | 140 +++++++++++++++++++++++++------------
 6 files changed, 131 insertions(+), 91 deletions(-)


base-commit: 2a39d8b39bffdaf1a4223d0d22f07baee154c8f3
-- 
2.36.0.464.gb9c8b46e94-goog

