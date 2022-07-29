Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBD4584A15
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 05:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbiG2DLS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 23:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiG2DLP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 23:11:15 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2155726E
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 20:11:14 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f3-20020a5b0d43000000b00671194e39abso2952496ybr.4
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 20:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=kNE0A+x9UWalb9vmF91QyMPZRoHnFCebpEpgUPj8Ezc=;
        b=iIJ3RBtR5xh0H4378Oz3m55pYJfZiW0vMDObJ3jKpZxsf7c3SCjySczYQkZKGMNUjN
         VpdXCOffh2oniYqHFxdXtlEh5jJrAR9f09itGKalYb6fFWwtcRx4wIo8fj6CbzrZ/LH6
         ow+Bsj1/svcsCuH0V0Yy88W9kTryIoxoBq/JCfF9dxeUGHVfOT1AihA8jeMbUDlC+ium
         1GSFkdupreEcsjY17vS2WWMBABCgywyJm9i167tJcfU8Ymn5P+EnJJvadDFI5ZRr5cTd
         nM9YcjLJlu+GhfouJyjjJcYyMKPKy9YzkhzniwGUwIQXHSd5wXuKsp6URl6Q4ALJ3NH2
         M3LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=kNE0A+x9UWalb9vmF91QyMPZRoHnFCebpEpgUPj8Ezc=;
        b=XnL9Oxs+Ghnd4wdk3BBgcFb9/YcqD6whWB6nZWuZKPZI3b6TEiLSFEhFXfTHLz9BsP
         XnFdiPN97s00nCK1Ljr4tDotFfFmrvCj+YyR3BERzNDbZDflsYeEjrmfFaPqExg9BJYY
         bvbI5jP+MPituNYH4l57vIkxEYcXuoFlrUpyzEomZnrZYjH/aroJautwo8JxB6NGEs5D
         7GlHWM/zG1SDLD07/RMFC+PuUiCZD/lGY85KYbhdI9xrIyZ1glq/Apz4L08dXrOWQ4aC
         IfdsOaRigbAp0Dl7VhAr2WaKOBDSu5v/yECuesCHHFI7RjSbO8P1KRLgBDt8VnBFSCYh
         G/xg==
X-Gm-Message-State: ACgBeo3uLu5SuQqVcjxtCcb0ahTNMi0hMkhARIPH0tRfyn4uVqCdBNx3
        c7AgBRCr9kKGpsfppFws2PZz7IrwD+0JybsTHxiGH2qt0oXZ3L4TbhTcp35jwmMvyNrXPYeZ8Yd
        bk3C5jM2vymxgn6wps5lUUD6F/rg98Fe7g9l0DliDagJfgfVzFOUS8nUekeBm
X-Google-Smtp-Source: AA6agR4HJIggYdlmBdHh4YYfY5nVJBQmgqq1N+ahToG45i0Fi6Zw1+t0m50wkqGKVkihbmQzB9AV/snZWKh/
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2d4:203:14b0:5318:8d0f:301a])
 (user=junaids job=sendgmr) by 2002:a05:6902:38c:b0:670:b6bc:6ed5 with SMTP id
 f12-20020a056902038c00b00670b6bc6ed5mr1095571ybs.604.1659064273263; Thu, 28
 Jul 2022 20:11:13 -0700 (PDT)
Date:   Thu, 28 Jul 2022 20:11:08 -0700
Message-Id: <20220729031108.3929138-1-junaids@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH] kvm: x86: Do proper cleanup if kvm_x86_ops->vm_init() fails
From:   Junaid Shahid <junaids@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, dmatlack@google.com, jmattson@google.com
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

If vm_init() fails [which can happen, for instance, if a memory
allocation fails during avic_vm_init()], we need to cleanup some
state in order to avoid resource leaks.

Signed-off-by: Junaid Shahid <junaids@google.com>
---
 arch/x86/kvm/x86.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f389691d8c04..ef5fd2f05c79 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12064,8 +12064,14 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_hv_init_vm(kvm);
 	kvm_xen_init_vm(kvm);
 
-	return static_call(kvm_x86_vm_init)(kvm);
+	ret = static_call(kvm_x86_vm_init)(kvm);
+	if (ret)
+		goto out_uninit_mmu;
 
+	return 0;
+
+out_uninit_mmu:
+	kvm_mmu_uninit_vm(kvm);
 out_page_track:
 	kvm_page_track_cleanup(kvm);
 out:

base-commit: a4850b5590d01bf3fb19fda3fc5d433f7382a974
-- 
2.37.1.455.g008518b4e5-goog

