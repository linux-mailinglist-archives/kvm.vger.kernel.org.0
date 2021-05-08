Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1473770EE
	for <lists+kvm@lfdr.de>; Sat,  8 May 2021 11:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhEHJdQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 May 2021 05:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbhEHJdN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 May 2021 05:33:13 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A34C061574;
        Sat,  8 May 2021 02:32:08 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id v13so6455662ple.9;
        Sat, 08 May 2021 02:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VCwCRDPBnnn7qNUo5vSlKxWUsTUAH/2lmhRqXohoBWQ=;
        b=U1kzLI99KF6933JgzvSZO63mcvGR5o2wyX8353sk/s67IUbcMyJ7kkQnJ0bMgnhueP
         4GoYk7no/XGcFOo3PmizqCkxIkr4LJ9ZcxkywTOTDVayUiSWNi96AAIBpbFZTeiLzH8n
         P0TTGPIdjAyKWzl6oIhA5WeoRfLhuCAod3KgVhHu7wNDtJSjYbap9HkYWkEodUL26mvr
         e/yaU0xypoTGxd/bFo7JAO6lJOqUEk1xcqi43sDvkgdBqRovCuNgXlyS93zxPCmOThrs
         zD+idL9m3v3/XvlOIamH12UEW6Gh2Pwz7T0RDueBwMe01OlDSO/YHL3bv9Kv5h1cqEej
         nfHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VCwCRDPBnnn7qNUo5vSlKxWUsTUAH/2lmhRqXohoBWQ=;
        b=O/grl6bFVPP+DczOM9uIh1ZTDEI2VA56sjcVDtYnUewVf15NViSBpS9F+T+SfKvBag
         ZCPftTpFeVUD2H/h80BU2KhZr1TpKY0Fh8y0FBHEaQL7liwgoAsLrE0YjZ/iOv01/xQm
         RzU9A1ZLWabPPDybKHSVs+wwkjV/NA+5JjWisI1XSpL0zsdWA+buEY7fqby9BbSZYOXR
         E4K2vrfuJb+DlBgAmlpL23xlsg0+ABE3dPwVFWgGTuEKXlqkoFl2/FVc2+n1wOnnJKIG
         HGgE4Joj/wb+nhNFR23mOVIC1qLcGCx8wUVaOZKwKAGIvbxYTqtZfgl4J4/j9Vu04lwm
         9Ugw==
X-Gm-Message-State: AOAM530hFuy2sJ/aP9oHjqe4XYMXiLeMr5jR9vOEs0Pz2NBRnLBREoaJ
        jeRDwadpVB7QwZciHms+jyO38rnqfQQ=
X-Google-Smtp-Source: ABdhPJxxb1/hNde2lEJzxBj+zIr/lFBB813z09ATk4UL3888M0n3XvTRwOV0m/VLp1syeMHd4xmVWw==
X-Received: by 2002:a17:902:9a01:b029:ef:11d:4b77 with SMTP id v1-20020a1709029a01b02900ef011d4b77mr10680897plp.51.1620466327228;
        Sat, 08 May 2021 02:32:07 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id f3sm40437765pjo.3.2021.05.08.02.32.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 May 2021 02:32:06 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 2/3] KVM: X86: Bail out of direct yield in case of undercomitted scenarios
Date:   Sat,  8 May 2021 17:31:49 +0800
Message-Id: <1620466310-8428-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1620466310-8428-1-git-send-email-wanpengli@tencent.com>
References: <1620466310-8428-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

In case of undercomitted scenarios, vCPU can get scheduling easily, 
kvm_vcpu_yield_to adds extra overhead, we can observe a lot of race 
between vcpu->ready is true and yield fails due to p->state is 
TASK_RUNNING. Let's bail out is such scenarios by checking the length 
of current cpu runqueue.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5bd550e..c0244a6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8358,6 +8358,9 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 	struct kvm_vcpu *target = NULL;
 	struct kvm_apic_map *map;
 
+	if (single_task_running())
+		goto no_yield;
+
 	vcpu->stat.directed_yield_attempted++;
 
 	rcu_read_lock();
-- 
2.7.4

