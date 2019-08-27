Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF049E49B
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 11:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbfH0JlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 05:41:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58852 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbfH0JlD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 05:41:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7R9Xg5R004723;
        Tue, 27 Aug 2019 09:39:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=JPkF6lzK/+T4qsG8ilfaNhkWn7WfY/fvZi21ug4KTpw=;
 b=KTtCNst+5DV96n4tlt6SkpbwYvOOHOzFrOjGjZkL4TajEsTNmPEmJSUKN0VPxayReGzX
 +xuaYnBxNVUsnlExsHP/HfiHVRfM/R2+mfEPEEgisabXo74Y3nZW0OYzd+1rGSqWXvIL
 oCm+DyN2f/IDYU4LEko1uOmhBq5oGxEx9yI+2bTAi3u4Yx9BCWQvPm2OsihifpeYlsr2
 yqEsDoRsYugltFGKaqpbITPEv451r4LsZ/xBORrS3UoT+vW93/nlKWA9qqKcUhPS3wDj
 nSDaY190K3DwWMJOjSl3xcZpcXfnaKoUm3ceb9zNlFbw5dNjwYy4JuCxeMU4PQfy+iER bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2un1sh04jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 09:39:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7R9cFNH089851;
        Tue, 27 Aug 2019 09:39:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2umhu8h6js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 09:39:08 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7R9d1Ed003849;
        Tue, 27 Aug 2019 09:39:01 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Aug 2019 02:39:01 -0700
Date:   Tue, 27 Aug 2019 12:38:52 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] x86: KVM: svm: Fix a check in nested_svm_vmrun()
Message-ID: <20190827093852.GA8443@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908270109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908270108
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We refactored this code a bit and accidentally deleted the "-" character
from "-EINVAL".  The kvm_vcpu_map() function never returns positive
EINVAL.

Fixes: c8e16b78c614 ("x86: KVM: svm: eliminate hardcoded RIP advancement from vmrun_interception()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
From static analysis.  I don't really know the impact.


 arch/x86/kvm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1f220a85514f..ef646e22d1ab 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3598,7 +3598,7 @@ static int nested_svm_vmrun(struct vcpu_svm *svm)
 	vmcb_gpa = svm->vmcb->save.rax;
 
 	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map);
-	if (ret == EINVAL) {
+	if (ret == -EINVAL) {
 		kvm_inject_gp(&svm->vcpu, 0);
 		return 1;
 	} else if (ret) {
-- 
2.20.1

