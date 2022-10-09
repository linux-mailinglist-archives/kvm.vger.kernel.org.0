Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651FA5F8AFC
	for <lists+kvm@lfdr.de>; Sun,  9 Oct 2022 13:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiJILuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Oct 2022 07:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiJILuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Oct 2022 07:50:04 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A096140D6;
        Sun,  9 Oct 2022 04:50:03 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id bk15so13286486wrb.13;
        Sun, 09 Oct 2022 04:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VUFLsuyuk9+p4OU7Z1hSP0ZO4o7UzZGIf41czrn5Hng=;
        b=A4W4gzNDpE6q/HlxRYLYDvLMmAqbfo53B9Enec3SWu7Fzm1hbPNo0odjnFkT9Kt17s
         kgBch7zi16JDMtvHW6Mv5cBrebn2e+sCmdr4i9ejHvDOMS1dbibuzZwD8nFEifIdTk1r
         1N2dtVxAxJO+kk4znwp/wElU+Whuc5Bh8YZLVoLUiCuorbhyqlJZzPssfRgOi2m9wiK5
         m8zV8w1G/ht7itJg10kMujTuoRM+xJQ5+ft+3IH+eCHouqwMaEeYNdWVX1nARpcaI3qZ
         giRwMozoFMSU51yGNzPIngGpan2a0i6KKHSdZ+q2cAwpiB4L1g9c8yzmhhGuem/YHVPo
         jAzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VUFLsuyuk9+p4OU7Z1hSP0ZO4o7UzZGIf41czrn5Hng=;
        b=MdwuijuOGoR5fQetjTWf0iNjWbZu2u6KZscWL5ucfCeQ0KPTEre7ZUgJQcsflRJ4Ar
         H1ZigIN0K2oUBsGBwIpYwWU2DYxGhLLvBXMTOWpCxQIGMKiwCIVLBeULBZTHbXYF9d1D
         H9e38C8tvL5WNZ87VMHNvLve7bvLLRTpAHXefTVpEfPJzRVxBs3Q1eGX5rjsDS4lRW6C
         3CmNjOp5r+r7EghKonoBXHygfQtBq0usL0+taFcdwYoiYhPzaqR7Bqyw18xeeRRz7F8A
         sB4k9je7Ulihu/12H5qwGRm+eEqdCFE94f7HHw3srJWTbR0GcrkMB/6ToyW9sIE0WYAL
         7NSQ==
X-Gm-Message-State: ACrzQf2OlMWcXCiEvDYYob04ZFQgptortaa/x7hnLkFyuRUXNDAUqGyJ
        R72SLMvMjQ/Uxees7uOB9Ck5XojaRNrJivZCN4DmMPNBCaQrxA==
X-Google-Smtp-Source: AMsMyM4HqdIClTx5IiJd6h6WSoougptHbMCx1FH2dNTqSLIvmGCDZWzym0oefWVFhm7GkaGhc7JTPY3E7Xy6oc+NOT0=
X-Received: by 2002:a5d:588f:0:b0:22a:fe0c:afb8 with SMTP id
 n15-20020a5d588f000000b0022afe0cafb8mr9016525wrf.431.1665316201699; Sun, 09
 Oct 2022 04:50:01 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Sun, 9 Oct 2022 19:49:50 +0800
Message-ID: <CAPm50aKGuxUfedpkPDpTZyGiLC1YFn3Wz+=5axzyBA9o2rd0XA@mail.gmail.com>
Subject: [PATCH v2] kvm: x86: Keep the lock order consistent
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peng Hao <flyingpeng@tencent.com>

 Acquire SRCU before taking the gpc spinlock in wait_pending_event() so as
  to be consistent with all other functions that acquire both locks.  It's
  not illegal to acquire SRCU inside a spinlock, nor is there deadlock
  potential, but in general it's preferable to order locks from least
  restrictive to most restrictive, e.g. if wait_pending_event() needed to
  sleep for whatever reason, it could do so while holding SRCU, but would
  need to drop the spinlock.

Thanks Sean Christopherson for the comment.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/xen.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 280cb5dc7341..fa6e54b13afb 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -965,8 +965,8 @@ static bool wait_pending_event(struct kvm_vcpu
*vcpu, int nr_ports,
        bool ret = true;
        int idx, i;

-       read_lock_irqsave(&gpc->lock, flags);
        idx = srcu_read_lock(&kvm->srcu);
+       read_lock_irqsave(&gpc->lock, flags);
        if (!kvm_gfn_to_pfn_cache_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
                goto out_rcu;

@@ -987,9 +987,8 @@ static bool wait_pending_event(struct kvm_vcpu
*vcpu, int nr_ports,
        }

  out_rcu:
-       srcu_read_unlock(&kvm->srcu, idx);
        read_unlock_irqrestore(&gpc->lock, flags);
-
+       srcu_read_unlock(&kvm->srcu, idx);
        return ret;
 }

--
2.27.0
