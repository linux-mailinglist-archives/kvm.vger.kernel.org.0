Return-Path: <kvm+bounces-42658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 49B8DA7C0C0
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 17:39:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 848F3189EEEE
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 15:40:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A63A1F63E8;
	Fri,  4 Apr 2025 15:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="INalXyZp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AC31F582E;
	Fri,  4 Apr 2025 15:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743781171; cv=none; b=WSSHpnAC1YWT7aGR1gLmg9dnABS0j2dT1Vx41fty6tBHdqi/RTHqKx0F8/tXo+nrzSeEghqSzBafF+SFFAo7e2r+H3SmDZZdPtUF7B6ga8djdnCXHYU0G4yKmrb/aiVXAdQBZQIGi3MfhG8bqm5QeHbBKWNfJWPP9wkwdpI+TeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743781171; c=relaxed/simple;
	bh=HEjQ44ECl6BWQeGt6MRJD0EJeyM16OwfpE3eK/mCCz0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bSTggeXN7+mw4V6Uacw6SecRG1BFXdD6B2Jov3vvzhW7YK8fHlZCmaVxVgX03dgbP9vkMSAQz5ofnwbPCZsZ5RICv+3SKeNcBPstY0hfAd1hCrZ9gCC0A6zeyVxRBPeHqlrX/4twikD1FZ+7CM2oil6+eXaf7kBzGa1WtlLBkhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=INalXyZp; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 534BQYJ6011494;
	Fri, 4 Apr 2025 15:39:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=9vFnFX
	GmFN4YVJC6HHTNW4/vjVozGULmM9qZqtND68A=; b=INalXyZpdW/tTGAKjLVGeC
	AraD0yfauhb111SuqaGxlL+Mo/Imn/wlgTSRIuiBE9wKgf0EM2cUSFYNluToQJSC
	q+j7ogv/3m9daxvxA7Ugm+tB8+YsBGhJOunmyl4+vvMdFveZcH0bTB3s9zdVAQKS
	3qTrcjHwvfxr2NHw6OVWlBEugNv6QbPPhs8XuYtkkv74qHDrGZOiSkEaLcwgLNRW
	FEBnGZNwnpcFYSXHADfUB5mlwwWKKWZ5cPgoK/CCd56Bk3c1gFNEgTCHV/ps/cCC
	E0FndjQuYTFhgh4giHBFjB2HmfgV0gmUcULFWbCyQAHaQEEhqdEErhddwl61EH2A
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45t2qbv6c7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Apr 2025 15:39:22 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 534F57RT021283;
	Fri, 4 Apr 2025 15:39:22 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45t2e7bk97-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Apr 2025 15:39:22 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 534FdIwv22020418
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 4 Apr 2025 15:39:18 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2D4A520043;
	Fri,  4 Apr 2025 15:39:18 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A203820040;
	Fri,  4 Apr 2025 15:39:17 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.152.224.212])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  4 Apr 2025 15:39:17 +0000 (GMT)
Date: Fri, 4 Apr 2025 17:39:10 +0200
From: Halil Pasic <pasic@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org,
        Chandra Merla
 <cmerla@redhat.com>, Stable@vger.kernel.org,
        Cornelia Huck
 <cohuck@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Eric Farman
 <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Wei Wang
 <wei.w.wang@intel.com>, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
Message-ID: <20250404173910.6581706a.pasic@linux.ibm.com>
In-Reply-To: <6f548b8b-8c6e-4221-a5d5-8e7a9013f9c3@redhat.com>
References: <20250402203621.940090-1-david@redhat.com>
	<20250403161836.7fe9fea5.pasic@linux.ibm.com>
	<e2936e2f-022c-44ee-bb04-f07045ee2114@redhat.com>
	<20250404063619.0fa60a41.pasic@linux.ibm.com>
	<4a33daa3-7415-411e-a491-07635e3cfdc4@redhat.com>
	<d54fbf56-b462-4eea-a86e-3a0defb6298b@redhat.com>
	<20250404153620.04d2df05.pasic@linux.ibm.com>
	<d6f5f854-1294-4afa-b02a-657713435435@redhat.com>
	<20250404160025.3ab56f60.pasic@linux.ibm.com>
	<6f548b8b-8c6e-4221-a5d5-8e7a9013f9c3@redhat.com>
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
X-Proofpoint-ORIG-GUID: WiU9dmC01eA-xDfoYKI1bTZ-BrqP5WXq
X-Proofpoint-GUID: WiU9dmC01eA-xDfoYKI1bTZ-BrqP5WXq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-04_06,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 adultscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504040107

