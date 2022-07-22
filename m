Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683CE57DC09
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 10:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbiGVIOO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 04:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234461AbiGVIOA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 04:14:00 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472189D50C
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 01:13:59 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26M6nm6n017020
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 08:13:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tj7uRNh0YEO6p3SX9Jzkp7OWPDX3dp14AcNrzCF+XGE=;
 b=XJQ2ahAEWG5h+nEQsqinJmmQCMTuOdlUWzqWgLmSSoQezdh1rBO+IRpud3arXU0XS/SU
 ElXap6LrZqREFeg5Xudr7H7CzBGyy/RAZuD8A+8Tutl6E7Mp0qxCMsoy48wB+mnchQws
 S2PaWQ+r+5vwtvg1/a8ohcVvUERqcIuGt+vvFh3ekibT3Gx70pdRMmRfPAJBGQXX0hFy
 3CU/F+ea7a0xfd73zEvFG9CM12uGPvGHhemiYGUeoMvJjWJgLKPPzchN7VUMybbiE9aH
 VB0y/4NuFoO8yHVFlU14q/9AO4n+UEdNXDnKJQCbz3Mq8e0jgbiZaueqkJU45+kAeVsA YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfpy8t42x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 08:13:58 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26M7jXr9020761
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 08:13:57 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfpy8t42c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 08:13:57 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26M87EZU021073;
        Fri, 22 Jul 2022 08:13:56 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3hbmkht7kk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 08:13:56 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26M8E5NI27591122
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jul 2022 08:14:05 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AAC3A4060;
        Fri, 22 Jul 2022 08:13:53 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D88C9A405F;
        Fri, 22 Jul 2022 08:13:52 +0000 (GMT)
Received: from [9.145.175.204] (unknown [9.145.175.204])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Jul 2022 08:13:52 +0000 (GMT)
Message-ID: <09d8bd01-7725-c89d-ea76-6e6acdcec084@linux.ibm.com>
Date:   Fri, 22 Jul 2022 10:13:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH v2 2/3] s390x: smp: use an array for sigp
 calls
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
References: <20220722072004.800792-1-nrb@linux.ibm.com>
 <20220722072004.800792-3-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220722072004.800792-3-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Oq0bKYahmgGMdC_k_AuaczUiXifunM55
X-Proofpoint-GUID: 4WNyzHZyJj7HdxvMIDtGHIj6URkY0L19
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_28,2022-07-21_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 suspectscore=0 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207220033
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/22/22 09:20, Nico Boehr wrote:
> Tests for the SIGP calls are quite similar, so we have a lot of code
> duplication right now. Since upcoming changes will add more cases,
> refactor the code to iterate over an array, similarily as we already do
> for test_invalid().
> 
> The receiving CPU is disabled for IO interrupts. This makes sure the
> conditional emergency signal is accepted and doesn't hurt the other
> orders.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

I'd like a few comments to make it more understandable. Other than that:
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>


Thanks for improving this

> ---
>   s390x/smp.c | 127 +++++++++++++++++++---------------------------------
>   1 file changed, 45 insertions(+), 82 deletions(-)
> 
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 34ae91c3fe12..683b0e618a48 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -43,6 +43,20 @@ static const struct sigp_invalid_cases cases_valid_cpu_addr[] = {
>   
>   static uint32_t cpu1_prefix;
>   
> +struct sigp_call_cases {
> +	char name[20];
> +	int call;
> +	uint16_t ext_int_expected_type;
> +	uint32_t cr0_bit;
> +	bool supports_pv;
> +};
> +static const struct sigp_call_cases cases_sigp_call[] = {
> +	{ "emcall",      SIGP_EMERGENCY_SIGNAL,      0x1201, CTL0_EMERGENCY_SIGNAL, true },
> +	{ "cond emcall", SIGP_COND_EMERGENCY_SIGNAL, 0x1201, CTL0_EMERGENCY_SIGNAL, false },
> +	{ "ecall",       SIGP_EXTERNAL_CALL,         0x1202, CTL0_EXTERNAL_CALL,    true },
> +};

/* Indicate that we're ready to receive the call */

>   	set_flag(1);
> -	while (lowcore.ext_int_code != 0x1201) { mb(); }
> +	while (lowcore.ext_int_code != current_sigp_call_case->ext_int_expected_type)
> +		mb();
>   	report_pass("received");
> +	ctl_clear_bit(0, current_sigp_call_case->cr0_bit);

/* Indicate that we're done */

>   	set_flag(1);
>   }
[..]

>   
> -static void test_cond_emcall(void)
> -{
> -	uint32_t status = 0;
> -	struct psw psw;
> -	int cc;
> -	psw.mask = extract_psw_mask() & ~PSW_MASK_IO;
> -	psw.addr = (unsigned long)emcall;
>   
> -	report_prefix_push("conditional emergency call");
> -
> -	if (uv_os_is_guest()) {
> -		report_skip("unsupported under PV");
> -		goto out;
> +	for (i = 0; i < ARRAY_SIZE(cases_sigp_call); i++) {
> +		current_sigp_call_case = &cases_sigp_call[i];
> +
> +		report_prefix_push(current_sigp_call_case->name);
> +		if (!current_sigp_call_case->supports_pv && uv_os_is_guest()) {
> +			report_skip("Not supported under PV");
> +			report_prefix_pop();
> +			continue;
> +		}
> +
> +		set_flag(0);
> +		psw.mask = extract_psw_mask();
> +		psw.addr = (unsigned long)call_received;
> +
> +		smp_cpu_start(1, psw);

/* Wait until the receiver has finished setup */

> +		wait_for_flag();
> +		set_flag(0);
> +		smp_sigp(1, current_sigp_call_case->call, 0, NULL);

/* Wait until the receiver has handled the call */

> +		wait_for_flag();
> +		smp_cpu_stop(1);
> +		report_prefix_pop();
>   	}
> -
> -	report_prefix_push("success");
> -	set_flag(0);
> -
> -	smp_cpu_start(1, psw);
> -	wait_for_flag();
> -	set_flag(0);
> -	cc = smp_sigp(1, SIGP_COND_EMERGENCY_SIGNAL, 0, &status);
> -	report(!cc, "CC = 0");
> -
> -	wait_for_flag();
> -	smp_cpu_stop(1);
> -
> -	report_prefix_pop();
> -
> -out:
> -	report_prefix_pop();
> -
>   }
>   
>   static void test_sense_running(void)
> @@ -499,9 +464,7 @@ int main(void)
>   	test_stop_store_status();
>   	test_store_status();
>   	test_set_prefix();
> -	test_ecall();
> -	test_emcall();
> -	test_cond_emcall();
> +	test_calls();
>   	test_sense_running();
>   	test_reset();
>   	test_reset_initial();

