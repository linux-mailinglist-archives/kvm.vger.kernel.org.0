Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2468919032
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 20:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfEISak convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 9 May 2019 14:30:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39204 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726620AbfEISak (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 May 2019 14:30:40 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x49IQSeV083851
        for <kvm@vger.kernel.org>; Thu, 9 May 2019 14:30:39 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2scr8mk7j6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 09 May 2019 14:30:39 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Thu, 9 May 2019 19:30:37 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 9 May 2019 19:30:33 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x49IUV8038011016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 May 2019 18:30:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DE21A4059;
        Thu,  9 May 2019 18:30:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64C96A4053;
        Thu,  9 May 2019 18:30:30 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.181.188])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 May 2019 18:30:30 +0000 (GMT)
Date:   Thu, 9 May 2019 20:30:28 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
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
        Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH 09/10] virtio/s390: use DMA memory for ccw I/O and
 classic notifiers
In-Reply-To: <db036887-c238-9795-5f47-cfeb475074e4@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
        <20190426183245.37939-10-pasic@linux.ibm.com>
        <a873909a-9846-d6d3-f03e-e86d53fd9c75@linux.ibm.com>
        <db036887-c238-9795-5f47-cfeb475074e4@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-TM-AS-GCONF: 00
x-cbid: 19050918-0020-0000-0000-0000033B0534
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050918-0021-0000-0000-0000218DAD8C
Message-Id: <20190509203028.5b75eaa2.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=949 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905090105
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 May 2019 15:30:08 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 08/05/2019 16:46, Pierre Morel wrote:
> > On 26/04/2019 20:32, Halil Pasic wrote:
> >> Before virtio-ccw could get away with not using DMA API for the pieces of
> >> memory it does ccw I/O with. With protected virtualization this has to
> >> change, since the hypervisor needs to read and sometimes also write these
> >> pieces of memory.
> >>
> >> The hypervisor is supposed to poke the classic notifiers, if these are
> >> used, out of band with regards to ccw I/O. So these need to be allocated
> >> as DMA memory (which is shared memory for protected virtualization
> >> guests).
> >>
> >> Let us factor out everything from struct virtio_ccw_device that needs to
> >> be DMA memory in a satellite that is allocated as such.
> >>
> ...
> >> +                       sizeof(indicators(vcdev)));
> > 
> > should be sizeof(long) ?

If something different then sizeof(u64) IMHO.
> > 
> > This is a recurrent error, but it is not an issue because the size of
> > the indicators is unsigned long as the size of the pointer.

I don't think there is an error, let alone a recurrent one.

> > 
> > Regards,
> > Pierre
> > 
> 
> Here too, with the problem of the indicator size handled:

I've laid out my view in a response to your comment on patch #8.

> Reviewed-by: Pierre Morel<pmorel@linux.ibm.com>

Thanks!
Halil

