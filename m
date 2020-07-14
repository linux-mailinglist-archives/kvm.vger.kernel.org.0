Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E9321F409
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 16:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgGNO1T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 10:27:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38766 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgGNO1R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 10:27:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EENFcM063488;
        Tue, 14 Jul 2020 14:26:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=qMQnxDh7lLTem5GHBoFbTpsZAzURxuhHrYLIUSYBF3w=;
 b=HtinuOMygse0d//W2DL4O5yw/8+OI55evhgk1Zuz63nRJBCcHT7bl2iYf0hnfEw8sMgl
 i7K0OMObUZaMiHfs9u7tUCmSr4CrPl4GpgqtRKyckoVCT+nPiRIZNb/970Bt+zxUXK9t
 UpdYSri6c/SDsu0jw2VMbvB0MDlLiRnC85jr7rD1AzVuDxBXpV8knO2QzydUbWC8+xw1
 vZOMnQy15yZE6yKG86Cimej8qZ0A8cI0R2EFcdFCZorzejPEBSVCmnVNnvVY0bf1qh2y
 pu/4TPHBEQuxbWap7rq1QscDiwQlAyZ1uo8Uo+WBC6dQ1vn8Y2okmzNaoK90jiXMY96v 4A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32762ndhh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 14:26:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EENaaZ163160;
        Tue, 14 Jul 2020 14:24:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 327q0pbjyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 14:24:06 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06EEO03k016983;
        Tue, 14 Jul 2020 14:24:00 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 07:23:59 -0700
Date:   Tue, 14 Jul 2020 17:23:51 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] KVM: SVM: Fix sev_pin_memory() error handling
Message-ID: <20200714142351.GA315374@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1011 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 suspectscore=2 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140111
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The sev_pin_memory() function was modified to return error pointers
instead of NULL but there are two problems.  The first problem is that
if "npages" is zero then it still returns NULL.  Secondly, several of
the callers were not updated to check for error pointers instead of
NULL.

Either one of these issues will lead to an Oops.

Fixes: a8d908b5873c ("KVM: x86: report sev_pin_memory errors with PTR_ERR")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 arch/x86/kvm/svm/sev.c   |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f7f1f4ecf08e..402dc4234e39 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -318,6 +318,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 	unsigned long locked, lock_limit;
 	struct page **pages;
 	unsigned long first, last;
+	int ret;
 
 	if (ulen == 0 || uaddr + ulen < uaddr)
 		return ERR_PTR(-EINVAL);
@@ -351,6 +352,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 	npinned = pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
 	if (npinned != npages) {
 		pr_err("SEV: Failure locking %lu pages.\n", npages);
+		ret = -ENOMEM;
 		goto err;
 	}
 
@@ -360,13 +362,11 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 	return pages;
 
 err:
-	if (npinned > 0) {
+	if (npinned > 0)
 		unpin_user_pages(pages, npinned);
-		npinned = -ENOMEM;
-	}
 
 	kvfree(pages);
-	return ERR_PTR(npinned);
+	return ERR_PTR(ret);
 }
 
 static void sev_unpin_memory(struct kvm *kvm, struct page **pages,
@@ -440,8 +440,8 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* Lock the user memory. */
 	inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
-	if (!inpages) {
-		ret = -ENOMEM;
+	if (IS_ERR(inpages)) {
+		ret = PTR_ERR(inpages);
 		goto e_free;
 	}
 
@@ -795,13 +795,13 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 
 		/* lock userspace source and destination page */
 		src_p = sev_pin_memory(kvm, vaddr & PAGE_MASK, PAGE_SIZE, &n, 0);
-		if (!src_p)
-			return -EFAULT;
+		if (IS_ERR(src_p))
+			return PTR_ERR(src_p);
 
 		dst_p = sev_pin_memory(kvm, dst_vaddr & PAGE_MASK, PAGE_SIZE, &n, 1);
-		if (!dst_p) {
+		if (IS_ERR(dst_p)) {
 			sev_unpin_memory(kvm, src_p, n);
-			return -EFAULT;
+			return PTR_ERR(dst_p);
 		}
 
 		/*
