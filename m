Return-Path: <kvm+bounces-42840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 72B7AA7DEA1
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 15:13:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 187E7188B633
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 13:13:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC39815382E;
	Mon,  7 Apr 2025 13:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XVRhZI8B"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735692288D2;
	Mon,  7 Apr 2025 13:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744031587; cv=none; b=UuP6AE3XDsx1srwfv3e2ndV+SsFeUonDdEhitOkt3hLxQrTUYUIFCWNJhexYtbWOQOWjN1FV+YwM7KkZM1vb20eTXiHRLDDALgvzaLOCIAqzo4n+qQUpN1QmD/0wT/iqqDT5tfAKnx3ybEtFaMoyntkvoWnsZSXfIaZSkt/xVhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744031587; c=relaxed/simple;
	bh=dVLtvgPnJdXLzcoDxT0pZr8vj6vljEbapmWMe2KsjVY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nSCH/oEc2yRHUM4EG7WXOBDBbIXCrx5Dl5qJGJffW4+oRAoS7NUCB8X1QhqFB4X2v1XA/IiK8DbQByaDaN77hKpgpCE3MPZ7V0sDyDdFDzpOlhU86d0ddqix4p7Xzd65h9BS0CN6V+FEpjGOnkdVe2Qbw/dQSArRqyPHphRgHTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XVRhZI8B; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 537D8nCt008341;
	Mon, 7 Apr 2025 13:12:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=kTVk9i
	eL2vFL3nlCB+xMp/6WkRXc8psU3RULIlrezBo=; b=XVRhZI8B6F3rVREKTFXp1l
	GLFUIZr7Bt4RlFNIJPtXOb6xEofgUgcP0S4JdTLWNac9/Zcp4WQzWdi3NqZv0iSq
	9yubEBbVi+9/lFkPm1SaZ9h8pNnt9aL0qkvyPcRV/QW8TLdlM509WEnSVY8styX2
	rJPxk3D10q1uz6w1Z1zyJ9BrEI5Zrc5UD/Ww7BwcXxMnYzXiGRrGkv1nV6gQHSQU
	TDZSx6qlpXtXSAH4P1xfG6d0X+jRUngUwh10n9Rg3K6StCx9XnrwNZLKjJjLpDIR
	OS7lZc4izypJqliIcA7k+Odb/Z9RLyfF1hQJEVlc3RGdf2EimNpL7YLsAwbhFtQQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45v739jg0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Apr 2025 13:12:59 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 537B6sh2017457;
	Mon, 7 Apr 2025 13:12:58 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 45uh2kdqnm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Apr 2025 13:12:56 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 537DCqWN54657412
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 7 Apr 2025 13:12:52 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6D6BD2004E;
	Mon,  7 Apr 2025 13:12:52 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE55C20040;
	Mon,  7 Apr 2025 13:12:51 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.152.224.212])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  7 Apr 2025 13:12:51 +0000 (GMT)
Date: Mon, 7 Apr 2025 15:12:49 +0200
From: Halil Pasic <pasic@linux.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, Chandra Merla <cmerla@redhat.com>,
        Stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth
 <thuth@redhat.com>, Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Wei Wang
 <wei.w.wang@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
Message-ID: <20250407151249.7fe1e418.pasic@linux.ibm.com>
In-Reply-To: <20250407042058-mutt-send-email-mst@kernel.org>
References: <20250404063619.0fa60a41.pasic@linux.ibm.com>
	<4a33daa3-7415-411e-a491-07635e3cfdc4@redhat.com>
	<d54fbf56-b462-4eea-a86e-3a0defb6298b@redhat.com>
	<20250404153620.04d2df05.pasic@linux.ibm.com>
	<d6f5f854-1294-4afa-b02a-657713435435@redhat.com>
	<20250404160025.3ab56f60.pasic@linux.ibm.com>
	<6f548b8b-8c6e-4221-a5d5-8e7a9013f9c3@redhat.com>
	<20250404173910.6581706a.pasic@linux.ibm.com>
	<20250407034901-mutt-send-email-mst@kernel.org>
	<2b187710-329d-4d36-b2e7-158709ea60d6@redhat.com>
	<20250407042058-mutt-send-email-mst@kernel.org>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XlMUYpPLp9HmrbE7tJ6e6kIKNuwsg--1
