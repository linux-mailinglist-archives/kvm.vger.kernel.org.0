Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02737595F45
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 17:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236137AbiHPPiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 11:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235974AbiHPPiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 11:38:16 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5CC66A48
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 08:37:24 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GF4Djs010234
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 15:37:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=7DJ5ob/jEqQdtbVGBvaz3+3fdhtdECBYOksQErxt6+c=;
 b=synnwRxNf+jn8VcdOvMKfk1cWpKCCnE0ySON5XOMEanP9j76S94GPjY/Mr8TL+QwGOMl
 2ZVCSabzDFfa0HXDBreyCytEY0qKX0Tw3LGkIFn9OEkLi6LHM33eIUMgA8yLUl8z1ny4
 NWFcn4spaVXeq6LlhWwGg1gfnfYV7TpvZ6abG3TgKiFU2xxEudoVf8YCVzpQgJB5V5u+
 csEj+zPtkB+1hGEJ3YMzv4q/kXqzAixqXR82+jC9qVmo9+Ch6vvKRmSu1ZgSPr7IweHu
 6CE8zFtJQPFRMlzRGpcEl3kwf+ZKAZj/SmUQcCG3EgTCk4q2WIkAxWs9p9in+BM7Ii2v zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j0dj6s3rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 15:37:23 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27GF6eBB018992
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 15:37:23 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j0dj6s3qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 15:37:23 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27GFKSCl008801;
        Tue, 16 Aug 2022 15:37:21 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3hx3k9bdc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 15:37:21 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27GFbITC11796870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Aug 2022 15:37:18 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5801042041;
        Tue, 16 Aug 2022 15:37:18 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10F274203F;
        Tue, 16 Aug 2022 15:37:18 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.13.253])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 16 Aug 2022 15:37:17 +0000 (GMT)
Date:   Tue, 16 Aug 2022 17:09:44 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 2/3] s390x: smp: use an array for sigp
 calls
Message-ID: <20220816170944.0e7afc58@p-imbrenda>
In-Reply-To: <20220810074616.1223561-3-nrb@linux.ibm.com>
References: <20220810074616.1223561-1-nrb@linux.ibm.com>
        <20220810074616.1223561-3-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Q-Q1KS9CC1n79sPQRRIZ6tXQ52eYE7kg
