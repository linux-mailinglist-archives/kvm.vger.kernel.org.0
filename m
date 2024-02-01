Return-Path: <kvm+bounces-7697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 86087845678
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 12:48:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 120711F21D26
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 11:48:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B42AE15D5C6;
	Thu,  1 Feb 2024 11:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="r2kqjF9A"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343D015A4A1;
	Thu,  1 Feb 2024 11:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706788077; cv=none; b=f+0c0M5AYFpkKupIKqM9oiCcKqHQsb1YeC6Xi7bHk286vJcKq9mTZN9swgyJ1lly1YkykBONZj7RdcQtlUul69SX8NcxJdQLKroQuAXaEmy40Fb3EOJqKjSsDB1kMUBG6+T+GOXozoTsWlln411cZCEufmjOVukZx9zpIZ61QZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706788077; c=relaxed/simple;
	bh=3YSBqGWCBu/wTnV/QgZRt0jfyeNGR91detHn2DZNthA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OF7phgTg/3TZx77yi0iH3X3z0YLcVd+1C3f6HHat+J+/1Kr0qrZtpwG4+Bv/jcMZ+9pvpC78ZcSY4eGDVqXCieu7NGKQWWrFU9hLLriyWGHuBV5hN2VsRBH8cIfYVnZlPfq1PFcm2Z+4Ae30H5PZFYMnZNgYsGFCzIoAPpys9kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=r2kqjF9A; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 411B1A55000664;
	Thu, 1 Feb 2024 11:47:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=jnFwnh2wR+EDN18Xur/JCsm2mfiUClnfyYdp83qB8YE=;
 b=r2kqjF9AOSElQFzyDTYdZd0ghDyQflRx0k2iTaUV1xjJAV0020RKB5c6JcOSOOvFT8pj
 BlFlF4fPGAGIUxKq1vR5+EFUOMiQLbCq1pGcBbh7XvVgwaWGuj1UtXp/y5P/xd2PKJLH
 HgCiclc/uLeR+RrYFIEg9H8lvXDruLM8nfdbMJizMT5zomy9arPPLPGqgXzsadTTwa7N
 lWvgDuW8Mr+sYNuVBCZHJbUDk4TYO7PJ1SWlyVD26TtwgIUANnXwcY0UdIagZUkPufrE
 3pYPqSZXhb2/nQvUY3bpU8Av7brLwEiwotdtS88BMma/X+q+HfttbG/TiGn9OE10T4Uf Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w07t4mm3p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 11:47:43 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 411B1EZ6001560;
	Thu, 1 Feb 2024 11:47:43 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w07t4mm3a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 11:47:43 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4119512X002195;
	Thu, 1 Feb 2024 11:47:42 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vwc5tm3vw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 11:47:42 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 411Bleqh21168692
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 1 Feb 2024 11:47:40 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 97BF02004B;
	Thu,  1 Feb 2024 11:47:40 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B61420043;
	Thu,  1 Feb 2024 11:47:40 +0000 (GMT)
Received: from DESKTOP-2CCOB1S. (unknown [9.171.218.73])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  1 Feb 2024 11:47:40 +0000 (GMT)
Date: Thu, 1 Feb 2024 12:47:39 +0100
From: Tobias Huschle <huschle@linux.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, Abel Wu <wuyun.abel@bytedance.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6
 sched/fair: Add lag based placement)
Message-ID: <ZbuE23ia3lhyzItm@DESKTOP-2CCOB1S.>
References: <20231212111433-mutt-send-email-mst@kernel.org>
 <42870.123121305373200110@us-mta-641.us.mimecast.lan>
 <20231213061719-mutt-send-email-mst@kernel.org>
 <25485.123121307454100283@us-mta-18.us.mimecast.lan>
 <20231213094854-mutt-send-email-mst@kernel.org>
 <20231214021328-mutt-send-email-mst@kernel.org>
 <92916.124010808133201076@us-mta-622.us.mimecast.lan>
 <20240121134311-mutt-send-email-mst@kernel.org>
 <07974.124020102385100135@us-mta-501.us.mimecast.lan>
 <20240201030341-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240201030341-mutt-send-email-mst@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Rvv6tM4E0SppOFo22qhAnxGudVTCSWAz
X-Proofpoint-GUID: 3L7n8JoQg6udY9-L0Fq692DCstTudRMc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-31_10,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 mlxlogscore=811
 phishscore=0 suspectscore=0 clxscore=1015 mlxscore=0 adultscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402010095

On Thu, Feb 01, 2024 at 03:08:07AM -0500, Michael S. Tsirkin wrote:
> On Thu, Feb 01, 2024 at 08:38:43AM +0100, Tobias Huschle wrote:
> > On Sun, Jan 21, 2024 at 01:44:32PM -0500, Michael S. Tsirkin wrote:
> > > On Mon, Jan 08, 2024 at 02:13:25PM +0100, Tobias Huschle wrote:
> > > > On Thu, Dec 14, 2023 at 02:14:59AM -0500, Michael S. Tsirkin wrote:
> > 
> > -------- Summary --------
> > 
> > In my (non-vhost experience) opinion the way to go would be either
> > replacing the cond_resched with a hard schedule or setting the
> > need_resched flag within vhost if the a data transfer was successfully
> > initiated. It will be necessary to check if this causes problems with
> > other workloads/benchmarks.
> 
> Yes but conceptually I am still in the dark on whether the fact that
> periodically invoking cond_resched is no longer sufficient to be nice to
> others is a bug, or intentional.  So you feel it is intentional?

I would assume that cond_resched is still a valid concept.
But, in this particular scenario we have the following problem:

So far (with CFS) we had:
1. vhost initiates data transfer
2. kworker is woken up
3. CFS gives priority to woken up task and schedules it
4. kworker runs

Now (with EEVDF) we have:
0. In some cases, kworker has accumulated negative lag 
1. vhost initiates data transfer
2. kworker is woken up
-3a. EEVDF does not schedule kworker if it has negative lag
-4a. vhost continues running, kworker on same CPU starves
--
-3b. EEVDF schedules kworker if it has positive or no lag
-4b. kworker runs

In the 3a/4a case, the kworker is given no chance to set the
necessary flag. The flag can only be set by another CPU now.
The schedule of the kworker was not caused by cond_resched, but
rather by the wakeup path of the scheduler.

cond_resched works successfully once the load balancer (I suppose) 
decides to migrate the vhost off to another CPU. In that case, the
load balancer on another CPU sets that flag and we are good.
That then eventually allows the scheduler to pick kworker, but very
late.

> I propose a two patch series then:
> 
> patch 1: in this text in Documentation/kernel-hacking/hacking.rst
> 
> If you're doing longer computations: first think userspace. If you
> **really** want to do it in kernel you should regularly check if you need
> to give up the CPU (remember there is cooperative multitasking per CPU).
> Idiom::
> 
>     cond_resched(); /* Will sleep */
> 
> 
> replace cond_resched -> schedule
> 
> 
> Since apparently cond_resched is no longer sufficient to
> make the scheduler check whether you need to give up the CPU.
> 
> patch 2: make this change for vhost.
> 
> WDYT?

For patch 1, I would like to see some feedback from Peter (or someone else
from the scheduler maintainers).
For patch 2, I would prefer to do some more testing first if this might have
an negative effect on other benchmarks.

I also stumbled upon something in the scheduler code that I want to verify.
Maybe a cgroup thing, will check that out again.

I'll do some more testing with the cond_resched->schedule fix, check the
cgroup thing and wait for Peter then.
Will get back if any of the above yields some results.

> 
> -- 
> MST
> 
> 

