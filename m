Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682B4783AD1
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 09:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbjHVH0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 03:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjHVH0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 03:26:10 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719A4116;
        Tue, 22 Aug 2023 00:26:06 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37M7BDaF006770;
        Tue, 22 Aug 2023 07:26:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QQMPbZtpysodB/pTGNnssq39j7cVuMWOh1cSPs0ZNvk=;
 b=KRwlLwayTbx5Og3pkNspuDweWigx6TCj2opEiluYk1XrTFmyASLlRHBphHIpoGGw6KA8
 jTuaDsC9BCN15Zwj+GYy4HK5Zq0rUga1aEHTbXrTFGASTBcXF7A4gTLeRpHpLuqTuGtG
 dQSTgOu+bJdft8IKWPk+jhgOzcHkjcF1eao1j1fG++Zclmetwsjz0HuYyX8EWZLXMMiz
 bKwpQBFl69ncF+Yq1rHo+VUy73Wv8SOi+aO/Inl8O8KDBjRBO7bt2X6JJShmMp0HyZo8
 Dtz/Q4vUnBfy2B5qBrpsE1QotaTkQ32ZmVF9VSNhq2bdeBo4cNcwcQ/KAvftWhHQm229 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3smqpb1esx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Aug 2023 07:26:05 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37M7DcMp018237;
        Tue, 22 Aug 2023 07:26:05 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3smqpb1ess-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Aug 2023 07:26:05 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37M4t3PL020702;
        Tue, 22 Aug 2023 07:26:04 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sk9jkhhxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Aug 2023 07:26:04 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37M7Q16x13959736
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Aug 2023 07:26:01 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DD9D20043;
        Tue, 22 Aug 2023 07:26:01 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B349320040;
        Tue, 22 Aug 2023 07:26:00 +0000 (GMT)
Received: from [9.179.29.40] (unknown [9.179.29.40])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 22 Aug 2023 07:26:00 +0000 (GMT)
Message-ID: <0ed545a9-059c-3825-17b0-0afb155e3535@linux.ibm.com>
Date:   Tue, 22 Aug 2023 09:26:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [kvm-unit-tests PATCH v1] s390x: spec_ex: load full register
To:     Nico Boehr <nrb@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com, nsg@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230811112949.888903-1-nrb@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230811112949.888903-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ok7iYkk8c7HmHEkevKKJhgAXpaCZhEYg
X-Proofpoint-ORIG-GUID: 1h-SrU2tJhTqf4Tv73juvqL33MyjT1qb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-22_06,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 spamscore=0 mlxscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 malwarescore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308220055
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/11/23 13:29, Nico Boehr wrote:
> There may be contents left in the upper 32 bits of executed_addr; hence
> we should use a 64-bit load to make sure they are overwritten.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

I've pushed this to devel since it seems you didn't do that yourself.

> ---
>   s390x/spec_ex.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> index e3dd85dcb153..72b942576369 100644
> --- a/s390x/spec_ex.c
> +++ b/s390x/spec_ex.c
> @@ -142,7 +142,7 @@ static int psw_odd_address(void)
>   		"	larl	%%r1,0f\n"
>   		"	stg	%%r1,%[fixup_addr]\n"
>   		"	lpswe	%[odd_psw]\n"
> -		"0:	lr	%[executed_addr],%%r0\n"
> +		"0:	lgr	%[executed_addr],%%r0\n"
>   	: [fixup_addr] "=&T" (fixup_psw.addr),
>   	  [executed_addr] "=d" (executed_addr)
>   	: [odd_psw] "Q" (odd)

