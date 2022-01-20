Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9DE494BB5
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 11:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376274AbiATKaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 05:30:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43758 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1359764AbiATKaP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 05:30:15 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20K8VU0T007756;
        Thu, 20 Jan 2022 10:30:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=yRChjvKoG7qtxswec0iJDshzNuJRtiMV9rzF7i/n/n0=;
 b=EirXxrMyg5NmpQs7tx8eRx0LX1qO1Y961YG6oqjLmZdXLeUwUnDwdCtP7sxMGdETmavK
 dDNglpt+A+e3OKMa2UUMgMIpcRl8ZNDge+YszQKW+zy+1ryhMLXaGvzcFDb8p05gYD4/
 xnrGtep00fsvmFKRUY5fIDtJLfUbkbnC6T4GGaytAQpWVQixLaLsKiqbtkaYTWSCGlml
 c+xARFi20nkT0PZhHDNzSdvVpoPLJHBHDzUEoUsj4pWNaMjV7m/cQA3t5d8/+Ay0/2LY
 vCW+1OmPKfkUbjVC4IYh2c8uGuF0mamHMkWKnII7Vvgb1MVQruA0g/cBy9gu2ITbj4+K QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dq15w5u5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 10:30:15 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20K8hFvZ000513;
        Thu, 20 Jan 2022 10:30:15 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dq15w5u4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 10:30:15 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20KAO64n009235;
        Thu, 20 Jan 2022 10:30:13 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3dknwa817h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 10:30:12 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20KAU9SH40370464
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 10:30:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 939F011C052;
        Thu, 20 Jan 2022 10:30:09 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29B0311C069;
        Thu, 20 Jan 2022 10:30:09 +0000 (GMT)
Received: from [9.171.35.3] (unknown [9.171.35.3])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Jan 2022 10:30:09 +0000 (GMT)
Message-ID: <6d3a4e4e-a038-0a30-6846-3f07948dab08@linux.ibm.com>
Date:   Thu, 20 Jan 2022 11:30:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC PATCH v1 02/10] KVM: s390: Honor storage keys when accessing
 guest memory
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220118095210.1651483-1-scgl@linux.ibm.com>
 <20220118095210.1651483-3-scgl@linux.ibm.com>
 <e5b06907-471d-fe4f-8461-a7dea37abca2@linux.ibm.com>
 <d5247a6c-2088-cbfa-20f9-c1c748f90daf@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <d5247a6c-2088-cbfa-20f9-c1c748f90daf@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jktopad3-aKLUFRDUQDC5Cibu0GFaRG9
X-Proofpoint-ORIG-GUID: Q60RhR0WIN1eMZlM16l0CWCZJmaTI9DY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-20_03,2022-01-19_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 adultscore=0 suspectscore=0 phishscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/20/22 11:27, Christian Borntraeger wrote:
> 
> 
> Am 18.01.22 um 15:38 schrieb Janosch Frank:
> [...]
>> /*
>> We'll do an actual access via the mv instruction which will return access errors to us so we don't need to check here.
>> */
> 
> Be slightly more verbose I guess. Something like
> We'll do an actual access via the mv instruction which will return access errors to us so we don't need to check here.
> By using key 0 all checks are skipped and no performance overhead occurs.
> 
> ?

Yes, I'll also mention that we implement storage protection override by retrying.
> 
>>> +    rc = guest_range_to_gpas(vcpu, ga, ar, gpas, len, asce, mode, 0);

