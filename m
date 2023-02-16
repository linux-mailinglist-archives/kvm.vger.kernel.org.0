Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500D2699911
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 16:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjBPPkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 10:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbjBPPk3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 10:40:29 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4B35355B;
        Thu, 16 Feb 2023 07:40:26 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id gd1so2274220pjb.1;
        Thu, 16 Feb 2023 07:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5/EYzJowo1zkQ3dnto3B4iHSRvmeCVItrxutmDGogJA=;
        b=PZqUve7aK7Ip19hPioTTDobjiniWkuChAHocY+YWa++XGHRA9rPf/PZnMBSsT6AhZQ
         wbYIo8LADa4S5XnZ4MalIN3vlC5DiC8I++b0bqSO0Z3j3VRYBS4xGonfZ11fMUKtKal+
         lhYJTUWBatUvG9DPeFR/3GM8xwk4mB9tLWv4XZusueUhdLRjYk+7gaLdFV2MtNGD7Gpw
         w4Qc6SqvtoFsPMO93KyVLn/paBfWU83M8thR3SkYGbwebhR2+U5Z6/oiKNW/M97+IibK
         WKmNoWnyDf4TzZM73GeK3yOO6JHSq01neY9HqMpiZRvID8O3EKOv102jTEXqIdC0rPlg
         rHHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5/EYzJowo1zkQ3dnto3B4iHSRvmeCVItrxutmDGogJA=;
        b=iYeZUFhOyHkkaMJHsLfyfwi2cW27LTfQRBA0KheGG1wPVHVbQVy/D/O1E0KUaxOqr9
         Nv+R7vEF14mbPEDxWRArZGVzjmE9mF8qtUMfd6BV+ZR0n4ikA3gcM2+kF7hzx2C7D0sb
         lnKYvT0D8rZgZJlMgmVaRTw7iqItwi2FpU/DOZNdS3gDKfDY3PFQVewbSG8kbHsYF4fv
         KXlLsvnMW/HvujXwiKiPPzapFG/g1XdRk9jHAtfrxj8FKe/cmtd4g+6gcrUmAk93IEB3
         3wF79vQQjjcbBFRdqZMc81lIsB4ecT0ixaFyzNDtrfs/6U6QoQFBXjqX+7N9tRZ+xkYH
         BVEw==
X-Gm-Message-State: AO0yUKX2uGqfoxm6Pt3Utq3goyWi/aL9krlw3se6/VnwOl/CRPDBcDxP
        A+1IvrQD92ShOiyR05OlIT9GqCEzVEM=
X-Google-Smtp-Source: AK7set+zsMIBpmxpANGhSQ6A7XCHQKBq8kL+5C/a7tyo/X6WXcYeZQULjRrLo/kF/5uMUTUiO/GZgA==
X-Received: by 2002:a17:903:32c6:b0:19a:b7c0:f097 with SMTP id i6-20020a17090332c600b0019ab7c0f097mr7307981plr.57.1676562025438;
        Thu, 16 Feb 2023 07:40:25 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id k14-20020a6568ce000000b004ecd14297f2sm1350680pgt.10.2023.02.16.07.40.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Feb 2023 07:40:24 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH V3 03/14] kvm: x86/mmu: Check mmu->sync_page pointer in kvm_sync_page_check()
Date:   Thu, 16 Feb 2023 23:41:09 +0800
Message-Id: <20230216154115.710033-4-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230216154115.710033-1-jiangshanlai@gmail.com>
References: <20230216154115.710033-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Check the pointer before calling it to catch any possible mistake.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ee2837ea18d4..69ab0d1bb0ec 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1940,7 +1940,7 @@ static bool kvm_sync_page_check(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	 * differs then the memslot lookup (SMM vs. non-SMM) will be bogus, the
 	 * reserved bits checks will be wrong, etc...
 	 */
-	if (WARN_ON_ONCE(sp->role.direct ||
+	if (WARN_ON_ONCE(sp->role.direct || !vcpu->arch.mmu->sync_page ||
 			 (sp->role.word ^ root_role.word) & ~sync_role_ign.word))
 		return false;
 
-- 
2.19.1.6.gb485710b

