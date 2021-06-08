Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C37D39FE9B
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 20:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbhFHSIY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 14:08:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45838 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234127AbhFHSIW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 14:08:22 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 158I41fI002968;
        Tue, 8 Jun 2021 14:06:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=9pT5NyCsMcXq6bxyr9aL7I+JZVm7+8yifIRbBFy2b3c=;
 b=kYq9HgrKj07DuLK4uy+IB1Cj1edid5VuONTL1G5F30TjaC1IG5GWaZ6S2SkYSmkShBkx
 HqXXE9XE+nfB5urbF8LAHD6eq+cbBhxy8Ys/b/TJkqp0bAse7hHFrK1p+zcl9f57wyyi
 +VcSOnY6tawL3jKD7DyAzNoXa6NQe0xlPS+kuaHSUFIA8nrlZtQQ7VDiOC9zjuRycNFB
 ICLhW936fNn+Jh9mY68fSGCg13EkS4hoU80d2mMKtNJOsVpjiLhzUpv1GaSvZgQO+Rws
 9Qoo2fUaV+L54irA6Z11RY0wSZCEbGQJP7DDVgqyPLV8kn98tyQRdp66uM5duvHsSArQ dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39266dy1xq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 14:06:25 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 158I436j003069;
        Tue, 8 Jun 2021 14:06:25 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39266dy1wg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 14:06:24 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 158HvaBb026004;
        Tue, 8 Jun 2021 18:06:22 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3900hhgx8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 18:06:22 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 158I6JN631195408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Jun 2021 18:06:19 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 760AA52051;
        Tue,  8 Jun 2021 18:06:19 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.5.240])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 103975204F;
        Tue,  8 Jun 2021 18:06:19 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        david@redhat.com, linux-mm@kvack.org
Subject: [PATCH v2 0/2] mm: export __vmalloc_node_range and use it
Date:   Tue,  8 Jun 2021 20:06:16 +0200
Message-Id: <20210608180618.477766-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mMY1AqUiAIUc7imm9kNMMO16XJpItA0d
X-Proofpoint-ORIG-GUID: HXhffsdsD4UNilx6V7W4H_8h-hNM9UAU
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-08_11:2021-06-04,2021-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 impostorscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=766 clxscore=1011 mlxscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Export __vmalloc_node_range so it can be used in modules.

Use the newly exported __vmalloc_node_range in KVM on s390 to overcome
a hardware limitation.

Claudio Imbrenda (2):
  mm/vmalloc: export __vmalloc_node_range
  KVM: s390: fix for hugepage vmalloc

 arch/s390/kvm/pv.c | 5 ++++-
 mm/vmalloc.c       | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

-- 
2.31.1