On Fri, 4 Apr 2025 16:17:14 +0200
David Hildenbrand <david@redhat.com> wrote:

> > It is offered. And this is precisely why I'm so keen on having a
> > precise wording here.  
> 
> Yes, me too. The current phrasing in the spec is not clear.
> 
> Linux similarly checks 
> virtio_has_feature()->virtio_check_driver_offered_feature().

Careful, that is a *driver* offered and not a *device* offered! 

We basically mandate that one can only check for a feature F with
virtio_has_feature() such that it is either in drv->feature_table or in
drv->feature_table_legacy.

AFAICT *device_features* obtained via dev->config->get_features(dev)
isn't even saved but is only used for binary and-ing it with the
driver_features to obtain the negotiated features.

That basically means that if I was, for the sake of fun do

--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -1197,7 +1197,6 @@ static unsigned int features[] = {
        VIRTIO_BALLOON_F_MUST_TELL_HOST,
        VIRTIO_BALLOON_F_STATS_VQ,
        VIRTIO_BALLOON_F_DEFLATE_ON_OOM,
-       VIRTIO_BALLOON_F_FREE_PAGE_HINT,
        VIRTIO_BALLOON_F_PAGE_POISON,
        VIRTIO_BALLOON_F_REPORTING,
 };

I would end up with virtio_check_driver_offered_feature() calling
BUG().

That basically means that Linux mandates implementing all previous
features regardless whether does are supposed to be optional ones or
not. Namely if you put the feature into drv->feature_table it will
get negotiated. 

Which is not nice IMHO.

> 
> > 
> > Usually for compatibility one needs negotiated. Because the feature
> > negotiation is mostly about compatibility. I.e. the driver should be
> > able to say, hey I don't know about that feature, and get compatible
> > behavior. If for example VIRTIO_BALLOON_F_FREE_PAGE_HINT and
> > VIRTIO_BALLOON_F_PAGE_REPORTING are both offered but only
> > VIRTIO_BALLOON_F_PAGE_REPORTING is negotiated. That would make
> > reporting_vq jump to +1 compared to the case where
> > VIRTIO_BALLOON_F_FREE_PAGE_HINT is not offered. Which is IMHO no
> > good, because for the features that the driver is going to reject in
> > most of the cases it should not matter if it was offered or not.  
> 
> Yes. The key part is that we may only add new features to the tail of 
> our feature list; maybe we should document that as well.
> 
> I agree that a driver that implements VIRTIO_BALLOON_F_PAGE_REPORTING 
> *must* be aware that VIRTIO_BALLOON_F_FREE_PAGE_HINT exists. So queue 
> existence is not about feature negotiation but about features being 
> offered from the device.
> 
> ... which is a bit the same behavior as with fixed-assigned numbers a 
> bit. VIRTIO_BALLOON_F_PAGE_REPORTING was documented as "4" because 
> VIRTIO_BALLOON_F_FREE_PAGE_HINT was documented to be "3" -- IOW, it 
> already existed in the spec.

I don't agree with the comparison.  One obviously needs to avoid fatal
collisions when extending the spec, and has to consider prior art.

But ideally not implemented  or fenced optional features A should have no
impact to implemented optional or not optional features B -- unless the
features are actually interdependent, but then the spec would prohibit
the combo of having B but not A. And IMHO exactly this would have been
the advantage of fixed-assigned numbers: you may not care if the other
queueues exist or not. 

Also like cloud-hypervisor has decided that they are going only to
support VIRTIO_BALLOON_F_REPORTING some weird OS could in theory
decide that they only care about VIRTIO_BALLOON_F_REPORTING. In that
setting having to look at VIRTIO_BALLOON_F_STATS_VQ and 
VIRTIO_BALLOON_F_FREE_PAGE_HINT are offered is weird. But that is all water
under the bridge. We have to respect what is out there in the field.

> 
> Not perfect, but AFAIKS, not horrible.

It is like it is. QEMU does queue exist if the corresponding feature
is offered by the device, and that is what we have to live with.

Yes, I agree we should make the spec reflect reality!

> 
> (as Linux supports all these features, it's easy. A driver that only 
> supports some features has to calculate the queue index manually based 
> on the offered features)

As I've tried to explain above, not implementing/accepting optional
features and then implementing/accepting a newer feature is problematic
with the current code. Supporting some features would work only as
supporting all features up to X.

Regards,
Halil

