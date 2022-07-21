Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC3E57CA90
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 14:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbiGUMUc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 08:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiGUMUa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 08:20:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBD2E0FD;
        Thu, 21 Jul 2022 05:20:30 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LBtvEu003353;
        Thu, 21 Jul 2022 12:20:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=79cTzjUU8arfxdY9zxEsif8YuGILU6MGWmZtB7deu5A=;
 b=P8YsQRsci8SxKxc/bnbKNlCFvmeOTAUC0xQAjLf3LGalK3Hmo3d/+8CiwSs5ztUdCs8r
 4qb+GLfSYC/wCLSskyd9hdYas9O09CXCoFyjuOVJSBb6sOhcMN1Ih0p2buJUgDwVIFT8
 QE7Ro8/LLz8F26YYfU+ZfbHo2B1OI+FCxWlMpbB+dRtJitmB9exRwHUineSjZB6CAec9
 n74sn3uS8doS8lcvihGqjMNjad4TCu738U17ixrFVEGcDmUOpItvU9khPLHcVwF/tJCo
 y6+w9bmOUqqmIGtEJrqnEVZ0er7o9ImLcbPwaXHV2JxYBvqj1NodEIyv/gju1S6edVEE BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf6bs0usf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 12:20:22 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LBv9VJ010395;
        Thu, 21 Jul 2022 12:20:22 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf6bs0ur7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 12:20:22 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LC5WNN026459;
        Thu, 21 Jul 2022 12:20:19 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3hbmy8n8vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 12:20:19 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LCKH3Q24314180
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 12:20:17 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26B98A405C;
        Thu, 21 Jul 2022 12:20:17 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD314A4054;
        Thu, 21 Jul 2022 12:20:16 +0000 (GMT)
Received: from [9.145.177.237] (unknown [9.145.177.237])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 12:20:16 +0000 (GMT)
Message-ID: <88ec8a24-69ac-d57f-797e-31af250dcd17@linux.ibm.com>
Date:   Thu, 21 Jul 2022 14:20:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] s390x: intercept: fence one test when using TCG
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, qemu-s390x@nongnu.org
Cc:     thuth@redhat.com
References: <20220721105641.131710-1-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220721105641.131710-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ruy9XTj7T_jzTcvJXa0xN1_rbGM2NTDI
X-Proofpoint-ORIG-GUID: VwfvUTsB7jaMA73jA3Xfmetv7r9s5wsj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_16,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 spamscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210048
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/21/22 12:56, Claudio Imbrenda wrote:
> Qemu commit f8333de2793 ("target/s390x/tcg: SPX: check validity of new prefix")
> fixes a TCG bug discovered with a new testcase in the intercept test.
> 
> The gitlab pipeline for the KVM unit tests uses TCG and it will keep
> failing every time as long as the pipeline uses a version of Qemu
> without the aforementioned patch.
> 
> Fence the specific testcase for now. Once the pipeline is fixed, this
> patch can safely be reverted.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   s390x/intercept.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/s390x/intercept.c b/s390x/intercept.c
> index 54bed5a4..c48818c2 100644
> --- a/s390x/intercept.c
> +++ b/s390x/intercept.c
> @@ -14,6 +14,7 @@
>   #include <asm/page.h>
>   #include <asm/facility.h>
>   #include <asm/time.h>
> +#include <hardware.h>
>   
>   static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
>   
> @@ -76,7 +77,7 @@ static void test_spx(void)
>   	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
>   
>   	new_prefix = get_ram_size() & 0x7fffe000;
> -	if (get_ram_size() - new_prefix < 2 * PAGE_SIZE) {
> +	if (!host_is_tcg() && (get_ram_size() - new_prefix < 2 * PAGE_SIZE)) {

I'm ok with this if we also do a report_skip() that states that we skip 
because of a QEMU bug which will lead to a SIGABORT.

I don't see an easy way to fence this more precisely. We could pass the 
QEMU version and check it but there are also backports to consider. So 
it's not a one size fits all solution...

>   		expect_pgm_int();
>   		asm volatile("spx	%0 " : : "Q"(new_prefix));
>   		check_pgm_int_code(PGM_INT_CODE_ADDRESSING);

