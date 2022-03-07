Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4714D02FE
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 16:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243811AbiCGPfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 10:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241144AbiCGPfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 10:35:36 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F425D5E6;
        Mon,  7 Mar 2022 07:34:42 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227E0nUK015185;
        Mon, 7 Mar 2022 15:34:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=qbnNa91uNhfOQsKK7p3VGeelGlfv8J0nLnT6NWA3Ta4=;
 b=pyiH/V6Bj5iKfWgDw6E2fhII/ixNMCHg9f/KXPUbOLr8fAfsSrUytFVipchbVSwkzQnE
 RyTlDutmlfhvF+MTzcecCNXlrZZyAtas9eZEY3kU8LMUP5KaBNMX4s/6+eZJepxR7RCA
 6P4onN8VImX+Pvbraqi5mLNVlII0oXQ/d+AK646k8chAyroFiYv975aWt9Ibk2gk/eb8
 RFNMZSmdlIPErPibDwNS03rrYjutkOGBDdJit0lI5f+eEXbDu7DON8afwM0nO7JDHKVY
 de9BqPrJgMrCnY4q5v2AGYph+Z9RGOfKoRQyGZaayWfyAzPiF/kVK52U/BdO2qvf6Z4r zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ene0ph0s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 15:34:40 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 227FGCad011565;
        Mon, 7 Mar 2022 15:34:40 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ene0ph0rx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 15:34:40 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 227FJMZr016885;
        Mon, 7 Mar 2022 15:34:38 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3ekyg94b04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 15:34:38 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 227FYZTF47514042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Mar 2022 15:34:35 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76B37A4054;
        Mon,  7 Mar 2022 15:34:35 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F5C0A4060;
        Mon,  7 Mar 2022 15:34:35 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.106])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Mar 2022 15:34:35 +0000 (GMT)
Date:   Mon, 7 Mar 2022 16:22:52 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests v1 2/6] s390x: smp: Test SIGP RESTART
 against stopped CPU
Message-ID: <20220307162252.682de499@p-imbrenda>
In-Reply-To: <20220303210425.1693486-3-farman@linux.ibm.com>
References: <20220303210425.1693486-1-farman@linux.ibm.com>
        <20220303210425.1693486-3-farman@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nKp156ebS1WxwGIlmzvzKNKb9M-UpEn6
X-Proofpoint-GUID: wHAHsew0pitFBkQy355G2YGCCmQsyrE1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_05,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2203070090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  3 Mar 2022 22:04:21 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> test_restart() makes two smp_cpu_restart() calls against CPU 1.
> It claims to perform both of them against running (operating) CPUs,
> but the first invocation tries to achieve this by calling
> smp_cpu_stop() to CPU 0. This will be rejected by the library.
> 
> Let's fix this by making the first restart operate on a stopped CPU,
> to ensure it gets test coverage instead of relying on other callers.
> 
> Fixes: 166da884d ("s390x: smp: Add restart when running test")
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/smp.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 068ac74d..2f4af820 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -50,10 +50,6 @@ static void test_start(void)
>  	report_pass("start");
>  }
>  
> -/*
> - * Does only test restart when the target is running.
> - * The other tests do restarts when stopped multiple times already.
> - */
>  static void test_restart(void)
>  {
>  	struct cpu *cpu = smp_cpu_from_idx(1);
> @@ -62,8 +58,8 @@ static void test_restart(void)
>  	lc->restart_new_psw.mask = extract_psw_mask();
>  	lc->restart_new_psw.addr = (unsigned long)test_func;
>  
> -	/* Make sure cpu is running */
> -	smp_cpu_stop(0);
> +	/* Make sure cpu is stopped */
> +	smp_cpu_stop(1);
>  	set_flag(0);
>  	smp_cpu_restart(1);
>  	wait_for_flag();

