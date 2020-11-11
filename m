Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A207C2AEB46
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 09:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgKKI1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 03:27:06 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18716 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725468AbgKKI1A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Nov 2020 03:27:00 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AB837Vt079858;
        Wed, 11 Nov 2020 03:27:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=C+EAAKL2NmmLDTG9WZHc7ZR025H2ysGuvFcxiEmRd1k=;
 b=ncX3oNcH9a0aSvxy5MHycj/AM4PDECx/UXPKKJaMxbhl0QDu7rSIu+kf/ATqoTgsWwVh
 acg7gfns+3VFGO7/2Nwp5aB0DynR1mda7QDUJFw/A6ZYWJNQY080fYgm2lhQ8N91icG8
 85XIw0M4LhyjQkqJRnUYtVPpNsjcL9G9lKW8Ty3bxDwhjHTgYt+/vU6MKBvDMQweTQDC
 4MTVaM+ARhU5fBKxwCloj7vO1NJhB6Ow0ltZZwC+OCck6LrUxb7tBDDY02Fb6LECJF6O
 TxDrRJYAd2DkzW+bTCP/+0flQHxJVBSI+KjCVfRicNcNXq0namy7Pue2gMKC9LzgguU6 TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34qkt0b11b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Nov 2020 03:27:00 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AB8QD5c011853;
        Wed, 11 Nov 2020 03:26:59 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34qkt0b108-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Nov 2020 03:26:59 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AB8MjGp006661;
        Wed, 11 Nov 2020 08:26:57 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 34nk78m24s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Nov 2020 08:26:57 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AB8QsQX6161090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 08:26:54 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4511C4C063;
        Wed, 11 Nov 2020 08:26:54 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E21D94C050;
        Wed, 11 Nov 2020 08:26:53 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.72.90])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 11 Nov 2020 08:26:53 +0000 (GMT)
Subject: Re: [PATCH] kvm: s390: pv: Mark mm as protected after the set secure
 parameters and improve cleanup
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
References: <20201030140141.106641-1-frankja@linux.ibm.com>
 <f4381509-bf28-2159-b5a6-7dd9e9ee4816@de.ibm.com>
 <fbb49f93-0b73-f1b4-1630-6c973058a420@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <fd5a1f1b-1e4f-b9f1-6dc8-a7da90a655fe@de.ibm.com>
Date:   Wed, 11 Nov 2020 09:26:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <fbb49f93-0b73-f1b4-1630-6c973058a420@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-11_02:2020-11-10,2020-11-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=807 suspectscore=0 clxscore=1015 bulkscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 adultscore=0
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011110043
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11.11.20 09:17, Janosch Frank wrote:
> On 10/30/20 3:23 PM, Christian Borntraeger wrote:
>> On 30.10.20 15:01, Janosch Frank wrote:
>>> We can only have protected guest pages after a successful set secure
>>> parameters call as only then the UV allows imports and unpacks.
>>>
>>> By moving the test we can now also check for it in s390_reset_acc()
>>> and do an early return if it is 0.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>
>> Can we check this into devel to give it some test coverage?
> 
> I think this also lacks:
> Fixes: 29b40f105ec8 ("KVM: s390: protvirt: Add initial vm and cpu
> lifecycle handling")

Yes, it does. I will schedule for kvm/master.
