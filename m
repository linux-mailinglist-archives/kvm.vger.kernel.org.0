Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDB724D524
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 14:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbgHUMij (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 08:38:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53764 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727104AbgHUMif (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Aug 2020 08:38:35 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LCYxFi063851
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 08:38:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=MXAVG0L/Coo4Ufdi2FLOeEe0kssyG+mYHO2NlOV6wjo=;
 b=sIRs1rkme2vQjiJBRyPZ6GljQjYELtNm+QwroHENdlPFvlwpqHUXIPqUS96cXyg0fveB
 znm5dKS9XEX9oIrVZ7DUKivLSKL+YqqIsaYvb1N/I91KESynvbZr6P8V53g46o+RrPa4
 kgMZwAAKLBfo9wMI0aca+yftTdjlBI10VyrsW3+EOGW/nVjLsHjF7kjEEzoKsDJpUY49
 lEdsRRQTLlzAwMW/T1rDNuse0FL3CpplSv0xqQ4f8T5d8aszQFkEaChGgnrKsekgviK4
 0Jmz0o2RFbpLoX9SN/+OMZGKrWnEMKxgt5bswZHC2XLwZtOulB5UwAIMyn8iZAjy3YGF Qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 332b8an82w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 08:38:35 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07LCZ7uE064703
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 08:38:34 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 332b8an824-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 08:38:34 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07LCZ6rW028617;
        Fri, 21 Aug 2020 12:38:32 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3304c92p50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 12:38:32 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07LCcTbY28573978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 12:38:29 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0ED84C04A;
        Fri, 21 Aug 2020 12:38:29 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 595024C040;
        Fri, 21 Aug 2020 12:38:29 +0000 (GMT)
Received: from marcibm.ibmuc.com (unknown [9.145.60.23])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Aug 2020 12:38:29 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 0/2] Use same test names in the default and the TAP13 output format
Date:   Fri, 21 Aug 2020 14:37:42 +0200
Message-Id: <20200821123744.33173-1-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_06:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 suspectscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

See patches description.

For everybody's convenience there is a branch:
https://gitlab.com/mhartmay/kvm-unit-tests/-/tree/tap

Marc Hartmayer (2):
  runtime.bash: remove outdated comment
  Use same test names in the default and the TAP13 output format

 run_tests.sh         | 15 +++++++++------
 scripts/runtime.bash |  9 +++------
 2 files changed, 12 insertions(+), 12 deletions(-)

-- 
2.25.4

