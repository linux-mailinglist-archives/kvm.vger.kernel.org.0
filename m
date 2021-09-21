Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5371F413A0D
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 20:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhIUS0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 14:26:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41112 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232890AbhIUS0s (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 14:26:48 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18LHClbs018413;
        Tue, 21 Sep 2021 14:25:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=yUCduo/+FNeUPxDRhu1f5vXQoveIvMutiZCSsB7+WSE=;
 b=bMaBaV8ffDypiiCsgH0z473+w7HnQHrCmYut2IjbPv6C1jPWHgL49mE19ENLQwJvgnb+
 cZXdj2V/wH+xB1Ewlvo61qj1MDC9wvpjewceaQb9p/hhCYjSuWLb3p+u90+d1MaE4hgN
 z2ev261u+8NnaZH6C8xtx0r8VxXOJDMfi8KsUhAUM2nBPU/YHGnN5LiDQs43T+gETlTn
 xQPdrOT15fkWSrzy82sO4rSeQGVPEnViP/zT35nNvqnB6SBCVNBF1zf0JSj4i235dmk4
 vRwH4ILAzu0N8AHxnNksWlosnby3y5K4gV8FhDGcr2uJQyR9D3YDTbgdfaQsWRIsrstS Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7kkg9fjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 14:25:18 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18LIKGCC002051;
        Tue, 21 Sep 2021 14:25:17 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7kkg9fhs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 14:25:17 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18LIHHa4029307;
        Tue, 21 Sep 2021 18:25:14 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3b57r9fe0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 18:25:14 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18LIPA7a2753116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 18:25:11 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B865B52057;
        Tue, 21 Sep 2021 18:25:10 +0000 (GMT)
Received: from li-748c07cc-28e5-11b2-a85c-e3822d7eceb3.ibm.com (unknown [9.171.53.36])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 19E8152077;
        Tue, 21 Sep 2021 18:25:10 +0000 (GMT)
Message-ID: <f4dc7040554fd7e9c7067aab2213b3639cfc6987.camel@linux.ibm.com>
Subject: Re: [PATCH 1/1] virtio/s390: fix vritio-ccw device teardown
From:   Vineeth Vijayan <vneethv@linux.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, bfu@redhat.com,
        Peter Oberparleiter <oberpar@linux.ibm.com>
Date:   Tue, 21 Sep 2021 20:25:09 +0200
In-Reply-To: <20210921185222.246b15bb.pasic@linux.ibm.com>
References: <20210915215742.1793314-1-pasic@linux.ibm.com>
         <87pmt8hp5o.fsf@redhat.com> <20210916151835.4ab512b2.pasic@linux.ibm.com>
         <87mtobh9xn.fsf@redhat.com> <20210920003935.1369f9fe.pasic@linux.ibm.com>
         <88b514a4416cf72cda53a31ad2e15c13586350e4.camel@linux.ibm.com>
         <878rzrh86c.fsf@redhat.com> <20210921052548.4eea231f.pasic@linux.ibm.com>
         <05b1ac0e4aa4a1c7df1a8994c898630e9b2e384d.camel@linux.ibm.com>
         <20210921185222.246b15bb.pasic@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0Ci8AMH7zOq2wX571aPN8cNde7Yq4fRB
X-Proofpoint-ORIG-GUID: 0iig0ErpBc7Z_dJZR9LRPPvSFK2wT6FU
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-21_05,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 malwarescore=0
 phishscore=0 clxscore=1015 mlxlogscore=999 lowpriorityscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109210107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-09-21 at 18:52 +0200, Halil Pasic wrote:
> > > > lock already,   
> > > 
> > > I believe we have a misunderstanding here. I believe that Vineeth
> > > is
> > > trying to tell us, that online_store_handle_offline() and
> > > online_store_handle_offline() are called under the a device lock
> > > of
> > > the ccw device. Right, Vineeth?  
> > Yes. I wanted to bring-out both the scenario.The
> > set_offline/_online()
> > calls and the unconditional-remove call.
> 
> I don't understand the paragraph above. I can't map the terms
> set_offline/_online() and unconditional-remove call to chunks of
> code.
> :( 
online_store() function can be used to set_online/set_offline manually
from the sysfs entry.
And an unconditional-remove call, for CIO, starts with a CRW which
indicates there is a subchannel_event which needs to be taken care.
This sch_event() (in device.c) then try to find the reason for this CRW
and act accordingly. This would lead to device_del and end up calling
the remove function of the driver.

> > For the set_online The virtio_ccw_online() also invoked with
> > ccwlock
> > held. (ref: ccw_device_set_online)
> 
> I don't think virtio_ccw_online() is invoked with the ccwlock held. I
> think we call virtio_ccw_online() in this line:
> https://elixir.bootlin.com/linux/v5.15-rc2/source/drivers/s390/cio/device.c#L394
> and we have released the cdev->ccwlock literally 2 lines above.
My bad. I overlooked it! 
> 
> 
> > > Conny, I believe, by online/offline callbacks, you mean
> > > virtio_ccw_online() and virtio_ccw_offline(), right?
> > > 
> > > But the thing is that virtio_ccw_online() may get called (and is
> > > typically called, AFAICT) with no locks held via:
> > > virtio_ccw_probe() --> async_schedule(virtio_ccw_auto_online,
> > > cdev)
> > > -*-> virtio_ccw_auto_online(cdev) --> ccw_device_set_online(cdev)
> > > -->
> > > virtio_ccw_online()
> > > 
> > > Furthermore after a closer look, I believe because we don't take
> > > a reference to the cdev in probe, we may get
> > > virtio_ccw_auto_online()
> > > called with an invalid pointer (the pointer is guaranteed to be
> > > valid
> > > in probe, but because of async we have no guarantee that it will
> > > be
> > > called in the context of probe).
> > > 
> > > Shouldn't we take a reference to the cdev in probe?  
> > We just had a quick look at the virtio_ccw_probe() function.
> > Did you mean to have a get_device() during the probe() and
> > put_device()
> > just after the virtio_ccw_auto_online() ?
> 
> Yes, that would ensure that cdev pointer is still valid when
> virtio_ccw_auto_online() is executed, and that things are cleaned up
> properly, I guess. But I'm not 100% sure about all the interactions.
> AFAIR ccw_device_set_online(cdev) would bail out if !drv. But then
> we have the case where we already assigned it to a new driver (e.g.
> vfio for dasd).
> 
> BTW I believe if we have a problem here, the dasd driver has the same
> problem as well. The code looks very, very similar.
You are right about that. I am trying to recreate that issue with DASD
now. And working on the patch as well.
> 
> And shouldn't this auto-online be common CIO functionality? What is
> the
> reason the char devices don't seem to have it?
I am not sure about that. I dont understand why it should be a CIO
functionality. 
> 
> Regards,
> Halil

