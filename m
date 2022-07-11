Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22DE3570DB5
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 00:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbiGKW6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 18:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiGKW55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 18:57:57 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8637E03F
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 15:57:57 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id j3-20020a17090a694300b001ef87826a62so4071347pjm.0
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 15:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=DAD9AJ7hVwjGPDz75YLlVxSBr8Hz85c/OPljz7ZiLcc=;
        b=Hq1sJ5nd7x3bSwdQ4k+YM00ufbIfu5r8ZXXNo6rc+iJW2lsKeDvt3zMzP2w6W5mbQr
         JK6bM7r4G+IhGmOlpDcOCShmWyzfyFmBv9j5lQ/zY0lE8uzHz2B8+DPxkekPsQURrJUK
         EJ/EurtISNpmOtxo89M6ar3ZNNaUhClkwbAs7/Ndyocl1hVsj2Yune79ZZ6kZekmic/i
         XgR1Xl19alHsb6kSRfnDBA9bGpbIoqhan9I4y0H54mbBrxoHO6KtyafC0fFSb6/f2nEk
         xV05QXJJ58vaGHhaEtVlq+KYLAYiuonU87Es2LIN6JnBrJrhOpv4x83Xh7wfqi2IfYqo
         QKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=DAD9AJ7hVwjGPDz75YLlVxSBr8Hz85c/OPljz7ZiLcc=;
        b=w/OeJpVluG5TWY1Z91UCakM4rKUp9ohU6YJpS2IHKEbAjbZqJk0YcR6GCpwCWLZ/95
         MdVSiThHmW1lDzEyhbrmqfzqZR8/0Wkrf074fqerapANZ2gBJLw7sdeWFuA5+t9WstKO
         /HH/y7poUadm9G2NU+TdMHZijuC2t6Na+sLI0cQKhmBs7tnzzbXhvj/fPhRuYppqlNap
         2dLHy7NxTo7vLD2AMJki270W97PyiBWsTEUNHpnctKT+mtipHr/1PIuTX0E0oEgCV4Ui
         fUC1VQqAqJvt8yMkYHKwkBrCUF6AgG91DGz4pQ8tnAzwsGoKAYBSHDKgZ/mt62Bkd6CC
         zHug==
X-Gm-Message-State: AJIora+yCJ+I+kkj5ErCnca4XLEwO2aZxCBCNg6HqkeX2p1DhpCSXxbd
        lvYmGs9ihqHhpIMNT7T9UbmOoB45RDg=
X-Google-Smtp-Source: AGRyM1srANk6OAlyQWS9Ezd7mhOg4d2we2G/mu8rFmQ0BGwOZGI75xAmbIW5VKBLR0DO9gq6iWlZwjUHJXU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1a8b:b0:525:9c4f:ade5 with SMTP id
 e11-20020a056a001a8b00b005259c4fade5mr21124511pfv.74.1657580276910; Mon, 11
 Jul 2022 15:57:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 11 Jul 2022 22:57:51 +0000
In-Reply-To: <20220711225753.1073989-1-seanjc@google.com>
Message-Id: <20220711225753.1073989-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220711225753.1073989-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH 1/3] KVM: selftests: Test MONITOR and MWAIT, not just MONITOR
 for quirk
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@linux.intel.com>
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

Fix a copy+paste error in monitor_mwait_test by switching one of the two
"monitor" instructions to  an "mwait".  The intent of the test is very
much to verify the quirk handles both MONITOR and MWAIT.

Fixes: 2325d4dd7321 ("KVM: selftests: Add MONITOR/MWAIT quirk test")
Reported-by: Yuan Yao <yuan.yao@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
index 49f2ed1c53fe..f5c09cb528ae 100644
--- a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
+++ b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
@@ -34,7 +34,7 @@ static void guest_monitor_wait(int testcase)
 	else
 		GUEST_ASSERT_2(!vector, testcase, vector);
 
-	vector = kvm_asm_safe("monitor");
+	vector = kvm_asm_safe("mwait");
 	if (fault_wanted)
 		GUEST_ASSERT_2(vector == UD_VECTOR, testcase, vector);
 	else
-- 
2.37.0.144.g8ac04bfd2-goog

