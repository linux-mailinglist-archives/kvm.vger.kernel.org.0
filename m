Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D068382E1B
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 16:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237599AbhEQOCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 10:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237575AbhEQOCk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 10:02:40 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533DFC061573;
        Mon, 17 May 2021 07:01:24 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id x188so5003206pfd.7;
        Mon, 17 May 2021 07:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+j3s61DfilBbdVnALbykcBci/7JJ6WTH2JZ9k+XRHnU=;
        b=W7g8/GRnta0CUdCKvH6q3+BTbrfVMZ2Dgypt4bokyz3VI3XNFxaK7jHh176QcdG192
         z2oKm+4fToet79rcJkGjz0pYtRbh/knkVyhmEPVqKM7O1KeszYrDZE3hXr5IjNDabkdC
         RKwHvbSbomti7LdFjiede5FFHojCzgCzNg3Y8kaUapUIZdBF/FNUquvjXmq+jGloCjOV
         QApgTGKYzwpup9TZof5cOvVL3rHknGSNneP4Nn6bgXfDVZG+Za9jdH6tNij21CBJnODH
         nBB3RAZfGNqWKp1LJMz2FFkQK9DR+aKVttks58bLNUHGhw8W59eMbjOf6U9xAF4xFeco
         wrfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+j3s61DfilBbdVnALbykcBci/7JJ6WTH2JZ9k+XRHnU=;
        b=Ap5uzTLojXN8mJzD7YYLAHngVAUu0DGO550BcOemPbKKqu58O4AbewOOQtv2nMDTlu
         auXF3UYt+VDZPXCyw9jNZqwMXAcsmNTuNBZRDhqG79uXDD5yImnfn2EjyxAn6lmFrZ7t
         EF5V/yxk2AqjODcyUsCzo0LrTXtvjNbLV8X+ic9Lod5S7FBq3NCe+nX5+Oh58xdaJgJr
         r0UBWVmaXtW2YEt6b72sALU0NPEqlST762CMtWRZa3mQuJ+byiEH7gYY5kltApEEW7Ge
         kawlDVeXGWjl4DsqmGRnz0qzQPD+ln+zGYCD8ZaQXlYRYRtxzSLQfnNQ0igCBwHxemiI
         q+IA==
X-Gm-Message-State: AOAM532kWOFe9QwL2eyOLtqS/O+8UaAlSjB57is2i1SNMSlGlqNJ0NJe
        BaTlkqT8UA1gBodnZmsRWrjgUgADfmA=
X-Google-Smtp-Source: ABdhPJxrncufwdLBI0i7fwUTKAAG8JEiUuwcsVlhfey6fS/fk/gjmsiPjF6aj48zOouQ/l91x5YSMA==
X-Received: by 2002:a63:6986:: with SMTP id e128mr61397794pgc.16.1621260083531;
        Mon, 17 May 2021 07:01:23 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.61])
        by smtp.googlemail.com with ESMTPSA id k10sm3074229pfu.175.2021.05.17.07.01.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 May 2021 07:01:23 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v3 2/5] KVM: X86: Bail out of direct yield in case of under-committed scenarios
Date:   Mon, 17 May 2021 07:00:25 -0700
Message-Id: <1621260028-6467-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621260028-6467-1-git-send-email-wanpengli@tencent.com>
References: <1621260028-6467-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

In case of under-committed scenarios, vCPU can get scheduling easily,
kvm_vcpu_yield_to add extra overhead, we can observe a lot of race
between vcpu->ready is true and yield fails due to p->state is
TASK_RUNNING. Let's bail out in such scenarios by checking the length
of current cpu runqueue, it can be treated as a hint of under-committed
instead of guarantee of accuracy. The directed_yield_successful/attempted 
ratio can be improved from 50+% to 80+% in the under-committed scenario. 

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v2 -> v3:
 * update patch description
v1 -> v2:
 * move the check after attempted counting
 * update patch description

 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9b6bca616929..dfb7c320581f 100644
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
2.25.1

