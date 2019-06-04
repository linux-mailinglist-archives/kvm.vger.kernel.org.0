Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C39634894
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 15:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfFDNXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 09:23:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47690 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727264AbfFDNXG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Jun 2019 09:23:06 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x54DEhFm035992
        for <kvm@vger.kernel.org>; Tue, 4 Jun 2019 09:23:05 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2swrc5uk4x-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2019 09:23:05 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Tue, 4 Jun 2019 14:23:03 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 4 Jun 2019 14:23:01 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x54DMwfd52559956
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Jun 2019 13:22:58 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7751CA4059;
        Tue,  4 Jun 2019 13:22:58 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C92A1A4051;
        Tue,  4 Jun 2019 13:22:57 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.145])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 Jun 2019 13:22:57 +0000 (GMT)
Date:   Tue, 4 Jun 2019 15:22:56 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Michael Mueller <mimu@linux.ibm.com>,
        KVM Mailing List <kvm@vger.kernel.org>,
        Linux-S390 Mailing List <linux-s390@vger.kernel.org>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: Re: [PATCH v3 4/8] s390/airq: use DMA memory for adapter interrupts
In-Reply-To: <20190603172740.1023e078.cohuck@redhat.com>
References: <20190529122657.166148-1-mimu@linux.ibm.com>
        <20190529122657.166148-5-mimu@linux.ibm.com>
        <20190603172740.1023e078.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19060413-4275-0000-0000-0000033C8EB0
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060413-4276-0000-0000-0000384C9DAA
Message-Id: <20190604152256.158d688c.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-04_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906040090
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 3 Jun 2019 17:27:40 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Wed, 29 May 2019 14:26:53 +0200
> Michael Mueller <mimu@linux.ibm.com> wrote:
> 
> > From: Halil Pasic <pasic@linux.ibm.com>
> > 
> > Protected virtualization guests have to use shared pages for airq
> > notifier bit vectors, because hypervisor needs to write these bits.
> > 
> > Let us make sure we allocate DMA memory for the notifier bit vectors by
> > replacing the kmem_cache with a dma_cache and kalloc() with
> > cio_dma_zalloc().
> > 
> > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > Reviewed-by: Sebastian Ott <sebott@linux.ibm.com>
> > Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> > ---
> >  arch/s390/include/asm/airq.h |  2 ++
> >  drivers/s390/cio/airq.c      | 32 ++++++++++++++++++++------------
> >  drivers/s390/cio/cio.h       |  2 ++
> >  drivers/s390/cio/css.c       |  1 +
> >  4 files changed, 25 insertions(+), 12 deletions(-)
> 
> Apologies if that already has been answered (and I missed it in my mail
> pile...), but two things had come to my mind previously:
> 
> - CHSC... does anything need to be done there? Last time I asked:
>   "Anyway, css_bus_init() uses some chscs
>    early (before cio_dma_pool_init), so we could not use the pools
>    there, even if we wanted to. Do chsc commands either work, or else
>    fail benignly on a protected virt guest?"

Protected virt won't support all CHSC. The supported ones won't requre
use of shared memory. So we are fine.

> - PCI indicators... does this interact with any dma configuration on
>   the pci device? (I know pci is not supported yet, and I don't really
>   expect any problems.)
> 

It does but, I'm pretty confident we don't have a problem with PCI. IMHO
Sebastian is the guy who needs to be paranoid about this, and he r-b-ed
the respective patches.

Regards,
Halil

