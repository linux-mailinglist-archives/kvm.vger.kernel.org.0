Return-Path: <kvm+bounces-16413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FE7C8B9AC1
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 14:24:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB78B1F21D4D
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 12:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A22583CCE;
	Thu,  2 May 2024 12:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SEGXKGk5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604867C09E;
	Thu,  2 May 2024 12:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714652639; cv=none; b=n6LdXntr+jwM8PnpqbfqxDHRScLe827cqVeOOH4grdkg1tn8f85iiC8hpHelodKEKkXPurz63y0iMTWeHI9b6K80uoVUn5rSiTMlY2f3U3kKoJjqvYOvcOpfeVG4Q3vdgVV0Axkkqlv6tT3b6VQj3fgB265WTgQthi+x6o8hLWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714652639; c=relaxed/simple;
	bh=7GnW3L0UewFa21PxmF5jDVBd/1UxVNTKfDWfygZy/mg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pf6hQ0KKYkus3HGCFXhm8jD86Dq2HoZtctiMxVc3X3Etmx70j/LeN31/96k6NpLuBDQPKZm3BzN7CI91fZnwBSJ4tbaNIGFveeverdd4PmhlgeekhF755SH21QmKbeXXZu6o9FebCfl25G0gEzd7sTzDL2BfVVgmpRdanpQHOdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SEGXKGk5; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 442C8iFM000348;
	Thu, 2 May 2024 12:23:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=9IiB2rmnnc0DMtL9pSUSRkL32DSpalMr9dFB/bMDr94=;
 b=SEGXKGk58zZplNiG0PHDKBbsg0APlNvPQ2jcSaCyeZc7gKErDDYQibbBJVIpbH06qyIo
 itba+mhkE4yjjbZthBY34bkW5RLci0ppJmo7Y4AE8aOyEMIzrNDDKgJplIBQ/q/zJFRp
 1EJXsyXAE3DTY+tx7Vr3w7kDiVL8bfoVob5fX6W03VIztlf76+52eMfWPl3BOziZDBUG
 7Tl5bPWrmtFBvEqB/n06C8Yyj91eYka+CP8YUPcY914n+kU8WZXZGlgvd59PsvW7KIlM
 W0s2fwdNszuZc2gjVZa1rcjTNxPh+ssocIwvYdn/osIPmB3gqz5ZYEI2+oQTXekwotx4 Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xvajr810d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 May 2024 12:23:41 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 442CNeUi022471;
	Thu, 2 May 2024 12:23:40 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xvajr8109-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 May 2024 12:23:40 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4429iej9015592;
	Thu, 2 May 2024 12:23:39 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xsed37esy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 May 2024 12:23:39 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 442CNYvF51904862
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 May 2024 12:23:36 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5678820063;
	Thu,  2 May 2024 12:23:34 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 14DDE20049;
	Thu,  2 May 2024 12:23:34 +0000 (GMT)
Received: from DESKTOP-2CCOB1S. (unknown [9.171.162.63])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  2 May 2024 12:23:34 +0000 (GMT)
Date: Thu, 2 May 2024 14:23:33 +0200
From: Tobias Huschle <huschle@linux.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Luis Machado <luis.machado@arm.com>,
        Jason Wang <jasowang@redhat.com>, Abel Wu <wuyun.abel@bytedance.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, netdev@vger.kernel.org,
        nd <nd@arm.com>, borntraeger@linux.ibm.com,
        Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6 sched/fair: Add
 lag based placement)
Message-ID: <ZjOFxbsHuQZ+Zltu@DESKTOP-2CCOB1S.>
References: <73123.124031407552500165@us-mta-156.us.mimecast.lan>
 <20240314110649-mutt-send-email-mst@kernel.org>
 <84704.124031504335801509@us-mta-515.us.mimecast.lan>
 <20240315062839-mutt-send-email-mst@kernel.org>
 <b3fd680c675208370fc4560bb3b4d5b8@linux.ibm.com>
 <20240319042829-mutt-send-email-mst@kernel.org>
 <4808eab5fc5c85f12fe7d923de697a78@linux.ibm.com>
 <ZjDM3SsZ3NkZuphP@DESKTOP-2CCOB1S.>
 <20240501105151.GG40213@noisy.programming.kicks-ass.net>
 <20240501112830-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240501112830-mutt-send-email-mst@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kVN33WdBekBnhviasqzgZSNBnf04Rs00
X-Proofpoint-GUID: D_B28lHPTZQArId0hWuIiQe6jqQ3ViYp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-02_01,2024-05-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0 impostorscore=0
 mlxlogscore=605 priorityscore=1501 malwarescore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405020078

On Wed, May 01, 2024 at 11:31:02AM -0400, Michael S. Tsirkin wrote:
> On Wed, May 01, 2024 at 12:51:51PM +0200, Peter Zijlstra wrote:
> > On Tue, Apr 30, 2024 at 12:50:05PM +0200, Tobias Huschle wrote:
<...>
> > 
> > I'm still wondering why exactly it is imperative for t2 to preempt t1.
> > Is there some unexpressed serialization / spin-waiting ?
> 
> 
> I am not sure but I think the point is that t2 is a kworker. It is
> much cheaper to run it right now when we are already in the kernel
> than return to userspace, let it run for a bit then interrupt it
> and then run t2.
> Right, Tobias?
> 

That would be correct, the optimal scenario would be that t1, the vhost
does its thing, wakes up t2, the kworker, makes sure t2 executes immediately,
then gets control again and continues watching its loops without ever 
leaving kernel space.

