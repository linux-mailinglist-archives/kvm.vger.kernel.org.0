Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49677268AB4
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 14:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgINMHH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 08:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgINMEE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 08:04:04 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E34EC061788;
        Mon, 14 Sep 2020 04:53:35 -0700 (PDT)
Received: from cap.home.8bytes.org (p549add56.dip0.t-ipconnect.de [84.154.221.86])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 4F1801DB;
        Mon, 14 Sep 2020 13:51:30 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH -tip] KVM: SVM: nested: Initialize on-stack pointers in svm_set_nested_state()
Date:   Mon, 14 Sep 2020 13:51:29 +0200
Message-Id: <20200914115129.10352-1-joro@8bytes.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The save and ctl pointers need to be initialized to NULL because there
is a way through the function in which there is no memory allocated
for the pointers but where they are freed in the end.

This involves the 'goto out_set_gif' before the memory for the
pointers is allocated.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 6ccbd29ade0d ("KVM: SVM: nested: Don't allocate VMCB structures on stack")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kvm/svm/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 598a769f1961..72a3d6f87107 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1062,8 +1062,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb __user *user_vmcb = (struct vmcb __user *)
 		&user_kvm_nested_state->data.svm[0];
-	struct vmcb_control_area *ctl;
-	struct vmcb_save_area *save;
+	struct vmcb_control_area *ctl = NULL;
+	struct vmcb_save_area *save = NULL;
 	int ret;
 	u32 cr0;
 
-- 
2.28.0

