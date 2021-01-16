Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9412F8AB5
	for <lists+kvm@lfdr.de>; Sat, 16 Jan 2021 03:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbhAPCVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 21:21:37 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46740 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728324AbhAPCVg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 21:21:36 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10G25nh2109880;
        Sat, 16 Jan 2021 02:20:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=FCHR/kvHlyKbKvUjMwXY42SxTz0rqXup5nfnNHN3YTM=;
 b=kZp8Mho1o8Hiz1VvTHwtA4FE1xzljnx3j0VGEgkgviub4Oj7jKeWr/NTtsxgrk8GhlJi
 VvOxzj2mVvrhTk7K1b9o1rk5iXN+7dz+Cmlj6IdykKFLVlRynXCkraXJq/DxT4hizqs3
 Did2knFiLmSueI/ErKeozWh+rU7l2ExCefGsXXpI93PLOgA5Dhm9p8FqIys7K/AiZJgo
 2iX9uRRKL5u/zJiJjpcx8vHj5tkwyPF55LqOokux4lNNp19VCooW4GmcQW1Xn0A9P3NW
 GqAXF0VXz53Qm09/ifyV6bHAMIuTVYp5FSeE3On2lTYAZOJQnwQZRQTS5RICUvKOLBCK HA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 360kvkf9gv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 Jan 2021 02:20:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10G26Ngb194960;
        Sat, 16 Jan 2021 02:20:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 360kebux99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 Jan 2021 02:20:51 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10G2KpGk014944;
        Sat, 16 Jan 2021 02:20:51 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 Jan 2021 18:20:51 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 3/3 v2] Test: SVM: Use ALIGN macro when aligning 'io_bitmap_area'
Date:   Sat, 16 Jan 2021 02:20:39 +0000
Message-Id: <20210116022039.7316-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210116022039.7316-1-krish.sadhukhan@oracle.com>
References: <20210116022039.7316-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9865 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101160010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9865 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101160010
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the macro is available and we already use it for MSR bitmap table, use
it for aligning IO bitmap table also.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/svm.c b/x86/svm.c
index a1808c7..846cf2a 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -298,7 +298,7 @@ static void setup_svm(void)
 	wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_SVME);
 	wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_NX);
 
-	io_bitmap = (void *) (((ulong)io_bitmap_area + 4095) & ~4095);
+	io_bitmap = (void *) ALIGN((ulong)io_bitmap_area, PAGE_SIZE);
 
 	msr_bitmap = (void *) ALIGN((ulong)msr_bitmap_area, PAGE_SIZE);
 
-- 
2.27.0

