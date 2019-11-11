Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75495F73E3
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 13:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfKKMbM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 07:31:12 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41868 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfKKMbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 07:31:12 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABCTHP5001044;
        Mon, 11 Nov 2019 12:31:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=2fAdoIoqJPojVuvgsIc2vvLK2/vDwZuM4WTB/emdJC4=;
 b=PInUh7g2YmhD8ZQ63NdtteNvKNbX7qusnRJUfCNqml1xpKehXeNupYUm52eOr8E9Hp8k
 bYyq2+u/pEED5lKabEHd4i4XYsLNMfoUczsTDbISaC4iS0mzKmOzagi0yWcbyWuoPHAn
 /MMCH/2zFDZBCOAxXg5L9BfWCOwPoxJ57DcaGGeEfrqNuhBifcCYs+/BTdeHqMmz9e2d
 m6NZnDu/IuSjHwtfgfQEkSIriWjnW68nVwjxQx/A+sp5x/Da/I66asLtlHps5hD3D4tf
 BthoLN73cNO7vIiU6MnuwLEDc67wJcD68urx+/Y3HTYY6xDS6QsQv8YYQkPIT73SCwUq nQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w5p3qenc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 12:31:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABCShqk069407;
        Mon, 11 Nov 2019 12:31:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2w67kkxfj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 12:31:04 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xABCV3CX019986;
        Mon, 11 Nov 2019 12:31:03 GMT
Received: from Lirans-MBP.Home (/79.182.207.213)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 04:31:03 -0800
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com
Subject: [PATCH 0/2] KVM: nVMX: Update vmcs01 TPR_THRESHOLD if L2 changed L1 TPR
Date:   Mon, 11 Nov 2019 14:30:53 +0200
Message-Id: <20191111123055.93270-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=993
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110119
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This patch series aims to fix an issue in nVMX when host use TPR-Threshold (APICv disabled)
and L1 provides to L2 direct access to L1 TPR.

1st patch is just a simple refactoring patch which also simplifies next patch.
2nd is the issue fix. For futher information, see patch commit message.

A kvm-unit-test was written to simulate this issue and will be submitted seperately.

Regards,
-Liran

