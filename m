Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96F2851D3E5
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 11:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390349AbiEFJDp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 05:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390346AbiEFJDh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 05:03:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5569166AED
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 01:59:50 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2468HEU0040710;
        Fri, 6 May 2022 08:59:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6zJ+cTe2e4M4qQBq/K8Xll46shNXHZHpKTBj61qET4A=;
 b=IUPhNXCoMH85XY+TFhCzdCKw6IOXaaajjHiG1p3vRONcZfs8uLfIEV7+MO2jUrFHd6Dw
 o5rDZMZQIJTTXgn/TroxJLLcNFT8MCm3CpEXD+0p0LZqtcWwWq2QrhYRu52ioQU1fESD
 HOoCanviC66ODL7rRQZi0tGuCwCB902W1aHCXxQdOJqvhINH8t0N0btHyKZdhJWNBhIY
 iS+X58RIJu9TRNjZmtL22k1v0ejGZyVvQgXGApHJWlU/nj50+/J2Xb1Kg2GKHgGI547W
 J7Vi2jxLP+IQd9I+M71B9fEh54vDNeZ3EPLQBCBrZoXkndmJlFDjUU7WxkAx39do5Wdi 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw0178r7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 08:59:43 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2468guHE007258;
        Fri, 6 May 2022 08:59:43 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw0178r6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 08:59:42 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2468qED9026073;
        Fri, 6 May 2022 08:59:40 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3fttcj41a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 08:59:40 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2468xbnN34013584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 May 2022 08:59:37 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D22DAE051;
        Fri,  6 May 2022 08:59:37 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7691BAE045;
        Fri,  6 May 2022 08:59:36 +0000 (GMT)
Received: from [9.171.62.79] (unknown [9.171.62.79])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 May 2022 08:59:36 +0000 (GMT)
Message-ID: <b10d70da-6548-328d-b7ed-f4936f16545b@linux.ibm.com>
Date:   Fri, 6 May 2022 11:03:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v5 9/9] s390x/pci: reflect proper maxstbl for groups of
 interpreted devices
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     farman@linux.ibm.com, kvm@vger.kernel.org, schnelle@linux.ibm.com,
        cohuck@redhat.com, richard.henderson@linaro.org, thuth@redhat.com,
        qemu-devel@nongnu.org, pasic@linux.ibm.com,
        alex.williamson@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        david@redhat.com, borntraeger@linux.ibm.com
References: <20220404181726.60291-1-mjrosato@linux.ibm.com>
 <20220404181726.60291-10-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220404181726.60291-10-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _RfjCH4bQSExgPv5WMXIobvmIjwSjEpq
X-Proofpoint-ORIG-GUID: CKAl7fR1Reo6w53T0xlNyFqLKIXTVDBQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_03,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205060045
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
