Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6AC5F7B1E
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 18:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiJGQAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 12:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiJGQAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 12:00:19 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94E01E3E2;
        Fri,  7 Oct 2022 09:00:17 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id n12so7916234wrp.10;
        Fri, 07 Oct 2022 09:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eWhe/luQNtiek+MCh1Ji3sftnJRDLuDyTuqEnw5KB1Y=;
        b=kYvkpJEZGPd8+VTgKqJW75WmXsItnXm/yLExbY4PKAUs3dQ83nWCE4EuMUIDorswrL
         6HzflzGb/0Qw34TD0pf6aOVhFxAOqdbtNyypUHj3eXUqtHL3NLcdohMk9/agDFkYS3Sr
         p6RpOktsZPhVYnwmbP64rfzrmTcS83RTZpEo5iqIHr1pD+3Hs58iH58bLwqURLNzdKf1
         NgVUYkDlAK2tp/344Fg1k12xk8zCVvWuaKNzuFV8Vanh+8RWalsRcoh5uF7YMp1kUzcb
         zsZzKmJM5VgY8xKqyNZV4pAxW7anfXdk7b0FzOqKXUoXNMGu9k48Tmt3kIip8VztOaHY
         igfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eWhe/luQNtiek+MCh1Ji3sftnJRDLuDyTuqEnw5KB1Y=;
        b=FhjX1EcbQTj6BdK2V9TD0wSR9frZzuy3DqIaqKWsTJcJgLVz52Ff4X457uo06HBN/W
         usMF0FYUnYwwjUXGsJvj2Lgu6sSPKFl7vEPd/yjiAf6ThPpak1mWXb9qfxkag8oW74eO
         K0xTeHBudzCzpDe24V4vuQKfXCNMKV9UYfV+yvjSNgkb6gNA29De2DvJquGU2cyERtZc
         lZ+gg2O7u8UBFR5fn7SUhtJ8DT6fDrZYytPh2sVzyNVQqT+/7HeOsQ+5dgyp4KVcOzts
         pkzA/34cIPyFlpFhfygGltPAo8c0ha3VIx33gwwzFp87vHHiybCmpQUx64H4LIGnBT+1
         q2CA==
X-Gm-Message-State: ACrzQf1JdNcTEir9g/i7iO9F/jdE64tIpIcN72QQqyCI/rZCDPE0r59y
        dOQRE8R2+0YIzAgzavm61+U65fXsnByYmdNge52SA3g0EGUdHw==
X-Google-Smtp-Source: AMsMyM6dnTT8G973h2mlbTXdQ3nGpdw/4AtFigxWff88BROQL/fagBC2j9bcIYEMEMUVo4JAoHPcToKjR0Up+fNSXpk=
X-Received: by 2002:a5d:59a7:0:b0:22a:47e3:a1b with SMTP id
 p7-20020a5d59a7000000b0022a47e30a1bmr3647629wrr.319.1665158416381; Fri, 07
 Oct 2022 09:00:16 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Fri, 7 Oct 2022 23:56:47 +0800
Message-ID: <CAPm50a+gcug5XOsg_Z=7R+3j+VUxHMrzyGNbps7-okR625KB_w@mail.gmail.com>
Subject: [PATCH] kvm: x86: Keep the lock order consistent
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

srcu read side in critical section may sleep, so it should precede
the read lock, while other paths such as kvm_xen_set_evtchn_fast
execute srcu_read_lock before acquiring the read lock.

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
