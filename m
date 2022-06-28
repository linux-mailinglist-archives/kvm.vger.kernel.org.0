Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5172F55CCF6
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245330AbiF1JDx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 05:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234531AbiF1JDv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 05:03:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B455911144;
        Tue, 28 Jun 2022 02:03:50 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25S8hv0b021734;
        Tue, 28 Jun 2022 09:03:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=EsjfSYc3Ykvoarlegm0oLfBwEtbmBAHBL2pvMklrxsQ=;
 b=KTdE7fe1vVrFTEb6XlC13DPpAHFyBYBU1UFLvkvQ8gWg4a2cDuMeimJC/oG0kqfinAY7
 Ai75gX876Yk2wVrnzl/ICQ8Y5FEHbo6/JaiTuAU++JazVwT9+HUP/Y2oQyLlCDz3Ntdg
 ceFJs2j+pl3eDJM9Yj3G01gf+zOYRjcr6sONpJISSt7JCHm5Cr/DnzWsDZH8d9audafb
 +MO57ZbUUd6xGBTnEdbUojK3lgqmYGZKf0ERVHVGUkhkzmmnkKL0Cul3FySFwjYIGGvH
 f1fwT33ttMCwv/lQRaFx3ixxbW4DGRqlLjExuY1cG5nuGIY+TzOoqilKjvhNzB6brtRx oA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gyxcwrhd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 09:03:50 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25S8i9u0022190;
        Tue, 28 Jun 2022 09:03:49 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gyxcwrhc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 09:03:49 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25S8oeSV024113;
        Tue, 28 Jun 2022 09:03:47 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3gwsmhucy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 09:03:47 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25S93iUN23003630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 09:03:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3421D52050;
        Tue, 28 Jun 2022 09:03:44 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id EC0905204E;
        Tue, 28 Jun 2022 09:03:43 +0000 (GMT)
Date:   Tue, 28 Jun 2022 11:03:42 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2] s390x/intercept: Test invalid prefix
 argument to SET PREFIX
Message-ID: <20220628110342.5b83f459@p-imbrenda>
In-Reply-To: <20220627152412.2243255-1-scgl@linux.ibm.com>
References: <20220627152412.2243255-1-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VLYaAqdk1lQ0UbUaLJx9LimrOT7_TxLt
X-Proofpoint-GUID: yG7TQc7NUa2qRtu1UAM9CwGX_pbRSQDt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_09,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 bulkscore=0 phishscore=0 spamscore=0
 clxscore=1015 malwarescore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280037
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Jun 2022 17:24:11 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> According to the architecture, SET PREFIX must try to access the new
> prefix area and recognize an addressing exception if the area is not
> accessible.
> Test that the exception occurs when we try to set a prefix higher
> than the available memory.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

thanks, queued

> ---
> 
> v1 -> v2
>  * report skip if we're running with too much memory (thanks Claudio)
> 
> 
>  s390x/intercept.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/s390x/intercept.c b/s390x/intercept.c
> index 86e57e11..54bed5a4 100644
> --- a/s390x/intercept.c
> +++ b/s390x/intercept.c
> @@ -74,6 +74,22 @@ static void test_spx(void)
>  	expect_pgm_int();
>  	asm volatile(" spx 0(%0) " : : "r"(-8L));
>  	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
> +
> +	new_prefix = get_ram_size() & 0x7fffe000;
> +	if (get_ram_size() - new_prefix < 2 * PAGE_SIZE) {
> +		expect_pgm_int();
> +		asm volatile("spx	%0 " : : "Q"(new_prefix));
> +		check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
> +
> +		/*
> +		 * Cannot test inaccessibility of the second page the same way.
> +		 * If we try to use the last page as first half of the prefix
> +		 * area and our ram size is a multiple of 8k, after SPX aligns
> +		 * the address to 8k we have a completely accessible area.
> +		 */
> +	} else {
> +		report_skip("inaccessible prefix area");
> +	}
>  }
>  
>  /* Test the STORE CPU ADDRESS instruction */
> 
> base-commit: 110c69492b53f0070e1bbce986fb635e72a423b4

