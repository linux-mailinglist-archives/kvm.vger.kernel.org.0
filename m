Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78B1C1658BB
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 08:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgBTHsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 02:48:46 -0500
Received: from mx60.baidu.com ([61.135.168.60]:28371 "EHLO
        tc-sys-mailedm05.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726501AbgBTHsq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 02:48:46 -0500
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Feb 2020 02:48:44 EST
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm05.tc.baidu.com (Postfix) with ESMTP id E37C61EBA001;
        Thu, 20 Feb 2020 15:39:32 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][resend] KVM: fix error handling in svm_cpu_init
Date:   Thu, 20 Feb 2020 15:39:32 +0800
Message-Id: <1582184372-15876-1-git-send-email-lirongqing@baidu.com>
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
index a3e32d61d60c..b8e948c65f51 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1014,7 +1014,7 @@ static int svm_cpu_init(int cpu)
 	r = -ENOMEM;
 	sd->save_area = alloc_page(GFP_KERNEL);
 	if (!sd->save_area)
-		goto err_1;
+		goto err_free_sd;
 
 	if (svm_sev_enabled()) {
 		r = -ENOMEM;
@@ -1022,14 +1022,16 @@ static int svm_cpu_init(int cpu)
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

