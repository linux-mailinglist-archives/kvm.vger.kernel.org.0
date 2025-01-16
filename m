Return-Path: <kvm+bounces-35685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84E4BA1422A
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 20:19:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 080AE3A97B6
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 19:19:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFF5A22F384;
	Thu, 16 Jan 2025 19:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VHU0hWTv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0BD23F296;
	Thu, 16 Jan 2025 19:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737055153; cv=none; b=GcBPUF28ggmnMMN1kAMgT3B1W5+h7Zk0nRMsgvl/7uG9dw/tCReT2bQWGwhzNCkXg6Roj93Ne3UuJcdasO/OtxdjR/ZTxI1j0Nl381iurYbNZjRYMT4mD49CKImcImiu+1z4QGHwTcOwCk2rhAPjUpN9xFEB+4yWm9WIwLZOrUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737055153; c=relaxed/simple;
	bh=ULFtzri1znEUXQlaetgij/v5Itjwzky80Js1UZCGxq4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fj/aeqTTOaBbmUExrvuX79ICeYlZ5El/znXwpDtbiBfg2tT8QYuL5RTdY84UgijVcn7QMNj635EL43IUQDgyb7bb9cVUb8be/033PuHVi4Wq28EE2CGkTawyhTg75idPIx8pm30gPRSYl1trC/UPy/4bQNxWaaa+4edHE3k86lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VHU0hWTv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50GE5vFE007900;
	Thu, 16 Jan 2025 19:19:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=DLc9/y
	VETKXKMGWKbN8jZGmlMJsKm6sSziimpYr1RIo=; b=VHU0hWTvirxjW+D4LaMY2D
	gjKlCoh2hF4fB2gbBGajuTc7Z5t8C2A3GNg4NMpwUGZaUX7LppVEvMvVirZsUC8j
	bukgXhkcJAgtc0UqDGMqZFvfUcHcBuYJMtG36I+VVKyTM796NLNABwn5JqZas5yK
	K3DLS2UqId9Sc7CvK6He2+RcLirpU4Wjoiak7KnWI1cKOdyAVaZKu/BJzs2FidWn
	F+agMsn1QJBtRYGnURATrRbpWij4xlz9HixomYVz//5gunm9DQiy6whJpTqxRoMI
	RG4ORPba/ERdAJA4AipU36Iv2LT6OEzU64/HyOV6o9vGcT85lLzADPHfpZgQQEvw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446tkcmcdn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 19:19:05 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50GIG9O6001108;
	Thu, 16 Jan 2025 19:19:04 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44456k747e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 19:19:04 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50GJJ1BE62194136
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 19:19:01 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 323EA2004F;
	Thu, 16 Jan 2025 19:19:01 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 75AF22004B;
	Thu, 16 Jan 2025 19:19:00 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.171.92.116])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 16 Jan 2025 19:19:00 +0000 (GMT)
Date: Thu, 16 Jan 2025 20:18:58 +0100
From: Halil Pasic <pasic@linux.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Anthony Krowiak <akrowiak@linux.ibm.com>,
        Rorie Reyes
 <rreyes@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, hca@linux.ibm.com,
        borntraeger@de.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        jjherne@linux.ibm.com, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v1] s390/vfio-ap: Signal eventfd when guest AP
 configuration is changed
Message-ID: <20250116201858.1a5f7e7f.pasic@linux.ibm.com>
In-Reply-To: <20250116115228.10eeb510.alex.williamson@redhat.com>
References: <20250107183645.90082-1-rreyes@linux.ibm.com>
	<20250114150540.64405f27.alex.williamson@redhat.com>
	<5d6402ce-38bd-4632-927e-2551fdd01dbe@linux.ibm.com>
	<20250116011746.20cf941c.pasic@linux.ibm.com>
	<89a1a029-172a-407a-aeb4-0b6228da07e5@linux.ibm.com>
	<20250116115228.10eeb510.alex.williamson@redhat.com>
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
X-Proofpoint-ORIG-GUID: O5RdBVzvjBFd3LKH6tBumLQzK6GhfpTO
X-Proofpoint-GUID: O5RdBVzvjBFd3LKH6tBumLQzK6GhfpTO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_08,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2411120000 definitions=main-2501160141

On Thu, 16 Jan 2025 11:52:28 -0500
Alex Williamson <alex.williamson@redhat.com> wrote:

> > > Alex, does the above answer your question on what guards against UAF (the
> > > short answer is: matrix_dev->mdevs_lock)?    
> 
> Yes, that answers my question, thanks for untangling it.  We might
> consider a lockdep_assert_held() in the new
> signal_guest_ap_cfg_changed() since it does get called from a variety
> of paths and we need that lock to prevent the UAF.

Yes I second that! I was thinking about it myself yesterday. And there
are also a couple of other functions that expect to be called with
certain locks held. I would love to see lockdep_assert_held() there
as well.

Since I went through that code last night I could spin a patch that
catches some of these at least. But if I don't within two weeks, I
won't be grumpy if somebody else picks that up.

Regards,
Halil

