Return-Path: <kvm+bounces-4322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A249A811149
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 13:46:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C169281C0E
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 12:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C3DC2940E;
	Wed, 13 Dec 2023 12:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YbVZVQTf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A535AA4;
	Wed, 13 Dec 2023 04:46:00 -0800 (PST)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDARbuI008373;
	Wed, 13 Dec 2023 12:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=pp1;
 bh=wYIz/Vd9ANFPlKGOr2CDAoGFi94eiSS+89jYrllbuTQ=;
 b=YbVZVQTfSIGuh+55ecFa7NNnAR36+EgZ2LZ2qkCyMPlJUCOtUYw0YU00puw2kM8wu9gf
 5wT727ewkid/c49oO/gigeYWieaoyyW2Soldyub0oUhNNSW2DygCzLoRM7XmYw5WLRSH
 SPiouwR5as9FZkg/J3SGq+KkwpsrlgHE3tbmAx3wD74Zd4GUIL0LetfOKG4jt+3IK57L
 +/K/F3O2Aoo4EUokyfLK6bnP85FdJt8bEKmY4cCXR2Jjs6BRany8C8QgXie4Ftt11dXJ
 tLILwqGyU45VY4VtMXudC0FJKdTA7BTp613TR7S0n5F2s4lDD+J/V6YS8qK88WRXhxFd wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uyavkv3j6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 12:45:40 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BDBpL3u021971;
	Wed, 13 Dec 2023 12:45:39 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uyavkv3hv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 12:45:39 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDB1f9d008544;
	Wed, 13 Dec 2023 12:45:38 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uw2jth0hx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 12:45:38 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BDCjbRt18350628
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Dec 2023 12:45:37 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2FD372004B;
	Wed, 13 Dec 2023 12:45:37 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0283220043;
	Wed, 13 Dec 2023 12:45:37 +0000 (GMT)
Received: from DESKTOP-2CCOB1S. (unknown [9.171.137.148])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 13 Dec 2023 12:45:36 +0000 (GMT)
Date: Wed, 13 Dec 2023 13:45:35 +0100
From: Tobias Huschle <huschle@linux.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, Abel Wu <wuyun.abel@bytedance.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6
 sched/fair: Add lag based placement)
Message-ID: <ZXmnb85uoOzDkoYy@DESKTOP-2CCOB1S.>
References: <56082.123120804242300177@us-mta-137.us.mimecast.lan>
 <20231208052150-mutt-send-email-mst@kernel.org>
 <53044.123120806415900549@us-mta-342.us.mimecast.lan>
 <20231209053443-mutt-send-email-mst@kernel.org>
 <CACGkMEuSGT-e-i-8U7hum-N_xEnsEKL+_07Mipf6gMLFFhj2Aw@mail.gmail.com>
 <20231211115329-mutt-send-email-mst@kernel.org>
 <CACGkMEudZnF7hUajgt0wtNPCxH8j6A3L1DgJj2ayJWhv9Bh1WA@mail.gmail.com>
 <20231212111433-mutt-send-email-mst@kernel.org>
 <42870.123121305373200110@us-mta-641.us.mimecast.lan>
 <20231213061719-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231213061719-mutt-send-email-mst@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jT_rJzCVG5b7S3291dEQ8y2q2AnD4dKV
X-Proofpoint-GUID: LgekF1CRqrhmTcxhanpAxmvz0l853p1c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-13_05,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=971 spamscore=0
 bulkscore=0 adultscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312130093

On Wed, Dec 13, 2023 at 07:00:53AM -0500, Michael S. Tsirkin wrote:
> On Wed, Dec 13, 2023 at 11:37:23AM +0100, Tobias Huschle wrote:
> > On Tue, Dec 12, 2023 at 11:15:01AM -0500, Michael S. Tsirkin wrote:
> > > On Tue, Dec 12, 2023 at 11:00:12AM +0800, Jason Wang wrote:
> > > > On Tue, Dec 12, 2023 at 12:54 AM Michael S. Tsirkin <mst@redhat.com> wrote:

[...]
> 
> Apparently schedule is already called?
> 

What about this: 

static int vhost_task_fn(void *data)
{
	<...>
	did_work = vtsk->fn(vtsk->data);  --> this calls vhost_worker if I'm not mistaken
	if (!did_work)
		schedule();
	<...>
}

static bool vhost_worker(void *data)
{
	struct vhost_worker *worker = data;
	struct vhost_work *work, *work_next;
	struct llist_node *node;

	node = llist_del_all(&worker->work_list);
	if (node) {
		<...>
		llist_for_each_entry_safe(work, work_next, node, node) {
			<...>
		}
	}

	return !!node;
}

The llist_for_each_entry_safe does not actually change the node value, doesn't it?

If it does not change it, !!node would return 1.
Thereby skipping the schedule.

This was changed recently with:
f9010dbdce91 fork, vhost: Use CLONE_THREAD to fix freezer/ps regression

It returned a hardcoded 0 before. The commit message explicitly mentions this
change to make vhost_worker return 1 if it did something.

Seems indeed like a nasty little side effect caused by EEVDF not scheduling
the woken up kworker right away.

