Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721FF5B0B58
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 19:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiIGRTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 13:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiIGRTu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 13:19:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0C314D20;
        Wed,  7 Sep 2022 10:19:41 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 287GDhH6029287;
        Wed, 7 Sep 2022 17:19:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=F0xc+5czV2UbnFYrYqCz4AcqHKW1n16n1PSM0a8NBNY=;
 b=ITvxJALMvJlYZDe/y8bDGf1RZz93VqgGeGp4afenKNBAAc81PKiLQtHdr9yIE+pTTgPi
 AHaOoETTqnb/I15q4V4+Iqrdu0RnnyjSZveVhv9mFFr2WN1qlnWtflaTwvyaIEChRZ+D
 vYYkKwBzxNL+u/zSrtxEaxGRRg6Yumh9y1JFjxxY4I6YQBmi3nOlY3yzqlsfDveGbIl4
 l/z00g1y340x1PasOronXiLGmIrMpG08Vkt4HHYdSytK5q11LbVA7mXOvXY+fzvTat5s
 ZLsX0FaOXf+AI9r2JYXeYrwCVT08RYg7dABJ9MO4HteBj24pWghhAIzcJajAPltk5SVi 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jexmtt5um-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 17:19:40 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 287GoKoq024102;
        Wed, 7 Sep 2022 17:19:40 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jexmtt5u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 17:19:40 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 287H66rX031656;
        Wed, 7 Sep 2022 17:19:38 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3jbx6hngbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 17:19:38 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 287HJYVB26870260
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Sep 2022 17:19:34 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A35A34C040;
        Wed,  7 Sep 2022 17:19:34 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 172104C044;
        Wed,  7 Sep 2022 17:19:34 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.145.188.40])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Sep 2022 17:19:34 +0000 (GMT)
Date:   Wed, 7 Sep 2022 19:19:23 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Anthony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v3 0/2] s390/vfio-ap: fix two problems discovered in the
 vfio_ap driver
Message-ID: <20220907191923.57e2d624.pasic@linux.ibm.com>
In-Reply-To: <33b8a9f4-ebe8-d836-807e-7c495c190536@linux.ibm.com>
References: <20220823150643.427737-1-akrowiak@linux.ibm.com>
        <33b8a9f4-ebe8-d836-807e-7c495c190536@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PruSYUulfmdlO4hY4yOFYDUYwiAeDDjy
X-Proofpoint-ORIG-GUID: b-_UUcdNlJ1x72Am3-ny8Al7ALjq3tNU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-07_08,2022-09-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 phishscore=0 impostorscore=0 spamscore=0 mlxlogscore=723
 suspectscore=0 adultscore=0 priorityscore=1501 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209070066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 6 Sep 2022 19:17:50 -0400
Anthony Krowiak <akrowiak@linux.ibm.com> wrote:

> PING?

I'm looking at the series. Expect results soon :D
