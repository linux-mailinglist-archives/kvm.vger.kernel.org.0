Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F1C6190F9
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 07:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbiKDGVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 02:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbiKDGVX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 02:21:23 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500DE2A72B
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 23:21:21 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id w14so5665235wru.8
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 23:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lCXwZ5vfNe4SOPsgVDOzi3k6ifSwUdOjW1NH0sg+5rM=;
        b=zcl272foHL4KaayQq1kq5oJeQSUrmBhZUd7b4kRoVJiQ5379j2ZkkOfI1EwRxRzFbE
         8rvWRUY2sP15++X3oRb2vdl6yJGi0+bKBKI6aS3gNmHmrJjKoyDsAQoHcPv8kv5lLrhr
         +CVusvt/P6/aSZM3mL5e9GYEj9TX3cZIG10RgXGN4aOK1aQZbxs/VQrNJ6Yh01d4SJmw
         2j6WPlHvWC98Hi8oBUVjYV06h3Z9xVvnI+/Wk8kTNMg904MfJ9BgQg5j8lew/yNY7m77
         M59jT/uKm3xEaphlt/qItM9WVOx7TqB7BRo8gJGkU7ZHLJnEvNi8hmUfQIdffryUu+y6
         F4Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lCXwZ5vfNe4SOPsgVDOzi3k6ifSwUdOjW1NH0sg+5rM=;
        b=OBF1g5aIEBuV6C2iW3YyQSCfP5dta8xVtIB96A4WwMf+z2GlgUY3SQbY85JJlVDi9r
         yOyicGXIY93wVQth1JAbMSz49cRwsAqY4Yl++QS50p7TqEWf/oISQ3nXeZ5cW9snpiLb
         RWlFszoH9UfLkgOGVngCgUBG7GkDkxcjgEZ2D2dSQe12g/2lUoR4FbTwPQ6znLgr+F+e
         HTW8edMYRxxca6ikgWtilPi/jKiBsUkJsCeFQHutHm79bYs88fl9e4NwB/2vZvm2z2C2
         Su0i4KgwC9cNJKnxdgp8d+GV74Q+bUAZ1nO/jR0nO7RA5hO9oT1Z3bPyOjIlu+aeGvKU
         5PGA==
X-Gm-Message-State: ACrzQf0w6IJwLanlS9OcY82fH3V7WjB0F4DiGEuT+b8AdzL7H72O37yk
        DKaoeXs8nk5g215sguPsSwANdA==
X-Google-Smtp-Source: AMsMyM68wJEa3smABHPK3YXkguRUiNr4QZx08ls9uFNkEujnEZnJ0igA3c8PEyj/dIjxjaBk9yTbDw==
X-Received: by 2002:adf:fe8e:0:b0:236:6860:e55a with SMTP id l14-20020adffe8e000000b002366860e55amr20229508wrr.105.1667542879959;
        Thu, 03 Nov 2022 23:21:19 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b4d7:0:c7c:f931:dd4c:1ea6])
        by smtp.gmail.com with ESMTPSA id w11-20020a5d608b000000b002366f9bd717sm3099924wrt.45.2022.11.03.23.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 23:21:19 -0700 (PDT)
From:   Usama Arif <usama.arif@bytedance.com>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com,
        bagasdotme@gmail.com
Cc:     fam.zheng@bytedance.com, liangma@liangbit.com,
        punit.agrawal@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [v2 6/6] KVM: selftests: add tests for PV time specific hypercall
Date:   Fri,  4 Nov 2022 06:21:05 +0000
Message-Id: <20221104062105.4119003-7-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104062105.4119003-1-usama.arif@bytedance.com>
References: <20221104062105.4119003-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a vendor specific hypercall.

Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 tools/testing/selftests/kvm/aarch64/hypercalls.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/aarch64/hypercalls.c
index a39da3fe4952..c5c304e886a5 100644
--- a/tools/testing/selftests/kvm/aarch64/hypercalls.c
+++ b/tools/testing/selftests/kvm/aarch64/hypercalls.c
@@ -78,6 +78,8 @@ static const struct test_hvc_info hvc_info[] = {
 	TEST_HVC_INFO(ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID,
 			ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID),
 	TEST_HVC_INFO(ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID, 0),
+	TEST_HVC_INFO(ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID,
+			ARM_SMCCC_VENDOR_HYP_KVM_PV_LOCK_FUNC_ID),
 	TEST_HVC_INFO(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID, KVM_PTP_VIRT_COUNTER),
 };
 
-- 
2.25.1