X-Proofpoint-ORIG-GUID: 57gH70YurVwezNxPn_dT839jgPekH1uD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 mlxscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208160059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Aug 2022 09:46:15 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

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
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/smp.c | 124 ++++++++++++++++++++--------------------------------
>  1 file changed, 48 insertions(+), 76 deletions(-)
> 
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 34ae91c3fe12..5a269087581f 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -43,6 +43,20 @@ static const struct sigp_invalid_cases cases_valid_cpu_addr[] = {
>  
>  static uint32_t cpu1_prefix;
>  
> +struct sigp_call_cases {
> +	char name[20];
> +	int call;
> +	uint16_t ext_int_expected_type;
> +	unsigned int cr0_bit;
> +	bool supports_pv;
> +};
> +static const struct sigp_call_cases cases_sigp_call[] = {
> +	{ "emcall",      SIGP_EMERGENCY_SIGNAL,      0x1201, CTL0_EMERGENCY_SIGNAL, true },
> +	{ "cond emcall", SIGP_COND_EMERGENCY_SIGNAL, 0x1201, CTL0_EMERGENCY_SIGNAL, false },
> +	{ "ecall",       SIGP_EXTERNAL_CALL,         0x1202, CTL0_EXTERNAL_CALL,    true },
> +};
> +static const struct sigp_call_cases *current_sigp_call_case;
> +
>  static void test_invalid(void)
>  {
>  	const struct sigp_invalid_cases *c;
> @@ -289,97 +303,57 @@ static void test_set_prefix(void)
>  
>  }
>  
> -static void ecall(void)
> +static void call_received(void)
>  {
>  	expect_ext_int();
> -	ctl_set_bit(0, CTL0_EXTERNAL_CALL);
> -	psw_mask_set_bits(PSW_MASK_EXT);
> -	set_flag(1);
> -	while (lowcore.ext_int_code != 0x1202) { mb(); }
> -	report_pass("received");
> -	set_flag(1);
> -}
> +	ctl_set_bit(0, current_sigp_call_case->cr0_bit);
> +	/* make sure conditional emergency is accepted by disabling IO interrupts */
> +	psw_mask_clear_and_set_bits(PSW_MASK_IO, PSW_MASK_EXT);
>  
> -static void test_ecall(void)
> -{
> -	struct psw psw;
> -	psw.mask = extract_psw_mask();
> -	psw.addr = (unsigned long)ecall;
> +	/* Indicate that we're ready to receive the call */
> +	set_flag(1);
>  
> -	report_prefix_push("ecall");
> -	set_flag(0);
> +	while (lowcore.ext_int_code != current_sigp_call_case->ext_int_expected_type)
> +		mb();
> +	report_pass("received");
>  
> -	smp_cpu_start(1, psw);
> -	wait_for_flag();
> -	set_flag(0);
> -	smp_sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
> -	wait_for_flag();
> -	smp_cpu_stop(1);
> -	report_prefix_pop();
> -}
> +	ctl_clear_bit(0, current_sigp_call_case->cr0_bit);
>  
> -static void emcall(void)
> -{
> -	expect_ext_int();
> -	ctl_set_bit(0, CTL0_EMERGENCY_SIGNAL);
> -	psw_mask_set_bits(PSW_MASK_EXT);
> -	set_flag(1);
> -	while (lowcore.ext_int_code != 0x1201) { mb(); }
> -	report_pass("received");
> +	/* Indicate that we're done */
>  	set_flag(1);
>  }
>  
> -static void test_emcall(void)
> +static void test_calls(void)
>  {
> +	int i;
>  	struct psw psw;
> -	psw.mask = extract_psw_mask();
> -	psw.addr = (unsigned long)emcall;
>  
> -	report_prefix_push("emcall");
> -	set_flag(0);
> +	for (i = 0; i < ARRAY_SIZE(cases_sigp_call); i++) {
> +		current_sigp_call_case = &cases_sigp_call[i];
>  
> -	smp_cpu_start(1, psw);
> -	wait_for_flag();
> -	set_flag(0);
> -	smp_sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
> -	wait_for_flag();
> -	smp_cpu_stop(1);
> +		report_prefix_push(current_sigp_call_case->name);
> +		if (!current_sigp_call_case->supports_pv && uv_os_is_guest()) {
> +			report_skip("Not supported under PV");
> +			report_prefix_pop();
> +			continue;
> +		}
>  
> -	report_prefix_pop();
> -}
> +		set_flag(0);
> +		psw.mask = extract_psw_mask();
> +		psw.addr = (unsigned long)call_received;
> +		smp_cpu_start(1, psw);
>  
> -static void test_cond_emcall(void)
> -{
> -	uint32_t status = 0;
> -	struct psw psw;
> -	int cc;
> -	psw.mask = extract_psw_mask() & ~PSW_MASK_IO;
> -	psw.addr = (unsigned long)emcall;
> +		/* Wait until the receiver has finished setup */
> +		wait_for_flag();
> +		set_flag(0);
>  
> -	report_prefix_push("conditional emergency call");
> +		smp_sigp(1, current_sigp_call_case->call, 0, NULL);
>  
> -	if (uv_os_is_guest()) {
> -		report_skip("unsupported under PV");
> -		goto out;
> +		/* Wait until the receiver has handled the call */
> +		wait_for_flag();
> +		smp_cpu_stop(1);
> +		report_prefix_pop();
>  	}
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
>  }
>  
>  static void test_sense_running(void)
> @@ -499,9 +473,7 @@ int main(void)
>  	test_stop_store_status();
>  	test_store_status();
>  	test_set_prefix();
> -	test_ecall();
> -	test_emcall();
> -	test_cond_emcall();
> +	test_calls();
>  	test_sense_running();
>  	test_reset();
>  	test_reset_initial();

