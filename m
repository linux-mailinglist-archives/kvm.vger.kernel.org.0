Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57A7C427AB
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 15:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbfFLNdu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 09:33:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41666 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406367AbfFLNdu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Jun 2019 09:33:50 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CDIHRX053853
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 09:33:49 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t3045q00e-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 09:33:49 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Wed, 12 Jun 2019 14:33:46 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 12 Jun 2019 14:33:43 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5CDXfLL27263206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 13:33:41 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB36252067;
        Wed, 12 Jun 2019 13:33:41 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.26])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 458F252054;
        Wed, 12 Jun 2019 13:33:41 +0000 (GMT)
Date:   Wed, 12 Jun 2019 15:33:24 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        "Jason J. Herne" <jjherne@linux.ibm.com>
Subject: Re: [PATCH v4 4/8] s390/airq: use DMA memory for adapter interrupts
In-Reply-To: <20190612082127.3fd63091.cohuck@redhat.com>
References: <20190606115127.55519-1-pasic@linux.ibm.com>
        <20190606115127.55519-5-pasic@linux.ibm.com>
        <20190611121721.61bf09b4.cohuck@redhat.com>
        <20190611162721.67ca8932.pasic@linux.ibm.com>
        <20190611181944.5bf2b953.cohuck@redhat.com>
        <20190612023231.7da4908c.pasic@linux.ibm.com>
        <20190612082127.3fd63091.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19061213-0012-0000-0000-000003287F9E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061213-0013-0000-0000-000021618793
Message-Id: <20190612153324.3dc6632c.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=832 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120092
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 Jun 2019 08:21:27 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Wed, 12 Jun 2019 02:32:31 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 
> > On Tue, 11 Jun 2019 18:19:44 +0200
> > Cornelia Huck <cohuck@redhat.com> wrote:
> >   
> > > On Tue, 11 Jun 2019 16:27:21 +0200
> > > Halil Pasic <pasic@linux.ibm.com> wrote:  
> 
> > > > IMHO the cleanest thing to do at this stage is to check if the
> > > > airq_iv_cache is NULL and fail the allocation if it is (to preserve
> > > > previous behavior).    
> > > 
> > > That's probably the least invasive fix for now. Did you check whether
> > > any of the other dma pools this series introduces have a similar
> > > problem due to init not failing?
> > >    
> > 
> > Good question!
> > 
> > I did a quick check. virtio_ccw_init() should be OK, because we don't
> > register the driver if allocation fails, so the thing is going to end
> > up dysfunctional as expected.
> > 
> > If however cio_dma_pool_init() fails, then we end up with the same
> > problem with airqs, just on the !AIRQ_IV_CACHELINE code path. It can be
> > fixed analogously: make cio_dma_zalloc() fail all allocation if
> > cio_dma_pool_init() failed before.  
> 
> Ok, makes sense.

v5 is out with the fixes. I have no ack/r-b from you for patch 4. Would
you like to give some, or should I proceed without?

Regards,
Halil

