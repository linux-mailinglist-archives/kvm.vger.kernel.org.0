Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E77590E00
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 11:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237936AbiHLJXA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 05:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiHLJW7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 05:22:59 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822ACA99D2
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 02:22:57 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27C9DEC1034229
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:22:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=S2h2Pynaluc5YLZwVSRzW+WAEPekpVHBWjfIxL2klU4=;
 b=Ej6AQMhKYI/7YjmxiXTDMK5LQcyW7cbMXrAQPqAiwax7+xS3FO5g0rMoEUyUuO0bNrzb
 CYFfXLjMW3T7KX2YgNck8T6/nbh/x2chdEJFCcI0EbVLTpHfKMh9fe+ZOwf6aZp7h2G2
 NlsOEyRv2O3/RT/Nscc3szboixwlES+g9E9gw+IBy5VC9izFi8VgrJXLZ0oOjEA9IcO6
 WJVK8x/fHjPF2NCu0xTfGd5MPK20Gn/XSavLz81KrZbzGLR1LAENUMzu3/FfzFcI1ecG
 uoeLNkNJyxETzzcymyJ8oOPofNkzKhtHdLxWwUwAR/J/vvAurnSXWe4RhulAaFBJ0Mn+ EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hwm1qg7aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:22:56 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27C9Dljl035718
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:22:56 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hwm1qg79v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Aug 2022 09:22:56 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27C97TpQ001116;
        Fri, 12 Aug 2022 09:22:54 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3huwvg31n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Aug 2022 09:22:54 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27C9MpoM31981884
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 09:22:51 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 335E3AE051;
        Fri, 12 Aug 2022 09:22:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0A2CAE045;
        Fri, 12 Aug 2022 09:22:50 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.179])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Aug 2022 09:22:50 +0000 (GMT)
Date:   Fri, 12 Aug 2022 11:22:48 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 2/4] s390x: add CPU timer related
 defines and functions
Message-ID: <20220812112248.3daa45a8@p-imbrenda>
In-Reply-To: <20220812062151.1980937-3-nrb@linux.ibm.com>
References: <20220812062151.1980937-1-nrb@linux.ibm.com>
        <20220812062151.1980937-3-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3BHA6JB8ggb16kMIy5khiIuybo3u_oDp
X-Proofpoint-GUID: 2oS65AxYuFWCJuaGOTGqqupD2P49G1j4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-12_06,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 impostorscore=0 adultscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208120024
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Aug 2022 08:21:49 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Upcoming changes will make use of the CPU timer, so add some defines and
> functions to work with the CPU timer.
> 
> Since shifts for both CPU timer and TOD clock are the same, introduce a
> new define S390_CLOCK_SHIFT_US. The respective shifts for CPU timer and
> TOD clock reference it, so the semantic difference between the two
> defines is kept.
> 
> Also add a define for the CPU timer subclass mask.

please change the Subject line to start with "lib/s390x"

> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h |  1 +
>  lib/s390x/asm/time.h     | 17 ++++++++++++++++-
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index e7ae454b3a33..b92291e8ae3f 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -78,6 +78,7 @@ struct cpu {
>  #define CTL0_EMERGENCY_SIGNAL			(63 - 49)
>  #define CTL0_EXTERNAL_CALL			(63 - 50)
>  #define CTL0_CLOCK_COMPARATOR			(63 - 52)
> +#define CTL0_CPU_TIMER				(63 - 53)
>  #define CTL0_SERVICE_SIGNAL			(63 - 54)
>  #define CR0_EXTM_MASK			0x0000000000006200UL /* Combined external masks */
>  
> diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
> index 7652a151e87a..d8d91d68a667 100644
> --- a/lib/s390x/asm/time.h
> +++ b/lib/s390x/asm/time.h
> @@ -11,9 +11,13 @@
>  #ifndef _ASMS390X_TIME_H_
>  #define _ASMS390X_TIME_H_
>  
> -#define STCK_SHIFT_US	(63 - 51)
> +#define S390_CLOCK_SHIFT_US	(63 - 51)
> +
> +#define STCK_SHIFT_US	S390_CLOCK_SHIFT_US
>  #define STCK_MAX	((1UL << 52) - 1)
>  
> +#define CPU_TIMER_SHIFT_US	S390_CLOCK_SHIFT_US
> +
>  static inline uint64_t get_clock_us(void)
>  {
>  	uint64_t clk;
> @@ -45,4 +49,15 @@ static inline void mdelay(unsigned long ms)
>  	udelay(ms * 1000);
>  }
>  
> +static inline void cpu_timer_set_ms(int64_t timeout_ms)
> +{
> +	int64_t timer_value = (timeout_ms * 1000) << CPU_TIMER_SHIFT_US;
> +
> +	asm volatile (
> +		"spt %[timer_value]\n"
> +		:
> +		: [timer_value] "Q" (timer_value)
> +	);
> +}
> +
>  #endif

