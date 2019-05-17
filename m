Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE10D219B3
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 16:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbfEQOUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 10:20:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35974 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728383AbfEQOUh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 May 2019 10:20:37 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4HECsQE061168
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 10:20:36 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2shwt9tntv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 10:20:35 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Fri, 17 May 2019 15:20:34 +0100
Received: from b01cxnp23033.gho.pok.ibm.com (9.57.198.28)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 17 May 2019 15:20:31 +0100
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4HEKUlW34669000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 14:20:30 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BB10112062;
        Fri, 17 May 2019 14:20:30 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C668A112066;
        Fri, 17 May 2019 14:20:29 +0000 (GMT)
Received: from [9.85.203.43] (unknown [9.85.203.43])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 17 May 2019 14:20:29 +0000 (GMT)
Subject: Re: [PATCH v3 1/3] s390/cio: Don't pin vfio pages for empty transfers
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20190516161403.79053-1-farman@linux.ibm.com>
 <20190516161403.79053-2-farman@linux.ibm.com>
 <20190517110635.5204a9e8.cohuck@redhat.com>
 <4e4b46e6-3dfd-9ef7-71e9-4859ace10d25@linux.ibm.com>
 <20190517160604.62265254.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Date:   Fri, 17 May 2019 10:20:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190517160604.62265254.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19051714-0072-0000-0000-0000042EE721
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011112; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01204645; UDB=6.00632414; IPR=6.00985580;
 MB=3.00026931; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-17 14:20:32
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051714-0073-0000-0000-00004C42007C
Message-Id: <c508d807-ff03-8c8c-09b8-797a77296177@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-17_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905170089
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/17/19 10:06 AM, Cornelia Huck wrote:
> On Fri, 17 May 2019 08:57:10 -0400
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> On 5/17/19 5:06 AM, Cornelia Huck wrote:
>>> On Thu, 16 May 2019 18:14:01 +0200
>>> Eric Farman <farman@linux.ibm.com> wrote:
>>>   
>>>> The skip flag of a CCW offers the possibility of data not being
>>>> transferred, but is only meaningful for certain commands.
>>>> Specifically, it is only applicable for a read, read backward, sense,
>>>> or sense ID CCW and will be ignored for any other command code
>>>> (SA22-7832-11 page 15-64, and figure 15-30 on page 15-75).
>>>>
>>>> (A sense ID is xE4, while a sense is x04 with possible modifiers in the
>>>> upper four bits.  So we will cover the whole "family" of sense CCWs.)
>>>>
>>>> For those scenarios, since there is no requirement for the target
>>>> address to be valid, we should skip the call to vfio_pin_pages() and
>>>> rely on the IDAL address we have allocated/built for the channel
>>>> program.  The fact that the individual IDAWs within the IDAL are
>>>> invalid is fine, since they aren't actually checked in these cases.
>>>>
>>>> Set pa_nr to zero when skipping the pfn_array_pin() call, since it is
>>>> defined as the number of pages pinned and is used to determine
>>>> whether to call vfio_unpin_pages() upon cleanup.
>>>>
>>>> As we do this, since the pfn_array_pin() routine returns the number of
>>>> pages pinned, and we might not be doing that, the logic for converting
>>>> a CCW from direct-addressed to IDAL needs to ensure there is room for
>>>> one IDAW in the IDAL being built since a zero-length IDAL isn't great.  
>>>
>>> I have now read this sentence several times and that this and that
>>> confuses me :)  
>>
>> I have read this code for several months and I'm still confused.  :)
> 
> Lol, I guess you are not alone :)
> 
>>
>>> What are we doing, and what is the thing that we might
>>> not be doing?  
>>
>> In the codepath that converts a direct-addressed CCW into an indirect
>> one, we currently rely on the returned value from pfn_array_pin() to
>> tell us how many pages were pinned, and thus how big of an IDAL to
>> allocate.  But since this patch causes us to skip the call to
>> pfn_array_pin() for certain CCWs, using that value would be zero
>> (leftover from pfn_array_alloc()) and thus would be weird to pass to the
>> kcalloc() for our IDAL.  We definitely want to allocate our own IDAL so
>> that CCW.CDA contains a valid address, regardless of whether the IDAWs
>> will be populated or not, so we calculate the number of pages ourselves
>> here.
>>
>> (Sidebar, the above is not a concern for the IDAL-to-IDAL codepath,
>> since it has already calculated the size of the IDAL from the guest CCW
>> and is going page-by-page through it.)
>>
>> pfn_array_pin() doesn't return "partial pin" counts.  If we ask for 10
>> pages to be pinned and it only does 5, we're going to get an error that
>> we have to clean up from, rather than carrying on as if "up to 10" pages
>> pinned was acceptable.  To say that another way, there's no SLI bit for
>> the vfio_pin_pages() call, so it's not necessary to rely on the count
>> being returned if we ourselves calculate it.
>>
>> So, with that...  Maybe the paragraph in question should be something
>> like this?
>>
>> ---8<---
>> The pfn_array_pin() routine returns the number of pages that were
>> pinned, but now might be skipped for some CCWs.  Thus we need to
>> calculate the expected number of pages ourselves such that we are
>> guaranteed to allocate a reasonable number of IDAWs, which will
>> provide a valid address in CCW.CDA regardless of whether the IDAWs
>> are filled in with pinned/translated addresses or not.
> 
> Much better, thanks!
> 
> I can change the description when picking up, if no reason for a respin
> comes up (series seems sane to me so far).

I appreciate that, thank you!  Looking forward to what others may say.

 - Eric

> 
>>
>>>   
>>>>
>>>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>>>> ---
>>>>   drivers/s390/cio/vfio_ccw_cp.c | 55 ++++++++++++++++++++++++++++++----
>>>>   1 file changed, 50 insertions(+), 5 deletions(-)  
>>>   
> 