X-Proofpoint-ORIG-GUID: XlMUYpPLp9HmrbE7tJ6e6kIKNuwsg--1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-07_04,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2502280000 definitions=main-2504070091

On Mon, 7 Apr 2025 04:34:29 -0400
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Mon, Apr 07, 2025 at 10:17:10AM +0200, David Hildenbrand wrote:
> > On 07.04.25 09:52, Michael S. Tsirkin wrote:  
> > > On Fri, Apr 04, 2025 at 05:39:10PM +0200, Halil Pasic wrote:  
> > > > > 
> > > > > Not perfect, but AFAIKS, not horrible.  
> > > > 
> > > > It is like it is. QEMU does queue exist if the corresponding feature
> > > > is offered by the device, and that is what we have to live with.  
> > > 
> > > I don't think we can live with this properly though.
> > > It means a guest that does not know about some features
> > > does not know where to find things.  
> > 
> > Please describe a real scenario, I'm missing the point.  
> 
> 
> OK so.
> 
> Device has VIRTIO_BALLOON_F_FREE_PAGE_HINT and VIRTIO_BALLOON_F_REPORTING
> Driver only knows about VIRTIO_BALLOON_F_REPORTING so
> it does not know what does VIRTIO_BALLOON_F_FREE_PAGE_HINT do.
> How does it know which vq to use for reporting?
> It will try to use the free page hint one.

First, sorry for not catching up again with the discussion earlier.

I think David's point is based on the assumption that by the time feature
with the feature bit N+1 is specified and allocates a queue Q, all
queues with indexes smaller than Q are allocated and possibly associated
with features that were previously specified (and probably have feature
bits smaller than N+1). 

I.e. that we can mandate, even if you don't want to care about other
optional features, you have to, because we say so, for the matter of
virtqueue existence. And anything in the future, you don't have to care
about because the queue index associated with future features is larger
than Q, so it does not affect our position.

I think that argument can fall a part if:
* future features reference optional queues defined in the past
* somebody managed to introduce a limbo where a feature is reserved, and
  they can not decide if they want a queue or not, or make the existence
  of the queue depend on something else than a feature bit.

Frankly I don't think the risks are huge, but it would undoubtedly make
the spec more ugly.

> 
> 
> 
> > Whoever adds new feat_X *must be aware* about all previous features,
> > otherwise we'd be reusing feature bits and everything falls to pieces.  
> 
> 
> The knowledge is supposed be limited to which feature bit to use.
> 

I do agree! This is why I brought this question up. Creating exceptions
from that rule would be very ugly IMHO. But I would not say it is
impossible.

> 
> 
> > > 
> > > So now, I am inclined to add linux code to work with current qemu and
> > > with spec compliant one, and add qemu code to work with current linux
> > > and spec compliant one.
> > > 
> > > Document the bug in the spec, maybe, in a non conformance section.  
> > 
> > I'm afraid this results in a lot of churn without really making things
> > better.  
> 
> > IMHO, documenting things how they actually behave, and maybe moving towards
> > fixed queue indexes for new features is the low hanging fruit.  
> 
> I worry about how to we ensure that?
> If old code is messed up people will just keep propagating that.
> I would like to fix old code so that new code is correct.
> 
> > 
> > As raised, it's not just qemu+linux, it's *at least* also cloud-hypervisor.
> > 
> > -- 
> > Cheers,
> > 
> > David / dhildenb  
> 
> There's a slippery slope here in that people will come to us
> with buggy devices and ask to change the spec.
> 

I agree! IMHO all we have are bad options. To decide for myself which is
less ugly I would love to see both.

I agree making the spec bend to the fact that implementations are buggy
does not seem right from the spec perspective. But if making things work
is not practical without sacrificing the sanctity of the spec, I am
willing to swallow the bitter pill and bend the spec.

If you don't mind try to keep me in the loop, even if I'm not able to
be as responsive as I would like to be. I'm happy fixing the code is
going to get another round of consideration.

Regards,
Halil


