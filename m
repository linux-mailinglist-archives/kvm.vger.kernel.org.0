Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698F154B25D
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 15:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240750AbiFNNgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 09:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbiFNNgg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 09:36:36 -0400
Received: from hust.edu.cn (mail.hust.edu.cn [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DEE1C135;
        Tue, 14 Jun 2022 06:36:35 -0700 (PDT)
Received: from localhost.localdomain ([172.16.0.254])
        (user=dzm91@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 25EDZ9Yq022324-25EDZ9Yt022324
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 14 Jun 2022 21:35:13 +0800
From:   Dongliang Mu <dzm91@hust.edu.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     mudongliang <mudongliangabcd@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] x86: kvm: remove NULL check before kfree
Date:   Tue, 14 Jun 2022 21:34:58 +0800
Message-Id: <20220614133458.147314-1-dzm91@hust.edu.cn>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: dzm91@hust.edu.cn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: mudongliang <mudongliangabcd@gmail.com>

kfree can handle NULL pointer as its argument.
According to coccinelle isnullfree check, remove NULL check
before kfree operation.

Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
v1->v2: modify my signature name
 arch/x86/kernel/kvm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 1a3658f7e6d9..d4e48b4a438b 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -236,8 +236,7 @@ void kvm_async_pf_task_wake(u32 token)
 	raw_spin_unlock(&b->lock);
 
 	/* A dummy token might be allocated and ultimately not used.  */
-	if (dummy)
-		kfree(dummy);
+	kfree(dummy);
 }
 EXPORT_SYMBOL_GPL(kvm_async_pf_task_wake);
 
-- 
2.35.1

