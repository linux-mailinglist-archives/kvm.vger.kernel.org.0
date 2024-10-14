Return-Path: <kvm+bounces-28803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D96999D6BE
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 20:48:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FC311C22B18
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 18:48:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EA3E1CACF3;
	Mon, 14 Oct 2024 18:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="In0ZR+59"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E33C83CDA;
	Mon, 14 Oct 2024 18:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728931720; cv=none; b=Xxj2De3h7me0vDSo0rGYxsfQT1pZez6VJbJhFbBuyP0ERcQGQxWR01ohM0C0pPjkVtVmJ1KgZ6suvt83qA3jD4PVG/6NMHbfjSEbbB4JP8OdE7uEtF4T6IwHCH40mm0/Rv1OdPZan3q5M1r/MEf5bhaFt6x5qyhxKmWSiRDfSVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728931720; c=relaxed/simple;
	bh=y9u96jcTsOYTUXHXWItfaOV9ukdvlpwU38+tlafA1Dw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bY+F8wFMCZ7aLyUVYz/tUYiPXsgZbDBp7eeUv3dUXYkfnHkgW9A/aQwi0m7QSrv+6gmjynh60waexT4sHQTv0s81P+o8sztBnZMu/baRdlpFSVvmOeI6D2kYs/LCpcVrPWqVZqmVT8stKp1/l16U0C/jaznEsJ85DMO+JGvNrRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=In0ZR+59; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49EIJiP5028228;
	Mon, 14 Oct 2024 18:48:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=y9u96jcTsOYTUXHXWItfaOV9ukd
	vlpwU38+tlafA1Dw=; b=In0ZR+59AzJO4xVMpVJgPv+FbyP80wFaXM/grtexUxU
	xN/3KCHETDO763NQBzLKgkMRJfRKns/cSVejLZ+GD1Ji5N7pICtaf8iVf6vdcRMO
	zUFHCk5jUza/zMNexi1dZnT24totLnmqoqm9cZZnMPZfbP6EnOB4TsP6G373qQN4
	QpQ+HLEOo2+tgZPBlZ6X7LoyTRgGegDe6PyVUdmxmFTDPKFexRINQrjZi8Gi8nSZ
	41rfipScPCUjJ0aJFvNjiqwb+rqZHVmylilgLxbdV1IEDjj0vK91FFr/CCUO7Vu2
	NUgFEf7vXjC0ZsMYGM7a5s5F0yklOAaxUHPzi6g9yuQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4298fsg3gn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 18:48:32 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49EImVPj021174;
	Mon, 14 Oct 2024 18:48:31 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4298fsg3gg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 18:48:31 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49EHgPje027432;
	Mon, 14 Oct 2024 18:48:30 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4283txg590-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 18:48:30 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49EImR0d54985154
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Oct 2024 18:48:27 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 215EA20043;
	Mon, 14 Oct 2024 18:48:27 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2820620040;
	Mon, 14 Oct 2024 18:48:26 +0000 (GMT)
Received: from osiris (unknown [9.171.66.174])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 14 Oct 2024 18:48:26 +0000 (GMT)
Date: Mon, 14 Oct 2024 20:48:24 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Mario Casquero <mcasquer@redhat.com>
Subject: Re: [PATCH v2 5/7] virtio-mem: s390 support
Message-ID: <20241014184824.10447-F-hca@linux.ibm.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-6-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014144622.876731-6-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uxrAbvVrvo_xSFv3iSYJ1lcmH8ghEeSX
X-Proofpoint-ORIG-GUID: s1Vm0XBS-RoBWitXsY0-xWCcYcWAwN3a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-14_12,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 adultscore=0
 mlxscore=0 malwarescore=0 phishscore=0 spamscore=0 mlxlogscore=270
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2409260000 definitions=main-2410140131

On Mon, Oct 14, 2024 at 04:46:17PM +0200, David Hildenbrand wrote:
> The special s390 kdump mode, whereby the 2nd kernel creates the ELF
> core header, won't currently dump virtio-mem memory. The virtio-mem
> driver has a special kdump mode, from where we can detect memory ranges
> to dump. Based on this, support for dumping virtio-mem memory can be
> added in the future fairly easily.

Hm.. who will add this support? This looks like a showstopper to me.
Who is supposed to debug crash dumps where memory parts are missing?

