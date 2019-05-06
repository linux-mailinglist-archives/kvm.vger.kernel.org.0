Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7435015077
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 17:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfEFPlB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 11:41:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42040 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726520AbfEFPlB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 May 2019 11:41:01 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x46Fcr5a014808
        for <kvm@vger.kernel.org>; Mon, 6 May 2019 11:41:00 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sap714su1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 06 May 2019 11:40:59 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Mon, 6 May 2019 16:40:58 +0100
Received: from b03cxnp08027.gho.boulder.ibm.com (9.17.130.19)
        by e31.co.us.ibm.com (192.168.1.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 6 May 2019 16:40:57 +0100
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x46Feub511272676
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 May 2019 15:40:56 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07292C6055;
        Mon,  6 May 2019 15:40:56 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 323D1C6059;
        Mon,  6 May 2019 15:40:55 +0000 (GMT)
Received: from [9.85.230.129] (unknown [9.85.230.129])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  6 May 2019 15:40:55 +0000 (GMT)
Subject: Re: [PATCH 6/7] s390/cio: Don't pin vfio pages for empty transfers
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20190503134912.39756-1-farman@linux.ibm.com>
 <20190503134912.39756-7-farman@linux.ibm.com>
 <20190506172054.612fd557.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Date:   Mon, 6 May 2019 11:40:54 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190506172054.612fd557.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19050615-8235-0000-0000-00000E90164F
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011060; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01199457; UDB=6.00629269; IPR=6.00980333;
 MB=3.00026755; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-06 15:40:58
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050615-8236-0000-0000-00004572992D
Message-Id: <d99db4cd-a671-ad3b-ba52-2b50c8cd40aa@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-06_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=946 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905060133
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/6/19 11:20 AM, Cornelia Huck wrote:
> On Fri,  3 May 2019 15:49:11 +0200
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> If a CCW has a count of zero, then no data will be transferred and
>> pinning/unpinning memory is unnecessary.
>>
>> In addition to that, the skip flag of a CCW offers the possibility of
>> data not being transferred, but is only meaningful for certain commands.
>> Specifically, it is only applicable for a read, read backward, sense, or
>> sense ID CCW and will be ignored for any other command code
>> (SA22-7832-11 page 15-64, and figure 15-30 on page 15-75).
> 
> This made me look at QEMU, and it seems that we cheerfully ignore that
> flag so far in our ccw interpretation code :/

Yup...  :(

> 
>>
>> (A sense ID is xE4, while a sense is x04 with possible modifiers in the
>> upper four bits.  So we will cover the whole "family" of sense CCWs.)
>>
>> For all those scenarios, since there is no requirement for the target
>> address to be valid, we should skip the call to vfio_pin_pages() and
>> rely on the IDAL address we have allocated/built for the channel
>> program.  The fact that the individual IDAWs within the IDAL are
>> invalid is fine, since they aren't actually checked in these cases.
>>
>> Set pa_nr to zero, when skipping the pfn_array_pin() call, since it is
>> defined as the number of pages pinned.  This will cause the vfio unpin
>> logic to return -EINVAL, but since the return code is not checked it
>> will not harm our cleanup path.
> 
> We could also try to skip the unpinning, but this works as well.

In an earlier version I had, I was re-purposing other fields in 
pfn_array, which was rather kludgy.  I could easily add a check for 
non-zero pa_nr here, just to be clear of what we're doing (or in case we 
decide TO check the return code from vfio_unpin_pages() some day).

> 
>>
>> As we do this, since the pfn_array_pin() routine returns the number of
>> pages pinned, and we might not be doing that, the logic for converting
>> a CCW from direct-addressed to IDAL needs to ensure there is room for
>> one IDAW in the IDAL being built since a zero-length IDAL isn't great.
>>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>   drivers/s390/cio/vfio_ccw_cp.c | 61 +++++++++++++++++++++++++++++++++++++-----
>>   1 file changed, 55 insertions(+), 6 deletions(-)
> 
> Looks good to me.
> 

