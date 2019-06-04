Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9543234A69
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 16:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbfFDO3U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 10:29:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50436 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727169AbfFDO3U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Jun 2019 10:29:20 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x54EOJdC002011
        for <kvm@vger.kernel.org>; Tue, 4 Jun 2019 10:29:18 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2swt7grqfv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2019 10:29:18 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Tue, 4 Jun 2019 15:29:16 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 4 Jun 2019 15:29:13 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x54ETB3d35389444
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Jun 2019 14:29:11 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59BE4A4064;
        Tue,  4 Jun 2019 14:29:11 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC03EA4054;
        Tue,  4 Jun 2019 14:29:10 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.145])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 Jun 2019 14:29:10 +0000 (GMT)
Date:   Tue, 4 Jun 2019 16:29:09 +0200
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
        Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH v3 7/8] virtio/s390: use DMA memory for ccw I/O and
 classic notifiers
In-Reply-To: <20190604153625.6c03c232.cohuck@redhat.com>
References: <20190529122657.166148-1-mimu@linux.ibm.com>
        <20190529122657.166148-8-mimu@linux.ibm.com>
        <20190603181716.325101d9.cohuck@redhat.com>
        <20190604150819.1f8707b5.pasic@linux.ibm.com>
        <20190604153625.6c03c232.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19060414-0012-0000-0000-000003233B86
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060414-0013-0000-0000-0000215C1B4E
Message-Id: <20190604162909.54de39fb.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-04_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=868 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906040096
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Jun 2019 15:36:25 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Tue, 4 Jun 2019 15:08:19 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 

[..]

> 
> Two things:
> - The call path goes from the vcdev to the vdev, then back to the vcdev
>   and then to the cdev. Going from the vcdev to the cdev  directly
>   eliminates the roundtrip via the vdev, which I think does not add
>   anything.
> - I prefer
> 	variable = function_returning_a_pointer(...);
>   over
> 	function_setting_a_variable(..., variable);
>   The latter obscures the fact that we change the value of the
>   variable, unless named very obviously.
> 

I understand. Here it's especially bad because what looks like a
function is actually a macro so it ain't even fn(..., &variable) but
just fn(..., variable). I guess I'm a bit desensitized towards the latter
because of my c++ background.


> > 
> > I will change this for v4 as you requested. Again sorry for missing it!
> 
> np, can happen.

Thanks for the explanation. I will use

ccw_device_dma_zalloc() directly in v4.

Regards,
Halil

