Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7DF7927C2
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 18:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237867AbjIEQFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 12:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354714AbjIENpx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 09:45:53 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0C5191;
        Tue,  5 Sep 2023 06:45:45 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385Dd2Z5009902;
        Tue, 5 Sep 2023 13:45:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sOrf9bMG9yQu4ljAz6PSN8Fr/regDOPoMhzl1jU+Rv8=;
 b=kk2HDDB4feJsTbyIfSlMW/VE0IokzAwF79knMb2J8NEj5+y/50hIyGSufq+UkA8yruBz
 /4lZ0sEEdujt53TfERZMJrrelSHkHakb9wvMh5Al00Si+a5iEJ96KxI8m7F/QY87ni7C
 6dq+VgqcqOaEwQFcJsflJFJODAqIIJ7kFJT5CK5e6mgDW8p1ZyCgx9fvLrbojCQNV+aG
 qt/UUX+AF/VHawN06TmNIgA7D3yW+LRjKj/rYoV8m8YwqYL+Vm3qKuOorLWuW/pbseG7
 ZDDf3K9sxK8WMEhF3+BoSs5N1YJT3amhCu7nXgmis1vbFvJddb+QiMbGJqLVfj7kX8tG hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sx44vjhqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Sep 2023 13:45:44 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 385DdFN5011557;
        Tue, 5 Sep 2023 13:45:44 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sx44vjhq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Sep 2023 13:45:44 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 385BGecI001603;
        Tue, 5 Sep 2023 13:45:43 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3svfcskagh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Sep 2023 13:45:43 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 385Djepu38273356
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Sep 2023 13:45:40 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9C9620040;
        Tue,  5 Sep 2023 13:45:40 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 745632004B;
        Tue,  5 Sep 2023 13:45:40 +0000 (GMT)
Received: from [9.171.57.58] (unknown [9.171.57.58])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  5 Sep 2023 13:45:40 +0000 (GMT)
Message-ID: <d6a62a3d-b15f-e1a7-c07e-00a599f5f041@linux.ibm.com>
Date:   Tue, 5 Sep 2023 15:45:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230904082318.1465055-1-nrb@linux.ibm.com>
 <20230904082318.1465055-8-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v6 7/8] s390x: add a test for SIE without
 MSO/MSL
In-Reply-To: <20230904082318.1465055-8-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eLHRHoMlEPdCwKfrwBGAgqmb2LWAdlt0
X-Proofpoint-GUID: lM1ehDRDQdcuQB5TSVyCwTJLUaP6_rd1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_10,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 adultscore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050118
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/4/23 10:22, Nico Boehr wrote:
> Since we now have the ability to run guests without MSO/MSL, add a test
> to make sure this doesn't break.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
[...]
> diff --git a/s390x/snippets/c/sie-dat.c b/s390x/snippets/c/sie-dat.c
> new file mode 100644
> index 000000000000..f29887643df9
> --- /dev/null
> +++ b/s390x/snippets/c/sie-dat.c
> @@ -0,0 +1,54 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Snippet used by the sie-dat.c test to verify paging without MSO/MSL
> + *
> + * Copyright (c) 2023 IBM Corp
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +#include <stddef.h>
> +#include <inttypes.h>
> +#include <string.h>
> +#include <asm-generic/page.h>

Please include libcflat.h and remove the standard library includes.

> +#include "sie-dat.h"
> +
[...]
> diff --git a/s390x/snippets/c/sie-dat.h b/s390x/snippets/c/sie-dat.h
> new file mode 100644
> index 000000000000..a3a1c38861fa
> --- /dev/null
> +++ b/s390x/snippets/c/sie-dat.h
> @@ -0,0 +1,5 @@
> +/* keep in sync with TEST_PAGE_COUNT in s390x/snippets/c/sie-dat.c */
> +#define GUEST_TEST_PAGE_COUNT 10
> +
> +/* keep in sync with TOTAL_PAGE_COUNT in s390x/snippets/c/sie-dat.c */
> +#define GUEST_TOTAL_PAGE_COUNT 256

You should remove the comments now that we can include this header in 
the test.

> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 68e119e4fcaa..184658ff7d8d 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -247,3 +247,6 @@ file = topology.elf
>   [topology-2]
>   file = topology.elf
>   extra_params = -cpu max,ctop=on -smp sockets=31,cores=8,maxcpus=248  -append '-sockets 31 -cores 8'
> +
> +[sie-dat]
> +file = sie-dat.elf

