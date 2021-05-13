Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBF037F10C
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 03:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhEMB7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 21:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhEMB71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 21:59:27 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86107C061574;
        Wed, 12 May 2021 18:58:17 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id c13so6829360pfv.4;
        Wed, 12 May 2021 18:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=s6yds0eAnM4G0Wdu571RvhPi3TKjI+npGap0XFILkfE=;
        b=klaPh4iM4ryJKcK4ak5Gfiffhss4QGvganMQRvxA3qZPdfc3DZscvNZalHS2iYY7l7
         eh7k3GoMAAuKHe4bKB7A2eIgoI5YkAhZbeevFgMnQzAniRwfzgmKbrXup6XMFcuJXzuH
         OTlFUIcDR5se3vDF+RbYMJYyBuY5lpPA70fczLto5JJvhn+VQnWUDFXrYzSWT9dJ2oC+
         bYVn24RIOEWg2b48Qn3ScdJAyLMfMnOOUtnHVJqAmMP/lqcWIHUXK1eQJNwma3vxR9FZ
         cSwcvzxAwEXITjApPsOQginDTlbi1fzYtvh0sB9yAoez58SOwXoF5cuRkZ6ZGJQIblYE
         Qxbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=s6yds0eAnM4G0Wdu571RvhPi3TKjI+npGap0XFILkfE=;
        b=dpfba45GmFGAh0uE1qSEakZRVq9vIFCvbZz3v4rq8I/ZyRQ/xRblrR5pdf6hHgwdh3
         5blhSSVvu1drDNzHFIpPl4XvUzA7uctGho9Ow6Mxzwr/cgZhnF/y/ffqqWGpCszga/XN
         /wHU5x2LuuDVyeiD4AdL12xfIDoXKYlFZtmmwz4bpvWYVZnW/+Rxe/F/Q4grxOwfDOUf
         80CAJHgBWrYP10Q8uy9JE9GqwA6kcAUKe8VS+u2OEM/TzoJOX0yxBvYnrF6rQ/jYYnld
         /1iWyop8ffVGau9hQIOBPk84fHEZgQ6aZd+Q5sfuT3x6M7c3GElQKRS6f3bvSAwePVT4
         5m1A==
X-Gm-Message-State: AOAM533Brl+1339A0uPd18e5vaL0d4PJGtRUCwxjA61qyDSuvK+zHWIr
        bvwhQh9/FAj6clDw5ohADCpvWNfiJoo=
X-Google-Smtp-Source: ABdhPJwlNz0fWh1ClQWl8HOGpto3Gg0232jmHcD6gUChaiSQ/a7krLx/KvJDva1shE16JBeioyGFvQ==
X-Received: by 2002:a17:90a:fd95:: with SMTP id cx21mr1777447pjb.137.1620871096858;
        Wed, 12 May 2021 18:58:16 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id b7sm799560pjq.36.2021.05.12.18.58.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 May 2021 18:58:15 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Segall <bsegall@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        David Matlack <dmatlack@google.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH v2 1/4] KVM: PPC: Book3S HV: exit halt polling on need_resched() as well
Date:   Thu, 13 May 2021 09:58:04 +0800
Message-Id: <1620871084-4639-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Inspired by commit 262de4102c7bb8 (kvm: exit halt polling on need_resched()
as well), CFS_BANDWIDTH throttling will use resched_task() when there is just
one task to get the task to block. It was likely allowing VMs to overrun their
quota when halt polling. Due to PPC implements an arch specific halt polling
logic, we should add the need_resched() checking there as well.

Cc: Ben Segall <bsegall@google.com>
Cc: Venkatesh Srinivas <venkateshs@chromium.org>
Cc: Jim Mattson <jmattson@google.com> 
Cc: David Matlack <dmatlack@google.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * update patch description

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

