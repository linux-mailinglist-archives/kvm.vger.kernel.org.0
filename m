Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5FD1819B
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 23:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbfEHVWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 17:22:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57118 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726591AbfEHVWU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 May 2019 17:22:20 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x48LLqEE081695
        for <kvm@vger.kernel.org>; Wed, 8 May 2019 17:22:19 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sc6pb0pd5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 17:22:19 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Wed, 8 May 2019 22:22:17 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 May 2019 22:22:14 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x48LMCNH55771286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 May 2019 21:22:13 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E294BA405F;
        Wed,  8 May 2019 21:22:12 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25B42A4054;
        Wed,  8 May 2019 21:22:12 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.71.200])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 May 2019 21:22:12 +0000 (GMT)
Date:   Wed, 8 May 2019 23:22:10 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Sebastian Ott <sebott@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
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
In-Reply-To: <alpine.LFD.2.21.1905081447280.1773@schleppi>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
        <20190426183245.37939-6-pasic@linux.ibm.com>
        <alpine.LFD.2.21.1905081447280.1773@schleppi>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19050821-0008-0000-0000-000002E4A9CD
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050821-0009-0000-0000-000022512CF5
Message-Id: <20190508232210.5a555caa.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-08_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905080129
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 May 2019 15:18:10 +0200 (CEST)
Sebastian Ott <sebott@linux.ibm.com> wrote:

> > +void cio_gp_dma_free(struct gen_pool *gp_dma, void *cpu_addr, size_t size)
> > +{
> > +	if (!cpu_addr)
> > +		return;
> > +	memset(cpu_addr, 0, size);  
> 
> Hm, normally I'd do the memset during alloc not during free - but maybe
> this makes more sense here with your usecase in mind.

I allocate the backing as zeroed, and zero the memory before putting it
back to the pool. So the stuff in the pool is always zeroed.

> 
> > @@ -1063,6 +1163,7 @@ static int __init css_bus_init(void)
> >  		unregister_reboot_notifier(&css_reboot_notifier);
> >  		goto out_unregister;
> >  	}
> > +	cio_dma_pool_init();  
> 
> This is too late for early devices (ccw console!).

You have already raised concern about this last time (thanks). I think,
I've addressed this issue: tje cio_dma_pool is only used by the airq
stuff. I don't think the ccw console needs it. Please have an other look
at patch #6, and explain your concern in more detail if it persists.

(@Mimu: What do you think, am I wrong here?)

Thanks for having a look!

Regards,
Halil

