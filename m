Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B323770EA
	for <lists+kvm@lfdr.de>; Sat,  8 May 2021 11:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbhEHJdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 May 2021 05:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbhEHJdG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 May 2021 05:33:06 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F16DC061574;
        Sat,  8 May 2021 02:32:05 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id a5so2578352pfa.11;
        Sat, 08 May 2021 02:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/AlNh+fXozUg9qKAtn5bD6eiY6c6BSYqdB15v+Gk2f0=;
        b=NCbVoT0Ho0gKDUXeKOE72t2xlQkggYC6StWQDCxhohmv0FUIh+QIkQv/B8I52PN1Ko
         wSgxuJDz3RAuf71FFpOVgU3mDk0fwm/+vGUYMrdk+E9uNSqFhIsYo3OByEGN4g5/8NUY
         2CkfLfmWG+dKOvpoic43mic8fbCYHfgPpXTZFrPWZhuOPTkC6PAxupfKSoW5Km+/ezFq
         O51f3iU7ekx2n4VFoXlk578ru8nrUrDQ/jUS3ksln+uuJwUUJc493tp62+/i1hPYkt/Q
         gs6xEByMzbooVpiEK7jjsdFk20VDWzokGeOOql9sDJwyqXqTupPydwks3oq2Fqh6Cosr
         QVCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/AlNh+fXozUg9qKAtn5bD6eiY6c6BSYqdB15v+Gk2f0=;
        b=YOxAduqPWmdwGOYS4EP/tRb9mvR7oy4WXQaqwyLVet0lo5UOX2QLA2T3yRBqcN656t
         1LcmAQ9MZVpPdQL47oYemBqrUs+gra0GIe48snkfS8PGjYlS3bCl4AsxVqgr/Hs2dPol
         n9K6ZENkffqF+BSsMisrSn9RY6vYhZEugULJ4CbtTZGUUF5EtA7CI6GLy2ZbhtaexfZ7
         qzz4Koiyk8OkJGRvFcpNWYKbUQ3dBKJdweESrnx79aMkWqJp9Hy9nyng9RlvNrDKof4n
         sgfZUG/US0+shRabKuDYZDTU47R1Ripa+dGiZmEGy13CZY+p2qhBhf4FZf/YAP553ViL
         dkkQ==
X-Gm-Message-State: AOAM530fCSTNK0J5Xvbx93ltk4xVGgg0UEa/4ya4CoOhXzBA8T2OliYB
        IpXTHdzfBIuqZTPu9yLXZcRElfB+dqM=
X-Google-Smtp-Source: ABdhPJwMe0nhLb9BY8hozBgV7qkeOlTJPC9ZbtPcg32B9HlEX3vFEMzSTTfgFl7CwwQdW5hD5fWtdg==
X-Received: by 2002:a63:dc57:: with SMTP id f23mr14237716pgj.294.1620466324753;
        Sat, 08 May 2021 02:32:04 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id f3sm40437765pjo.3.2021.05.08.02.32.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 May 2021 02:32:04 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paul Mackerras <paulus@ozlabs.org>
Subject: [PATCH 1/3] KVM: PPC: Book3S HV: exit halt polling on need_resched() as well
Date:   Sat,  8 May 2021 17:31:48 +0800
Message-Id: <1620466310-8428-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Inspired by commit 262de4102c7bb8 (kvm: exit halt polling on need_resched() 
as well), due to PPC implements an arch specific halt polling logic, we should 
add the need_resched() checking there as well.

Cc: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/powerpc/kvm/book3s_hv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 28a80d2..6199397 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3936,7 +3936,8 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 				break;
 			}
 			cur = ktime_get();
-		} while (single_task_running() && ktime_before(cur, stop));
+		} while (single_task_running() && !need_resched() &&
+			 ktime_before(cur, stop));
 
 		spin_lock(&vc->lock);
 		vc->vcore_state = VCORE_INACTIVE;
-- 
2.7.4

