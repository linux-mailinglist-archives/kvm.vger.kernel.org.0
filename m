Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18A9A60111
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 08:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfGEGfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 02:35:47 -0400
Received: from mx57.baidu.com ([61.135.168.57]:53036 "EHLO
        tc-sys-mailedm01.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725813AbfGEGfr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jul 2019 02:35:47 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm01.tc.baidu.com (Postfix) with ESMTP id 5772E2040050;
        Fri,  5 Jul 2019 14:29:07 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     pbonzini@redhat.com, x86@kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com
Subject: [PATCH][resend] KVM: fix error handling in svm_cpu_init
Date:   Fri,  5 Jul 2019 14:29:07 +0800
Message-Id: <1562308147-5786-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

sd->save_area should be freed in error path

Fixes: 70cd94e60c733 ("KVM: SVM: VMRUN should use associated ASID when SEV is enabled")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 48c865a4e5dd..a69eff0aa40b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -999,7 +999,7 @@ static int svm_cpu_init(int cpu)
 	r = -ENOMEM;
 	sd->save_area = alloc_page(GFP_KERNEL);
 	if (!sd->save_area)
-		goto err_1;
+		goto err_free_sd;
 
 	if (svm_sev_enabled()) {
 		r = -ENOMEM;
@@ -1007,14 +1007,16 @@ static int svm_cpu_init(int cpu)
 					      sizeof(void *),
 					      GFP_KERNEL);
 		if (!sd->sev_vmcbs)
-			goto err_1;
+			goto err_free_saved_area;
 	}
 
 	per_cpu(svm_data, cpu) = sd;
 
 	return 0;
 
-err_1:
+err_free_saved_area:
+	__free_page(sd->save_area);
+err_free_sd:
 	kfree(sd);
 	return r;
 
-- 
2.16.2

