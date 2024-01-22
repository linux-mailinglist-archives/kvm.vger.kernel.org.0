Return-Path: <kvm+bounces-6541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 11D668361FD
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 12:38:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05EA31C260E4
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 11:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 152CD40BE9;
	Mon, 22 Jan 2024 11:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="k3QKYbNv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFA4405F1;
	Mon, 22 Jan 2024 11:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705922961; cv=none; b=cuolAsiWTd/eJUFIb/m6oq6pJvcRsGZCQNO5jyRbNV3IOQ6wEr6xh0dJoXD93rLn+8rHj4eSv8FHTpZhDe80iaUDAM5iOHstw+HM92HfwXwM5SQ342vwyRvtWhOE9dcckLWvuDctZNPPwAiw5h1b9cUjqWT78URQjg+3s4N4lZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705922961; c=relaxed/simple;
	bh=02p3/XLk2GVAFOCVUjH4j4G+NWMsL97dBG6vEoRo548=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D/jlluT92sPygTc8XebAzkEWTe939lM+Y/AUUiHGHcdRDTjkJvN4zaxi1B958GUKySiopO/M9Kg43MQgnkDGLSAlaMzqmdwZoD/ZNPk//GI/m7gjGsrbbrUN6vWEMacYCpJzbxc+57aOSN0UEOLtmRTjwxLAIFq7qsbK+T9WhlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=k3QKYbNv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40MAxtDV001776;
	Mon, 22 Jan 2024 11:29:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=5QH4HoCU8SmewLPPMnnsPEQ8yT5/pbHG6Jqw+tq2pTk=;
 b=k3QKYbNvKjkrfceL0uRbET6cKX0Sl4SqIGrWj+wPxCV+jxq3yAf93DdqQFbUJ0xIf9zQ
 ijJrUbEgNixsJDnUKs/kUlOs/o/H3Go5m/Ik0MXX21L+Rtoj2x9WCicFXD5+O1W4hokn
 vmFlzSYox13kiIRDYWb0Mk2vgf4O7FaeIu5HLoYfrKz1j81iOuJrNfkNzGyWRtnhqmHo
 NhPR2YVWwi62ZZhRykE73+bNl0YUyWwsXmT9xPjXFR88xFrv27eerMWCfTeZeo8n+wSC
 X1JiyqsuWn6PJh0NDM74vpqvivPii9XTC0hj0JI3ZXSZg7/LPMscgAhu7A8eLZMv28OJ 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vsk8qe56h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Jan 2024 11:29:06 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40MBRDbc020845;
	Mon, 22 Jan 2024 11:29:05 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vsk8qe566-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Jan 2024 11:29:05 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40MAbajW026507;
	Mon, 22 Jan 2024 11:29:04 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vrrgt07dw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Jan 2024 11:29:04 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40MBT2vW12911278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Jan 2024 11:29:02 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 649E62004E;
	Mon, 22 Jan 2024 11:29:02 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3C2C920040;
	Mon, 22 Jan 2024 11:29:02 +0000 (GMT)
Received: from DESKTOP-2CCOB1S. (unknown [9.171.150.144])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 22 Jan 2024 11:29:02 +0000 (GMT)
Date: Mon, 22 Jan 2024 12:29:00 +0100
From: Tobias Huschle <huschle@linux.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, Abel Wu <wuyun.abel@bytedance.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6
 sched/fair: Add lag based placement)
Message-ID: <Za5RfPHu/Q9I6P05@DESKTOP-2CCOB1S.>
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
X-Proofpoint-ORIG-GUID: tFuOvGgRbZN-3A8u42BRC_-gNLQlCRlI
X-Proofpoint-GUID: jXHNqVrtEiakXHusiQPnyvRpdl7S0ZlQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-22_02,2024-01-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=831 spamscore=0 clxscore=1015 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401220082

On Sun, Jan 21, 2024 at 01:44:32PM -0500, Michael S. Tsirkin wrote:
> On Mon, Jan 08, 2024 at 02:13:25PM +0100, Tobias Huschle wrote:
> > On Thu, Dec 14, 2023 at 02:14:59AM -0500, Michael S. Tsirkin wrote:
> > > 
> > > Peter, would appreciate feedback on this. When is cond_resched()
> > > insufficient to give up the CPU? Should Documentation/kernel-hacking/hacking.rst
> > > be updated to require schedule() instead?
> > > 
> > 
> > Happy new year everybody!
> > 
> > I'd like to bring this thread back to life. To reiterate:
> > 
> > - The introduction of the EEVDF scheduler revealed a performance
> >   regression in a uperf testcase of ~50%.
> > - Tracing the scheduler showed that it takes decisions which are
> >   in line with its design.
> > - The traces showed as well, that a vhost instance might run
> >   excessively long on its CPU in some circumstance. Those cause
> >   the performance regression as they cause delay times of 100+ms
> >   for a kworker which drives the actual network processing.
> > - Before EEVDF, the vhost would always be scheduled off its CPU
> >   in favor of the kworker, as the kworker was being woken up and
> >   the former scheduler was giving more priority to the woken up
> >   task. With EEVDF, the kworker, as a long running process, is
> >   able to accumulate negative lag, which causes EEVDF to not
> >   prefer it on its wake up, leaving the vhost running.
> > - If the kworker is not scheduled when being woken up, the vhost
> >   continues looping until it is migrated off the CPU.
> > - The vhost offers to be scheduled off the CPU by calling 
> >   cond_resched(), but, the the need_resched flag is not set,
> >   therefore cond_resched() does nothing.
> > 
> > To solve this, I see the following options 
> >   (might not be a complete nor a correct list)
> > - Along with the wakeup of the kworker, need_resched needs to
> >   be set, such that cond_resched() triggers a reschedule.
> 
> Let's try this? Does not look like discussing vhost itself will
> draw attention from scheduler guys but posting a scheduling
> patch probably will? Can you post a patch?
> 

I'll give it a go.

> > - The vhost calls schedule() instead of cond_resched() to give up
> >   the CPU. This would of course be a significantly stricter
> >   approach and might limit the performance of vhost in other cases.
> > - Preventing the kworker from accumulating negative lag as it is
> >   mostly not runnable and if it runs, it only runs for a very short
> >   time frame. This might clash with the overall concept of EEVDF.
> > - On cond_resched(), verify if the consumed runtime of the caller
> >   is outweighing the negative lag of another process (e.g. the 
> >   kworker) and schedule the other process. Introduces overhead
> >   to cond_resched.
> 
> Or this last one.
> 

This one will probably be more complicated as the necessary information
is not really available at the places where I'd like to see it.
Will have to ponder on that a bit to figure out if there might be an
elegant way to approach this.

> 
> > 
> > I would be curious on feedback on those ideas and interested in
> > alternative approaches.
> 
> 

