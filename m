Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D2A4D5BFA
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 08:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346987AbiCKHEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 02:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346944AbiCKHE2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 02:04:28 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192A585950;
        Thu, 10 Mar 2022 23:03:22 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id e2so6964240pls.10;
        Thu, 10 Mar 2022 23:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mGM0ZiK+NvSXxBCFgDxX2j+AvMkjH2c5Fn9qXNWdyQQ=;
        b=VWtLfvf4rRksbcko3VrPqjGmWuDEcSV9GLG22i4QcHrev7UoasurYNeOuSiXg/15bT
         QeSjJwAlZBKDERqolggzLGHuqQIoXXHCtu23yK0/odG1h748l1fFggkMil7m8J7v5iGS
         iuT0sOa0zJfiZlvjLPx72h0t7OkpJ3db2S4oRW4ZVcA5l1tcDqVBTtNDeb4FJtatvmvQ
         TBgIe8EXIXzwMklzuXSCkqfKtpyFDdbCUKqvq/a+qOT2IX84gqCEF7q4YdYpBoWM+4h1
         jcwnanCER0IVU/AFL3kww+0eZUZFrwidC5SZojo9JkXlwHtMmxjJhaalCAAAkOOt0aez
         3DYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mGM0ZiK+NvSXxBCFgDxX2j+AvMkjH2c5Fn9qXNWdyQQ=;
        b=gsB9n1xTeEaziHJye0EHjaj3eYfEhuh7uJK0g3LmkVI7gIGTQA3U6LO63J8gF2UXmn
         Y12vcxn7BHuwlIk02Nj6IdEl6ynOd6APPhZlpaLUr28vARjS5/dJi6NISod68UwHu5pg
         0b9YecdN4M7uqHe7Ne2bthPstvkEXHZt8xW07Hr93iD382jnz4nKyFNwpXQLaNmZ+mrY
         sxUn8qziZkbjP7qK+lahHHo+SDFf1BlvZ6yfYc98pemM9lfKvnzjDQ574vZXIBDk/9LX
         itc+eI70Im3u4hFqllTJIIyPq7kzUm1bfKzYxjyCLlISQUp2XwYJV3ZuSDKHl7Wxlzx5
         Y8PQ==
X-Gm-Message-State: AOAM531qt652vrRGwjhiqP+GQuGdTIqDVouxAJ/Cy7woE3SyUBnpyVQ+
        Oq87x76UswqZy5kXTnGAOEFbxwZwHEk=
X-Google-Smtp-Source: ABdhPJxYto/Z+1zCP3rHxcbEpBGXmSMvdcMy46HTJNDxKQCbIYD9UZv9vx3N1O1zLyb63rGpINn+uw==
X-Received: by 2002:a17:902:b406:b0:14f:bb35:95ab with SMTP id x6-20020a170902b40600b0014fbb3595abmr8869206plr.140.1646982201440;
        Thu, 10 Mar 2022 23:03:21 -0800 (PST)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id c3-20020a056a00248300b004f6f729e485sm9707560pfv.127.2022.03.10.23.03.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Mar 2022 23:03:21 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH V2 2/5] KVM: X86: Fix comments in update_permission_bitmask
Date:   Fri, 11 Mar 2022 15:03:42 +0800
Message-Id: <20220311070346.45023-3-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220311070346.45023-1-jiangshanlai@gmail.com>
References: <20220311070346.45023-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

The commit 09f037aa48f3 ("KVM: MMU: speedup update_permission_bitmask")
refactored the code of update_permission_bitmask() and change the
comments.  It added a condition into a list to match the new code,
so the number/order for conditions in the comments should be updated
too.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c12133c3cf00..781f90480d00 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4583,8 +4583,8 @@ static void update_permission_bitmask(struct kvm_mmu *mmu, bool ept)
 			 *   - Page fault in kernel mode
 			 *   - if CPL = 3 or X86_EFLAGS_AC is clear
 			 *
-			 * Here, we cover the first three conditions.
-			 * The fourth is computed dynamically in permission_fault();
+			 * Here, we cover the first four conditions.
+			 * The fifth is computed dynamically in permission_fault();
 			 * PFERR_RSVD_MASK bit will be set in PFEC if the access is
 			 * *not* subject to SMAP restrictions.
 			 */
-- 
2.19.1.6.gb485710b

