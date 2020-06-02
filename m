Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882941EC37B
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 22:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgFBUJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 16:09:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37928 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728382AbgFBUJO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 16:09:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052JuRSj168397;
        Tue, 2 Jun 2020 20:07:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=ocpI79mplZv5oRbHZuWSY3GLTXVWYIgy/TCx4GYGkDk=;
 b=l4FZRHEuVBz6ABFS8e7MyuVRHvexUYysDsEtiwh+5NZgqFtEKTSeMZmSzHDQgQJEvjXd
 f8XFk9q1+Jdtiw9f9/R734I3X2EVSxqr5Av5wItEY30NwJmQRet9r85b7ZNA4svqeMwP
 cK5I643twktqqMUzTLXTSd2fnVh2bsjojTiBhmUHSN/5czBWENVeA80RzIF5lHf5zwit
 6Oh3D0yfgpwO+IwC4zo0OzkEjul/zdkadtmCFG1DIZcMEl60spjXodNXcQgBL+XI2cTs
 OcdASU50mtCvvAXxHXh1fCitbkda1XqsdTe88kPjPMicM/NckKGhgLowE0LSWyGjdROd qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31bfem5ucg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 20:07:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052Jvvt3065027;
        Tue, 2 Jun 2020 20:07:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31c25pvtqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 20:07:41 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 052K7dKp005443;
        Tue, 2 Jun 2020 20:07:39 GMT
Received: from ayz-linux.us.oracle.com (/10.154.185.88)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 13:07:39 -0700
From:   Anthony Yznaga <anthony.yznaga@oracle.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        steven.sistare@oracle.com, anthony.yznaga@oracle.com
Subject: [PATCH 2/3] KVM: x86: avoid unnecessary rmap walks when creating/moving slots
Date:   Tue,  2 Jun 2020 13:07:29 -0700
Message-Id: <1591128450-11977-3-git-send-email-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591128450-11977-1-git-send-email-anthony.yznaga@oracle.com>
References: <1591128450-11977-1-git-send-email-anthony.yznaga@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=2
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1011
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020146
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On large memory guests it has been observed that creating a memslot
for a very large range can take noticeable amount of time.
Investigation showed that the time is spent walking the rmaps to update
existing sptes to remove write access or set/clear dirty bits to support
dirty logging.  These rmap walks are unnecessary when creating or moving
a memslot.  A newly created memslot will not have any existing mappings,
and the existing mappings of a moved memslot will have been invalidated
and flushed.  Any mappings established once the new/moved memslot becomes
visible will be set using the properties of the new slot.

Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 23fd888e52ee..d211c8ced6bb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10138,7 +10138,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 *
 	 * FIXME: const-ify all uses of struct kvm_memory_slot.
 	 */
-	if (change != KVM_MR_DELETE)
+	if (change == KVM_MR_FLAGS_ONLY)
 		kvm_mmu_slot_apply_flags(kvm, (struct kvm_memory_slot *) new);
 
 	/* Free the arrays associated with the old memslot. */
-- 
2.13.3

