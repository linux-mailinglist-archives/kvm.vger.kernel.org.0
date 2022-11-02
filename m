Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3341C6170E3
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbiKBWv1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbiKBWvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:51:23 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C211ABE17
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:22 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id oo18-20020a17090b1c9200b0020bdba475afso2443933pjb.4
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=JcZMucM3N+QRdhicEc59RBXatvydp0DZ46+SwzfIwd0=;
        b=B289Onc/ttH2rYwc2xy8gEOghB2eFoDqH1152VhNGYLA2a4CyMoXfLM7yiFQU+UO+c
         wG5SfuuM8fNVx46r6KkwjysJvRrMhVADhxMtCoejRAbvnVJ059V+9re7pNVxdbcgmKTh
         5nA3QMT7K5akIFWKEG2FkkHI5JnQ7EWYs6UhflKMP1K/n1rUw/DlIP8nEZTm97h22y4r
         ogSKz902664r4DJf65u+kKq3NjjOnMF7w3sQhPlQCTkBgB8YDVaoYlXfhRzEGpoTDHnh
         55TI89btHMLSzqV9pua4wjLu+UlzxoQ24Yb6sas931D91yJRHjLDAkEiro40N6o8x0v6
         Amxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JcZMucM3N+QRdhicEc59RBXatvydp0DZ46+SwzfIwd0=;
        b=dhuWaMHhudUcQTFUVuCcw0bpuoP14Nm4QJw1qktTVS7sf+Rv0V3wZGzc/bQW4bYlGt
         TGyH44PFaqXI6blMP5d1Jdowg8klJ0BD5d6U+cGgSpO4DDnOZJ7009mNeX4qUQPQh0f6
         /11zFjQs5vwGDqeAub01me/jm3GhcV+ERds5FHFgBLpWFG7oJAwTeRM8QvxFeiysCpsK
         0sU0wMdnDs/VGadNorNDVZWJvU4PoWMGbgXeZvGQhkC+W8A1wMvegt1zCx7YD+b6BNHN
         CwZDaXWhAzG+VoXZ9GjAiqUkn9ftanCLnmdzblBfJ5hwDnBiJCn0ziSAWY4vs6wUYfgF
         Hmwg==
X-Gm-Message-State: ACrzQf2VSvDUcBwIjnBL1ZJ/effaz00MgyP/Ar4NqthCCoKMP5gXqbSr
        O8SkZGrMvHtehcebjwRtf4Ga5jvD1fQ=
X-Google-Smtp-Source: AMsMyM4/AhaR3mgTbJPXsQFRw84peYl1yqd1pH6pMqEQLwC4Svc0SaIjChSozZtFAPG5BkXn8fP8L4FDJZo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:26cd:b0:188:4c74:e1de with SMTP id
 jg13-20020a17090326cd00b001884c74e1demr3424979plb.56.1667429482375; Wed, 02
 Nov 2022 15:51:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:50:48 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-6-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 05/27] x86/pmu: Fix printed messages for
 emulated instruction test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Like Xu <likexu@tencent.com>,
        Sandipan Das <sandipan.das@amd.com>
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

From: Like Xu <likexu@tencent.com>

This test case uses MSR_IA32_PERFCTR0 to count branch instructions
and PERFCTR1 to count instruction events. The same correspondence
should be maintained at report(), specifically this should use
status bit 1 for instructions and bit 0 for branches.

Fixes: 20cf914 ("x86/pmu: Test PMU virtualization on emulated instructions")
Reported-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index da8c004a..715b45a3 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -512,8 +512,8 @@ static void check_emulated_instr(void)
 	       "branch count");
 	// Additionally check that those counters overflowed properly.
 	status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
-	report(status & 1, "instruction counter overflow");
-	report(status & 2, "branch counter overflow");
+	report(status & 1, "branch counter overflow");
+	report(status & 2, "instruction counter overflow");
 
 	report_prefix_pop();
 }
-- 
2.38.1.431.g37b22c650d-goog

