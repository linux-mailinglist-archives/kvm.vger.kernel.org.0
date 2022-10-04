Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA7465F44B1
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 15:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiJDNsb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 09:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiJDNsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 09:48:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE782AE03;
        Tue,  4 Oct 2022 06:48:16 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 294DhsYV025906;
        Tue, 4 Oct 2022 13:48:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=dDyDdfZuWCVkELzu73z7iClNunLBhEVpbZ/ZUfUs+hQ=;
 b=s8zj9hLwEhfqVkZ7ESPDxaASjJ7a/9geUtPzwKV51zalFgrt/N1M14jpTsg+hwg9LCdf
 uPM9JjJnys8iE2X6gap6zZafSXns/KtXT0VzdziUB6djNexCOrPfqbPJ/jRd1b2A01m9
 PvcaSh+N7C3tf3fYppbezuu07o9ACKUjhz/PKGQ8UcIr0g0JuFJDd2h3wWV9wQU/3Ba9
 qA1x3t6YNf4YJ++cMlx3hbKV5PCRlcLvBaSvpDHIGnAHacKumduWH1Mf+dzL/K+TH8Ft
 1Q2Zb0/sBryi6d8qNHOnHiDtJaH5/bV9XC8VuOsj37a8LvjwMFXhlX9CV7JdZ1XCf2ES Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0gwts7e4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 13:48:15 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 294DhthL026538;
        Tue, 4 Oct 2022 13:48:15 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0gwts7cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 13:48:15 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 294Ddmsh005286;
        Tue, 4 Oct 2022 13:48:13 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3jxd68u2x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 13:48:12 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 294Dm9lt38469918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Oct 2022 13:48:09 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B543A405B;
        Tue,  4 Oct 2022 13:48:09 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF2ABA4054;
        Tue,  4 Oct 2022 13:48:08 +0000 (GMT)
Received: from [9.145.154.3] (unknown [9.145.154.3])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 Oct 2022 13:48:08 +0000 (GMT)
Message-ID: <e183d9b5-eb39-1e08-1d23-831a2df2e0e6@linux.ibm.com>
Date:   Tue, 4 Oct 2022 15:48:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v14 6/6] KVM: s390: pv: module parameter to fence
 asynchronous destroy
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com, nrb@linux.ibm.com
References: <20220930140150.37463-1-imbrenda@linux.ibm.com>
 <20220930140150.37463-7-imbrenda@linux.ibm.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
In-Reply-To: <20220930140150.37463-7-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qw7fXyNA5Hvq3RG62Izt_abfCp2L87PF
X-Proofpoint-ORIG-GUID: 7LN1qNEnvdONuGAMeayDj6fCTLEZxDGM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_06,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 spamscore=0 impostorscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210040088
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/30/22 16:01, Claudio Imbrenda wrote:
> Add the module parameter "async_destroy", to allow the asynchronous
> destroy mechanism to be switched off. This might be useful for
> debugging purposes.
> 
> The parameter is enabled by default since the feature is opt-in anyway.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
LGTM
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>

> ---
>   arch/s390/kvm/kvm-s390.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 7a3bd68efd85..33a53b389cf3 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -209,7 +209,13 @@ unsigned int diag9c_forwarding_hz;
>   module_param(diag9c_forwarding_hz, uint, 0644);
>   MODULE_PARM_DESC(diag9c_forwarding_hz, "Maximum diag9c forwarding per second, 0 to turn off");
>   
> -static int async_destroy;
> +/*
> + * allow asynchronous deinit for protected guests; enable by default since
> + * the feature is opt-in anyway
> + */
> +static int async_destroy = 1;
> +module_param(async_destroy, int, 0444);
> +MODULE_PARM_DESC(async_destroy, "Asynchronous destroy for protected guests");
>   
>   /*
>    * For now we handle at most 16 double words as this is what the s390 base
