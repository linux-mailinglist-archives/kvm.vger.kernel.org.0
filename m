Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3806EAE1F
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 17:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbjDUPgl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 11:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbjDUPgj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 11:36:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA6340D8;
        Fri, 21 Apr 2023 08:36:38 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33LFaARC018893;
        Fri, 21 Apr 2023 15:36:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=/FMpU4TfifPVn8UshXrNPrTHSW+pw/6FI+yMLAFC5yk=;
 b=I5jedrJO3yOpPMWcAcEM1o7YLL23QUD9ppkP92asrUX5GP6iKV0M/Rtej+ck5yBzoMtk
 oXSLQC2q5xo0UrsBQgqC0CtvsPZUxXDPbE1wIqOWh10relpNnDgVI43VW6Gbd/Ct543x
 /P2QCMG5Ly/Uo3MskC1tCr7B4GomqcuS6jy0qaBXEkwPhOAILD/292dSUWdKpwsYnkfP
 u+OAjrWdGIqKkGOO0ajCzl2IaEbxJrklr5GZM9Vr9YubkMo/6zbFwMvPP3hTTa/v2YDo
 1Zn+DSPc2B95UxmDpZJ5z/qc+GG/+21ibqjD4e6QkCTa9mvVDWtMC/0UKV1o9ZzL50tn uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3tcf90fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 15:36:37 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33LFaOoB020777;
        Fri, 21 Apr 2023 15:36:24 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3tcf8yec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 15:36:23 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33L25eMH021015;
        Fri, 21 Apr 2023 15:32:29 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pykj6c4m4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 15:32:29 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33LFWPG915270554
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 15:32:25 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA5F32004B;
        Fri, 21 Apr 2023 15:32:25 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 579A22004E;
        Fri, 21 Apr 2023 15:32:25 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.17.52])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
        Fri, 21 Apr 2023 15:32:25 +0000 (GMT)
Date:   Fri, 21 Apr 2023 16:13:53 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        nrb@linux.ibm.com, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 4/7] lib: s390x: uv: Add pv guest
 requirement check function
Message-ID: <20230421161353.2dfaea97@p-imbrenda>
In-Reply-To: <20230421113647.134536-5-frankja@linux.ibm.com>
References: <20230421113647.134536-1-frankja@linux.ibm.com>
        <20230421113647.134536-5-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tIvzq0FJUiZrT-vbCaL-YhAn8rwHbOV9
X-Proofpoint-ORIG-GUID: DQSLNgWtfkxnEI3W8MTDbVmIAHCdw_21
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_08,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304210137
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Apr 2023 11:36:44 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> When running PV guests some of the UV memory needs to be allocated
> with > 31 bit addresses which means tests with PV guests will always
> need a lot more memory than other tests.
> Additionally facilities nr 158 and sclp.sief2 need to be available.
> 
> Let's add a function that checks for these requirements and prints a
> helpful skip message.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/snippet.h |  7 +++++++
>  lib/s390x/uv.c      | 20 ++++++++++++++++++++
>  lib/s390x/uv.h      |  1 +
>  s390x/pv-diags.c    |  8 +-------
>  4 files changed, 29 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
> index 57045994..11ec54c3 100644
> --- a/lib/s390x/snippet.h
> +++ b/lib/s390x/snippet.h
> @@ -30,6 +30,13 @@
>  #define SNIPPET_HDR_LEN(type, file) \
>  	((uintptr_t)SNIPPET_HDR_END(type, file) - (uintptr_t)SNIPPET_HDR_START(type, file))
>  
> +/*
> + * Some of the UV memory needs to be allocated with >31 bit
> + * addresses which means we need a lot more memory than other
> + * tests.
> + */
> +#define SNIPPET_PV_MIN_MEM_SIZE	(SZ_1M * 2200UL)
> +
>  #define SNIPPET_PV_TWEAK0	0x42UL
>  #define SNIPPET_PV_TWEAK1	0UL
>  #define SNIPPET_UNPACK_OFF	0
> diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
> index 383271a5..db47536c 100644
> --- a/lib/s390x/uv.c
> +++ b/lib/s390x/uv.c
> @@ -18,6 +18,7 @@
>  #include <asm/uv.h>
>  #include <uv.h>
>  #include <sie.h>
> +#include <snippet.h>
>  
>  static struct uv_cb_qui uvcb_qui = {
>  	.header.cmd = UVC_CMD_QUI,
> @@ -38,6 +39,25 @@ bool uv_os_is_host(void)
>  	return test_facility(158) && uv_query_test_call(BIT_UVC_CMD_INIT_UV);
>  }
>  
> +bool uv_guest_requirement_checks(void)

I would call it uv_host_requirement_checks since it will run on the
host to check if the host meets certain requirements

> +{
> +	if (!test_facility(158)) {
> +		report_skip("UV Call facility unavailable");
> +		return false;
> +	}
> +	if (!sclp_facilities.has_sief2) {
> +		report_skip("SIEF2 facility unavailable");
> +		return false;
> +	}
> +	if (get_ram_size() < SNIPPET_PV_MIN_MEM_SIZE) {
> +		report_skip("Not enough memory. This test needs about %ld MB of memory",
> +			    SNIPPET_PV_MIN_MEM_SIZE / 1024 / 1024);

a better way to do this would be to check the amount of memory needed
by the Ultravisor and check if that size + 2GB is available

of course in that case unittest.cfg would also need to be adjusted

> +		return false;
> +	}
> +
> +	return true;
> +}
> +
>  bool uv_query_test_call(unsigned int nr)
>  {
>  	/* Query needs to be called first */
> diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
> index 78b979b7..d9af691a 100644
> --- a/lib/s390x/uv.h
> +++ b/lib/s390x/uv.h
> @@ -7,6 +7,7 @@
>  
>  bool uv_os_is_guest(void);
>  bool uv_os_is_host(void);
> +bool uv_guest_requirement_checks(void);
>  bool uv_query_test_call(unsigned int nr);
>  const struct uv_cb_qui *uv_get_query_data(void);
>  void uv_init(void);
> diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
> index fa4e5532..1289a571 100644
> --- a/s390x/pv-diags.c
> +++ b/s390x/pv-diags.c
> @@ -149,14 +149,8 @@ static void test_diag_yield(void)
>  int main(void)
>  {
>  	report_prefix_push("pv-diags");
> -	if (!test_facility(158)) {
> -		report_skip("UV Call facility unavailable");
> +	if (!uv_guest_requirement_checks())
>  		goto done;
> -	}
> -	if (!sclp_facilities.has_sief2) {
> -		report_skip("SIEF2 facility unavailable");
> -		goto done;
> -	}
>  
>  	uv_setup_asces();
>  	snippet_setup_guest(&vm, true);

