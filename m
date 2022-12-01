Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 096F663ED46
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 11:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbiLAKJq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 05:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbiLAKJX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 05:09:23 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714291B1C5
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 02:09:21 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B19n9hL010915
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 10:09:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gN4PXV3HhIYdQK+TPakernky33kf6KJ0i71sJqMGM78=;
 b=Ycjcpm31keSIbjC3SD8gaV7iPNDXGb0wbsYnFAtEPnP8XdpGDJHNGjQa6bakqvIH4mrc
 2Qn7WZcjBXPHVxAo6UoDc2PXh61NBCvTTjprYxlbVPwpzEhnGBdOryfySjsT/MAZaaCw
 90II4qhbMdWiu5DXezyHGssLNZ6lB2wxAf4962lCoHaocMPLNV3rxlhZPIO8iOHGWb+2
 JHkzadwWC3GwCkFPeFHH6dO9y7Y+Fcc5/S2JWNn571nEL6cT9+GnGl9VCyuOmIE2YIOf
 Sq1rwdJ7HKE38YFVZe2Lo9N7TSpPW7so6MeJpEAOpg8OvqS3rlu6JlS2N+RBElYHQa9l Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6sym8er4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 10:09:20 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B19rnPH028148
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 10:09:20 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6sym8eqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 10:09:20 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B1A6VXl023990;
        Thu, 1 Dec 2022 10:09:18 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3m3a2hy63p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 10:09:18 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B1A9Esw26477292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Dec 2022 10:09:14 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3F9AAE051;
        Thu,  1 Dec 2022 10:09:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78265AE045;
        Thu,  1 Dec 2022 10:09:14 +0000 (GMT)
Received: from [9.152.224.253] (unknown [9.152.224.253])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Dec 2022 10:09:14 +0000 (GMT)
Message-ID: <d95a4761-422d-7074-d3ca-8acc98997265@linux.ibm.com>
Date:   Thu, 1 Dec 2022 11:09:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [kvm-unit-tests PATCH v3 0/2] lib: s390x: add PSW and
 PSW_WITH_CUR_MASK macros
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     nrb@linux.ibm.com, seiden@linux.ibm.com, scgl@linux.ibm.com,
        thuth@redhat.com
References: <20221130154038.70492-1-imbrenda@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20221130154038.70492-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: W94nPDi0r-vVqq-IwauKj_3vzHg5bj4u
X-Proofpoint-GUID: jereYfK7QY7iqsWWuhXJ_dvQwr18iCl0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_04,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 mlxscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010070
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/22 16:40, Claudio Imbrenda wrote:
> Since a lot of code starts new CPUs using the current PSW mask, add two
> macros to streamline the creation of generic PSWs and PSWs with the
> current program mask.
> 
> Update the existing code to use the newly introduced macros.

Series:
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> 
> 
> v2->v3
> * rename PSW_CUR_MASK to PSW_WITH_CUR_MASK
> 
> Claudio Imbrenda (2):
>    lib: s390x: add PSW and PSW_WITH_CUR_MASK macros
>    s390x: use the new PSW and PSW_WITH_CUR_MASK macros
> 
>   lib/s390x/asm/arch_def.h |  4 +++
>   s390x/adtl-status.c      | 24 +++---------------
>   s390x/firq.c             |  5 +---
>   s390x/migration.c        |  6 +----
>   s390x/skrf.c             |  7 +-----
>   s390x/smp.c              | 53 +++++++++-------------------------------
>   s390x/uv-host.c          |  5 +---
>   7 files changed, 23 insertions(+), 81 deletions(-)
> 

