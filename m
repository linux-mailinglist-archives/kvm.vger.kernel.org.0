Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B4743E2C3
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 15:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhJ1N7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 09:59:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20906 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229887AbhJ1N7Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Oct 2021 09:59:16 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19SDmAT9022005;
        Thu, 28 Oct 2021 13:56:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=3Y6lteLfUPBChcASwXUwRdn1BQK2ILLRwZ4Nuk0nTYM=;
 b=gJ/Li03PIoqeMwRryfqwdvzLuKoMARJ1rr4u9C656NjN3DxLohRI4BsQAT31RA75y0+T
 LwoZAj+MeUFwF6iQfrUZ6VfKYWKMZSx1rJ/SHlhu7FdjvWQ69kuLFbKnli3m2GEBsqxk
 4jQXzxud8JqVuRvHQUmxNvlEnzNK4uqmaBnpegRFA28saaullupX+7JVEhN/KZz1wvSl
 i0UzCYECypz8v0fvCaCMcBrHzl/KpYGl0EnS9eOPmeCQZuVO0SbFnbYzwY1jOzmbBEIW
 T+J/QHqOv/gMmLbj8js+MYsNzI7SF8IyrjYX86sI1630FcixZXXbZ09xGSXoZGjx0tnj sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3byw2p8523-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 13:56:49 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19SDn4FB024008;
        Thu, 28 Oct 2021 13:56:49 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3byw2p851a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 13:56:49 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19SDr2sl011834;
        Thu, 28 Oct 2021 13:56:46 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3bx4f1su7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 13:56:46 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19SDoYhc38339038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Oct 2021 13:50:34 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4C97A405B;
        Thu, 28 Oct 2021 13:56:43 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4669CA4060;
        Thu, 28 Oct 2021 13:56:43 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Oct 2021 13:56:43 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] KVM: s390: Some gaccess cleanup
Date:   Thu, 28 Oct 2021 15:55:53 +0200
Message-Id: <20211028135556.1793063-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LasjKA88j_A33Gv2_a28oMEO8HQxrnVW
X-Proofpoint-ORIG-GUID: PkJHyxa0CLwcdI0Mz0eO3TNi8nSQKxoL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-28_01,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110280075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cleanup s390 guest access code a bit, getting rid of some code
duplication and improving readability.

v1 -> v2
	separate patch for renamed variable
		fragment_len instead of seg
	expand comment of guest_range_to_gpas
	fix nits

I did not pick up Janosch's Reviewed-by because of the split patch
and the changed variable name.

Janis Schoetterl-Glausch (3):
  KVM: s390: gaccess: Refactor gpa and length calculation
  KVM: s390: gaccess: Refactor access address range check
  KVM: s390: gaccess: Cleanup access to guest frames

 arch/s390/kvm/gaccess.c | 158 +++++++++++++++++++++++-----------------
 1 file changed, 92 insertions(+), 66 deletions(-)

-- 
2.25.1

