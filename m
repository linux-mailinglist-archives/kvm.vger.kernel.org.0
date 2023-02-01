Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B04C686FF6
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 21:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbjBAUqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 15:46:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbjBAUph (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 15:45:37 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E297A4BA
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 12:44:56 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id h16so18468813wrz.12
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 12:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Si9kzr7Ck9J5FJkWCPsjkhUgmegMqi5GAbSuKxlmi/Y=;
        b=sXMxj/CKJBGFdLzPqQuDQiOPwKF/J04CKNI5iVbGlsHYa+yHZsQXZ/welJivcDAh78
         03XN/aIk9smRRSJBbVcD8A7xCJQW537kgAuRtyai14FS8t0ukXFaqkwlkudC99dkmvdN
         rtlhlvW0kPQwaNg8Yz96FxnRXUt/hZZ4kDgRUlcTj6wrqyrl6sv/drdH7ZlZp7N0xpgr
         7/F+R8t/koV++BDvOKRHqSKkhTRC4E1+ivjSfL+Y8IvbVH6WudoBt9K7CLfIp39iEZO0
         iRMQLwcQy13UYZ9od7HzZ4VJNpiv6qQnkv1bEA/lGY/7VjTyfJn1TzJcGWgdw61ICEHi
         8K6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Si9kzr7Ck9J5FJkWCPsjkhUgmegMqi5GAbSuKxlmi/Y=;
        b=r/fSn1CNK1ZBLXYP1cN/TsetBwtTVEAkMiC6irsZKYWEa94nDZ98CpqsMBYG3K3Zi8
         pY7P//G13aNTdQxlWdS1vyB6Moey49KBbMCL8bXmgvvODzLZ4WVcEcWq6+OAhCpX/o/d
         N5xElGwR8jRv5BRwuJDwtm8/TpRSusj/TZed6tWpT4n4yt04Uwv0QeWzAjMnfs7JSHyi
         dClxIw4t1T8yiT6rmnC/UrdoBXAC/akqZYRbh5K/bcPo/ChlMm1V5hrIR7KvPixq+Sc9
         H1xEdHJ7gH6NmR5OLFBLAX3yFqI+89Tvt01NQaTsMn0tN1CJ+DQBqjwCgeTPHVBUaIZp
         hQBA==
X-Gm-Message-State: AO0yUKV72qRyTmnkPZIQRKuSVB6LDwsDwqAviVArbfSG0BFv6fP+rvxE
        +4O4v+Go4pI9Pi7EIOBep1VFkA==
X-Google-Smtp-Source: AK7set/CwFq4yq21SPwqQ75tLHpsn8i9sDNtMo1urKN3i7lFWEBvGKN2/cx1n6sFd6WcKFjNEuGwpg==
X-Received: by 2002:adf:fb8f:0:b0:2c1:28dc:1566 with SMTP id a15-20020adffb8f000000b002c128dc1566mr99026wrr.41.1675284294722;
        Wed, 01 Feb 2023 12:44:54 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:7611:c340:3d8d:d46c])
        by smtp.gmail.com with ESMTPSA id n15-20020a5d598f000000b002bdff778d87sm19993584wri.34.2023.02.01.12.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 12:44:54 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     dwmw2@infradead.org, tglx@linutronix.de
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 8/9] x86/mtrr: Avoid repeated save of MTRRs on boot-time CPU bringup
Date:   Wed,  1 Feb 2023 20:43:37 +0000
Message-Id: <20230201204338.1337562-9-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230201204338.1337562-1-usama.arif@bytedance.com>
References: <20230201204338.1337562-1-usama.arif@bytedance.com>
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

From: David Woodhouse <dwmw@amazon.co.uk>

There's no need to repeatedly save the BSP's MTRRs for each AP we bring
up at boot time. And there's no need to use smp_call_function_single()
even for the one time we *do* want to do it.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kernel/cpu/mtrr/mtrr.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.c b/arch/x86/kernel/cpu/mtrr/mtrr.c
index 2746cac9d8a9..2884017586f1 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.c
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.c
@@ -814,11 +814,20 @@ void mtrr_ap_init(void)
  */
 void mtrr_save_state(void)
 {
+	static bool mtrr_saved;
 	int first_cpu;
 
 	if (!mtrr_enabled())
 		return;
 
+	if (system_state < SYSTEM_RUNNING) {
+		if (!mtrr_saved) {
+			mtrr_save_fixed_ranges(NULL);
+			mtrr_saved = true;
+		}
+		return;
+	}
+
 	first_cpu = cpumask_first(cpu_online_mask);
 	smp_call_function_single(first_cpu, mtrr_save_fixed_ranges, NULL, 1);
 }
-- 
2.25.1

