Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D8B52A55E
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 16:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349422AbiEQOxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 10:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349425AbiEQOxX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 10:53:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF9C5007C;
        Tue, 17 May 2022 07:53:02 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HEJcWm026044;
        Tue, 17 May 2022 14:53:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=6H/FBRfBZN80h5ovzXpTVaodLe/u85knV9Mzl/ezOKs=;
 b=dumlG0KgEt0qi/kOBsiOgbS6fW1OqrEGxugdflf4eC8lmO2fRasSJqO2YXlBWmBEHXnI
 DKV538dGsUb1vMlDqz/UQkHlFwdyz+nU5fysr1hIllnPAPQVOHJPzfV7/cNF3CNmTHB7
 HZYTawO68OYQsK4K5q7qbGsw9RFc7lQxdgPsr8Asy85+QQqxmZR+Hn9IHNkVG8ZWRj9z
 vbnZQouaudy5FQ+qmXQF0VUbxO5g/L7kc///srSItm3vPQwkuuCo6pasnjodQ4Pz15Dv
 7TwFt8ATOZGBO3Gpi5TYc3UmCf+Oo3jHovN6orNp3Kw+3che7KhpamzPCc2lKAQzGRYF yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4dcdrtsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 14:53:01 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24HEKUl6028854;
        Tue, 17 May 2022 14:53:01 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4dcdrtrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 14:53:01 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HEnm2A029377;
        Tue, 17 May 2022 14:52:59 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3g2429cda3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 14:52:59 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HEquuT49807850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 14:52:56 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBD9852050;
        Tue, 17 May 2022 14:52:55 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B23975204F;
        Tue, 17 May 2022 14:52:55 +0000 (GMT)
Date:   Tue, 17 May 2022 16:52:53 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 4/4] s390x: Test effect of storage
 keys on diag 308
Message-ID: <20220517165253.46799a10@p-imbrenda>
In-Reply-To: <20220517115607.3252157-5-scgl@linux.ibm.com>
References: <20220517115607.3252157-1-scgl@linux.ibm.com>
        <20220517115607.3252157-5-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: T4OnAvUGXCr_lKT0mOiaq4Q3s1lSJn49
X-Proofpoint-ORIG-GUID: -iFjp2mLaR6VD6f412aPeDptKJayr3Ka
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 phishscore=0 mlxscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0
 adultscore=0 spamscore=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170089
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 May 2022 13:56:07 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> Test that key-controlled protection does not apply to diag 308.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>  s390x/skey.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/s390x/skey.c b/s390x/skey.c
> index 60ae8158..c2d28ffd 100644
> --- a/s390x/skey.c
> +++ b/s390x/skey.c
> @@ -285,6 +285,31 @@ static void test_store_cpu_address(void)
>  	report_prefix_pop();
>  }
>  
> +static void test_diag_308(void)
> +{
> +	uint16_t response;
> +	uint32_t (*ipib)[1024] = (void *)pagebuf;

why not just uint32_t *ipib = (void *)pagebuf; ?

> +
> +	report_prefix_push("DIAG 308");
> +	(*ipib)[0] = 0; /* Invalid length */

then you can simply do:

ipib[0] = 0;

> +	set_storage_key(ipib, 0x28, 0);
> +	/* key-controlled protection does not apply */
> +	asm volatile (
> +		"lr	%%r2,%[ipib]\n\t"
> +		"spka	0x10\n\t"
> +		"diag	%%r2,%[code],0x308\n\t"
> +		"spka	0\n\t"
> +		"lr	%[response],%%r3\n"
> +		: [response] "=d" (response)
> +		: [ipib] "d" (ipib),
> +		  [code] "d" (5)
> +		: "%r2", "%r3"
> +	);
> +	report(response == 0x402, "no exception on fetch, response: invalid IPIB");
> +	set_storage_key(ipib, 0x00, 0);
> +	report_prefix_pop();
> +}
> +
>  /*
>   * Perform CHANNEL SUBSYSTEM CALL (CHSC)  instruction while temporarily executing
>   * with access key 1.
> @@ -714,6 +739,7 @@ int main(void)
>  	test_chg();
>  	test_test_protection();
>  	test_store_cpu_address();
> +	test_diag_308();
>  	test_channel_subsystem_call();
>  
>  	setup_vm();

