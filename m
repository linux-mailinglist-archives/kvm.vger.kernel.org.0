Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932876EF887
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 18:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbjDZQgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 12:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDZQf6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 12:35:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B01476A5
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 09:35:57 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33QGZX7A021147;
        Wed, 26 Apr 2023 16:35:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xdrAX7ksQg1V64IDWbv3tRy51Bpyo7uneyqy7PGWkxI=;
 b=RWNJW8KHq8rMHYEqyFUhEz+WWugQKK7pQlPVrRzz/pq0G0Y9obXAwZMhFCM+3gaymU68
 B1gk9aGr1hKdRrsls9vPIypfqiaX7P6BFm1lijIqqfaz1A3AvQR7iblj8GSXNsa+mdVw
 Ts7AWYCNa1OAuW/uYQmoxPodPGGZmfnWJhM9cMsknS3F4QhEOxFqS323Ud1+7FGT+xV2
 JcigwnREXP3WeZGp/mNp2IfrTE1sAYEZQXrRALZMBFt8Kr5HmPaSC4dXHY4FCbWr538c
 WkkqZmi/kaM2xcKHTqsa1G4/EFnyo5G72EJUcrX2zvDG/AozNmwq9EECiuSuRbre06Zp NA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q766btjj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 16:35:54 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33QGZs21022598;
        Wed, 26 Apr 2023 16:35:54 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q766bth41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 16:35:51 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33QGKj72019488;
        Wed, 26 Apr 2023 16:31:20 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([9.208.130.98])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3q4778p927-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 16:31:19 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
        by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33QGVI0843909514
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Apr 2023 16:31:19 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8EE458064;
        Wed, 26 Apr 2023 16:31:18 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0D595805F;
        Wed, 26 Apr 2023 16:31:17 +0000 (GMT)
Received: from [9.152.224.253] (unknown [9.152.224.253])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 26 Apr 2023 16:31:17 +0000 (GMT)
Message-ID: <4e4b227c-e8f1-d959-20a3-e1f4b38521a2@linux.ibm.com>
Date:   Wed, 26 Apr 2023 18:31:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [kvm-unit-tests PATCH] clang-format: add project-wide
 configuration file
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>
References: <20230426140805.704491-1-seiden@linux.ibm.com>
 <243608a7-484c-4844-9274-0b02dc32ec25@redhat.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
In-Reply-To: <243608a7-484c-4844-9274-0b02dc32ec25@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: npL8-SxTeSYazv5RpTONRFRA12mmWQVP
X-Proofpoint-ORIG-GUID: beqZTERBBhlhN2hB4C_z0vU_A792fFBk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_08,2023-04-26_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 mlxscore=0 clxscore=1015 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304260146
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/26/23 16:41, Thomas Huth wrote:
>> +# Taken from:
>> +#   git grep -h '^#define [^[:space:]]*for_each[^[:space:]]*(' 
>> include/ tools/ \
>> +#   | sed "s,^#define \([^[:space:]]*for_each[^[:space:]]*\)(.*$,  - 
>> '\1'," \
>> +#   | LC_ALL=C sort -u
>> +ForEachMacros:
>> +  - '__ata_qc_for_each'
>> +  - '__bio_for_each_bvec'
>> +  - '__bio_for_each_segment'
>> +  - '__evlist__for_each_entry'
>> +  - '__evlist__for_each_entry_continue'
>> +  - '__evlist__for_each_entry_from'
>> +  - '__evlist__for_each_entry_reverse'
>> +  - '__evlist__for_each_entry_safe'
>> +  - '__for_each_mem_range'
>> +  - '__for_each_mem_range_rev'
>> +  - '__for_each_thread'
>> +  - '__hlist_for_each_rcu'
>> +  - '__map__for_each_symbol_by_name'
>> +  - '__perf_evlist__for_each_entry'
>> +  - '__perf_evlist__for_each_entry_reverse'
>> +  - '__perf_evlist__for_each_entry_safe'
>> +  - '__rq_for_each_bio'
>> +  - '__shost_for_each_device'
> ...
> 
> I think this ForEachMacros list should be adapted for the k-u-ts.
> The "git grep" statement results in this list for the k-u-ts:
> 
>    - 'dt_for_each_subnode'
>    - 'fdt_for_each_property_offset'
>    - 'fdt_for_each_subnode'
>    - 'for_each_cpu'
>    - 'for_each_online_cpu'
>    - 'for_each_present_cpu'
> 
> which is definitely much shorter 😄
> 
>   Thomas
Makes sense. I'll do that.
