Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9781578826
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 19:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234024AbiGRRNi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 13:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233320AbiGRRNh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 13:13:37 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758DA2B626
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:13:36 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d18-20020aa78692000000b0052abaa9a6bbso3574772pfo.2
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=hBW555vzZ9VwsiwxyvqF8/j7N4IdLZ1Pm2etmGkj9Ok=;
        b=EqOXIAFmmesXHqqQFo3pONu5uf32f5JqWCF2lKIjhQd4BOWd19v/3vwgO9In29blAz
         oMa8JbfevDRcwU1N4l97vw6esfc1WgiX18pg8XjHK8EY1i6N0JW65KpmARgyhOaWgftV
         ZSdz+oUM37q4T1JPfJcXLMD3Np0m5MWop0YBUCkyTBeo7bhFgExeoOlJbJNjLMP2SF4W
         YfWuJzBLfBCmm8BGPZcfULXGD7sjQb3TTclxTUn6HBf8EQjT/FP+n94FIqe5+RvBSQfb
         F4OS1GENnPqUPZOB8jHsOiRUnbuV7dRAn1XscKeYfNghwrnRueLHUHgOzecgiu8MQGQK
         +DFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=hBW555vzZ9VwsiwxyvqF8/j7N4IdLZ1Pm2etmGkj9Ok=;
        b=0JssBrKf8nGYFxAu1dstkzLPz8GVagsGZwVBQ/EGcYm88pi21v/OEUUN9aKJJmG3tK
         9/hfw2OPJJq6CaNYAhpFjqqJW7J2AOqzyu5mbsFVoVUrMAoc/I6A8fZboVq2+yIctq0N
         rrHTmV2CFnQZQVWjb08bcxF0ThS6B+lZwwCsaaeWxeFzIkm4YlcxRf8XVI3dsRU7OJDl
         q6MWSe4/ljmWPlLD2PHyWeDYJf9q4ULVJvJjEEl/klDEyGXspVZWuHi1OokHYLscDbEB
         QP1pQqWDGijOtVInlRyveJJV+zfVWlyAUx65uFqFrG9G5Gdsq0Gxe8Q6RAYC1i2lEIY5
         tQGQ==
X-Gm-Message-State: AJIora+iOa5jWVMFlOaNX/eUseEwk2/3V+hSpLw+60N+EMNznCBq90WL
        mdP6xwTx4rifHjrYbjiJPT+ZVFL41/sL
X-Google-Smtp-Source: AGRyM1tNyE9t7NLqrrVSjIDGyHcYXyS3Ib48NX9s+UucFR8qcFtBGC2Zl8iwLf0L2nIH/7d+e4u+QANdsxDC
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:902:f68c:b0:16c:4eb6:913c with SMTP id
 l12-20020a170902f68c00b0016c4eb6913cmr28593782plg.2.1658164416047; Mon, 18
 Jul 2022 10:13:36 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon, 18 Jul 2022 17:13:30 +0000
Message-Id: <20220718171333.1321831-1-mizhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 0/2] Extend KVM trace_kvm_nested_vmrun() to support VMX
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>
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

This patch set update trace_kvm_nested_vmrun() to support VMX:
 - Change the print of EPT/NPT enabled boolean to print of nested
   EPT/NPT address in the trace;
 - Add a caller from vmx/nested.c.
 - Fix some minor format fixes from the callsites and Update the trace
   output naming according to the x86 vendor.

v1 -> v2:
 - fix some format issue in trace_kvm_nested_vmrun() in vmx/nested.

v1 link:
 - https://lore.kernel.org/lkml/20220708232304.1001099-2-mizhang@google.com/T/

David Matlack (1):
  kvm: nVMX: add tracepoint for kvm:kvm_nested_vmrun

Mingwei Zhang (1):
  KVM: nested/x86: update trace_kvm_nested_vmrun() to suppot VMX

 arch/x86/kvm/svm/nested.c |  4 +++-
 arch/x86/kvm/trace.h      | 19 +++++++++++++------
 arch/x86/kvm/vmx/nested.c |  9 +++++++++
 3 files changed, 25 insertions(+), 7 deletions(-)

-- 
2.37.0.144.g8ac04bfd2-goog

