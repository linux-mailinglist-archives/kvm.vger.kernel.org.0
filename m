Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDCB208D2
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 16:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbfEPN7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 09:59:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48804 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727717AbfEPN7b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 May 2019 09:59:31 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4GDs3Qs136856
        for <kvm@vger.kernel.org>; Thu, 16 May 2019 09:59:30 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sh8mv9su6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 May 2019 09:59:30 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <sebott@linux.ibm.com>;
        Thu, 16 May 2019 14:59:27 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 16 May 2019 14:59:25 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4GDxNsh19726444
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 May 2019 13:59:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E3274203F;
        Thu, 16 May 2019 13:59:23 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB51042042;
        Thu, 16 May 2019 13:59:22 +0000 (GMT)
Received: from dyn-9-152-212-110.boeblingen.de.ibm.com (unknown [9.152.212.110])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 16 May 2019 13:59:22 +0000 (GMT)
Date:   Thu, 16 May 2019 15:59:22 +0200 (CEST)
From:   Sebastian Ott <sebott@linux.ibm.com>
X-X-Sender: sebott@schleppi
To:     Halil Pasic <pasic@linux.ibm.com>
cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>
Subject: Re: [PATCH 05/10] s390/cio: introduce DMA pools to cio
In-Reply-To: <20190512202256.5517592d.pasic@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com> <20190426183245.37939-6-pasic@linux.ibm.com> <alpine.LFD.2.21.1905081447280.1773@schleppi> <20190508232210.5a555caa.pasic@linux.ibm.com> <20190509121106.48aa04db.cohuck@redhat.com>
 <20190510001112.479b2fd7.pasic@linux.ibm.com> <20190510161013.7e697337.cohuck@redhat.com> <20190512202256.5517592d.pasic@linux.ibm.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH?=
 =?ISO-8859-15?Q?_=2F_Vorsitzende_des_Aufsichtsrats=3A_Matthias?=
 =?ISO-8859-15?Q?_Hartmann_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp?=
 =?ISO-8859-15?Q?_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Reg?=
 =?ISO-8859-15?Q?istergericht=3A_Amtsgericht_Stuttgart=2C_HRB_2432?=
 =?ISO-8859-15?Q?94=22?=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
x-cbid: 19051613-0028-0000-0000-0000036E602A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051613-0029-0000-0000-0000242DFB1E
Message-Id: <alpine.LFD.2.21.1905161517570.1767@schleppi>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-16_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=923 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905160092
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 12 May 2019, Halil Pasic wrote:
> I've also got code that deals with AIRQ_IV_CACHELINE by turning the
> kmem_cache into a dma_pool.
> 
> Cornelia, Sebastian which approach do you prefer:
> 1) get rid of cio_dma_pool and AIRQ_IV_CACHELINE, and waste a page per
> vector, or
> 2) go with the approach taken by the patch below?

We only have a couple of users for airq_iv:

virtio_ccw.c: 2K bits

pci with floating IRQs: <= 2K (for the per-function bit vectors)
                        1..4K (for the summary bit vector)

pci with CPU directed IRQs: 2K (for the per-CPU bit vectors)
                            1..nr_cpu (for the summary bit vector)


The options are:
* page allocations for everything
* dma_pool for AIRQ_IV_CACHELINE ,gen_pool for others
* dma_pool for everything

I think we should do option 3 and use a dma_pool with cachesize
alignment for everything (as a prerequisite we have to limit
config PCI_NR_FUNCTIONS to 2K - but that is not a real constraint).

Sebastian

