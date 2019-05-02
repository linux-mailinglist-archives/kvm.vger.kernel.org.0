Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C198121E2
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 20:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfEBSb3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 14:31:29 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:53316 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfEBSb3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 14:31:29 -0400
Received: by mail-pg1-f201.google.com with SMTP id f7so1643283pgi.20
        for <kvm@vger.kernel.org>; Thu, 02 May 2019 11:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=m5JSsxatSQCQI+MuUyatr4tj7uv59zzuOhugSBaN6yI=;
        b=YFYeiXVSCnWmk22yNTIkpGdBrlp7Tp9X5UU2uiuZ4C1eqVLnFnvGeuGm6XxIPq5s0S
         g7+V9UanOCRj1x9d47DOF+rGse3js9Arf4I8qqt6cP5rpc81kodJR82YHV46qamXT9bt
         nNuUao+xcM8scHeXH/U5e9TGJ0R7zlYQ6BjHg1VvEp3d581N7BrD2oRSWB5YGWAtHif+
         OCRyqL3FWUVebOUZSeCZCmR7Jues1BOF+eabuhjsF/n3Xs7P29oN0TOcYtTXvdOmPa5T
         3amKt166WBH/mzXkBmEIGLubK7Ne0SA+LU+NCEiz99BqDt8L4fs5aurnLCtOqV+0td/u
         4o+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=m5JSsxatSQCQI+MuUyatr4tj7uv59zzuOhugSBaN6yI=;
        b=ZF0PNim+v2kowwafF1xm+JXgukaQyCETB83yZB+xIDYcN45IkUNQ2xrUxH1QXQx8iG
         BIAXN6L9nrgKiybx3I8mrqnVpktnV8qBi2uDt7eg+U/qhMrpCsKN9YmaYxqaqBCaZyfe
         WtAXNR5YoNi9nu1sCOJwZc6Zhkrm8Q9sIECNK7gAvzB2sff2ckXuUXZPtKzhWD+E29QW
         olLYxs5d5gmj1x8vw31YsGoBir9W8nhQHZcGJ0sjdsbfq05mxf7TvMqOaibzjd9/kpO8
         AHkHU2dCHAeB4y1wyIS5C7cKb6rWwVbM1ex/zxaid+vEVBJNV3BBswR8METeiCQZeegG
         H3aQ==
X-Gm-Message-State: APjAAAXfDh61YbbY2M3sNKDVTLkK6GiasqEg7bRiT3ZakBCldjiEqCRR
        D+K81XaPDyBoqqk48hA0Mj5Te0jUB/bgvrPS
X-Google-Smtp-Source: APXvYqywx9WB2Xv3CMIWBPaAl3vup69e8gWrmIhnv0nVrSCQHq08ARFHwKGc9j9WhL/eZLnDpRBN5XBxqD6qZ/mL
X-Received: by 2002:a63:2b41:: with SMTP id r62mr5467572pgr.403.1556821888761;
 Thu, 02 May 2019 11:31:28 -0700 (PDT)
Date:   Thu,  2 May 2019 11:31:25 -0700
Message-Id: <20190502183125.257005-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
Subject: [PATCH 1/3] kvm: nVMX: Set nested_run_pending in vmx_set_nested_state
 after checks complete
From:   Aaron Lewis <aaronlewis@google.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        marcorr@google.com, kvm@vger.kernel.org
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

nested_run_pending=1 implies we have successfully entered guest mode.
Move setting from external state in vmx_set_nested_state() until after
all other checks are complete.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/vmx/nested.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6401eb7ef19c..081dea6e211a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5460,9 +5460,6 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
 		return 0;
 
-	vmx->nested.nested_run_pending =
-		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
-
 	if (nested_cpu_has_shadow_vmcs(vmcs12) &&
 	    vmcs12->vmcs_link_pointer != -1ull) {
 		struct vmcs12 *shadow_vmcs12 = get_shadow_vmcs12(vcpu);
@@ -5489,6 +5486,9 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	if (ret)
 		return -EINVAL;
 
+	vmx->nested.nested_run_pending =
+		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
+
 	return 0;
 }
 
-- 
2.21.0.593.g511ec345e18-goog

