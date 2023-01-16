Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D7E66CEEB
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 19:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbjAPSgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 13:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbjAPSgT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 13:36:19 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0F52CC58
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 10:25:31 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GHp1qo025856
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 18:25:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=VybrEBGUIDZsanGqoYi+98juflR5NRNQaeHXM1oLkW0=;
 b=DSWpW8IfCk4G0fYiUuQAv4469gzNzKOHPx5FNQpCw5g1qECThK7bdYDsUYdu5pPuw7Xi
 s8LQK6GRfAJjLxtBq/2b+0N9CiPtxKmm6ZqmLsE3XNJe7PyihyUb16Vra+n1aBGqq4Td
 Kfbw5DfhRj1gHrv+zuQum3YSIXQBRqr9cXCEBPg3aKaswFMDalx2Nxa1lisrRjr4cgqj
 kwnr22ODzoDz5XaO4m80JeIs+NTi9BEdkx/CoAYBVt1wddgzOYnx3LAvYi3tSfIQOIz9
 K/ho9CQvlPJivg2pN5gRHDBuHEeu59lD6BgO/C2jVcVlUTwFU0sLSdB6hGj/GMncNGJz VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5bbh0k1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 18:25:30 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30GHsM9m005762
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 18:25:30 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5bbh0k1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 18:25:30 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30GDZIZi016548;
        Mon, 16 Jan 2023 18:25:28 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3n3m16j0w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 18:25:28 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30GIPODm48300502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 18:25:24 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94F3120049;
        Mon, 16 Jan 2023 18:25:24 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5513920040;
        Mon, 16 Jan 2023 18:25:24 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 18:25:24 +0000 (GMT)
Date:   Mon, 16 Jan 2023 19:20:27 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 5/9] s390x/Makefile: remove unused
 include path
Message-ID: <20230116192027.27fa09cb@p-imbrenda>
In-Reply-To: <20230116175757.71059-6-mhartmay@linux.ibm.com>
References: <20230116175757.71059-1-mhartmay@linux.ibm.com>
        <20230116175757.71059-6-mhartmay@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vx459DaniN5RLJWecvmNaBs0PEbldann
X-Proofpoint-GUID: bAmOKr6VkZ44W9YzM6QRdtZojOJZmwjw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_15,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0
 mlxlogscore=973 clxscore=1015 lowpriorityscore=0 adultscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160135
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Jan 2023 18:57:53 +0100
Marc Hartmayer <mhartmay@linux.ibm.com> wrote:

> `lib` seems to be unused therefore let's remove it.
> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>

this definitely needs to be merged into the previous patch

> ---
>  s390x/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 032524373593..31f6db11213d 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -63,7 +63,7 @@ test_cases: $(tests)
>  test_cases_binary: $(tests_binary)
>  test_cases_pv: $(tests_pv_binary)
>  
> -INCLUDE_PATHS = $(SRCDIR)/lib $(SRCDIR)/lib/s390x lib
> +INCLUDE_PATHS = $(SRCDIR)/lib $(SRCDIR)/lib/s390x
>  CPPFLAGS = $(addprefix -I,$(INCLUDE_PATHS))
>  
>  CFLAGS += -std=gnu99

