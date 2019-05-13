Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F189A1B663
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 14:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730003AbfEMMuw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 08:50:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56516 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729557AbfEMMuv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 May 2019 08:50:51 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4DCcBmn047169
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 08:50:50 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sf8g09f2h-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 08:50:50 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Mon, 13 May 2019 13:50:48 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 13 May 2019 13:50:45 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4DCohaK52101178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 12:50:43 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0EB942045;
        Mon, 13 May 2019 12:50:43 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DDB542049;
        Mon, 13 May 2019 12:50:43 +0000 (GMT)
Received: from [9.152.97.147] (unknown [9.152.97.147])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 13 May 2019 12:50:43 +0000 (GMT)
Reply-To: mimu@linux.ibm.com
Subject: Re: [PATCH 04/10] s390/mm: force swiotlb for protected virtualization
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
 <20190426183245.37939-5-pasic@linux.ibm.com>
 <20190426192711.GA31463@infradead.org>
 <20190429155951.3175fef5.pasic@linux.ibm.com>
 <3b9956a5-d8da-65fa-a2f7-4f54087d91d6@de.ibm.com>
From:   Michael Mueller <mimu@linux.ibm.com>
Organization: IBM
Date:   Mon, 13 May 2019 14:50:42 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <3b9956a5-d8da-65fa-a2f7-4f54087d91d6@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19051312-0016-0000-0000-0000027B266B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051312-0017-0000-0000-000032D7EB0E
Message-Id: <b80f9f39-73a9-de29-9b7a-c720bb7f215f@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-13_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=875 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905130090
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 29.04.19 16:05, Christian Borntraeger wrote:
> 
> 
> On 29.04.19 15:59, Halil Pasic wrote:
>> On Fri, 26 Apr 2019 12:27:11 -0700
>> Christoph Hellwig <hch@infradead.org> wrote:
>>
>>> On Fri, Apr 26, 2019 at 08:32:39PM +0200, Halil Pasic wrote:
>>>> +EXPORT_SYMBOL_GPL(set_memory_encrypted);
>>>
>>>> +EXPORT_SYMBOL_GPL(set_memory_decrypted);
>>>
>>>> +EXPORT_SYMBOL_GPL(sev_active);
>>>
>>> Why do you export these?  I know x86 exports those as well, but
>>> it shoudn't be needed there either.
>>>
>>
>> I export these to be in line with the x86 implementation (which
>> is the original and seems to be the only one at the moment). I assumed
>> that 'exported or not' is kind of a part of the interface definition.
>> Honestly, I did not give it too much thought.
>>
>> For x86 set_memory(en|de)crypted got exported by 95cf9264d5f3 "x86, drm,
>> fbdev: Do not specify encrypted memory for video mappings" (Tom
>> Lendacky, 2017-07-17). With CONFIG_FB_VGA16=m seems to be necessary for x84.
>>
>> If the consensus is don't export: I won't. I'm fine one way or the other.
>> @Christian, what is your take on this?
> 
> If we do not need it today for anything (e.g. virtio-gpu) then we can get rid
> of the exports (and introduce them when necessary).

I'll take them out then.

>>
>> Thank you very much!
>>
>> Regards,
>> Halil
>>
>>
> 

