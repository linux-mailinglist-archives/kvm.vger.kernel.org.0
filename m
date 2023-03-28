Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6882E6CBDF0
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 13:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbjC1LiK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 07:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbjC1LiI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 07:38:08 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EEE40EA;
        Tue, 28 Mar 2023 04:38:06 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32S9KW0l006860;
        Tue, 28 Mar 2023 11:38:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/uql0AsOgChupybCjnv/4rCRhr5aUbiikSgPJ1sXICE=;
 b=cHZJyo5yuARzP34P4TTTvkHXyasXPU2DwS46I3NEBd2QXUvgTgiQUuoSJE5+np6F8FiG
 exIAIpPzyapROtXX+7JJe6nBmEabiMPm3sDp9/gOEBuczRXN3O4wy+CLzQg1HMMQMCyS
 2Bt0zNROUF/TPs1yXu5/MxObhvv5RAwzkd7gEnVJF4uIPsovIvsvQSZLlGN052bFdnY8
 oGzLvnbrCtCyesleLLVABQ1Hw5xAGat5BEJaAptWgC+6bm0iHpPUyDxFGPX5wIosuENK
 g7IlrpXNxTYXFDhANKT3fDYMzv0G8iQiVQIWdyZv0wZUS3mxLuGrS3NpYdFHYKg3EKwj Pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pkwgxb8ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 11:38:05 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32SBb3SW003350;
        Tue, 28 Mar 2023 11:38:05 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pkwgxb8c0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 11:38:04 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32S4VKHR019202;
        Tue, 28 Mar 2023 11:38:03 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3phrk6kx7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 11:38:03 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32SBbxPH21234322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Mar 2023 11:37:59 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B7022004D;
        Tue, 28 Mar 2023 11:37:59 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E1B52004B;
        Tue, 28 Mar 2023 11:37:59 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 28 Mar 2023 11:37:59 +0000 (GMT)
Message-ID: <3dcfb02a-84db-1298-1b88-810b52c12818@linux.ibm.com>
Date:   Tue, 28 Mar 2023 13:37:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v7 2/2] s390x: topology: Checking
 Configuration Topology Information
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com
References: <20230320085642.12251-1-pmorel@linux.ibm.com>
 <20230320085642.12251-3-pmorel@linux.ibm.com>
 <167965555147.41638.10047922188597254104@t14-nrb>
 <eed972f5-7d94-4db3-c496-60f7d37db0f3@linux.ibm.com>
 <167998471655.28355.8845167343467425829@t14-nrb>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <167998471655.28355.8845167343467425829@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: peLi7sPjwIgMNQNpTlgCphY0wCGKfLn4
X-Proofpoint-ORIG-GUID: WNCXHg-ws4MF4be1xOCNBZJGkcOdAS-x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-28_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 impostorscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 clxscore=1015 adultscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303280094
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/28/23 08:25, Nico Boehr wrote:
> Quoting Pierre Morel (2023-03-27 14:38:35)
>>> [...]


[...]


>> If a topology level always exist physically and if it is not specified
>> on the QEMU command line it is implicitly unique.
> What do you mean by 'implicitly unique'?

I mean that if the topology level is not explicitly specified on the 
command line, it exists a single entity of this topology level.


>
>> OK for expected_topo_lvl if you prefer.
> Yes, please.
>
>>> [...]
>>>> +/*
>>>> + * stsi_check_mag
>>>> + * @info: Pointer to the stsi information
>>>> + *
>>>> + * MAG field should match the architecture defined containers
>>>> + * when MNEST as returned by SCLP matches MNEST of the SYSIB.
>>>> + */
>>>> +static void stsi_check_mag(struct sysinfo_15_1_x *info)
>>>> +{
>>>> +       int i;
>>>> +
>>>> +       report_prefix_push("MAG");
>>>> +
>>>> +       stsi_check_maxcpus(info);
>>>> +
>>>> +       /* Explicitly skip the test if both mnest do not match */
>>>> +       if (max_nested_lvl != info->mnest)
>>>> +               goto done;
>>> What does it mean if the two don't match, i.e. is this an error? Or a skip? Or is it just expected?
>> I have no information on the representation of the MAG fields for a
>> SYSIB with a nested level different than the maximum nested level.
>>
>> There are examples in the documentation but I did not find, and did not
>> get a clear answer, on how the MAG field are calculated.
>>
>> The examples seems clear for info->mnest between MNEST -1 and 3 but the
>> explication I had on info->mnest = 2 is not to be found in any
>> documentation.
>>
>> Until it is specified in a documentation I skip all these tests.
> Alright - then please:
> - update the comment to say:
>    "It is not clear how the MAG fields are calculated when mnest in the SYSIB 15.x is different from the maximum nested level in the SCLP info, so we skip here for now."
> - when this is the case, do a report_skip() and show info->mnest and max_nested_lvl in the message.


OK, thanks.

Regards,

Pierre

