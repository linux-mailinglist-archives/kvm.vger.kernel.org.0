Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D192357DC60
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 10:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbiGVIaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 04:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbiGVIay (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 04:30:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFA39E29B
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 01:30:53 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26M6jv39028097
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 08:30:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hr2Z3UcHLZS3D0/6riSYbZ+uV1U3WkDSlhnafueQUYM=;
 b=RcsLXYb9TPFCEA/rOJJ9kwW/5TTwiJg34uzooIpx7drcW2KU8W2eeT3I7bjtR87CL/ZI
 XtooMTGIZmLznm64CUPws5UIsMYGD0YGukF+LeF9qwcWpGDX36jYg3odqwvBQGrdPaBi
 1dGxqVYKuGSrRzm5THpDP4MRtCKFeowFH0w+vdLnZg7QcioJcoE4nVXpiVVooYOarbS8
 1Dxi9wZqjBNNvMDTEnNZQaptYT35pScss3woHVfPhvbIzF7SUAfHAd3PursC8zeRkl+K
 XT/pF/VZjXXXw1B6Dt9+gbCFH6qbFKdGLF6bnQ7zaPkMOrucFXjGeYvtieWfSSRKkYco BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfpws2ku1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 08:30:52 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26M8IgxY008157
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 08:30:52 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfpws2kt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 08:30:52 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26M8LAIS005302;
        Fri, 22 Jul 2022 08:30:50 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3hbmy905cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 08:30:50 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26M8UkjW9502992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jul 2022 08:30:47 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB530A405F;
        Fri, 22 Jul 2022 08:30:46 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5E33A4060;
        Fri, 22 Jul 2022 08:30:46 +0000 (GMT)
Received: from [9.145.175.204] (unknown [9.145.175.204])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Jul 2022 08:30:46 +0000 (GMT)
Message-ID: <facc8a71-954a-4b4d-5d63-d07b69125a80@linux.ibm.com>
Date:   Fri, 22 Jul 2022 10:30:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
References: <20220722072004.800792-1-nrb@linux.ibm.com>
 <20220722072004.800792-4-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: smp: add tests for calls in
 wait state
In-Reply-To: <20220722072004.800792-4-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wLn42z-gzyaFVMkyFX3kfu9Fhog_fkRA
X-Proofpoint-ORIG-GUID: EYed6aJaqjXeKCFnlgE9mRlPqfoYeKdi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_28,2022-07-21_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207220033
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/22/22 09:20, Nico Boehr wrote:
> Under PV, SIGP ecall requires some special handling by the hypervisor
> when the receiving CPU is in enabled wait. Hence, we should have
> coverage for the various SIGP call orders when the receiving CPU is in
> enabled wait.

When the SIGP interpretation facility is in use a SIGP external call to 
a waiting CPU will result in an exit of the calling cpu. For non-pv 
guests it's a code 56 (partial execution) exit otherwise its a code 108 
(secure instruction notification) exit. Those exits are handled 
differently from a normal SIGP instruction intercept that happens 
without interpretation and hence need to be tested.

> 
> The ecall test currently fails under PV due to a KVM bug under
> investigation.

That shouldn't be true anymore

> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/smp.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 75 insertions(+)
> 
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 683b0e618a48..eed7aa3564de 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -347,6 +347,80 @@ static void test_calls(void)
>   	}
>   }
>   
> +static void call_in_wait_ext_int_fixup(struct stack_frame_int *stack)
> +{
> +	/* leave wait after returning */

Clear wait bit so we don't immediately wait again after the fixup

> +	lowcore.ext_old_psw.mask &= ~PSW_MASK_WAIT;
> +
> +	stack->crs[0] &= ~current_sigp_call_case->cr0_bit;

You need a mask but have a bit, no?

~BIT(current_sigp_call_case->cr0_bit)

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
/* Let the secondary CPU setup the external mask and the external 
interrupt cleanup function */
> +		set_flag(0);
> +		psw.mask = extract_psw_mask();
> +		psw.addr = (unsigned long)call_in_wait_setup;
> +		smp_cpu_start(1, psw);
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
> +		psw.mask = extract_psw_mask() | PSW_MASK_EXT | PSW_MASK_WAIT;
> +		psw.addr = (unsigned long)call_in_wait_received;
> +		smp_cpu_start(1, psw);
> +
> +		smp_sigp(1, current_sigp_call_case->call, 0, NULL);
> +
> +		wait_for_flag();
> +		smp_cpu_stop(1);
> +
> +		report_prefix_pop();
> +	}
> +	report_prefix_pop();
> +}
> +
>   static void test_sense_running(void)
>   {
>   	report_prefix_push("sense_running");
> @@ -465,6 +539,7 @@ int main(void)
>   	test_store_status();
>   	test_set_prefix();
>   	test_calls();
> +	test_calls_in_wait();
>   	test_sense_running();
>   	test_reset();
>   	test_reset_initial();

