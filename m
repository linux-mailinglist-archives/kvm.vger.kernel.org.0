Return-Path: <kvm+bounces-19579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E84BD907391
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 15:25:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA7361C248F8
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 13:25:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C73701494A8;
	Thu, 13 Jun 2024 13:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ku+rEo3x"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FFA148844;
	Thu, 13 Jun 2024 13:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718284890; cv=none; b=d5QuYNSj5wvwMgl2FcHxuvrj69ZuZiOGMLElqMDeI2fKJAlMsEF8QjzDz/vU1cDNeJuOlMaqdPQZH0CoLHra9NQYoeWab3cc+vcGeqvQ3nq2IZqa9nCOZHNOXo7a55kbtFmrF5vHc1dG4LZvAz1/+RLLal2zNUutm8NrhGGUr+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718284890; c=relaxed/simple;
	bh=RK8WKQVYlTt4bXheXEUU0mVVWYcV4rc4D1nRpPUmE6U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lhrGR53vab6YjSAKF/rAs/2B3gbhB+94N8e1JlRcoYAEDmvhTxe+sKPMknlKsk0iBkLEl1DPnVvy1zS/H0khhhFknj+9Y3iqmUa7Ne4J8XbOOSnp6hZqgAbl6Ofsuw5m4rqbE8DeFVNW8AfGcU7LpoPjElD0+TGFfTz8C2QzA3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ku+rEo3x; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45DBHsqu010674;
	Thu, 13 Jun 2024 13:21:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	b+wlSXuMo8/DelJGsnFcywewsSR5WyB3cG1gH5c6b5Q=; b=ku+rEo3xv52IqgJB
	kyxONxQ+6z2MBmpCRikKIQGbISg5odvLZracZs5U68GjG2aMlWJCurEYh3S7C+MO
	nk6r+ir3rRnGJ/rcSvY+zPDSOi3hC6jStrMSP1JWHl1g+l4yRHvjGZ2ZjelE4G2l
	ghj/G/C8ckrXBkgordL3pTtgwSXry0PeiZ5bpSMgmsRjmHTV8m8K2HuhCXsk4QZR
	o79IQYWyvf9OHs7446c8VUOiA0B3CvVtQ4uSRDRnPqrvrJg/jJsL1VakwsFHmPUr
	jF4uEQtOJNTr5834LrLfmLtBQ5E4mdoOaWsrl1CbzhRD1VWhaGws/xgNVPauAPJL
	c4DQgQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yqu3c93y9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Jun 2024 13:21:25 +0000 (GMT)
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45DDLOcS019176;
	Thu, 13 Jun 2024 13:21:24 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yqu3c93y7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Jun 2024 13:21:24 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45DBZncs003930;
	Thu, 13 Jun 2024 13:21:24 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yn2mq7rgc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Jun 2024 13:21:24 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45DDLI4o20906564
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Jun 2024 13:21:20 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 200542004B;
	Thu, 13 Jun 2024 13:21:18 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4D44120043;
	Thu, 13 Jun 2024 13:21:17 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.171.55.240])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 13 Jun 2024 13:21:17 +0000 (GMT)
Date: Thu, 13 Jun 2024 15:21:15 +0200
From: Halil Pasic <pasic@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>, Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Boqiao Fu
 <bfu@redhat.com>,
        Sebastian Mitterle <smitterl@redhat.com>,
        Halil Pasic
 <pasic@linux.ibm.com>
Subject: Re: [PATCH 1/1] s390/virtio_ccw: fix config change notifications
Message-ID: <20240613152115.48b00798.pasic@linux.ibm.com>
In-Reply-To: <6086ef5e-48e7-40f3-b0a7-ff67b20aeae3@redhat.com>
References: <20240611214716.1002781-1-pasic@linux.ibm.com>
	<6086ef5e-48e7-40f3-b0a7-ff67b20aeae3@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HHBRDu5sTnlRr0CFKAZ02W7k5mRoSl6s
X-Proofpoint-GUID: uW43c1IDzMuH9x7ccVkdE9pjVaBdMpvu
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_04,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxscore=0 priorityscore=1501 suspectscore=0 spamscore=0 mlxlogscore=614
 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2405170001
 definitions=main-2406130090

On Wed, 12 Jun 2024 16:04:15 +0200
Thomas Huth <thuth@redhat.com> wrote:

> On 11/06/2024 23.47, Halil Pasic wrote:
> > Commit e3e9bda38e6d ("s390/virtio_ccw: use DMA handle from DMA API")
> > broke configuration change notifications for virtio-ccw by putting the
> > DMA address of *indicatorp directly into ccw->cda disregarding the fact
> > that if !!(vcdev->is_thinint) then the function
> > virtio_ccw_register_adapter_ind() will overwrite that ccw->cda value
> > with the address of the virtio_thinint_area so it can actually set up
> > the adapter interrupts via CCW_CMD_SET_IND_ADAPTER.  Thus we end up
> > pointing to the wrong object for both CCW_CMD_SET_IND if setting up the
> > adapter interrupts fails, and for CCW_CMD_SET_CONF_IND regardless
> > whether it succeeds or fails.
> > 
> > To fix this, let us save away the dma address of *indicatorp in a local
> > variable, and copy it to ccw->cda after the "vcdev->is_thinint" branch.
> > 
> > Reported-by: Boqiao Fu <bfu@redhat.com>
> > Reported-by: Sebastian Mitterle <smitterl@redhat.com>
> > Fixes: e3e9bda38e6d ("s390/virtio_ccw: use DMA handle from DMA API")
> > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > ---
> > I know that checkpatch.pl complains about a missing 'Closes' tag.
> > Unfortunately I don't have an appropriate URL at hand. @Sebastian,
> > @Boqiao: do you have any suggetions?  
> 
> Closes: https://issues.redhat.com/browse/RHEL-39983
> ?

Yep! That is a public bug tracker bug. Qualifies!
@Vasily: Can you guys pick hat one up when picking the patch?

> 
> Anyway, I've tested the patch and it indeed fixes the problem with 
> virtio-balloon and the link state for me:
> 
> Tested-by: Thomas Huth <thuth@redhat.com>
> 

Thanks!

