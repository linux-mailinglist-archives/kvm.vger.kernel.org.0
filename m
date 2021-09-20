Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6140411057
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 09:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbhITHms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 03:42:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48914 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231990AbhITHmp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 03:42:45 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18K4hDZ6027238;
        Mon, 20 Sep 2021 03:41:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=QhU2fJ30Ylq89IQ5b92Q9qDJ3jDbJqw0TeGqxw6bagk=;
 b=bsODAaUAFqt5cPNm/DmLiW1PuNIvnCXFgoTyrPzgvtSQ65yF6t8HqKnoYG+EtwRtIsa5
 T4UXmqq+8sCQZvFIV9A+9qBq9AdAp2pbx9UuRtwIOek9EuyxkPSYfeuHZ0BX6PUbiZWA
 wkKylznDsRUzw5s7Um/97G2V5lGEnbdgVYRqcSaRXqTbxTxvrB+Riw9qC8vkD9DSzUI1
 zMXIpbIb1SMxoTqi2c9Get2A4ek4nz28ykZqpfqXWvxVNl/bNWFRNyV25G9mSlYLSxZI
 9CEDQ7twVeelXQgVnSM69KYhO7PTK0EuJTiF2cHMunPgWqDfNcYq+eOR+dst1dzeLXk5 vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5w693bvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 03:41:15 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18K7KdAF011125;
        Mon, 20 Sep 2021 03:41:14 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5w693bum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 03:41:14 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18K7VW7r028991;
        Mon, 20 Sep 2021 07:41:12 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3b57r94hgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 07:41:12 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18K7aPIe43516410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 07:36:25 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 921874C063;
        Mon, 20 Sep 2021 07:41:07 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 836954C059;
        Mon, 20 Sep 2021 07:41:06 +0000 (GMT)
Received: from li-748c07cc-28e5-11b2-a85c-e3822d7eceb3.ibm.com (unknown [9.171.5.235])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Sep 2021 07:41:06 +0000 (GMT)
Message-ID: <88b514a4416cf72cda53a31ad2e15c13586350e4.camel@linux.ibm.com>
Subject: Re: [PATCH 1/1] virtio/s390: fix vritio-ccw device teardown
From:   Vineeth Vijayan <vneethv@linux.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, bfu@redhat.com
Date:   Mon, 20 Sep 2021 09:41:06 +0200
In-Reply-To: <20210920003935.1369f9fe.pasic@linux.ibm.com>
References: <20210915215742.1793314-1-pasic@linux.ibm.com>
         <87pmt8hp5o.fsf@redhat.com> <20210916151835.4ab512b2.pasic@linux.ibm.com>
         <87mtobh9xn.fsf@redhat.com> <20210920003935.1369f9fe.pasic@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: O2YLebhLF1qY_dykVwHEiFcUaS00yvK1
X-Proofpoint-ORIG-GUID: _OOu5WaZyCxFiCTJFzzcGPi_Mkn2GqpQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_03,2021-09-17_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=925 priorityscore=1501 phishscore=0 clxscore=1011
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200044
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-09-20 at 00:39 +0200, Halil Pasic wrote:
> On Fri, 17 Sep 2021 10:40:20 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
...snip...
> > > 
> > > Thanks, if I find time for it, I will try to understand this
> > > better and
> > > come back with my findings.
> > >  
> > > > > * Can virtio_ccw_remove() get called while !cdev->online and 
> > > > >   virtio_ccw_online() is running on a different cpu? If yes,
> > > > > what would
> > > > >   happen then?    
> > > > 
> > > > All of the remove/online/... etc. callbacks are invoked via the
> > > > ccw bus
> > > > code. We have to trust that it gets it correct :) (Or have the
> > > > common
> > > > I/O layer maintainers double-check it.)
> > > >   
> > > 
> > > Vineeth, what is your take on this? Are the struct ccw_driver
> > > virtio_ccw_remove and the virtio_ccw_online callbacks mutually
> > > exclusive. Please notice that we may initiate the onlining by
> > > calling ccw_device_set_online() from a workqueue.
> > > 
> > > @Conny: I'm not sure what is your definition of 'it gets it
> > > correct'...
> > > I doubt CIO can make things 100% foolproof in this area.  
> > 
> > Not 100% foolproof, but "don't online a device that is in the
> > progress
> > of going away" seems pretty basic to me.
> > 
> 
> I hope Vineeth will chime in on this.
Considering the online/offline processing, 
The ccw_device_set_offline function or the online/offline is handled
inside device_lock. Also, the online_store function takes care of
avoiding multiple online/offline processing. 

Now, when we consider the unconditional remove of the device,
I am not familiar with the virtio_ccw driver. My assumptions are based
on how CIO/dasd drivers works. If i understand correctly, the dasd
driver sets different flags to make sure that a device_open is getting
prevented while the the device is in progress of offline-ing. 

> 
> > >  
> > > > >  
> > > > > The main addresse of these questions is Conny ;).  
> > > 

...snip...

