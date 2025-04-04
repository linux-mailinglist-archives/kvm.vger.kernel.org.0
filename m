Return-Path: <kvm+bounces-42647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF68EA7BC4E
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 14:08:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9C753BC01D
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 12:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99F991E0083;
	Fri,  4 Apr 2025 12:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FliFonRz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBC413AA2D;
	Fri,  4 Apr 2025 12:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743768352; cv=none; b=iSAiyw9oE6kozOIgkt87EV1r7ENs0JD8LJG2LuR4LLf3Wzy10i1wBvd/ZCWI0z5rgTzSQ2+PQ1aTHCyXyRE6ZHjdQQ8O3HYM2TwMfC3bF4+lDdC7VqilFGm8vadtJHZR7yZAO5k4fPSKFdBswlfWUAfVaSgyjKt6wzW1VAZdP6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743768352; c=relaxed/simple;
	bh=CKICFswTagr4M5w0rTnDXDPxJT/HGpOKJpeTFfAm058=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SDDAQC07MEpkgm6PDDc7go29xj6su4h0vJVhQnTzdQL0aUgUQzjXTVpt8hN/LHhKAFGHIDrk2r7cmUwpsGNL4u1cAr7Hh9UIStTEpfXPJ6VpouJ7xIYf55QModGMC/5f8PN4XV+q71KNuoEKTmY3XizH8fr1RssYYGIBDvzo93k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FliFonRz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5341iPpW012823;
	Fri, 4 Apr 2025 12:05:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=gdRE9A
	feY0sv/9P4CQuo5UaCAIb69zipdGKQZI+5fZQ=; b=FliFonRzNX0UDeCjhbCu1p
	5Dg/h9QhYusvGa7f9JSYYyC7v0kWvXRov1/e5fAqSavFeKIbb9KHrIWhnqy5iksT
	D1V24AxjzCJoy3YsPUe3b4Ntmd3/znQu/SeFRI4H1bDCLAV2l0z2eW84/XidPWNq
	8EdcQh/fhjCHrz7vi9AUhFzJ/IQzY/D7hZnRgn0hTRqerXQpaMUeJpXEA4G6P0+/
	jC2E0DvuNmmEjcubOLT5xcA1Hpme36eP0jKMSrOs9o7cOELwvX6COV8Nn9lHwWJm
	FL9VF4/LrhAIUHUcA3gABVoh3a5g25bchG4GeHI9UChXoEJ9irqh01RbJQyermRg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45t2qbu3d9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Apr 2025 12:05:44 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 534B8QAV001877;
	Fri, 4 Apr 2025 12:05:44 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45t2ch2v78-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Apr 2025 12:05:44 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 534C5dwN55116130
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 4 Apr 2025 12:05:39 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 91BD82004E;
	Fri,  4 Apr 2025 12:05:39 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1316020040;
	Fri,  4 Apr 2025 12:05:39 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.152.224.212])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  4 Apr 2025 12:05:39 +0000 (GMT)
Date: Fri, 4 Apr 2025 14:05:37 +0200
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
Message-ID: <20250404140537.54c1e464.pasic@linux.ibm.com>
In-Reply-To: <20250404013208-mutt-send-email-mst@kernel.org>
References: <20250402203621.940090-1-david@redhat.com>
	<20250403161836.7fe9fea5.pasic@linux.ibm.com>
	<20250403103127-mutt-send-email-mst@kernel.org>
	<20250404060204.04db301d.pasic@linux.ibm.com>
	<20250404013208-mutt-send-email-mst@kernel.org>
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
X-Proofpoint-ORIG-GUID: E7GPCDF2y4xfi5bYTJ2LPr4e7-D0TdM6
X-Proofpoint-GUID: E7GPCDF2y4xfi5bYTJ2LPr4e7-D0TdM6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-04_04,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 adultscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=729
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504040079

On Fri, 4 Apr 2025 01:33:28 -0400
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> > 
> > I think, a consequence of this design is that all queues need to be
> > created and allocated at initialization time.  
> 
> Why? after feature negotiation.

What I mean is, with this change having queues that exist but are not
set up before the device becomes operational is not viable any more.

Let me use the virtio-net example again. I assume by the current spec
it would be OK to have max_virtqueue_pairs quite big e.g. 64, just in
case the guest ends up having many vCPUs hotplugged. But start out with
2 vcpus, 2 queue pairs and initially doing VIRTIO_NET_CTRL_MQ_VQ_PAIRS_SET with 2.

And then grow the guest to 8 vcpus, 'discover' virtqueues
2(I-1) receiveqI, 2(I-1)+1 transmitqI for 2 < I < 9 (I is a natural number)
and do another VIRTIO_NET_CTRL_MQ_VQ_PAIRS_SET with 8.

Please notice that the controlq would sit at index 128 (64*2) all along. That
is in the old world. In the new world we don't do holes, so we need to
allocate all the virtqueues up to controlq up-front. To avoid having
holes. Or any queue-pairs that are discoverd after the initial vq discovery
would need to have an index larger than controlq has.

Regards,
Halil

