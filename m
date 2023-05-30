Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47433716749
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 17:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjE3Pk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 11:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjE3Pkz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 11:40:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A841C5;
        Tue, 30 May 2023 08:40:54 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UFdPHa018125;
        Tue, 30 May 2023 15:40:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=iCIkmtgM88mWH8lRvjTLr1ymQtyEbbJ3B8adCVY/hEI=;
 b=PuUmIORdTpU6zAMRCOXGItubO9UTrVWLe0FwRsS9F/cJA2nxnrqeSSBKGVWWrSzcAf9w
 w+91QNvn4z/V5auAU+LZBEqts19dul5DDwxISxBcOqbnKwIAebJagPp9jvL6IfHJes7P
 a5RGL77GAyoIugaIptdBD8+ez/Xai8ocpIaIjb5giK8Zq4xGx1G2WnT5Z0kJw6aPb7oi
 mqKEqpdF/UsQk/LLVbP31pl96KU+dTnXdgF75TVONnITQ5vJ1LzDZys/E2gvLloGQCkr
 ionUuxY4tcaJpKKJfQ6dJpfAcC50Teut4fe1PLn5p5xNxuGptD1fu44T8qRcXyYuoHM4 gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwbst7g58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 15:40:53 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34UFdiKP020651;
        Tue, 30 May 2023 15:40:52 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwbst7g3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 15:40:52 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34U9UlCL020426;
        Tue, 30 May 2023 15:35:50 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3qu9g59a37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 15:35:50 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34UFZk8f37093900
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 May 2023 15:35:46 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 723F720043;
        Tue, 30 May 2023 15:35:46 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C0BA20040;
        Tue, 30 May 2023 15:35:46 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 30 May 2023 15:35:46 +0000 (GMT)
Date:   Tue, 30 May 2023 17:35:44 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        nrb@linux.ibm.com, nsg@linux.ibm.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 2/2] s390x: sclp: Implement
 SCLP_RC_INSUFFICIENT_SCCB_LENGTH
Message-ID: <20230530173544.378a63c6@p-imbrenda>
In-Reply-To: <20230530125243.18883-3-pmorel@linux.ibm.com>
References: <20230530125243.18883-1-pmorel@linux.ibm.com>
        <20230530125243.18883-3-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uHXi4Ctt2ZpbbsBJGZ9a4qntP4Xq1iNv
X-Proofpoint-GUID: egfCoHI-lJWB85cEcEqFdvfBPeZPbMju
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_11,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300124
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 30 May 2023 14:52:43 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> If SCLP_CMDW_READ_SCP_INFO fails due to a short buffer, retry
> with a greater buffer.

the idea is good, but I wonder if the code can be simplified (see below)

> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/sclp.c | 58 +++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 50 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index 34a31da..9d51ca4 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -17,13 +17,14 @@
>  #include "sclp.h"
>  #include <alloc_phys.h>
>  #include <alloc_page.h>
> +#include <asm/facility.h>
>  
>  extern unsigned long stacktop;
>  
>  static uint64_t storage_increment_size;
>  static uint64_t max_ram_size;
>  static uint64_t ram_size;
> -char _read_info[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
> +char _read_info[2 * PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));

this is ok ^

[skip everything else]

>  void sclp_read_info(void)
>  {
> -	sclp_read_scp_info((void *)_read_info, SCCB_SIZE);

	sclp_read_scp_info((void *)_read_info,
		test_facility(140) ? sizeof(_read_info) : SCCB_SIZE;

> +	sclp_read_scp_info((void *)_read_info);
>  	read_info = (ReadInfo *)_read_info;
>  }
>  

