Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7858C1793A
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 14:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbfEHMQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 08:16:45 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39679 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728031AbfEHMQp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 08:16:45 -0400
Received: by mail-wm1-f67.google.com with SMTP id n25so2970944wmk.4;
        Wed, 08 May 2019 05:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=+uSM2xfSQ11lGMP7BGRPKgpGed0cJqoT69USPPkz3jU=;
        b=Ks8R50PmLH8B3wYlvGWd9xR78gXMG+K3RiXZmZt7IJD12HkAxPr+weWGElt2Pq+Oiq
         6EHpYkYVNUldyBbIZgLFhgOmtmS1lGe+c9GmDXIkor1o/YKw6xVHI8Sge4HeT7Tz/rV3
         pR28gQOzdSUa9+yUpzqGx6q6PlCNGjIjixJDSaBoHnvNNdkAwq23nu7EFHBSF4Eha/Eb
         IvR/KLR1mfqxUM1oXCNLB4BPdN8PEucgB6GlmYyzZo6X/gWWn5S8FRxJ0Kc8QQ+cNbku
         HRusIXxlJcTdO5OS/y1URHtWkC0tJ9KOPZZ1vgfTkHgmlJg8TBG1ZF7Avp9fuvLUVySE
         BHWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=+uSM2xfSQ11lGMP7BGRPKgpGed0cJqoT69USPPkz3jU=;
        b=mgLxjNRLmAF9eLTsXYWtPmArTk8zMLzPQQj2qxmf1KUbx1/ApDSOeoLZY3RG3fgHmo
         Ucc+tl25krPFhrQv4J/fpJRBMdCX9b75V4zLDys+puU3V5q/k5XTjrebEdMXJSzZZ10o
         8zTP1UJcWN3uCGA4qbjrOZVs+SIy3oE5Rr2+L/yItDeuy5NxHtKIu8uQ3liqtYzLCBu2
         Yky6Pvdiq6FnOS6/taZYKL/4XZ+QdZXkQnhYhBgWJ+MSdOGA8DlAaDj7Uf/Y/PJJXhM0
         IH3lPvOZSq4v4owurwjBLSOnOt11RuLT2JcdmSqJU4Bo4uqXn5qU+FSBGaDtBa7FMKEn
         NWwg==
X-Gm-Message-State: APjAAAUDsgdHmcja567XTzLJ+AXIHROZYsfSsAxl1rvQyHlNMhe1DUX3
        Bbu4IEIuliICwMLUwxS86ZuVB7Id
X-Google-Smtp-Source: APXvYqxQtVrDyVQTPETlefWXQ8Z0BnDc1dfeAnKn9pDyxLpMFspzLm3H8P5D9WhnPS9zWn6dt551/A==
X-Received: by 2002:a1c:c7c8:: with SMTP id x191mr2860289wmf.146.1557317803365;
        Wed, 08 May 2019 05:16:43 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id p24sm1509368wma.18.2019.05.08.05.16.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 05:16:42 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Subject: [PATCH v2] kvm: nVMX: Set nested_run_pending in vmx_set_nested_state after checks complete
Date:   Wed,  8 May 2019 14:16:39 +0200
Message-Id: <1557317799-39866-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Aaron Lewis <aaronlewis@google.com>

nested_run_pending=1 implies we have successfully entered guest mode.
Move setting from external state in vmx_set_nested_state() until after
all other checks are complete.

Based on a patch by Aaron Lewis.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index cec77f30f61c..e58caff92694 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5420,9 +5420,6 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
 		return 0;
 
-	vmx->nested.nested_run_pending =
-		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
-
 	if (nested_cpu_has_shadow_vmcs(vmcs12) &&
 	    vmcs12->vmcs_link_pointer != -1ull) {
 		struct vmcs12 *shadow_vmcs12 = get_shadow_vmcs12(vcpu);
@@ -5446,9 +5443,14 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	vmx->nested.dirty_vmcs12 = true;
+	vmx->nested.nested_run_pending =
+		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
+
 	ret = nested_vmx_enter_non_root_mode(vcpu, false);
-	if (ret)
+	if (ret) {
+		vmx->nested.nested_run_pending = 0;
 		return -EINVAL;
+	}
 
 	return 0;
 }
-- 
1.8.3.1

