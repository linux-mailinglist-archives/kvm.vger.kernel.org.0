Return-Path: <kvm+bounces-43158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36C78A85DB2
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 14:51:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B39EF4C3FEE
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 12:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6E992BD5BC;
	Fri, 11 Apr 2025 12:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SICH88CT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621DF29CB42;
	Fri, 11 Apr 2025 12:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744375378; cv=none; b=KZPlx8MVqJds9kTfB55v39S4lzbmfPVMuXuGutsgaCnGR53cQZRA0jmOZo4ENIyi+reWQoOVfdd7WTNN9aYE75/vjJSxZW1F3Z9GtN1RrK/5zN5a6m5ZOBe3antq4/tCUU5SyxCYoK09aNbyHBAkwN/sDgEnmo3WvC4cPncn38c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744375378; c=relaxed/simple;
	bh=LRBlzSos3dhGHutKp01tSFMKt4Gbxl3XFGUSmAinjeU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q5yW1r+f9x7wiIg6xu9wHrd3Sfk5FN6Gq3e0ulJ2aO3Rlr3zbffpHQRJgJiF/dJSdExA3KJiZh0wHKLK0Q+eNYuJkHgTHh/MHuDab8Dov9/F47mCxoQ+4Pze1qKe5rGiJ2SO+J4nYvle4ZMOhtYesayt48ZnRF/GUybW4xxKzoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SICH88CT; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53B2GwTQ028860;
	Fri, 11 Apr 2025 12:42:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=wllDMLVyjUN526ZRNsd50HowPiyj1q
	cvrx5XL9ogpG0=; b=SICH88CT3h4e5JoHQhDhlysl8FFRCeiJoF4pIiDIj0HQtP
	goz4LQb6iBTxk0A/2clqpGP0NesX0has3UbYRMOctiK8oYWULcvxWmKB8Mr0snls
	vYmKQLxHRxkVMqGfR10cDTpw1YWMCbV/7Cv0M01Fuhrj942j9UI9AtBWcGBJolxz
	Ikp1up47HDPeSYsgBo9cm9OfyX/M85K40LbAwLwlMbIIdZkGZzjM/b1HddImP4Jb
	P1/DCW9JmB/dBfwEX9UKBOavUnI+8CauzOb1FuJWNQnwIreLrvE9xQ5ayXNYHdUf
	yMTpC6wYa+/1Xc4Lw2j1RTULtDMULX8PGBi5ynjw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45xj5xmhh7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Apr 2025 12:42:49 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53BB57rE017826;
	Fri, 11 Apr 2025 12:42:48 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 45uh2m2su6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Apr 2025 12:42:48 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53BCgitX45613410
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Apr 2025 12:42:45 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CD35420043;
	Fri, 11 Apr 2025 12:42:44 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D7CD320040;
	Fri, 11 Apr 2025 12:42:43 +0000 (GMT)
Received: from osiris (unknown [9.171.65.230])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 11 Apr 2025 12:42:43 +0000 (GMT)
Date: Fri, 11 Apr 2025 14:42:42 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, Chandra Merla <cmerla@redhat.com>,
        Stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
Message-ID: <20250411124242.123863D16-hca@linux.ibm.com>
References: <20250402203621.940090-1-david@redhat.com>
 <065d46ba-83c1-473a-9cbe-d5388237d1ea@redhat.com>
 <a6f667b2-ef7d-4636-ba3c-cf4afe8ff6c3@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6f667b2-ef7d-4636-ba3c-cf4afe8ff6c3@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9om_QFYPDMLFrBloZCYPQNzLoFWKkiaT
X-Proofpoint-ORIG-GUID: 9om_QFYPDMLFrBloZCYPQNzLoFWKkiaT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-11_04,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 mlxlogscore=719 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2504110080

On Fri, Apr 11, 2025 at 01:11:55PM +0200, Christian Borntraeger wrote:
> Am 10.04.25 um 20:44 schrieb David Hildenbrand:
> [...]
> > > ---
> > 
> > So, given that
> > 
> > (a) people are actively running into this
> > (b) we'll have to backport this quite a lot
> > (c) the spec issue is not a s390x-only issue
> > (d) it's still unclear how to best deal with the spec issue
> > 
> > I suggest getting this fix here upstream asap. It will neither making sorting out the spec issue easier nor harder :)
> > 
> > I can spot it in the s390 fixes tree already.
> 
> Makes sense to me. MST, ok with you to send via s390 tree?

Well, it is already part of a pull request:
https://lore.kernel.org/r/20250411100301.123863C11-hca@linux.ibm.com/

...and contains all the Acks that were given in this thread.

