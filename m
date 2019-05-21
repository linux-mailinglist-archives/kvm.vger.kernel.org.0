Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2CF24ABD
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 10:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfEUIsl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 04:48:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52260 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726247AbfEUIsl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 May 2019 04:48:41 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4L8m8B6065996
        for <kvm@vger.kernel.org>; Tue, 21 May 2019 04:48:39 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2smd06tw2b-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 21 May 2019 04:48:35 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Tue, 21 May 2019 09:46:55 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 21 May 2019 09:46:53 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4L8kprD44761154
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 08:46:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9B0F42045;
        Tue, 21 May 2019 08:46:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1634A42041;
        Tue, 21 May 2019 08:46:51 +0000 (GMT)
Received: from [9.152.98.87] (unknown [9.152.98.87])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 May 2019 08:46:51 +0000 (GMT)
Reply-To: mimu@linux.ibm.com
Subject: Re: [PATCH 05/10] s390/cio: introduce DMA pools to cio
To:     Halil Pasic <pasic@linux.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
 <20190426183245.37939-6-pasic@linux.ibm.com>
 <alpine.LFD.2.21.1905081447280.1773@schleppi>
 <20190508232210.5a555caa.pasic@linux.ibm.com>
 <20190509121106.48aa04db.cohuck@redhat.com>
 <20190510001112.479b2fd7.pasic@linux.ibm.com>
 <20190510161013.7e697337.cohuck@redhat.com>
 <20190512202256.5517592d.pasic@linux.ibm.com>
 <alpine.LFD.2.21.1905161517570.1767@schleppi>
 <20190520141312.4e3a2d36.pasic@linux.ibm.com>
From:   Michael Mueller <mimu@linux.ibm.com>
Organization: IBM
Date:   Tue, 21 May 2019 10:46:50 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520141312.4e3a2d36.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19052108-4275-0000-0000-00000336FB79
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052108-4276-0000-0000-000038468F1A
Message-Id: <af3479db-691c-ddd3-0253-f379cc528f57@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-21_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905210057
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20.05.19 14:13, Halil Pasic wrote:
> On Thu, 16 May 2019 15:59:22 +0200 (CEST)
> Sebastian Ott <sebott@linux.ibm.com> wrote:
> 
>> On Sun, 12 May 2019, Halil Pasic wrote:
>>> I've also got code that deals with AIRQ_IV_CACHELINE by turning the
>>> kmem_cache into a dma_pool.
>>>
>>> Cornelia, Sebastian which approach do you prefer:
>>> 1) get rid of cio_dma_pool and AIRQ_IV_CACHELINE, and waste a page per
>>> vector, or
>>> 2) go with the approach taken by the patch below?
>>
>> We only have a couple of users for airq_iv:
>>
>> virtio_ccw.c: 2K bits
> 
> 
> You mean a single allocation is 2k bits (VIRTIO_IV_BITS = 256 * 8)? My
> understanding is that the upper bound is more like:
> MAX_AIRQ_AREAS * VIRTIO_IV_BITS = 20 * 256 * 8 = 40960 bits.
> 
> In practice it is most likely just 2k.
> 
>>
>> pci with floating IRQs: <= 2K (for the per-function bit vectors)
>>                          1..4K (for the summary bit vector)
>>
> 
> As far as I can tell with virtio_pci arch_setup_msi_irqs() gets called
> once per device and allocates a small number of bits (2 and 3 in my
> test, it may depend on #virtqueues, but I did not check).
> 
> So for an upper bound we would have to multiply with the upper bound of
> pci devices/functions. What is the upper bound on the number of
> functions?
> 
>> pci with CPU directed IRQs: 2K (for the per-CPU bit vectors)
>>                              1..nr_cpu (for the summary bit vector)
>>
> 
> I guess this is the same.
> 
>>
>> The options are:
>> * page allocations for everything
> 
> Worst case we need 20 + #max_pci_dev pages. At the moment we allocate
> from ZONE_DMA (!) and waste a lot.
> 
>> * dma_pool for AIRQ_IV_CACHELINE ,gen_pool for others
> 
> I prefer this. Explanation follows.
> 
>> * dma_pool for everything
>>
> 
> Less waste by factor factor 16.
> 
>> I think we should do option 3 and use a dma_pool with cachesize
>> alignment for everything (as a prerequisite we have to limit
>> config PCI_NR_FUNCTIONS to 2K - but that is not a real constraint).
>>
> 
> I prefer option 3 because it is conceptually the smallest change, and
> provides the behavior which is closest to the current one.
> 
> Commit  414cbd1e3d14 "s390/airq: provide cacheline aligned
> ivs" (Sebastian Ott, 2019-02-27) could have been smaller had you implemented
> 'kmem_cache for everything' (and I would have had just to replace kmem_cache with
> dma_cache to achieve option 3). For some reason you decided to keep the
> iv->vector = kzalloc(size, GFP_KERNEL) code-path and make the client code request
> iv->vector = kmem_cache_zalloc(airq_iv_cache, GFP_KERNEL) explicitly, using a flag
> which you only decided to use for directed pci irqs AFAICT.
> 
> My understanding of these decisions, and especially of the rationale
> behind commit 414cbd1e3d14 is limited. Thus if option 3 is the way to
> go, and the choices made by 414cbd1e3d14 were sub-optimal, I would feel
> much more comfortable if you provided a patch that revises  and switches
> everything to kmem_chache. I would then just swap kmem_cache out with a
> dma_cache and my change would end up a straightforward and relatively
> clean one.
> 
> So Sebastian, what shall we do?
> 
> Regards,
> Halil
> 
> 
> 
> 
>> Sebastian
>>
> 

Folks, I had a version running with slight changes to the initial
v1 patch set together with a revert of 414cbd1e3d14 "s390/airq: provide 
cacheline aligned ivs". That of course has the deficit of the memory
usage pattern.

Now you are discussing same substantial changes. The exercise was to
get an initial working code through the door. We really need a decision!


Michael

