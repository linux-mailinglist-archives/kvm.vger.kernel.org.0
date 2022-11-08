Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8586207CC
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 04:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbiKHDvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 22:51:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233158AbiKHDvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 22:51:10 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479922D1F7;
        Mon,  7 Nov 2022 19:51:07 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id cl5so18969466wrb.9;
        Mon, 07 Nov 2022 19:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=d7AZ9fnN2tUylyfRKzR6a2/M1Lj+kB6r4vHswVHye90=;
        b=iRI0RtEuyPEL9brryyCqDrPH0t1h4fEn+uW3ieYN0BYFRiVNGdVLnobfrepwYAxiQi
         OcTjcSv7SrzEsCgjUaM8WGR8UpDHb89UAyquul3rqFSm9FpLlSGH/vQdbXNDJbhrQHsP
         DPSQ19wHgpQVikcLwIGHk5eXRMWp2wFe1yF3p2/UU0oTG+854yNSqMMb8Hvat/PL1XNS
         NuxJ15B4M7+NjcxTFsT8nGAC9OLLj+1wGJB/HdPJ2LQGsifme/Dm6YdqJLvaz9VyDaS4
         TDYOWV1/Oy2eTZQaDJ40uuGQwSMZgBbJGebFof6tWmdg8A1aYMGBgBoLF0hD3hzJZMVA
         Np0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d7AZ9fnN2tUylyfRKzR6a2/M1Lj+kB6r4vHswVHye90=;
        b=F3MGCRtZSDKAvgV4odWTUIGDSBIarqhI+Cv22d3IBQyvOATA0x8IFg4HANSobxteGA
         KAF31qpwUg/FsvmKR/ck0j7ER4eqHmxf/btPD5lIBKii5Sn5ojIFLlQYNEMwMBlyEGOf
         FxeykWGBOjKnWRMfL6QMnV1kc80g/w66YAFBl7p1W2pKvxSH92ih0Yh3k+50zSf63bAx
         yaJEA3HDhMQiqy6jRvIzg8YVMzDu9JSIaOgJ4E59o9w5ffLvPNVkdFqen65M0SHgrqex
         jeDk6r/WxNLEISHZfHWiYhuyVq5wnjRD/XEa9KgIhLnCdaYwvfGn3LKpwti2xAqJvpkI
         Bpdw==
X-Gm-Message-State: ACrzQf021Kkjc8Z/3fv1yAYU3JEo3MBT66Bis5/e7rnaAQBGaHIEQ7Eb
        jvHNCeOvA5lGyvp1O6hgW2bONFTf8fv1LSZVY3s=
X-Google-Smtp-Source: AMsMyM79UydLpAGXMznv57REslScMwtPqZFPrZHQzooK8DtBHjHYLARnYUiAL6Eaev/mWtyMXbyR+qxy6LMn2K+lQNg=
X-Received: by 2002:adf:e385:0:b0:236:91a6:bd1b with SMTP id
 e5-20020adfe385000000b0023691a6bd1bmr33863115wrm.278.1667879465744; Mon, 07
 Nov 2022 19:51:05 -0800 (PST)
MIME-Version: 1.0
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Tue, 8 Nov 2022 11:50:54 +0800
Message-ID: <CAPm50a++Cb=QfnjMZ2EnCj-Sb9Y4UM-=uOEtHAcjnNLCAAf-dQ@mail.gmail.com>
Subject: [PATCH v3] KVM: x86: Keep the lock order consistent
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, inux-kernel@vger.kernel.org,
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
Reviewed-by: Sean Christopherson <seanjc@google.com>
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
