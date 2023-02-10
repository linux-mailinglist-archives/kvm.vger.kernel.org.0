Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8723969159A
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 01:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjBJAeA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 19:34:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbjBJAd0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 19:33:26 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1B564D93
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 16:32:37 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id u15-20020a170902a60f00b001992a366c3bso2107765plq.12
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 16:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GV8Qd4jwtvFFFyzJG7jPBupn1ncGCYAxnl51ikPvDjg=;
        b=RfaxmpJmG9jL4AGZCBmKU4zsa8HltXgf43LDd6T84KlHljb9TGwwAfKaXfK+icJs+c
         pUvJL17rd027NxDrs4pR5w1EiXGNc6npCDSiyeAhJYe6/ellqC6mmwWc0KgQooBOE/oT
         xGwtUBZon57cuW9J5Efbvqu5+KlDkNdFI3uf7mlxBuJ00ndVI2VxZgT5SwgGR01NLerQ
         X0XEwC1GhiSrXG7DjUGVWnrDUE0Ug97iS7igTHVoFu/SilkEljhC3/hFLmCSga9nwY5F
         0WUACeMZBk3hONJO9vTn8DBj+1Pd9U20dpofJ3wKywCnk7FuFcmbq1DVgx9LVTOyK3p6
         2FgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GV8Qd4jwtvFFFyzJG7jPBupn1ncGCYAxnl51ikPvDjg=;
        b=tSABPLcd2pm/i5EbwFMfX7xKvYjujkP8rZ6I6pfeepyN07zrdIsLCraDTrJtdlynBZ
         tOVo7dVZlkIpWWs0tISib7LvJMc2VMvHnz1tKsHUiNa/4SkX6sME2NuDKkRNsvi+yiV6
         U1Nw6oLTeum0gVHaK8+oaWa0pVV6X4gCULs2xCw5q383MIIBcDxPTtgpG0XDpJaQX7mI
         zmxStsq3bLrX3R37M0RTn3UKaFrLkmyhwHoFF8hfLFUCkV5wORAZeTnZWYeuscN04s+w
         qOKD6iogPM9b9QSwwdOwZ7cXid3agIFNMwqSbUEa6BnW+FkeMSV6VEDPpeW2jO/h9Ynw
         dNpg==
X-Gm-Message-State: AO0yUKVJ3+hK1kuqucFBJtk8orBJjHl0sLqdV37FoL8lZ1xtj3Yw9MV9
        v3QqL/EIetBSIhDzes5UrOLzmGwSxTU=
X-Google-Smtp-Source: AK7set/M+sHPDt/EnXMFYsTwY4C0va9HLF/aPs6/hhxt23x5YMe3QsKGfhoONHIBb6R/PiS+LP3u8hwzlL0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:b915:0:b0:4d8:12fd:cd3b with SMTP id
 z21-20020a63b915000000b004d812fdcd3bmr2616270pge.115.1675989140811; Thu, 09
 Feb 2023 16:32:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Feb 2023 00:31:45 +0000
In-Reply-To: <20230210003148.2646712-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230210003148.2646712-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210003148.2646712-19-seanjc@google.com>
Subject: [PATCH v2 18/21] KVM: selftests: Drop "all done!" printf() from
 PERF_CAPABILITIES test
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>
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

Drop the arbitrary "done" message from the VMX PMU caps test, it's pretty
obvious the test is done when the process exits.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index 6fc86f5eba0b..6733d879a00b 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -213,6 +213,4 @@ int main(int argc, char *argv[])
 	test_fungible_perf_capabilities(host_cap);
 	test_immutable_perf_capabilities(host_cap);
 	test_guest_wrmsr_perf_capabilities(host_cap);
-
-	printf("Completed perf capability tests.\n");
 }
-- 
2.39.1.581.gbfd45094c4-goog

