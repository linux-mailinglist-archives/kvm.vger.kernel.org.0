Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C9F6182B3
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 16:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbiKCP1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 11:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbiKCP0v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 11:26:51 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B4D1BE89;
        Thu,  3 Nov 2022 08:26:38 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A3FI9qj032103;
        Thu, 3 Nov 2022 15:26:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=qZs/1Mht4kBzO4JzaoAy3buNdmAe6nA5ETR3flBHNyc=;
 b=OfJaqMUMKHat9xgcOJDjvssg4NsGIH8mvb+OjvfEA/hocR6mau0ALGWw42j+FAU875B+
 LAmYZQn45IJ7DPOW1EEUa8BE35sPBHMeLedEtj3XQr9YyyxklFyvirmM28/B4ttR4SOk
 vC76FRCtQgq6WGJyZkNHaoebiwl0Xbi4t03MuUt8yLPyDvDH3uUKpD/GBJEmbgCrgwy1
 PUKa9WdNZ8hoJl0U79gZaQ84Ym9z9YWes4jvhA4Y0Eocda+dV+C2p+9kcQDuBdMEovnc
 X83IHbWu+MCfw0OMIvwMlUBbFXTDqG4iBtWUhr55AYf75jdcLDRsa62rfruiTql1Mvk6 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmemwkvqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 15:26:37 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A3FKGmj003973;
        Thu, 3 Nov 2022 15:26:37 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmemwkvps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 15:26:37 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A3F65Ih002097;
        Thu, 3 Nov 2022 15:26:35 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3kguej1194-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 15:26:35 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A3FR8xc47841770
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Nov 2022 15:27:08 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0081D4C044;
        Thu,  3 Nov 2022 15:26:32 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 850044C040;
        Thu,  3 Nov 2022 15:26:31 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.245])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Nov 2022 15:26:31 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, svens@linux.ibm.com
Subject: [PATCH v3 0/1] KVM: s390: vsie: clarifications on setting the APCB
Date:   Thu,  3 Nov 2022 16:26:30 +0100
Message-Id: <20221103152631.17393-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0bdX_N3QkLLdQA8EtCHtq6BLENzyFYXj
X-Proofpoint-GUID: G_ubcIFwY1OsmCkoFzK9iQb3GpFJU81j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_04,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 impostorscore=0 adultscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 spamscore=0 lowpriorityscore=0 mlxlogscore=570 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211030101
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This is a v3 of the previously called:
[PATCH] KVM: s390: vsie: fix crycb virtual vs physical usage
and 
[PATCH v2 0/1] KVM: s390: vsie: clarifications on setting the APCB

Changes:

1->2 After David's comment that the patch has not to do with
     virtual vs physical, I reworked the commit message.

2->3 rename crycb_o crycb_gpa and apcb_o apcb_gpa
     gpa = Guest Physical Address 

I resent the patch because I think that even the previous
version is not really buggy, this new version brings clarity.

Regards,
Pierre


Pierre Morel (1):
  KVM: s390: vsie: clarifications on setting the APCB

 arch/s390/kvm/vsie.c | 50 +++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

-- 
2.31.1

