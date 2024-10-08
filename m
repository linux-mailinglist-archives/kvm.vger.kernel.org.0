Return-Path: <kvm+bounces-28132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC4829947BB
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 13:52:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63C34B26958
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 11:52:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AD351DF96B;
	Tue,  8 Oct 2024 11:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="B3HrFDwd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CE0176FA7;
	Tue,  8 Oct 2024 11:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728388218; cv=none; b=L43l0CCoir4RqVAo40be5PdbQ4bvyRbd7L3ZTZGVBlSnDuIxHFbOwAtQylUY/svw1NhwVYUoGtRb32EJ9LuNeoXUcFl+xOkZCCFq+Nc6yWaWCViDzwam3tJZE8dN/8i56JFhYj2KeFDWNi6u3Y/Wf+jzFEQ5SVO7YeHYN40DgLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728388218; c=relaxed/simple;
	bh=bXOLVYsX/WP08jCi/ZnDwBulgCqnkfkpGIP3JkBkVNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DC67vYM/Brp1t7e+UDsLNptimj8N0LP3gSiiQTzY/BHXRBPjo5BDCgV7GlxI1iGgGts3cc5FcGICxyVozmXfcwRKomAMPprLzP/Kuc6gY0mIqykF859Fz1ZCRidOkPN40mWT7wmqSIsxoVJ+mB/iLphuZFIoA4K7GnVXf9ahIRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=B3HrFDwd; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 498AJcd4032601;
	Tue, 8 Oct 2024 11:50:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:mime-version; s=pp1; bh=sPQhgvelRG0K77jbWvixmaTlvuL
	6bVrJguWhLBuE/bo=; b=B3HrFDwdw0qtGeouTk2Bzir7hkZtMLnG7xgryTSpnHc
	HH3cAF+jdo+xZo1AtfqChL08kWFPhwo9VCBR49XVNozr7Y7LT40svws6Bz3tQuV9
	nQTIetyFsj3BLY2nQo/VFTSQSTMf8ZplcopMqnL9cTzjhEecEcW0t5zXE6wiemRs
	+JmMs6rqfMIlQWezcTfiDS9fh7YRBpWpRHWH3C2MRYqQ+rZ/lKf5FnwFAFGRGeIc
	vNuVin+CDm5w/T3Ls9vpM7o6bI2rh8UiCM83Ea4dPrZSA2K8yEqJ4FCbs1t7qFe5
	loz4Fj9RBLfk9mJSLMPQAwJGKEZL5rtJ/llCSHUZgiw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4252vpgdkt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Oct 2024 11:50:10 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 498Bo93o015899;
	Tue, 8 Oct 2024 11:50:09 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4252vpgdkj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Oct 2024 11:50:09 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4989x2iv022851;
	Tue, 8 Oct 2024 11:50:08 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 423h9juw8m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Oct 2024 11:50:08 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 498Bo54C49480108
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 8 Oct 2024 11:50:05 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0094A20043;
	Tue,  8 Oct 2024 11:50:05 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B8C8120040;
	Tue,  8 Oct 2024 11:50:04 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  8 Oct 2024 11:50:04 +0000 (GMT)
Date: Tue, 8 Oct 2024 13:50:03 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Halil Pasic <pasic@linux.ibm.com>
Cc: Cornelia Huck <cohuck@redhat.com>, Eric Farman <farman@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-s390@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: Re: [PATCH 1/1] s390/virtio_ccw: fix dma_parm pointer not set up
Message-ID: <20241008115003.7472-G-hca@linux.ibm.com>
References: <20241007201030.204028-1-pasic@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241007201030.204028-1-pasic@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lXuzBf918RgHmyYBbn9kgtgUNeYxgvnc
X-Proofpoint-GUID: rBXwCyasaV23gVF_2VnZKQ8z3XPyrKkS
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-08_10,2024-10-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 bulkscore=0 adultscore=0 mlxlogscore=859 suspectscore=0 clxscore=1011
 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2409260000 definitions=main-2410080072

On Mon, Oct 07, 2024 at 10:10:30PM +0200, Halil Pasic wrote:
> At least since commit 334304ac2bac ("dma-mapping: don't return errors
> from dma_set_max_seg_size") setting up device.dma_parms is basically
> mandated by the DMA API. As of now Channel (CCW) I/O in general does not
> utilize the DMA API, except for virtio. For virtio-ccw however the
> common virtio DMA infrastructure is such that most of the DMA stuff
> hinges on the virtio parent device, which is a CCW device.
> 
> So lets set up the dma_parms pointer for the CCW parent device and hope
> for the best!
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Fixes: 334304ac2bac ("dma-mapping: don't return errors from dma_set_max_seg_size")
> Reported-by: "Marc Hartmayer" <mhartmay@linux.ibm.com>
> Closes: https://bugzilla.linux.ibm.com/show_bug.cgi?id=209131
> Reviewed-by: Eric Farman <farman@linux.ibm.com>
> ---

Applied, thanks!

