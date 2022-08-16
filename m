Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC6E595F4A
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 17:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbiHPPie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 11:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235818AbiHPPiP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 11:38:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2876E85FFD
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 08:37:19 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GFMRYr031314
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 15:37:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=99jd5FNNjUmig5nU1MiNvmari+HgfkizVEyjb/AfhoE=;
 b=g4s6efgcb/v3OI46sOb5c9XO+j7V+IqD5MfCQP4QX86lIyGJCd+71aKJsbI7tbY05e88
 u9YPVbSCCWH5zPzZnJodtdOsrSqO5wAO/uS844LgaclaQAk4qsn2ydRD/kDwGNA3aB3V
 +jBLsGR2dk6HP3WdSFuDkV0d5+i9H9T2bX3CHrdAVjzDxP4GOQ6ya2QzXW0+2q6fJKyv
 6kKGueuvC/77Yza00UvoOUspE9rmWkKis0xKQz552qAXuEQ/rqZKO9jFDNWW1qWxO3KK
 qGYqrBJDTgowhtvbdht4U+FetHNv/r62NGF8lyqLbF/nNZ7Dha/E/g+YiQqeVAK4NhmQ nA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j0dtmgf78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 15:37:18 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27GFMRGk031287
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 15:37:18 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j0dtmgf69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 15:37:18 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27GFKW2h026315;
        Tue, 16 Aug 2022 15:37:16 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3hx3k92js7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 15:37:15 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27GFbCKs31195572
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Aug 2022 15:37:12 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 584C342047;
        Tue, 16 Aug 2022 15:37:12 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AE9442041;
        Tue, 16 Aug 2022 15:37:12 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.13.253])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 16 Aug 2022 15:37:11 +0000 (GMT)
Date:   Tue, 16 Aug 2022 14:12:45 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 1/3] s390x: smp: move sigp calls with
 invalid cpu address to array
Message-ID: <20220816141245.7983eebf@p-imbrenda>
In-Reply-To: <20220810074616.1223561-2-nrb@linux.ibm.com>
References: <20220810074616.1223561-1-nrb@linux.ibm.com>
        <20220810074616.1223561-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: H4UvoXtXU6ZvLAv9AgcWOPvoeEHupsKH
X-Proofpoint-GUID: euz-gV4pgjTJDQuCdWtpivta-WW2aD-V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 adultscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 mlxscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208160059
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Aug 2022 09:46:14 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> We have the nice array to test SIGP calls with invalid CPU addresses.
> Move the SIGP cases there to eliminate some of the duplicated code in
> test_emcall and test_cond_emcall.
> 
> Since adding coverage for invalid CPU addresses in the ecall case is now
> trivial, do that as well.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/smp.c | 18 +++---------------
>  1 file changed, 3 insertions(+), 15 deletions(-)
> 
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 0df4751f9cee..34ae91c3fe12 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -30,6 +30,9 @@ static const struct sigp_invalid_cases cases_invalid_cpu_addr[] = {
>  	{ SIGP_STOP,                  "stop with invalid CPU address" },
>  	{ SIGP_START,                 "start with invalid CPU address" },
>  	{ SIGP_CPU_RESET,             "reset with invalid CPU address" },
> +	{ SIGP_COND_EMERGENCY_SIGNAL, "conditional emcall with invalid CPU address" },
> +	{ SIGP_EMERGENCY_SIGNAL,      "emcall with invalid CPU address" },
> +	{ SIGP_EXTERNAL_CALL,         "ecall with invalid CPU address" },
>  	{ INVALID_ORDER_CODE,         "invalid order code and CPU address" },
>  	{ SIGP_SENSE,                 "sense with invalid CPU address" },
>  	{ SIGP_STOP_AND_STORE_STATUS, "stop and store status with invalid CPU address" },
> @@ -329,7 +332,6 @@ static void emcall(void)
>  static void test_emcall(void)
>  {
>  	struct psw psw;
> -	int cc;
>  	psw.mask = extract_psw_mask();
>  	psw.addr = (unsigned long)emcall;
>  
> @@ -343,13 +345,6 @@ static void test_emcall(void)
>  	wait_for_flag();
>  	smp_cpu_stop(1);
>  
> -	report_prefix_push("invalid CPU address");
> -
> -	cc = sigp(INVALID_CPU_ADDRESS, SIGP_EMERGENCY_SIGNAL, 0, NULL);
> -	report(cc == 3, "CC = 3");
> -
> -	report_prefix_pop();
> -
>  	report_prefix_pop();
>  }
>  
> @@ -368,13 +363,6 @@ static void test_cond_emcall(void)
>  		goto out;
>  	}
>  
> -	report_prefix_push("invalid CPU address");
> -
> -	cc = sigp(INVALID_CPU_ADDRESS, SIGP_COND_EMERGENCY_SIGNAL, 0, NULL);
> -	report(cc == 3, "CC = 3");
> -
> -	report_prefix_pop();
> -
>  	report_prefix_push("success");
>  	set_flag(0);
>  

