Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5F965E672
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 09:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbjAEIHI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 03:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjAEIHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 03:07:05 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDF7544F3;
        Thu,  5 Jan 2023 00:07:05 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3057kGWt005426;
        Thu, 5 Jan 2023 08:06:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=em0hYjDj0abFWoDkUwKCbrdF0k41o839F18VwMFiLbQ=;
 b=r5SbpYYMV7SfkmKmBgrnFjKFuMAC3R7tY8OfcVgbKHy5sBghZmuk5jiky1sc4AuE4bbL
 wfM5lrCKuQE6qW2wwEqM37nEstHy7n0ACWgNED9hPp0r4S8yO5GwcvjTCAakDODz7b1z
 zSQsC6GsHgnBd9zEeFYtgDrOMJFq+yU2f2sEBV9ZMWyWYd7e6bnSBrpzPJrJTEC5ha2x
 BOpAauydOjlX8dI0VD1aIhTtMYeRrm6IPGSVWO8ehDFb/fV/wJpBgocd96Dvqw+Emo8p
 mDpZjVHLC4P3T5/CSA+a5WDqgAnN++VXbe7hWgh2b4XjgW124lvm5GaFLUxCix2HC4Su YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mwtf18ejp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 08:06:34 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3057vaZ9013612;
        Thu, 5 Jan 2023 08:06:34 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mwtf18ej1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 08:06:34 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30518CNv008371;
        Thu, 5 Jan 2023 08:06:32 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3mtcbfmqxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 08:06:32 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30586SbA24510954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Jan 2023 08:06:28 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A3F720043;
        Thu,  5 Jan 2023 08:06:28 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFE4420040;
        Thu,  5 Jan 2023 08:06:27 +0000 (GMT)
Received: from osiris (unknown [9.171.68.186])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu,  5 Jan 2023 08:06:27 +0000 (GMT)
Date:   Thu, 5 Jan 2023 09:06:26 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@meta.com, rostedt@goodmis.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH rcu 06/27] arch/s390/kvm: Remove "select SRCU"
Message-ID: <Y7aFAqmgF4eu6SNH@osiris>
References: <20230105003759.GA1769545@paulmck-ThinkPad-P17-Gen-1>
 <20230105003813.1770367-6-paulmck@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105003813.1770367-6-paulmck@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bFKzjL5BSCYr32RZTpDpfBd6VwtgBcQx
X-Proofpoint-ORIG-GUID: YJxYUOCrB21-BA5binzfh_-OHRIhi9Jk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_02,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 phishscore=0 mlxlogscore=361 impostorscore=0 spamscore=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301050066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 04, 2023 at 04:37:52PM -0800, Paul E. McKenney wrote:
> Now that the SRCU Kconfig option is unconditionally selected, there is
> no longer any point in selecting it.  Therefore, remove the "select SRCU"
> Kconfig statements.
> 
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: <kvm@vger.kernel.org>
> Cc: <linux-s390@vger.kernel.org>
> ---
>  arch/s390/kvm/Kconfig | 1 -
>  1 file changed, 1 deletion(-)

Acked-by: Heiko Carstens <hca@linux.ibm.com>
