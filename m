Return-Path: <kvm+bounces-19955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4194490E85C
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 12:33:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E24591F21FC0
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 10:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 135A912FB0A;
	Wed, 19 Jun 2024 10:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VymZb0Dq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F2578C91;
	Wed, 19 Jun 2024 10:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718793189; cv=none; b=HDVr9OYqNI1E7bmUgi5VdhhpIQOi4WIfjG1rJwpKIEcFmZiA8L03nOi0bIZfYcc3yPmL66pAQaOSMCL63SswIUzCLZSeTKJpQV8LxhKqsLNYkO3zUKhidTg+pJ5pcBL0GHl619Manbn22P0eGTDOfAe1+I6uYnnvR/7sWbKWBfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718793189; c=relaxed/simple;
	bh=UrZRPJUMF85098sOggzaqUsbYYJWPI5tGohEdROwtpk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IL+8fzhTyhk+1M3i9GAB8tUgydpJeeCeXp/KogxBATxs6atPmkToYHgSDZeq9ywsK5mBVE6jLJX/khdfySLAl09nbwMdWj9/TV1hmSYQh6hJwgTTEgAC0xK6VbwIpBqGmwTlRLVqgFsbqoG0Q5Eoe7IADEOPmQPt8m6frFFb6Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VymZb0Dq; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45JATtdE016633;
	Wed, 19 Jun 2024 10:33:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	EmFnM2M6vINWkHXs613zLTG1TdJP9EUBcYSfppMV+yQ=; b=VymZb0DqgymUQD+t
	U9ygY+RCVEDplpFs+wg0VDyn4wboiGPTiY6QBI2pzeqjxv4+YWI6lhvSYonPyoIm
	b9+swAivHcFPir4Di+Bj5eHuNuq5XfP6Eb8/FL03YRZdpsvZ1enJSZc/A2/qLbJh
	4a3HUjsCFj9aeQl/RLQinT1sF1w3saZTZv9Wgbz0Rl7OAw2ubQizWFeVp97jpfOK
	df/szhLREn9JHiaJ5T3tCauzZnUd+K+4hQUouHAbU/YygksUz+oS8yxDdEEiE7m2
	RwUJCMyPsYz1jAVbP3WqdAdPsnVRP8dJeOEbVbMezZeqtv4/kWDOI26ZqqVzVtrK
	GjDMtw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yuwm6007g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jun 2024 10:33:04 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45J8exqE011027;
	Wed, 19 Jun 2024 10:33:03 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yspsnb9gu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jun 2024 10:33:03 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45JAWvJn44695938
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Jun 2024 10:32:59 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 84D052004E;
	Wed, 19 Jun 2024 10:32:57 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 97F1020043;
	Wed, 19 Jun 2024 10:32:56 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.171.42.81])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 19 Jun 2024 10:32:56 +0000 (GMT)
Date: Wed, 19 Jun 2024 12:32:55 +0200
From: Halil Pasic <pasic@linux.ibm.com>
To: Eric Farman <farman@linux.ibm.com>
Cc: Vineeth Vijayan <vneethv@linux.ibm.com>,
        Jeff Johnson
 <quic_jjohnson@quicinc.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Matthew
 Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH] s390/cio: add missing MODULE_DESCRIPTION() macros
Message-ID: <20240619123255.4b1a6c6d.pasic@linux.ibm.com>
In-Reply-To: <afdde0842680698276df0856dd8b896dac692b56.camel@linux.ibm.com>
References: <20240615-md-s390-drivers-s390-cio-v1-1-8fc9584e8595@quicinc.com>
	<064eb313-2f38-479d-80bd-14777f7d3d62@linux.ibm.com>
	<afdde0842680698276df0856dd8b896dac692b56.camel@linux.ibm.com>
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
X-Proofpoint-GUID: kwRyS9oDx2UqRyENfPbHRtoLutxEkTs1
X-Proofpoint-ORIG-GUID: kwRyS9oDx2UqRyENfPbHRtoLutxEkTs1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-19_02,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 adultscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=992
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406190077

On Tue, 18 Jun 2024 16:11:33 -0400
Eric Farman <farman@linux.ibm.com> wrote:

> > > +MODULE_DESCRIPTION("VFIO based Physical Subchannel device
> > > driver");  
> > 
> > Halil/Mathew/Eric,
> > Could you please comment on this ?  
> 
> That's what is in the prologue, and is fine.

Eric can you explain it to me why is the attribute "physical" appropriate
here? I did a quick grep for "Physical Subchannel" only turned up hits
in vfio-ccw.

My best guess is that "physical" was somehow intended to mean the
opposite of "virtual". But actually it does not matter if our underlying
subchannel is emulated or not, at least AFAIU.

Regards,
Halil

