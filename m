Return-Path: <kvm+bounces-35686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F368BA14245
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 20:30:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56B861889FF1
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 19:30:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17D05232440;
	Thu, 16 Jan 2025 19:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OL7EzCsV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95DE1DE894;
	Thu, 16 Jan 2025 19:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737055846; cv=none; b=QlhsJAjox4W6zNebXiwNRmeId59nBHltzGSN1Poq/gYwPF4oPzaPqXM9GI2hZSnn/BlGxDKEpYvUqJTm/2zL1pG7oMqWfGXYqB7uXFF02mEpex4reR2Cqoc1dmPngrrPBNjFEA7uXzA6KEFvLJk81zQOoKy6qjg+YP/2dOytuNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737055846; c=relaxed/simple;
	bh=HTuq5eEdre+ITQL67WPcgqX4wFo1mxG2/2bN6Y5GRxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Baf5OevuFSzHYSMxK/m4OqVg+DmdF/aIQwLk6pgDRz90QHEMhJaYw8btqVyaTG0AiNqYirgAcq4YkM7lhrJmFY0BUOOI85vVHCOchzjm1XmRbtXk6V3nGlgwxYyu94hWUYqyCHfVbtXetl/1KXLpR9qTCLJJdxjSp8u+vAhtN2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OL7EzCsV; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50GB7YbR022292;
	Thu, 16 Jan 2025 19:30:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Ew+Qbd
	DGS38Bla/c7xGNNflFzvGbXgwOXzMlGunGIEs=; b=OL7EzCsVAVLo9IsX3AbUJu
	p1Ij/i8CSR6Zj2wCggJwYmVrI1SFF9s2PkdueQ3WS6PQfx/lzALj08rTem5chVf4
	7k9Z1KcrifM9FlxxH7mOrMeRCMfh59idJz+GVNJtXbwzJRb09UeRt30Ww5RFGavH
	cWkgiy2bn4bIkljHwZGdWXoanomne39tp+TfBkrcd9PHRfE0LFHwUSIPYIasSpBC
	Ya4ryR3q45G9oLEJcIXJdRqsK3AqZQ68RwHdh1ctFArPPOP2WCJ8plFmJyHDSywA
	Zn4w+u+XQsUnBEG5h7Ph9Zcf8rVRiKIFZ7kNUL0Z5AZekerwU9nTvC1BsqYj/CyQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446pub52n9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 19:30:41 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50GIOLZQ000875;
	Thu, 16 Jan 2025 19:30:40 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44456k75ry-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 19:30:40 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50GJUbuC20971900
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 19:30:37 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4822B20043;
	Thu, 16 Jan 2025 19:30:37 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 838F520040;
	Thu, 16 Jan 2025 19:30:36 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.171.92.116])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 16 Jan 2025 19:30:36 +0000 (GMT)
Date: Thu, 16 Jan 2025 20:30:34 +0100
From: Halil Pasic <pasic@linux.ibm.com>
To: Anthony Krowiak <akrowiak@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Rorie Reyes
 <rreyes@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, hca@linux.ibm.com,
        borntraeger@de.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        jjherne@linux.ibm.com, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v1] s390/vfio-ap: Signal eventfd when guest AP
 configuration is changed
Message-ID: <20250116203034.2ec75969.pasic@linux.ibm.com>
In-Reply-To: <89a1a029-172a-407a-aeb4-0b6228da07e5@linux.ibm.com>
References: <20250107183645.90082-1-rreyes@linux.ibm.com>
	<20250114150540.64405f27.alex.williamson@redhat.com>
	<5d6402ce-38bd-4632-927e-2551fdd01dbe@linux.ibm.com>
	<20250116011746.20cf941c.pasic@linux.ibm.com>
	<89a1a029-172a-407a-aeb4-0b6228da07e5@linux.ibm.com>
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
X-Proofpoint-GUID: a5NX6rGsGsaR8NasszSHY1ItWtELZ6QX
X-Proofpoint-ORIG-GUID: a5NX6rGsGsaR8NasszSHY1ItWtELZ6QX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_08,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=866 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501160144

On Thu, 16 Jan 2025 10:38:41 -0500
Anthony Krowiak <akrowiak@linux.ibm.com> wrote:

> > Alex, does the above answer your question on what guards against UAF (the
> > short answer is: matrix_dev->mdevs_lock)?  
> 
> I agree that the matrix_dev->mdevs_lock does prevent changes to
> matrix_mdev->cfg_chg_trigger while it is being accessed by the
> vfio_ap device driver. My confusion arises from my interpretation of
> Alex's question; it seemed to me that he was talking its use outside
> of the vfio_ap driver and how to guard against that.

BTW the key for understanding how we are protected form something
like userspace closing he eventfd is that eventfd_ctx_fdget()
takes a reference to the internal eventfd context,  which makes
sure userspace can not shoot us in the foot and the context
remains to be safe to use until we have done our put. Generally
userspace is responsible for not shooting itself in the foot,
so how QEMU uses its end is mostly QEMUs problem in my understanding.

Regards,
Halil

