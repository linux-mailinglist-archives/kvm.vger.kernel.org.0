Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5E1587FAC
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 18:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbiHBQGQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 12:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiHBQGP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 12:06:15 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63B532B
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 09:06:14 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 272FvMKw000707
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 16:06:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=44OqCcbHmyjOx5yfXgmpZKIIsmIXnti14el6PuB8Wd4=;
 b=Xo+GVfWFK4ljMGYidBV4mcUY2ydNpEhVWWLqPO25Jze4XLtAWcVc7yyKgh4NwMPLHylB
 I98fekKVUQebC5bySQgSDvgaEn/eIwnw0mItkcjzGYypAYBXJ6UGrkHZ18jFHpMgsdb+
 aZk3jE47wH46rxbG44sY0KgzRSZ0MSZ7f5RLhmo5BT/xCG4jUoJw+Sahp0nwtxrth1bK
 HQbslmcDpR8DnnWY+MbGL/N0GKzPdqdK4j6TdFC1N2wg5QejrgAP45s7N7ddm6EFHRaJ
 m8/wRFooyVDPhv++tz7xvkDy5wppKYVbuVAJ8H9rZgWLlUN6UI42mALrTd8sf0LGfz65 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hq7128afu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 16:06:13 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 272FwBTu004187
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 16:06:13 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hq7128adn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 16:06:13 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 272G6BiV008955;
        Tue, 2 Aug 2022 16:06:11 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3hmuwhscsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 16:06:11 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 272G6NhS31523126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Aug 2022 16:06:23 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1586452050;
        Tue,  2 Aug 2022 16:06:08 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.9.152])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B93FC5204E;
        Tue,  2 Aug 2022 16:06:07 +0000 (GMT)
Date:   Tue, 2 Aug 2022 18:06:05 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 3/3] s390x: smp: add tests for calls
 in wait state
Message-ID: <20220802180605.2b546603@p-imbrenda>
In-Reply-To: <20220725155420.2009109-4-nrb@linux.ibm.com>
References: <20220725155420.2009109-1-nrb@linux.ibm.com>
        <20220725155420.2009109-4-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lHRDKSkHP-mptnp4MBxNcp6ALLyp7ijP
X-Proofpoint-GUID: zwY2Qz5S3hemoCUF-TysTptTye7IhvrE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-02_10,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208020075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Jul 2022 17:54:20 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> When the SIGP interpretation facility is in use a SIGP external call to
> a waiting CPU will result in an exit of the calling cpu. For non-pv
> guests it's a code 56 (partial execution) exit otherwise its a code 108
> (secure instruction notification) exit. Those exits are handled
> differently from a normal SIGP instruction intercept that happens
> without interpretation and hence need to be tested.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  s390x/smp.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 78 insertions(+)
> 
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 12c40cadaed2..d59ca38e7a37 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -356,6 +356,83 @@ static void test_calls(void)
>  	}
>  }
>  
> +static void call_in_wait_ext_int_fixup(struct stack_frame_int *stack)
> +{
> +	/* Clear wait bit so we don't immediately wait again after the fixup */
> +	lowcore.ext_old_psw.mask &= ~PSW_MASK_WAIT;
> +
> +	stack->crs[0] &= ~BIT(current_sigp_call_case->cr0_bit);
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
> +		expect_ext_int();

which external interrupt are you expecting on this CPU?

> +		psw.mask = extract_psw_mask() | PSW_MASK_EXT | PSW_MASK_WAIT;
> +		psw.addr = (unsigned long)call_in_wait_received;
> +		smp_cpu_start(1, psw);
> +
> +		smp_sigp(1, current_sigp_call_case->call, 0, NULL);
> +
> +		/* Wait until the receiver has handled the call */
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
> @@ -474,6 +551,7 @@ int main(void)
>  	test_store_status();
>  	test_set_prefix();
>  	test_calls();
> +	test_calls_in_wait();
>  	test_sense_running();
>  	test_reset();
>  	test_reset_initial();

