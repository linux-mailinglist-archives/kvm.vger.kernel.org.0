Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9AF766484
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 08:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbjG1Guk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 02:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233625AbjG1GuQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 02:50:16 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976F43C2F;
        Thu, 27 Jul 2023 23:50:01 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3fe10691ef6so820835e9.2;
        Thu, 27 Jul 2023 23:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690527000; x=1691131800;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uhSR/39SsHibv71ovDtdFhaEOQZBAeJ8bNjoNr9uDp0=;
        b=FXJ5lz2iLlHLoCIF000EnExmKrZsCW4Ka/ScVT4MzNXmVTFi4GvkwDLYANYxP+ZHCy
         CNr7tybHkrDv+Zgo19HvRVwtM0j1XbqnsX2XThJmP74AbFUVVW8sEBDF2HbKusrPQiHD
         Uo3jLXRuFIqSJPUCq8dCfU1wf2sZGR6qyT/M/n/eNrWA20KjlczR8/OMMf3585Gg/G82
         VanX4X4OpvCJqWFbNMHM5NGsY1OxW8hOA6lOaDS3sk8frkRJXsIC8AoXi1bjY+OU/T4m
         ctlKKxxQLNoLB1aFHshjRQ/ynKExLbZF+BPg6NL342YnAdhwvAoHK85EunCmFp3BCCwr
         DD1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690527000; x=1691131800;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uhSR/39SsHibv71ovDtdFhaEOQZBAeJ8bNjoNr9uDp0=;
        b=FzgXCBV9toSF9gxuINQXoiP8O7NulbYC9nGl9Q5HWXLIj8MhkW9FVLOasF9op6vvSe
         aAzok8Hj4Rzzdi0iBELOE2wwyHaJhpnawSByre54mPISs2PKEDnOd8YoA4ruwtMJIhMg
         eH5owdS0/vpXyjJ8aEr1CDniEq5hZJeYPpsRYgwfrsnqMk+FQMAQPn0nZmCquH259n9e
         MqUXCiI2xSlR+vyc4+pD7ZU2yZqIIp4Ws9eVhSQ0vF3zbCPjb0QbnxHJ6h+EgOXHYZ8J
         997GHOm1Qx3DDTVaLcm1kCxwuVhPUU0Y7CcvnYKZWs+YhhPFF3OlQURD8c+82PIRh7eZ
         hMkw==
X-Gm-Message-State: ABy/qLZx3WI2D3pLaHMjUI/0M86Qd6C9ao5bt4YzavS0WXSqjT1jaEa9
        tybbbmayFhHBiwxiKpivGKDBjbqSWtIpfqhwpE8=
X-Google-Smtp-Source: APBJJlG0HScZfh6FKqpkhYfnx3dtioDusRby0/HOvMWJE3Vi2nhEuoRCvDZ1ryeb+V9lRE3E3oEgMyL3TgN2wC7ETNM=
X-Received: by 2002:a7b:c314:0:b0:3fb:403d:90c0 with SMTP id
 k20-20020a7bc314000000b003fb403d90c0mr776397wmj.39.1690526999748; Thu, 27 Jul
 2023 23:49:59 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Fri, 28 Jul 2023 14:49:48 +0800
Message-ID: <CAPm50aLxCQ3TQP2Lhc0PX3y00iTRg+mniLBqNDOC=t9CLxMwwA@mail.gmail.com>
Subject: [PATCH] KVM: X86: Use GFP_KERNEL_ACCOUNT for pid_table in ipiv
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peng Hao <flyingpeng@tencent.com>

The pid_table of ipiv is the persistent memory allocated by
per-vcpu, which should be counted into the memory cgroup.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0ecf4be2c6af..da1bf3648939 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4651,7 +4651,7 @@ static int vmx_alloc_ipiv_pid_table(struct kvm *kvm)
        if (kvm_vmx->pid_table)
                return 0;

-       pages = alloc_pages(GFP_KERNEL | __GFP_ZERO,
vmx_get_pid_table_order(kvm));
+       pages = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO,
vmx_get_pid_table_order(kvm));
        if (!pages)
                return -ENOMEM;

--
2.31.1
