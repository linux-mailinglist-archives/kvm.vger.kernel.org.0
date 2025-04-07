Return-Path: <kvm+bounces-42864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1010DA7E831
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 19:27:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DFE29188DA4B
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 17:27:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3923217679;
	Mon,  7 Apr 2025 17:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Z8HXjcw1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403F52054F5;
	Mon,  7 Apr 2025 17:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744046800; cv=none; b=iZiQCx27CmrWUx15wfFHzndUNsHhqhsOxUQc99nLF1I4EkdJcoNNz4JTR4bildxw7EZyXm+a5Vx1T+cM94SImigmijCOldOIA4hARV7QPVghjnp3m9c+uxVPzCia+umJjivudAd/6eYyCEWbNm/lx33xtMgBawYOIyNuj/CmXzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744046800; c=relaxed/simple;
	bh=pk8wyV+OnEy4qlOQmIX6tSX6iKR+8zSU/AHbe41bpII=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b694rrX/EOD8lJ+ClCX+DaNI4oWgP6D49wkLn0wHGOjxed88xcEot0Yke/uNXCsHL877KpndFJ5Uh+AObwGJL9l3LskxeeOui8qx01lHuOBb05Zx1X8YySKUW41dRekkkOsnjdxiSIxaqMeXBPOvHRGFfr66B7SYHLg1x6LM0dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Z8HXjcw1; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 537HBXnj005859;
	Mon, 7 Apr 2025 17:26:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=AsUA3f
	ycvbPxwQlbhLFJ7bYYQdsQ64Au0CYYS3yyPlw=; b=Z8HXjcw1Jr7e5FTybHWPsH
	Fb7CXoYtwpYRGAaseqm/UBE2TVezQhSLRuhSrPULXwYo0JekNS1RqOkwI5nG4fn8
	m43lF2ycomD+vTRKkdXToQP9VRq+Ej0+GNv52GMP88D+bTU3zbBCvaTxxa4C86ml
	BRGPhmjJFR0yDo8Fb6Vd3WMlMQFgAONMgWx2jf0GtSEF7lxFwWazLqmzSwIRfPNd
	zfDT1gx5SYjxljVnI/rN1t69nnz/89NYmR7fA4qdEWYJ6+lVPneiCQG4Ees4Hl2O
	ad4C8YE8hpl/kMjAwWRJepzjGqhce9SpaPHAOU2i22Y7gturX4mgQmK98NKVUNOg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45vjvxg26y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Apr 2025 17:26:32 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 537H6A5v024651;
	Mon, 7 Apr 2025 17:26:32 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 45ueut72vh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Apr 2025 17:26:31 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 537HQS3Y31261056
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 7 Apr 2025 17:26:28 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 603A820043;
	Mon,  7 Apr 2025 17:26:28 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E25020040;
	Mon,  7 Apr 2025 17:26:27 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.171.83.239])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon,  7 Apr 2025 17:26:27 +0000 (GMT)
Date: Mon, 7 Apr 2025 19:26:25 +0200
From: Halil Pasic <pasic@linux.ibm.com>
To: Cornelia Huck <cohuck@redhat.com>
Cc: David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin"
 <mst@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, Chandra Merla
 <cmerla@redhat.com>,
        Stable@vger.kernel.org, Thomas Huth
 <thuth@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
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
Message-ID: <20250407192625.196b1b34.pasic@linux.ibm.com>
In-Reply-To: <87h6309k42.fsf@redhat.com>
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
	<20250407151249.7fe1e418.pasic@linux.ibm.com>
	<9126bfbf-9461-4959-bd38-1d7bc36d7701@redhat.com>
	<87h6309k42.fsf@redhat.com>
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
X-Proofpoint-ORIG-GUID: OOmVvdMQTFN8i-SpEj-wsHj-ODU-d7pt
X-Proofpoint-GUID: OOmVvdMQTFN8i-SpEj-wsHj-ODU-d7pt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-07_04,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2504070118

On Mon, 07 Apr 2025 15:28:13 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> > Staring at the cross-vmm, including the adding+removing of features and 
> > queues that are not in the spec, I am wondering if (in a world with 
> > fixed virtqueues)
> >
> > 1) Feature bits must be reserved before used.
> >
> > 2) Queue indices must be reserved before used.
> >
> > It all smells like a problem similar to device IDs ...  
> 
> Indeed, we need a rule "reserve a feature bit/queue index before using
> it, even if you do not plan to spec it properly".

What definition of usage do you guys have in mind?  Would an RFC patch
constitute usage.

I think reserving/allocating an identifier of this type before relying on
it for anything remotely serious is very basic common sense.

Frankly I would go even further and advocate for the following rule: we
don't accept anything virtio into Linux unless it is reasonably/properly
spec-ed. My train of thought is following: if a virtio thing gains
traction with Linux it has a fair chance of becoming a de-facto standard.

Consider our thinking on this one. Despite the fact that what is spec-ed
is obviously nicer, we almost decided to change the spec to fit what is
implemented and fielded out there. And IMHO for good reason. For any
rule we come up with, I think one of the most crucial questions is, who
is going to enforce it if anybody. The Linux (and probably also QEMU)
virtio maintainers are in my opinion the most reasonable point of
enforcement. Another thing to consider. After the code is in and things
work, I speculate that the motivation for writing a proper spec may
wane. I hope we do strive for consistency between the spec and the
implementations we are talking about. Having and eye on the spec while
looking at and trying to understand the code suits my workflow better
at least than the other way around. And licensing-wise getting the spec
merged first is probably the better option. 

Regards,
Halil



