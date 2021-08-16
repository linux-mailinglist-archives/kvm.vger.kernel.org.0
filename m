Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB85F3ED97B
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 17:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbhHPPIG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 11:08:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22282 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231438AbhHPPIC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 11:08:02 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GF3ItD145308;
        Mon, 16 Aug 2021 11:07:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=8VuV6kkubQLx/fXq4+8jf1QCpapuUKeWDRUmz/1F54I=;
 b=fO4YD09fQniAJIteOW7mqeKYhtTW6Ui9cv3T9HrRl6pEblH7LdqQfSDS4ubn8DNOX8iQ
 njMaBlbYNtD95f5AT/KWK3fJP/P53gx4n1HU5rahppSEJJkyDijuR8IyKl9g00VJRp/L
 AXsc9qw2LDIyvt1dlRSA5IrCYjNm/Gql5owONNa9isjvFbvBtHLpJlkWBB5Lv+e37JtR
 IBgvZbzFpjpLlx2BW650KBsrshiiwFaNZPkhtRk082q1e8rqKGyE2I77lRQqYZ5Cz7mv
 N7P9qggfSyWH9cGXeLPR2XRcokJeaI5ZCPQxTd1cI8FUR0c3YSYk+pH9zYJ88uznuf5Q Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aetu0b4c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 11:07:30 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17GF41eA002819;
        Mon, 16 Aug 2021 11:07:30 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aetu0b4b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 11:07:30 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17GF64C0020523;
        Mon, 16 Aug 2021 15:07:27 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3ae5f8b1ju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 15:07:27 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17GF7NpH54395174
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 15:07:23 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BFF611C04A;
        Mon, 16 Aug 2021 15:07:23 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D47D11C085;
        Mon, 16 Aug 2021 15:07:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 Aug 2021 15:07:23 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     scgl@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [PATCH 0/2] KVM: s390: Some gaccess cleanup
Date:   Mon, 16 Aug 2021 17:07:15 +0200
Message-Id: <20210816150718.3063877-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aL3zqgpaSkHAmSzSIGNeWXX6NTErAtPq
X-Proofpoint-GUID: mUQ3-TXg6J4qJDXwjo5cRnj8SIBT_Kq5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-16_04:2021-08-16,2021-08-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=905 mlxscore=0
 malwarescore=0 bulkscore=0 adultscore=0 clxscore=1011 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108160096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cleanup s390 guest access code a bit, getting rid of some code
duplication and improving readability.

Janis Schoetterl-Glausch (2):
  KVM: s390: gaccess: Cleanup access to guest frames
  KVM: s390: gaccess: Refactor access address range check

 arch/s390/kvm/gaccess.c | 129 ++++++++++++++++++++--------------------
 1 file changed, 63 insertions(+), 66 deletions(-)

-- 
2.25.1

