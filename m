Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508B738F871
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 05:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbhEYDFM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 23:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhEYDFL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 23:05:11 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1B9C061574;
        Mon, 24 May 2021 20:03:41 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id t193so21590819pgb.4;
        Mon, 24 May 2021 20:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=th0hO51xkkKq/t6d5uQ7ST6KQWCdJeF/YWkbLeTlsMQ=;
        b=oXkCJZmK7YDZdH3kbjADAbiU6xMfWRM7txtP0+FnLgWoisTyYofcNxJWcUuEc+iUbj
         l4+w9moNcxtOh4x9FVjvBrxK/uK7RMJoJmaf6K8UWylW1GCt6Xx+SUVMyGQFispcAxA/
         Zqy4oULaPz9ZS1Xy7DeiQaNApGn3b1yk2mo1fqpSXEwj4CV6JzRudejASZSrP+W7ZNJB
         NZ1ROubJP7qiEJzc+XanG8ATxUW15AeLpT31aFcpIb/P/GNZZvaADhNjodjj/wPRvF55
         r+3PxhjC4eEKR1iIKzoF19e5qKRxbiHdTLzSeoN7aiiHr+xTsyey4c/N6i9pxZ1g5yeC
         sBkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=th0hO51xkkKq/t6d5uQ7ST6KQWCdJeF/YWkbLeTlsMQ=;
        b=QHhxDN1v37pa9ipWZsl7MJbsmv06UsT/mzf4jOGnoNvzjoKmiR+B/Pwq/D+OYaBmmb
         PVDEHToc6u1KPU1384fZDkVbTRcz8Z3T0PpMWj2Ei5WP61VHvCgf3+NrTec6OrkdCZw7
         Mp3lZV7jC5sEcSuOT7nREvIgUXIhvf2ryjfC9DtUPSJsdl2Kwec8QovAKig6gj3Gr56D
         THdNJbjC6uPwT1L94IIyeXeJAG9GApkQ+diFs0C1LK1Hs7x0N5Hi4Hf8l9JhMMGvABtB
         AXBk/FqN3V6ojtKe+eCm53TUbL6c4iiGebgOEz4sTq+9yv7o677OMhHSVGbcyJIK19uB
         d9eA==
X-Gm-Message-State: AOAM530xs0vylXYvMoxn3lqSrpRQd5gUetAOBel8tF0Bnk973cEVqr7i
        H7SMs0+Uvkczt1/FMAzVHYkHQOJUQPU=
X-Google-Smtp-Source: ABdhPJz2SC9zFEh96aoyYZTXx+YAmOIV/m9ECRaadpA9Gbekovi/WDSGkA+eX8gLdtjYaMAq6DuipA==
X-Received: by 2002:a63:1d09:: with SMTP id d9mr16608036pgd.302.1621911820997;
        Mon, 24 May 2021 20:03:40 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.53])
        by smtp.googlemail.com with ESMTPSA id x23sm637521pje.52.2021.05.24.20.03.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 May 2021 20:03:40 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: Fix ERROR: modpost: .kvm_vcpu_can_poll undefined!
Date:   Mon, 24 May 2021 20:02:50 -0700
Message-Id: <1621911770-11744-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Export kvm_vcpu_can_poll to fix ERROR: modpost: .kvm_vcpu_can_poll undefined!

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 virt/kvm/kvm_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 62522c1..8eaec42 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2949,6 +2949,7 @@ bool kvm_vcpu_can_poll(ktime_t cur, ktime_t stop)
 {
 	return single_task_running() && !need_resched() && ktime_before(cur, stop);
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_can_poll);
 
 /*
  * The vCPU has executed a HLT instruction with in-kernel mode enabled.
-- 
2.7.4

