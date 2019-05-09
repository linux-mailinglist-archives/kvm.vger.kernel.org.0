Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAC218AB3
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 15:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfEINaT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 09:30:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36774 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726054AbfEINaT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 May 2019 09:30:19 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x49DNOFO024614
        for <kvm@vger.kernel.org>; Thu, 9 May 2019 09:30:17 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2scjnfy374-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 09 May 2019 09:30:17 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 9 May 2019 14:30:15 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 9 May 2019 14:30:11 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x49DU9wK33882182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 May 2019 13:30:09 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8827E4204D;
        Thu,  9 May 2019 13:30:09 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98F5242054;
        Thu,  9 May 2019 13:30:08 +0000 (GMT)
Received: from [9.145.47.201] (unknown [9.145.47.201])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 May 2019 13:30:08 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH 09/10] virtio/s390: use DMA memory for ccw I/O and classic
 notifiers
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>
Cc:     virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
 <20190426183245.37939-10-pasic@linux.ibm.com>
 <a873909a-9846-d6d3-f03e-e86d53fd9c75@linux.ibm.com>
Date:   Thu, 9 May 2019 15:30:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <a873909a-9846-d6d3-f03e-e86d53fd9c75@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050913-0016-0000-0000-00000279F49B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050913-0017-0000-0000-000032D6A9C4
Message-Id: <db036887-c238-9795-5f47-cfeb475074e4@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905090081
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/05/2019 16:46, Pierre Morel wrote:
> On 26/04/2019 20:32, Halil Pasic wrote:
>> Before virtio-ccw could get away with not using DMA API for the pieces of
>> memory it does ccw I/O with. With protected virtualization this has to
>> change, since the hypervisor needs to read and sometimes also write these
>> pieces of memory.
>>
>> The hypervisor is supposed to poke the classic notifiers, if these are
>> used, out of band with regards to ccw I/O. So these need to be allocated
>> as DMA memory (which is shared memory for protected virtualization
>> guests).
>>
>> Let us factor out everything from struct virtio_ccw_device that needs to
>> be DMA memory in a satellite that is allocated as such.
>>
...
>> +                       sizeof(indicators(vcdev)));
> 
> should be sizeof(long) ?
> 
> This is a recurrent error, but it is not an issue because the size of
> the indicators is unsigned long as the size of the pointer.
> 
> Regards,
> Pierre
> 

Here too, with the problem of the indicator size handled:
Reviewed-by: Pierre Morel<pmorel@linux.ibm.com>


-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany

