Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044FB1D8A59
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 00:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgERWBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 18:01:14 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18402 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726386AbgERWBO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 18:01:14 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04ILUuYB145922;
        Mon, 18 May 2020 18:01:13 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31426n8t5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 18:01:13 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04IM1CuG052027;
        Mon, 18 May 2020 18:01:12 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31426n8t54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 18:01:12 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04ILdI7o016458;
        Mon, 18 May 2020 22:01:11 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01dal.us.ibm.com with ESMTP id 313x16k38y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 22:01:11 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04IM1AwG55050702
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 May 2020 22:01:10 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4351AE087;
        Mon, 18 May 2020 22:01:10 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57157AE08D;
        Mon, 18 May 2020 22:01:10 +0000 (GMT)
Received: from [9.160.58.3] (unknown [9.160.58.3])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 18 May 2020 22:01:10 +0000 (GMT)
Subject: Re: [RFC PATCH v2 0/4] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200513142934.28788-1-farman@linux.ibm.com>
 <20200514154601.007ae46f.pasic@linux.ibm.com>
 <4e00c83b-146f-9f1d-882b-a5378257f32c@linux.ibm.com>
 <20200515165539.2e4a8485.pasic@linux.ibm.com>
 <931b96fc-0bb5-cdc1-bb1c-102a96f346ea@linux.ibm.com>
 <20200515203759.4ffc6f31.pasic@linux.ibm.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <cb87469c-84ad-933a-3473-afa9b009c499@linux.ibm.com>
Date:   Mon, 18 May 2020 18:01:09 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200515203759.4ffc6f31.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_06:2020-05-15,2020-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=0
 impostorscore=0 cotscore=-2147483648 phishscore=0 mlxscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005180181
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/15/20 2:37 PM, Halil Pasic wrote:
> On Fri, 15 May 2020 14:12:05 -0400
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>>>>> Also why do we see the scenario you describe in the wild? I agree that
>>>>> this should be taken care of in the kernel as well, but according to my
>>>>> understanding QEMU is already supposed to reject the second SSCH (CPU 2)
>>>>> with cc 2 because it sees that FC clear function is set. Or?  
>>>>
>>>> Maybe for virtio, but for vfio this all gets passed through to the
>>>> kernel who makes that distinction. And as I've mentioned above, that's
>>>> not happening.  
>>>
>>> Let's have a look at the following qemu functions. AFAIK it is
>>> common to vfio and virtio, or? Will prefix my inline   
>>
>> My mistake, I didn't look far enough up the callchain in my quick look
>> at the code.
>>
>> ...snip...
>>
> 
> No problem. I'm glad I was at least little helpful.
> 
>>>
>>> So unless somebody (e.g. the kernel vfio-ccw) nukes the FC bits qemu
>>> should prevent the second SSCH from your example getting to the kernel,
>>> or?  
>>
>> It's not so much something "nukes the FC bits" ... but rather that that
>> the data in the irb_area of the io_region is going to reflect what the
>> subchannel told us for the interrupt.
> 
> This is why the word composition came into my mind. If the HW subchannel
> has FC clear, but QEMU subchannel does not the way things compose (or
> superpose) is fishy.
> 
>>
>> Hrm... If something is polling on TSCH instead of waiting for a tap on
>> the shoulder, that's gonna act weird too. Maybe the bits need to be in
>> io_region.irb_area proper, rather than this weird private->scsw space.
> 
> Do we agree that the scenario you described with that diagram should not
> have hit kernel in the first place, because if things were correct QEMU
> should have fenced the second SSCH?
> 
> I think you do, but want to be sure. If not, then we need to meditate
> some more on this.

I think I do too.  :)  I'll meditate on this a bit later, because...

> 
> I do tend to think that the kernel part is not supposed to rely on
> userspace playing nice.

...this is important, and I'd rather get the kernel buttoned up first
before sorting out QEMU.

 Especially when it comes to integrity and
> correctness. I can't tell  just yet if this is something we must
> or just can catch in the kernel module. I'm for catching it regardless,
> but I'm even more for everything working as it is supposed. :)
> 
> Regards,
> Halil
> 
