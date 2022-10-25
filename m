Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B236860CD3A
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 15:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbiJYNRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 09:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232743AbiJYNRp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 09:17:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5944CE52E5;
        Tue, 25 Oct 2022 06:17:44 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PCfeYp004049;
        Tue, 25 Oct 2022 13:17:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=M9PK9LY4oTb8D3o+jZliwBeehdFYroiqI+wKOruGl0Y=;
 b=ACvKlCaAPkCFLIhwhFDzLYFHZ275xnWnUNQCdVr6jnrN+TyUE08NeDcmxljb19Yxx/Ml
 J3xwtiK2H7OIL6JjxV3qOkgNTb/hYUzq/+DBBWiqEXYGpNKTdtnf3veZizxaqacS4iHG
 rMDhypTzWXpDA5L11XhsJcL+99R2iL1BfZQn7USClQ911GFcHRvSNOuJmoN16RdEMqy+
 8sOetSwSFFd+nVthwTdI+SyK6zpQZ67ccDyisfs6Ombv+3EbaxWwh4IEZEvkfS5/ut8V
 DH/r5nhXh3u47xlHUh5m/R5Up1qX/8B7V5tRYW4mQuzKOTmBKoEcSHXLM1LI7tTHslOb Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kee35wd89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 13:17:43 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29PCfn9K004898;
        Tue, 25 Oct 2022 13:17:43 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kee35wd6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 13:17:43 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29PD6bOu013922;
        Tue, 25 Oct 2022 13:17:40 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3kc8594351-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 13:17:40 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29PDHbZW2949656
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 13:17:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84E25A4040;
        Tue, 25 Oct 2022 13:17:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C769FA404D;
        Tue, 25 Oct 2022 13:17:36 +0000 (GMT)
Received: from [9.171.30.119] (unknown [9.171.30.119])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 13:17:36 +0000 (GMT)
Message-ID: <0117e263-2856-b2fd-1e61-59b21e5da2e5@linux.ibm.com>
Date:   Tue, 25 Oct 2022 15:17:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v2 1/1] KVM: s390: vsie: clarifications on setting the
 APCB
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, svens@linux.ibm.com
References: <20221025091319.37110-1-pmorel@linux.ibm.com>
 <20221025091319.37110-2-pmorel@linux.ibm.com>
 <e9a237d7-3a34-11c8-1c5b-1a3c14e8cfb0@redhat.com>
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <e9a237d7-3a34-11c8-1c5b-1a3c14e8cfb0@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WFO04gaDUtMpOw2tljq--Y9LiVCAxz3h
X-Proofpoint-GUID: MJRwK1_i_YK8wnWfVoWROUkVP3L55NiR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_06,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=677
 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1011 phishscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210250075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/25/22 11:30, David Hildenbrand wrote:
> On 25.10.22 11:13, Pierre Morel wrote:
>> The APCB is part of the CRYCB.
>> The calculation of the APCB origin can be done by adding
>> the APCB offset to the CRYCB origin.
>>
>> Current code makes confusing transformations, converting
>> the CRYCB origin to a pointer to calculate the APCB origin.
>>
> 
> 
> While at it, can we rename "crycb_o" to "crycb_gpa" and "apcb_o" to 
> "apcb_gpa".
> 
> These are not pointers but guest physical addresses.
> 

I can do that.
the _o came from the name in the documentation "origin"
but gpa is more obvious.

-- 
Pierre Morel
IBM Lab Boeblingen
