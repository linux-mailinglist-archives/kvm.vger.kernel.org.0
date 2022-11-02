Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFC861686B
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 17:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbiKBQVP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 12:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbiKBQUj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 12:20:39 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8697F2FFDA
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 09:14:59 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id cl5so13633803wrb.9
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 09:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m7TrrgzPAckx8MhzlXbOG19HS5vuSIcZLDLnFx3IxeQ=;
        b=0fMwoeRZHNCs3+eyJg3ygNryplDr80DrJk1L3bYfCxV2ziWdoNriajz7egBPWFlUDx
         wqVWXJacNM3jRg0yzHjHQpfEY/qDel4qPeh/ZooONZpvmKmUgjuDgzJyqfaFCaqf6Kkn
         vNXcaH0SzwTD6G6FuprpgURrGQwMsvB6jmdu+kC6DAELIFzdNKEHEria5xPI151SqlyR
         820zReyhlMk9aGbFb2I+z4lbPK6qrUliHAgmfSavPTd/dSuFeEfAVFTVGFRcpymdZfa6
         u3I3NE0yAEEpXsV+niZ0vDnSsXVFh/cuwQ5ien2+FwztNLuEdRgIBnvNU4iKh+QiezP/
         h9vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m7TrrgzPAckx8MhzlXbOG19HS5vuSIcZLDLnFx3IxeQ=;
        b=QXOgN2SGEBhzF/3inr/tMX9LaA1p07GBHMcwNr24W22QnBMVADmVxcau83yjG5VGmR
         BWyfxQ5ewQXn970VDpFxE4Ph7nZxb6YM790GtBTF81ENceoV1AzlKREmRE3PsMw6BNkG
         9LA/13KBYvrFUUpcE6j77fi04jgGWEbE7oJrS+b2i0ocbLWBuNAgh4FQNOfjGGUMO/Tr
         Yx2E3RGG5hIc/5urmMoto5eSYqKZ1SzUeYYXFblDYpZ9/LBUdEPJA85k7V/w6SEs8KMQ
         FCgWwkdp/oHe8hzZXqHvVytIw8IK02/FFMuXTPSxtX0lsXoQnBfvc8pTzJDSXZ2+E2D2
         CFMw==
X-Gm-Message-State: ACrzQf02CfzWvV578qKfXZVazLP0m/6eLyWe0skp5t04bsg4mOjMjR3x
        CnzpNQKKTZGm+4UbnQ+q/FnQqg==
X-Google-Smtp-Source: AMsMyM64kx8n6kzyuVGSQjYf92MlBu2zMhzN4ZR8BycrERCw7fqPcNS02NCH0GQQnVYB90z0ymW8kQ==
X-Received: by 2002:adf:fc12:0:b0:236:9b2e:4843 with SMTP id i18-20020adffc12000000b002369b2e4843mr15535660wrr.620.1667405664466;
        Wed, 02 Nov 2022 09:14:24 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b4d7:0:6a08:9b26:ab04:7065])
        by smtp.gmail.com with ESMTPSA id m17-20020a5d56d1000000b0022cc6b8df5esm13230923wrw.7.2022.11.02.09.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 09:14:24 -0700 (PDT)
From:   Usama Arif <usama.arif@bytedance.com>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com
Cc:     fam.zheng@bytedance.com, liangma@liangbit.com,
        punit.agrawal@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [RFC 6/6] KVM: selftests: add tests for PV time specific hypercalls
Date:   Wed,  2 Nov 2022 16:13:40 +0000
Message-Id: <20221102161340.2982090-7-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221102161340.2982090-1-usama.arif@bytedance.com>
References: <20221102161340.2982090-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These are vendor specific hypercalls.

Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 tools/testing/selftests/kvm/aarch64/hypercalls.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/aarch64/hypercalls.c
index a39da3fe4952..743ee6cb97d8 100644
--- a/tools/testing/selftests/kvm/aarch64/hypercalls.c
+++ b/tools/testing/selftests/kvm/aarch64/hypercalls.c
@@ -79,6 +79,8 @@ static const struct test_hvc_info hvc_info[] = {
 			ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID),
 	TEST_HVC_INFO(ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID, 0),
 	TEST_HVC_INFO(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID, KVM_PTP_VIRT_COUNTER),
+	TEST_HVC_INFO(ARM_SMCCC_ARCH_FEATURES_FUNC_ID, ARM_SMCCC_HV_PV_LOCK_FEATURES),
+	TEST_HVC_INFO(ARM_SMCCC_HV_PV_LOCK_FEATURES, ARM_SMCCC_HV_PV_LOCK_PREEMPTED),
 };
 
 /* Feed false hypercall info to test the KVM behavior */
-- 
2.25.1

