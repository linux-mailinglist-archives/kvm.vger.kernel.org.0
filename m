Return-Path: <kvm+bounces-11896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BD8587C9F4
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 09:34:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E7B71C22592
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 08:34:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95F18175A1;
	Fri, 15 Mar 2024 08:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ECOghEEI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F3317581;
	Fri, 15 Mar 2024 08:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710491656; cv=none; b=EFJgmraaPPC0AUrVwNnsI2f0pLfrSGivQ6Yl8FiG1ID3wCguTE23J09rzHkuZYLK5WRoC8XxWHuxdCPcXTV2r6QXskcmSJagLF4HuufVZ/a2W3+erRbQDFUvcdJcz2wPfK9IOzGrriCg/ASX1fDSppbPTIrrCOspysPgvrPd0ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710491656; c=relaxed/simple;
	bh=uLD2+SRtcCTCMUCgmnjSj25HkrmEKJRC6VbmgO5duKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bx7mqQomC5FgQ16iNyemqB+eOnpRXVdikFBOtJ5TE8Y1BNZoLh2RntLbxbSYSjbUrQx9ZdeAfg6GluqP3RFXZ9rSPh96ZcmxE5J7Z0z2cWKYXr2Zs4Ko9NleUDJEdCwp1HW1aQqY3qyr9pFbg9u+Wj/iGHrAwiQK9nEal83fBGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ECOghEEI; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42F8VFEh005212;
	Fri, 15 Mar 2024 08:33:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=h8UR0vcPeFHcPgZLJhsWdusEkhHzg6hgpaW3PTDECQM=;
 b=ECOghEEIJRzNpAxo23Hnd0WzEskYr1XIMjeMjM18Ovqzx6zdcGT5mNwP20luumKEmATM
 3Q1zW0pZK6gZsbqxn5GAHV/TunBe6xFTXMSH9GiSDgbdJ5eihf7FVZ+YlsN2HH+6Rwcy
 3iC0wnxa9ZQHb45a/oCXp5ThmhF+z8oB1+nwtSrGkTfiCeRj5Eks+KpqjGm2o/rh6Wh2
 Y83OFt4UYkW4QnkyiwtEEbgqoqSufnkExi1CbBSV81m5p0uaqQo/SjNmh7TgWutBsNua
 m6Y/0S4G3arUz+aDQMEt9n7KD6NCsQHpay5rPrjM7syWjQmU8aL2HiQ8CbmdWtj7e7nX vw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wvgjdspmm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Mar 2024 08:33:56 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42F8VS27005858;
	Fri, 15 Mar 2024 08:33:56 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wvgjdspm7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Mar 2024 08:33:56 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42F7wb1R020506;
	Fri, 15 Mar 2024 08:33:54 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ws3kmjhyy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Mar 2024 08:33:54 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42F8Xovm35127556
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Mar 2024 08:33:52 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BB2A42005A;
	Fri, 15 Mar 2024 08:33:50 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 871132004B;
	Fri, 15 Mar 2024 08:33:50 +0000 (GMT)
Received: from DESKTOP-2CCOB1S. (unknown [9.171.202.216])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 15 Mar 2024 08:33:50 +0000 (GMT)
Date: Fri, 15 Mar 2024 09:33:49 +0100
From: Tobias Huschle <huschle@linux.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Luis Machado <luis.machado@arm.com>, Jason Wang <jasowang@redhat.com>,
        Abel Wu <wuyun.abel@bytedance.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, netdev@vger.kernel.org,
        nd <nd@arm.com>
Subject: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6 sched/fair: Add
 lag based placement)
Message-ID: <ZfQH7b3ZBwqwV3G3@DESKTOP-2CCOB1S.>
References: <20231214021328-mutt-send-email-mst@kernel.org>
 <92916.124010808133201076@us-mta-622.us.mimecast.lan>
 <20240121134311-mutt-send-email-mst@kernel.org>
 <07974.124020102385100135@us-mta-501.us.mimecast.lan>
 <20240201030341-mutt-send-email-mst@kernel.org>
 <89460.124020106474400877@us-mta-475.us.mimecast.lan>
 <20240311130446-mutt-send-email-mst@kernel.org>
 <cf813f92-9806-4449-b099-1bb2bd492b3c@arm.com>
 <73123.124031407552500165@us-mta-156.us.mimecast.lan>
 <20240314110649-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240314110649-mutt-send-email-mst@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4U3YY95uVFkwJGPaq4gMrxxcn20Le5KY
X-Proofpoint-ORIG-GUID: GM8yA1PPHFYC7BILomuwNiZdApPQ2qoL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-14_13,2024-03-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 mlxscore=0
 suspectscore=0 spamscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403150069

On Thu, Mar 14, 2024 at 11:09:25AM -0400, Michael S. Tsirkin wrote:
> 
> Thanks a lot! To clarify it is not that I am opposed to changing vhost.
> I would like however for some documentation to exist saying that if you
> do abc then call API xyz. Then I hope we can feel a bit safer that
> future scheduler changes will not break vhost (though as usual, nothing
> is for sure).  Right now we are going by the documentation and that says
> cond_resched so we do that.
> 
> -- 
> MST
> 

Here I'd like to add that we have two different problems:

1. cond_resched not working as expected
   This appears to me to be a bug in the scheduler where it lets the cgroup, 
   which the vhost is running in, loop endlessly. In EEVDF terms, the cgroup
   is allowed to surpass its own deadline without consequences. One of my RFCs
   mentioned above adresses this issue (not happy yet with the implementation).
   This issue only appears in that specific scenario, so it's not a general 
   issue, rather a corner case.
   But, this fix will still allow the vhost to reach its deadline, which is
   one full time slice. This brings down the max delays from 300+ms to whatever
   the timeslice is. This is not enough to fix the regression.

2. vhost relying on kworker being scheduled on wake up
   This is the bigger issue for the regression. There are rare cases, where
   the vhost runs only for a very short amount of time before it wakes up 
   the kworker. Simultaneously, the kworker takes longer than usual to 
   complete its work and takes longer than the vhost did before. We
   are talking 4digit to low 5digit nanosecond values.
   With those two being the only tasks on the CPU, the scheduler now assumes
   that the kworker wants to unfairly consume more than the vhost and denies
   it being scheduled on wakeup.
   In the regular cases, the kworker is faster than the vhost, so the 
   scheduler assumes that the kworker needs help, which benefits the
   scenario we are looking at.
   In the bad case, this means unfortunately, that cond_resched cannot work
   as good as before, for this particular case!
   So, let's assume that problem 1 from above is fixed. It will take one 
   full time slice to get the need_resched flag set by the scheduler
   because vhost surpasses its deadline. Before, the scheduler cannot know
   that the kworker should actually run. The kworker itself is unable
   to communicate that by itself since it's not getting scheduled and there 
   is no external entity that could intervene.
   Hence my argumentation that cond_resched still works as expected. The
   crucial part is that the wake up behavior has changed which is why I'm 
   a bit reluctant to propose a documentation change on cond_resched.
   I could see proposing a doc change, that cond_resched should not be
   used if a task heavily relies on a woken up task being scheduled.

