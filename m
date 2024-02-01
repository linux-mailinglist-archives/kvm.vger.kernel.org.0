Return-Path: <kvm+bounces-7671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AFE484521C
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 08:39:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F9F71C21732
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 07:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BE291586C8;
	Thu,  1 Feb 2024 07:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cIkXFR+n"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993A6208DD;
	Thu,  1 Feb 2024 07:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706773146; cv=none; b=esFXr8JAJVCC6bJ3KxT/aXO2ksb34kAu0sBgJSaTk/eXd/ykx5qqNCfE2o1B8QkJvbsYgPa3QM2tHmKG+GVOPn/cympoV+4c1ZGHE75dUTrc7tssU41cV8kYym5TCsLLVBMuZoa5r3j0UWS7yAgzRzeAr+13egfl7t0uabme9j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706773146; c=relaxed/simple;
	bh=Vy3QAsyp6Zh8+Hcn9aLRVk8VwYfa3R24xQXNfWAKT4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JAKSUxILUQY7Ruo7iOx6NcfGS3CtyyTTNtbH8ryxpg/3gKLeNnyg/jaQCHYA/Pk6TLe9MEaNyMchyWSjGTdNXeV39in9uYYuGSJxs99bo9khpNoZ8okk+z9btIkL4BACZXlBktK8SFBkXGnzyN3PfPS7wJX1kjQVZWJEmi/E0mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cIkXFR+n; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41167OjR023207;
	Thu, 1 Feb 2024 07:38:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=O5xbgGIVQTFeQwn1snTqVjPyk1UJqDq7NObWf8KUYvU=;
 b=cIkXFR+n/pu1/YCFuL3LWp5TOK+UO2VLs5whWub60JTQvqf7suBBLJs13FHLYc9zWQ1W
 d7JcT8/RNZwbGn/W9zSt3rfaBTNLYdDeyuE6YMcoH5fmZYF7NFUYjlyREmOtGMtMfskT
 HRY/TVn8v2Tf/srs8UsUY3sS7ni6PvYdHi7HiI6iDLVTD1FyPMl8WE5q4/nXQOoznlw7
 aAKl/QCb1GgQdQQdknUYQD49mCWo5/n6UIFW66TcWc0JZVK6DW0fKJF9D86ubAiq+4tT
 amyz0z2suBSkX+5Rf/t3P598z4ONL5iKeResvWudmHo76N13suWP/lxmy8dM7gGYnTIm gA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w05re1wty-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 07:38:49 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4117TlOG016946;
	Thu, 1 Feb 2024 07:38:48 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w05re1wtf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 07:38:48 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4116sqx1008242;
	Thu, 1 Feb 2024 07:38:47 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vwdnmajk0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 07:38:47 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4117cj8X39518878
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 1 Feb 2024 07:38:45 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1431920043;
	Thu,  1 Feb 2024 07:38:45 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DA4DE20040;
	Thu,  1 Feb 2024 07:38:44 +0000 (GMT)
Received: from DESKTOP-2CCOB1S. (unknown [9.171.218.73])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  1 Feb 2024 07:38:44 +0000 (GMT)
Date: Thu, 1 Feb 2024 08:38:43 +0100
From: Tobias Huschle <huschle@linux.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, Abel Wu <wuyun.abel@bytedance.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6
 sched/fair: Add lag based placement)
Message-ID: <ZbtKg6815Uwg3HPw@DESKTOP-2CCOB1S.>
References: <20231211115329-mutt-send-email-mst@kernel.org>
 <CACGkMEudZnF7hUajgt0wtNPCxH8j6A3L1DgJj2ayJWhv9Bh1WA@mail.gmail.com>
 <20231212111433-mutt-send-email-mst@kernel.org>
 <42870.123121305373200110@us-mta-641.us.mimecast.lan>
 <20231213061719-mutt-send-email-mst@kernel.org>
 <25485.123121307454100283@us-mta-18.us.mimecast.lan>
 <20231213094854-mutt-send-email-mst@kernel.org>
 <20231214021328-mutt-send-email-mst@kernel.org>
 <92916.124010808133201076@us-mta-622.us.mimecast.lan>
 <20240121134311-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240121134311-mutt-send-email-mst@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dszN-J_Pt26RmI-Q8iq1vbjEbXr0EEWP
X-Proofpoint-ORIG-GUID: TIVluWx1UphXsst12-HPeQ90EczE4qo0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-31_10,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 malwarescore=0
 mlxlogscore=686 bulkscore=0 phishscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402010060

On Sun, Jan 21, 2024 at 01:44:32PM -0500, Michael S. Tsirkin wrote:
> On Mon, Jan 08, 2024 at 02:13:25PM +0100, Tobias Huschle wrote:
> > On Thu, Dec 14, 2023 at 02:14:59AM -0500, Michael S. Tsirkin wrote:
> > - Along with the wakeup of the kworker, need_resched needs to
> >   be set, such that cond_resched() triggers a reschedule.
> 
> Let's try this? Does not look like discussing vhost itself will
> draw attention from scheduler guys but posting a scheduling
> patch probably will? Can you post a patch?

As a baseline, I verified that the following two options fix
the regression:

- replacing the cond_resched in the vhost_worker function with a hard
  schedule 
- setting the need_resched flag using set_tsk_need_resched(current)
  right before calling cond_resched

I then tried to find a better spot to put the set_tsk_need_resched
call. 

One approach I found to be working is setting the need_resched flag 
at the end of handle_tx and hande_rx.
This would be after data has been actually passed to the socket, so 
the originally blocked kworker has something to do and will profit
from the reschedule. 
It might be possible to go deeper and place the set_tsk_need_resched
call to the location right after actually passing the data, but this
might leave us with sprinkling that call in multiple places and
might be too intrusive.
Furthermore, it might be possible to check if an error occured when
preparing the transmission and then skip the setting of the flag.

This would require a conceptual decision on the vhost side.
This solution would not touch the scheduler, only incentivise it to
do the right thing for this particular regression.

Another idea could be to find the counterpart that initiates the
actual data transfer, which I assume wakes up the kworker. From
what I gather it seems to be an eventfd notification that ends up
somewhere in the qemu code. Not sure if that context would allow
to set the need_resched flag, nor whether this would be a good idea.

> 
> > - On cond_resched(), verify if the consumed runtime of the caller
> >   is outweighing the negative lag of another process (e.g. the 
> >   kworker) and schedule the other process. Introduces overhead
> >   to cond_resched.
> 
> Or this last one.

On cond_resched itself, this will probably only be possible in a very 
very hacky way. That is because currently, there is no immidiate access
to the necessary data available, which would make it necessary to 
bloat up the cond_resched function quite a bit, with a probably 
non-negligible amount of overhead.

Changing other aspects in the scheduler might get us in trouble as
they all would probably resolve back to the question "What is the magic
value that determines whether a small task not being scheduled justifies
setting the need_resched flag for a currently running task or adjusting 
its lag?". As this would then also have to work for all non-vhost related
cases, this looks like a dangerous path to me on second thought.


-------- Summary --------

In my (non-vhost experience) opinion the way to go would be either
replacing the cond_resched with a hard schedule or setting the
need_resched flag within vhost if the a data transfer was successfully
initiated. It will be necessary to check if this causes problems with
other workloads/benchmarks.

