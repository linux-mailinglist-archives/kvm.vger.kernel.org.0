Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEADA559FA4
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 19:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbiFXRSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 13:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiFXRSM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 13:18:12 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157CF1EAD6
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 10:18:11 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id e8-20020a17090301c800b0016a57150c37so1577958plh.3
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 10:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=v5yna8ItikU2fb5u1sePnTAPT+OQna41hrQ1rG7Dn0Y=;
        b=KyIuHFn8LfqulIFW1TY5xQGMGKE5mrB5KYFzJL5pvXrFz9Z+E8TP798YlQiCx0euRQ
         hACEWEJ6aNEucjttEX9XhVoJgxjBu2sOAZ6pLxOxcPm2wmyAZSgZiK1BPzML1Um0M+k0
         yE3Tl0UTpLUitJyMN8wUwnX93sPI9+HQ3Ao49FkAPuK34WwuRNEqEE1fHuLkb/buqMpa
         5bPwAIpA7c/yXX9a7gflIxragXVwgj9D6/tNfTijiNYw1xmnkLwLY4q6a/K2E6yn5heC
         hRaa4vU+hwzw42TSYRgStAn1/+LuwEpNObCwzt4XMpgU+9X/gGLcIHT7DhbBvD5anPBu
         i8Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=v5yna8ItikU2fb5u1sePnTAPT+OQna41hrQ1rG7Dn0Y=;
        b=h0+eZZueDqRQfh9hSQuOX49KmRqzgryUe6xtiO3QmYh2bjq6qvK7F3U3FCImTyXpZd
         IcQU0QOHq+2TD+bDDespUmHSvMUEZdMXVoPgfXZHr9+XUx0Yp0uTD9WAb5ND/cNMmOq7
         tgdQHC8VfJ4nF9RvmcmUky7QyRchK5/foLs0LiCeoLCT6Epm95K6fOlLIy2zm5mszXkD
         cp/FOUUqtdmiR/iQMPwaz3qbE7WGgRPLeMy63ej0jUZ8wLdWJQVVXdlI4CaPJgfOsFQc
         F6l8VWHbY1Y3tfFiahKn5D9z4iV0nxPlZjUx7G6JYovJ9SQi73KRasx7Wt3j1ZuYLQcn
         emlA==
X-Gm-Message-State: AJIora8MkX3Y3dn02Tvvn0P+Xbw1oatfTXr6WclgHf20SZRIXhRpmnZ/
        8Cod3CcmVgwqbobaO0co4KayW2+3fN8=
X-Google-Smtp-Source: AGRyM1vNM3+l3baD53Rb//jNTwLDUmtvY2umobKNWJc93BvkYCSdkLSQPoj0oan9ZhziLBTWSveAjIySE5E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2450:b0:4f7:bf07:c063 with SMTP id
 d16-20020a056a00245000b004f7bf07c063mr47194536pfj.51.1656091090609; Fri, 24
 Jun 2022 10:18:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Jun 2022 17:18:05 +0000
Message-Id: <20220624171808.2845941-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH 0/3] KVM: x86/mmu: Cleanups for eager page splitting
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
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

Eager page splitting cleanups for a few minor things that were noted in
code review but didn't make it into the committed code.

The last patch in particular is a bit more urgent than I first realized.
I had forgotten that pte_list_desc is now 128 bytes, and I also had a
brain fart and thought it was just allocating pointers, i.e. 8 bytes.
In other words, I was thinking the 513 object buffer was "only" wasting
~8kb per VM, whereas it actually costs ~64kb per VM.

Sean Christopherson (3):
  KVM: x86/mmu: Avoid subtle pointer arithmetic in kvm_mmu_child_role()
  KVM: x86/mmu: Use "unsigned int", not "u32", for SPTEs' @access info
  KVM: x86/mmu: Buffer nested MMU split_desc_cache only by default
    capacity

 arch/x86/kvm/mmu/mmu.c | 53 ++++++++++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 18 deletions(-)


base-commit: 4b88b1a518b337de1252b8180519ca4c00015c9e
-- 
2.37.0.rc0.161.g10f37bed90-goog

