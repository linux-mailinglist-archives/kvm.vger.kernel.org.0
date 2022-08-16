Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 376D3595F4B
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 17:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiHPPir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 11:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235973AbiHPPiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 11:38:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33B486715
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 08:37:22 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GEunFL018479
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 15:37:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=DONKCbPH49vZ6VJZFm8OrKUz299AsPCW5Rfb/NHWeMU=;
 b=UU1w0Q0T4wgY4mti6TJ2pLsAN2VL3PVxAmNV91EfKJdOwrWP4k1mQVJfWDHTbYRqKFHx
 zrpBb8WGBdF9tL5zz22qVV+jZfWSK3RxhwWf7FNw+dDKHzL3UJ3ED1XxNSxYCywnNeES
 UIQCCQl/bqhjPCXEgsXaNgBRjD9GIhNQx/qRunYhbkFK6SAygTvd6ebbQGBDb94tCpT5
 5hW+EnKv315zfM/MCiRUWTkrciaKAbd2hwWAaLIGGEIB+OExt5dO8FMNW3CC4WuFWEQZ
 8JWJtFzAr1sbR5czSbecpeoVdnUNktGKhsTjtIzbkSySXy+wwNPIIFKHfFJFDf7FKUtM 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j0c2650dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 15:37:22 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27GDM6Sc020069
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 15:37:22 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j0c2650c9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 15:37:21 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27GFL7Gt002538;
        Tue, 16 Aug 2022 15:37:19 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3hx37j2k16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 15:37:19 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27GFbGeD18153946
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Aug 2022 15:37:16 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8071C42041;
        Tue, 16 Aug 2022 15:37:16 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B30C4203F;
        Tue, 16 Aug 2022 15:37:16 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.13.253])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 16 Aug 2022 15:37:16 +0000 (GMT)
Date:   Tue, 16 Aug 2022 17:37:07 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 3/3] s390x: smp: add tests for calls
 in wait state
Message-ID: <20220816173707.0efc67db@p-imbrenda>
In-Reply-To: <20220810074616.1223561-4-nrb@linux.ibm.com>
References: <20220810074616.1223561-1-nrb@linux.ibm.com>
        <20220810074616.1223561-4-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: --g8zhztNAif0eIXVuQlJY4-CMWoDDKB
X-Proofpoint-ORIG-GUID: kceOmrMgNFDnUo2aSoGOVfoLnmYaQPrW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 impostorscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 lowpriorityscore=0 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208160059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Aug 2022 09:46:16 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> When the SIGP interpretation facility is in use a SIGP external call to
> a waiting CPU will result in an exit of the calling cpu. For non-pv
> guests it's a code 56 (partial execution) exit otherwise its a code 108
> (secure instruction notification) exit. Those exits are handled
> differently from a normal SIGP instruction intercept that happens
> without interpretation and hence need to be tested.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/smp.c | 97 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 97 insertions(+)
> 
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 5a269087581f..91f3e3bcc12a 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -356,6 +356,102 @@ static void test_calls(void)
>  	}
>  }
>  
> +static void call_in_wait_ext_int_fixup(struct stack_frame_int *stack)
> +{
> +	/* Clear wait bit so we don't immediately wait again after the fixup */
> +	lowcore.ext_old_psw.mask &= ~PSW_MASK_WAIT;
> +}
> +
> +static void call_in_wait_setup(void)
> +{
> +	expect_ext_int();
> +	ctl_set_bit(0, current_sigp_call_case->cr0_bit);
> +	register_ext_cleanup_func(call_in_wait_ext_int_fixup);
> +
> +	set_flag(1);
> +}
> +
> +static void call_in_wait_received(void)
> +{
> +	report(lowcore.ext_int_code == current_sigp_call_case->ext_int_expected_type, "received");
> +
> +	set_flag(1);
> +}
> +
> +static void call_in_wait_cleanup(void)
> +{
> +	ctl_clear_bit(0, current_sigp_call_case->cr0_bit);
> +	register_ext_cleanup_func(NULL);
> +
> +	set_flag(1);
> +}
> +
> +static void test_calls_in_wait(void)
> +{
> +	int i;
> +	struct psw psw;
> +
> +	report_prefix_push("psw wait");
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
> +		/* Let the secondary CPU setup the external mask and the external interrupt cleanup function */
> +		set_flag(0);
> +		psw.mask = extract_psw_mask();
> +		psw.addr = (unsigned long)call_in_wait_setup;
> +		smp_cpu_start(1, psw);
> +
> +		/* Wait until the receiver has finished setup */
> +		wait_for_flag();
> +		set_flag(0);
> +
> +		/*
> +		 * To avoid races, we need to know that the secondary CPU has entered wait,
> +		 * but the architecture provides no way to check whether the secondary CPU
> +		 * is in wait.
> +		 *
> +		 * But since a waiting CPU is considered operating, simply stop the CPU, set
> +		 * up the restart new PSW mask in wait, send the restart interrupt and then
> +		 * wait until the CPU becomes operating (done by smp_cpu_start).
> +		 */
> +		smp_cpu_stop(1);
> +		psw.mask = extract_psw_mask() | PSW_MASK_EXT | PSW_MASK_WAIT;
> +		psw.addr = (unsigned long)call_in_wait_received;
> +		smp_cpu_start(1, psw);
> +
> +		smp_sigp(1, current_sigp_call_case->call, 0, NULL);
> +
> +		/* Wait until the receiver has handled the call */
> +		wait_for_flag();
> +		smp_cpu_stop(1);
> +		set_flag(0);
> +
> +		/*
> +		 * Now clean up the mess we have left behind. If the cleanup
> +		 * were part of call_in_wait_received we would not get a chance
> +		 * to catch an interrupt that is presented twice since we would
> +		 * disable the external call on the first interrupt.
> +		 */
> +		psw.mask = extract_psw_mask();
> +		psw.addr = (unsigned long)call_in_wait_cleanup;
> +		smp_cpu_start(1, psw);
> +
> +		/* Wait until the cleanup has been completed */
> +		wait_for_flag();
> +		smp_cpu_stop(1);
> +
> +		report_prefix_pop();
> +	}
> +	report_prefix_pop();
> +}
> +
>  static void test_sense_running(void)
>  {
>  	report_prefix_push("sense_running");
> @@ -474,6 +570,7 @@ int main(void)
>  	test_store_status();
>  	test_set_prefix();
>  	test_calls();
> +	test_calls_in_wait();
>  	test_sense_running();
>  	test_reset();
>  	test_reset_initial();

