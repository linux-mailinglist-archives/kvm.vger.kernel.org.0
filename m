Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1FA37F110
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 04:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhEMCBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 22:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhEMCBI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 22:01:08 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EABC061574;
        Wed, 12 May 2021 18:59:57 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id m124so19808878pgm.13;
        Wed, 12 May 2021 18:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=VDsDy5xQWwksvhm+nuIt7Vlx0l+g7cwsVeWeOmz1eWU=;
        b=AFzz3dAqLjeJDZSjvZkjVKkz7cqh6EXhlp7d/z3feu6puiyVz9+I6FrEYQcKmVlhXb
         LRnTmycZNhPJRT3FBvMzAYBzIv0WzeXDfIOLDWoztB7Vtsxr2m1lz/5NA0deIhIYe59q
         B2L3ktSnNUrEdeNtvD4tOgjS7uhL9tdi2rpqiOUrN1dFQpgausYfGYpR82JLJykCjTPj
         icREzk1KSRZ5Zgc+pfITx5KrBoNB4ekENbF8KJUNtMKNiBBx4Cl01u0aUMAn7Pw1Aith
         LCbd4/KIrrvhGnSlrDT4NFMPr9jrxj7Mo6SPVDFUQeJzK7UEPeDAUci/hHNsXT1mHCPX
         mcjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VDsDy5xQWwksvhm+nuIt7Vlx0l+g7cwsVeWeOmz1eWU=;
        b=Ky6C50Dut8bRIWETMGt2pe3K8VsP4zT/XUcfVprGhBJyrIl7ZxC/oLlQcYB58fQiiJ
         Wu2AoAoQ1eCV5kkDHq6vTW8pMMCY/pXvTyB8EepL/Eqb/R1og0I6qeMHUZ85V7Mhp2lA
         KrM1SH2Qzjp/YjsVyku0DNRHnDEqoXxJDnLyqe6rN+1Qu8QGnQZN+LOZF04rcpamNmCp
         wp564HjajE6RN9O3wSl4Vnkd4tppIqVTyO2gLgOLsU7zJip5MqE6gVo4xIQFAu2lrlsJ
         T6FFRfOYWPi1ix3IjOeFXaumtLadH6RpTSdPrr8NoC7xuKTuRfYVDO/TFF+qB2X9p+SF
         gdLw==
X-Gm-Message-State: AOAM531aZJ7LnQFOfuDz+q4kZfCvQm/UrYTjlZFkp265j2vNTNzJUJ9m
        mxMkw/yidJq01W3DWpoQ28gG5oOX/EE=
X-Google-Smtp-Source: ABdhPJxXq3Es3YDoK2u5q63iVXU0bF4SUyU/vyJg/b0l7HEC6hCw9fw9KG0YxOyH07TPX2XYk4CeQw==
X-Received: by 2002:aa7:95b6:0:b029:28e:aa31:dd3c with SMTP id a22-20020aa795b60000b029028eaa31dd3cmr38528069pfk.43.1620871197231;
        Wed, 12 May 2021 18:59:57 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id w123sm812742pfw.151.2021.05.12.18.59.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 May 2021 18:59:56 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 2/4] KVM: X86: Bail out of direct yield in case of under-comitted scenarios
Date:   Thu, 13 May 2021 09:59:47 +0800
Message-Id: <1620871189-4763-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

In case of under-comitted scenarios, vCPU can get scheduling easily, 
kvm_vcpu_yield_to adds extra overhead, we can observe a lot of race 
between vcpu->ready is true and yield fails due to p->state is 
TASK_RUNNING. Let's bail out in such scenarios by checking the length 
of current cpu runqueue, it can be treated as a hint of under-committed 
instead of guarantee of accuracy.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * move the check after attempted counting
 * update patch description

 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9b6bca6..dfb7c32 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8360,6 +8360,9 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 
 	vcpu->stat.directed_yield_attempted++;
 
+	if (single_task_running())
+		goto no_yield;
+
 	rcu_read_lock();
 	map = rcu_dereference(vcpu->kvm->arch.apic_map);
 
-- 
2.7.4

