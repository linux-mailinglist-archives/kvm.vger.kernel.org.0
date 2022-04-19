Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343D1507A79
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 21:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356090AbiDSTsr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 15:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242801AbiDSTsq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 15:48:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B69012A93
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 12:46:03 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23JHA1IB023882;
        Tue, 19 Apr 2022 19:45:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3mPYrZiCFsGlzZPvWuAMQcQYvBhkD+0kMPJg2kAgOgo=;
 b=og7BIt1wldmUNDluX2OVE8wttBJ3qu9ZSfCdS59VUqVErxoUppAIgvCCb3prUM3qA4cQ
 0H9vu8L23zPZpsf7Z8AUEPKKPLFcOAkA4bZCa92MhLwG+0hvi/NH3XSSoQRQ+3mZCwD1
 N7/KqLGoWt1EA9NG/jLSAfs7VEWUvtYUspoIm0EZHhIJx0gSLKT7tltzB8Yo7KMYpGBH
 hEB0Yy1xRRbdL7zS/utssmQVxK0qKROMF5C8JgaDkwgOvLFpB7IvMOaSJwQ8nRW2fk3R
 +jzmMMdL1clIoi6cOc4zKHOkwPM1fbf09Nusd+4cHD+L+ByiBzRApy9MFDZ320CXhnWm fA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg79f1yfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 19:45:54 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23JJghNA029043;
        Tue, 19 Apr 2022 19:45:53 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg79f1yep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 19:45:53 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23JJOHcR014699;
        Tue, 19 Apr 2022 19:45:51 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3ffvt9bj5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 19:45:51 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23JJX2nV31719786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 19:33:02 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2535D4203F;
        Tue, 19 Apr 2022 19:45:48 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E4E442041;
        Tue, 19 Apr 2022 19:45:47 +0000 (GMT)
Received: from [9.171.88.57] (unknown [9.171.88.57])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Apr 2022 19:45:47 +0000 (GMT)
Message-ID: <a99e5d50-3bd0-f45f-53e3-84520410b846@linux.ibm.com>
Date:   Tue, 19 Apr 2022 21:49:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v5 9/9] s390x/pci: reflect proper maxstbl for groups of
 interpreted devices
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220404181726.60291-1-mjrosato@linux.ibm.com>
 <20220404181726.60291-10-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220404181726.60291-10-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Wp5jgYALSQbgfdG6OMqaq9kGRBtDorm1
X-Proofpoint-ORIG-GUID: p8azPYExsuIhhV1rG4TyL7t_4rLMIFTq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-19_07,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 bulkscore=0 phishscore=0 clxscore=1015 malwarescore=0 spamscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204190110
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/4/22 20:17, Matthew Rosato wrote:
> The maximum supported store block length might be different depending
> on whether the instruction is interpretively executed (firmware-reported
> maximum) or handled via userspace intercept (host kernel API maximum).
> Choose the best available value during group creation.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>

> ---
>   hw/s390x/s390-pci-vfio.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
> index 985980f021..212dd053f7 100644
> --- a/hw/s390x/s390-pci-vfio.c
> +++ b/hw/s390x/s390-pci-vfio.c
> @@ -213,7 +213,11 @@ static void s390_pci_read_group(S390PCIBusDevice *pbdev,
>           resgrp->msia = cap->msi_addr;
>           resgrp->mui = cap->mui;
>           resgrp->i = cap->noi;
> -        resgrp->maxstbl = cap->maxstbl;
> +        if (pbdev->interp && hdr->version >= 2) {
> +            resgrp->maxstbl = cap->imaxstbl;
> +        } else {
> +            resgrp->maxstbl = cap->maxstbl;
> +        }
>           resgrp->version = cap->version;
>           resgrp->dtsm = ZPCI_DTSM;
>       }
> 

-- 
Pierre Morel
IBM Lab Boeblingen
