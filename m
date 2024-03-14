Return-Path: <kvm+bounces-11795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6313A87BC50
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 12:56:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8695D1C21004
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 11:55:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 490486F09B;
	Thu, 14 Mar 2024 11:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fLZxSUsE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD21D60ED0;
	Thu, 14 Mar 2024 11:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710417345; cv=none; b=E3Qj67x7XNryAWDxOodlATur6HZ8me96rGmZSRiZdhp4vp3DtZwJgDs2ar71loqPnxjdRawpVT60ymrCvsFMoafLw10PAKF13c38qnsxvRLHHNSqyTSjy9O31D5pkM1q4L1FQdFtNP+V4JMC0NMgb3F4Ijk6QoLDt+L8ckeuN78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710417345; c=relaxed/simple;
	bh=1JjhfL7FcQqnuhY7jT5WcbVKksVOcdGMYehx/+c0rr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lk0CEgHKDnOq68XLOGvD1FwgPAJLeauiwwh2t+6z4cmVWGaAEnhBN3w8YhA/x9PWOqYghrMxC8DuPr5kHfK0zf71aEpL/CphDvG1Ak6/GyJvyQ1KnM8xMQ1+BIyqCGTui0iIi+nnw03vCfssB2JIUQvgFI3PHgidVBIdxNjYcro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fLZxSUsE; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42EBlHeF003175;
	Thu, 14 Mar 2024 11:55:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=xHYEL1lRKfbbIXWWI4DDnPg/kjBT2P/MRCov2Y8zLH8=;
 b=fLZxSUsEBoXmkeDkU8mPLsAfh2icRZ2876jBMfL+otAhwyDmMh4PC6eDEeSMhVBWEmR1
 HRsnr/jBlZVGHIrW+eyRrSf7plYqFZ/QFvMwqrMYVdFVEznkOdh1fvsU+n8GwH+RamuU
 WuV0DjSecMAYrcK7hmyx0ztcS/2ZcrgRLg/fQMw1vAjnd3lwYATXvfVmk/6ufTVWsrm7
 WqQuKV3bL4jVXnyF70gG8hj2TtfI12QXzauXFf4sErUuu8WExF8KuGY647mKsAvj9aIN
 ylVV51qsgbhlKGrafDjtahYIO1kmJQOQcp/AKZeOybaK0CrturiT5HZEz6a8ksfZJsio zA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wv0ntr22n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Mar 2024 11:55:23 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42EBtNpD019215;
	Thu, 14 Mar 2024 11:55:23 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wv0ntr1ve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Mar 2024 11:55:23 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42E90Yas015501;
	Thu, 14 Mar 2024 11:46:59 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ws2g04t67-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Mar 2024 11:46:59 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42EBktXE30146886
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Mar 2024 11:46:57 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BE70020043;
	Thu, 14 Mar 2024 11:46:55 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D84D20040;
	Thu, 14 Mar 2024 11:46:55 +0000 (GMT)
Received: from DESKTOP-2CCOB1S. (unknown [9.171.201.209])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 14 Mar 2024 11:46:55 +0000 (GMT)
Date: Thu, 14 Mar 2024 12:46:54 +0100
From: Tobias Huschle <huschle@linux.ibm.com>
To: Luis Machado <luis.machado@arm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Abel Wu <wuyun.abel@bytedance.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, netdev@vger.kernel.org,
        nd <nd@arm.com>
Subject: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6 sched/fair: Add
 lag based placement)
Message-ID: <ZfLjrgn5rlPOD5Xa@DESKTOP-2CCOB1S.>
References: <25485.123121307454100283@us-mta-18.us.mimecast.lan>
 <20231213094854-mutt-send-email-mst@kernel.org>
 <20231214021328-mutt-send-email-mst@kernel.org>
 <92916.124010808133201076@us-mta-622.us.mimecast.lan>
 <20240121134311-mutt-send-email-mst@kernel.org>
 <07974.124020102385100135@us-mta-501.us.mimecast.lan>
 <20240201030341-mutt-send-email-mst@kernel.org>
 <89460.124020106474400877@us-mta-475.us.mimecast.lan>
 <20240311130446-mutt-send-email-mst@kernel.org>
 <cf813f92-9806-4449-b099-1bb2bd492b3c@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf813f92-9806-4449-b099-1bb2bd492b3c@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4WG_DbRUNjYH5LKbYYHh4Hj_rurXdFYU
X-Proofpoint-GUID: yN8qJr39mIg58TjVoNIARvWEO-oed-Kd
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-14_10,2024-03-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 impostorscore=0 mlxlogscore=999 phishscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1011 adultscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403140085

On Tue, Mar 12, 2024 at 09:45:57AM +0000, Luis Machado wrote:
> On 3/11/24 17:05, Michael S. Tsirkin wrote:
> > 
> > Are we going anywhere with this btw?
> > 
> >
> 
> I think Tobias had a couple other threads related to this, with other potential fixes:
> 
> https://lore.kernel.org/lkml/20240228161018.14253-1-huschle@linux.ibm.com/
> 
> https://lore.kernel.org/lkml/20240228161023.14310-1-huschle@linux.ibm.com/
> 

Sorry, Michael, should have provided those threads here as well.

The more I look into this issue, the more things to ponder upon I find.
It seems like this issue can (maybe) be fixed on the scheduler side after all.

The root cause of this regression remains that the mentioned kworker gets
a negative lag value and is therefore not elligible to run on wake up.
This negative lag is potentially assigned incorrectly. But I'm not sure yet.

Anytime I find something that can address the symptom, there is a potential
root cause on another level, and I would like to avoid to just address a
symptom to fix the issue, wheras it would be better to find the actual
root cause.

I would nevertheless still argue, that vhost relies rather heavily on the fact
that the kworker gets scheduled on wake up everytime. But I don't have a 
proposal at hand that accounts for potential side effects if opting for
explicitly initiating a schedule.
Maybe the assumption, that said kworker should always be selected on wake 
up is valid. In that case the explicit schedule would merely be a safety 
net.

I will let you know if something comes up on the scheduler side. There are
some more ideas on my side how this could be approached.

