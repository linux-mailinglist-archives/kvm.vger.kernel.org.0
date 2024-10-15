Return-Path: <kvm+bounces-28842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 016EF99E008
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 09:58:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 76BBA1F23671
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 07:58:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82FEB1D9580;
	Tue, 15 Oct 2024 07:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Un5fbx4j"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E521CF7DD;
	Tue, 15 Oct 2024 07:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728979071; cv=none; b=iGpfysoO500WHqpjDZkIbshekmezoLyXEUWikeIBgq+ZawqrfT8dNGkjhqy+sOY4ENp3UG7gjYrcniQCxwEBlvYW9tSS9jLOctidvoB7x1c29zg5pQDBiQRhr5u7Deihoec3HkShf9RAYloqhGwXfqb8fRQcYPeKpI1ZJBQ62YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728979071; c=relaxed/simple;
	bh=LysHzPd7dlLah+lHs5TKm6/+zie9DVyHTUp7iGUpusc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ig0IuKg6r0v59gnhvi1MSqEkXWVOSn6wb0AcXhA7qMofXYrb0zknVLhU0CCjE4rMXMCrAZhYUcicE5SiFD3FY6buN5w+1g2hsbSlDfe/rXquuLj2TfsEBXmo+x1JwbiCJmBV2Pu00T4F4+sCd9f5RyAPs04kf8kIwUylrXlc7Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Un5fbx4j; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49F6Pkxu026413;
	Tue, 15 Oct 2024 07:57:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=QSrseP
	fkB5K2VV335DeClzFbTBNk++ahYm8ulSAy/iQ=; b=Un5fbx4jaUVIRMkcttwIy/
	aUUf01mo/c3G3RVrKcUEQZbc+uCc/zUSXz2WveTmZSAzBlUy+BtQVLgqONH4pttO
	fFQQ3TlIRmKgr4L91BKyuFfRyXR0/wDZVfTG7BQy9rc7GWJDnEKfuXz02uk6IL0p
	G+0J9l4AMeiBh71UBzEf2RvaUsT/cW28vx9eE4T1lkdmPBEu6FoYYZ0krjrPv4Wb
	+IL17qNlZYQfgRHdjn7JBTKKrE2rQuEAOUwq8j8DmQuDth8AlpHB7OJT5CPSkgEj
	NSe4EAQS/kQb8Lb4Sh8ntlNAmJi7dnx9mkhvtyCguImE4ann5vj0knOOMQnyRjFQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429k3xrdss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 07:57:42 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49F7ugM0021951;
	Tue, 15 Oct 2024 07:57:41 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429k3xrdsk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 07:57:41 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49F5eTLT005906;
	Tue, 15 Oct 2024 07:57:40 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 428650t844-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 07:57:40 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49F7vbri32833968
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 07:57:37 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 06C7620040;
	Tue, 15 Oct 2024 07:57:37 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 73CE320049;
	Tue, 15 Oct 2024 07:57:36 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 15 Oct 2024 07:57:36 +0000 (GMT)
Date: Tue, 15 Oct 2024 09:57:35 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux.dev, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas
 Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang
 <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio
 =?UTF-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Andrew Morton
 <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2 0/7] virtio-mem: s390 support
Message-ID: <20241015095735.189a93a9@p-imbrenda.boeblingen.de.ibm.com>
In-Reply-To: <20241014185659.10447-H-hca@linux.ibm.com>
References: <20241014144622.876731-1-david@redhat.com>
	<20241014185659.10447-H-hca@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Du4l9sP7TVUAjH_iYt432adQvi2pGWuw
X-Proofpoint-ORIG-GUID: uFXJhMFRxlEgNTc8MZnarzacqCG1ep_i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 adultscore=0 clxscore=1011 priorityscore=1501 phishscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2410150052

On Mon, 14 Oct 2024 20:56:59 +0200
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Mon, Oct 14, 2024 at 04:46:12PM +0200, David Hildenbrand wrote:
> > Let's finally add s390 support for virtio-mem; my last RFC was sent
> > 4 years ago, and a lot changed in the meantime.
> > 
> > The latest QEMU series is available at [1], which contains some more
> > details and a usage example on s390 (last patch).
> > 
> > There is not too much in here: The biggest part is querying a new diag(500)
> > STORAGE_LIMIT hypercall to obtain the proper "max_physmem_end".
> > 
> > The last two patches are not strictly required but certainly nice-to-have.
> > 
> > Note that -- in contrast to standby memory -- virtio-mem memory must be
> > configured to be automatically onlined as soon as hotplugged. The easiest
> > approach is using the "memhp_default_state=" kernel parameter or by using
> > proper udev rules. More details can be found at [2].
> > 
> > I have reviving+upstreaming a systemd service to handle configuring
> > that on my todo list, but for some reason I keep getting distracted ...
> > 
> > I tested various things, including:
> >  * Various memory hotplug/hotunplug combinations
> >  * Device hotplug/hotunplug
> >  * /proc/iomem output
> >  * reboot
> >  * kexec
> >  * kdump: make sure we don't hotplug memory
> > 
> > One remaining work item is kdump support for virtio-mem memory. This will
> > be sent out separately once initial support landed.  
> 
> Besides the open kdump question, which I think is quite important, how
> is this supposed to go upstream?
> 
> This could go via s390, however in any case this needs reviews and/or
> Acks from kvm folks.

we're working on it :)

