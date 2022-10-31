Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0BF6613127
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 08:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiJaHXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 03:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJaHXX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 03:23:23 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8DD21D;
        Mon, 31 Oct 2022 00:23:22 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id bg9-20020a05600c3c8900b003bf249616b0so7462962wmb.3;
        Mon, 31 Oct 2022 00:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yrNqh8qXz0mUaZPbmwYZ6bkRSvhVnWT2SUvHKAbyQeI=;
        b=AFji/w6T6HNj1HCOxpfDpkRT8Lz25YKyAgO0065FyY0H598YV7C+NDJrOGnFT4F2vh
         E3p9JyZ9qn1HvUNG/6aeNDCrCSwnNbMIBEhS8dTs0C7SG+WJo4n8LPossfXSHFAhkFjL
         IZ7M0NCuLK/oGiOusrXoBzaESDly96i319+0ts8DvVco3BgxF/zpPUxizSylSlxlrHDI
         fIFusgkHKi3v8UXbHjmOux+9+JhCykb8pvxlfAbPInEwwfuNBHeh8mPCsShza55yX6ic
         67d3y8NCzqEBy/Qdwaj0MxWyWtLLLhZ7Rm7aZzhAKGSF/HrscCdaDqgf/OjE+VayKF0W
         PdGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yrNqh8qXz0mUaZPbmwYZ6bkRSvhVnWT2SUvHKAbyQeI=;
        b=JfBxjLMm2dHdfmK39MCIDEr5FMnod92Ufk6too5OgYtTScEQyx4qgTfkuNaHoygO9V
         wxPH3HjftSwrAGFUEkwzToNwiwwnts4vBGi6rypOXz9k2wdmdFYEtjzrzXlTmN5IEWur
         NDgXx0skzZt4BfzF2dgfDT4hYs3c95uL6cHwl6YJ/iGlAlqGzGjSmQsbCI36xgS4GdUX
         KbkgdyFe3CC4TP6AiE8EEZk60LnTGIgh1wSDQSI6/1JNxt/ni5ca+lTAuM8zYQhJov7g
         Ha6F8/okNCJSYB6oIVFsKhQfzNRdB/hhCZ8kvakyTmA3EgFDUWmU5OF0Ca8CPkyhe06V
         gXEg==
X-Gm-Message-State: ACrzQf2HSsJ5ycsuqwEPRGLce3gLbWAIN0wObI4NUBLR3lovu7r2ax3Q
        oo8zDhRL/EUXTwyMBsgXwZhJLjJh0zdqm29qm1ETvm8xn3HsXQ==
X-Google-Smtp-Source: AMsMyM4MiDDIfVnXw2qqKSi8pzTySlQZnozv6pfsot4x72CD2TTLBfYNW/UJkyJGZ05Om3nKmhE//P3DVs5y0D0JPbM=
X-Received: by 2002:a05:600c:1c04:b0:3cf:5fd2:1f74 with SMTP id
 j4-20020a05600c1c0400b003cf5fd21f74mr9458659wms.45.1667201000765; Mon, 31 Oct
 2022 00:23:20 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Mon, 31 Oct 2022 15:20:07 +0800
Message-ID: <CAPm50aJPpzWz1nnBu6vhcac2kwKq29h-oq7jZtKz23XJ46LW0g@mail.gmail.com>
Subject: [RESEND PATCH v2] kvm: x86: Keep the lock order consistent
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
 arch/x86/kvm/xen.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 2dae413bd62a..766e8a4ca3ea 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -964,8 +964,8 @@ static bool wait_pending_event(struct kvm_vcpu
*vcpu, int nr_ports,
        bool ret = true;
        int idx, i;

-       read_lock_irqsave(&gpc->lock, flags);
        idx = srcu_read_lock(&kvm->srcu);
+       read_lock_irqsave(&gpc->lock, flags);
        if (!kvm_gfn_to_pfn_cache_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
                goto out_rcu;

@@ -986,8 +986,8 @@ static bool wait_pending_event(struct kvm_vcpu
*vcpu, int nr_ports,
        }

  out_rcu:
-       srcu_read_unlock(&kvm->srcu, idx);
        read_unlock_irqrestore(&gpc->lock, flags);
+       srcu_read_unlock(&kvm->srcu, idx);

        return ret;
 }
--
2.27.0
