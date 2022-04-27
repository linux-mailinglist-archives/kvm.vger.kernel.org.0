Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7276351159B
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 13:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbiD0LWP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 07:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232316AbiD0LWK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 07:22:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0066B2E090;
        Wed, 27 Apr 2022 04:18:59 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23R9DVbX009595;
        Wed, 27 Apr 2022 11:18:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=NDYmzBIlBOiLuUjxMTsAv5Z8IRvwuvBue0i3vly4ldc=;
 b=q7Kemb7VTAHV7UKKpV+bZYFd9xCoEQ9rPGFpVM7qbgHANIrdTaH5FyIWP7pUG5ZMB9T3
 mgK3s0kbHb4OASklaANtrQVlk2XtTiG7Xs21r981ChewKcwBqYYEHTYN02d6DaPtVx/M
 URsDUTPK5ca8e7bugf9ufpNXHfUTAqRBoUTIxoZ6wIUu/P44tRf6h6cMD4fFuIiOiTtE
 ZdK//YCwqCVUfOs5wGyWjoR8avHS2M4bqL7JdGEJOTA28n7XhJvek3Klwbw/sUcdMui4
 j3MTvPrXaIz6JRL0kvlsds1Ig+SxbYEIsBv6xH5Qtnr7MYm2RITxHlwKS/FwBoe+ktop ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpv8895ph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 11:18:59 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23RBHJgg024914;
        Wed, 27 Apr 2022 11:18:58 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpv8895p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 11:18:58 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23RB8h1q015022;
        Wed, 27 Apr 2022 11:18:56 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3fm938vm1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 11:18:56 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23RBIrXF58523966
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 11:18:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94BB84C044;
        Wed, 27 Apr 2022 11:18:53 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30B6A4C040;
        Wed, 27 Apr 2022 11:18:53 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.176])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 27 Apr 2022 11:18:53 +0000 (GMT)
Date:   Wed, 27 Apr 2022 13:14:49 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v6 1/3] s390x: Give name to return value
 of tprot()
Message-ID: <20220427131449.61cce697@p-imbrenda>
In-Reply-To: <20220427100611.2119860-2-scgl@linux.ibm.com>
References: <20220427100611.2119860-1-scgl@linux.ibm.com>
        <20220427100611.2119860-2-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jP1PkPPpCk8NldCPyZx8yGESVErEDsjZ
X-Proofpoint-ORIG-GUID: fJ1cEh61NgK8SC3n6iwXBj4927wLAHiA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_03,2022-04-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 phishscore=0 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=791 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204270073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 Apr 2022 12:06:09 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> Improve readability by making the return value of tprot() an enum.
> 
> No functional change intended.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

but see nit below

> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h | 11 +++++++++--
>  lib/s390x/sclp.c         |  6 +++---
>  s390x/tprot.c            | 24 ++++++++++++------------
>  3 files changed, 24 insertions(+), 17 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index bab3c374..46c370e6 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -228,7 +228,14 @@ static inline uint64_t stidp(void)
>  	return cpuid;
>  }
>  
> -static inline int tprot(unsigned long addr, char access_key)
> +enum tprot_permission {
> +	TPROT_READ_WRITE = 0,
> +	TPROT_READ = 1,
> +	TPROT_RW_PROTECTED = 2,
> +	TPROT_TRANSL_UNAVAIL = 3,
> +};
> +
> +static inline enum tprot_permission tprot(unsigned long addr, char access_key)
>  {
>  	int cc;
>  
> @@ -237,7 +244,7 @@ static inline int tprot(unsigned long addr, char access_key)
>  		"	ipm	%0\n"
>  		"	srl	%0,28\n"
>  		: "=d" (cc) : "a" (addr), "a" (access_key << 4) : "cc");
> -	return cc;
> +	return (enum tprot_permission)cc;
>  }
>  
>  static inline void lctlg(int cr, uint64_t value)
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index 33985eb4..b8204c5f 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -198,7 +198,7 @@ int sclp_service_call(unsigned int command, void *sccb)
>  void sclp_memory_setup(void)
>  {
>  	uint64_t rnmax, rnsize;
> -	int cc;
> +	enum tprot_permission permission;
>  
>  	assert(read_info);
>  
> @@ -222,9 +222,9 @@ void sclp_memory_setup(void)
>  	/* probe for r/w memory up to max memory size */
>  	while (ram_size < max_ram_size) {
>  		expect_pgm_int();
> -		cc = tprot(ram_size + storage_increment_size - 1, 0);
> +		permission = tprot(ram_size + storage_increment_size - 1, 0);
>  		/* stop once we receive an exception or have protected memory */
> -		if (clear_pgm_int() || cc != 0)
> +		if (clear_pgm_int() || permission != TPROT_READ_WRITE)
>  			break;
>  		ram_size += storage_increment_size;
>  	}
> diff --git a/s390x/tprot.c b/s390x/tprot.c
> index 460a0db7..8eb91c18 100644
> --- a/s390x/tprot.c
> +++ b/s390x/tprot.c
> @@ -20,26 +20,26 @@ static uint8_t pagebuf[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
>  
>  static void test_tprot_rw(void)
>  {
> -	int cc;
> +	enum tprot_permission permission;
>  
>  	report_prefix_push("Page read/writeable");
>  
> -	cc = tprot((unsigned long)pagebuf, 0);
> -	report(cc == 0, "CC = 0");
> +	permission = tprot((unsigned long)pagebuf, 0);
> +	report(permission == TPROT_READ_WRITE, "CC = 0");

here and in all similar cases below: does it still make sense to have
"CC = 0" as message at this point? Maybe a more descriptive one would
be better

>  
>  	report_prefix_pop();
>  }
>  
>  static void test_tprot_ro(void)
>  {
> -	int cc;
> +	enum tprot_permission permission;
>  
>  	report_prefix_push("Page readonly");
>  
>  	protect_dat_entry(pagebuf, PAGE_ENTRY_P, 5);
>  
> -	cc = tprot((unsigned long)pagebuf, 0);
> -	report(cc == 1, "CC = 1");
> +	permission = tprot((unsigned long)pagebuf, 0);
> +	report(permission == TPROT_READ, "CC = 1");
>  
>  	unprotect_dat_entry(pagebuf, PAGE_ENTRY_P, 5);
>  
> @@ -48,28 +48,28 @@ static void test_tprot_ro(void)
>  
>  static void test_tprot_low_addr_prot(void)
>  {
> -	int cc;
> +	enum tprot_permission permission;
>  
>  	report_prefix_push("low-address protection");
>  
>  	low_prot_enable();
> -	cc = tprot(0, 0);
> +	permission = tprot(0, 0);
>  	low_prot_disable();
> -	report(cc == 1, "CC = 1");
> +	report(permission == TPROT_READ, "CC = 1");
>  
>  	report_prefix_pop();
>  }
>  
>  static void test_tprot_transl_unavail(void)
>  {
> -	int cc;
> +	enum tprot_permission permission;
>  
>  	report_prefix_push("Page translation unavailable");
>  
>  	protect_dat_entry(pagebuf, PAGE_ENTRY_I, 5);
>  
> -	cc = tprot((unsigned long)pagebuf, 0);
> -	report(cc == 3, "CC = 3");
> +	permission = tprot((unsigned long)pagebuf, 0);
> +	report(permission == TPROT_TRANSL_UNAVAIL, "CC = 3");
>  
>  	unprotect_dat_entry(pagebuf, PAGE_ENTRY_I, 5);
>  

