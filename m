Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1AE71F71A
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 17:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbfEOPEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 11:04:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53702 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726583AbfEOPEp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 May 2019 11:04:45 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4FF3ZLw079488;
        Wed, 15 May 2019 11:04:35 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sgmm7hpwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 May 2019 11:04:35 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x4F98b3K009289;
        Wed, 15 May 2019 09:08:58 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01dal.us.ibm.com with ESMTP id 2sdp14x68t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 May 2019 09:08:58 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4FF4XTT38994162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 May 2019 15:04:33 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93BE2B206B;
        Wed, 15 May 2019 15:04:33 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 745B2B2065;
        Wed, 15 May 2019 15:04:33 +0000 (GMT)
Received: from [9.60.85.4] (unknown [9.60.85.4])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 15 May 2019 15:04:33 +0000 (GMT)
Subject: Re: [PATCH v2 5/7] s390/cio: Allow zero-length CCWs in vfio-ccw
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20190514234248.36203-1-farman@linux.ibm.com>
 <20190514234248.36203-6-farman@linux.ibm.com>
 <20190515142339.12065a1d.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <f309cad9-9265-e276-8d57-8b6387f6fed7@linux.ibm.com>
Date:   Wed, 15 May 2019 11:04:33 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515142339.12065a1d.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-15_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=753 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905150093
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/15/19 8:23 AM, Cornelia Huck wrote:
> On Wed, 15 May 2019 01:42:46 +0200
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> It is possible that a guest might issue a CCW with a length of zero,
>> and will expect a particular response.  Consider this chain:
>>
>>     Address   Format-1 CCW
>>     --------  -----------------
>>   0 33110EC0  346022CC 33177468
>>   1 33110EC8  CF200000 3318300C
>>
>> CCW[0] moves a little more than two pages, but also has the
>> Suppress Length Indication (SLI) bit set to handle the expectation
>> that considerably less data will be moved.  CCW[1] also has the SLI
>> bit set, and has a length of zero.  Once vfio-ccw does its magic,
>> the kernel issues a start subchannel on behalf of the guest with this:
>>
>>     Address   Format-1 CCW
>>     --------  -----------------
>>   0 021EDED0  346422CC 021F0000
>>   1 021EDED8  CF240000 3318300C
>>
>> Both CCWs were converted to an IDAL and have the corresponding flags
>> set (which is by design), but only the address of the first data
>> address is converted to something the host is aware of.  The second
>> CCW still has the address used by the guest, which happens to be (A)
>> (probably) an invalid address for the host, and (B) an invalid IDAW
>> address (doubleword boundary, etc.).
>>
>> While the I/O fails, it doesn't fail correctly.  In this example, we
>> would receive a program check for an invalid IDAW address, instead of
>> a unit check for an invalid command.
>>
>> To fix this, revert commit 4cebc5d6a6ff ("vfio: ccw: validate the
>> count field of a ccw before pinning") and allow the individual fetch
>> routines to process them like anything else.  We'll make a slight
>> adjustment to our allocation of the pfn_array (for direct CCWs) or
>> IDAL (for IDAL CCWs) memory, so that we have room for at least one
>> address even though no data will be transferred.
>>
>> Note that this doesn't provide us with a channel program that will
>> fail in the expected way.  Since our length is zero, vfio_pin_pages()

s/is/was/

>> returns -EINVAL and cp_prefetch() will thus fail.  This will be fixed
>> in the next patch.
> 
> So, this failed before, and still fails, just differently? 

Probably.  If the guest gave us a valid address, the pin might actually 
work now whereas before it would fail because the length was zero.  If 
the address were also invalid,

 >IOW, this
> has no effect on bisectability?

I think so, but I suppose that either (A) patch 5 and 6 could be 
squashed together, or (B) I could move the "set pa_nr to zero" (or more 
accurately, set it to ccw->count) pieces from patch 6 into this patch, 
so that the vfio_pin_pages() call occurs like it does today.

> 
>>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>   drivers/s390/cio/vfio_ccw_cp.c | 26 ++++++++------------------
>>   1 file changed, 8 insertions(+), 18 deletions(-)
> 
