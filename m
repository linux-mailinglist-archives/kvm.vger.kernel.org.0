Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD8F589FE9
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 19:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238773AbiHDRf4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 13:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiHDRfy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 13:35:54 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331F72DDA;
        Thu,  4 Aug 2022 10:35:54 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274HNl8a015764;
        Thu, 4 Aug 2022 17:35:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=/cghOawxKGz6XmbmY4L8110OIlpBHcHQawRv8FO7xUg=;
 b=oUIByVc3Yd9jg4PmDOyEb7MFmYQvcISDiTtiMdlO2TGgddGkYavDXW+KGeKlV9tIIXt6
 SOulhXDg+DkiVekvyyb2js0XJweD4KCeJSc+vTM7yI6zZFcL2Lg6mLMqIQC7iA5Tv7zM
 OJNRCv+plG7zInheTvv7dV0xiIIJrjVSCW3ARHuXsUnDKeeBOtYeLkUXHYN5Dkgo6ICo
 Sa29IzdTO+3C7EuY697XgAZQKL8yWQ/Ofb/LWOX1/GdPFnxNXi83tKWffakN5U6+h3tw
 eQ3SJbYS161/aijnTmKfT7VuhWsKADM8uifoSdS1u9w8dALWlF/fAmxs/bAuvZuFTTem ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hrjd5rh2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Aug 2022 17:35:53 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 274HNrnS016516;
        Thu, 4 Aug 2022 17:35:52 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hrjd5rh1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Aug 2022 17:35:52 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 274H4tUH010741;
        Thu, 4 Aug 2022 17:35:52 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01dal.us.ibm.com with ESMTP id 3hq6j009e6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Aug 2022 17:35:52 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 274HZpHL9634324
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Aug 2022 17:35:51 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E646728059;
        Thu,  4 Aug 2022 17:35:50 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 609932805E;
        Thu,  4 Aug 2022 17:35:49 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.67.200])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu,  4 Aug 2022 17:35:49 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 0/1] fix sparse warning in linux-next
Date:   Thu,  4 Aug 2022 13:35:45 -0400
Message-Id: <20220804173546.226968-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XGBff3sb0cj_qt1081xNQAdZVKQ4V1PY
X-Proofpoint-GUID: Zqyiq6J4HXckSKL2Xj11giQHZ1QlU-ji
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 bulkscore=0 clxscore=1011 impostorscore=0 lowpriorityscore=0 phishscore=0
 suspectscore=0 priorityscore=1501 mlxlogscore=787 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Sorry I missed the initial report on this while out of the office.
This patch fixes a sparse warning that shows up in
'KVM: s390: pci: do initial setup for AEN interpretation'
as part of the 5.20/6.0 pull request.

Matthew Rosato (1):
  KVM: s390: pci: fix airq_iv_create sparse warning

 arch/s390/kvm/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.31.1

