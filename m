Return-Path: <kvm+bounces-4315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 74C4A810E94
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 11:38:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0441B1F211F7
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 10:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B013E22EF3;
	Wed, 13 Dec 2023 10:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YI6lNq57"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A82AAC;
	Wed, 13 Dec 2023 02:37:55 -0800 (PST)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDAO2Mi003351;
	Wed, 13 Dec 2023 10:37:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=pp1;
 bh=afXyD57CHd9fg95bfg8aUY7o4KARJbvf2+R1FiHzP4k=;
 b=YI6lNq570hKrQW3jYYE6BV3oxoxC6MsRQ0hBVGWzlX8sroBvzrSgu1qMUahoYr+TSrN1
 SFcwmZ/Pcy6pbitQSXw+/ZCAlZ2omCpX3xra1qHMn9C7jDLLZmIoJlJ3aNPVnyZsdB4Q
 GFps1oZmOVAC2uPic4buoKXhoWSw7SvyJiBxFQ4iFnMdXrvjgjMd8RbPE0JZAMzZyYcE
 Ic6nOoJ7G/sWj2sCJbVskEEiHgtsCtyn8X1jQ4eCpWAG9y7T7FW70vsYSzzHbOlpvRbr
 MYUjro3dvwJkEctTOdtgeOKYkQU8qBJe8H5QTgcay8Qv0DVE6KsdsknIZPRQnziSxcQ3 dw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uyanc8nkn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 10:37:30 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BDAEpJG010128;
	Wed, 13 Dec 2023 10:37:30 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uyanc8nk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 10:37:30 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BD8vQEa028244;
	Wed, 13 Dec 2023 10:37:28 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3uw2xyr6vp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 10:37:28 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BDAbPYO45351502
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Dec 2023 10:37:26 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5DB662004B;
	Wed, 13 Dec 2023 10:37:25 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3197D20043;
	Wed, 13 Dec 2023 10:37:25 +0000 (GMT)
Received: from DESKTOP-2CCOB1S. (unknown [9.171.137.148])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 13 Dec 2023 10:37:25 +0000 (GMT)
Date: Wed, 13 Dec 2023 11:37:23 +0100
From: Tobias Huschle <huschle@linux.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, Abel Wu <wuyun.abel@bytedance.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6
 sched/fair: Add lag based placement)
Message-ID: <ZXmJYxLfLGBtuQ3L@DESKTOP-2CCOB1S.>
References: <07513.123120701265800278@us-mta-474.us.mimecast.lan>
 <20231207014626-mutt-send-email-mst@kernel.org>
 <56082.123120804242300177@us-mta-137.us.mimecast.lan>
 <20231208052150-mutt-send-email-mst@kernel.org>
 <53044.123120806415900549@us-mta-342.us.mimecast.lan>
 <20231209053443-mutt-send-email-mst@kernel.org>
 <CACGkMEuSGT-e-i-8U7hum-N_xEnsEKL+_07Mipf6gMLFFhj2Aw@mail.gmail.com>
 <20231211115329-mutt-send-email-mst@kernel.org>
 <CACGkMEudZnF7hUajgt0wtNPCxH8j6A3L1DgJj2ayJWhv9Bh1WA@mail.gmail.com>
 <20231212111433-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231212111433-mutt-send-email-mst@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NJ7X8x2DPO5i1YAi5viaSFBL9uVdkghe
X-Proofpoint-GUID: 8ozMYjH15i4wTe6alK14MMBRna_ewWAc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-13_03,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 suspectscore=0 impostorscore=0 clxscore=1011 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312130077

On Tue, Dec 12, 2023 at 11:15:01AM -0500, Michael S. Tsirkin wrote:
> On Tue, Dec 12, 2023 at 11:00:12AM +0800, Jason Wang wrote:
> > On Tue, Dec 12, 2023 at 12:54 AM Michael S. Tsirkin <mst@redhat.com> wrote:

We played around with the suggestions and some other ideas.
I would like to share some initial results.

We tried the following:

1. Call uncondtional schedule in the vhost_worker function
2. Change the HZ value from 100 to 1000
3. Reverting 05bfb338fa8d vhost: Fix livepatch timeouts in vhost_worker()
4. Adding a cond_resched to translate_desc
5. Reducing VHOST_NET_WEIGHT to 25% of its original value

Please find the diffs below.

Summary:

Option 1 is very very hacky but resolved the regression.
Option 2 reduces the regression by ~20%.
Options 3-5 do not help unfortunately.

Potential explanation:

While the vhost is executing, the need_resched flag is not set (observable
in the traces). Therefore cond_resched and alike will do nothing. vhost
will continue executing until the need_resched flag is set by an external
party, e.g. by a request to migrate the vhost.

Calling schedule unconditionally forces the scheduler to re-evaluate all 
tasks and their vruntime/deadline/vlag values. The scheduler comes to the
correct conclusion, that the kworker should be executed and from there it
is smooth sailing. I will have to verify that sequence by collecting more
traces, but this seems rather plausible.
This hack might of course introduce all kinds of side effects but might
provide an indicator that this is the actual problem.
The big question would be how to solve this conceptually, and, first
things first, whether you think this is a viable hypothesis.

Increasing the HZ value helps most likely because the other CPUs take 
scheduling/load balancing decisions more often as well and therefore
trigger the migration faster.

Bringing down VHOST_NET_WEIGHT even more might also help to shorten the
vhost loop. But I have no intuition how low we can/should go here.


We also changed vq_err to print error messages, but did not encounter any.

Diffs:
--------------------------------------------------------------------------

1. Call uncondtional schedule in the vhost_worker function

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index e0c181ad17e3..16d73fd28831 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -414,6 +414,7 @@ static bool vhost_worker(void *data)
                }
        }
 
+       schedule();
        return !!node;
 }

--------------------------------------------------------------------------

2. Change the HZ value from 100 to 1000

--> config change 

--------------------------------------------------------------------------

3. Reverting 05bfb338fa8d vhost: Fix livepatch timeouts in vhost_worker()

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index e0c181ad17e3..d519d598ebb9 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -410,7 +410,8 @@ static bool vhost_worker(void *data)
                        kcov_remote_start_common(worker->kcov_handle);
                        work->fn(work);
                        kcov_remote_stop();
-                       cond_resched();
+                       if (need_resched())
+                               schedule();
                }
        }

--------------------------------------------------------------------------

4. Adding a cond_resched to translate_desc

I just picked some location.

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index e0c181ad17e3..f885dd29cbd1 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2367,6 +2367,7 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
                s += size;
                addr += size;
                ++ret;
+               cond_resched();
        }
 
        if (ret == -EAGAIN)

--------------------------------------------------------------------------

5. Reducing VHOST_NET_WEIGHT to 25% of its original value

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index f2ed7167c848..2c6966ea6229 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -42,7 +42,7 @@ MODULE_PARM_DESC(experimental_zcopytx, "Enable Zero Copy TX;"
 
 /* Max number of bytes transferred before requeueing the job.
  * Using this limit prevents one virtqueue from starving others. */
-#define VHOST_NET_WEIGHT 0x80000
+#define VHOST_NET_WEIGHT 0x20000
 
 /* Max number of packets transferred before requeueing the job.
  * Using this limit prevents one virtqueue from starving others with small

