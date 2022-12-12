Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8A5364A74C
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbiLLSii (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:38:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbiLLShn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:37:43 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F2D11150
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:42 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id 191-20020a6214c8000000b00577ab8701b0so426997pfu.0
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x5QngdHQiKQfEuJYIiEzFXAizHnjRUO3mh7eHj4eZ3w=;
        b=rdP1+wMzNzcT40yMVG9EmesGEqtj8WetNxbG2ao8AaGcVeiWSJtrO9mjxyuqOOP+dK
         d/jDekzoXjtR9ksfmyl+xmS2Wqlf9meX9787kRVadr1tpGUOdurqsIR7tRFrrrL/UsDj
         BehiVYyGedKtL9yglQ2xG49nvJ/Aet8SbOXABV5x4iPwq8SIkEfARjtqQDjGEc/Y2Orw
         2D5XcyaRWgUaKlMiYtN0vsxBqW5gk5ADC5tH7tmBYUiegMI3P1DWdTj278HS1W8wMSgU
         ptS3InxvJ9CMBTDB4iDVmABCIyjG87wIO04Uqa/+Sgj5E25pXVR2owVOfsVLdOVXgTai
         OTqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x5QngdHQiKQfEuJYIiEzFXAizHnjRUO3mh7eHj4eZ3w=;
        b=DO56Q/Bf2mt4aeOu1M2mxj76+8onSKU3ikOzFUs7YdTdpuWKU5HsxrW9hJm40f4iC3
         nHMx7U2NNTjUDY+ASw/o5PWIVTtQfo84RvKIS7EVVCS8o2irYMS0M6l13ZuIwAuwBiXw
         ecLBoEQKgBK/m23Oomhy3IhU7CFpqZRMZkY7pQkaM+vLT0agf5ks8XlzjyQ44BIq1gum
         qE9XNlhRwrcGMknstDTmDcUxUAw45M70358xPnjGx3HFY0uZEgy/+RCeyEyknYaCJboX
         5BVl4qadXgEtPVYFgRsxibNWG2Lh0jF9P0ZWt6x1hGuYDxShVdPo+s4uDSPQt7dKadrr
         NRaw==
X-Gm-Message-State: ANoB5pn7QCI8yOYoLDfq3UzVhbbYVDvigIwxsKAlG0G6lMzQlxqWJdO2
        PMB9LVNmNyKAlV2D96v1uX35JsTCUAcX
X-Google-Smtp-Source: AA0mqf6Dn6GCbSxu0NPu9oPjgMiz92uF+OHQPKb3rPZT7vKfROULEeTOeno/R2eXy5pVf+Qfw+qZw7VUJRdb
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:aa7:820e:0:b0:573:ab15:1d6f with SMTP id
 k14-20020aa7820e000000b00573ab151d6fmr85141950pfi.9.1670870261939; Mon, 12
 Dec 2022 10:37:41 -0800 (PST)
Date:   Mon, 12 Dec 2022 10:37:18 -0800
In-Reply-To: <20221212183720.4062037-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221212183720.4062037-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221212183720.4062037-12-vipinsh@google.com>
Subject: [Patch v4 11/13] KVM: selftests: Replace hardcoded Linux OS id with HYPERV_LINUX_OS_ID
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
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

Use HYPERV_LINUX_OS_ID macro instead of hardcoded 0x8100 << 48

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/hyperv_clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
index d576bc8ce823..2ee0af0d449e 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
@@ -104,7 +104,7 @@ static void guest_main(struct ms_hyperv_tsc_page *tsc_page, vm_paddr_t tsc_page_
 
 	/* Set Guest OS id to enable Hyper-V emulation */
 	GUEST_SYNC(1);
-	wrmsr(HV_X64_MSR_GUEST_OS_ID, (u64)0x8100 << 48);
+	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
 	GUEST_SYNC(2);
 
 	check_tsc_msr_rdtsc();
-- 
2.39.0.rc1.256.g54fd8350bd-goog

