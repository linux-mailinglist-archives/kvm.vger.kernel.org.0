Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7798266E441
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 17:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjAQQ7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 11:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbjAQQ7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 11:59:11 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8746442C0
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 08:59:10 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30HG0D71006358;
        Tue, 17 Jan 2023 16:59:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=iZ02NKEUeJtgM6VZ1W4vUetCFfduwAz+VYjCHoweqJs=;
 b=ez8OXXH5z4ZCWW7sztrjhyY28/cRFCQmyfNl2NYlUGDTwwXYK6+u4TOc1+ZrRH3l83wD
 EwtYZunjs9UjWUtNXaEeeVEhUoIpDoV77ByXF4HLg29pfAwtCXoFIAhyGHR7hc9mMGfI
 2bc76X2ym5GG3dpDHO1p4aiiwqVAc7lOPkJlzcbj9BRylwDrTifQRBJ2wNbPuGI1Wv80
 CdIOtw/jLQQ0ViQg4CD8TzQBQYKUZ6Vb1LWyogu6M8ee1Hw4lB/lyttKGdkNzfesdLuC
 PXLJ4iCV0J4ul4ulhdllolhtcmof7uX7gsWrmDm2ww0DWHDVZE3GdQrHINkZyo0Hgqij DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5peh6885-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 16:59:04 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30HGx4Pp026047;
        Tue, 17 Jan 2023 16:59:04 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5peh687c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 16:59:03 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30H7kIqY006229;
        Tue, 17 Jan 2023 16:59:02 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3n3knfm5q8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 16:59:01 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30HGwwff47120740
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Jan 2023 16:58:58 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E92920043;
        Tue, 17 Jan 2023 16:58:58 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC31920040;
        Tue, 17 Jan 2023 16:58:56 +0000 (GMT)
Received: from [9.171.42.216] (unknown [9.171.42.216])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 17 Jan 2023 16:58:56 +0000 (GMT)
Message-ID: <155ddd20-1245-ea74-4039-dd7925a58f67@linux.ibm.com>
Date:   Tue, 17 Jan 2023 17:58:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v14 03/11] target/s390x/cpu topology: handle STSI(15) and
 build the SYSIB
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org,
        frankja@linux.ibm.com
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-4-pmorel@linux.ibm.com>
 <5cf19913-b2d7-d72d-4332-27aa484f72e4@redhat.com>
 <cf0ce650d86e9a1fae7477d1ed8e49d87fc4d9d2.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <cf0ce650d86e9a1fae7477d1ed8e49d87fc4d9d2.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rV18jt9VPZYwA2TilOGvy4rMCn5e9cWv
X-Proofpoint-ORIG-GUID: HJk4FW3JjWdvbfdY_X3LIZqSMWMwTBlo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_08,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxscore=0 impostorscore=0 spamscore=0 clxscore=1015
 suspectscore=0 mlxlogscore=929 lowpriorityscore=0 malwarescore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301170133
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/11/23 18:14, Nina Schoetterl-Glausch wrote:
> On Tue, 2023-01-10 at 15:29 +0100, Thomas Huth wrote:
>> On 05/01/2023 15.53, Pierre Morel wrote:
>>> On interception of STSI(15.1.x) the System Information Block
>>> (SYSIB) is built from the list of pre-ordered topology entries.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>
> [...]
> 
>>> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
>>> +{
>>> +    union {
>>> +        char place_holder[S390_TOPOLOGY_SYSIB_SIZE];
>>> +        SysIB_151x sysib;
>>> +    } buffer QEMU_ALIGNED(8) = {};
>>> +    int len;
>>> +
>>> +    if (!s390_has_topology() || sel2 < 2 || sel2 > SCLP_READ_SCP_INFO_MNEST) {
>>> +        setcc(cpu, 3);
>>> +        return;
>>> +    }
>>> +
>>> +    len = setup_stsi(cpu, &buffer.sysib, sel2);
>>> +
>>> +    if (len > 4096) {
>>
>> Maybe use TARGET_PAGE_SIZE instead of 4096 ?
> 
> sizeof(SysIB) would be preferable IMO.

Yes better


Thanks,

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
