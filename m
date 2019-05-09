Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4ECF19509
	for <lists+kvm@lfdr.de>; Fri, 10 May 2019 00:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfEIWLW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 18:11:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42150 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726761AbfEIWLW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 May 2019 18:11:22 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x49LvPNF092878
        for <kvm@vger.kernel.org>; Thu, 9 May 2019 18:11:21 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2scu6bkdch-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 09 May 2019 18:11:20 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Thu, 9 May 2019 23:11:18 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 9 May 2019 23:11:16 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x49MBEXw57147578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 May 2019 22:11:14 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9ACDDAE045;
        Thu,  9 May 2019 22:11:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA33DAE04D;
        Thu,  9 May 2019 22:11:13 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.181.188])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 May 2019 22:11:13 +0000 (GMT)
Date:   Fri, 10 May 2019 00:11:12 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Sebastian Ott <sebott@linux.ibm.com>, kvm@vger.kernel.org,
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
In-Reply-To: <20190509121106.48aa04db.cohuck@redhat.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
        <20190426183245.37939-6-pasic@linux.ibm.com>
        <alpine.LFD.2.21.1905081447280.1773@schleppi>
        <20190508232210.5a555caa.pasic@linux.ibm.com>
        <20190509121106.48aa04db.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19050922-0008-0000-0000-000002E51035
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050922-0009-0000-0000-00002251990B
Message-Id: <20190510001112.479b2fd7.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=990 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905090125
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 May 2019 12:11:06 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Wed, 8 May 2019 23:22:10 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 
> > On Wed, 8 May 2019 15:18:10 +0200 (CEST)
> > Sebastian Ott <sebott@linux.ibm.com> wrote:
> 
> > > > @@ -1063,6 +1163,7 @@ static int __init css_bus_init(void)
> > > >  		unregister_reboot_notifier(&css_reboot_notifier);
> > > >  		goto out_unregister;
> > > >  	}
> > > > +	cio_dma_pool_init();    
> > > 
> > > This is too late for early devices (ccw console!).  
> > 
> > You have already raised concern about this last time (thanks). I think,
> > I've addressed this issue: tje cio_dma_pool is only used by the airq
> > stuff. I don't think the ccw console needs it. Please have an other look
> > at patch #6, and explain your concern in more detail if it persists.
> 
> What about changing the naming/adding comments here, so that (1) folks
> aren't confused by the same thing in the future and (2) folks don't try
> to use that pool for something needed for the early ccw consoles?
> 

I'm all for clarity! Suggestions for better names?

Regards,
Halil

