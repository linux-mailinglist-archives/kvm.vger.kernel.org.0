Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB639569D47
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 10:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiGGIWR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 04:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234560AbiGGIVj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 04:21:39 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3664F66A;
        Thu,  7 Jul 2022 01:20:51 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2677pvB6023351;
        Thu, 7 Jul 2022 08:20:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uhsofTH+kMsWpnDHUVDrRNYi2PtbCX3drvdW21czUB0=;
 b=P/qyTVtpd7vVZMfaQftpPQ94cgNaFWbIdhPfaZ1EyvEmV61AEzVLCWBP36lnq3g4SE3Y
 75SRJdAVtxTDA4EvBMtIjI4Z9Ny58zc+s5U+25IWD1v3vLQYSFHY0LsrI3r4LzlhtQwq
 nxYPNQe7JFyRO1wk0aT4VnAjNNK/Jf7ieUwRG5T08np/tXaQEVKRhiNXoslwJ4PojV1V
 HOQ1QPzRP0qRNEqap7sj6ISvAdyQiB4xOlmOsre8f8m69tIgeiUIRcq+yTWibnxi0rdF
 s4FOQVHsTxQ2y6bRysQ0NVhQV/ND6wK5CAD9jaz9Wkm4ef9qmKp0jRJoB0VsnsO842a7 gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5ufjrr5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 08:20:50 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2677rNV2027487;
        Thu, 7 Jul 2022 08:20:49 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5ufjrr5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 08:20:49 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26785qqa020870;
        Thu, 7 Jul 2022 08:20:47 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3h4ujsj8w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 08:20:47 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2678JQxD23920962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jul 2022 08:19:26 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAD7311C04C;
        Thu,  7 Jul 2022 08:20:44 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48F0011C04A;
        Thu,  7 Jul 2022 08:20:44 +0000 (GMT)
Received: from [9.145.178.7] (unknown [9.145.178.7])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Jul 2022 08:20:44 +0000 (GMT)
Message-ID: <52f4af7b-5c11-c62f-1ef8-0b20b8a0c127@linux.ibm.com>
Date:   Thu, 7 Jul 2022 10:20:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH v2 1/8] s390x: uv-host: Add access checks
 for donated memory
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>,
        kvm390 mailing list 
        <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com
References: <20220706064024.16573-1-frankja@linux.ibm.com>
 <20220706064024.16573-2-frankja@linux.ibm.com>
 <c8dcbb5c-73c0-be3d-8727-a376220007fa@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <c8dcbb5c-73c0-be3d-8727-a376220007fa@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uTXOPoJQqTtPKVOdZIdcj3GKl56JdLA0
X-Proofpoint-GUID: 6YntzCZotqfrMohhiC_hovTHQtFRvHrb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_06,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 spamscore=0 clxscore=1015 mlxlogscore=999 malwarescore=0
 bulkscore=0 adultscore=0 impostorscore=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207070031
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/7/22 10:11, Steffen Eiden wrote:
> Hi Janosch,
> 
> On 7/6/22 08:40, Janosch Frank wrote:
>> Let's check if the UV really protected all the memory we donated.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>    s390x/uv-host.c | 29 +++++++++++++++++++++++++++++
>>    1 file changed, 29 insertions(+)
>>
>> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
>> index a1a6d120..983cb4a1 100644
>> --- a/s390x/uv-host.c
>> +++ b/s390x/uv-host.c
>> @@ -43,6 +43,24 @@ static void cpu_loop(void)
>>    	for (;;) {}
>>    }
>>    
>> +/*
>> + * Checks if a memory area is protected as secure memory.
>> + * Will return true if all pages are protected, false otherwise.
>> + */
>> +static bool access_check_3d(uint64_t *access_ptr, uint64_t len)
>> +{
>> +	while (len) {
>> +		expect_pgm_int();
>> +		*access_ptr += 42;
>> +		if (clear_pgm_int() != PGM_INT_CODE_SECURE_STOR_ACCESS)
>> +			return false;
>> +		access_ptr += PAGE_SIZE / sizeof(access_ptr);
>> +		len -= PAGE_SIZE;
> If someone uses this function with 'len' not being a multiple of
> PAGE_SIZE this test does not for what is was intended by testing more
> memory than expected.
> 
> I suggest adding an explicit assert at the beginning of the function
> that ensures 'len' is a multiple of PAGE_SIZE.

Sure

> 
>> +	}
>> +
>> +	return true;
>> +}
>> +
> 
> [snip]
> 
> Steffen

