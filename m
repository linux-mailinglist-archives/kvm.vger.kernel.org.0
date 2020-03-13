Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8446183FDA
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 04:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgCMDzg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 23:55:36 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41281 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgCMDzg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 23:55:36 -0400
Received: by mail-pf1-f194.google.com with SMTP id z65so4375727pfz.8;
        Thu, 12 Mar 2020 20:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=bFy5BGqYIsvQcigpiL/tId818nkLJ5jSEKOHxLuc+ho=;
        b=QgwHFrUhzfSofz5itbllISH4EH2+ljgNI0x0fmR9HiOZV4NjCYt/vTQbrXlzxCPC5F
         MHh3ReUBkwcO0DLIi/hkvWskaBT5bvfN0E/WlU9vEe5t8/J4R6lEincGPn3vjreyOx72
         WYcWN0GicThi/G8roCHyJxoEnEYyO1OtMIrvN/e7rFDI82u8EzZ5xjV63MdCmmAQZkxM
         C6icuyKtJYwwKZtuNgJJH8vElDDaJdW0iZNKQHNHZ9Uk+ThyQPPnO4fv7dvKblejMiti
         yVge5r/xFHBn+/j5BCaJKdi8LBuytjogaEPlMyqb8Q7Y/KWcK81k523QSQH7wgdQm+cF
         MBlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bFy5BGqYIsvQcigpiL/tId818nkLJ5jSEKOHxLuc+ho=;
        b=lyk4ysriDYHO5uvbczT9vj9mtV20afKO34FMMHBkQneH51zmxkJqoUWC88S3Bb7Clj
         HgihdPI7lcDbnFxSJUxv8A1cpMpQfwU039i9kCOwSfOehMtoEQzY5fDDYZv15uXrWLdS
         qzfh+iV5o4iKzLNQbK1T+hvV0PR4ifsjtj4c03cs8FERNntiNCBbePXL6wwfUAnmok81
         dAoVg4nvrGfnKvp5ScFvTsNUoEaMXgOGkAk/H2zFru9+2z875ea8nQcouL/BVmBJO2Xh
         zwWTPkv8/OWkcnT3hP8A8t+BZy9bLTvnm2nKW50rZ75ueM19+Nh4pnSLqSkZlLZ8ROjj
         D31w==
X-Gm-Message-State: ANhLgQ1R33xTGn+S6wAstaNX6f0BMJehSN2XVPgWOkzc+IqdLs47Toak
        uhRBO8icDpYD03wo3qnSMlc7ndZY
X-Google-Smtp-Source: ADFU+vvEtxyIaqDqKWJgBRMV5ZSjK/QVfAp+w8TpRpMiFUcvCI6x5N0FZQO4poCsbcMd98aWIX1BrQ==
X-Received: by 2002:aa7:850b:: with SMTP id v11mr8012798pfn.64.1584071734727;
        Thu, 12 Mar 2020 20:55:34 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id y9sm19625326pgo.80.2020.03.12.20.55.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 12 Mar 2020 20:55:34 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2] KVM: VMX: Micro-optimize vmexit time when not exposing PMU
Date:   Fri, 13 Mar 2020 11:55:18 +0800
Message-Id: <1584071718-17163-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

PMU is not exposed to guest by most of products from cloud providers since the 
bad performance of PMU emulation and security concern. However, it calls 
perf_guest_switch_get_msrs() and clear_atomic_switch_msr() unconditionally 
even if PMU is not exposed to the guest before each vmentry. 

~2% vmexit time reduced can be observed by kvm-unit-tests/vmexit.flat on my 
SKX server.

Before patch:
vmcall 1559

After patch:
vmcall 1529

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * move the check before atomic_switch_perf_msrs

 arch/x86/kvm/vmx/vmx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 40b1e61..b20423c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6567,7 +6567,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	pt_guest_enter(vmx);
 
-	atomic_switch_perf_msrs(vmx);
+	if (vcpu_to_pmu(vcpu)->version)
+		atomic_switch_perf_msrs(vmx);
 	atomic_switch_umwait_control_msr(vmx);
 
 	if (enable_preemption_timer)
-- 
2.7.4

