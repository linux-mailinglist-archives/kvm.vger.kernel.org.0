Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCA3842A6C
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 17:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406075AbfFLPLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 11:11:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60054 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405266AbfFLPLQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Jun 2019 11:11:16 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CFAXOk128215
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 11:11:14 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t33mt8kpj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 11:11:14 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Wed, 12 Jun 2019 16:11:12 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 12 Jun 2019 16:11:09 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5CFB8FH39584166
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 15:11:08 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2221CAE055;
        Wed, 12 Jun 2019 15:11:08 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EAE7AE051;
        Wed, 12 Jun 2019 15:11:07 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.26])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Jun 2019 15:11:07 +0000 (GMT)
Date:   Wed, 12 Jun 2019 17:11:05 +0200
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
Subject: Re: [PATCH v5 4/8] s390/airq: use DMA memory for adapter interrupts
In-Reply-To: <20190612163501.45a050b0.cohuck@redhat.com>
References: <20190612111236.99538-1-pasic@linux.ibm.com>
        <20190612111236.99538-5-pasic@linux.ibm.com>
        <20190612163501.45a050b0.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19061215-0012-0000-0000-0000032887F9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061215-0013-0000-0000-000021619065
Message-Id: <20190612171105.230b976d.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=997 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120102
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 Jun 2019 16:35:01 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Wed, 12 Jun 2019 13:12:32 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:

[..]

> > --- a/drivers/s390/cio/css.c
> > +++ b/drivers/s390/cio/css.c
> > @@ -1184,6 +1184,7 @@ static int __init css_bus_init(void)
> >  	ret = cio_dma_pool_init();
> >  	if (ret)
> >  		goto out_unregister_pmn;
> > +	airq_init();
> 
> Ignoring the return code here does not really hurt right now, but we
> probably want to change that if we want to consider failures in css
> initialization to be fatal.
> 

Right. I think that would even simplify the code a bit (no rollback).

> >  	css_init_done = 1;
> >  
> >  	/* Enable default isc for I/O subchannels. */
> 
> On the whole, not really anything that needs changes right now, so have
> a
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thank you so much!

Regards,
Halil

