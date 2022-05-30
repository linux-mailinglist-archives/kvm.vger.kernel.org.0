Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEFF537807
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 12:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234650AbiE3J11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 05:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234588AbiE3J1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 05:27:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACC7641F;
        Mon, 30 May 2022 02:27:13 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24U7gMG6005584;
        Mon, 30 May 2022 09:27:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=wDj44lerMcMAJdLsjLd54yBBsxX5D9/jE0xYlYMLmzY=;
 b=MEbMDfT8ukgTS2VyBa2yQ1fSgtt2uNu0Eiickd6K5TnTHnNPOip2EuxnFZf//1/yjIWX
 JIk/f/GdL6O9rX1WmRVq6TX0dCWX+85ePZGRGACND65M+UA6unKTMs4sKVp4QkDMwvfv
 5YvCiKIgJiNjZl1K0aQwLsAroEPizHJkbrSwA8Jfkcrif0hLcZ9mfXSGQulNloKYJ4Rh
 +5+o3xoKtjvXOmIqZOFK5u8WGJUUls5pX8MChfkz9aw1Xi3dapOJPc0A0auheB9ur4Au
 fRLXphrguRwVT4zbsOvNxhZqSke/VvHpN7s5WLyYMFkFcYIXyQJ1X+VMTT/Q/Qp3Vz4A VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcsrw21sf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 09:27:13 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24U9GDdO024569;
        Mon, 30 May 2022 09:27:12 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcsrw21ru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 09:27:12 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24U9M46h021962;
        Mon, 30 May 2022 09:27:10 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3gbcb7hua2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 09:27:10 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24U9ClIm49938918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 09:12:47 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1901211C050;
        Mon, 30 May 2022 09:27:07 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06EEB11C04C;
        Mon, 30 May 2022 09:27:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 30 May 2022 09:27:06 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id C29FEE13C2; Mon, 30 May 2022 11:27:06 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     KVM <kvm@vger.kernel.org>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: [PATCH 0/2] s390/gmap/pgtable improve handling of keyed KVM guests
Date:   Mon, 30 May 2022 11:27:04 +0200
Message-Id: <20220530092706.11637-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _sRyGeoO0Pz-WEk8H8X-pgnD3QKlVy_n
X-Proofpoint-ORIG-GUID: ysDSVcSpzZeMC47SAPw7N98g-oM706KU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_03,2022-05-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 mlxlogscore=753 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205300044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These two patches try to address stalls/timeouts that we have seen when
switching many guests to enable storage keys.

Christian Borntraeger (2):
  s390/gmap: voluntarily schedule during key setting
  s390/pgtable: use non-quiescing sske for KVM switch to keyed

 arch/s390/mm/gmap.c    | 14 ++++++++++++++
 arch/s390/mm/pgtable.c |  2 +-
 2 files changed, 15 insertions(+), 1 deletion(-)

-- 
2.35.1

