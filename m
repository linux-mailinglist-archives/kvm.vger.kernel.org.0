Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93D84FE28B
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 15:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355956AbiDLN3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 09:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357697AbiDLN3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 09:29:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7DD1168;
        Tue, 12 Apr 2022 06:25:47 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23CBBt4x029775;
        Tue, 12 Apr 2022 13:25:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=AW8kwVPCS9/wRl4iOLeyMMq2debXEm5LVydGMSILoXU=;
 b=UsEM8sjXGLtwddI02//Go8ofFU8YOGntUM+l/2381XJuqHQAk4+qqPp7a/sP8TpqBXN6
 YrNtFfeZdybX4yWsW4W9MkfNiU7gYEyF8mSc0e8by5OgSs1ZDSrGOhPqF5BiTORiCPX4
 LPoFdArPbLjZ0FDf7E18KKA7I4sT7EiQbcXZno4/sgZ3yKBX1rlprOxl8P+GwOmOlRFK
 kXi3SGT4Kn8o/aPGyt1B73nUQWcRunU9GwgANRI7idIkDp+qmxlGSDpTx41lg42XdIAw
 2UIFf9SBWOUnBlzkymwrQLwur7ioX/GsT/q6M5r7MnT+Mamh6Yq0ayk2Jq/2VKFjs0pC KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd8b5k3xq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 13:25:46 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23CCk7mv002844;
        Tue, 12 Apr 2022 13:25:46 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd8b5k3x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 13:25:46 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23CDHTIw027965;
        Tue, 12 Apr 2022 13:25:45 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma05wdc.us.ibm.com with ESMTP id 3fb1s9g71c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 13:25:45 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23CDPi1e25297344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 13:25:44 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64D96B206C;
        Tue, 12 Apr 2022 13:25:44 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D03D7B205F;
        Tue, 12 Apr 2022 13:25:42 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.163.28.157])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 12 Apr 2022 13:25:42 +0000 (GMT)
Message-ID: <f1c02fc33429403fa17bfaa21d9c551310fb968c.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 3/3] s390x: smp: make stop stopped cpu
 look the same as the running case
From:   Eric Farman <farman@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Date:   Tue, 12 Apr 2022 09:25:41 -0400
In-Reply-To: <20220412093022.21378-1-nrb@linux.ibm.com>
References: <20220412093022.21378-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gHhSBni3zb6EqmdgPKuUGxksBlpq4Yfu
X-Proofpoint-GUID: B1KkdeCiqLUCyftuYlxyF8TXVllDWxvr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_04,2022-04-12_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 bulkscore=0 spamscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1011 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-04-12 at 11:30 +0200, Nico Boehr wrote:
> Adjust the stop stopped CPU case such that it looks the same as the
> stop running
> CPU case: use the nowait variant, handle the error code in the same
> way and make
> the report messages look the same.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Eric Farman <farman@linux.ibm.com>

> ---
>  s390x/smp.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 5257852c35a7..de3aba71c956 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -144,8 +144,9 @@ static void test_stop(void)
>  	report(smp_cpu_stopped(1), "cpu stopped");
>  
>  	report_prefix_push("stop stopped CPU");
> -	report(!smp_cpu_stop(1), "STOP succeeds");
> -	report(smp_cpu_stopped(1), "CPU is stopped");
> +	rc = smp_cpu_stop_nowait(1);
> +	report(!rc, "return code");
> +	report(smp_cpu_stopped(1), "cpu stopped");
>  	report_prefix_pop();
>  
>  	report_prefix_pop();

