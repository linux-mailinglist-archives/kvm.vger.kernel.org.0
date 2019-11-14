Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0900AFCC27
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 18:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfKNRxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 12:53:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64108 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725976AbfKNRxX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 12:53:23 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEHmC3D145969
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 12:53:22 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w993eqg93-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 12:52:43 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 14 Nov 2019 17:51:03 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 17:51:00 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEHoxOZ50987196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 17:50:59 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 895205204F;
        Thu, 14 Nov 2019 17:50:59 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.27])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 52B5452052;
        Thu, 14 Nov 2019 17:50:59 +0000 (GMT)
Subject: Re: [PATCH v1 4/4] s390x: Testing the Subchannel I/O read
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
 <1573647799-30584-5-git-send-email-pmorel@linux.ibm.com>
 <db451544-fcb1-9d81-7042-ef91c8324204@linux.ibm.com>
 <81ef68d4-5ec5-b14e-6c3d-6935e9a6a1c1@linux.ibm.com>
 <75b72389-eec5-200f-01af-512d1294f137@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Thu, 14 Nov 2019 18:50:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <75b72389-eec5-200f-01af-512d1294f137@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19111417-0012-0000-0000-00000363AB8C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111417-0013-0000-0000-0000219F2610
Message-Id: <4f6763fa-a97b-94eb-ac84-9416a653f009@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=644 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140153
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019-11-14 17:51, Thomas Huth wrote:
> On 14/11/2019 17.38, Pierre Morel wrote:
> [...]
>>>> +static char buffer[4096];
>>>> +
>>>> +static void delay(int d)
>>>> +{
>>>> +    int i, j;
>>>> +
>>>> +    while (d--)
>>>> +        for (i = 1000000; i; i--)
>>>> +            for (j = 1000000; j; j--)
>>>> +                ;
>>>> +}
>>> You could set a timer.
>> Hum, do we really want to do this?
> I'm pretty sure that the compiler optimizes empty loops away. Maybe have
> a look at the disassembly of your delay function...
>
> Anyway, it's likely better to use STCK and friends to get a proper
> timing. You could move get_clock_ms() from s390x/intercept.c to the
> lib/s390x folder and then use that function here.


Yes, I can, thanks.

Pierre



>
>   Thomas
>
-- 
Pierre Morel
IBM Lab Boeblingen

