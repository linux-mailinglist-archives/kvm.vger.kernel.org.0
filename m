Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC8D60C7CF
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 11:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiJYJUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 05:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbiJYJTP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 05:19:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E7916D561;
        Tue, 25 Oct 2022 02:13:30 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29P8fws5031995;
        Tue, 25 Oct 2022 09:13:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=tUK1S1V8KkuMZE5qnKt6Zlic8ds/4BgXj6jD058Z+lo=;
 b=R27+k7Zh7iz6n9/TExEpZbM8IknTk1YfGThAnaDJWZkONK5TjtEgggkmyPROWCLLcJ8T
 4pOfkPG/pjcPniGtiy1LXZpzCj9VgVD3XPfgZ9LGITut+RlpWuGEq7Kq9sKnC1Fbeooz
 VJHh8XhmKZGc4raDGswOczsDqgNwVSSvTDO0ediWyaM+yhp1T+Dfiy62DiJ6iGMfR7cX
 U/3RD/Q0Do3gdMB3J3KISMk3tgRs6RoEwhJI09tp5XG4ciyYcdQ3FpeyP43xxJRFW1VB
 xjf+WUXvRjttrgJNL2jTaLq7CxsC1U/e+oyGv2EgVVD3AuPB/kot9Hblb2YrWW4KPokl +g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kecgvs2h7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 09:13:29 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29P8gE8P032435;
        Tue, 25 Oct 2022 09:13:29 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kecgvs2gf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 09:13:29 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29P95uru022594;
        Tue, 25 Oct 2022 09:13:26 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3kc8594711-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 09:13:26 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29P9DvOU36765964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 09:13:57 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AE99A4060;
        Tue, 25 Oct 2022 09:13:23 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67571A405B;
        Tue, 25 Oct 2022 09:13:22 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.30.119])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 09:13:22 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, svens@linux.ibm.com
Subject: [PATCH v2 0/1] KVM: s390: vsie: clarifications on setting the APCB
Date:   Tue, 25 Oct 2022 11:13:18 +0200
Message-Id: <20221025091319.37110-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QKleZcusJWMEQdzvL98M5YQXHvVslG3L
X-Proofpoint-GUID: _OWq1eiKTs7F5UnxrDMMf6MuXOrfw-Nt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_03,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 impostorscore=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=473 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210250052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This is a v2 of the previously called: 
[PATCH] KVM: s390: vsie: fix crycb virtual vs physical usage

After David's comment that the patch has not to do with
virtual vs physical, I reworked the commit message.

I resent the patch because I think that even the previous
version is not really buggy, this new version brings clarity.

Regards,
Pierre

Pierre Morel (1):
  KVM: s390: vsie: clarifications on setting the APCB

 arch/s390/kvm/vsie.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

-- 
2.31.1

