Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB7C033202
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 16:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbfFCOWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 10:22:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37890 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728253AbfFCOWb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Jun 2019 10:22:31 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x53EKMFk108897
        for <kvm@vger.kernel.org>; Mon, 3 Jun 2019 10:22:30 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sw3q74y6s-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2019 10:22:29 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Mon, 3 Jun 2019 15:22:26 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 3 Jun 2019 15:22:23 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x53EMLl013303934
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jun 2019 14:22:21 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65D2E5204F;
        Mon,  3 Jun 2019 14:22:21 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.145])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id F156452052;
        Mon,  3 Jun 2019 14:22:20 +0000 (GMT)
Date:   Mon, 3 Jun 2019 16:22:19 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Michael Mueller <mimu@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
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
In-Reply-To: <20190603160428.2112077a.pasic@linux.ibm.com>
References: <20190529122657.166148-1-mimu@linux.ibm.com>
        <20190529122657.166148-3-mimu@linux.ibm.com>
        <20190603133745.240c00a7.cohuck@redhat.com>
        <035b4bd3-5856-e8e5-91bf-ba0b5c7c3736@linux.ibm.com>
        <20190603160428.2112077a.pasic@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19060314-0012-0000-0000-000003226217
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060314-0013-0000-0000-0000215B3C9F
Message-Id: <20190603162219.31de2df9.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-03_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030101
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 3 Jun 2019 16:04:28 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> On Mon, 3 Jun 2019 14:09:02 +0200
> Michael Mueller <mimu@linux.ibm.com> wrote:
> 
> > >> @@ -1059,16 +1168,19 @@ static int __init css_bus_init(void)
> > >>   	if (ret)
> > >>   		goto out_unregister;
> > >>   	ret = register_pm_notifier(&css_power_notifier);
> > >> -	if (ret) {
> > >> -		unregister_reboot_notifier(&css_reboot_notifier);
> > >> -		goto out_unregister;
> > >> -	}
> > >> +	if (ret)
> > >> +		goto out_unregister_rn;
> > >> +	ret = cio_dma_pool_init();
> > >> +	if (ret)
> > >> +		goto out_unregister_rn;  
> > > 
> > > Don't you also need to unregister the pm notifier on failure here?  
> > 
> > Mmh, that was the original intention. Thanks!
> 
> I suppose we could also move cio_dma_pool_init() right before the
> register_reboot_notifier() call and goto out_unregister on error.
> 

Forget it, then we have to rollback the pool creation if the register
stuff fails... Sorry for the noise.

Regards,
Halil

