Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F775F651B
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 13:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbiJFLTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 07:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiJFLTG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 07:19:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989088992C
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 04:19:05 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 296A29mc020972
        for <kvm@vger.kernel.org>; Thu, 6 Oct 2022 11:19:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=NZCkjhiGcZA3umP4nt6bbQL3QsYYCBDhJbz7OiqMDP0=;
 b=ba0M1LL3kY85ZdoqJy3cPQkTSUi8dd1B76ijJ2bv895W4qvIu3ioYuapi751efGoyjVl
 uXFfQ+rAXvoENpXZM0SoRBEPrPeGwby9eLGjuHucp7T9MgLb5j6fV0StPnoMwI5AfxDg
 2hoNDFsF6HdDN8IqA0it7JWctY8xWuXsAAosZ95FQN/XryEpgq6FrJbFDef4c5NFdSN3
 rlnB5vz26R6XMzLRSdrfAClM4iiWW4eRGwRGSbPdsODbLghkoJRYnxFV6HGhL2at1sdW
 DDVl8kXHZ1D9MiCIIf7MHP+QZP7UW5UsGzGTsfU4aEAZaLQFeDuB6CiAxO5+/uT+wM3z nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k1u9xw6ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 11:19:05 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 296BI66a010898
        for <kvm@vger.kernel.org>; Thu, 6 Oct 2022 11:19:04 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k1u9xw6sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Oct 2022 11:19:04 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 296B756o006177;
        Thu, 6 Oct 2022 11:19:02 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3jxcthw3tu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Oct 2022 11:19:01 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 296BJSjP43647268
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Oct 2022 11:19:28 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3E0411C04A;
        Thu,  6 Oct 2022 11:18:58 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7519611C052;
        Thu,  6 Oct 2022 11:18:58 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.242])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  6 Oct 2022 11:18:58 +0000 (GMT)
Date:   Thu, 6 Oct 2022 13:18:56 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 0/2] s390x: Add exit time test
Message-ID: <20221006131856.430dfc6a@p-imbrenda>
In-Reply-To: <20220901150956.1075828-1-nrb@linux.ibm.com>
References: <20220901150956.1075828-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: I_IE4sVgyFklkuPgr11KGdManHrOKqMF
X-Proofpoint-ORIG-GUID: 2mMY2NgUy706301zcWGbxSouwks7oAw1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_05,2022-10-06_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 suspectscore=0 adultscore=0 spamscore=0 bulkscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=990 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210060066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  1 Sep 2022 17:09:54 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> v1->v2:
> ---
> * add missing cc clobber, fix constraints for get_clock_us() (thanks
>   Thomas)
> * avoid array and use pointer to const char* (thanks Thomas)
> * add comment why testing nop makes sense (thanks Thomas)
> * rework constraints and clobbers (thanks Thomas)
> 
> Sometimes, it is useful to measure the exit time of certain instructions
> to e.g. identify performance regressions in instructions emulated by the
> hypervisor.
> 
> This series adds a test which executes some instructions and measures
> their execution time. Since their execution time depends a lot on the
> environment at hand, all tests are reported as PASS currently.
> 
> The point of this series is not so much the instructions which have been
> chosen here (but your ideas are welcome), but rather the general
> question whether it makes sense to have a test like this in
> kvm-unit-tests.

perhaps it makes sense to merge this patch series with your other one,
"s390x: Add migration test for guest TOD clock"

they both concern timing and reshuffling around and/or fixing timing
functions

> 
> Nico Boehr (2):
>   lib/s390x: time: add wrapper for stckf
>   s390x: add exittime tests
> 
>  lib/s390x/asm/time.h |  11 +-
>  s390x/Makefile       |   1 +
>  s390x/exittime.c     | 255 +++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg  |   4 +
>  4 files changed, 270 insertions(+), 1 deletion(-)
>  create mode 100644 s390x/exittime.c
> 

