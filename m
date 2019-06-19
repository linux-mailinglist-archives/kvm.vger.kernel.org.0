Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94D6E4B6C9
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 13:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731593AbfFSLMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 07:12:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11936 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726826AbfFSLMG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jun 2019 07:12:06 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5JB7qLo134311;
        Wed, 19 Jun 2019 07:11:48 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t7kq9903m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jun 2019 07:11:47 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x5JBACHh027517;
        Wed, 19 Jun 2019 11:11:47 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 2t4ra62bh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jun 2019 11:11:46 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5JBBjiL24772960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 11:11:45 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DAD77805C;
        Wed, 19 Jun 2019 11:11:45 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 088FC78063;
        Wed, 19 Jun 2019 11:11:43 +0000 (GMT)
Received: from [9.80.214.94] (unknown [9.80.214.94])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 19 Jun 2019 11:11:43 +0000 (GMT)
Subject: Re: [RFC PATCH v1 0/5] s390: more vfio-ccw code rework
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20190618202352.39702-1-farman@linux.ibm.com>
 <20190619102501.3be69000.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <9ea22f6e-d6df-3586-f4d5-23ee0df3ceb5@linux.ibm.com>
Date:   Wed, 19 Jun 2019 07:11:43 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190619102501.3be69000.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-19_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906190093
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/19/19 4:25 AM, Cornelia Huck wrote:
> On Tue, 18 Jun 2019 22:23:47 +0200
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> A couple little improvements to the malloc load in vfio-ccw.
>> Really, there were just (the first) two patches, but then I
>> got excited and added a few stylistic ones to the end.
>>
>> The routine ccwchain_calc_length() has this basic structure:
>>
>>   ccwchain_calc_length
>>     a0 = kcalloc(CCWCHAIN_LEN_MAX, sizeof(struct ccw1))
>>     copy_ccw_from_iova(a0, src)
>>       copy_from_iova
>>         pfn_array_alloc
>>           b = kcalloc(len, sizeof(*pa_iova_pfn + *pa_pfn)
>>         pfn_array_pin
>>           vfio_pin_pages
>>         memcpy(a0, src)
>>         pfn_array_unpin_free
>>           vfio_unpin_pages
>>           kfree(b)
>>     kfree(a0)
>>
>> We do this EVERY time we process a new channel program chain,
>> meaning at least once per SSCH and more if TICs are involved,
>> to figure out how many CCWs are chained together.  Once that
>> is determined, a new piece of memory is allocated (call it a1)
>> and then passed to copy_ccw_from_iova() again, but for the
>> value calculated by ccwchain_calc_length().
>>
>> This seems inefficient.
>>
>> Patch 1 moves the malloc of a0 from the CCW processor to the
>> initialization of the device.  Since only one SSCH can be
>> handled concurrently, we can use this space safely to
>> determine how long the chain being processed actually is.
>>
>> Patch 2 then removes the second copy_ccw_from_iova() call
>> entirely, and replaces it with a memcpy from a0 to a1.  This
>> is done before we process a TIC and thus a second chain, so
>> there is no overlap in the storage in channel_program.
>>
>> Patches 3-5 clean up some things that aren't as clear as I'd
>> like, but didn't want to pollute the first two changes.
>> For example, patch 3 moves the population of guest_cp to the
>> same routine that copies from it, rather than in a called
>> function.  Meanwhile, patch 4 (and thus, 5) was something I
>> had lying around for quite some time, because it looked to
>> be structured weird.  Maybe that's one bridge too far.
> 
> I think this is worthwhile.
> 
>>
>> Eric Farman (5):
>>   vfio-ccw: Move guest_cp storage into common struct
>>   vfio-ccw: Skip second copy of guest cp to host
>>   vfio-ccw: Copy CCW data outside length calculation
>>   vfio-ccw: Factor out the ccw0-to-ccw1 transition
>>   vfio-ccw: Remove copy_ccw_from_iova()
>>
>>  drivers/s390/cio/vfio_ccw_cp.c  | 108 +++++++++++---------------------
>>  drivers/s390/cio/vfio_ccw_cp.h  |   7 +++
>>  drivers/s390/cio/vfio_ccw_drv.c |   7 +++
>>  3 files changed, 52 insertions(+), 70 deletions(-)
>>
> 
> Ok, so I just wanted to take a quick look, and then ended up reviewing
> it all :)

Haha, oops!  :)  Thank you!  That was a nice surprise.

> 
> Will give others some time to look at this before I queue.
> 

Sounds great!  I'll get back to my own reviews (notes the gentle
reminder on qemu :)
