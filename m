Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9247A2F8AB4
	for <lists+kvm@lfdr.de>; Sat, 16 Jan 2021 03:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728694AbhAPCVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 21:21:36 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:48626 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbhAPCVf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 21:21:35 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10G24LVK125385;
        Sat, 16 Jan 2021 02:20:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=s+hKv2Hsgem2IKtJX/pjAPHvUqbzAyi0SIY3rNiY9/g=;
 b=jUGrAM+jqX96Qz3tGU9PDnoO8KQ4N4Tk2L2Mu+Zkbwr0le6qbkR0Mw7jNt/cPsAtidR8
 JzeISBNYSVvH2XFKpbZCal6eEn0FfOmgqQ1mEjW4rcxWWeRtZlnD8vMRlhFuZ/z1/eiI
 Ve3GiUwIIElToVxo9yNc306OhUlJj3IFVPqobhxjltRqKU4B9zNGQrxQGhS6QHuaLJlg
 N9oecmbJScUNWENR80Y2WF/imjJmEU0akdKgeOoE3CM02dXKeRBVbfpgE51127VBZqCD
 AeA+1+aVbAvLF6T2VRpRMEfOdP1Mr1ys5h9Kx3kjgv1dytPpcb9uYs7BJ0Surq/UTpax /Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 363nna83gt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 Jan 2021 02:20:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10G25u8h004140;
        Sat, 16 Jan 2021 02:20:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 360kfbuvsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 Jan 2021 02:20:51 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10G2KonK019552;
        Sat, 16 Jan 2021 02:20:50 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 Jan 2021 18:20:50 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 0/3 v2] KVM: nSVM: Check addresses of MSR bitmap and IO bitmap tables on vmrun of nested guests
Date:   Sat, 16 Jan 2021 02:20:36 +0000
Message-Id: <20210116022039.7316-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9865 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101160010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9865 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 bulkscore=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101160010
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1 -> v2:
	In patch# 1, the parameter to nested_vmcb_check_controls() has been
	changed to 'struct kvm_vcpu' from 'struct vcpu_svm'. This necessiated
	relevant changes to its callers.
	Also, the new checks in nested_vmcb_check_controls() now use
	page_address_valid() instead of duplicating code.

	It has also been rebased to v5.11-rc3.


[PATCH 1/3 v2] nSVM: Check addresses of MSR and IO bitmap
[PATCH 2/3 v2] Test: nSVM: Test MSR and IO bitmap address
[PATCH 3/3 v2] Test: SVM: Use ALIGN macro when aligning 'io_bitmap_area'

 arch/x86/kvm/svm/nested.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

Krish Sadhukhan (1):
      nSVM: Check addresses of MSR and IO bitmap

 x86/svm.c       |  2 +-
 x86/svm_tests.c | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 1 deletion(-)

Krish Sadhukhan (2):
      nSVM: Test MSR and IO bitmap address
      SVM: Use ALIGN macro when aligning 'io_bitmap_area'

