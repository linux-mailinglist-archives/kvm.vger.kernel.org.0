Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 124BC4482B
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732657AbfFMRFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:05:05 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39122 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404646AbfFMREN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:04:13 -0400
Received: by mail-wm1-f65.google.com with SMTP id z23so10884699wma.4;
        Thu, 13 Jun 2019 10:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jaUW90F2XcvyyNOiBDWBIl+rBU7N3jgUCLQ74JA8HY8=;
        b=pfgo5FLepeaIJD+KZt2q+PesNkh2w0Am0wcy+jDy1AhaUFwS91I267moEWF7VLjNpp
         NbLuLAPO0cu7OEm23KjEHa8iNeTbi9q/KQTnrWVh4BGjl535OF1yAsjVxPKelDNnnKd/
         7imB/0riKzQAPOwtRr/QN7cBevz9I2lANuxwYoEZxNFvW1F9OS/9fmQHFL4V4s08PtI1
         YMqqM97MIIsQ23eCh7ZkNH0v8nF3o5II/8IBPNweOar3BtIvCCMv+zeCkKtaegqp5Rv/
         lB6UUxy4lxo1YyBWJsQM4NlGjb0CLyjupXaPV4PwxLnsfA1XZP7xrBBMgglW3RlkndoS
         HJ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=jaUW90F2XcvyyNOiBDWBIl+rBU7N3jgUCLQ74JA8HY8=;
        b=fDmqdVnwNCn7xXDLce+BOn3KsdYMOus1rIUYpP0Jppq6QBZKrdV/H9N0wU26Nx9+Ez
         7R2x0XDuTBPleF5x7usxp7a2+oZ93jX9vGcwnhUMS7lTJuKsgRYtRxgICyw+NwpbHDy8
         NN6SO5QgiWZ9gp6bXfR8bvvCkF10+GzJzPOssbi+b3ncN9Qa5AerkSH7UvYfgnfaRo98
         KCTGwXlm/OJttMmYVXOndmHjur1q8xQmC+x47xrhZ10uCBuVZkdqs/TKVJ/rokCTr9w6
         5WPpbrySQ53AVUzd9Y3JYNrbtk9aFl6xNaNlceO0mdaKyQUfHOQBnzUa2yWaW23sj4/4
         apRw==
X-Gm-Message-State: APjAAAVQPj0xmY0pnrwRd92V7nAc4/z/jeE1MPTCbAIC72EqxEs413Rg
        URG/y9W8b1bJ3NjfHW2MQVlZHwBN
X-Google-Smtp-Source: APXvYqzBVGU7YzwgN3HFU2LWObiQkan8zTDrGSZIbUFkf6vrphKatGjIZFT/5zjdkYFTgU0Ulph9rg==
X-Received: by 2002:a1c:be0a:: with SMTP id o10mr4531286wmf.91.1560445451449;
        Thu, 13 Jun 2019 10:04:11 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.04.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:04:10 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 39/43] KVM: nVMX: Preserve last USE_MSR_BITMAPS when preparing vmcs02
Date:   Thu, 13 Jun 2019 19:03:25 +0200
Message-Id: <1560445409-17363-40-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

KVM dynamically toggles the CPU_BASED_USE_MSR_BITMAPS execution control
for nested guests based on whether or not both L0 and L1 want to pass
through the same MSRs to L2.  Preserve the last used value from vmcs02
so as to avoid multiple VMWRITEs to (re)set/(re)clear the bit on nested
VM-Entry.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 32bcf777576c..14a8cfade50f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2047,8 +2047,18 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	 * A vmexit (to either L1 hypervisor or L0 userspace) is always needed
 	 * for I/O port accesses.
 	 */
-	exec_control &= ~CPU_BASED_USE_IO_BITMAPS;
 	exec_control |= CPU_BASED_UNCOND_IO_EXITING;
+	exec_control &= ~CPU_BASED_USE_IO_BITMAPS;
+
+	/*
+	 * This bit will be computed in nested_get_vmcs12_pages, because
+	 * we do not have access to L1's MSR bitmap yet.  For now, keep
+	 * the same bit as before, hoping to avoid multiple VMWRITEs that
+	 * only set/clear this bit.
+	 */
+	exec_control &= ~CPU_BASED_USE_MSR_BITMAPS;
+	exec_control |= exec_controls_get(vmx) & CPU_BASED_USE_MSR_BITMAPS;
+
 	exec_controls_set(vmx, exec_control);
 
 	/*
-- 
1.8.3.1


