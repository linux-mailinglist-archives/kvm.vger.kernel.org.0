Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A222B7A7F
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 10:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgKRJju (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 04:39:50 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55446 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725814AbgKRJjt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Nov 2020 04:39:49 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AI9Xfgh023727;
        Wed, 18 Nov 2020 04:39:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=u54aAQWoLPMzEIvVZIw+FkSBkit07Cum0WnKaE4yIw8=;
 b=hpP2DwEW0F+gOsEQCTUYcqbGyORJuMCkzYFXk8rMB3eFQBfJsytMicBF5oGvwifyybQN
 ipb61tNZurjbgCag6dN6yWF5GlUnWe8+hmkf+cIFW0VLvh0V7BKk7hbZVy20K9YcA5Bj
 YkTO66tDtRApHpMbxQ9RN2NwooMkqPGjZelkF+eALoJSH+T0gpdfTOqE6bqPh6H2MXX0
 NqFVkHmDZdApLPnsK/ExSNsrW7G2zwcX8tmyNxKgKHx5Bhw0k9ms/2Mkt5ZyZeybBPiq
 qV8EJiNR+zI4wZlDt/Z5b2houS/Wc8vvHj/iSPPcEY6KGjuAJEjn0bm0qiR8bqj6Dr6p GQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34w0sh8gcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 04:39:48 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AI9YEKf027330;
        Wed, 18 Nov 2020 04:39:48 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34w0sh8gc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 04:39:47 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AI9auNr018334;
        Wed, 18 Nov 2020 09:39:46 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 34t6v8bye2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 09:39:46 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AI9dhse35389926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Nov 2020 09:39:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 805EEA4040;
        Wed, 18 Nov 2020 09:39:43 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F27AA4051;
        Wed, 18 Nov 2020 09:39:43 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 18 Nov 2020 09:39:43 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 35618E23AF; Wed, 18 Nov 2020 10:39:43 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 0/2] Fix and MAINTAINER update for 5.10
Date:   Wed, 18 Nov 2020 10:39:40 +0100
Message-Id: <20201118093942.457191-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_04:2020-11-17,2020-11-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 bulkscore=0 impostorscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 suspectscore=0 clxscore=1015
 mlxlogscore=524 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011180062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Conny, David,

your chance for quick feedback. I plan to send a pull request for kvm
master soon.

I have agreed with Heiko to carry this via the KVM tree as
this is KVM s390 specific.

Christian Borntraeger (2):
  s390/uv: handle destroy page legacy interface
  MAINTAINERS: add uv.c also to KVM/s390

 MAINTAINERS           | 1 +
 arch/s390/kernel/uv.c | 9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

-- 
2.28.0

