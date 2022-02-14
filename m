Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B16A4B4581
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 10:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242809AbiBNJTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 04:19:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242452AbiBNJTP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 04:19:15 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A1B606F2;
        Mon, 14 Feb 2022 01:19:07 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21E7P4pF008181;
        Mon, 14 Feb 2022 09:19:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2qoJE32n/9Dy/jvjffEMpVgzIFg6SsKQOaRBycTQmxw=;
 b=CgbqTeO2v31P9E4fQwUJZPYMc7+9WKfvJtAyuMvHuUOtV107eo1vjyq1b+3XnO+g/lUS
 UMsLw/TelzJ2G6QSuWEBlKJdjDArO4DRT++O6F1H2WOfAkHwbkVHviN65Zr9TuPL0B4W
 9lpEjO9f5dMkIAbIpiBWCjDHMWoQVRLipRORcdiR3rzLIrkrcGm1ivD35FWWrl7OUYGG
 PyzLcQb3Hv2kXDydm9k7IZtjR/y6tEsCI8mM6/PiRdph9TsUbRuPE4lOpBj8ZcCdytyV
 qnI5MZkeYyl2BYEucJrJHptmxsJIldlU6hp3AkrefDk8d0zOjw6tg5bg3nEEZsTTuext hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e78m0cb9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 09:19:07 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21E8SQDw008049;
        Mon, 14 Feb 2022 09:19:06 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e78m0cb8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 09:19:06 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21E9Fe5I020256;
        Mon, 14 Feb 2022 09:19:04 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3e64h9ka83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 09:19:04 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21E9J1sq15663444
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 09:19:01 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F49BA405C;
        Mon, 14 Feb 2022 09:19:01 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC623A4054;
        Mon, 14 Feb 2022 09:19:00 +0000 (GMT)
Received: from [9.171.42.254] (unknown [9.171.42.254])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Feb 2022 09:19:00 +0000 (GMT)
Message-ID: <4f29c9a2-6984-47b5-ab8d-940847cead27@linux.ibm.com>
Date:   Mon, 14 Feb 2022 10:21:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v4 3/4] s390x: topology: Check the Perform
 Topology Function
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com
References: <20220208132709.48291-1-pmorel@linux.ibm.com>
 <20220208132709.48291-4-pmorel@linux.ibm.com>
 <8dd704d23f8a14907ed2a7f28ec3ac52685ab96c.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <8dd704d23f8a14907ed2a7f28ec3ac52685ab96c.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vXKIvkY47Nm6mVonIiy6mMwjx_HCbmAs
X-Proofpoint-ORIG-GUID: SZWMofuf51451ltCBmb7Kuw78Pet1m_i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_01,2022-02-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxscore=0 phishscore=0 impostorscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/9/22 12:37, Nico Boehr wrote:
> On Tue, 2022-02-08 at 14:27 +0100, Pierre Morel wrote:
>> We check the PTF instruction.
> 
> You could test some very basic things as well:
> 
> - you get a privileged pgm int in problem state,
> - reserved bits in first operand cause specification pgm int,
> - reserved FC values result in a specification pgm int,
> - second operand is ignored.

right, I will add these, I was more focused on the functionalities

> 
>>
>> - We do not expect to support vertical polarization.
>>
>> - We do not expect the Modified Topology Change Report to be
> [...]
> 
> Forgive me if I'm missing something, but why _Modified_ Topology Change
> Report?
> 
>> diff --git a/s390x/topology.c b/s390x/topology.c
>> new file mode 100644
>> index 00000000..a1f9ce51
>> --- /dev/null
>> +++ b/s390x/topology.c
> 
> [...]
> 
>> +static int ptf(unsigned long fc, unsigned long *rc)
>> +{
>> +       int cc;
>> +
>> +       asm volatile(
>> +               "       .insn   rre,0xb9a20000,%1,0\n"
>> +               "       ipm     %0\n"
>> +               "       srl     %0,28\n"
>> +               : "=d" (cc), "+d" (fc)
>> +               : "d" (fc)
> 
> Why list fc here again?
> 
> 

No reason, I suppress it.

Thanks for the review
pierre


-- 
Pierre Morel
IBM Lab Boeblingen
