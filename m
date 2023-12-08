Return-Path: <kvm+bounces-3910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E406F80A26F
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 12:42:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A3211F21586
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 11:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 978E81BDCD;
	Fri,  8 Dec 2023 11:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eaOkcqkQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80FC1724;
	Fri,  8 Dec 2023 03:42:02 -0800 (PST)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B8BRl6Q002639;
	Fri, 8 Dec 2023 11:41:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=aJQu+Av/3MN6IBG2EPgO6rv8bX3z7cMZ1gb+fobzFr4=;
 b=eaOkcqkQsCSGZjJcxwYC/y0cKI2coV5IKEch9I9FK1OpDb/C3uiPtMi3jbdMlf7MFIU4
 4MnvCFjiSCSAZ1BzWoQ6BOKLcFMRrHxFQHanG0Q0Fr1fqV5Qd8CguMZW0hxou+0nin1Z
 Ye7IpHTMk85Vx/axBanVSqHMwBtLYyXF9A2clj40T9Hry7cagAqK2X1TMjQNRdCWC/5g
 kGYgUYLA0PW15X0AVzTmqOL5lPDNdKRc1T85ujAJg5QSzXfgZsMPgyHH3MDUsr4Es95k
 nUS+FBMmqgWMpE7njQkMLO4dlOihkC+sgP+7GsCCUg/6sVhCoZh31f8fJvceyE5hnjjs bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uv29ggb8q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 11:41:43 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B8Bfh0j012863;
	Fri, 8 Dec 2023 11:41:43 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uv29ggb8g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 11:41:43 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B8A8DZT001591;
	Fri, 8 Dec 2023 11:41:42 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3utav2s9vk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 11:41:42 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B8Bfef717105560
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 8 Dec 2023 11:41:40 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 731DE20043;
	Fri,  8 Dec 2023 11:41:40 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4882420040;
	Fri,  8 Dec 2023 11:41:40 +0000 (GMT)
Received: from DESKTOP-2CCOB1S. (unknown [9.171.204.69])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  8 Dec 2023 11:41:40 +0000 (GMT)
Date: Fri, 8 Dec 2023 12:41:38 +0100
From: Tobias Huschle <huschle@linux.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Abel Wu <wuyun.abel@bytedance.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, netdev@vger.kernel.org,
        jasowang@redhat.com
Subject: Re: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6
 sched/fair: Add lag based placement)
Message-ID: <ZXMA8r+T86Is8Ohv@DESKTOP-2CCOB1S.>
References: <20231117123759.GP8262@noisy.programming.kicks-ass.net>
 <46a997c2-5a38-4b60-b589-6073b1fac677@bytedance.com>
 <ZVyt4UU9+XxunIP7@DESKTOP-2CCOB1S.>
 <20231122100016.GO8262@noisy.programming.kicks-ass.net>
 <6564a012.c80a0220.adb78.f0e4SMTPIN_ADDED_BROKEN@mx.google.com>
 <d4110c79-d64f-49bd-9f69-0a94369b5e86@bytedance.com>
 <07513.123120701265800278@us-mta-474.us.mimecast.lan>
 <20231207014626-mutt-send-email-mst@kernel.org>
 <56082.123120804242300177@us-mta-137.us.mimecast.lan>
 <20231208052150-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231208052150-mutt-send-email-mst@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: a1l3gNc8w_7KWEDTL1N2M4KPK0UhgnsI
X-Proofpoint-ORIG-GUID: 8f6spidwjlhsK31bm9iRrZvQqTJ9wUjF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-08_06,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 mlxlogscore=548 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 spamscore=0 phishscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312080098

On Fri, Dec 08, 2023 at 05:31:18AM -0500, Michael S. Tsirkin wrote:
> On Fri, Dec 08, 2023 at 10:24:16AM +0100, Tobias Huschle wrote:
> > On Thu, Dec 07, 2023 at 01:48:40AM -0500, Michael S. Tsirkin wrote:
> > > On Thu, Dec 07, 2023 at 07:22:12AM +0100, Tobias Huschle wrote:
> > > > 3. vhost looping endlessly, waiting for kworker to be scheduled
> > > > 
> > > > I dug a little deeper on what the vhost is doing. I'm not an expert on
> > > > virtio whatsoever, so these are just educated guesses that maybe
> > > > someone can verify/correct. Please bear with me probably messing up 
> > > > the terminology.
> > > > 
> > > > - vhost is looping through available queues.
> > > > - vhost wants to wake up a kworker to process a found queue.
> > > > - kworker does something with that queue and terminates quickly.
> > > > 
> > > > What I found by throwing in some very noisy trace statements was that,
> > > > if the kworker is not woken up, the vhost just keeps looping accross
> > > > all available queues (and seems to repeat itself). So it essentially
> > > > relies on the scheduler to schedule the kworker fast enough. Otherwise
> > > > it will just keep on looping until it is migrated off the CPU.
> > > 
> > > 
> > > Normally it takes the buffers off the queue and is done with it.
> > > I am guessing that at the same time guest is running on some other
> > > CPU and keeps adding available buffers?
> > > 
> > 
> > It seems to do just that, there are multiple other vhost instances
> > involved which might keep filling up thoses queues. 
> > 
> 
> No vhost is ever only draining queues. Guest is filling them.
> 
> > Unfortunately, this makes the problematic vhost instance to stay on
> > the CPU and prevents said kworker to get scheduled. The kworker is
> > explicitly woken up by vhost, so it wants it to do something.
> > 
> > At this point it seems that there is an assumption about the scheduler
> > in place which is no longer fulfilled by EEVDF. From the discussion so
> > far, it seems like EEVDF does what is intended to do.
> > 
> > Shouldn't there be a more explicit mechanism in use that allows the
> > kworker to be scheduled in favor of the vhost?
> > 
> > It is also concerning that the vhost seems cannot be preempted by the
> > scheduler while executing that loop.
> 
> 
> Which loop is that, exactly?

The loop continously passes translate_desc in drivers/vhost/vhost.c
That's where I put the trace statements.

The overall sequence seems to be (top to bottom):

handle_rx
get_rx_bufs
vhost_get_vq_desc
vhost_get_avail_head
vhost_get_avail
__vhost_get_user_slow
translate_desc               << trace statement in here
vhost_iotlb_itree_first

These functions show up as having increased overhead in perf.

There are multiple loops going on in there.
Again the disclaimer though, I'm not familiar with that code at all.

