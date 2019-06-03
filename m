Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB76F3301F
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 14:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfFCMrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 08:47:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52578 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726713AbfFCMrQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Jun 2019 08:47:16 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x53CYx6E095130
        for <kvm@vger.kernel.org>; Mon, 3 Jun 2019 08:47:15 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sw1mf65aa-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2019 08:47:15 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Mon, 3 Jun 2019 13:47:13 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 3 Jun 2019 13:47:10 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x53Cl88M61472880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jun 2019 12:47:08 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47C01AE04D;
        Mon,  3 Jun 2019 12:47:08 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AEC6FAE045;
        Mon,  3 Jun 2019 12:47:07 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.145])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jun 2019 12:47:07 +0000 (GMT)
Date:   Mon, 3 Jun 2019 14:47:06 +0200
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
Subject: Re: [PATCH v3 2/8] s390/cio: introduce DMA pools to cio
In-Reply-To: <20190603133745.240c00a7.cohuck@redhat.com>
References: <20190529122657.166148-1-mimu@linux.ibm.com>
        <20190529122657.166148-3-mimu@linux.ibm.com>
        <20190603133745.240c00a7.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19060312-0012-0000-0000-000003225782
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060312-0013-0000-0000-0000215B318B
Message-Id: <20190603144706.2d458ccc.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-03_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030091
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 3 Jun 2019 13:37:45 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Wed, 29 May 2019 14:26:51 +0200
> Michael Mueller <mimu@linux.ibm.com> wrote:
> 
> > From: Halil Pasic <pasic@linux.ibm.com>
> > 
> > To support protected virtualization cio will need to make sure the
> > memory used for communication with the hypervisor is DMA memory.
> > 
> > Let us introduce one global pool for cio.
> > 
> > Our DMA pools are implemented as a gen_pool backed with DMA pages. The
> > idea is to avoid each allocation effectively wasting a page, as we
> > typically allocate much less than PAGE_SIZE.
> > 
> > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > Reviewed-by: Sebastian Ott <sebott@linux.ibm.com>
> > Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> > ---
> >  arch/s390/Kconfig           |   1 +
> >  arch/s390/include/asm/cio.h |  11 ++++
> >  drivers/s390/cio/css.c      | 120 ++++++++++++++++++++++++++++++++++++++++++--
> >  3 files changed, 128 insertions(+), 4 deletions(-)
> 
> (...)
> 
> > diff --git a/arch/s390/include/asm/cio.h b/arch/s390/include/asm/cio.h
> > index 1727180e8ca1..43c007d2775a 100644
> > --- a/arch/s390/include/asm/cio.h
> > +++ b/arch/s390/include/asm/cio.h
> > @@ -328,6 +328,17 @@ static inline u8 pathmask_to_pos(u8 mask)
> >  void channel_subsystem_reinit(void);
> >  extern void css_schedule_reprobe(void);
> >  
> > +extern void *cio_dma_zalloc(size_t size);
> > +extern void cio_dma_free(void *cpu_addr, size_t size);
> > +extern struct device *cio_get_dma_css_dev(void);
> > +
> > +struct gen_pool;
> 
> That forward declaration is a bit ugly... 

Can you explain to me what is ugly about it so I can avoid similar
mistakes in the future?

>I guess the alternative was
> include hell?
> 

What do you mean by include hell?

I decided to use a forward declaration because the guys that include
"cio.h" are not expected to require the interfaces defined in
linux/genalloc.h. My motivation to do it like this was the principle of
encapsulation.

Regards,
Halil

