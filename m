Return-Path: <kvm+bounces-19634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 53835907E58
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 23:51:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A5525B211AE
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 21:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E16F14B091;
	Thu, 13 Jun 2024 21:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ahtnjbfp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D08E5A4FD;
	Thu, 13 Jun 2024 21:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718315449; cv=none; b=NujhTdHsm0fJKRTdPpULNJ1hrlBtJOcvYbPFwEf5gcaZQhhFrhZkfW0EfdYmpHqnaowgMn5oYzx/27qRXERGcnHcU8EkWjqYN/0sWEpjAfwE7m/XZWibh4IFw/YT0fFg2hhTEmvCZ5FYrgz0CrJTEH1CDi+jbcUYQ3hMwBAcA8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718315449; c=relaxed/simple;
	bh=E1LZ2qD4h47Nm0fqTgahufLnfYId7G2BDN4j2DBKUCk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Y6chLNkbTkTC0BEKwlxEavS7GIuMrDqzUmw5Ec9KYihUuduoRQRLXT6EGdfsVpjDK8oJTF5ulxRr0bONlEmGIVZWq718KvDBS4xiTdd8mV1RXS4TOZ6pjQnVpdgD+YqsHOQRcm9iKJpJHqXEOdlhYiAM36ppxYZZbp2d5EiPCYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ahtnjbfp; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45DLlh9b031385;
	Thu, 13 Jun 2024 21:50:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:mime-version; s=pp1; bh=XfZH3QdHnUhyEF5FH3erh0hNNk8
	Aq0lyphP1+FusXOQ=; b=AhtnjbfpjiJr5bCvMnSzcUf8TyNL9iGvyW019pquIcV
	5h5PwSosD+VKRTVPhuC4Al2vgT+BmchWoJ/ySStw/IDgz8THzr4UspieTGYvViVC
	ScNoLnms23vLDeh6JiDWAq18fZDK08aVd3Aml3pE0D2De6V4lE9ASxfmP3SXz1bB
	ZN577x3kGLyq5bAhBd6dLLEq4O25S0fEMGxqlQRJdAAiJMCIhP1xZkChx/nJO0A2
	kVudq5s6/jGHe+PlzlJ/L2NIVd5Dx4xd28mh5/m2zUDemIb3vvVjN6Kmo2/7Be/s
	S+WWofgE77M6VwD4nisZ8UoxVn6ZeODTrqwZNUwON8w==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yr76mg9hh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Jun 2024 21:50:45 +0000 (GMT)
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45DLojbd002840;
	Thu, 13 Jun 2024 21:50:45 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yr76mg9hf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Jun 2024 21:50:45 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45DKZtQm027243;
	Thu, 13 Jun 2024 21:50:44 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yn211c1r2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Jun 2024 21:50:44 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45DLocP956688914
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Jun 2024 21:50:40 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9CF8220040;
	Thu, 13 Jun 2024 21:50:38 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 070F720043;
	Thu, 13 Jun 2024 21:50:38 +0000 (GMT)
Received: from localhost (unknown [9.171.17.6])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 13 Jun 2024 21:50:37 +0000 (GMT)
Date: Thu, 13 Jun 2024 23:50:36 +0200
From: Vasily Gorbik <gor@linux.ibm.com>
To: Halil Pasic <pasic@linux.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Boqiao Fu <bfu@redhat.com>,
        Sebastian Mitterle <smitterl@redhat.com>
Subject: Re: [PATCH 1/1] s390/virtio_ccw: fix config change notifications
Message-ID: <your-ad-here.call-01718315436-ext-6568@work.hours>
References: <20240611214716.1002781-1-pasic@linux.ibm.com>
 <6086ef5e-48e7-40f3-b0a7-ff67b20aeae3@redhat.com>
 <20240613152115.48b00798.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240613152115.48b00798.pasic@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Zh5pS27zY4hCl2nM5Z-JIj_yqJcTPm8n
X-Proofpoint-GUID: ISNNOKrlGBlJTnIO7-XUbGs6B1Of3jyG
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_13,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=447 bulkscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 adultscore=0 clxscore=1011 phishscore=0
 spamscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2405170001 definitions=main-2406130154

On Thu, Jun 13, 2024 at 03:21:15PM +0200, Halil Pasic wrote:
> On Wed, 12 Jun 2024 16:04:15 +0200
> Thomas Huth <thuth@redhat.com> wrote:
> 
> > On 11/06/2024 23.47, Halil Pasic wrote:
> > > Commit e3e9bda38e6d ("s390/virtio_ccw: use DMA handle from DMA API")
> > > broke configuration change notifications for virtio-ccw by putting the
> > > DMA address of *indicatorp directly into ccw->cda disregarding the fact
> > > that if !!(vcdev->is_thinint) then the function
> > > virtio_ccw_register_adapter_ind() will overwrite that ccw->cda value
> > > with the address of the virtio_thinint_area so it can actually set up
> > > the adapter interrupts via CCW_CMD_SET_IND_ADAPTER.  Thus we end up
> > > pointing to the wrong object for both CCW_CMD_SET_IND if setting up the
> > > adapter interrupts fails, and for CCW_CMD_SET_CONF_IND regardless
> > > whether it succeeds or fails.
> > > 
> > > To fix this, let us save away the dma address of *indicatorp in a local
> > > variable, and copy it to ccw->cda after the "vcdev->is_thinint" branch.
> > > 
> > > Reported-by: Boqiao Fu <bfu@redhat.com>
> > > Reported-by: Sebastian Mitterle <smitterl@redhat.com>
> > > Fixes: e3e9bda38e6d ("s390/virtio_ccw: use DMA handle from DMA API")
> > > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > > ---
> > > I know that checkpatch.pl complains about a missing 'Closes' tag.
> > > Unfortunately I don't have an appropriate URL at hand. @Sebastian,
> > > @Boqiao: do you have any suggetions?  
> > 
> > Closes: https://issues.redhat.com/browse/RHEL-39983
> > ?
> 
> Yep! That is a public bug tracker bug. Qualifies!
> @Vasily: Can you guys pick hat one up when picking the patch?

Sure, applied. Thanks!

